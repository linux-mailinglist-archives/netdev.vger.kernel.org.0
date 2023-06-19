Return-Path: <netdev+bounces-11901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A3973509C
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:43:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C86C828104E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:43:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD4D3C13C;
	Mon, 19 Jun 2023 09:43:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC63BE6C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:43:05 +0000 (UTC)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA586113
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:43:02 -0700 (PDT)
X-QQ-mid: bizesmtp85t1687167775t8w6g2i9
Received: from localhost.localdomain ( [122.235.139.240])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 19 Jun 2023 17:42:45 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: esg/Nh4VDJiu7QSwG+wknBIbl/EFNsa1AIS6AAq7ecDKBG+f6KYQ4EZ8CZdfj
	Udwts8J8XuSF7yArnP8A/BxXfKQyDagr4khTUvuIuvjNjkTHiy8O3LDd7FSx5eJYDuChOFh
	BjVGyiNqJR6b2oGJP/usDWJf8FRICdMDOg4rIEHH0LwDiFMpD33gY7rPbLqqHAMe2osFeEV
	mWrlbWvIgJAwhdwOtL2mvXZK/71UsbeVDTHi39Dd5q6mwL1IrjACUP7RnkplkHjzCGtlsZ5
	2mG9fVnMFxawNs9zwJG7edN3Sc/hJI3Q56scr0pT2FSy1P+sGmGjOCl4ZbGpVy70QPCz3u1
	eS7ZdFpvFoXD9nUeYUz17wScPcjAmcBn86Cq/FmwpAJ5WehKohMZmSDYaJ0MLwq7mUMQlRI
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 8547525226610091630
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next] net: ngbe: add Wake on Lan support
Date: Mon, 19 Jun 2023 17:42:26 +0800
Message-ID: <58725FAD2BC3AE85+20230619094226.29704-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement ethtool_ops get_wol and set_wol.
Implement Wake-on-LAN support.

Magic packets are checked by fw, for now just support
WAKE_MAGIC.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  3 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |  1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  4 ++
 .../net/ethernet/wangxun/ngbe/ngbe_ethtool.c  | 37 +++++++++++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 62 +++++++++++++++++--
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c |  1 +
 6 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.c b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
index 39a9aeee7aab..ad09ab1d1209 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1501,7 +1501,7 @@ static void wx_restore_vlan(struct wx *wx)
  *
  * Configure the Rx unit of the MAC after a reset.
  **/
-static void wx_configure_rx(struct wx *wx)
+void wx_configure_rx(struct wx *wx)
 {
 	u32 psrtype, i;
 	int ret;
@@ -1545,6 +1545,7 @@ static void wx_configure_rx(struct wx *wx)
 	wx_enable_rx(wx);
 	wx_enable_sec_rx_path(wx);
 }
