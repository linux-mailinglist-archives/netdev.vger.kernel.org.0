Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDAAECE97
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 13:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfKBMOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 08:14:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:42775 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfKBMOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 08:14:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 05:14:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,259,1569308400"; 
   d="scan'208";a="204132341"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga003.jf.intel.com with ESMTP; 02 Nov 2019 05:14:20 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 2/7] fm10k: add support for ndo_get_vf_stats operation
Date:   Sat,  2 Nov 2019 05:14:12 -0700
Message-Id: <20191102121417.15421-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
References: <20191102121417.15421-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

Support capturing and reporting statistics for all of the VFs associated
with a given PF device via the ndo_get_vf_stats callback.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/fm10k/fm10k.h      |  3 ++
 drivers/net/ethernet/intel/fm10k/fm10k_iov.c  | 48 +++++++++++++++++++
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  1 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  3 ++
 drivers/net/ethernet/intel/fm10k/fm10k_type.h |  1 +
 5 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k.h b/drivers/net/ethernet/intel/fm10k/fm10k.h
index b14441944b4b..f306084ca12c 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k.h
@@ -534,6 +534,7 @@ void fm10k_iov_suspend(struct pci_dev *pdev);
 int fm10k_iov_resume(struct pci_dev *pdev);
 void fm10k_iov_disable(struct pci_dev *pdev);
 int fm10k_iov_configure(struct pci_dev *pdev, int num_vfs);
+void fm10k_iov_update_stats(struct fm10k_intfc *interface);
 s32 fm10k_iov_update_pvid(struct fm10k_intfc *interface, u16 glort, u16 pvid);
 int fm10k_ndo_set_vf_mac(struct net_device *netdev, int vf_idx, u8 *mac);
 int fm10k_ndo_set_vf_vlan(struct net_device *netdev,
@@ -542,6 +543,8 @@ int fm10k_ndo_set_vf_bw(struct net_device *netdev, int vf_idx,
 			int __always_unused min_rate, int max_rate);
 int fm10k_ndo_get_vf_config(struct net_device *netdev,
 			    int vf_idx, struct ifla_vf_info *ivi);
+int fm10k_ndo_get_vf_stats(struct net_device *netdev,
+			   int vf_idx, struct ifla_vf_stats *stats);
 
 /* DebugFS */
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_iov.c b/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
index afe1fafd2447..8c50a128df29 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_iov.c
@@ -520,6 +520,27 @@ int fm10k_iov_configure(struct pci_dev *pdev, int num_vfs)
 	return num_vfs;
 }
 
+/**
+ * fm10k_iov_update_stats - Update stats for all VFs
+ * @interface: device private structure
+ *
+ * Updates the VF statistics for all enabled VFs. Expects to be called by
+ * fm10k_update_stats and assumes that locking via the __FM10K_UPDATING_STATS
+ * bit is already handled.
+ */
+void fm10k_iov_update_stats(struct fm10k_intfc *interface)
+{
+	struct fm10k_iov_data *iov_data = interface->iov_data;
+	struct fm10k_hw *hw = &interface->hw;
+	int i;
+
+	if (!iov_data)
+		return;
+
+	for (i = 0; i < iov_data->num_vfs; i++)
+		hw->iov.ops.update_stats(hw, iov_data->vf_info[i].stats, i);
+}
+
 static inline void fm10k_reset_vf_info(struct fm10k_intfc *interface,
 				       struct fm10k_vf_info *vf_info)
 {
@@ -650,3 +671,30 @@ int fm10k_ndo_get_vf_config(struct net_device *netdev,
 
 	return 0;
 }
+
+int fm10k_ndo_get_vf_stats(struct net_device *netdev,
+			   int vf_idx, struct ifla_vf_stats *stats)
+{
+	struct fm10k_intfc *interface = netdev_priv(netdev);
+	struct fm10k_iov_data *iov_data = interface->iov_data;
+	struct fm10k_hw *hw = &interface->hw;
+	struct fm10k_hw_stats_q *hw_stats;
+	u32 idx, qpp;
+
+	/* verify SR-IOV is active and that vf idx is valid */
+	if (!iov_data || vf_idx >= iov_data->num_vfs)
+		return -EINVAL;
+
+	qpp = fm10k_queues_per_pool(hw);
+	hw_stats = iov_data->vf_info[vf_idx].stats;
+
+	for (idx = 0; idx < qpp; idx++) {
+		stats->rx_packets += hw_stats[idx].rx_packets.count;
+		stats->tx_packets += hw_stats[idx].tx_packets.count;
+		stats->rx_bytes += hw_stats[idx].rx_bytes.count;
+		stats->tx_bytes += hw_stats[idx].tx_bytes.count;
+		stats->rx_dropped += hw_stats[idx].rx_drops.count;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 09f7a246e134..68baee04dc58 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1643,6 +1643,7 @@ static const struct net_device_ops fm10k_netdev_ops = {
 	.ndo_set_vf_vlan	= fm10k_ndo_set_vf_vlan,
 	.ndo_set_vf_rate	= fm10k_ndo_set_vf_bw,
 	.ndo_get_vf_config	= fm10k_ndo_get_vf_config,
+	.ndo_get_vf_stats	= fm10k_ndo_get_vf_stats,
 	.ndo_udp_tunnel_add	= fm10k_udp_tunnel_add,
 	.ndo_udp_tunnel_del	= fm10k_udp_tunnel_del,
 	.ndo_dfwd_add_station	= fm10k_dfwd_add_station,
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index bb236fa44048..d122d0087191 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -630,6 +630,9 @@ void fm10k_update_stats(struct fm10k_intfc *interface)
 	net_stats->rx_errors = rx_errors;
 	net_stats->rx_dropped = interface->stats.nodesc_drop.count;
 
+	/* Update VF statistics */
+	fm10k_iov_update_stats(interface);
+
 	clear_bit(__FM10K_UPDATING_STATS, interface->state);
 }
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_type.h b/drivers/net/ethernet/intel/fm10k/fm10k_type.h
index 15ac1c7885bc..63968c5d7c5d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_type.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_type.h
@@ -581,6 +581,7 @@ struct fm10k_vf_info {
 	 * at the same offset as the mailbox
 	 */
 	struct fm10k_mbx_info	mbx;		/* PF side of VF mailbox */
+	struct fm10k_hw_stats_q	stats[FM10K_MAX_QUEUES_POOL];
 	int			rate;		/* Tx BW cap as defined by OS */
 	u16			glort;		/* resource tag for this VF */
 	u16			sw_vid;		/* Switch API assigned VLAN */
-- 
2.21.0

