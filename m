Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13921DA604
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 02:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgETAEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 20:04:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:15429 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgETAEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 20:04:32 -0400
IronPort-SDR: gtxW049GZ2KUMFuOEkbKTqLMgj8Eeg+szn4M+58lEoI15uPRhCWz85WsNd6orxGOmCVQ87VAht
 A1IUrQffaexQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2020 17:04:23 -0700
IronPort-SDR: Id7FORvO5+iDQmRMa7YD/7d2HdoK9vop9yEYyvKOnIvyW9D4xPeAjyTQfz23WODzF0nvzUEWMs
 F1CgCq5zJiYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,411,1583222400"; 
   d="scan'208";a="466324781"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga006.fm.intel.com with ESMTP; 19 May 2020 17:04:22 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/14] igc: Refactor VLAN priority filtering code
Date:   Tue, 19 May 2020 17:04:12 -0700
Message-Id: <20200520000419.1595788-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
References: <20200520000419.1595788-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The whole VLAN priority filtering code is implemented in igc_ethtool.c
and mixes logic from ethtool and core parts. This patch refactors it so
core logic is moved to igc_main.c, aligning the VLAN priority filtering
code organization with the MAC address filtering code.

This patch also takes the opportunity to add some log messages to ease
debugging.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  3 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 64 ++++----------------
 drivers/net/ethernet/intel/igc/igc_main.c    | 52 ++++++++++++++++
 3 files changed, 68 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 661dc8875f3f..5f1e1d31e832 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -235,6 +235,9 @@ int igc_add_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		       const s8 queue, const u8 flags);
 int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 		       const u8 flags);
+int igc_add_vlan_prio_filter(struct igc_adapter *adapter, int prio,
+			     int queue);
+void igc_del_vlan_prio_filter(struct igc_adapter *adapter, int prio);
 void igc_update_stats(struct igc_adapter *adapter);
 
 /* igc_dump declarations */
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index f28f7feb39a5..c5be8b936963 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1223,35 +1223,6 @@ static int igc_rxnfc_write_etype_filter(struct igc_adapter *adapter,
 	return 0;
 }
 
-static int igc_rxnfc_write_vlan_prio_filter(struct igc_adapter *adapter,
-					    struct igc_nfc_filter *input)
-{
-	struct igc_hw *hw = &adapter->hw;
-	u8 vlan_priority;
-	u16 queue_index;
-	u32 vlapqf;
-
-	vlapqf = rd32(IGC_VLANPQF);
-	vlan_priority = (ntohs(input->filter.vlan_tci) & VLAN_PRIO_MASK)
-				>> VLAN_PRIO_SHIFT;
-	queue_index = (vlapqf >> (vlan_priority * 4)) & IGC_VLANPQF_QUEUE_MASK;
-
-	/* check whether this VLAN prio is already set */
-	if (vlapqf & IGC_VLANPQF_VALID(vlan_priority) &&
-	    queue_index != input->action) {
-		netdev_err(adapter->netdev,
-			   "ethtool rxnfc set VLAN prio filter failed\n");
-		return -EEXIST;
-	}
-
-	vlapqf |= IGC_VLANPQF_VALID(vlan_priority);
-	vlapqf |= IGC_VLANPQF_QSEL(vlan_priority, input->action);
-
-	wr32(IGC_VLANPQF, vlapqf);
-
-	return 0;
-}
-
 int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 {
 	struct igc_hw *hw = &adapter->hw;
@@ -1285,10 +1256,15 @@ int igc_add_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 			return err;
 	}
 
-	if (input->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI)
-		err = igc_rxnfc_write_vlan_prio_filter(adapter, input);
+	if (input->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
+		int prio = (ntohs(input->filter.vlan_tci) & VLAN_PRIO_MASK) >>
+			   VLAN_PRIO_SHIFT;
+		err = igc_add_vlan_prio_filter(adapter, prio, input->action);
+		if (err)
+			return err;
+	}
 
