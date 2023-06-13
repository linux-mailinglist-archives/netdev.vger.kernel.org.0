Return-Path: <netdev+bounces-10549-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 107FC72EFD8
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 01:15:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6801728113F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:15:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58CF12DBA3;
	Tue, 13 Jun 2023 23:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC031361
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:15:36 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EE7199E
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686698134; x=1718234134;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mYYNP4k9twgj8XoiNUIUeugOakpKuUCeGbaX+iQExnE=;
  b=f4I2vl5IStCnoQ7mf7yrtYZ2JYer0D/LsO9OO3o4Ntmm0Ig6LR/GWA3P
   cddAKS0o4Mqp+lu4TOvzGzlkqC1LiJNrRFbbsPTKCzdwnIoHLka5PYBeZ
   JRtY0T4FlIz5YqMhK1HyD+izQAuCFWCWrxhAGnw/mqUfmc+4qc5MP5/Nh
   3W08n0K8OFZNAoh9sQ62aUrSvf7bGH2ZxPFd93CpfjczfNHWQDX24uXzz
   uGVD/jPi/FvdB2fVrOzjil+78EtGUkWALLkMNOpL+PlE8xaTVg6H6oZUu
   tKaAHNy7JzsUbDo8vjaAwDDryLuxpcX1TIV2hFxrm/rdp09zfiCv6C+Zk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="357351999"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="357351999"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 16:15:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="714973982"
X-IronPort-AV: E=Sophos;i="6.00,241,1681196400"; 
   d="scan'208";a="714973982"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga007.fm.intel.com with ESMTP; 13 Jun 2023 16:15:31 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	anthony.l.nguyen@intel.com,
	magnus.karlsson@intel.com,
	fred@cloudflare.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 iwl-next] ice: allow hot-swapping XDP programs
Date: Wed, 14 Jun 2023 01:15:23 +0200
Message-Id: <20230613231523.339413-1-maciej.fijalkowski@intel.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---

v1->v2:
- fix missing brace (sigh)

 drivers/net/ethernet/intel/ice/ice_main.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a1f7c8edc22f..dba1f7709e8b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2924,6 +2924,12 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
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
@@ -2956,13 +2962,6 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
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


