Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756AB104CDB
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfKUHqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:46:37 -0500
Received: from mga12.intel.com ([192.55.52.136]:4522 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbfKUHqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:46:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 23:46:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="216077568"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by fmsmga001.fm.intel.com with ESMTP; 20 Nov 2019 23:46:16 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/15] ice: implement VF stats NDO
Date:   Wed, 20 Nov 2019 23:46:09 -0800
Message-Id: <20191121074612.3055661-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
References: <20191121074612.3055661-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Implement the VF stats gathering via the kernel via ndo_get_vf_stats().
The driver will show per-VF stats in the output of the
ip -s link show dev <PF> command.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c     |  1 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  | 45 +++++++++++++++++++
 .../net/ethernet/intel/ice/ice_virtchnl_pf.h  | 11 +++++
 3 files changed, 57 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ea577588b274..d282eb05c2e0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5219,6 +5219,7 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_set_vf_trust = ice_set_vf_trust,
 	.ndo_set_vf_vlan = ice_set_vf_port_vlan,
 	.ndo_set_vf_link_state = ice_set_vf_link_state,
+	.ndo_get_vf_stats = ice_get_vf_stats,
 	.ndo_vlan_rx_add_vid = ice_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid = ice_vlan_rx_kill_vid,
 	.ndo_set_features = ice_set_features,
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index aa99d7cb7d8e..edb374296d1f 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3391,3 +3391,48 @@ int ice_set_vf_link_state(struct net_device *netdev, int vf_id, int link_state)
 
 	return 0;
 }
+
+/**
+ * ice_get_vf_stats - populate some stats for the VF
+ * @netdev: the netdev of the PF
+ * @vf_id: the host OS identifier (0-255)
+ * @vf_stats: pointer to the OS memory to be initialized
+ */
+int ice_get_vf_stats(struct net_device *netdev, int vf_id,
+		     struct ifla_vf_stats *vf_stats)
+{
+	struct ice_pf *pf = ice_netdev_to_pf(netdev);
+	struct ice_eth_stats *stats;
+	struct ice_vsi *vsi;
+	struct ice_vf *vf;
+
+	if (ice_validate_vf_id(pf, vf_id))
+		return -EINVAL;
+
+	vf = &pf->vf[vf_id];
+
+	if (ice_check_vf_init(pf, vf))
+		return -EBUSY;
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	if (!vsi)
+		return -EINVAL;
+
+	ice_update_eth_stats(vsi);
+	stats = &vsi->eth_stats;
+
+	memset(vf_stats, 0, sizeof(*vf_stats));
+
+	vf_stats->rx_packets = stats->rx_unicast + stats->rx_broadcast +
+		stats->rx_multicast;
+	vf_stats->tx_packets = stats->tx_unicast + stats->tx_broadcast +
+		stats->tx_multicast;
+	vf_stats->rx_bytes   = stats->rx_bytes;
+	vf_stats->tx_bytes   = stats->tx_bytes;
+	vf_stats->broadcast  = stats->rx_broadcast;
+	vf_stats->multicast  = stats->rx_multicast;
+	vf_stats->rx_dropped = stats->rx_discards;
+	vf_stats->tx_dropped = stats->tx_discards;
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
index 2e867ad2e81d..88aa65d5cb31 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
@@ -122,6 +122,9 @@ int ice_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool ena);
 int ice_calc_vf_reg_idx(struct ice_vf *vf, struct ice_q_vector *q_vector);
 
 void ice_set_vf_state_qs_dis(struct ice_vf *vf);
+int
+ice_get_vf_stats(struct net_device *netdev, int vf_id,
+		 struct ifla_vf_stats *vf_stats);
 #else /* CONFIG_PCI_IOV */
 #define ice_process_vflr_event(pf) do {} while (0)
 #define ice_free_vfs(pf) do {} while (0)
@@ -194,5 +197,13 @@ ice_calc_vf_reg_idx(struct ice_vf __always_unused *vf,
 {
 	return 0;
 }
+
+static inline int
+ice_get_vf_stats(struct net_device __always_unused *netdev,
+		 int __always_unused vf_id,
+		 struct ifla_vf_stats __always_unused *vf_stats)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_PCI_IOV */
 #endif /* _ICE_VIRTCHNL_PF_H_ */
-- 
2.23.0

