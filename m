Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399B86829F0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 11:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjAaKG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 05:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjAaKGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 05:06:33 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B197F4B8AE
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 02:06:27 -0800 (PST)
X-QQ-mid: bizesmtp69t1675159579t6346do2
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 31 Jan 2023 18:06:17 +0800 (CST)
X-QQ-SSF: 01400000000000M0O000000A0000000
X-QQ-FEAT: QityeSR92A2U7wHt/s2fTTvtU2neahRjmvwt4bGZfY8fNEtmKIOZcovRTKomA
        Rp9UCMA6N2+scQMu7LxoQrDzyVUQ//+cIIr3RPoqEM+2v4sYTnkWbWjACM0WH8z8LUySyqX
        LDQStQJhJqEU0YMNtYxFeLq+Zlc58u1qhZj4BoC+0iKoJSfCxVPs7C79Mr0lUl0inBwuKp/
        665WPdFo/kxdlf9ZZFHt2ky9QqEUjX5CoOkMLaAE766DupenHc/wokfUaIypRK/L732ZAGV
        WswsSBmVn6YlzEfeJu+7Jh8DQvaZpIGW0BIW/lm/7cuQbGusTgsR+Ng3XZV+yCbqL27QS4R
        Z94BpmzHLaiWOArBwvahySDXJfViOKezg9n13ImuwGA6qTNCw0SAoo1zpXWEf5bohiIlqQO
        7MC567guc5Md6vBi8bnthg==
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com
Subject: [PATCH net-next v2 06/10] net: txgbe: Setup Rx and Tx ring
Date:   Tue, 31 Jan 2023 18:05:37 +0800
Message-Id: <20230131100541.73757-7-mengyuanlou@net-swift.com>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

Improve the configuration of Rx and Tx ring, set Rx flags and implement
ndo_set_rx_mode ops.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 43 +++++++++++++++++--
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  3 ++
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 1863c6cbc6c6..7b247af0ff17 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -200,6 +200,7 @@
 #define WX_MAC_TX_CFG                0x11000
 #define WX_MAC_TX_CFG_TE             BIT(0)
 #define WX_MAC_TX_CFG_SPEED_MASK     GENMASK(30, 29)
+#define WX_MAC_TX_CFG_SPEED_10G      FIELD_PREP(WX_MAC_TX_CFG_SPEED_MASK, 0)
 #define WX_MAC_TX_CFG_SPEED_1G       FIELD_PREP(WX_MAC_TX_CFG_SPEED_MASK, 3)
 #define WX_MAC_RX_CFG                0x11004
 #define WX_MAC_RX_CFG_RE             BIT(0)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 48cca2fb54c7..3b50acb09699 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -218,6 +218,8 @@ static int txgbe_request_irq(struct wx *wx)
 
 static void txgbe_up_complete(struct wx *wx)
 {
+	u32 reg;
+
 	wx_control_hw(wx, true);
 	wx_configure_vectors(wx);
 
@@ -225,6 +227,15 @@ static void txgbe_up_complete(struct wx *wx)
 	rd32(wx, WX_PX_IC);
 	rd32(wx, WX_PX_MISC_IC);
 	txgbe_irq_enable(wx, true);
+
+	/* Configure MAC Rx and Tx when link is up */
+	reg = rd32(wx, WX_MAC_RX_CFG);
+	wr32(wx, WX_MAC_RX_CFG, reg);
+	wr32(wx, WX_MAC_PKT_FLT, WX_MAC_PKT_FLT_PR);
+	reg = rd32(wx, WX_MAC_WDG_TIMEOUT);
+	wr32(wx, WX_MAC_WDG_TIMEOUT, reg);
+	reg = rd32(wx, WX_MAC_TX_CFG);
+	wr32(wx, WX_MAC_TX_CFG, (reg & ~WX_MAC_TX_CFG_SPEED_MASK) | WX_MAC_TX_CFG_SPEED_10G);
 }
 
 static void txgbe_reset(struct wx *wx)
