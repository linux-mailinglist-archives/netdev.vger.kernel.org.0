Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F57486F48
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344905AbiAGA64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344883AbiAGA6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC1DC0611FD
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DF761EAB
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBA0C36AF6;
        Fri,  7 Jan 2022 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517127;
        bh=5jD1OzQ5f7jM99gGeK9vAw2XeqxWy8Ppmlr0pVBeQV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qp3MiyNZJ4WtdK7PdT02l+MM90LsqHaIYpAYm/8VRb+CmIgqyv9eBlCoIwtLzYiMC
         md2kuyZOlVSQ2o4HpuCD6o/XRgDK9OhH713sP9jTSGqQSvBprJMC/H0BWGsdPBrDNW
         DX9OI7Y/dxVQzsJaXISV9W4JNPx3GqkzSsYbDgbsQhG++mfNok0CE90YbBWtvmDapt
         1+PDyjctGfSM+aEdm0UHsk0+5Y4x8/fmk7U3gLmeHF2dDZxjSuyB9rRU08ffhDRFFq
         L0g3QyQgf1CI7ebN2SQRzXekGr8bql37lsHfXBClsET/LKFAB0Ddwbh2DmQDrwS6hG
         ZX0MqdVK252vg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/11] net/mlx5e: Fix matching on modified inner ip_ecn bits
Date:   Thu,  6 Jan 2022 16:58:27 -0800
Message-Id: <20220107005831.78909-8-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Tunnel device follows RFC 6040, and during decapsulation inner
ip_ecn might change depending on inner and outer ip_ecn as follows:

 +---------+----------------------------------------+
 |Arriving |         Arriving Outer Header          |
 |   Inner +---------+---------+---------+----------+
 |  Header | Not-ECT | ECT(0)  | ECT(1)  |   CE     |
 +---------+---------+---------+---------+----------+
 | Not-ECT | Not-ECT | Not-ECT | Not-ECT | <drop>   |
 |  ECT(0) |  ECT(0) | ECT(0)  | ECT(1)  |   CE*    |
 |  ECT(1) |  ECT(1) | ECT(1)  | ECT(1)* |   CE*    |
 |    CE   |   CE    |  CE     | CE      |   CE     |
 +---------+---------+---------+---------+----------+

Cells marked above are changed from original inner packet ip_ecn value.

Tc then matches on the modified inner ip_ecn, but hw offload which
matches the inner ip_ecn value before decap, will fail.

Fix that by mapping all the cases of outer and inner ip_ecn matching,
and only supporting cases where we know inner wouldn't be changed by
decap, or in the outer ip_ecn=CE case, inner ip_ecn didn't matter.

Fixes: bcef735c59f2 ("net/mlx5e: Offload TC matching on tos/ttl for ip tunnels")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 120 +++++++++++++++++-
 1 file changed, 116 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 5e454a14428f..9b3adaccc9be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1949,6 +1949,111 @@ u8 mlx5e_tc_get_ip_version(struct mlx5_flow_spec *spec, bool outer)
 	return ip_version;
 }
 
