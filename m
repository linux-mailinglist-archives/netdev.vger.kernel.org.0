Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542874C2080
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 01:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245204AbiBXANP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 19:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245200AbiBXAM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 19:12:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392E45F4D6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 16:12:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C885C60C51
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 00:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F82C340EB;
        Thu, 24 Feb 2022 00:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645661546;
        bh=5RNPcucXqAdYsDrARFlHmphEMrY5nh3OmyRWD3Akv/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T0aFIKE2Dvj7FLuxJmuDXz+BjNU7ZBNuWFJUIWGd3NedsB/DgsjZoF+ZffEM+XJe6
         WGryd4nEJvzsr7UjIsjBydCV/b0ZaVX+TGCCcXWtFRhbE7r1k8yYiQFvl5xWgBeyVz
         1riFpd0/9tnTxpMUC3ZRQSOq7XtbK5vvV2uEDaed48OWtJEg1+3KrX0vJRAQSpTKEJ
         aNlKoFcAo9LtKSzrwDMJtrv5wO9VTmAYIzziVO4Fy4r+RJ80hAgjC0Uu+7zU8z/Mn2
         Xi+45K2qPV4d/h2b+X7gAj/IED9P42UNABhRD7HQJ6GtaBaYrRgu/hPU7ghcXzWFWo
         4mNUL5HCESf6g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [v2 net 17/19] net/mlx5e: MPLSoUDP decap, fix check for unsupported matches
Date:   Wed, 23 Feb 2022 16:11:21 -0800
Message-Id: <20220224001123.365265-18-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224001123.365265-1-saeed@kernel.org>
References: <20220224001123.365265-1-saeed@kernel.org>
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

