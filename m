Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 694A0595A0C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233718AbiHPL0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiHPLZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642F659257
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B72960FAD
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04D0C433C1;
        Tue, 16 Aug 2022 10:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646387;
        bh=2ZuC+HmM/kaFnYZeCswoXQXUkTQzOBsj5hfEmRCgW6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbeGS3CuijJQLpRmM9SNJHg/M7R8vdI4UlHEU3ztDVfaAkxLy9S2+DsgzFu8Xa1WT
         mEi2fXItPaviiAs4pwiKySaZ4GHZx8Zv4W3Mpfsk71n+YdtEEcWEOWSQ2kQEB5sIE9
         IidyssRf2Z6yTHD7JNHtaASA8vPUQwj5+ThtymOT0LtDIKbesKgBWA5Jy9kuGUmbx4
         2kzuTTaYKUoWEpAhqySVET1ILk8ksNUEQ7D/bw5tIX33KGzdPJ2qg4bW6A4W8Jj4lt
         7AUK+Qg9rAli8qChs7DzbwW3bX0rJryHlJ9XoXQdJrZ3q2si4MnJ+mJ4wlgmx6keOg
         mQr9lmVGSHpbg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 14/26] net/mlx5e: Refactor FTE setup code to be more clear
Date:   Tue, 16 Aug 2022 13:38:02 +0300
Message-Id: <604f24270e8369f17bed23edb54da4cdda6b5c6b.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 136 +++++++++++-------
 1 file changed, 83 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 291533d55e2d..19e22780f846 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -331,60 +331,78 @@ static void tx_ft_put(struct mlx5e_ipsec *ipsec)
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
 
-	flow_act->ipsec_obj_id = ipsec_obj_id;
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
@@ -394,7 +412,6 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	u32 ipsec_obj_id = sa_entry->ipsec_obj_id;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
@@ -413,13 +430,21 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
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
 
@@ -433,6 +458,8 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		goto out_err;
 	}
 
+	flow_act.ipsec_obj_id = sa_entry->ipsec_obj_id;
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT |
 			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
@@ -462,6 +489,7 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
+	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
 	struct mlx5_flow_act flow_act = {};
@@ -480,16 +508,18 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
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
 
+	flow_act.ipsec_obj_id = sa_entry->ipsec_obj_id;
+	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
 			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT;
 	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, NULL, 0);
-- 
2.37.2

