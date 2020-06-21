Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC82029A9
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 10:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbgFUIex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 04:34:53 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:35845 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729502AbgFUIew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 04:34:52 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8AA535C00F0;
        Sun, 21 Jun 2020 04:34:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 21 Jun 2020 04:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=mLfErFhKw4iy5sV2w/KPgox0DiH/bOuAUFnOsgZunEQ=; b=i18t4RVa
        wLstEVgFCWsoyyyOm+9IHjm7/zMyGBUtsiBw8pY9ZZOy67S7hu+g4T/y+hpMJLxx
        r++Q04x5bC/q0nhajHv/s3mLcYM6q6UwUsq+K5eM8uflpBxjuhZam6Q3/3O9DNOr
        X9HhsvHfwR/UKlo9DBI4YxF2PwDONFgEWoxjgvmncvqp4NPqNojgXhyYPFgK5tss
        W4rZA7zP5wRtXM9CSQ3PUdi9LOWKHFdpeWnlfmj7daHhnuziCwjp3KFY/lOp1vHB
        mfLpxQA92kIR4e2sXYBoOwm9epqR2/3lXmkWpTjdH+bKRUjK5LJs5Mx50W/oKsQ7
        DAO90p+zC4zPhg==
X-ME-Sender: <xms:qxvvXn2U2eao866FgJpHNs7uqVGuadIdMuQP5CGbgs2E-fyCDjNc9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudektddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeijedrkedruddvleen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:qxvvXmGjPldk539odhiiyAfmXdhcQahw-Y7efYBSACu0psfe2KMDng>
    <xmx:qxvvXn4OQR-bCn7s2jggO4f18u9fsZz41u1cSxTvll-R0w9oIyb1Wg>
    <xmx:qxvvXs3Lw6Y4dz11cKphG4mB7O2SwwxZbmROhTF1oXT2uG2eFjvMwg>
    <xmx:qxvvXvTYagvF6hKE-RYlSzZ7CViFERO3L1oXSUW3xc_jzWfSMyKmLw>
Received: from splinter.mtl.com (bzq-109-67-8-129.red.bezeqint.net [109.67.8.129])
        by mail.messagingengine.com (Postfix) with ESMTPA id 27B7C3066D7B;
        Sun, 21 Jun 2020 04:34:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/4] mlxsw: spectrum: Split handling of pedit mangle by chip type
Date:   Sun, 21 Jun 2020 11:34:33 +0300
Message-Id: <20200621083436.476806-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200621083436.476806-1-idosch@idosch.org>
References: <20200621083436.476806-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Certain ACL actions are only available on some Spectrum revisions. In
particular, L4_PORT_ACTION is not available on Spectrum-1. Introduce a
new ops struct intended to hold these differences, mlxsw_sp_rulei_ops.
Prime it with a sole member, act_mangle_field, meant for handling of
pedit mangles.

Create two ops structures, one for Spectrum-1, the other for Spectrum-2
and above. Add callbacks for act_mangle_field and dispatch to the common
handler.

Invoke mlxsw_sp_rulei_ops.act_mangle_field from the field mangler
instead of calling the common handler directly.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 13 +++++
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 51 ++++++++++++++++---
 3 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 55af877763ed..7d7ebd99f09e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4594,6 +4594,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->afa_ops = &mlxsw_sp1_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp1_afk_ops;
 	mlxsw_sp->mr_tcam_ops = &mlxsw_sp1_mr_tcam_ops;
+	mlxsw_sp->acl_rulei_ops = &mlxsw_sp1_acl_rulei_ops;
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp1_acl_tcam_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp1_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp1_mac_mask;
@@ -4621,6 +4622,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
 	mlxsw_sp->mr_tcam_ops = &mlxsw_sp2_mr_tcam_ops;
+	mlxsw_sp->acl_rulei_ops = &mlxsw_sp2_acl_rulei_ops;
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
@@ -4644,6 +4646,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
 	mlxsw_sp->mr_tcam_ops = &mlxsw_sp2_mr_tcam_ops;
+	mlxsw_sp->acl_rulei_ops = &mlxsw_sp2_acl_rulei_ops;
 	mlxsw_sp->acl_tcam_ops = &mlxsw_sp2_acl_tcam_ops;
 	mlxsw_sp->nve_ops_arr = mlxsw_sp2_nve_ops_arr;
 	mlxsw_sp->mac_mask = mlxsw_sp2_mac_mask;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 6e87457dd635..17dd16d82f87 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -120,6 +120,7 @@ struct mlxsw_sp_kvdl;
 struct mlxsw_sp_nve;
 struct mlxsw_sp_kvdl_ops;
 struct mlxsw_sp_mr_tcam_ops;
+struct mlxsw_sp_acl_rulei_ops;
 struct mlxsw_sp_acl_tcam_ops;
 struct mlxsw_sp_nve_ops;
 struct mlxsw_sp_sb_vals;
