Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B737D49EC8D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344061AbiA0UkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:40:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37730 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344054AbiA0UkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:40:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88B361988
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 20:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC6FC340EA;
        Thu, 27 Jan 2022 20:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643316014;
        bh=AYbV5nbsbgYC3As/qvFCJ8yQkF2omZ+Sw7YNPnNq6fg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=il+DE+rN28vbaOVdQ8L5L5cs62Ms4s326uuLVdoBT3hhmYnKpgQkad/86HLjgulxf
         FUzPlYWY4veYQqm+fWMg1xTKZBwOsjRl8cp9WunzLk4BOLXA/21dcTbGIGlR7xMcTI
         rvW1jbS6btiqUW7lSOcPm0Mhm07ML0VUS5R/9uFw1nvZkTzbCWTtaTN9Cy70FpFnQl
         Y9sJwaoeTFOCKPtfAOD6NgVCoWfIUPiSQoz9L5q4eKxYA5whbI3S6sGgabOpau7iww
         XaJZwhuvo8YUAPf7HrNeXijDOs9D2F/xPH1l1LrXk3RcmIKAW/ZAQhz0sq8XKZZ8xt
         QhK4F9efAMwGQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next RESEND 07/17] net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr
Date:   Thu, 27 Jan 2022 12:39:57 -0800
Message-Id: <20220127204007.146300-8-saeed@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127204007.146300-1-saeed@kernel.org>
References: <20220127204007.146300-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

In later commit we are going to instantiate multiple attr instances
for flow instead of single attr.
Make sure mlx5e_tc_add_flow_mod_hdr() use the correct attr and not flow->attr.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c    |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c      | 12 ++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h      |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index c8cb173f1ffb..1f8d339ff0c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1380,7 +1380,7 @@ static void mlx5e_reoffload_encap(struct mlx5e_priv *priv,
 			continue;
 		}
 
-		err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+		err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "Failed to update flow mod_hdr err=%d",
 				       err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index de07ccd6ac7b..9201ba8fa509 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1360,10 +1360,10 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 }
 
 int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow_parse_attr *parse_attr,
-			      struct mlx5e_tc_flow *flow)
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &parse_attr->mod_hdr_acts;
+	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 	struct mlx5_modify_hdr *mod_hdr;
 
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
@@ -1373,8 +1373,8 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 	if (IS_ERR(mod_hdr))
 		return PTR_ERR(mod_hdr);
 
-	WARN_ON(flow->attr->modify_hdr);
-	flow->attr->modify_hdr = mod_hdr;
+	WARN_ON(attr->modify_hdr);
+	attr->modify_hdr = mod_hdr;
 
 	return 0;
 }
@@ -1577,7 +1577,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
 		if (vf_tun) {
-			err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+			err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 			if (err)
 				goto err_out;
 		} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 5ffae9b13066..0da5ea44f607 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -243,8 +243,8 @@ int mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
 					 u32 data);
 
 int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow_parse_attr *parse_attr,
-			      struct mlx5e_tc_flow *flow);
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_attr *attr);
 
 struct mlx5e_tc_flow;
 u32 mlx5e_tc_get_flow_tun_id(struct mlx5e_tc_flow *flow);
-- 
2.34.1

