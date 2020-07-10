Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C965221ADA5
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 05:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGJDru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 23:47:50 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:20955
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgGJDrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 23:47:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8k4ohv2V38hak911bGy6fRDozYE2KJUjOazhX5PbHsDi+afc6F0HMN+7i1wi0utddQXDnVvA2LZj9lMMsJrG5D+miwXOGm4OuaGCjsvTs80q8ZsqQ53eVxZLGBX4iTQmUfAGvP4CO4QKeeQA9ZU7363aovlgKBilhHQ2Jz8+bIVUpW+JeSb8+VLlvX3YeGtBhiWyT4i7ZZifs0N1RsKJns+Wi5eiYsy0S16eUSg67y/OasJDz/4K5zuuSvd4SBsHFoWBtBtZRcvzYoci+a2mVh/Bz+WDlo9/wVoHRhE796EInY1sZZbM5mmLXC+MHXerhyNpGNCD/MjA+1mKPNQeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpcRsWfldJltRItT4jSs7pqWlvhR7OOpw04j7v2ZPT0=;
 b=Hi02sQrL8RCFIXv52bKVUNQOxLam6q3UwAJAamR0C8J66Iuy2XBX5SVwvLZniXFVGVmM3y19M86hEFak1YVJ8YOl3xkGNbxRd1hccZKj4qTWdSn4u6KmrHC/hs4B87v5Dt7cpW+XDbXEfQqKkEEBbF5gI+qZQnpbAa2Z8n5OGesIx/LDPTLX5E8cci7OufvkoVGqvPM8geRSNg7rfOl1Fmi3nlPkwVM+UVvATRQvo2LwEOFx14d4jAroXlNWiqiw+uBY4KfZwFN62nXu5RCcpyXf3vamdGe6t1dE5ATci7yd+bCZxyIWtT8O230qQ6OTveBs/as33m3vfjAuOa4cFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FpcRsWfldJltRItT4jSs7pqWlvhR7OOpw04j7v2ZPT0=;
 b=SsWzlRXMzbVHTDbOJL8cOXnzx/ZGFKIsF9KWu9S9ikOzTmcZmp63u8IGdG+d3fKhEz0yosGKLJtHo1YHtOByhbWsjVbDAMlsfjj/twL6HsQitXxLIFk0JcfAEe0+vcJ1CPUQ+C7smZq2ImlvG/725bpshjE0q1D1gbU9Cb7tz7Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Fri, 10 Jul
 2020 03:47:43 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 03:47:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/13] net/mlx5e: CT: Save ct entries tuples in hashtables
