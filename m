Return-Path: <netdev+bounces-11066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F347316B8
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:33:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5AFF61C20E77
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA25125AE;
	Thu, 15 Jun 2023 11:33:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDDE20E0
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:33:34 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28758272C
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686828812; x=1718364812;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=swnICab9eS1LzbQCd0/9UolOAetCs1RLm9JzSgAZ1Zo=;
  b=UJ2BCJPvTWMRtW6bAUDJA/uiAvGy9nO+k7HlC/2oWH9CvSoYDnTb+KxB
   Vi1xn6pMVc8AM4u0rn9wzWlyQg/VWeiJ8DAUd9Nn1DZQS+zdCCeTPEt0X
   +RAmCWJYLOejxEcjaPBM+c00XZn7tLsP0Vr/ZuBya3Iun4SLXQU2tBt7n
   wJhJKy9+7jkNX/Ya3o3cLhBFWLVkg31qYgw5gk2XmJS9tz2HxPJR1qnUt
   NY2+KMC0eqbaxKDUEOET2nc6mzjduy4WOVfuFahbOCt8bgWGavwCTwFES
   1zittQW085eLn+icxA9QbjS1uJc9JRLlNldh9gLZDhbTB9lugDWdfOfMX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="362267421"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="362267421"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 04:33:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="1042627105"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="1042627105"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga005.fm.intel.com with ESMTP; 15 Jun 2023 04:33:29 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	fred@cloudflare.com,
	toke@kernel.org,
	aleksander.lobakin@intel.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 iwl-next] ice: allow hot-swapping XDP programs
Date: Thu, 15 Jun 2023 13:33:26 +0200
Message-Id: <20230615113326.347770-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently ice driver's .ndo_bpf callback brings interface down and up
independently of XDP resources' presence. This is only needed when
either these resources have to be configured or removed. It means that
if one is switching XDP programs on-the-fly with running traffic,
packets will be dropped.

To avoid this, compare early on ice_xdp_setup_prog() state of incoming
bpf_prog pointer vs the bpf_prog pointer that is already assigned to
VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.

Lastly, while at it, put old bpf_prog *after* the update of Rx ring's
bpf_prog pointer. In theory previous code could expose us to a state
where Rx ring's bpf_prog would still be referring to old_prog that got
released with earlier bpf_prog_put().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---

v2->v3:
- move bpf_prog_put() after ice_rx_ring::xdp_prog update [Toke, Olek]
v1->v2:
- fix missing brace (sigh)

 drivers/net/ethernet/intel/ice/ice_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 62e91512aeab..a7c76fded603 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2633,11 +2633,11 @@ static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
 	int i;
 
 	old_prog = xchg(&vsi->xdp_prog, prog);
-	if (old_prog)
-		bpf_prog_put(old_prog);
-
 	ice_for_each_rxq(vsi, i)
 		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
+
+	if (old_prog)
+		bpf_prog_put(old_prog);
 }
 
 /**
@@ -2922,6 +2922,12 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		}
 	}
 
+	/* hot swap progs and avoid toggling link */
+	if (ice_is_xdp_ena_vsi(vsi) == !!prog) {
+		ice_vsi_assign_bpf_prog(vsi, prog);
+		return 0;
+	}
+
 	/* need to stop netdev while setting up the program for Rx rings */
 	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
 		ret = ice_down(vsi);
@@ -2954,13 +2960,6 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		xdp_ring_err = ice_realloc_zc_buf(vsi, false);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
-	} else {
-		/* safe to call even when prog == vsi->xdp_prog as
-		 * dev_xdp_install in net/core/dev.c incremented prog's
-		 * refcount so corresponding bpf_prog_put won't cause
-		 * underflow
-		 */
-		ice_vsi_assign_bpf_prog(vsi, prog);
 	}
 
 	if (if_running)
-- 
2.34.1


