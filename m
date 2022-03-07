Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548DA4D05A4
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 18:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238379AbiCGRsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 12:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244507AbiCGRsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 12:48:37 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B792511167;
        Mon,  7 Mar 2022 09:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646675262; x=1678211262;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=G4rpL32y1sZlYolgjSTtKzYmS1ss1HKDhqbQQWZrjkU=;
  b=cmYq62Kb+JTMkkCvpiwry3AZla4E78JXuNwKdPK6eWA1bhrveK+z8Gb/
   vDkrAbBukXMBKW+ZE1aVmbY9YYoomsPMt896COVEi800M0iVVlpg7Isw/
   87bep3MmQEHRTAv8YGrvJnnDCqcMW9vYhMfFD9i1VW7/KpbX8VOOYStJ/
   Jqps5oZpDfrqzQVOMZAebyxYjzGD9EUG90goQPddLy/ZDuS3MrTWE3cqM
   eIFH/1UE7J/l3UGY3Ka5ZbjaPhNxxraeO6PmapU1cW1HLqQphwqZYl/Mo
   Bnz9kgHW6DsG0T0Pz47SwssM2McDjzGw3gER8MOWg62gHJz93m7YwKFbI
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="317687109"
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="317687109"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 09:47:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="577684539"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 07 Mar 2022 09:47:40 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        dan.carpenter@oracle.com
Subject: [PATCH intel-net] ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()
Date:   Mon,  7 Mar 2022 18:47:39 +0100
Message-Id: <20220307174739.55899-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
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

It is possible to do NULL pointer dereference in routine that updates
Tx ring stats. Currently only stats and bytes are updated when ring
pointer is valid, but later on ring is accessed to propagate gathered Tx
stats onto VSI stats.

Change the existing logic to move to next ring when ring is NULL.

Fixes: e72bba21355d ("ice: split ice_ring onto Tx/Rx separate structs")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 289e5c99e313..d3f8b6468b92 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6145,8 +6145,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
 		u64 pkts = 0, bytes = 0;
 
 		ring = READ_ONCE(rings[i]);
-		if (ring)
-			ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
+		if (!ring)
+			continue;
+		ice_fetch_u64_stats_per_ring(&ring->syncp, ring->stats, &pkts, &bytes);
 		vsi_stats->tx_packets += pkts;
 		vsi_stats->tx_bytes += bytes;
 		vsi->tx_restart += ring->tx_stats.restart_q;
-- 
2.33.1

