Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D3C13003B
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 03:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgADCt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 21:49:58 -0500
Received: from mga12.intel.com ([192.55.52.136]:64695 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbgADCt5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 21:49:57 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 18:49:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="369757867"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga004.jf.intel.com with ESMTP; 03 Jan 2020 18:49:54 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Michal Swiatkowski <michal.swiatkowski@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/16] ice: Return error on not supported ethtool -C parameters
Date:   Fri,  3 Jan 2020 18:49:44 -0800
Message-Id: <20200104024953.2336731-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
References: <20200104024953.2336731-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@intel.com>

Check for all unused parameters, if ethtool sent one of them,
print info about that and return error.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 50 ++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index b815f1df5698..f395457b728f 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3587,6 +3587,53 @@ ice_set_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
 	return 0;
 }
 
+/**
+ * ice_is_coalesce_param_invalid - check for unsupported coalesce parameters
+ * @netdev: pointer to the netdev associated with this query
+ * @ec: ethtool structure to fill with driver's coalesce settings
+ *
+ * Print netdev info if driver doesn't support one of the parameters
+ * and return error. When any parameters will be implemented, remove only
+ * this parameter from param array.
+ */
+static int
+ice_is_coalesce_param_invalid(struct net_device *netdev,
+			      struct ethtool_coalesce *ec)
+{
+	struct ice_ethtool_not_used {
+		u32 value;
+		const char *name;
+	} param[] = {
+		{ec->stats_block_coalesce_usecs, "stats-block-usecs"},
+		{ec->rate_sample_interval, "sample-interval"},
+		{ec->pkt_rate_low, "pkt-rate-low"},
+		{ec->pkt_rate_high, "pkt-rate-high"},
+		{ec->rx_max_coalesced_frames, "rx-frames"},
+		{ec->rx_coalesce_usecs_irq, "rx-usecs-irq"},
+		{ec->rx_max_coalesced_frames_irq, "rx-frames-irq"},
+		{ec->tx_max_coalesced_frames, "tx-frames"},
+		{ec->tx_coalesce_usecs_irq, "tx-usecs-irq"},
+		{ec->tx_max_coalesced_frames_irq, "tx-frames-irq"},
+		{ec->rx_coalesce_usecs_low, "rx-usecs-low"},
+		{ec->rx_max_coalesced_frames_low, "rx-frames-low"},
+		{ec->tx_coalesce_usecs_low, "tx-usecs-low"},
+		{ec->tx_max_coalesced_frames_low, "tx-frames-low"},
+		{ec->rx_max_coalesced_frames_high, "rx-frames-high"},
+		{ec->tx_max_coalesced_frames_high, "tx-frames-high"}
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(param); i++) {
+		if (param[i].value) {
+			netdev_info(netdev, "Setting %s not supported\n",
+				    param[i].name);
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * __ice_set_coalesce - set ITR/INTRL values for the device
  * @netdev: pointer to the netdev associated with this query
@@ -3603,6 +3650,9 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 
+	if (ice_is_coalesce_param_invalid(netdev, ec))
+		return -EINVAL;
+
 	if (q_num < 0) {
 		int v_idx;
 
-- 
2.24.1

