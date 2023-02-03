Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404FB689369
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbjBCJQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjBCJQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:16:25 -0500
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A799B6F7
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:16:06 -0800 (PST)
X-QQ-mid: bizesmtp68t1675415760tjfqxv7o
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 03 Feb 2023 17:16:00 +0800 (CST)
X-QQ-SSF: 01400000000000H0Y000B00A0000000
X-QQ-FEAT: lkL5M32tl2Cyix4MfR380DdxBZhMnSMAkcGWoKeVH4zqjs9ZT+EAw8PS/iZug
        YLLrvY3K5UXzV8DA6BS8+UD/jf+elDhFz76TG/ppb5egkpLfgTKPe0Oj8wTH/lWuKMCs9oV
        1O9tJbe62nzivTcLefEuO3h2J605CxZJibnzaPRmhpXGbmmFjZXy5LwDjZ3xz6988mjiJbM
        hpKdElNCK4ubJEJshaDu3YlQNOdUiOQZzh7OO4AmXCIuUHU+BrDblLGySP3JShSz8LQq9Th
        fUKII6mUgnY9TH0REg2e1PqTLXNuxcUwXvgM8e2IOBUYe/XmoadcjX8AYehYNQ4hLa8Dg5e
        wCD57+0NbBHJcBH8uD3MPTsh4Z6cDYzanipMf5NmWWyAcHjK3NOf5XWquTIB+zJvffPrxOi
        pp3eEFbUBFA=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: [PATCH net-next v3 10/10] net: ngbe: Support Rx and Tx process path
Date:   Fri,  3 Feb 2023 17:11:35 +0800
Message-Id: <20230203091135.3294377-11-jiawenwu@trustnetic.com>
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

From: Mengyuan Lou <mengyuanlou@net-swift.com>

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
2.27.0

