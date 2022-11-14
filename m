Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02DA6280F3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbiKNNM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbiKNNMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:12:45 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F64A28E20
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668431557; x=1699967557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rgAPs7log2UWG8/xCvTZeDeVszLluOPvI71EOX9QBj8=;
  b=TH30E5rjjS0uSvp75uM0O9IPquN97Aifz6i28+moZ3GFYenuhh0Mn9eb
   Et7lKj9shHNmd9xOf52Po5ZNI15QKDfjwaRxg7Hhc09SR0uj6VwWF4I1o
   hHSAIoLdQdsBGIK3Co+w0Tr+Z2ZaDnJC76XNs5YupcuSK/P4Wh/2pqldZ
   3s4WKrmvceBNLiBzxhAnE/q/rP+eGDH+HR5YY/wtb234dGKJgbyXQpgax
   BdUePaiZ5fDccov9pdd2/qyY+cfZDovUjtRibkoIdgYMfgasz5aVwG0gO
   DdJIR5Ac5vFjdoecGU2dHfAeJx7At2QXM/RMUowBFzzLCcFNYDGTTrKhD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="313110633"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="313110633"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 05:12:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="616306044"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="616306044"
Received: from wasp.igk.intel.com ([10.102.20.192])
  by orsmga006.jf.intel.com with ESMTP; 14 Nov 2022 05:12:32 -0800
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Cc:     intel-wired-lan@lists.osuosl.org, jiri@nvidia.com,
        anthony.l.nguyen@intel.com, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Subject: [PATCH net-next 09/13] ice: update VSI instead of init in some case
Date:   Mon, 14 Nov 2022 13:57:51 +0100
Message-Id: <20221114125755.13659-10-michal.swiatkowski@linux.intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
References: <20221114125755.13659-1-michal.swiatkowski@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ice_vsi_cfg() is called from different contexts:
1) VSI exsist in HW, but it is reconfigured, because of changing queues
   for example -> update instead of init should be used
2) VSI doesn't exsist, because rest has happened -> init command should
   be sent

To support both cases pass boolean value which will store information
what type of command has to be sent to HW.

Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 16 ++++++++++------
 drivers/net/ethernet/intel/ice/ice_lib.h  |  4 ++--
 drivers/net/ethernet/intel/ice/ice_main.c |  2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 32da2da74056..bc04f2b9f8a2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2551,9 +2551,11 @@ static int ice_vsi_cfg_tc_lan(struct ice_pf *pf, struct ice_vsi *vsi)
  * @vf: pointer to VF to which this VSI connects. This field is used primarily
  *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
  * @ch: ptr to channel
+ * @init_vsi: is this an initialization or a reconfigure of the VSI
  */
 static int
-ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
+ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch,
+		int init_vsi)
 {
 	struct device *dev = ice_pf_to_dev(vsi->back);
 	struct ice_pf *pf = vsi->back;
@@ -2580,7 +2582,7 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
 	ice_vsi_set_tc_cfg(vsi);
 
 	/* create the VSI */
-	ret = ice_vsi_init(vsi, true);
+	ret = ice_vsi_init(vsi, init_vsi);
 	if (ret)
 		goto unroll_get_qs;
 
@@ -2694,12 +2696,14 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
  * @vf: pointer to VF to which this VSI connects. This field is used primarily
  *      for the ICE_VSI_VF type. Other VSI types should pass NULL.
  * @ch: ptr to channel
+ * @init_vsi: is this an initialization or a reconfigure of the VSI
  */
-int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch)
+int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf, struct ice_channel *ch,
+		int init_vsi)
 {
 	int ret;
 
-	ret = ice_vsi_cfg_def(vsi, vf, ch);
+	ret = ice_vsi_cfg_def(vsi, vf, ch, init_vsi);
 	if (ret)
 		return ret;
 
@@ -2796,7 +2800,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 		return NULL;
 	}
 
-	ret = ice_vsi_cfg(vsi, vf, ch);
+	ret = ice_vsi_cfg(vsi, vf, ch, ICE_VSI_FLAG_INIT);
 	if (ret)
 		goto err_vsi_cfg;
 
@@ -3286,7 +3290,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi)
 	prev_num_q_vectors = ice_vsi_rebuild_get_coalesce(vsi, coalesce);
 
 	ice_vsi_decfg(vsi);
-	ret = ice_vsi_cfg_def(vsi, vsi->vf, vsi->ch);
+	ret = ice_vsi_cfg_def(vsi, vsi->vf, vsi->ch, init_vsi);
 	if (ret)
 		goto err_vsi_cfg;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index 8905f8721a76..b76f05e1f8a3 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -60,8 +60,6 @@ int ice_vsi_release(struct ice_vsi *vsi);
 
 void ice_vsi_close(struct ice_vsi *vsi);
 
-int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf,
-		struct ice_channel *ch);
 int ice_ena_vsi(struct ice_vsi *vsi, bool locked);
 
 void ice_vsi_decfg(struct ice_vsi *vsi);
@@ -75,6 +73,8 @@ ice_get_res(struct ice_pf *pf, struct ice_res_tracker *res, u16 needed, u16 id);
 #define ICE_VSI_FLAG_INIT	BIT(0)
 #define ICE_VSI_FLAG_NO_INIT	0
 int ice_vsi_rebuild(struct ice_vsi *vsi, int init_vsi);
+int ice_vsi_cfg(struct ice_vsi *vsi, struct ice_vf *vf,
+		struct ice_channel *ch, int init_vsi);
 
 bool ice_is_reset_in_progress(unsigned long *state);
 int ice_wait_for_reset(struct ice_pf *pf, unsigned long timeout);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 49d29eb61c17..9766032e95ec 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5012,7 +5012,7 @@ int ice_load(struct ice_pf *pf)
 		return err;
 
 	vsi = ice_get_main_vsi(pf);
-	err = ice_vsi_cfg(vsi, NULL, NULL);
+	err = ice_vsi_cfg(vsi, NULL, NULL, ICE_VSI_FLAG_INIT);
 	if (err)
 		goto err_vsi_cfg;
 
-- 
2.36.1

