Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168714D396D
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237112AbiCITED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236107AbiCITEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:04:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5667DB0D17
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852579; x=1678388579;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ThiNWe3KIHqvfqvs0hulEqbvut2M0BaLgA8i2NMpMw=;
  b=hFJdwOzLQFPbOflrpAYqwyTKBC5ZskWW8dhtW9Ej/Tcq/Ge4fdhV6HNT
   T6rYaaH/5/GJS9beikw3lYvlSHodv68wucVI86X0uuW1RDFXLuDmyqECV
   EUMypG3NrQQaEYD+Vl24cB52DuGlRvxkidoGbiLpYQn8sxx5P+XK1tR4i
   hlWpWM299M+6QnzZE4zQLGwbXfXsGdjxx719HE+I4UOjA7bkos/kgBvK2
   m7Rfy+i9lpk9h5b/lI2dofE+sdtsQmGnuNkSU2Q2OS5BSIzeMZoPVK5W4
   b3V6IXz5bMG+wC6lcoT7QwTUE0rpHNCr2Idx7S92xQVfHfBWGvpYnlHOD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="341494154"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="341494154"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:02:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="781188753"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2022 11:02:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Subject: [PATCH net-next 2/5] ice: Add slow path offload stats on port representor in switchdev
Date:   Wed,  9 Mar 2022 11:03:12 -0800
Message-Id: <20220309190315.1380414-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
References: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Implement callbacks to check for stats and fetch port representor stats.
Stats are taken from RX/TX ring corresponding to port representor and show
the number of bytes/packets that were not offloaded.

To see slow path stats run:
ifstat -x cpu_hits -a

Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      |  3 ++
 drivers/net/ethernet/intel/ice/ice_main.c |  6 +--
 drivers/net/ethernet/intel/ice/ice_repr.c | 55 +++++++++++++++++++++++
 3 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index dc42ff92dbad..f9ebd6084474 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -833,6 +833,9 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf);
 int ice_vsi_recfg_qs(struct ice_vsi *vsi, int new_rx, int new_tx);
 void ice_update_vsi_stats(struct ice_vsi *vsi);
 void ice_update_pf_stats(struct ice_pf *pf);
+void
+ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp,
+			     struct ice_q_stats stats, u64 *pkts, u64 *bytes);
 int ice_up(struct ice_vsi *vsi);
 int ice_down(struct ice_vsi *vsi);
 int ice_vsi_cfg(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 289e5c99e313..ca22c60636b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6113,9 +6113,9 @@ int ice_up(struct ice_vsi *vsi)
  * This function fetches stats from the ring considering the atomic operations
  * that needs to be performed to read u64 values in 32 bit machine.
  */
-static void
-ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp, struct ice_q_stats stats,
-			     u64 *pkts, u64 *bytes)
+void
+ice_fetch_u64_stats_per_ring(struct u64_stats_sync *syncp,
+			     struct ice_q_stats stats, u64 *pkts, u64 *bytes)
 {
 	unsigned int start;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 2adfaf21e056..f8db3ca521da 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -142,6 +142,59 @@ ice_repr_get_devlink_port(struct net_device *netdev)
 	return &repr->vf->devlink_port;
 }
 
+/**
+ * ice_repr_sp_stats64 - get slow path stats for port representor
+ * @dev: network interface device structure
+ * @stats: netlink stats structure
+ *
+ * RX/TX stats are being swapped here to be consistent with VF stats. In slow
+ * path, port representor receives data when the corresponding VF is sending it
+ * (and vice versa), TX and RX bytes/packets are effectively swapped on port
+ * representor.
+ */
+static int
+ice_repr_sp_stats64(const struct net_device *dev,
+		    struct rtnl_link_stats64 *stats)
+{
+	struct ice_netdev_priv *np = netdev_priv(dev);
+	int vf_id = np->repr->vf->vf_id;
+	struct ice_tx_ring *tx_ring;
+	struct ice_rx_ring *rx_ring;
+	u64 pkts, bytes;
+
+	tx_ring = np->vsi->tx_rings[vf_id];
+	ice_fetch_u64_stats_per_ring(&tx_ring->syncp, tx_ring->stats,
+				     &pkts, &bytes);
+	stats->rx_packets = pkts;
+	stats->rx_bytes = bytes;
+
+	rx_ring = np->vsi->rx_rings[vf_id];
+	ice_fetch_u64_stats_per_ring(&rx_ring->syncp, rx_ring->stats,
+				     &pkts, &bytes);
+	stats->tx_packets = pkts;
+	stats->tx_bytes = bytes;
+	stats->tx_dropped = rx_ring->rx_stats.alloc_page_failed +
+			    rx_ring->rx_stats.alloc_buf_failed;
+
+	return 0;
+}
+
+static bool
+ice_repr_ndo_has_offload_stats(const struct net_device *dev, int attr_id)
+{
+	return attr_id == IFLA_OFFLOAD_XSTATS_CPU_HIT;
+}
+
+static int
+ice_repr_ndo_get_offload_stats(int attr_id, const struct net_device *dev,
+			       void *sp)
+{
+	if (attr_id == IFLA_OFFLOAD_XSTATS_CPU_HIT)
+		return ice_repr_sp_stats64(dev, (struct rtnl_link_stats64 *)sp);
+
+	return -EINVAL;
+}
+
 static int
 ice_repr_setup_tc_cls_flower(struct ice_repr *repr,
 			     struct flow_cls_offload *flower)
@@ -199,6 +252,8 @@ static const struct net_device_ops ice_repr_netdev_ops = {
 	.ndo_start_xmit = ice_eswitch_port_start_xmit,
 	.ndo_get_devlink_port = ice_repr_get_devlink_port,
 	.ndo_setup_tc = ice_repr_setup_tc,
+	.ndo_has_offload_stats = ice_repr_ndo_has_offload_stats,
+	.ndo_get_offload_stats = ice_repr_ndo_get_offload_stats,
 };
 
 /**
-- 
2.31.1