+/* Tunnel device follows RFC 6040, see include/net/inet_ecn.h.
+ * And changes inner ip_ecn depending on inner and outer ip_ecn as follows:
+ *      +---------+----------------------------------------+
+ *      |Arriving |         Arriving Outer Header          |
+ *      |   Inner +---------+---------+---------+----------+
+ *      |  Header | Not-ECT | ECT(0)  | ECT(1)  |   CE     |
+ *      +---------+---------+---------+---------+----------+
+ *      | Not-ECT | Not-ECT | Not-ECT | Not-ECT | <drop>   |
+ *      |  ECT(0) |  ECT(0) | ECT(0)  | ECT(1)  |   CE*    |
+ *      |  ECT(1) |  ECT(1) | ECT(1)  | ECT(1)* |   CE*    |
+ *      |    CE   |   CE    |  CE     | CE      |   CE     |
+ *      +---------+---------+---------+---------+----------+
+ *
+ * Tc matches on inner after decapsulation on tunnel device, but hw offload matches
+ * the inner ip_ecn value before hardware decap action.
+ *
+ * Cells marked are changed from original inner packet ip_ecn value during decap, and
+ * so matching those values on inner ip_ecn before decap will fail.
+ *
+ * The following helper allows offload when inner ip_ecn won't be changed by outer ip_ecn,
+ * except for the outer ip_ecn = CE, where in all cases inner ip_ecn will be changed to CE,
+ * and such we can drop the inner ip_ecn=CE match.
+ */
+
+static int mlx5e_tc_verify_tunnel_ecn(struct mlx5e_priv *priv,
+				      struct flow_cls_offload *f,
+				      bool *match_inner_ecn)
+{
+	u8 outer_ecn_mask = 0, outer_ecn_key = 0, inner_ecn_mask = 0, inner_ecn_key = 0;
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_match_ip match;
+
+	*match_inner_ecn = true;
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
+		flow_rule_match_enc_ip(rule, &match);
+		outer_ecn_key = match.key->tos & INET_ECN_MASK;
+		outer_ecn_mask = match.mask->tos & INET_ECN_MASK;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IP)) {
+		flow_rule_match_ip(rule, &match);
+		inner_ecn_key = match.key->tos & INET_ECN_MASK;
+		inner_ecn_mask = match.mask->tos & INET_ECN_MASK;
+	}
+
+	if (outer_ecn_mask != 0 && outer_ecn_mask != INET_ECN_MASK) {
+		NL_SET_ERR_MSG_MOD(extack, "Partial match on enc_tos ecn bits isn't supported");
+		netdev_warn(priv->netdev, "Partial match on enc_tos ecn bits isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!outer_ecn_mask) {
+		if (!inner_ecn_mask)
+			return 0;
+
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on tos ecn bits without also matching enc_tos ecn bits isn't supported");
+		netdev_warn(priv->netdev,
+			    "Matching on tos ecn bits without also matching enc_tos ecn bits isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (inner_ecn_mask && inner_ecn_mask != INET_ECN_MASK) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Partial match on tos ecn bits with match on enc_tos ecn bits isn't supported");
+		netdev_warn(priv->netdev,
+			    "Partial match on tos ecn bits with match on enc_tos ecn bits isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (!inner_ecn_mask)
+		return 0;
+
+	/* Both inner and outer have full mask on ecn */
+
+	if (outer_ecn_key == INET_ECN_ECT_1) {
+		/* inner ecn might change by DECAP action */
+
+		NL_SET_ERR_MSG_MOD(extack, "Match on enc_tos ecn = ECT(1) isn't supported");
+		netdev_warn(priv->netdev, "Match on enc_tos ecn = ECT(1) isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	if (outer_ecn_key != INET_ECN_CE)
+		return 0;
+
+	if (inner_ecn_key != INET_ECN_CE) {
+		/* Can't happen in software, as packet ecn will be changed to CE after decap */
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Match on tos enc_tos ecn = CE while match on tos ecn != CE isn't supported");
+		netdev_warn(priv->netdev,
+			    "Match on tos enc_tos ecn = CE while match on tos ecn != CE isn't supported");
+		return -EOPNOTSUPP;
+	}
+
+	/* outer ecn = CE, inner ecn = CE, as decap will change inner ecn to CE in anycase,
+	 * drop match on inner ecn
+	 */
+	*match_inner_ecn = false;
+
+	return 0;
+}
+
 static int parse_tunnel_attr(struct mlx5e_priv *priv,
 			     struct mlx5e_tc_flow *flow,
 			     struct mlx5_flow_spec *spec,
@@ -2144,6 +2249,7 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
 	enum fs_flow_table_type fs_type;
+	bool match_inner_ecn = true;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
@@ -2197,6 +2303,10 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 			headers_c = get_match_inner_headers_criteria(spec);
 			headers_v = get_match_inner_headers_value(spec);
 		}
+
+		err = mlx5e_tc_verify_tunnel_ecn(priv, f, &match_inner_ecn);
+		if (err)
+			return err;
 	}
 
 	err = mlx5e_flower_parse_meta(filter_dev, f);
@@ -2420,10 +2530,12 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		struct flow_match_ip match;
 
 		flow_rule_match_ip(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
-			 match.mask->tos & 0x3);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
-			 match.key->tos & 0x3);
+		if (match_inner_ecn) {
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_ecn,
+				 match.mask->tos & 0x3);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ip_ecn,
+				 match.key->tos & 0x3);
+		}
 
 		MLX5_SET(fte_match_set_lyr_2_4, headers_c, ip_dscp,
 			 match.mask->tos >> 2);
-- 
2.33.1

