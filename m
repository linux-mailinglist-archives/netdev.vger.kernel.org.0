Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E55636E17
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiKWXGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKWXGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:06:36 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E556153394
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244792; x=1700780792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TeOKMU9AIb7HXDsArofwYk7IQ9FeIb1FAvagXSKHnbY=;
  b=hFK2nul3YeeRORYEEI57jXLi4dmQzl0JqUDZMcb/o1ORsHFrqETWBrQk
   UY+LFmkDfYTfTqwm9P6Ue8Qs2+KxwFRZnXT/NTZbenUZqrmWkZn1vMx+m
   mE0W8mPg3NWiJgmJl/qIDl8pzvxJViDqLQOgzzX8bvsmbAs8s6/GkPa4r
   oQGlxAECIN5S1UYSG/dVp6IOLsThTe05bMuSZHGb6h63SiE6PP+vCgxg8
   9Q/9xpwkmpfD6SuEqPcOMiofNDmpboHVOtfep/BT0V/SE1gFzA4jOLJKw
   H7VByv2G5MDcjHep7v8dFoKzt5IizUR9HroTtdTWFh/falS3z+o7nJ4KF
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="376318632"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="376318632"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:06:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705531277"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="705531277"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 15:06:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Benjamin Mikailenko <benjamin.mikailenko@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 3/6] ice: Accumulate HW and Netdev statistics over reset
Date:   Wed, 23 Nov 2022 15:06:18 -0800
Message-Id: <20221123230621.3562805-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
References: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Mikailenko <benjamin.mikailenko@intel.com>

Resets happen with or without user interaction. For example, incidents
such as TX hang or a reconfiguration of parameters will result in a reset.
During reset, hardware and software statistics were set to zero. This
created an issue for the user where a reset happens in the background,
statistics set to zero, and the user checks statistics expecting them to
be populated.

To ensure this doesn't happen, keep accumulating stats over reset.

1. Remove function calls which reset hardware and netdev statistics.
2. Do not rollover statistics in ice_stat_update40 during reset.

Signed-off-by: Benjamin Mikailenko <benjamin.mikailenko@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  1 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c |  3 ++
 drivers/net/ethernet/intel/ice/ice_lib.c     |  7 +++++
 drivers/net/ethernet/intel/ice/ice_main.c    | 30 +++++++++++++++++---
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index f88ee051e71c..74d40a766664 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -373,6 +373,7 @@ struct ice_vsi {
 
 	/* VSI stats */
 	struct rtnl_link_stats64 net_stats;
+	struct rtnl_link_stats64 net_stats_prev;
 	struct ice_eth_stats eth_stats;
 	struct ice_eth_stats eth_stats_prev;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
index 9defb9d0fe88..4f24d441c35e 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_lib.c
@@ -881,6 +881,9 @@ void ice_update_dcb_stats(struct ice_pf *pf)
 	prev_ps = &pf->stats_prev;
 	cur_ps = &pf->stats;
 
+	if (ice_is_reset_in_progress(pf->state))
+		pf->stat_prev_loaded = false;
+
 	for (i = 0; i < 8; i++) {
 		ice_stat_update32(hw, GLPRT_PXOFFRXC(port, i),
 				  pf->stat_prev_loaded,
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index a2cfa0c614ce..ffb455e1f3dc 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1795,11 +1795,15 @@ void ice_update_eth_stats(struct ice_vsi *vsi)
 {
 	struct ice_eth_stats *prev_es, *cur_es;
 	struct ice_hw *hw = &vsi->back->hw;
+	struct ice_pf *pf = vsi->back;
 	u16 vsi_num = vsi->vsi_num;    /* HW absolute index of a VSI */
 
 	prev_es = &vsi->eth_stats_prev;
 	cur_es = &vsi->eth_stats;
 
+	if (ice_is_reset_in_progress(pf->state))
+		vsi->stat_offsets_loaded = false;
+
 	ice_stat_update40(hw, GLV_GORCL(vsi_num), vsi->stat_offsets_loaded,
 			  &prev_es->rx_bytes, &cur_es->rx_bytes);
 
@@ -3304,6 +3308,8 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 			goto err_vectors;
 
 		ice_vsi_map_rings_to_vectors(vsi);
+
+		vsi->stat_offsets_loaded = false;
 		if (ice_is_xdp_ena_vsi(vsi)) {
 			ret = ice_vsi_determine_xdp_res(vsi);
 			if (ret)
@@ -3340,6 +3346,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, bool init_vsi)
 		if (ret)
 			goto err_vectors;
 
+		vsi->stat_offsets_loaded = false;
 		break;
 	case ICE_VSI_CHNL:
 		if (test_bit(ICE_FLAG_RSS_ENA, pf->flags)) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d6f460ff1b72..aa80e2b896b1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6397,6 +6397,7 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
  */
 static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 {
+	struct rtnl_link_stats64 *net_stats, *stats_prev;
 	struct rtnl_link_stats64 *vsi_stats;
 	u64 pkts, bytes;
 	int i;
@@ -6436,10 +6437,28 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 
 	rcu_read_unlock();
 
-	vsi->net_stats.tx_packets = vsi_stats->tx_packets;
-	vsi->net_stats.tx_bytes = vsi_stats->tx_bytes;
-	vsi->net_stats.rx_packets = vsi_stats->rx_packets;
-	vsi->net_stats.rx_bytes = vsi_stats->rx_bytes;
+	net_stats = &vsi->net_stats;
+	stats_prev = &vsi->net_stats_prev;
+
+	/* clear prev counters after reset */
+	if (vsi_stats->tx_packets < stats_prev->tx_packets ||
+	    vsi_stats->rx_packets < stats_prev->rx_packets) {
+		stats_prev->tx_packets = 0;
+		stats_prev->tx_bytes = 0;
+		stats_prev->rx_packets = 0;
+		stats_prev->rx_bytes = 0;
+	}
+
+	/* update netdev counters */
+	net_stats->tx_packets += vsi_stats->tx_packets - stats_prev->tx_packets;
+	net_stats->tx_bytes += vsi_stats->tx_bytes - stats_prev->tx_bytes;
+	net_stats->rx_packets += vsi_stats->rx_packets - stats_prev->rx_packets;
+	net_stats->rx_bytes += vsi_stats->rx_bytes - stats_prev->rx_bytes;
+
+	stats_prev->tx_packets = vsi_stats->tx_packets;
+	stats_prev->tx_bytes = vsi_stats->tx_bytes;
+	stats_prev->rx_packets = vsi_stats->rx_packets;
+	stats_prev->rx_bytes = vsi_stats->rx_bytes;
 
 	kfree(vsi_stats);
 }
@@ -6501,6 +6520,9 @@ void ice_update_pf_stats(struct ice_pf *pf)
 	prev_ps = &pf->stats_prev;
 	cur_ps = &pf->stats;
 
+	if (ice_is_reset_in_progress(pf->state))
+		pf->stat_prev_loaded = false;
+
 	ice_stat_update40(hw, GLPRT_GORCL(port), pf->stat_prev_loaded,
 			  &prev_ps->eth.rx_bytes,
 			  &cur_ps->eth.rx_bytes);
-- 
2.35.1

