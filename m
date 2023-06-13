Return-Path: <netdev+bounces-10337-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B5972DEFA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 12:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEC691C20C53
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 10:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF5D38CC8;
	Tue, 13 Jun 2023 10:14:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F409734CE2
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:14:45 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABF413A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 03:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686651284; x=1718187284;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AESFojjzaa+7IcmWawxnNiN1nmca6WAY0k/xlyoPLZs=;
  b=Pxi/xNkjbjpgf3u0E2nrPduoAyvFXXso+o+Ie6k7Zb2MV+fO1eraiWSw
   94Vft96lcBPrdI4/qjqLz3jqJZnhdYR/TF1odzPanAZcVuwCkuhEK5/rc
   nDoCOMFiTMTn+oyRkO+tyG/AUMjtF6C3YaVC/2wLrrz6eIq/A8JvROWh6
   P4TsUlZ9lSTOXwg2/bSfBro//ouNsxdkn/kQ3s0cHcDJNTk6DjJt4j8do
   QG1bJNvh5v+KfqZ0RTrF2QReVFbx5LuaK31zFhF0NGWkvHTFFnUFbL5O/
   qWuGU/YiI+PxslwU19ElW1K8FMqzANGo6oLyf25K9+1YM2MLAPMP/xONH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="424168071"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="424168071"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 03:14:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885787130"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="885787130"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by orsmga005.jf.intel.com with ESMTP; 13 Jun 2023 03:14:41 -0700
Received: from rozewie.igk.intel.com (rozewie.igk.intel.com [10.211.8.69])
	by irvmail002.ir.intel.com (Postfix) with ESMTP id B9F0C35820;
	Tue, 13 Jun 2023 11:14:40 +0100 (IST)
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
Subject: [PATCH iwl-next v5 05/12] ice: Unset src prune on uplink VSI
Date: Tue, 13 Jun 2023 12:13:23 +0200
Message-Id: <20230613101330.87734-6-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230613101330.87734-1-wojciech.drewek@intel.com>
References: <20230613101330.87734-1-wojciech.drewek@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In switchdev mode uplink VSI is supposed to receive all packets that
were not matched by existing filters. If ICE_AQ_VSI_SW_FLAG_LOCAL_LB
bit is unset and we have a filter associated with uplink VSI
which matches on dst mac equal to MAC1, then packets with src mac equal
to MAC1 will be pruned from reaching uplink VSI.

Fix this by updating uplink VSI with ICE_AQ_VSI_SW_FLAG_LOCAL_LB bit
set when configuring switchdev mode.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
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


