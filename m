Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A4135895D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhDHQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 12:12:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:26214 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232118AbhDHQLz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 12:11:55 -0400
IronPort-SDR: pvBTnrjGmrdM7jAlyHnb33brdGZh/jJEH1/wg31C+aUt1gQ/iLZxcyBTMDmCb05zchLt4K6V42
 upMfbCHzWPiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="191424034"
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="191424034"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 09:11:43 -0700
IronPort-SDR: hjWRWvToMZ5DG2CO2Ej8cmoo8k4CZpPaujRjxDv3PxhtHYuGcSv1OpvlnTYZJdjySIiWfbqijT
 Jzp+Ky8uatjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,206,1613462400"; 
   d="scan'208";a="415841450"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 08 Apr 2021 09:11:42 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 13/15] ice: Remove rx_gro_dropped stat
Date:   Thu,  8 Apr 2021 09:13:19 -0700
Message-Id: <20210408161321.3218024-14-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
References: <20210408161321.3218024-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

Tracking of the rx_gro_dropped statistic was removed in
commit f73fc40327c0 ("ice: drop dead code in ice_receive_skb()").
Remove the associated variables and its reporting to ethtool stats.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         | 1 -
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 1 -
 drivers/net/ethernet/intel/ice/ice_main.c    | 4 +---
 drivers/net/ethernet/intel/ice/ice_txrx.h    | 1 -
 4 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 02badaaf818c..721afa0f0a88 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -265,7 +265,6 @@ struct ice_vsi {
 	u32 tx_busy;
 	u32 rx_buf_failed;
 	u32 rx_page_failed;
-	u32 rx_gro_dropped;
 	u16 num_q_vectors;
 	u16 base_vector;		/* IRQ base for OS reserved vectors */
 	enum ice_vsi_type type;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 4ca8d5880cfc..51d3a929ecfd 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -60,7 +60,6 @@ static const struct ice_stats ice_gstrings_vsi_stats[] = {
 	ICE_VSI_STAT("rx_unknown_protocol", eth_stats.rx_unknown_protocol),
 	ICE_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	ICE_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
-	ICE_VSI_STAT("rx_gro_dropped", rx_gro_dropped),
 	ICE_VSI_STAT("tx_errors", eth_stats.tx_errors),
 	ICE_VSI_STAT("tx_linearize", tx_linearize),
 	ICE_VSI_STAT("tx_busy", tx_busy),
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 73dd272acbf9..3c73ee4a6c0c 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5354,7 +5354,6 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 	vsi->tx_linearize = 0;
 	vsi->rx_buf_failed = 0;
 	vsi->rx_page_failed = 0;
-	vsi->rx_gro_dropped = 0;
 
 	rcu_read_lock();
 
@@ -5369,7 +5368,6 @@ static void ice_update_vsi_ring_stats(struct ice_vsi *vsi)
 		vsi_stats->rx_bytes += bytes;
 		vsi->rx_buf_failed += ring->rx_stats.alloc_buf_failed;
 		vsi->rx_page_failed += ring->rx_stats.alloc_page_failed;
-		vsi->rx_gro_dropped += ring->rx_stats.gro_dropped;
 	}
 
 	/* update XDP Tx rings counters */
@@ -5401,7 +5399,7 @@ void ice_update_vsi_stats(struct ice_vsi *vsi)
 	ice_update_eth_stats(vsi);
 
 	cur_ns->tx_errors = cur_es->tx_errors;
-	cur_ns->rx_dropped = cur_es->rx_discards + vsi->rx_gro_dropped;
+	cur_ns->rx_dropped = cur_es->rx_discards;
 	cur_ns->tx_dropped = cur_es->tx_discards;
 	cur_ns->multicast = cur_es->rx_multicast;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index ffe0d271dec7..701552d88bea 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -192,7 +192,6 @@ struct ice_rxq_stats {
 	u64 non_eop_descs;
 	u64 alloc_page_failed;
 	u64 alloc_buf_failed;
-	u64 gro_dropped; /* GRO returned dropped */
 };
 
 enum ice_ring_state_t {
-- 
2.26.2

