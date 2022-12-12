Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D66649A45
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiLLIo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiLLIoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:44:25 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A561E008
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 00:44:23 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NVwBk3hrxz15NLr;
        Mon, 12 Dec 2022 16:43:26 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 12 Dec
 2022 16:44:21 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <isdn@linux-pingi.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@resnulli.us>, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net v2 3/3] mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Mon, 12 Dec 2022 16:41:39 +0800
Message-ID: <20221212084139.3277913-4-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221212084139.3277913-1-yangyingliang@huawei.com>
References: <20221212084139.3277913-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not allowed to call kfree_skb() or consume_skb() from hardware
interrupt context or with hardware interrupts being disabled.

skb_queue_purge() is called under spin_lock_irqsave() in handle_dmsg()
and hfcm_l1callback(), kfree_skb() is called in them, to fix this, use
skb_queue_splice_init() to move the dch->squeue to a free queue, also
enqueue the tx_skb and rx_skb, at last calling __skb_queue_purge() to
free the SKBs afer unlock.

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..e840609c50eb 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3217,6 +3217,7 @@ static int
 hfcm_l1callback(struct dchannel *dch, u_int cmd)
 {
 	struct hfc_multi	*hc = dch->hw;
+	struct sk_buff_head	free_queue;
 	u_long	flags;
 
 	switch (cmd) {
@@ -3245,6 +3246,7 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 		l1_event(dch->l1, HW_POWERUP_IND);
 		break;
 	case HW_DEACT_REQ:
+		__skb_queue_head_init(&free_queue);
 		/* start deactivation */
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->ctype == HFC_TYPE_E1) {
@@ -3264,20 +3266,21 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 				plxsd_checksync(hc, 0);
 			}
 		}
-		skb_queue_purge(&dch->squeue);
+		skb_queue_splice_init(&dch->squeue, &free_queue);
 		if (dch->tx_skb) {
-			dev_kfree_skb(dch->tx_skb);
+			__skb_queue_tail(&free_queue, dch->tx_skb);
 			dch->tx_skb = NULL;
 		}
 		dch->tx_idx = 0;
 		if (dch->rx_skb) {
-			dev_kfree_skb(dch->rx_skb);
+			__skb_queue_tail(&free_queue, dch->rx_skb);
 			dch->rx_skb = NULL;
 		}
 		test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
 		if (test_and_clear_bit(FLG_BUSY_TIMER, &dch->Flags))
 			del_timer(&dch->timer);
 		spin_unlock_irqrestore(&hc->lock, flags);
+		__skb_queue_purge(&free_queue);
 		break;
 	case HW_POWERUP_REQ:
 		spin_lock_irqsave(&hc->lock, flags);
@@ -3384,6 +3387,9 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 	case PH_DEACTIVATE_REQ:
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		if (dch->dev.D.protocol != ISDN_P_TE_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			spin_lock_irqsave(&hc->lock, flags);
 			if (debug & DEBUG_HFCMULTI_MSG)
 				printk(KERN_DEBUG
@@ -3405,14 +3411,14 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 				/* deactivate */
 				dch->state = 1;
 			}
-			skb_queue_purge(&dch->squeue);
+			skb_queue_splice_init(&dch->squeue, &free_queue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				__skb_queue_tail(&free_queue, dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				__skb_queue_tail(&free_queue, dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
@@ -3424,6 +3430,7 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 #endif
 			ret = 0;
 			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else
 			ret = l1_event(dch->l1, hh->prim);
 		break;
-- 
2.25.1

