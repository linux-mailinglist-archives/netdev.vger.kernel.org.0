Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88EC689345
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjBCJQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232675AbjBCJQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:16:23 -0500
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65B195D31
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:16:04 -0800 (PST)
X-QQ-mid: bizesmtp68t1675415758tos65246
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 03 Feb 2023 17:15:57 +0800 (CST)
X-QQ-SSF: 01400000000000H0Y000B00A0000000
X-QQ-FEAT: lkL5M32tl2Bh0YGrduW6ZbtZs+gCZwgnNRB45cAfYyXy8GxAhwA5kSMPuW9hr
        WJlNStwFvz/AyavYziHePt/vxly6PhEqfgfH8CggQ8cLepWNPuEzr8EmdGqveIsLxiVrSLT
        b56f5O4u6Pkum7+YLmb8GVNcLWlHkJD4E0WYp7VTPSYgD6vxvEFKRIVN/O71xOMW9lxJNzJ
        DJ9+kX2CEfNdVOjJNr1g0QLoM2kspdVzwevWVPfDb2fjtx2eyOw8lrBhKuIR9AFdRNHsF9z
        YeTSVYPRGD4jR0iK9/nRCjP+pdA4XgTP3OpD0vJNy03K0Z5gvboQ1W+oCfbQjYUJO6dbQOa
        nkOeetQXgnGbV35lXQMif2v7UulsuQCBjNvTuI9D7oUlTXu8nyifdlGJxPVvD5Ik/V4RNWa
        oSkeuTbbkiDBJ5gqluDJrg==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 09/10] net: txgbe: Support Rx and Tx process path
Date:   Fri,  3 Feb 2023 17:11:34 +0800
Message-Id: <20230203091135.3294377-10-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230203091135.3294377-1-jiawenwu@trustnetic.com>
References: <20230203091135.3294377-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean Rx and Tx ring interrupts, process packets in the data path.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 37 ++++++++++++++-----
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 3b50acb09699..094df377726b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -223,6 +223,10 @@ static void txgbe_up_complete(struct wx *wx)
 	wx_control_hw(wx, true);
 	wx_configure_vectors(wx);
 
+	/* make sure to complete pre-operations */
+	smp_mb__before_atomic();
+	wx_napi_enable_all(wx);
+
 	/* clear any pending interrupts, may auto mask */
 	rd32(wx, WX_PX_IC);
 	rd32(wx, WX_PX_MISC_IC);
@@ -236,6 +240,10 @@ static void txgbe_up_complete(struct wx *wx)
 	wr32(wx, WX_MAC_WDG_TIMEOUT, reg);
 	reg = rd32(wx, WX_MAC_TX_CFG);
 	wr32(wx, WX_MAC_TX_CFG, (reg & ~WX_MAC_TX_CFG_SPEED_MASK) | WX_MAC_TX_CFG_SPEED_10G);
+
+	/* enable transmits */
+	netif_tx_start_all_queues(wx->netdev);
+	netif_carrier_on(wx->netdev);
 }
 
 static void txgbe_reset(struct wx *wx)
@@ -268,10 +276,12 @@ static void txgbe_disable_device(struct wx *wx)
 		/* this call also flushes the previous write */
 		wx_disable_rx_queue(wx, wx->rx_ring[i]);
 
+	netif_tx_stop_all_queues(netdev);
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
 	wx_irq_disable(wx);
+	wx_napi_disable_all(wx);
 
 	if (wx->bus.func < 2)
 		wr32m(wx, TXGBE_MIS_PRB_CTL, TXGBE_MIS_PRB_CTL_LAN_UP(wx->bus.func), 0);
@@ -300,6 +310,9 @@ static void txgbe_down(struct wx *wx)
 {
 	txgbe_disable_device(wx);
 	txgbe_reset(wx);
+
+	wx_clean_all_tx_rings(wx);
+	wx_clean_all_rx_rings(wx);
 }
 
 /**
@@ -381,10 +394,21 @@ static int txgbe_open(struct net_device *netdev)
 	if (err)
 		goto err_free_isb;
 
+	/* Notify the stack of the actual queue counts. */
+	err = netif_set_real_num_tx_queues(netdev, wx->num_tx_queues);
+	if (err)
+		goto err_free_irq;
+
+	err = netif_set_real_num_rx_queues(netdev, wx->num_rx_queues);
+	if (err)
+		goto err_free_irq;
+
 	txgbe_up_complete(wx);
 
 	return 0;
 
+err_free_irq:
+	wx_free_irq(wx);
 err_free_isb:
 	wx_free_isb_resources(wx);
 err_reset:
@@ -403,8 +427,6 @@ static int txgbe_open(struct net_device *netdev)
 static void txgbe_close_suspend(struct wx *wx)
 {
 	txgbe_disable_device(wx);
-
-	wx_free_irq(wx);
 	wx_free_resources(wx);
 }
 
@@ -461,19 +483,14 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 	}
 }
 
-static netdev_tx_t txgbe_xmit_frame(struct sk_buff *skb,
-				    struct net_device *netdev)
-{
-	return NETDEV_TX_OK;
-}
-
 static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
-	.ndo_start_xmit         = txgbe_xmit_frame,
+	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
+	.ndo_get_stats64        = wx_get_stats64,
 };
 
 /**
@@ -647,6 +664,8 @@ static int txgbe_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, wx);
 
+	netif_tx_stop_all_queues(netdev);
+
 	/* calculate the expected PCIe bandwidth required for optimal
 	 * performance. Note that some older parts will never have enough
 	 * bandwidth due to being older generation PCIe parts. We clamp these
-- 
2.27.0

