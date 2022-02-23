Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD0E4C1963
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbiBWRFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243160AbiBWRFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE00853B71
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A0F1B82107
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 17:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B259CC36AE5;
        Wed, 23 Feb 2022 17:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645635886;
        bh=5RNPcucXqAdYsDrARFlHmphEMrY5nh3OmyRWD3Akv/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpnINd4Gp3VI+JDYQCfK97QJ4c7R0WHU0AwKOB+dQm5pWyuSK0Oj0M9++q/+oHcYf
         nQbU4p3Na9NssEJhY9ariVrxPKXgTVwxJQyXXsgTy0Xf0vMJIRyzjaHNnhV1S/Vrec
         eEfQMSf1ptxWKUiM5zW2DqXaDcNzeijcjLoAzdBiyyY7c+8wQeXRKrYfdApi+R1DHG
         6ufzedfDryvWXMcFFi3p4E2IMDrAeAD21+BiJm0f3VPo/WWJ9OKpyg9Zeg/O86vhES
         joFqejHAi2lfTGz9eMNgO07wF3vBT8BOczdsW0mJW6hc8EbnDsnoCfDvya8jv1Fw4C
         Xo4kpU/NdE2aw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 17/19] net/mlx5e: MPLSoUDP decap, fix check for unsupported matches
Date:   Wed, 23 Feb 2022 09:04:28 -0800
Message-Id: <20220223170430.295595-18-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223170430.295595-1-saeed@kernel.org>
References: <20220223170430.295595-1-saeed@kernel.org>
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

From: Maor Dickman <maord@nvidia.com>

Currently offload of rule on bareudp device require tunnel key
in order to match on mpls fields and without it the mpls fields
are ignored, this is incorrect due to the fact udp tunnel doesn't
have key to match on.

Fix by returning error in case flow is matching on tunnel key.

Fixes: 72046a91d134 ("net/mlx5e: Allow to match on mpls parameters")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c   | 28 ++++++++-----------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index f40dbfcb6437..c5b1617d556f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -59,37 +59,31 @@ static int parse_tunnel(struct mlx5e_priv *priv,
 			void *headers_v)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
-	struct flow_match_enc_keyid enc_keyid;
 	struct flow_match_mpls match;
 	void *misc2_c;
 	void *misc2_v;
 
-	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
-			       misc_parameters_2);
-	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
-			       misc_parameters_2);
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
-		return 0;
-
-	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
-		return 0;
-
-	flow_rule_match_enc_keyid(rule, &enc_keyid);
-
-	if (!enc_keyid.mask->keyid)
-		return 0;
-
 	if (!MLX5_CAP_ETH(priv->mdev, tunnel_stateless_mpls_over_udp) &&
 	    !(MLX5_CAP_GEN(priv->mdev, flex_parser_protocols) & MLX5_FLEX_PROTO_CW_MPLS_UDP))
 		return -EOPNOTSUPP;
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_KEYID))
+		return -EOPNOTSUPP;
+
+	if (!flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_MPLS))
+		return 0;
+
 	flow_rule_match_mpls(rule, &match);
 
 	/* Only support matching the first LSE */
 	if (match.mask->used_lses != 1)
 		return -EOPNOTSUPP;
 
+	misc2_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			       misc_parameters_2);
+	misc2_v = MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			       misc_parameters_2);
+
 	MLX5_SET(fte_match_set_misc2, misc2_c,
 		 outer_first_mpls_over_udp.mpls_label,
 		 match.mask->ls[0].mpls_label);
-- 
2.35.1

