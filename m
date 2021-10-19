Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F069433E7C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234876AbhJSSef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:34:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:51642 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234531AbhJSSeb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:34:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="226058564"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="226058564"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 11:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="444602719"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2021 11:32:16 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 07/10] ice: Refactor PR ethtool ops
Date:   Tue, 19 Oct 2021 11:30:24 -0700
Message-Id: <20211019183027.2820413-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
References: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

This patch improves a few things:

- it fixes issue where ethtool -i reports that PR supports
  priv-flags and tests when in fact it does not support them
- instead of using the same functions for both PF and PR ethtool ops,
  this patch introduces separate ops for both cases and internal
  functions with core logic.
- prevent accessing VF VSI while VF is not ready by calling
  ice_check_vf_ready_for_cfg
- all PR specific functions in ethtool.c were moved to one place in
  file
- instead overwriting n_priv_flags in ice_repr_get_drvinfo,
  priv-flags code was moved from __ice_get_drvinfo to ice_get_drvinfo

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 99 +++++++++++++++-----
 1 file changed, 74 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f4b3c5b73c7d..8b3eef6632e9 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -192,7 +192,6 @@ __ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo,
 
 	strscpy(drvinfo->bus_info, pci_name(pf->pdev),
 		sizeof(drvinfo->bus_info));
-	drvinfo->n_priv_flags = ICE_PRIV_FLAG_ARRAY_SIZE;
 }
 
 static void
@@ -201,18 +200,8 @@ ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 
 	__ice_get_drvinfo(netdev, drvinfo, np->vsi);
-}
-
-static void
-ice_repr_get_drvinfo(struct net_device *netdev,
-		     struct ethtool_drvinfo *drvinfo)
-{
-	struct ice_repr *repr = ice_netdev_to_repr(netdev);
 
-	if (ice_check_vf_ready_for_cfg(repr->vf))
-		return;
-
-	__ice_get_drvinfo(netdev, drvinfo, repr->src_vsi);
+	drvinfo->n_priv_flags = ICE_PRIV_FLAG_ARRAY_SIZE;
 }
 
 static int ice_get_regs_len(struct net_device __always_unused *netdev)
@@ -886,10 +875,10 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 	netdev_info(netdev, "testing finished\n");
 }
 
-static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
+static void
+__ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data,
+		  struct ice_vsi *vsi)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = ice_get_netdev_priv_vsi(np);
 	unsigned int i;
 	u8 *p = data;
 
@@ -940,6 +929,13 @@ static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	}
 }
 
+static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+
+	__ice_get_strings(netdev, stringset, data, np->vsi);
+}
+
 static int
 ice_set_phys_id(struct net_device *netdev, enum ethtool_phys_id_state state)
 {
@@ -1331,9 +1327,6 @@ static int ice_get_sset_count(struct net_device *netdev, int sset)
 		 * order of strings will suffer from race conditions and are
 		 * not safe.
 		 */
-		if (ice_is_port_repr_netdev(netdev))
-			return ICE_VSI_STATS_LEN;
-
 		return ICE_ALL_STATS_LEN(netdev);
 	case ETH_SS_TEST:
 		return ICE_TEST_LEN;
@@ -1345,11 +1338,10 @@ static int ice_get_sset_count(struct net_device *netdev, int sset)
 }
 
 static void
-ice_get_ethtool_stats(struct net_device *netdev,
-		      struct ethtool_stats __always_unused *stats, u64 *data)
+__ice_get_ethtool_stats(struct net_device *netdev,
+			struct ethtool_stats __always_unused *stats, u64 *data,
+			struct ice_vsi *vsi)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = ice_get_netdev_priv_vsi(np);
 	struct ice_pf *pf = vsi->back;
 	struct ice_tx_ring *tx_ring;
 	struct ice_rx_ring *rx_ring;
@@ -1416,6 +1408,15 @@ ice_get_ethtool_stats(struct net_device *netdev,
 	}
 }
 
+static void
+ice_get_ethtool_stats(struct net_device *netdev,
+		      struct ethtool_stats __always_unused *stats, u64 *data)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+
+	__ice_get_ethtool_stats(netdev, stats, data, np->vsi);
+}
+
 #define ICE_PHY_TYPE_LOW_MASK_MIN_1G	(ICE_PHY_TYPE_LOW_100BASE_TX | \
 					 ICE_PHY_TYPE_LOW_100M_SGMII)
 
@@ -3839,6 +3840,54 @@ ice_set_per_q_coalesce(struct net_device *netdev, u32 q_num,
 	return __ice_set_coalesce(netdev, ec, q_num);
 }
 
+static void
+ice_repr_get_drvinfo(struct net_device *netdev,
+		     struct ethtool_drvinfo *drvinfo)
+{
+	struct ice_repr *repr = ice_netdev_to_repr(netdev);
+
+	if (ice_check_vf_ready_for_cfg(repr->vf))
+		return;
+
+	__ice_get_drvinfo(netdev, drvinfo, repr->src_vsi);
+}
+
+static void
+ice_repr_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
+{
+	struct ice_repr *repr = ice_netdev_to_repr(netdev);
+
+	/* for port representors only ETH_SS_STATS is supported */
+	if (ice_check_vf_ready_for_cfg(repr->vf) ||
+	    stringset != ETH_SS_STATS)
+		return;
+
+	__ice_get_strings(netdev, stringset, data, repr->src_vsi);
+}
+
+static void
+ice_repr_get_ethtool_stats(struct net_device *netdev,
+			   struct ethtool_stats __always_unused *stats,
+			   u64 *data)
+{
+	struct ice_repr *repr = ice_netdev_to_repr(netdev);
+
+	if (ice_check_vf_ready_for_cfg(repr->vf))
+		return;
+
+	__ice_get_ethtool_stats(netdev, stats, data, repr->src_vsi);
+}
+
+static int ice_repr_get_sset_count(struct net_device *netdev, int sset)
+{
+	switch (sset) {
+	case ETH_SS_STATS:
+		return ICE_VSI_STATS_LEN;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 #define ICE_I2C_EEPROM_DEV_ADDR		0xA0
 #define ICE_I2C_EEPROM_DEV_ADDR2	0xA2
 #define ICE_MODULE_TYPE_SFP		0x03
@@ -4093,9 +4142,9 @@ void ice_set_ethtool_safe_mode_ops(struct net_device *netdev)
 static const struct ethtool_ops ice_ethtool_repr_ops = {
 	.get_drvinfo		= ice_repr_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
-	.get_strings		= ice_get_strings,
-	.get_ethtool_stats      = ice_get_ethtool_stats,
-	.get_sset_count		= ice_get_sset_count,
+	.get_strings		= ice_repr_get_strings,
+	.get_ethtool_stats      = ice_repr_get_ethtool_stats,
+	.get_sset_count		= ice_repr_get_sset_count,
 };
 
 /**
-- 
2.31.1

