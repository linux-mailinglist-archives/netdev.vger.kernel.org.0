Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5A0350807
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhCaURM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236413AbhCaUQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 122ED610C8;
        Wed, 31 Mar 2021 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221801;
        bh=BvVSfcwizxrreuZr9YBkQn4pjp3GOarm7PZdFHLRvzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+catqqXMPisIPsmuNupFZYwJpCwCQIvyY8H4VY2bGX6buzuZdxd3/PrPpiz1NsK2
         RgSdozCyUt4pfM3M4si5+Ez3+unFRC21Lgg/fDvudJZ86iPBxjqNki2vQCipgCIQt8
         bHOWi2DyZErHeZKh3K1N2lJno/lFNDFWSdQI7l4hLvubhRjCMKavF6hqL4vZDWe/8K
         kDYwedgpvZjd1NkrQbpjcDzTpEHsCpreMDicQ5V3FGBH/1z8x5wxMDPBKowlDMkWms
         UP+qOr5XUgeHh+GYNYL6b7gFQbuzc+2crH6CPVCHDjQf3Ba1oNyKCRp38nDkDcohOE
         +Otq3Eec+dl/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 8/9] net/mlx5e: Consider geneve_opts for encap contexts
Date:   Wed, 31 Mar 2021 13:14:23 -0700
Message-Id: <20210331201424.331095-9-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dima Chumak <dchumak@nvidia.com>

Current algorithm for encap keys is legacy from initial vxlan
implementation and doesn't take into account all possible fields of a
tunnel. For example, for a Geneve tunnel, which may have additional TLV
options, they are ignored when comparing encap keys and a rule can be
attached to an incorrect encap entry.

Fix that by introducing encap_info_equal() operation in
struct mlx5e_tc_tunnel. Geneve tunnel type uses custom implementation,
which extends generic algorithm and considers options if they are set.

Fixes: 7f1a546e3222 ("net/mlx5e: Consider tunnel type for encap contexts")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   | 10 +++++++
 .../mellanox/mlx5/core/en/tc_tun_encap.c      | 23 ++++++---------
 .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 29 +++++++++++++++++++
 .../mellanox/mlx5/core/en/tc_tun_gre.c        |  1 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c   |  1 +
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      |  1 +
 6 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 67de2bf36861..e1271998b937 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -21,6 +21,11 @@ enum {
 	MLX5E_TC_TUNNEL_TYPE_MPLSOUDP,
 };
 
+struct mlx5e_encap_key {
+	const struct ip_tunnel_key *ip_tun_key;
+	struct mlx5e_tc_tunnel     *tc_tunnel;
+};
+
 struct mlx5e_tc_tunnel {
 	int tunnel_type;
 	enum mlx5_flow_match_level match_level;
@@ -44,6 +49,8 @@ struct mlx5e_tc_tunnel {
 			    struct flow_cls_offload *f,
 			    void *headers_c,
 			    void *headers_v);
+	bool (*encap_info_equal)(struct mlx5e_encap_key *a,
+				 struct mlx5e_encap_key *b);
 };
 
 extern struct mlx5e_tc_tunnel vxlan_tunnel;
@@ -101,6 +108,9 @@ int mlx5e_tc_tun_parse_udp_ports(struct mlx5e_priv *priv,
 				 void *headers_c,
 				 void *headers_v);
 
+bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
+					   struct mlx5e_encap_key *b);
+
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif //__MLX5_EN_TC_TUNNEL_H__
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 7f7b0f6dcdf9..9f16ad2c0710 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -476,16 +476,11 @@ void mlx5e_detach_decap(struct mlx5e_priv *priv,
 	mlx5e_decap_dealloc(priv, d);
 }
 