@@ -164,6 +165,7 @@ struct mlxsw_sp {
 	const struct mlxsw_afa_ops *afa_ops;
 	const struct mlxsw_afk_ops *afk_ops;
 	const struct mlxsw_sp_mr_tcam_ops *mr_tcam_ops;
+	const struct mlxsw_sp_acl_rulei_ops *acl_rulei_ops;
 	const struct mlxsw_sp_acl_tcam_ops *acl_tcam_ops;
 	const struct mlxsw_sp_nve_ops **nve_ops_arr;
 	const struct mlxsw_sp_rif_ops **rif_ops_arr;
@@ -856,6 +858,17 @@ void mlxsw_sp_acl_fini(struct mlxsw_sp *mlxsw_sp);
 u32 mlxsw_sp_acl_region_rehash_intrvl_get(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_acl_region_rehash_intrvl_set(struct mlxsw_sp *mlxsw_sp, u32 val);
 
+struct mlxsw_sp_acl_mangle_action;
+
+struct mlxsw_sp_acl_rulei_ops {
+	int (*act_mangle_field)(struct mlxsw_sp *mlxsw_sp, struct mlxsw_sp_acl_rule_info *rulei,
+				struct mlxsw_sp_acl_mangle_action *mact, u32 val,
+				struct netlink_ext_ack *extack);
+};
+
+extern struct mlxsw_sp_acl_rulei_ops mlxsw_sp1_acl_rulei_ops;
+extern struct mlxsw_sp_acl_rulei_ops mlxsw_sp2_acl_rulei_ops;
+
 /* spectrum_acl_tcam.c */
 struct mlxsw_sp_acl_tcam;
 struct mlxsw_sp_acl_tcam_region;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 47da9ee0045d..cadcec6dbe19 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -563,11 +563,39 @@ mlxsw_sp_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
 	case MLXSW_SP_ACL_MANGLE_FIELD_IP_ECN:
 		return mlxsw_afa_block_append_qos_ecn(rulei->act_block,
 						      val, extack);
+	default:
+		return -EOPNOTSUPP;
 	}
+}
 
-	/* We shouldn't have gotten a match in the first place! */
-	WARN_ONCE(1, "Unhandled mangle field");
-	return -EINVAL;
+static int mlxsw_sp1_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_acl_rule_info *rulei,
+						struct mlxsw_sp_acl_mangle_action *mact,
+						u32 val, struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlxsw_sp_acl_rulei_act_mangle_field(mlxsw_sp, rulei, mact, val, extack);
+	if (err != -EOPNOTSUPP)
+		return err;
+
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
+	return err;
+}
+
+static int mlxsw_sp2_acl_rulei_act_mangle_field(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_acl_rule_info *rulei,
+						struct mlxsw_sp_acl_mangle_action *mact,
+						u32 val, struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = mlxsw_sp_acl_rulei_act_mangle_field(mlxsw_sp, rulei, mact, val, extack);
+	if (err != -EOPNOTSUPP)
+		return err;
+
+	NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
+	return err;
 }
 
 int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
@@ -576,6 +604,7 @@ int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
 				  u32 offset, u32 mask, u32 val,
 				  struct netlink_ext_ack *extack)
 {
+	const struct mlxsw_sp_acl_rulei_ops *acl_rulei_ops = mlxsw_sp->acl_rulei_ops;
 	struct mlxsw_sp_acl_mangle_action *mact;
 	size_t i;
 
@@ -585,13 +614,13 @@ int mlxsw_sp_acl_rulei_act_mangle(struct mlxsw_sp *mlxsw_sp,
 		    mact->offset == offset &&
 		    mact->mask == mask) {
 			val >>= mact->shift;
-			return mlxsw_sp_acl_rulei_act_mangle_field(mlxsw_sp,
-								   rulei, mact,
-								   val, extack);
+			return acl_rulei_ops->act_mangle_field(mlxsw_sp,
+							       rulei, mact,
+							       val, extack);
 		}
 	}
 
-	NL_SET_ERR_MSG_MOD(extack, "Unsupported mangle field");
+	NL_SET_ERR_MSG_MOD(extack, "Unknown mangle field");
 	return -EINVAL;
 }
 
@@ -930,3 +959,11 @@ int mlxsw_sp_acl_region_rehash_intrvl_set(struct mlxsw_sp *mlxsw_sp, u32 val)
 	return mlxsw_sp_acl_tcam_vregion_rehash_intrvl_set(mlxsw_sp,
 							   &acl->tcam, val);
 }
+
+struct mlxsw_sp_acl_rulei_ops mlxsw_sp1_acl_rulei_ops = {
+	.act_mangle_field = mlxsw_sp1_acl_rulei_act_mangle_field,
+};
+
+struct mlxsw_sp_acl_rulei_ops mlxsw_sp2_acl_rulei_ops = {
+	.act_mangle_field = mlxsw_sp2_acl_rulei_act_mangle_field,
+};
-- 
2.26.2

