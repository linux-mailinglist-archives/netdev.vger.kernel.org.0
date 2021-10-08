Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6932042603D
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241549AbhJGXKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:10:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:15520 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237511AbhJGXKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 19:10:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226340366"
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="226340366"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2021 16:08:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="590344368"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga004.jf.intel.com with ESMTP; 07 Oct 2021 16:08:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        jiri@resnulli.us, ivecera@redhat.com,
        michal.swiatkowski@linux.intel.com, grzegorz.nitka@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 12/12] ice: add port representor ethtool ops and stats
Date:   Thu,  7 Oct 2021 16:06:20 -0700
Message-Id: <20211007230620.3413290-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
References: <20211007230620.3413290-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wojciech Drewek <wojciech.drewek@intel.com>

Introduce the following ethtool operations for VF's representor:
	-get_drvinfo
	-get_strings
	-get_ethtool_stats
	-get_sset_count
	-get_link

In all cases, existing operations were used with minor
changes which allow us to detect if ethtool op was called for
representor. Only VF VSI stats will be available for representor.

Implement ndo_get_stats64 for port representor. This will update
VF VSI stats and read them.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h          | 14 +++++
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c  |  5 ++
 drivers/net/ethernet/intel/ice/ice_ethtool.c  | 55 +++++++++++++++++--
 drivers/net/ethernet/intel/ice/ice_repr.c     | 33 +++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |  4 +-
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  | 14 +++++
 6 files changed, 118 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3399eb777d68..0d44a3767bad 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -615,6 +615,19 @@ static inline struct ice_vsi *ice_get_main_vsi(struct ice_pf *pf)
 	return NULL;
 }
 
+/**
+ * ice_get_netdev_priv_vsi - return VSI associated with netdev priv.
+ * @np: private netdev structure
+ */
+static inline struct ice_vsi *ice_get_netdev_priv_vsi(struct ice_netdev_priv *np)
+{
+	/* In case of port representor return source port VSI. */
+	if (np->repr)
+		return np->repr->src_vsi;
+	else
+		return np->vsi;
+}
+
 /**
  * ice_get_ctrl_vsi - Get the control VSI
  * @pf: PF instance
@@ -670,6 +683,7 @@ int ice_vsi_setup_rx_rings(struct ice_vsi *vsi);
 int ice_vsi_open_ctrl(struct ice_vsi *vsi);
 int ice_vsi_open(struct ice_vsi *vsi);
 void ice_set_ethtool_ops(struct net_device *netdev);
+void ice_set_ethtool_repr_ops(struct net_device *netdev);
 void ice_set_ethtool_safe_mode_ops(struct net_device *netdev);
 u16 ice_get_avail_txq_count(struct ice_pf *pf);
 u16 ice_get_avail_rxq_count(struct ice_pf *pf);
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 26b4d5f579e6..73714685fb68 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -683,6 +683,11 @@ void ice_pf_dcb_recfg(struct ice_pf *pf)
 				vsi->idx);
 			continue;
 		}
+		/* no need to proceed with remaining cfg if it is switchdev
+		 * VSI
+		 */
+		if (vsi->type == ICE_VSI_SWITCHDEV_CTRL)
+			continue;
 
 		ice_vsi_map_rings_to_vectors(vsi);
 		if (vsi->type == ICE_VSI_PF)
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 6f0a29be3ee5..201979cc47fb 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -170,10 +170,9 @@ static const struct ice_priv_flag ice_gstrings_priv_flags[] = {
 #define ICE_PRIV_FLAG_ARRAY_SIZE	ARRAY_SIZE(ice_gstrings_priv_flags)
 
 static void
-ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
+__ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo,
+		  struct ice_vsi *vsi)
 {
-	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
 	struct ice_orom_info *orom;
@@ -196,6 +195,26 @@ ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
 	drvinfo->n_priv_flags = ICE_PRIV_FLAG_ARRAY_SIZE;
 }
 
