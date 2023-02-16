Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D03A698EEF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjBPIol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjBPIoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:44:39 -0500
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E388438E88
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:44:33 -0800 (PST)
X-QQ-mid: bizesmtp67t1676537064tlckoisj
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 16 Feb 2023 16:44:15 +0800 (CST)
X-QQ-SSF: 01400000000000N0P000000A0000000
X-QQ-FEAT: zT6n3Y95oi0+eqt/JMZ4aEz/GnPqA0mPIYkFLrQ6M3tGR2Vw/i1ecUFGcAcKV
        Z4bV0AbXFmkmH6r7est2g3T+B9AVgW/CIdTUx+oy8N/OB1GO5U4YlZQInHCc2Yy01n8NzJ/
        4m7rXY5NguxCnQB0d+25Yz3CpgxRurrUZi80NTRiajvigUsZDMx9QSpSKQhY2E8l62yjtb1
        1BeY6D0qP2GX4P11TDjgfJ92pzHthdIXb1gfXDLdKUpWhMUwcC4BDuDABka+HE525sZKkN4
        wo2IScI6q5kFN9JpI5gdFFWv9WFuLNPHQXOTcVsUwhWFgRvwQWyjLqWubjJL7ZB1Ia5X9vF
        1djVVaYC6iwDDS45kG++gogX+oVBVSYwZ/Q8lahMWzrIe7qRovq0b8oGN+yj7IaHOhR+Xmz
        SehcQ+MGGuw=
X-QQ-GoodBg: 2
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: wangxun: Implement the ndo change mtu interface
Date:   Thu, 16 Feb 2023 16:44:13 +0800
Message-Id: <20230216084413.10089-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.39.1
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

Add ngbe and txgbe ndo_change_mtu support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  2 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 38 ++++++++++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |  1 -
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 38 ++++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 -
 5 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 77d8d7f1707e..2b9efd13c500 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -300,6 +300,8 @@
 #define WX_MAX_RXD                   8192
 #define WX_MAX_TXD                   8192
 
+#define WX_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
+
 /* Supported Rx Buffer Sizes */
 #define WX_RXBUFFER_256      256    /* Used for skb receive header */
 #define WX_RXBUFFER_2K       2048
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 5b564d348c09..78bfaff02aad 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -361,6 +361,15 @@ static void ngbe_up(struct wx *wx)
 	phy_start(wx->phydev);
 }
 
+static void ngbe_reinit_locked(struct wx *wx)
+{
+	/* prevent tx timeout */
+	netif_trans_update(wx->netdev);
+	ngbe_down(wx);
+	wx_configure(wx);
+	ngbe_up(wx);
+}
+
 /**
  * ngbe_open - Called when a network interface is made active
  * @netdev: network interface device structure
@@ -435,6 +444,32 @@ static int ngbe_close(struct net_device *netdev)
 	return 0;
 }
 
+/**
+ * ngbe_change_mtu - Change the Maximum Transfer Unit
+ * @netdev: network interface device structure
+ * @new_mtu: new value for maximum frame size
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int ngbe_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
+	struct wx *wx = netdev_priv(netdev);
+
+	if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
+		return -EINVAL;
+
+	netdev_info(netdev, "Changing MTU from %d to %d.\n",
+		    netdev->mtu, new_mtu);
+
+	/* must set new MTU before calling down or up */
+	netdev->mtu = new_mtu;
+	if (netif_running(netdev))
+		ngbe_reinit_locked(wx);
+
+	return 0;
+}
+
 static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct wx *wx = pci_get_drvdata(pdev);
@@ -470,6 +505,7 @@ static void ngbe_shutdown(struct pci_dev *pdev)
 static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_open               = ngbe_open,
 	.ndo_stop               = ngbe_close,
+	.ndo_change_mtu         = ngbe_change_mtu,
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
@@ -562,7 +598,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = NGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
+	netdev->max_mtu = WX_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
 
 	wx->bd_number = func_nums;
 	/* setup the private structure */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index a2351349785e..373d5af628cd 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -137,7 +137,6 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_RX_PB_SIZE				42
 #define NGBE_MC_TBL_SIZE			128
 #define NGBE_TDB_PB_SZ				(20 * 1024) /* 160KB Packet Buffer */
-#define NGBE_MAX_JUMBO_FRAME_SIZE		9432 /* max payload 9414 */
 
 /* TX/RX descriptor defines */
 #define NGBE_DEFAULT_TXD			512 /* default ring size */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 6c0a98230557..0b09f982a2c8 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -454,6 +454,41 @@ static int txgbe_close(struct net_device *netdev)
 	return 0;
 }
 
+static void txgbe_reinit_locked(struct wx *wx)
+{
+	/* prevent tx timeout */
+	netif_trans_update(wx->netdev);
+	txgbe_down(wx);
+	wx_configure(wx);
+	txgbe_up_complete(wx);
+}
+
+/**
+ * txgbe_change_mtu - Change the Maximum Transfer Unit
+ * @netdev: network interface device structure
+ * @new_mtu: new value for maximum frame size
+ *
+ * Returns 0 on success, negative on failure
+ **/
+static int txgbe_change_mtu(struct net_device *netdev, int new_mtu)
+{
+	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN;
+	struct wx *wx = netdev_priv(netdev);
+
+	if (max_frame > WX_MAX_JUMBO_FRAME_SIZE)
+		return -EINVAL;
+
+	netdev_info(netdev, "Changing MTU from %d to %d.\n",
+		    netdev->mtu, new_mtu);
+
+	/* must set new MTU before calling down or up */
+	netdev->mtu = new_mtu;
+	if (netif_running(netdev))
+		txgbe_reinit_locked(wx);
+
+	return 0;
+}
+
 static void txgbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct wx *wx = pci_get_drvdata(pdev);
@@ -487,6 +522,7 @@ static void txgbe_shutdown(struct pci_dev *pdev)
 static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_open               = txgbe_open,
 	.ndo_stop               = txgbe_close,
+	.ndo_change_mtu         = txgbe_change_mtu,
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
 	.ndo_validate_addr      = eth_validate_addr,
@@ -605,7 +641,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
 	netdev->min_mtu = ETH_MIN_MTU;
-	netdev->max_mtu = TXGBE_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
+	netdev->max_mtu = WX_MAX_JUMBO_FRAME_SIZE - (ETH_HLEN + ETH_FCS_LEN);
 
 	/* make sure the EEPROM is good */
 	err = txgbe_validate_eeprom_checksum(wx, NULL);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 563ea51deca6..63a1c733718d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -79,7 +79,6 @@
 #define TXGBE_SP_MC_TBL_SIZE    128
 #define TXGBE_SP_RX_PB_SIZE     512
 #define TXGBE_SP_TDB_PB_SZ      (160 * 1024) /* 160KB Packet Buffer */
-#define TXGBE_MAX_JUMBO_FRAME_SIZE      9432 /* max payload 9414 */
 
 /* TX/RX descriptor defines */
 #define TXGBE_DEFAULT_TXD               512
-- 
2.39.1

