Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1B51653EE
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbgBTA5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:33269 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgBTA5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621371"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/12] igc: Add WOL support
Date:   Wed, 19 Feb 2020 16:57:12 -0800
Message-Id: <20200220005713.682605-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

This patch adds a define and WOL support for an i225 parts.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  1 +
 drivers/net/ethernet/intel/igc/igc_defines.h |  3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 61 ++++++++++++++++++++
 drivers/net/ethernet/intel/igc/igc_main.c    | 10 ++++
 4 files changed, 75 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5e9c2dd8b8e4..8d9ed4f0b69d 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -61,6 +61,7 @@ extern char igc_driver_version[];
 #define IGC_FLAG_QUEUE_PAIRS		BIT(3)
 #define IGC_FLAG_DMAC			BIT(4)
 #define IGC_FLAG_PTP			BIT(8)
+#define IGC_FLAG_WOL_SUPPORTED		BIT(8)
 #define IGC_FLAG_NEED_LINK_UPDATE	BIT(9)
 #define IGC_FLAG_MEDIA_RESET		BIT(10)
 #define IGC_FLAG_MAS_ENABLE		BIT(12)
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 3c03962bde5e..4ddccccf42cc 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -16,7 +16,10 @@
 
 /* Wake Up Filter Control */
 #define IGC_WUFC_LNKC	0x00000001 /* Link Status Change Wakeup Enable */
+#define IGC_WUFC_MAG	0x00000002 /* Magic Packet Wakeup Enable */
+#define IGC_WUFC_EX	0x00000004 /* Directed Exact Wakeup Enable */
 #define IGC_WUFC_MC	0x00000008 /* Directed Multicast Wakeup Enable */
+#define IGC_WUFC_BC	0x00000010 /* Broadcast Wakeup Enable */
 
 #define IGC_CTRL_ADVD3WUC	0x00100000  /* D3 WUC */
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index ee07011e13e9..69f50b8e2af3 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -308,6 +308,65 @@ static void igc_get_regs(struct net_device *netdev,
 		regs_buff[168 + i] = rd32(IGC_TXDCTL(i));
 }
 
+static void igc_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	wol->wolopts = 0;
+
+	if (!(adapter->flags & IGC_FLAG_WOL_SUPPORTED))
+		return;
+
+	wol->supported = WAKE_UCAST | WAKE_MCAST |
+			 WAKE_BCAST | WAKE_MAGIC |
+			 WAKE_PHY;
+
+	/* apply any specific unsupported masks here */
+	switch (adapter->hw.device_id) {
+	default:
+		break;
+	}
+
+	if (adapter->wol & IGC_WUFC_EX)
+		wol->wolopts |= WAKE_UCAST;
+	if (adapter->wol & IGC_WUFC_MC)
+		wol->wolopts |= WAKE_MCAST;
+	if (adapter->wol & IGC_WUFC_BC)
+		wol->wolopts |= WAKE_BCAST;
+	if (adapter->wol & IGC_WUFC_MAG)
+		wol->wolopts |= WAKE_MAGIC;
+	if (adapter->wol & IGC_WUFC_LNKC)
+		wol->wolopts |= WAKE_PHY;
+}
+
+static int igc_set_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
+{
+	struct igc_adapter *adapter = netdev_priv(netdev);
+
+	if (wol->wolopts & (WAKE_ARP | WAKE_MAGICSECURE | WAKE_FILTER))
+		return -EOPNOTSUPP;
+
+	if (!(adapter->flags & IGC_FLAG_WOL_SUPPORTED))
+		return wol->wolopts ? -EOPNOTSUPP : 0;
+
+	/* these settings will always override what we currently have */
+	adapter->wol = 0;
+
+	if (wol->wolopts & WAKE_UCAST)
+		adapter->wol |= IGC_WUFC_EX;
+	if (wol->wolopts & WAKE_MCAST)
+		adapter->wol |= IGC_WUFC_MC;
+	if (wol->wolopts & WAKE_BCAST)
+		adapter->wol |= IGC_WUFC_BC;
+	if (wol->wolopts & WAKE_MAGIC)
+		adapter->wol |= IGC_WUFC_MAG;
+	if (wol->wolopts & WAKE_PHY)
+		adapter->wol |= IGC_WUFC_LNKC;
+	device_set_wakeup_enable(&adapter->pdev->dev, adapter->wol);
+
+	return 0;
+}
+
 static u32 igc_get_msglevel(struct net_device *netdev)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -1859,6 +1918,8 @@ static const struct ethtool_ops igc_ethtool_ops = {
 	.get_drvinfo		= igc_get_drvinfo,
 	.get_regs_len		= igc_get_regs_len,
 	.get_regs		= igc_get_regs,
+	.get_wol		= igc_get_wol,
+	.set_wol		= igc_set_wol,
 	.get_msglevel		= igc_get_msglevel,
 	.set_msglevel		= igc_set_msglevel,
 	.nway_reset		= igc_nway_reset,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index e982b5f54dc9..69fa1ce1f927 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4789,6 +4789,16 @@ static int igc_probe(struct pci_dev *pdev,
 	hw->fc.requested_mode = igc_fc_default;
 	hw->fc.current_mode = igc_fc_default;
 
+	/* By default, support wake on port A */
+	adapter->flags |= IGC_FLAG_WOL_SUPPORTED;
+
+	/* initialize the wol settings based on the eeprom settings */
+	if (adapter->flags & IGC_FLAG_WOL_SUPPORTED)
+		adapter->wol |= IGC_WUFC_MAG;
+
+	device_set_wakeup_enable(&adapter->pdev->dev,
+				 adapter->flags & IGC_FLAG_WOL_SUPPORTED);
+
 	/* reset the hardware with the new settings */
 	igc_reset(adapter);
 
-- 
2.24.1

