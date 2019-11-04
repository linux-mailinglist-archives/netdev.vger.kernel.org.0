Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED7EEB0C
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 22:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729549AbfKDVX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 16:23:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:13957 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729660AbfKDVXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:23:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219715374"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:23:50 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 7/7] i40e: implement VF stats NDO
Date:   Mon,  4 Nov 2019 13:23:48 -0800
Message-Id: <20191104212348.9625-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
References: <20191104212348.9625-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

Implement the VF stats gathering via the kernel via ndo_get_vf_stats().
The driver will show per-VF stats in the output of the command:
ip -s link show dev <PF>

Testing Hints:
ip -s link show dev eth0
will return non-zero VF stats.
...
   vf 0 MAC 00:55:aa:00:55:aa, spoof checking on, link-state enable, trust off
   RX: bytes  packets  mcast   bcast
   128000     1000     104     104
   TX: bytes  packets
   128000     1000

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  1 +
 .../ethernet/intel/i40e/i40e_virtchnl_pf.c    | 48 +++++++++++++++++++
 .../ethernet/intel/i40e/i40e_virtchnl_pf.h    |  2 +
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b3d7edbb1389..9fac1cea6fa5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12870,6 +12870,7 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_set_features	= i40e_set_features,
 	.ndo_set_vf_mac		= i40e_ndo_set_vf_mac,
 	.ndo_set_vf_vlan	= i40e_ndo_set_vf_port_vlan,
+	.ndo_get_vf_stats	= i40e_get_vf_stats,
 	.ndo_set_vf_rate	= i40e_ndo_set_vf_bw,
 	.ndo_get_vf_config	= i40e_ndo_get_vf_config,
 	.ndo_set_vf_link_state	= i40e_ndo_set_vf_link_state,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index a2710664d653..6a3f0fc56c3b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -4524,3 +4524,51 @@ int i40e_ndo_set_vf_trust(struct net_device *netdev, int vf_id, bool setting)
 	clear_bit(__I40E_VIRTCHNL_OP_PENDING, pf->state);
 	return ret;
 }
+
+/**
+ * i40e_get_vf_stats - populate some stats for the VF
+ * @netdev: the netdev of the PF
+ * @vf_id: the host OS identifier (0-127)
+ * @vf_stats: pointer to the OS memory to be initialized
+ */
+int i40e_get_vf_stats(struct net_device *netdev, int vf_id,
+		      struct ifla_vf_stats *vf_stats)
+{
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+	struct i40e_pf *pf = np->vsi->back;
+	struct i40e_eth_stats *stats;
+	struct i40e_vsi *vsi;
+	struct i40e_vf *vf;
+
+	/* validate the request */
+	if (i40e_validate_vf(pf, vf_id))
+		return -EINVAL;
+
+	vf = &pf->vf[vf_id];
+	if (!test_bit(I40E_VF_STATE_INIT, &vf->vf_states)) {
+		dev_err(&pf->pdev->dev, "VF %d in reset. Try again.\n", vf_id);
+		return -EBUSY;
+	}
+
+	vsi = pf->vsi[vf->lan_vsi_idx];
+	if (!vsi)
+		return -EINVAL;
+
+	i40e_update_eth_stats(vsi);
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
diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
index 1ce06240a702..631248c0981a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h
@@ -138,5 +138,7 @@ int i40e_ndo_set_vf_spoofchk(struct net_device *netdev, int vf_id, bool enable);
 
 void i40e_vc_notify_link_state(struct i40e_pf *pf);
 void i40e_vc_notify_reset(struct i40e_pf *pf);
+int i40e_get_vf_stats(struct net_device *netdev, int vf_id,
+		      struct ifla_vf_stats *vf_stats);
 
 #endif /* _I40E_VIRTCHNL_PF_H_ */
-- 
2.21.0