Date:   Thu,  9 Jul 2020 20:44:21 -0700
Message-Id: <20200710034432.112602-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710034432.112602-1-saeedm@mellanox.com>
References: <20200710034432.112602-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Fri, 10 Jul 2020 03:47:41 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ceaa363-308f-4f3b-4a6f-08d824840049
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512808EBF1A0EA61A498659BE650@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1060;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Uk9VhQOpnVk/lUkqcSx7HsbZrq1qqFNcrG+FkVTjKf3ba95HWkeaGt6VUkD8gSChR1JjFtMyOt7fqEnKpNuUYqEN1F/mNYfO7bp68VhmsA3kwfxTiezhUHTuAFM9nV4F+359mkNTTgpDPOwyA0aqYSTlWpCE/Jqnc53r+fF77h4Mt5S2uEZVg1JQqUGxrpvP5TUco3w9eh8LUpCNhbbKIPMcz3//KbRVpEbQQW55Zb0pawnYhG1I2dG7EfU1wnqZlrr/PCY4XMUClf/P5ghBKihmYOHTBRPSRySjRjzi2sMBrOKXPdlcRmIIazSlSv3fn+tcHokLzm+ObhjCBQFJphlINHjkRG25wu+7VHb88VJPrtmgrkRyGLtmigWMOzy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(2906002)(107886003)(86362001)(8936002)(8676002)(6512007)(5660300002)(83380400001)(16526019)(52116002)(66946007)(54906003)(6486002)(186003)(1076003)(956004)(26005)(66556008)(6666004)(6506007)(36756003)(66476007)(478600001)(2616005)(4326008)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4jP07QUOKP8MGhQPR+csSdV1kRE8nmb1G36/Xx+W2GSC71BJbLp8XR5zP103y+lsPhx+ylwqzbeTS4iHB7YCedUHR9G0HX9xM19Z1+ZEMqng/tqPQNeql81meaeRJc8LwZ2uuIuwapojiJ38LYhvQOfxaK+UmdojXN6rcFCZt3NZOwMi2W9fxJVo0yArvm/ARaLUNa7H4MgnEtZm7yVulBItMDpT4nNVCn5i6e+b0VMwMAYOfRJC/EGV9vHM1iG7UIvq+VHVVYA33UxGBDvLYuvIuMO7zmElbgy5nziVLMCY5+8JadfKmllLK1zAvgkzWbS/uJ0X+LUChot1TXIn48P8cOpy3wzgvdA5UX484mjW4pXqfk2p/8OcFyTfRkuN3zOokwnatVbBE7FQjo2mOmChHACYF8TYXw74jF2p2EhSj4bPjjeb3NZmjSXMpNiICCca1TW9wy0yi1/dRrVaceZN/aicYkiA3ItTCtwVd2c=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ceaa363-308f-4f3b-4a6f-08d824840049
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 03:47:43.6838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtqSurEMOvfLP586Mi5ZLnT4gap++FetLhOdIUKfrsKwOOk50hwzgagKfNwqxt2d4J2bCSNzHQPSdIz7nfhgJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Save original tuple and natted tuple in two new hashtables.

