Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C421E649A44
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 09:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiLLIoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 03:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiLLIoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 03:44:21 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889CBE02C
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 00:44:20 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NVwBc4VwkzRpyc;
        Mon, 12 Dec 2022 16:43:20 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 12 Dec
 2022 16:44:18 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <isdn@linux-pingi.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <jiri@resnulli.us>, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH net v2 2/3] mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()
Date:   Mon, 12 Dec 2022 16:41:38 +0800
Message-ID: <20221212084139.3277913-3-yangyingliang@huawei.com>
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

skb_queue_purge() is called under spin_lock_irqsave() in hfcpci_l2l1D(),
kfree_skb() is called in it, to fix this, use skb_queue_splice_init()
to move the dch->squeue to a free queue, also enqueue the tx_skb and
rx_skb, at last calling __skb_queue_purge() to free the SKBs afer unlock.

Fixes: 1700fe1a10dc ("Add mISDN HFC PCI driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index e964a8dd8512..c0331b268010 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1617,16 +1617,19 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 		test_and_clear_bit(FLG_L2_ACTIVATED, &dch->Flags);
 		spin_lock_irqsave(&hc->lock, flags);
 		if (hc->hw.protocol == ISDN_P_NT_S0) {
+			struct sk_buff_head free_queue;
+
+			__skb_queue_head_init(&free_queue);
 			/* prepare deactivation */
 			Write_hfc(hc, HFCPCI_STATES, 0x40);
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
@@ -1639,10 +1642,12 @@ hfcpci_l2l1D(struct mISDNchannel *ch, struct sk_buff *skb)
 			hc->hw.mst_m &= ~HFCPCI_MASTER;
 			Write_hfc(hc, HFCPCI_MST_MODE, hc->hw.mst_m);
 			ret = 0;
+			spin_unlock_irqrestore(&hc->lock, flags);
+			__skb_queue_purge(&free_queue);
 		} else {
 			ret = l1_event(dch->l1, hh->prim);
+			spin_unlock_irqrestore(&hc->lock, flags);
 		}
-		spin_unlock_irqrestore(&hc->lock, flags);
 		break;
 	}
 	if (!ret)
-- 
2.25.1

