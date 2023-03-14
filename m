Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357F66B8DFD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjCNJAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCNI7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 04:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8135494F64
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FDB66164E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADBEC433D2;
        Tue, 14 Mar 2023 08:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784369;
        bh=DWd4aV7AfXIILs5zA4w30dW0oTBSiW20i87q+EvAQmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odfuMnvzfz8vNspeCCDkDyjyScFzD7lLCeIn6hz+Rfrrw0hBb0KiaWUC1WLoWhqKR
         oUR2qIecTEk6B582d7xTKdrXWnnPDY5Q0NkTJcjGmcZK9feKMeqsvuDKcDwd/Pt26u
         hI2Ey7OWc5a0rYdken+TpmZ6k+seTjnLPVZIyVKtNfGoQJ6Ik3xRDHKdvW0o9g+JJC
         l4GUKlUtXzQ/CCqzqD7KOjottDTvowPEeBDOkvhEGQZ6FFDkD26O0o0QrZB13qJKqS
         BK0h54p1e0TawlS1rWaJ5QqFSP09uygizSZrp5hu7xzgaCcGe7KwVTsEyzXY2CZ5Rf
         hBJP01/pZ2I0A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 6/9] net/mlx5e: Allow policies with reqid 0, to support IKE policy holes
Date:   Tue, 14 Mar 2023 10:58:41 +0200
Message-Id: <cbcadde312c24de74c47d9b0616f86a5818cc9bf.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

IKE policies hole, is special policy that exists to allow for IKE
traffic to bypass IPsec encryption even though there is already a
policies and SA(s) configured on same endpoints, these policies
does not nessecarly have the reqid configured, so need to add
an exception for such policies. These kind of policies are allowed
under the condition that at least upper protocol and/or ips
are not 0.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 11 +--
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  7 ++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 68 ++++++++++++-------
 3 files changed, 59 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 83012bece548..9cc59dc8b592 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -503,6 +503,8 @@ static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
 				      struct xfrm_policy *x,
 				      struct netlink_ext_ack *extack)
 {
+	struct xfrm_selector *sel = &x->selector;
+
 	if (x->type != XFRM_POLICY_TYPE_MAIN) {
 		NL_SET_ERR_MSG_MOD(extack, "Cannot offload non-main policy types");
 		return -EINVAL;
@@ -520,8 +522,9 @@ static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
 		return -EINVAL;
 	}
 
-	if (!x->xfrm_vec[0].reqid) {
-		NL_SET_ERR_MSG_MOD(extack, "Cannot offload policy without reqid");
+	if (!x->xfrm_vec[0].reqid && sel->proto == IPPROTO_IP &&
+	    addr6_all_zero(sel->saddr.a6) && addr6_all_zero(sel->daddr.a6)) {
+		NL_SET_ERR_MSG_MOD(extack, "Unsupported policy with reqid 0 without at least one of upper protocol or ip addr(s) different than 0");
 		return -EINVAL;
 	}
 
@@ -530,8 +533,8 @@ static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
 		return -EINVAL;
 	}
 
-	if (x->selector.proto != IPPROTO_IP &&
-	    (x->selector.proto != IPPROTO_UDP || x->xdo.dir != XFRM_DEV_OFFLOAD_OUT)) {
+	if (sel->proto != IPPROTO_IP &&
+	    (sel->proto != IPPROTO_UDP || x->xdo.dir != XFRM_DEV_OFFLOAD_OUT)) {
 		NL_SET_ERR_MSG_MOD(extack, "Device does not support upper protocol other than UDP, and only Tx direction");
 		return -EINVAL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index b36e047396da..f3e81c3383e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -254,6 +254,13 @@ mlx5e_ipsec_pol2dev(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
 	return pol_entry->ipsec->mdev;
 }
+
+static inline bool addr6_all_zero(__be32 *addr6)
+{
+	static const __be32 zaddr6[4] = {};
+
+	return !memcmp(addr6, zaddr6, sizeof(*zaddr6));
+}
 #else
 static inline void mlx5e_ipsec_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 0c9640d575a7..9f694a8e21fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -621,37 +621,53 @@ static void tx_ft_put_policy(struct mlx5e_ipsec *ipsec, u32 prio)
 static void setup_fte_addr4(struct mlx5_flow_spec *spec, __be32 *saddr,
 			    __be32 *daddr)
 {
+	if (!*saddr && !*daddr)
+		return;
+
 	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
 	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 4);
 
-	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			    outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4), saddr, 4);
-	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			    outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4), daddr, 4);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
-			 outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
-			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+	if (*saddr) {
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4), saddr, 4);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
+	}
+
+	if (*daddr) {
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4), daddr, 4);
+		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+	}
 }
 
 static void setup_fte_addr6(struct mlx5_flow_spec *spec, __be32 *saddr,
 			    __be32 *daddr)
 {
+	if (addr6_all_zero(saddr) && addr6_all_zero(daddr))
+		return;
+
 	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
 	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 6);
 
-	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
-	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
-	memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), 0xff, 16);
-	memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), 0xff, 16);
+	if (!addr6_all_zero(saddr)) {
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
+		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), 0xff, 16);
+	}
+
+	if (!addr6_all_zero(daddr)) {
+		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
+		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), 0xff, 16);
+	}
 }
 
 static void setup_fte_esp(struct mlx5_flow_spec *spec)
@@ -920,7 +936,8 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		setup_fte_reg_a(spec);
 		break;
 	case XFRM_DEV_OFFLOAD_PACKET:
-		setup_fte_reg_c0(spec, attrs->reqid);
+		if (attrs->reqid)
+			setup_fte_reg_c0(spec, attrs->reqid);
 		err = setup_pkt_reformat(mdev, attrs, &flow_act);
 		if (err)
 			goto err_pkt_reformat;
@@ -989,10 +1006,12 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	setup_fte_no_frags(spec);
 	setup_fte_upper_proto_match(spec, &attrs->upspec);
 
-	err = setup_modify_header(mdev, attrs->reqid, XFRM_DEV_OFFLOAD_OUT,
-				  &flow_act);
-	if (err)
-		goto err_mod_header;
+	if (attrs->reqid) {
+		err = setup_modify_header(mdev, attrs->reqid,
+					  XFRM_DEV_OFFLOAD_OUT, &flow_act);
+		if (err)
+			goto err_mod_header;
+	}
 
 	switch (attrs->action) {
 	case XFRM_POLICY_ALLOW:
@@ -1028,7 +1047,8 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	return 0;
 
 err_action:
-	mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
+	if (attrs->reqid)
+		mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
 err_mod_header:
 	kvfree(spec);
 err_alloc:
@@ -1263,7 +1283,9 @@ void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry)
 		return;
 	}
 
-	mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
+	if (ipsec_rule->modify_hdr)
+		mlx5_modify_header_dealloc(mdev, ipsec_rule->modify_hdr);
+
 	tx_ft_put_policy(pol_entry->ipsec, pol_entry->attrs.prio);
 }
 
-- 
2.39.2