This is a pre-step for restoring ct state after hw miss by performing a
5-tuple lookup on the hash tables.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 196 ++++++++++++++++++
 1 file changed, 196 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index c7107da03212..55402b1739ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -39,6 +39,8 @@ struct mlx5_tc_ct_priv {
 	struct idr fte_ids;
 	struct xarray tuple_ids;
 	struct rhashtable zone_ht;
+	struct rhashtable ct_tuples_ht;
+	struct rhashtable ct_tuples_nat_ht;
 	struct mlx5_flow_table *ct;
 	struct mlx5_flow_table *ct_nat;
 	struct mlx5_flow_table *post_ct;
@@ -82,12 +84,38 @@ struct mlx5_ct_ft {
 	struct mlx5_tc_ct_pre pre_ct_nat;
 };
 
+struct mlx5_ct_tuple {
+	u16 addr_type;
+	__be16 n_proto;
+	u8 ip_proto;
+	struct {
+		union {
+			__be32 src_v4;
+			struct in6_addr src_v6;
+		};
+		union {
+			__be32 dst_v4;
+			struct in6_addr dst_v6;
+		};
+	} ip;
+	struct {
+		__be16 src;
+		__be16 dst;
+	} port;
+
+	u16 zone;
+};
+
 struct mlx5_ct_entry {
 	u16 zone;
 	struct rhash_head node;
+	struct rhash_head tuple_node;
+	struct rhash_head tuple_nat_node;
 	struct mlx5_fc *counter;
 	unsigned long cookie;
 	unsigned long restore_cookie;
+	struct mlx5_ct_tuple tuple;
+	struct mlx5_ct_tuple tuple_nat;
 	struct mlx5_ct_zone_rule zone_rules[2];
 };
 
@@ -106,6 +134,22 @@ static const struct rhashtable_params zone_params = {
 	.automatic_shrinking = true,
 };
 
+static const struct rhashtable_params tuples_ht_params = {
+	.head_offset = offsetof(struct mlx5_ct_entry, tuple_node),
+	.key_offset = offsetof(struct mlx5_ct_entry, tuple),
+	.key_len = sizeof(((struct mlx5_ct_entry *)0)->tuple),
+	.automatic_shrinking = true,
+	.min_size = 16 * 1024,
+};
+
+static const struct rhashtable_params tuples_nat_ht_params = {
+	.head_offset = offsetof(struct mlx5_ct_entry, tuple_nat_node),
+	.key_offset = offsetof(struct mlx5_ct_entry, tuple_nat),
+	.key_len = sizeof(((struct mlx5_ct_entry *)0)->tuple_nat),
+	.automatic_shrinking = true,
+	.min_size = 16 * 1024,
+};
+
 static struct mlx5_tc_ct_priv *
 mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
 {
@@ -118,6 +162,115 @@ mlx5_tc_ct_get_ct_priv(struct mlx5e_priv *priv)
 	return uplink_priv->ct_priv;
 }
 
+static int
+mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *rule)
+{
+	struct flow_match_control control;
+	struct flow_match_basic basic;
+
+	flow_rule_match_basic(rule, &basic);
+	flow_rule_match_control(rule, &control);
+
+	tuple->n_proto = basic.key->n_proto;
+	tuple->ip_proto = basic.key->ip_proto;
+	tuple->addr_type = control.key->addr_type;
+
+	if (tuple->addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		struct flow_match_ipv4_addrs match;
+
+		flow_rule_match_ipv4_addrs(rule, &match);
+		tuple->ip.src_v4 = match.key->src;
+		tuple->ip.dst_v4 = match.key->dst;
+	} else if (tuple->addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct flow_match_ipv6_addrs match;
+
+		flow_rule_match_ipv6_addrs(rule, &match);
+		tuple->ip.src_v6 = match.key->src;
+		tuple->ip.dst_v6 = match.key->dst;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
+		struct flow_match_ports match;
+
+		flow_rule_match_ports(rule, &match);
+		switch (tuple->ip_proto) {
+		case IPPROTO_TCP:
+		case IPPROTO_UDP:
+			tuple->port.src = match.key->src;
+			tuple->port.dst = match.key->dst;
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int
+mlx5_tc_ct_rule_to_tuple_nat(struct mlx5_ct_tuple *tuple,
+			     struct flow_rule *rule)
+{
+	struct flow_action *flow_action = &rule->action;
+	struct flow_action_entry *act;
+	u32 offset, val, ip6_offset;
+	int i;
+
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id != FLOW_ACTION_MANGLE)
+			continue;
+
+		offset = act->mangle.offset;
+		val = act->mangle.val;
+		switch (act->mangle.htype) {
+		case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
+			if (offset == offsetof(struct iphdr, saddr))
+				tuple->ip.src_v4 = cpu_to_be32(val);
+			else if (offset == offsetof(struct iphdr, daddr))
+				tuple->ip.dst_v4 = cpu_to_be32(val);
+			else
+				return -EOPNOTSUPP;
+			break;
+
+		case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+			ip6_offset = (offset - offsetof(struct ipv6hdr, saddr));
+			ip6_offset /= 4;
+			if (ip6_offset < 8)
+				tuple->ip.src_v6.s6_addr32[ip6_offset] = cpu_to_be32(val);
+			else
+				return -EOPNOTSUPP;
+			break;
+
+		case FLOW_ACT_MANGLE_HDR_TYPE_TCP:
+			if (offset == offsetof(struct tcphdr, source))
+				tuple->port.src = cpu_to_be16(val);
+			else if (offset == offsetof(struct tcphdr, dest))
+				tuple->port.dst = cpu_to_be16(val);
+			else
+				return -EOPNOTSUPP;
+			break;
+
+		case FLOW_ACT_MANGLE_HDR_TYPE_UDP:
+			if (offset == offsetof(struct udphdr, source))
+				tuple->port.src = cpu_to_be16(val);
+			else if (offset == offsetof(struct udphdr, dest))
+				tuple->port.dst = cpu_to_be16(val);
+			else
+				return -EOPNOTSUPP;
+			break;
+
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
+
+	return 0;
+}
+
 static int
 mlx5_tc_ct_set_tuple_match(struct mlx5e_priv *priv, struct mlx5_flow_spec *spec,
 			   struct flow_rule *rule)
@@ -614,9 +767,33 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 		return -ENOMEM;
 
 	entry->zone = ft->zone;
+	entry->tuple.zone = ft->zone;
 	entry->cookie = flow->cookie;
 	entry->restore_cookie = meta_action->ct_metadata.cookie;
 
+	err = mlx5_tc_ct_rule_to_tuple(&entry->tuple, flow_rule);
+	if (err)
+		goto err_set;
+
+	memcpy(&entry->tuple_nat, &entry->tuple, sizeof(entry->tuple));
+	err = mlx5_tc_ct_rule_to_tuple_nat(&entry->tuple_nat, flow_rule);
+	if (err)
+		goto err_set;
+
+	err = rhashtable_insert_fast(&ct_priv->ct_tuples_ht,
+				     &entry->tuple_node,
+				     tuples_ht_params);
+	if (err)
+		goto err_tuple;
+
+	if (memcmp(&entry->tuple, &entry->tuple_nat, sizeof(entry->tuple))) {
+		err = rhashtable_insert_fast(&ct_priv->ct_tuples_nat_ht,
+					     &entry->tuple_nat_node,
+					     tuples_nat_ht_params);
+		if (err)
+			goto err_tuple_nat;
+	}
+
 	err = mlx5_tc_ct_entry_add_rules(ct_priv, flow_rule, entry);
 	if (err)
 		goto err_rules;
@@ -631,6 +808,15 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 err_insert:
 	mlx5_tc_ct_entry_del_rules(ct_priv, entry);
 err_rules:
+	rhashtable_remove_fast(&ct_priv->ct_tuples_nat_ht,
+			       &entry->tuple_nat_node, tuples_nat_ht_params);
+err_tuple_nat:
+	if (entry->tuple_node.next)
+		rhashtable_remove_fast(&ct_priv->ct_tuples_ht,
+				       &entry->tuple_node,
+				       tuples_ht_params);
+err_tuple:
+err_set:
 	kfree(entry);
 	netdev_warn(ct_priv->netdev,
 		    "Failed to offload ct entry, err: %d\n", err);
@@ -650,6 +836,12 @@ mlx5_tc_ct_block_flow_offload_del(struct mlx5_ct_ft *ft,
 		return -ENOENT;
 
 	mlx5_tc_ct_entry_del_rules(ft->ct_priv, entry);
+	if (entry->tuple_node.next)
+		rhashtable_remove_fast(&ft->ct_priv->ct_tuples_nat_ht,
+				       &entry->tuple_nat_node,
+				       tuples_nat_ht_params);
+	rhashtable_remove_fast(&ft->ct_priv->ct_tuples_ht, &entry->tuple_node,
+			       tuples_ht_params);
 	WARN_ON(rhashtable_remove_fast(&ft->ct_entries_ht,
 				       &entry->node,
 				       cts_ht_params));
@@ -1563,6 +1755,8 @@ mlx5_tc_ct_init(struct mlx5_rep_uplink_priv *uplink_priv)
 	xa_init_flags(&ct_priv->tuple_ids, XA_FLAGS_ALLOC1);
 	mutex_init(&ct_priv->control_lock);
 	rhashtable_init(&ct_priv->zone_ht, &zone_params);
+	rhashtable_init(&ct_priv->ct_tuples_ht, &tuples_ht_params);
+	rhashtable_init(&ct_priv->ct_tuples_nat_ht, &tuples_nat_ht_params);
 
 	/* Done, set ct_priv to know it initializted */
 	uplink_priv->ct_priv = ct_priv;
@@ -1593,6 +1787,8 @@ mlx5_tc_ct_clean(struct mlx5_rep_uplink_priv *uplink_priv)
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct_nat);
 	mlx5_esw_chains_destroy_global_table(ct_priv->esw, ct_priv->ct);
 
+	rhashtable_destroy(&ct_priv->ct_tuples_ht);
+	rhashtable_destroy(&ct_priv->ct_tuples_nat_ht);
 	rhashtable_destroy(&ct_priv->zone_ht);
 	mutex_destroy(&ct_priv->control_lock);
 	xa_destroy(&ct_priv->tuple_ids);
-- 
2.26.2

