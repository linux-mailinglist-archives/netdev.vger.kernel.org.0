Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E25E6989C4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBPBQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjBPBQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:16:39 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529343C2BF
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:16:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676510198; x=1708046198;
  h=from:to:cc:subject:date:message-id;
  bh=dQwZub3mqk1B9/uN7Coavy7BchozyuGAMzGX3UdoFpw=;
  b=ZeRpq6zpTi6kTNc7+kcJaTF/LsiK6TyqGP/RBXrlSHy8XH+kemHau+sI
   A340xgXtJwrdvGQyoXKcMC2SEcS90rq5eBBI+ClS1yFh7HOstCN32zFCd
   1J2JysLzCWcgv6X6s/BzeSonk3jV0ajnniachCaJEXmV4svP4gAEeENjH
   n8N+J4mcQjpXz4+sQCmN/tegyApxTfzkPV82Wj4Qm2oD99/ARvEExhpyZ
   DxdeJWLaMdil03VWyzZeDovvERhXH3o/ZkwdNCwhpKVTFecfBcPKBRjOz
   AWfNS1/VPi8eltzBur98vh9rnamLd1MJFEmwNsO0SuUBNrGqXq9lPjMFw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="396229236"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="396229236"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 17:16:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="619830437"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="619830437"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga003.jf.intel.com with ESMTP; 15 Feb 2023 17:16:33 -0800
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     vinicius.gomes@intel.com, kuba@kernel.org,
        muhammad.husaini.zulkifli@intel.com, naamax.meir@linux.intel.com,
        anthony.l.nguyen@intel.com, leon@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        tee.min.tan@linux.intel.com, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next v5] igc: offload queue max SDU from tc-taprio
Date:   Thu, 16 Feb 2023 09:16:24 +0800
Message-Id: <20230216011624.14022-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

Add support for configuring the max SDU for each Tx queue.
If not specified, keep the default.

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

---
V4 -> V5: Rework based on Jakub's comment.
V3 -> V4: Rebase to the latest tree as per requested by Anthony.
V2 -> V3: Rework based on Leon Romanovsky's comment.
V1 -> V2: Rework based on Vinicius's comment.
---
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_hw.h   |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 33 ++++++++++++++++++++---
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 9db93c1f97679..34aebf00a5123 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -99,6 +99,7 @@ struct igc_ring {
 
 	u32 start_time;
 	u32 end_time;
+	u32 max_sdu;
 
 	/* CBS parameters */
 	bool cbs_enable;                /* indicates if CBS is enabled */
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 88680e3d613dd..e1c572e0d4ef0 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -273,6 +273,7 @@ struct igc_hw_stats {
 	u64 o2bspc;
 	u64 b2ospc;
 	u64 b2ogprc;
+	u64 txdrop;
 };
 
 struct net_device *igc_get_hw_dev(struct igc_hw *hw);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0f31f0cfcc3e6..2c40796c151fb 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1501,6 +1501,7 @@ static int igc_tso(struct igc_ring *tx_ring,
 static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 				       struct igc_ring *tx_ring)
 {
+	struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
 	bool first_flag = false, insert_empty = false;
 	u16 count = TXD_USE_COUNT(skb_headlen(skb));
 	__be16 protocol = vlan_get_protocol(skb);
@@ -1563,9 +1564,19 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
+	if (tx_ring->max_sdu > 0) {
+		u32 max_sdu = 0;
+
+		max_sdu = tx_ring->max_sdu +
+			  (skb_vlan_tagged(first->skb) ? VLAN_HLEN : 0);
 
+		if (first->bytecount > max_sdu) {
+			adapter->stats.txdrop++;
+			goto out_drop;
+		}
+	}
+
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		/* FIXME: add support for retrieving timestamps from
 		 * the other timer registers before skipping the
 		 * timestamping request.
@@ -4920,7 +4931,8 @@ void igc_update_stats(struct igc_adapter *adapter)
 	net_stats->tx_window_errors = adapter->stats.latecol;
 	net_stats->tx_carrier_errors = adapter->stats.tncrs;
 
-	/* Tx Dropped needs to be maintained elsewhere */
+	/* Tx Dropped */
+	net_stats->tx_dropped = adapter->stats.txdrop;
 
 	/* Management Stats */
 	adapter->stats.mgptc += rd32(IGC_MGTPTC);
@@ -6039,6 +6051,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 
 		ring->start_time = 0;
 		ring->end_time = NSEC_PER_SEC;
+		ring->max_sdu = 0;
 	}
 
 	return 0;
@@ -6122,6 +6135,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		}
 	}
 
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+		struct net_device *dev = adapter->netdev;
+
+		if (qopt->max_sdu[i])
+			ring->max_sdu = qopt->max_sdu[i] + dev->hard_header_len;
+		else
+			ring->max_sdu = 0;
+	}
+
 	return 0;
 }
 
@@ -6220,8 +6243,10 @@ static int igc_tc_query_caps(struct igc_adapter *adapter,
 
 		caps->broken_mqprio = true;
 
-		if (hw->mac.type == igc_i225)
+		if (hw->mac.type == igc_i225) {
+			caps->supports_queue_max_sdu = true;
 			caps->gate_mask_per_txq = true;
+		}
 
 		return 0;
 	}
-- 
2.17.1

