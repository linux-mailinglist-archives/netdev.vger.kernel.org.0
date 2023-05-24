Return-Path: <netdev+bounces-4985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE5070F649
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 14:24:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A7D3280C5A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE5F718AE8;
	Wed, 24 May 2023 12:22:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B448E182B6
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 12:22:46 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63953E46
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 05:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684930959; x=1716466959;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tJHYS1D+DuCqmg6wf2r4ihvHN4TALwGfSZd23lEepI4=;
  b=Bn+OmUbp8Ic75gb0SYIZtzOf6l0GbKBF2+Po8Z0SD1gUGVHJemA20AUY
   ST2XCwMCQe4WvO9jMvPiEsEiG9N/9vqDnPr5r2uFiJWG6otJ2f2bfWrVO
   SEXy7S4Sb1BIyjiTzoQKEta3rpEhpAmFRnAQmu39UMtUeRZfjA0YLB+yz
   qe6NKOj5f4JG9zW35bGQsAtQhTnoMpKdxdFVyYhLa0rEOirigxKNshA5j
   SwfVuj+hG+v8FmLya0+f2hganhWE8Gc0P9979QTP+8Da4Hm8ejTjm7sb4
   pqRB5Ic22omWjSrplTGkssKq3LrzMA4ep63hJXRyYywjz7c7buYLoIldm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="439900970"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="439900970"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 05:22:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="950995929"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="950995929"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2023 05:22:36 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id 3D3403782D;
	Wed, 24 May 2023 13:22:35 +0100 (IST)
From: Wojciech Drewek <wojciech.drewek@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org,
	alexandr.lobakin@intel.com,
	david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com,
	marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com,
	sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de,
	simon.horman@corigine.com,
	dan.carpenter@linaro.org
Subject: [PATCH iwl-next v4 05/13] ice: Unset src prune on uplink VSI
Date: Wed, 24 May 2023 14:21:13 +0200
Message-Id: <20230524122121.15012-6-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230524122121.15012-1-wojciech.drewek@intel.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
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

In switchdev mode uplink VSI is supposed to receive all packets that
were not matched by existing filters. If ICE_AQ_VSI_SW_FLAG_LOCAL_LB
bit is unset and we have a filter associated with uplink VSI
which matches on dst mac equal to MAC1, then packets with src mac equal
to MAC1 will be pruned from reaching uplink VSI.

Fix this by updating uplink VSI with ICE_AQ_VSI_SW_FLAG_LOCAL_LB bit
set when configuring switchdev mode.

Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
---
v2: fix @ctx declaration in ice_vsi_update_local_lb
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c |  6 +++++
 drivers/net/ethernet/intel/ice/ice_lib.c     | 25 ++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h     |  1 +
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index bfd003135fc8..4fe235da1182 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -113,8 +113,13 @@ static int ice_eswitch_setup_env(struct ice_pf *pf)
 	if (ice_vsi_update_security(ctrl_vsi, ice_vsi_ctx_set_allow_override))
 		goto err_override_control;
 
+	if (ice_vsi_update_local_lb(uplink_vsi, true))
+		goto err_override_local_lb;
+
 	return 0;
 
+err_override_local_lb:
+	ice_vsi_update_security(ctrl_vsi, ice_vsi_ctx_clear_allow_override);
 err_override_control:
 	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
 err_override_uplink:
@@ -391,6 +396,7 @@ static void ice_eswitch_release_env(struct ice_pf *pf)
 
 	vlan_ops = ice_get_compat_vsi_vlan_ops(uplink_vsi);
 
+	ice_vsi_update_local_lb(uplink_vsi, false);
 	ice_vsi_update_security(ctrl_vsi, ice_vsi_ctx_clear_allow_override);
 	ice_vsi_update_security(uplink_vsi, ice_vsi_ctx_clear_allow_override);
 	vlan_ops->ena_rx_filtering(uplink_vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5ddb95d1073a..e8142bea2eb2 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -4117,3 +4117,28 @@ void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx)
 {
 	ctx->info.sec_flags &= ~ICE_AQ_VSI_SEC_FLAG_ALLOW_DEST_OVRD;
 }
+
+/**
+ * ice_vsi_update_local_lb - update sw block in VSI with local loopback bit
+ * @vsi: pointer to VSI structure
+ * @set: set or unset the bit
+ */
+int
+ice_vsi_update_local_lb(struct ice_vsi *vsi, bool set)
+{
+	struct ice_vsi_ctx ctx = {
+		.info	= vsi->info,
+	};
+
+	ctx.info.valid_sections = cpu_to_le16(ICE_AQ_VSI_PROP_SW_VALID);
+	if (set)
+		ctx.info.sw_flags |= ICE_AQ_VSI_SW_FLAG_LOCAL_LB;
+	else
+		ctx.info.sw_flags &= ~ICE_AQ_VSI_SW_FLAG_LOCAL_LB;
+
+	if (ice_update_vsi(&vsi->back->hw, vsi->idx, &ctx, NULL))
+		return -ENODEV;
+
+	vsi->info = ctx.info;
+	return 0;
+}
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e985766e6bb5..1628385a9672 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -157,6 +157,7 @@ void ice_vsi_ctx_clear_antispoof(struct ice_vsi_ctx *ctx);
 void ice_vsi_ctx_set_allow_override(struct ice_vsi_ctx *ctx);
 
 void ice_vsi_ctx_clear_allow_override(struct ice_vsi_ctx *ctx);
+int ice_vsi_update_local_lb(struct ice_vsi *vsi, bool set);
 int ice_vsi_add_vlan_zero(struct ice_vsi *vsi);
 int ice_vsi_del_vlan_zero(struct ice_vsi *vsi);
 bool ice_vsi_has_non_zero_vlans(struct ice_vsi *vsi);
-- 
2.40.1


