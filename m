Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844566829F1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjAaKG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:06:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbjAaKGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:06:45 -0500
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECA24B8AD
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:06:40 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159593tekembi7
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:06:32 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: 3M0okmaRx3hZMtlmQMyDrNJpaHkjDXnxLLVnxit7pWz1ULUK8vBHGOaYYw7hW
        jnCmesRTncWOM8G1imA6C5Uvzc4B79mvUrniTT2vz1r7YkhC6pY6Erege1jN0Qme2vsB+51
        +nwMS4wy8Hkl5XPlhO0htWwlwb0MuNs6clxXvnriIRM4JYpmzpnPaERmSZHxRwLEDAoEO0F
        U2ftYbmtg+4gt8APW7eGMm1XgV0AUxnXfNZDgGyKS+78HMVIlYKpTpdXf6OUrl5m6dEFS97
        k2DWH7sP0Ogn5dKrX9+Whg70OnZsF97eMuOhEMfcfxvrnTipS3bRHwgXhjhOddTxoLb5nT5
        FkDmSKeG168jK3hNbdaEm2zAjd5OlNYLANuywq6wx0WaLTUqb3KmQq/T8AcfCVW/fQQy/Ky
        DG8hKSh0YukH2bZp74D6fXQXJJXoW99U
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v2 10/10] net: ngbe: Support Rx and Tx process path
Date:   Tue, 31 Jan 2023 18:05:41 +0800
Message-Id: <20230131100541.73757-11-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230131100541.73757-1-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvr:qybglogicsvr1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add enable and disable operation process for ngbe open/close.
Clean Rx and Tx ring interrupts, process packets in the data path.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 70 +++++++++++++++----
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  4 ++
 2 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index a9772f929274..f94d415daf3c 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -113,6 +113,9 @@ static int ngbe_sw_init(struct wx *wx)
 	wx->mac.num_rar_entries = NGBE_RAR_ENTRIES;
 	wx->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
 	wx->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
+	wx->mac.mcft_size = NGBE_MC_TBL_SIZE;
+	wx->mac.rx_pb_size = NGBE_RX_PB_SIZE;
+	wx->mac.tx_pb_size = NGBE_TDB_PB_SZ;
 
 	/* PCI config space info */
 	err = wx_sw_init(wx);
@@ -307,25 +310,46 @@ static int ngbe_request_irq(struct wx *wx)
 static void ngbe_disable_device(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
+	u32 i;
 
+	/* disable all enabled rx queues */
+	for (i = 0; i < wx->num_rx_queues; i++)
+		/* this call also flushes the previous write */
+		wx_disable_rx_queue(wx, wx->rx_ring[i]);
 	/* disable receives */
 	wx_disable_rx(wx);
+	wx_napi_disable_all(wx);
+	netif_tx_stop_all_queues(netdev);
 	netif_tx_disable(netdev);
 	if (wx->gpio_ctrl)
 		ngbe_sfp_modules_txrx_powerctl(wx, false);
 	wx_irq_disable(wx);
+	/* disable transmits in the hardware now that interrupts are off */
+	for (i = 0; i < wx->num_tx_queues; i++) {
+		u8 reg_idx = wx->tx_ring[i]->reg_idx;
+
+		wr32(wx, WX_PX_TR_CFG(reg_idx), WX_PX_TR_CFG_SWFLSH);
+	}
 }
 
 static void ngbe_down(struct wx *wx)
 {
 	phy_stop(wx->phydev);
 	ngbe_disable_device(wx);
+	wx_clean_all_tx_rings(wx);
+	wx_clean_all_rx_rings(wx);
 }
 
 static void ngbe_up(struct wx *wx)
 {
 	wx_configure_vectors(wx);
 
+	/* make sure to complete pre-operations */
+	smp_mb__before_atomic();
+	wx_napi_enable_all(wx);
+	/* enable transmits */
+	netif_tx_start_all_queues(wx->netdev);
+
 	/* clear any pending interrupts, may auto mask */
 	rd32(wx, WX_PX_IC);
 	rd32(wx, WX_PX_MISC_IC);
@@ -352,7 +376,7 @@ static int ngbe_open(struct net_device *netdev)
 
 	wx_control_hw(wx, true);
 
-	err = wx_setup_isb_resources(wx);
+	err = wx_setup_resources(wx);
 	if (err)
 		return err;
 
@@ -360,16 +384,29 @@ static int ngbe_open(struct net_device *netdev)
 
 	err = ngbe_request_irq(wx);
 	if (err)
-		goto err_req_irq;
+		goto err_free_resources;
 
 	err = ngbe_phy_connect(wx);
 	if (err)
-		return err;
+		goto err_free_irq;
+
+	err = netif_set_real_num_tx_queues(netdev, wx->num_tx_queues);
+	if (err)
+		goto err_dis_phy;
+
+	err = netif_set_real_num_rx_queues(netdev, wx->num_rx_queues);
+	if (err)
+		goto err_dis_phy;
+
 	ngbe_up(wx);
 
 	return 0;
-err_req_irq:
-	wx_free_isb_resources(wx);
+err_dis_phy:
+	phy_disconnect(wx->phydev);
+err_free_irq:
+	wx_free_irq(wx);
+err_free_resources:
+	wx_free_resources(wx);
 	return err;
 }
 
@@ -390,19 +427,13 @@ static int ngbe_close(struct net_device *netdev)
 
 	ngbe_down(wx);
 	wx_free_irq(wx);
-	wx_free_isb_resources(wx);
+	wx_free_resources(wx);
 	phy_disconnect(wx->phydev);
 	wx_control_hw(wx, false);
 
 	return 0;
 }
 
-static netdev_tx_t ngbe_xmit_frame(struct sk_buff *skb,
-				   struct net_device *netdev)
-{
-	return NETDEV_TX_OK;
-}
-
 static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct wx *wx = pci_get_drvdata(pdev);
@@ -438,9 +469,11 @@ static void ngbe_shutdown(struct pci_dev *pdev)
 static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_open               = ngbe_open,
 	.ndo_stop               = ngbe_close,
-	.ndo_start_xmit         = ngbe_xmit_frame,
+	.ndo_start_xmit         = wx_xmit_frame,
+	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
+	.ndo_get_stats64        = wx_get_stats64,
 };
 
 /**
@@ -516,6 +549,17 @@ static int ngbe_probe(struct pci_dev *pdev,
 	netdev->netdev_ops = &ngbe_netdev_ops;
 
 	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features = NETIF_F_SG;
+
+	/* copy netdev features into list of user selectable features */
+	netdev->hw_features |= netdev->features |
+			       NETIF_F_RXALL;
+
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->priv_flags |= IFF_SUPP_NOFCS;
+
+	netdev->min_mtu = ETH_MIN_MTU;
+	netdev->max_mtu = NGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
 
 	wx->bd_number = func_nums;
 	/* setup the private structure */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index b60f5f0f64fa..a2351349785e 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -134,6 +134,10 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_ETH_LENGTH_OF_ADDRESS		6
 #define NGBE_MAX_MSIX_VECTORS			0x09
 #define NGBE_RAR_ENTRIES			32
+#define NGBE_RX_PB_SIZE				42
+#define NGBE_MC_TBL_SIZE			128
+#define NGBE_TDB_PB_SZ				(20 * 1024) /* 160KB Packet Buffer */
+#define NGBE_MAX_JUMBO_FRAME_SIZE		9432 /* max payload 9414 */
 
 /* TX/RX descriptor defines */
 #define NGBE_DEFAULT_TXD			512 /* default ring size */
-- 
2.39.1