-	return err;
+	return 0;
 }
 
 static void igc_clear_etype_filter_regs(struct igc_adapter *adapter,
@@ -1306,31 +1282,17 @@ static void igc_clear_etype_filter_regs(struct igc_adapter *adapter,
 	adapter->etype_bitmap[reg_index] = false;
 }
 
-static void igc_clear_vlan_prio_filter(struct igc_adapter *adapter,
-				       u16 vlan_tci)
-{
-	struct igc_hw *hw = &adapter->hw;
-	u8 vlan_priority;
-	u32 vlapqf;
-
-	vlan_priority = (vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
-
-	vlapqf = rd32(IGC_VLANPQF);
-	vlapqf &= ~IGC_VLANPQF_VALID(vlan_priority);
-	vlapqf &= ~IGC_VLANPQF_QSEL(vlan_priority, IGC_VLANPQF_QUEUE_MASK);
-
-	wr32(IGC_VLANPQF, vlapqf);
-}
-
 int igc_erase_filter(struct igc_adapter *adapter, struct igc_nfc_filter *input)
 {
 	if (input->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE)
 		igc_clear_etype_filter_regs(adapter,
 					    input->etype_reg_index);
 
-	if (input->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI)
-		igc_clear_vlan_prio_filter(adapter,
-					   ntohs(input->filter.vlan_tci));
+	if (input->filter.match_flags & IGC_FILTER_FLAG_VLAN_TCI) {
+		int prio = (ntohs(input->filter.vlan_tci) & VLAN_PRIO_MASK) >>
+			   VLAN_PRIO_SHIFT;
+		igc_del_vlan_prio_filter(adapter, prio);
+	}
 
 	if (input->filter.match_flags & IGC_FILTER_FLAG_SRC_MAC_ADDR)
 		igc_del_mac_filter(adapter, input->filter.src_addr,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 125026d053eb..7e59c0393dbc 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2314,6 +2314,58 @@ int igc_del_mac_filter(struct igc_adapter *adapter, const u8 *addr,
 	return 0;
 }
 
+/**
+ * igc_add_vlan_prio_filter() - Add VLAN priority filter
+ * @adapter: Pointer to adapter where the filter should be added
+ * @prio: VLAN priority value
+ * @queue: Queue number which matching frames are assigned to
+ *
+ * Return: 0 in case of success, negative errno code otherwise.
+ */
+int igc_add_vlan_prio_filter(struct igc_adapter *adapter, int prio, int queue)
+{
+	struct net_device *dev = adapter->netdev;
+	struct igc_hw *hw = &adapter->hw;
+	u32 vlanpqf;
+
+	vlanpqf = rd32(IGC_VLANPQF);
+
+	if (vlanpqf & IGC_VLANPQF_VALID(prio)) {
+		netdev_dbg(dev, "VLAN priority filter already in use\n");
+		return -EEXIST;
+	}
+
+	vlanpqf |= IGC_VLANPQF_QSEL(prio, queue);
+	vlanpqf |= IGC_VLANPQF_VALID(prio);
+
+	wr32(IGC_VLANPQF, vlanpqf);
+
+	netdev_dbg(dev, "Add VLAN priority filter: prio %d queue %d\n",
+		   prio, queue);
+	return 0;
+}
+
+/**
+ * igc_del_vlan_prio_filter() - Delete VLAN priority filter
+ * @adapter: Pointer to adapter where the filter should be deleted from
+ * @prio: VLAN priority value
+ */
+void igc_del_vlan_prio_filter(struct igc_adapter *adapter, int prio)
+{
+	struct igc_hw *hw = &adapter->hw;
+	u32 vlanpqf;
+
+	vlanpqf = rd32(IGC_VLANPQF);
+
+	vlanpqf &= ~IGC_VLANPQF_VALID(prio);
+	vlanpqf &= ~IGC_VLANPQF_QSEL(prio, IGC_VLANPQF_QUEUE_MASK);
+
+	wr32(IGC_VLANPQF, vlanpqf);
+
+	netdev_dbg(adapter->netdev, "Delete VLAN priority filter: prio %d\n",
+		   prio);
+}
+
 static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
-- 
2.26.2

