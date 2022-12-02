Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94934640EF0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiLBUMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiLBULe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CFFF1CCF
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A85E7622CB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C48DC433C1;
        Fri,  2 Dec 2022 20:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011890;
        bh=tgMh15cyno/75xkIEGH1Z8OvjMnkpPDH4FcE5iTR7AA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAwrUQd0lj42iJnGrirClgxiXZJNd7E1xiGv9ftAfhxQJHBYwnhTS2vkHPCgD2oMj
         K+z3VgLRxcLGm2ChV1WcAJJxGgEPA5xYXB47XGjYBJwwo1+rvwCcPDhM+HyrJgVNie
         rj/txDjzePUZ7HV11r1qe2mZqTTmpRAx+k+xLdAU20+7UuhtOxnoxPhQBKUDlwSb00
         9phIa0dJqGh3j9D15d3vqFJGynfFutTnJr/j8ITWgE7nXLLHspqtoZBijo6fcxshXg
         3nub+U945mmvOK9SHwi0LWj8uHDc+jyEk/FFbBI66M/jGQWgY4WEy5plVuvq8tHkF8
         Z2XhF7I19iJvA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 12/16] net/mlx5e: Refactor FTE setup code to be more clear
Date:   Fri,  2 Dec 2022 22:10:33 +0200
Message-Id: <2752cbcd615ce39f927a7c074d53a08a9bb4ed43.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

The policy offload logic needs to set flow steering rule that match
on saddr and daddr too, so factor out this code to separate functions,
together with code alignment to netdev coding pattern of relying on
family type.

As part of this change, let's separate more logic from setup_fte_common
to make sure that the function names describe that is done in the
function better than general *common* name.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 139 +++++++++++-------
 1 file changed, 85 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index f65a74e3d648..4c5904544bda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -326,61 +326,78 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
 	mutex_unlock(&tx->ft.mutex);
 }
 
-static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
-			     u32 ipsec_obj_id,
-			     struct mlx5_flow_spec *spec,
-			     struct mlx5_flow_act *flow_act)
+static void setup_fte_addr4(struct mlx5_flow_spec *spec, __be32 *saddr,
+			    __be32 *daddr)
 {
-	u8 ip_version = (attrs->family == AF_INET) ? 4 : 6;
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
 
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS;
-
-	/* ip_version */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
-	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 4);
+
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4), saddr, 4);
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4), daddr, 4);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+}
 
-	/* Non fragmented */
-	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.frag);
-	MLX5_SET(fte_match_param, spec->match_value, outer_headers.frag, 0);
+static void setup_fte_addr6(struct mlx5_flow_spec *spec, __be32 *saddr,
+			    __be32 *daddr)
+{
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 6);
+
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), saddr, 16);
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), daddr, 16);
+	memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6), 0xff, 16);
+	memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6), 0xff, 16);
+}
 
+static void setup_fte_esp(struct mlx5_flow_spec *spec)
+{
 	/* ESP header */
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
 	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_ESP);
+}
 
+static void setup_fte_spi(struct mlx5_flow_spec *spec, u32 spi)
+{
 	/* SPI number */
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS;
+
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
-	MLX5_SET(fte_match_param, spec->match_value,
-		 misc_parameters.outer_esp_spi, attrs->spi);
-
-	if (ip_version == 4) {
-		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				    outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4),
-		       &attrs->saddr.a4, 4);
-		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
-		       &attrs->daddr.a4, 4);
-		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
-				 outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
-		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
-				 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
-	} else {
-		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &attrs->saddr.a6, 16);
-		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &attrs->daddr.a6, 16);
-		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       0xff, 16);
-		memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-				    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       0xff, 16);
-	}
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi, spi);
+}
 
-	flow_act->crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
-	flow_act->crypto.obj_id = ipsec_obj_id;
-	flow_act->flags |= FLOW_ACT_NO_APPEND;
+static void setup_fte_no_frags(struct mlx5_flow_spec *spec)
+{
+	/* Non fragmented */
+	spec->match_criteria_enable |= MLX5_MATCH_OUTER_HEADERS;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.frag);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.frag, 0);
+}
+
+static void setup_fte_reg_a(struct mlx5_flow_spec *spec)
+{
+	/* Add IPsec indicator in metadata_reg_a */
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
+
+	MLX5_SET(fte_match_param, spec->match_criteria,
+		 misc_parameters_2.metadata_reg_a, MLX5_ETH_WQE_FT_META_IPSEC);
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters_2.metadata_reg_a, MLX5_ETH_WQE_FT_META_IPSEC);
 }
 
 static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
@@ -390,7 +407,6 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
@@ -409,13 +425,21 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		goto out_err;
 	}
 
-	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
+	if (attrs->family == AF_INET)
+		setup_fte_addr4(spec, &attrs->saddr.a4, &attrs->daddr.a4);
+	else
+		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
+
+	setup_fte_spi(spec, attrs->spi);
+	setup_fte_esp(spec);
+	setup_fte_no_frags(spec);
 
 	/* Set bit[31] ipsec marker */
 	/* Set bit[23-0] ipsec_obj_id */
 	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_B);
-	MLX5_SET(set_action_in, action, data, (ipsec_obj_id | BIT(31)));
+	MLX5_SET(set_action_in, action, data,
+		 (sa_entry->ipsec_obj_id | BIT(31)));
 	MLX5_SET(set_action_in, action, offset, 0);
 	MLX5_SET(set_action_in, action, length, 32);
 
@@ -429,6 +453,9 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		goto out_err;
 	}
 
+	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
+	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
 			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
@@ -458,6 +485,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5_flow_act flow_act = {};
@@ -476,16 +504,19 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		goto out;
 	}
 
-	setup_fte_common(&sa_entry->attrs, sa_entry->ipsec_obj_id, spec,
-			 &flow_act);
+	if (attrs->family == AF_INET)
+		setup_fte_addr4(spec, &attrs->saddr.a4, &attrs->daddr.a4);
+	else
+		setup_fte_addr6(spec, attrs->saddr.a6, attrs->daddr.a6);
 
-	/* Add IPsec indicator in metadata_reg_a */
-	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
-	MLX5_SET(fte_match_param, spec->match_criteria, misc_parameters_2.metadata_reg_a,
-		 MLX5_ETH_WQE_FT_META_IPSEC);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters_2.metadata_reg_a,
-		 MLX5_ETH_WQE_FT_META_IPSEC);
+	setup_fte_spi(spec, attrs->spi);
+	setup_fte_esp(spec);
+	setup_fte_no_frags(spec);
+	setup_fte_reg_a(spec);
 
+	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
+	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
 			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT;
 	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, NULL, 0);
-- 
2.38.1

