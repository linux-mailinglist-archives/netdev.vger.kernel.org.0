Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E4C67152F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjARHk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjARHi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:38:28 -0500
X-Greylist: delayed 83 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 17 Jan 2023 23:00:10 PST
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFC7366A0
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 23:00:09 -0800 (PST)
X-QQ-mid: bizesmtp80t1674025136t2pmf6eq
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 18 Jan 2023 14:58:55 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: 3M0okmaRx3gpscBtG+wZoA7I3Nnl1cJQc5+0JK9VKv60Npi6Ln51dq4GxUFWj
        +X8q77OSzTGSQVYYHy5VlHOi5/3rW3Z/HPSZCvBPIVnKvXzIZewxyM1KB8uWipx3tbD6zP8
        AY5asp+Wc23Vf9UlT/DreDx8KL45EoF55jsaJsB4evzSDfuCW7ipMmtWVpOK4t3IiZutQGG
        UMvpVl6Is7orvnKPM14tRXD2KWBIhCFa7VPGdqHVMm78b+Oc0SEG63QwlUTOO9+GQ+Lgh2q
        Ulq5BFPsXhZnTFPLBA/cUUVr7DzAtbFkOQ7PHNA+Ok9qTFU64tg7swiXQmRg5wG2Cwgv8B8
        iuuO5mt0RrBK/Pd/M4+wTXZ9c7f0+Cd820en5SfziiXfFDOeHWqLhxrc80K7J3jtgvpIQUU
        GfUPeUcsb30KN0vAJWi9Tw==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 09/10] net: txgbe: Support Rx and Tx process path
Date:   Wed, 18 Jan 2023 14:55:03 +0800
Message-Id: <20230118065504.3075474-10-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
References: <20230118065504.3075474-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=ham
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