+EXPORT_SYMBOL(wx_configure_rx);
 
 static void wx_configure_isb(struct wx *wx)
 {
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_hw.h b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
index 1f93ca32c921..b95090e973ae 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.h
@@ -25,6 +25,7 @@ void wx_disable_rx(struct wx *wx);
 void wx_set_rx_mode(struct net_device *netdev);
 int wx_change_mtu(struct net_device *netdev, int new_mtu);
 void wx_disable_rx_queue(struct wx *wx, struct wx_ring *ring);
+void wx_configure_rx(struct wx *wx);
 void wx_configure(struct wx *wx);
 void wx_start_hw(struct wx *wx);
 int wx_disable_pcie_master(struct wx *wx);
diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index 5063846e1b52..6da3388355ea 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -158,6 +158,10 @@
 #define WX_PSR_LAN_FLEX_DW_H(_i)     (0x15C04 + ((_i) * 16))
 #define WX_PSR_LAN_FLEX_MSK(_i)      (0x15C08 + ((_i) * 16))
 
+#define WX_PSR_WKUP_CTL              0x15B80
+/* Wake Up Filter Control Bit */
+#define WX_PSR_WKUP_CTL_MAG          BIT(1) /* Magic Packet Wakeup Enable */
+
 /* vlan tbl */
 #define WX_PSR_VLAN_TBL(_i)          (0x16000 + ((_i) * 4))
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
index 5b25834baf38..d2a80558e086 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
@@ -6,14 +6,51 @@
 #include <linux/netdevice.h>
 
 #include "../libwx/wx_ethtool.h"
+#include "../libwx/wx_type.h"
 #include "ngbe_ethtool.h"
 
+static void ngbe_get_wol(struct net_device *netdev,
+			 struct ethtool_wolinfo *wol)
+{
+	struct wx *wx = netdev_priv(netdev);
+
+	if (!wx->wol_enabled)
+		return;
+	wol->supported = WAKE_MAGIC;
+	wol->wolopts = 0;
+	if (wx->wol & WX_PSR_WKUP_CTL_MAG)
+		wol->wolopts |= WAKE_MAGIC;
+}
+
+static int ngbe_set_wol(struct net_device *netdev,
+			struct ethtool_wolinfo *wol)
+{
+	struct wx *wx = netdev_priv(netdev);
+	struct pci_dev *pdev = wx->pdev;
+
+	if (!wx->wol_enabled)
+		return -EOPNOTSUPP;
+	if (wol->wolopts & WAKE_MAGIC)
+		return -EOPNOTSUPP;
+
+	wx->wol = 0;
+	if (wol->wolopts & WAKE_MAGIC)
+		wx->wol = WX_PSR_WKUP_CTL_MAG;
+	netdev->wol_enabled = !!(wx->wol);
+	wr32(wx, WX_PSR_WKUP_CTL, wx->wol);
+	device_set_wakeup_enable(&pdev->dev, wx->wol);
+
+	return 0;
+}
+
 static const struct ethtool_ops ngbe_ethtool_ops = {
 	.get_drvinfo		= wx_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
 	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
 	.nway_reset		= phy_ethtool_nway_reset,
+	.get_wol		= ngbe_get_wol,
+	.set_wol		= ngbe_set_wol,
 };
 
 void ngbe_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index c99a5d3de72e..e5aaac2746d5 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -440,14 +440,26 @@ static void ngbe_dev_shutdown(struct pci_dev *pdev, bool *enable_wake)
 {
 	struct wx *wx = pci_get_drvdata(pdev);
 	struct net_device *netdev;
+	u32 wufc = wx->wol;
 
 	netdev = wx->netdev;
+	rtnl_lock();
 	netif_device_detach(netdev);
 
-	rtnl_lock();
 	if (netif_running(netdev))
-		ngbe_down(wx);
+		ngbe_close(netdev);
+	wx_clear_interrupt_scheme(wx);
 	rtnl_unlock();
+
+	if (wufc) {
+		wx_set_rx_mode(netdev);
+		wx_configure_rx(wx);
+		wr32(wx, NGBE_PSR_WKUP_CTL, wufc);
+	} else {
+		wr32(wx, NGBE_PSR_WKUP_CTL, 0);
+	}
+	pci_wake_from_d3(pdev, !!wufc);
+	*enable_wake = !!wufc;
 	wx_control_hw(wx, false);
 
 	pci_disable_device(pdev);
@@ -624,9 +636,8 @@ static int ngbe_probe(struct pci_dev *pdev,
 	if (wx->wol_enabled)
 		wx->wol = NGBE_PSR_WKUP_CTL_MAG;
 
-	wx->wol_enabled = !!(wx->wol);
+	netdev->wol_enabled = !!(wx->wol);
 	wr32(wx, NGBE_PSR_WKUP_CTL, wx->wol);
-
 	device_set_wakeup_enable(&pdev->dev, wx->wol);
 
 	/* Save off EEPROM version number and Option Rom version which
@@ -712,11 +723,54 @@ static void ngbe_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
+static int ngbe_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	bool wake;
+
+	ngbe_dev_shutdown(pdev, &wake);
+	device_set_wakeup_enable(&pdev->dev, wake);
+
+	return 0;
+}
+
+static int ngbe_resume(struct pci_dev *pdev)
+{
+	struct net_device *netdev;
+	struct wx *wx;
+	u32 err;
+
+	wx = pci_get_drvdata(pdev);
+	netdev = wx->netdev;
+
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		wx_err(wx, "Cannot enable PCI device from suspend\n");
+		return err;
+	}
+	/* make sure to complete pre-operations */
+	smp_mb__before_atomic();
+	pci_set_master(pdev);
+	device_wakeup_disable(&pdev->dev);
+
+	ngbe_reset_hw(wx);
+	rtnl_lock();
+	err = wx_init_interrupt_scheme(wx);
+	if (!err && netif_running(netdev))
+		err = ngbe_open(netdev);
+	if (!err)
+		netif_device_attach(netdev);
+	rtnl_unlock();
+
+	return 0;
+}
+
 static struct pci_driver ngbe_driver = {
 	.name     = ngbe_driver_name,
 	.id_table = ngbe_pci_tbl,
 	.probe    = ngbe_probe,
 	.remove   = ngbe_remove,
+	.suspend  = ngbe_suspend,
+	.resume   = ngbe_resume,
 	.shutdown = ngbe_shutdown,
 };
 
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
index c9ddbbc3fa4f..cc2f325a52f7 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
@@ -236,6 +236,7 @@ static void ngbe_phy_fixup(struct wx *wx)
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
 	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
 
+	phydev->mac_managed_pm = true;
 	if (wx->mac_type != em_mac_type_mdi)
 		return;
 	/* disable EEE, internal phy does not support eee */
-- 
2.41.0


