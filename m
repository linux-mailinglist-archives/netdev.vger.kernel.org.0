Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53760645693
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbiLGJfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLGJfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:35:32 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3753722B
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:35:31 -0800 (PST)
Received: from dggpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NRsZB0MJzzJqLW;
        Wed,  7 Dec 2022 17:34:42 +0800 (CST)
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 7 Dec
 2022 17:35:00 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <isdn@linux-pingi.de>, <davem@davemloft.net>
Subject: [PATCH net 3/3] mISDN: hfcmulti: don't call dev_kfree_skb() under spin_lock_irqsave()
Date:   Wed, 7 Dec 2022 17:32:39 +0800
Message-ID: <20221207093239.3775457-4-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221207093239.3775457-1-yangyingliang@huawei.com>
References: <20221207093239.3775457-1-yangyingliang@huawei.com>
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

It is not allowed to call consume_skb() from hardware interrupt context
or with interrupts being disabled. So replace dev_kfree_skb() with
dev_consume_skb_irq() under spin_lock_irqsave().

Fixes: af69fb3a8ffa ("Add mISDN HFC multiport driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 4f7eaa17fb27..9f932cbb2a20 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -3266,12 +3266,12 @@ hfcm_l1callback(struct dchannel *dch, u_int cmd)
 		}
 		skb_queue_purge(&dch->squeue);
 		if (dch->tx_skb) {
-			dev_kfree_skb(dch->tx_skb);
+			dev_consume_skb_irq(dch->tx_skb);
 			dch->tx_skb = NULL;
 		}
 		dch->tx_idx = 0;
 		if (dch->rx_skb) {
-			dev_kfree_skb(dch->rx_skb);
+			dev_consume_skb_irq(dch->rx_skb);
 			dch->rx_skb = NULL;
 		}
 		test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
@@ -3407,12 +3407,12 @@ handle_dmsg(struct mISDNchannel *ch, struct sk_buff *skb)
 			}
 			skb_queue_purge(&dch->squeue);
 			if (dch->tx_skb) {
-				dev_kfree_skb(dch->tx_skb);
+				dev_consume_skb_irq(dch->tx_skb);
 				dch->tx_skb = NULL;
 			}
 			dch->tx_idx = 0;
 			if (dch->rx_skb) {
-				dev_kfree_skb(dch->rx_skb);
+				dev_consume_skb_irq(dch->rx_skb);
 				dch->rx_skb = NULL;
 			}
 			test_and_clear_bit(FLG_TX_BUSY, &dch->Flags);
-- 
2.25.1

