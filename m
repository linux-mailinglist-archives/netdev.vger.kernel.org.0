Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C99843CD67
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 17:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242732AbhJ0PWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 11:22:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37353 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238106AbhJ0PWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 11:22:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F18165C01B2;
        Wed, 27 Oct 2021 11:20:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 27 Oct 2021 11:20:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=F3xZcZfkkzjgMEHzS6V+Dk1pln3pFrVJxLhY4Jrtyi4=; b=IRa+KYf0
        2mwVt+t2lA7C+OM/l8h1tPfwy1TYm+S+Y2e0pjg3mzGz323VnNogX6PSXPz+80Xs
        V8fkB4ftRWxTNN2XnhtdYnB4rj3plLPoFqtOWJ1SyV0DXK7reVhRTp69PX4awWLj
        9wRLT+7k51BM+Dn5GD5EHHlYLgS5w820IziZIkEyzAThlYeC99B2y0uLl54lD8Ef
        WarY3LayRRX1SQOuKkaJjD5avpt7Uotp86sILPf7jh1R79VuTpu2sln+YZ6jEXFy
        pVOQzfl4x6RYSxDHMQwmdn5eQPrphpMcbPsPLc0sR2NNDy0/4rLmI8ggJTZMCBb1
        6aACbS8ifdSwtQ==
X-ME-Sender: <xms:NG55YcbxwQDQaG5N6STrm0A0iLCUrRp7ozMeH515jwfJATkwjYgxXg>
    <xme:NG55YXbxSXDy5Y1DdD-hczGGTaBjmiU68FWL6K1B8Ai-eelmXrMsGRTjxbr_9i3gx
    xplgWPvc6Aoynw>
X-ME-Received: <xmr:NG55YW8rlCIrcBg3eRGMEh-FutCchcYdbkjCxJsW0ihtihokEQn61xgncoTDX5raD-dNmh4PIgWe_7z2ipo5X3AsOfQc0DT9vGgStHJp7xi96A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NG55YWqkU2moT5L5-a1lXYLM1SB88qcsJNTFLnFDDxeOgW6Ms0VNRQ>
    <xmx:NG55YXoBULhFoD3MMGSXCNFxk9udNJWtrue2i3pDlwizvdAZPqLweA>
    <xmx:NG55YUTZwgS-9jIMRupLM36gIpiQox-DENEpAekLAbZstm3PtB8zBA>
    <xmx:NG55YYnv8KHZfr9zxygcWPCz8VPfRZkac0BoISj_eSRkeift1Ikp1w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 11:20:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: spectrum_qdisc: Offload root TBF as port shaper
Date:   Wed, 27 Oct 2021 18:19:59 +0300
Message-Id: <20211027152001.1320496-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027152001.1320496-1-idosch@idosch.org>
References: <20211027152001.1320496-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The Spectrum ASIC allows configuration of maximum shaper on all levels of
the scheduling hierarchy: TCs, subgroups, groups and also ports. Currently,
TBF always configures a subgroup. But a user could reasonably express the
intent to configure port shaper by putting TBF to a root position, around
ETS / PRIO. Accept this usage and offload appropriately.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 55 +++++++++++++------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index ddb5ad88b350..4243d3b883ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -271,6 +271,7 @@ mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 
 struct mlxsw_sp_qdisc_tree_validate {
 	bool forbid_ets;
+	bool forbid_root_tbf;
 	bool forbid_tbf;
 	bool forbid_red;
 };
@@ -310,18 +311,26 @@ __mlxsw_sp_qdisc_tree_validate(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 		if (validate.forbid_red)
 			return -EINVAL;
 		validate.forbid_red = true;
+		validate.forbid_root_tbf = true;
 		validate.forbid_ets = true;
 		break;
 	case MLXSW_SP_QDISC_TBF:
-		if (validate.forbid_tbf)
-			return -EINVAL;
-		validate.forbid_tbf = true;
-		validate.forbid_ets = true;
+		if (validate.forbid_root_tbf) {
+			if (validate.forbid_tbf)
+				return -EINVAL;
+			/* This is a TC TBF. */
+			validate.forbid_tbf = true;
+			validate.forbid_ets = true;
+		} else {
+			/* This is root TBF. */
+			validate.forbid_root_tbf = true;
+		}
 		break;
 	case MLXSW_SP_QDISC_PRIO:
 	case MLXSW_SP_QDISC_ETS:
 		if (validate.forbid_ets)
 			return -EINVAL;
+		validate.forbid_root_tbf = true;
 		validate.forbid_ets = true;
 		break;
 	default:
@@ -905,16 +914,34 @@ mlxsw_sp_setup_tc_qdisc_leaf_clean_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 	mlxsw_sp_qdisc->stats_base.backlog = 0;
 }
 
+static enum mlxsw_reg_qeec_hr
+mlxsw_sp_qdisc_tbf_hr(struct mlxsw_sp_port *mlxsw_sp_port,
+		      struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
+{
+	if (mlxsw_sp_qdisc == &mlxsw_sp_port->qdisc->root_qdisc)
+		return MLXSW_REG_QEEC_HR_PORT;
+
+	/* Configure subgroup shaper, so that both UC and MC traffic is subject
+	 * to shaping. That is unlike RED, however UC queue lengths are going to
+	 * be different than MC ones due to different pool and quota
+	 * configurations, so the configuration is not applicable. For shaper on
+	 * the other hand, subjecting the overall stream to the configured
+	 * shaper makes sense. Also note that that is what we do for
+	 * ieee_setmaxrate().
+	 */
+	return MLXSW_REG_QEEC_HR_SUBGROUP;
+}
+
 static int
 mlxsw_sp_qdisc_tbf_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc)
 {
+	enum mlxsw_reg_qeec_hr hr = mlxsw_sp_qdisc_tbf_hr(mlxsw_sp_port,
+							  mlxsw_sp_qdisc);
 	int tclass_num = mlxsw_sp_qdisc_get_tclass_num(mlxsw_sp_port,
 						       mlxsw_sp_qdisc);
 
-	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-					     MLXSW_REG_QEEC_HR_SUBGROUP,
-					     tclass_num, 0,
+	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port, hr, tclass_num, 0,
 					     MLXSW_REG_QEEC_MAS_DIS, 0);
 }
 
@@ -996,6 +1023,8 @@ mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			   void *params)
 {
+	enum mlxsw_reg_qeec_hr hr = mlxsw_sp_qdisc_tbf_hr(mlxsw_sp_port,
+							  mlxsw_sp_qdisc);
 	struct tc_tbf_qopt_offload_replace_params *p = params;
 	u64 rate_kbps = mlxsw_sp_qdisc_tbf_rate_kbps(p);
 	int tclass_num;
@@ -1016,17 +1045,7 @@ mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 		/* check_params above was supposed to reject this value. */
 		return -EINVAL;
 
-	/* Configure subgroup shaper, so that both UC and MC traffic is subject
-	 * to shaping. That is unlike RED, however UC queue lengths are going to
-	 * be different than MC ones due to different pool and quota
-	 * configurations, so the configuration is not applicable. For shaper on
-	 * the other hand, subjecting the overall stream to the configured
-	 * shaper makes sense. Also note that that is what we do for
-	 * ieee_setmaxrate().
-	 */
-	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port,
-					     MLXSW_REG_QEEC_HR_SUBGROUP,
-					     tclass_num, 0,
+	return mlxsw_sp_port_ets_maxrate_set(mlxsw_sp_port, hr, tclass_num, 0,
 					     rate_kbps, burst_size);
 }
 
-- 
2.31.1