@@ -246,11 +257,17 @@ static void txgbe_reset(struct wx *wx)
 static void txgbe_disable_device(struct wx *wx)
 {
 	struct net_device *netdev = wx->netdev;
+	u32 i;
 
 	wx_disable_pcie_master(wx);
 	/* disable receives */
 	wx_disable_rx(wx);
 
+	/* disable all enabled rx queues */
+	for (i = 0; i < wx->num_rx_queues; i++)
+		/* this call also flushes the previous write */
+		wx_disable_rx_queue(wx, wx->rx_ring[i]);
+
 	netif_carrier_off(netdev);
 	netif_tx_disable(netdev);
 
@@ -268,6 +285,13 @@ static void txgbe_disable_device(struct wx *wx)
 		wr32m(wx, WX_MAC_TX_CFG, WX_MAC_TX_CFG_TE, 0);
 	}
 
+	/* disable transmits in the hardware now that interrupts are off */
+	for (i = 0; i < wx->num_tx_queues; i++) {
+		u8 reg_idx = wx->tx_ring[i]->reg_idx;
+
+		wr32(wx, WX_PX_TR_CFG(reg_idx), WX_PX_TR_CFG_SWFLSH);
+	}
+
 	/* Disable the Tx DMA engine */
 	wr32m(wx, WX_TDM_CTL, WX_TDM_CTL_TE, 0);
 }
@@ -291,6 +315,8 @@ static int txgbe_sw_init(struct wx *wx)
 	wx->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
 	wx->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
 	wx->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
+	wx->mac.rx_pb_size = TXGBE_SP_RX_PB_SIZE;
+	wx->mac.tx_pb_size = TXGBE_SP_TDB_PB_SZ;
 
 	/* PCI config space info */
 	err = wx_sw_init(wx);
@@ -345,7 +371,7 @@ static int txgbe_open(struct net_device *netdev)
 	struct wx *wx = netdev_priv(netdev);
 	int err;
 
-	err = wx_setup_isb_resources(wx);
+	err = wx_setup_resources(wx);
 	if (err)
 		goto err_reset;
 
@@ -379,7 +405,7 @@ static void txgbe_close_suspend(struct wx *wx)
 	txgbe_disable_device(wx);
 
 	wx_free_irq(wx);
-	wx_free_isb_resources(wx);
+	wx_free_resources(wx);
 }
 
 /**
@@ -399,7 +425,7 @@ static int txgbe_close(struct net_device *netdev)
 
 	txgbe_down(wx);
 	wx_free_irq(wx);
-	wx_free_isb_resources(wx);
+	wx_free_resources(wx);
 	wx_control_hw(wx, false);
 
 	return 0;
@@ -445,6 +471,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
 	.ndo_start_xmit         = txgbe_xmit_frame,
+	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 };
@@ -549,6 +576,16 @@ static int txgbe_probe(struct pci_dev *pdev,
 	}
 
 	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features = NETIF_F_SG;
+
+	/* copy netdev features into list of user selectable features */
+	netdev->hw_features |= netdev->features | NETIF_F_RXALL;
+
+	netdev->priv_flags |= IFF_UNICAST_FLT;
+	netdev->priv_flags |= IFF_SUPP_NOFCS;
+
+	netdev->min_mtu = ETH_MIN_MTU;
+	netdev->max_mtu = TXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
 
 	/* make sure the EEPROM is good */
 	err = txgbe_validate_eeprom_checksum(wx, NULL);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ec28cf60c91d..563ea51deca6 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -77,6 +77,9 @@
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
+#define TXGBE_SP_RX_PB_SIZE     512
+#define TXGBE_SP_TDB_PB_SZ      (160 * 1024) /* 160KB Packet Buffer */
+#define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
 
 /* TX/RX descriptor defines */
 #define TXGBE_DEFAULT_TXD               512
-- 
2.39.1