-struct encap_key {
-	const struct ip_tunnel_key *ip_tun_key;
-	struct mlx5e_tc_tunnel *tc_tunnel;
-};
-
-static int cmp_encap_info(struct encap_key *a,
-			  struct encap_key *b)
+bool mlx5e_tc_tun_encap_info_equal_generic(struct mlx5e_encap_key *a,
+					   struct mlx5e_encap_key *b)
 {
-	return memcmp(a->ip_tun_key, b->ip_tun_key, sizeof(*a->ip_tun_key)) ||
-		a->tc_tunnel->tunnel_type != b->tc_tunnel->tunnel_type;
+	return memcmp(a->ip_tun_key, b->ip_tun_key, sizeof(*a->ip_tun_key)) == 0 &&
+		a->tc_tunnel->tunnel_type == b->tc_tunnel->tunnel_type;
 }
 
 static int cmp_decap_info(struct mlx5e_decap_key *a,
@@ -494,7 +489,7 @@ static int cmp_decap_info(struct mlx5e_decap_key *a,
 	return memcmp(&a->key, &b->key, sizeof(b->key));
 }
 
-static int hash_encap_info(struct encap_key *key)
+static int hash_encap_info(struct mlx5e_encap_key *key)
 {
 	return jhash(key->ip_tun_key, sizeof(*key->ip_tun_key),
 		     key->tc_tunnel->tunnel_type);
@@ -516,18 +511,18 @@ static bool mlx5e_decap_take(struct mlx5e_decap_entry *e)
 }
 
 static struct mlx5e_encap_entry *
-mlx5e_encap_get(struct mlx5e_priv *priv, struct encap_key *key,
+mlx5e_encap_get(struct mlx5e_priv *priv, struct mlx5e_encap_key *key,
 		uintptr_t hash_key)
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5e_encap_key e_key;
 	struct mlx5e_encap_entry *e;
-	struct encap_key e_key;
 
 	hash_for_each_possible_rcu(esw->offloads.encap_tbl, e,
 				   encap_hlist, hash_key) {
 		e_key.ip_tun_key = &e->tun_info->key;
 		e_key.tc_tunnel = e->tunnel;
-		if (!cmp_encap_info(&e_key, key) &&
+		if (e->tunnel->encap_info_equal(&e_key, key) &&
 		    mlx5e_encap_take(e))
 			return e;
 	}
@@ -694,8 +689,8 @@ int mlx5e_attach_encap(struct mlx5e_priv *priv,
 	struct mlx5_flow_attr *attr = flow->attr;
 	const struct ip_tunnel_info *tun_info;
 	unsigned long tbl_time_before = 0;
-	struct encap_key key;
 	struct mlx5e_encap_entry *e;
+	struct mlx5e_encap_key key;
 	bool entry_created = false;
 	unsigned short family;
 	uintptr_t hash_key;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
index 7ed3f9f79f11..f5b26f5a7de4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c
@@ -329,6 +329,34 @@ static int mlx5e_tc_tun_parse_geneve(struct mlx5e_priv *priv,
 	return mlx5e_tc_tun_parse_geneve_options(priv, spec, f);
 }
 
+static bool mlx5e_tc_tun_encap_info_equal_geneve(struct mlx5e_encap_key *a,
+						 struct mlx5e_encap_key *b)
+{
+	struct ip_tunnel_info *a_info;
+	struct ip_tunnel_info *b_info;
+	bool a_has_opts, b_has_opts;
+
+	if (!mlx5e_tc_tun_encap_info_equal_generic(a, b))
+		return false;
+
+	a_has_opts = !!(a->ip_tun_key->tun_flags & TUNNEL_GENEVE_OPT);
+	b_has_opts = !!(b->ip_tun_key->tun_flags & TUNNEL_GENEVE_OPT);
+
+	/* keys are equal when both don't have any options attached */
+	if (!a_has_opts && !b_has_opts)
+		return true;
+
+	if (a_has_opts != b_has_opts)
+		return false;
+
+	/* geneve options stored in memory next to ip_tunnel_info struct */
+	a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
+	b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
+
+	return a_info->options_len == b_info->options_len &&
+		memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
+}
+
 struct mlx5e_tc_tunnel geneve_tunnel = {
 	.tunnel_type          = MLX5E_TC_TUNNEL_TYPE_GENEVE,
 	.match_level          = MLX5_MATCH_L4,
@@ -338,4 +366,5 @@ struct mlx5e_tc_tunnel geneve_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_geneve,
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_geneve,
 	.parse_tunnel         = mlx5e_tc_tun_parse_geneve,
+	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_geneve,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
index 2805416c32a3..ada14f0574dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_gre.c
@@ -94,4 +94,5 @@ struct mlx5e_tc_tunnel gre_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_gretap,
 	.parse_udp_ports      = NULL,
 	.parse_tunnel         = mlx5e_tc_tun_parse_gretap,
+	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
index 3479672e84cf..60952b33b568 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -131,4 +131,5 @@ struct mlx5e_tc_tunnel mplsoudp_tunnel = {
 	.generate_ip_tun_hdr  = generate_ip_tun_hdr,
 	.parse_udp_ports      = parse_udp_ports,
 	.parse_tunnel         = parse_tunnel,
+	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 038a0f1cecec..4267f3a1059e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -150,4 +150,5 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_vxlan,
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_vxlan,
 	.parse_tunnel         = mlx5e_tc_tun_parse_vxlan,
+	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
 };
-- 
2.30.2

