Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C954DCDB7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237453AbiCQSi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbiCQSiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:38:55 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C3E11437E;
        Thu, 17 Mar 2022 11:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647542258; x=1679078258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P8piRP65tYC45LGSIp/Zi/VLaAKDC8F8qz2ibDmGUe8=;
  b=cIH9LLH1sKPTH0H46Twte69RYTi+iF0ZG1mr6dLzM/caI/L9h5AP6sy0
   gpBn4cl+m1a6gn0SMtgROm4oCuk6x12yww9K8fGtq+3XR5igO5kLdx+Hd
   FB6iBkCFzsEX7lerSkOBgeTpR3D6pgRonUZbTv1MTrfzxxjFTfozddrTu
   n+LbNn5uqWG0e3aBwzI1OeWNnGacjAEtig9cJySHOXdmWoyAZ6zfHtiyz
   9rLNQlAE+kt13Uk8Oo724+sD7leWWrDue6Eubb4Rrbsp4KA7rKVM2WksV
   Zf6LhCZtrr+jqg8GNa0+MDeQpW5cQ94gsHV/BNPP7YWOf7Fp66P1lxCA7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="343386028"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="343386028"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 11:37:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="558057177"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 17 Mar 2022 11:37:35 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 1/3] ice: synchronize_rcu() when terminating rings
Date:   Thu, 17 Mar 2022 19:36:27 +0100
Message-Id: <20220317183629.340350-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
References: <20220317183629.340350-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, the ice driver doesn't respect the RCU critical section that
XSK wakeup is surrounded with. To fix this, add synchronize_rcu() calls to
paths that destroy resources that might be in use.

This was addressed in other AF_XDP ZC enabled drivers, for reference see
for example commit b3873a5be757 ("net/i40e: Fix concurrency issues
between config flow and XSK")

Fixes: efc2214b6047 ("ice: Add support for XDP")
Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c | 4 +++-
 drivers/net/ethernet/intel/ice/ice_xsk.c  | 4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bea1d1e39fa2..211d91be53a0 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -672,7 +672,7 @@ static inline struct ice_pf *ice_netdev_to_pf(struct net_device *netdev)
 
 static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
 {
-	return !!vsi->xdp_prog;
+	return !!READ_ONCE(vsi->xdp_prog);
 }
 
 static inline void ice_set_ring_xdp(struct ice_tx_ring *ring)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b7e8744b0c0a..c3c73a61bfd0 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2729,8 +2729,10 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 
 	ice_for_each_xdp_txq(vsi, i)
 		if (vsi->xdp_rings[i]) {
-			if (vsi->xdp_rings[i]->desc)
+			if (vsi->xdp_rings[i]->desc) {
+				synchronize_rcu();
 				ice_free_tx_ring(vsi->xdp_rings[i]);
+			}
 			kfree_rcu(vsi->xdp_rings[i], rcu);
 			vsi->xdp_rings[i] = NULL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 2388837d6d6c..24a8f54c32df 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -41,8 +41,10 @@ static void ice_qp_reset_stats(struct ice_vsi *vsi, u16 q_idx)
 static void ice_qp_clean_rings(struct ice_vsi *vsi, u16 q_idx)
 {
 	ice_clean_tx_ring(vsi->tx_rings[q_idx]);
-	if (ice_is_xdp_ena_vsi(vsi))
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		synchronize_rcu();
 		ice_clean_tx_ring(vsi->xdp_rings[q_idx]);
+	}
 	ice_clean_rx_ring(vsi->rx_rings[q_idx]);
 }
 
-- 
2.27.0

