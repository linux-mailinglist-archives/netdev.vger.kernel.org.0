Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7884DA45F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351881AbiCOVNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351875AbiCOVNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:13:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B045B3D7
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647378721; x=1678914721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kp2m0YcIS3HNtMLjRIoXR1Nu5rcOmWYSxmnmsOsZQ6o=;
  b=gkOJqij++eGp1HpcRY1jcZtMZG/R4jcKh04b+/RPjftId0Bz05QCCYzD
   SfScdubTMGmGgRoCyPXeSpl2LMjIVHwANVUnSMs4YsgR92tnxd8Hq4w08
   jVBLiU5Fr+UAgH2s+0/6IlcrK9Dia4GVsNV6N+Lz0Lv4PDM1gKmNwHmM1
   QIGGaD5WEaocrxTwxiAUB8HTSJ5utpevsKTPv8cinO+o3fEFDNhj8DzfV
   PpKTckfedbXK0eEhPQo23TDUfQyL6U3PDDdSdFOf5Eit70VK4HE3chSkN
   4psl6NE5PZ/iutrMf+P7BEeFFVlnDAORjTE4oT7Z+48KDn2PNws0ekGzv
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236370469"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="236370469"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 14:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="820113204"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2022 14:12:00 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/3] ice: fix NULL pointer dereference in ice_update_vsi_tx_ring_stats()
Date:   Tue, 15 Mar 2022 14:12:23 -0700
Message-Id: <20220315211225.2923496-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

It is possible to do NULL pointer dereference in routine that updates
Tx ring stats. Currently only stats and bytes are updated when ring
pointer is valid, but later on ring is accessed to propagate gathered Tx
stats onto VSI stats.

Change the existing logic to move to next ring when ring is NULL.

Fixes: e72bba21355d ("ice: split ice_ring onto Tx/Rx separate structs")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 493942e910be..d4a7c39fd078 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5962,8 +5962,9 @@ ice_update_vsi_tx_ring_stats(struct ice_vsi *vsi,
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
2.31.1