+static void
+ice_get_drvinfo(struct net_device *netdev, struct ethtool_drvinfo *drvinfo)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+
+	__ice_get_drvinfo(netdev, drvinfo, np->vsi);
+}
+
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
 static int ice_get_regs_len(struct net_device __always_unused *netdev)
 {
 	return sizeof(ice_regs_dump_list);
@@ -869,7 +888,7 @@ ice_self_test(struct net_device *netdev, struct ethtool_test *eth_test,
 static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
+	struct ice_vsi *vsi = ice_get_netdev_priv_vsi(np);
 	unsigned int i;
 	u8 *p = data;
 
@@ -879,6 +898,9 @@ static void ice_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 			ethtool_sprintf(&p,
 					ice_gstrings_vsi_stats[i].stat_string);
 
+		if (ice_is_port_repr_netdev(netdev))
+			return;
+
 		ice_for_each_alloc_txq(vsi, i) {
 			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
 			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
@@ -1308,6 +1330,9 @@ static int ice_get_sset_count(struct net_device *netdev, int sset)
 		 * order of strings will suffer from race conditions and are
 		 * not safe.
 		 */
+		if (ice_is_port_repr_netdev(netdev))
+			return ICE_VSI_STATS_LEN;
+
 		return ICE_ALL_STATS_LEN(netdev);
 	case ETH_SS_TEST:
 		return ICE_TEST_LEN;
@@ -1323,7 +1348,7 @@ ice_get_ethtool_stats(struct net_device *netdev,
 		      struct ethtool_stats __always_unused *stats, u64 *data)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
-	struct ice_vsi *vsi = np->vsi;
+	struct ice_vsi *vsi = ice_get_netdev_priv_vsi(np);
 	struct ice_pf *pf = vsi->back;
 	struct ice_ring *ring;
 	unsigned int j;
@@ -1339,6 +1364,9 @@ ice_get_ethtool_stats(struct net_device *netdev,
 			     sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
 	}
 
+	if (ice_is_port_repr_netdev(netdev))
+		return;
+
 	/* populate per queue stats */
 	rcu_read_lock();
 
@@ -4062,6 +4090,23 @@ void ice_set_ethtool_safe_mode_ops(struct net_device *netdev)
 	netdev->ethtool_ops = &ice_ethtool_safe_mode_ops;
 }
 
+static const struct ethtool_ops ice_ethtool_repr_ops = {
+	.get_drvinfo		= ice_repr_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_strings		= ice_get_strings,
+	.get_ethtool_stats      = ice_get_ethtool_stats,
+	.get_sset_count		= ice_get_sset_count,
+};
+
+/**
+ * ice_set_ethtool_repr_ops - setup VF's port representor ethtool ops
+ * @netdev: network interface device structure
+ */
+void ice_set_ethtool_repr_ops(struct net_device *netdev)
+{
+	netdev->ethtool_ops = &ice_ethtool_repr_ops;
+}
+
 /**
  * ice_set_ethtool_ops - setup netdev ethtool ops
  * @netdev: network interface device structure
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index ee11bfc7bee1..cb83f58d7c71 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -39,6 +39,37 @@ ice_repr_get_phys_port_name(struct net_device *netdev, char *buf, size_t len)
 	return 0;
 }
 
+/**
+ * ice_repr_get_stats64 - get VF stats for VFPR use
+ * @netdev: pointer to port representor netdev
+ * @stats: pointer to struct where stats can be stored
+ */
+static void
+ice_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_eth_stats *eth_stats;
+	struct ice_vsi *vsi;
+
+	if (ice_is_vf_disabled(np->repr->vf))
+		return;
+	vsi = np->repr->src_vsi;
+
+	ice_update_vsi_stats(vsi);
+	eth_stats = &vsi->eth_stats;
+
+	stats->tx_packets = eth_stats->tx_unicast + eth_stats->tx_broadcast +
+			    eth_stats->tx_multicast;
+	stats->rx_packets = eth_stats->rx_unicast + eth_stats->rx_broadcast +
+			    eth_stats->rx_multicast;
+	stats->tx_bytes = eth_stats->tx_bytes;
+	stats->rx_bytes = eth_stats->rx_bytes;
+	stats->multicast = eth_stats->rx_multicast;
+	stats->tx_errors = eth_stats->tx_errors;
+	stats->tx_dropped = eth_stats->tx_discards;
+	stats->rx_dropped = eth_stats->rx_discards;
+}
+
 /**
  * ice_netdev_to_repr - Get port representor for given netdevice
  * @netdev: pointer to port representor netdev
@@ -112,6 +143,7 @@ ice_repr_get_devlink_port(struct net_device *netdev)
 
 static const struct net_device_ops ice_repr_netdev_ops = {
 	.ndo_get_phys_port_name = ice_repr_get_phys_port_name,
+	.ndo_get_stats64 = ice_repr_get_stats64,
 	.ndo_open = ice_repr_open,
 	.ndo_stop = ice_repr_stop,
 	.ndo_start_xmit = ice_eswitch_port_start_xmit,
@@ -136,6 +168,7 @@ ice_repr_reg_netdev(struct net_device *netdev)
 {
 	eth_hw_addr_random(netdev);
 	netdev->netdev_ops = &ice_repr_netdev_ops;
+	ice_set_ethtool_repr_ops(netdev);
 
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 2f5c0215c9b0..4d0b643906ff 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1603,7 +1603,7 @@ bool ice_reset_all_vfs(struct ice_pf *pf, bool is_vflr)
  *
  * Returns true if the PF or VF is disabled, false otherwise.
  */
-static bool ice_is_vf_disabled(struct ice_vf *vf)
+bool ice_is_vf_disabled(struct ice_vf *vf)
 {
 	struct ice_pf *pf = vf->pf;
 
@@ -2841,7 +2841,7 @@ static void ice_wait_on_vf_reset(struct ice_vf *vf)
  * disabled, and initialized so it can be configured and/or queried by a host
  * administrator.
  */
-static int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
+int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
 {
 	struct ice_pf *pf;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 6bad277d16fc..3115284e5411 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -176,6 +176,10 @@ int ice_set_vf_trust(struct net_device *netdev, int vf_id, bool trusted);
 
 int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state);
 
+int ice_check_vf_ready_for_cfg(struct ice_vf *vf);
+
+bool ice_is_vf_disabled(struct ice_vf *vf);
+
 int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena);
 
 int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector);
@@ -211,6 +215,16 @@ static inline void ice_print_vfs_mdd_events(struct ice_pf *pf) { }
 static inline void ice_print_vf_rx_mdd_event(struct ice_vf *vf) { }
 static inline void ice_restore_all_vfs_msi_state(struct pci_dev *pdev) { }
 
+static inline int ice_check_vf_ready_for_cfg(struct ice_vf *vf)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool ice_is_vf_disabled(struct ice_vf *vf)
+{
+	return true;
+}
+
 static inline struct ice_vsi *ice_get_vf_vsi(struct ice_vf *vf)
 {
 	return NULL;
-- 
2.31.1

