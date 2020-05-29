Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5F61E8824
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgE2Tr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:29 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgE2Tr2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKWtb/1Nm75yjJeIznLedIzOrMeX1xYQef9LFFtSazqiJHdWp+6O/eoCF4MN9ZLpK9PuOLOb1cigtItaCjC5nH4T7gy8kpNzWqJSPO6CzvUeloD8xAPyrK+1RHlRgiLRvX3XUld9dZnorePucVa32MW0dDjC75zVfEZiFe3mAL0PFod3k1ln3YihgkZkrMi52qnk94JXxMlcnns1iFaPbeq1jjZY2ea5kNip2i/Lusn3G2Sa6eql/dYd9SlViOy3WNEJtftdgO1o2955l2mwJ8JC52defDY5uA2aQ2EMjQz2RN9xJSdENAEDsO9pM4bw8fxS4GCEhvczfNuQVPg0Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0xyFn8iEi4P8HnzRtciOJKCgGX9PMvaOm7UkX/8AM0=;
 b=oVvszt4jdjjTGZC6NyhfilVx7OrXIlIby+5PZTye/kl9sJB5KqcwlVkfx9XHCxyU+kd3kxm8p9+b97blEYawH6yvhEgv2lJ1sa4FXqSdDSPR4oihVZU/UOg6dAuoH+9YfvBazdAYA67FzoxheDdaAtnCp3JlZcMWKN+VBm8DmfOnVa41EpYxLRNWhShICdxFh6ZZtkA+NOzg9HzevcmlAy0v/OCcAHELObyo3ZH4hteFDxzVVf8eF5EQBAmucMcgaLXyCuYM5y8BHn+VbniS+frYtWAzwK2O5fBeE13zgOc8yKUjqjiphfWl6ZZ7m3g2ribHt4l1ewyxxX2v/xzM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0xyFn8iEi4P8HnzRtciOJKCgGX9PMvaOm7UkX/8AM0=;
 b=Ml3zAl9MWAbIjb1PjPT843EnqPOhQP6K+uO6OAumTh6iIoTnofH9t67wvjw2cVUbOwNlCfFgbXMQGDt2XivQ2TedK9oscAf8CNSSiuX3BAxsnslMIiWbPTZ7xFk3YJYnAEkddZOZ3pzdWfkmZq41bGhrBxOZKCMzKoRa5o8dYeo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:13 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:13 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/11] net/mlx5e: Accel, Expose flow steering API for rules add/del
Date:   Fri, 29 May 2020 12:46:35 -0700
Message-Id: <20200529194641.243989-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:11 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0fc42a75-f59e-4f9c-d95f-08d804091568
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB65893E9A1F351E5942E49BFFBE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LW8q2wccOUc9CdNe1C2BooqdJ4gWilY/dKpy8C4fTzF+CFjsrHBCAjbqSl2o0qWUMHmcslzX8JwUaeQNd1OMV71IRBjIsnJxFj0atx9vTTvtxoKeemshgBbvfxZDXiQ5xz7dDararsy5KykY58YlxR2lbhrOiza5qY8ghO17hG+2FWcP+t4FvZ/uUarCeJqiWhUY4kMDXE388pX52BpcUHhOy/xjZdbq0I5r4sRmXJb5EVw+uETQYJvy5VJoBijz0O/JacrwYHT7OYka6HJbQBN+Sx/pK3K2/GVeWZewEckx7THcTRUzmETXUPqKV4Y9OhiKfBKDEUldRz5lZypps7uYxKXlA6OW9boJg43gqllo/SroL0gPEAmcrNQm+RU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ps1ngM88TY71MORc4eJmFwgTm5lyFIyTxKbWYjEt5GEQQlnOPKhmZmjhRQeItOnJD4bHWGldWyKxACggvwJVFQVqYHVBksBFVWo97IEUGp2rlAOVUDN98GMj2cBLIvaGYXHdqteq0hhH9DZfuIqoEW9B2DfiT66Cps1yiSKIuchU7KX3C1Y0r2D6yLY/9Mp+CR3Zhga3Y/r972CkA4irbWbJA9OQdEWChzc8N7L+IIxd5/nDaWEFTS4B6Cn1S2Zrm1sOZU/PhPdb+gbx8Kll7yG+oKVJao+dpZ2w6qi5/INhd2AjFUgAOSHRX1bJOdX3MtZD0Tmdq8Ltkghwll5/FdsMjbXo3m9OO0y+OfNWyPoNXFThF1ToPWDSo6p95K9EHUBHS3iurHZAGQBVUkK+szR8nhIsqvs40Nw8p1Dw6SpJaStfVIPOFHfwREfUuTfhmrhPzSajtH6tfsl3ezpZIv27OAvC8bFiMcz7OSmbjk8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc42a75-f59e-4f9c-d95f-08d804091568
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:13.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWpXaN2edtSPpHQlEifEhLgamEaOc4Iurf9x0o41tWCwbYvDWorMzEkVPoqCES2QS4pN5iFnL0q1P2kWDODtRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Given a socket, the function extracts the TCP/IP{4,6} ntuple
and adds rule to steering.
Another function gets the rule and deletes it.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 114 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |   9 ++
 2 files changed, 123 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index 882ea296e7eec..c5cd96ef8a7e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -26,6 +26,120 @@ static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
 	}
 }
 
+static void accel_fs_tcp_set_ipv4_flow(struct mlx5_flow_spec *spec, struct sock *sk)
+{
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ethertype);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ethertype, ETH_P_IP);
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4),
+	       &inet_sk(sk)->inet_daddr, 4);
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
+	       &inet_sk(sk)->inet_rcv_saddr, 4);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.src_ipv4_src_ipv6.ipv4_layout.ipv4);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.dst_ipv4_dst_ipv6.ipv4_layout.ipv4);
+}
+
+static void accel_fs_tcp_set_ipv6_flow(struct mlx5_flow_spec *spec, struct sock *sk)
+{
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ethertype);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ethertype, ETH_P_IPV6);
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6),
+	       &sk->sk_v6_daddr, 16);
+	memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
+			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+	       &inet6_sk(sk)->saddr, 16);
+	memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    outer_headers.src_ipv4_src_ipv6.ipv6_layout.ipv6),
+	       0xff, 16);
+	memset(MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
+			    outer_headers.dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+	       0xff, 16);
+}
+
+void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule)
+{
+	mlx5_del_flow_rules(rule);
+}
+
+struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
+					       struct sock *sk, u32 tirn,
+					       uint32_t flow_tag)
+{
+	struct mlx5_flow_destination dest = {};
+	struct mlx5e_flow_table *ft = NULL;
+	struct mlx5e_accel_fs_tcp *fs_tcp;
+	MLX5_DECLARE_FLOW_ACT(flow_act);
+	struct mlx5_flow_handle *flow;
+	struct mlx5_flow_spec *spec;
+
+	spec = kvzalloc(sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return ERR_PTR(-ENOMEM);
+
+	fs_tcp = priv->fs.accel_tcp;
+
+	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+	switch (sk->sk_family) {
+	case AF_INET:
+		accel_fs_tcp_set_ipv4_flow(spec, sk);
+		ft = &fs_tcp->tables[ACCEL_FS_IPV4_TCP];
+		mlx5e_dbg(HW, priv, "%s flow is %pI4:%d -> %pI4:%d\n", __func__,
+			  &inet_sk(sk)->inet_rcv_saddr,
+			  inet_sk(sk)->inet_sport,
+			  &inet_sk(sk)->inet_daddr,
+			  inet_sk(sk)->inet_dport);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case AF_INET6:
+		if (!sk->sk_ipv6only &&
+		    ipv6_addr_type(&sk->sk_v6_daddr) == IPV6_ADDR_MAPPED) {
+			accel_fs_tcp_set_ipv4_flow(spec, sk);
+			ft = &fs_tcp->tables[ACCEL_FS_IPV4_TCP];
+		} else {
+			accel_fs_tcp_set_ipv6_flow(spec, sk);
+			ft = &fs_tcp->tables[ACCEL_FS_IPV6_TCP];
+		}
+		break;
+#endif
+	default:
+		break;
+	}
+
+	if (!ft) {
+		flow = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.tcp_dport);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.tcp_sport);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.tcp_dport,
+		 ntohs(inet_sk(sk)->inet_sport));
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.tcp_sport,
+		 ntohs(inet_sk(sk)->inet_dport));
+
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_TIR;
+	dest.tir_num = tirn;
+	if (flow_tag != MLX5_FS_DEFAULT_FLOW_TAG) {
+		spec->flow_context.flow_tag = flow_tag;
+		spec->flow_context.flags = FLOW_CONTEXT_HAS_TAG;
+	}
+
+	flow = mlx5_add_flow_rules(ft->t, spec, &flow_act, &dest, 1);
+	if (IS_ERR(flow))
+		netdev_err(priv->netdev, "mlx5_add_flow_rules() failed, flow is %ld\n",
+			   PTR_ERR(flow));
+
+out:
+	kvfree(spec);
+	return flow;
+}
+
 static int accel_fs_tcp_add_default_rule(struct mlx5e_priv *priv,
 					 enum accel_fs_tcp_type type)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
index 0df53473550af..4341806a7b689 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h
@@ -9,9 +9,18 @@
 #ifdef CONFIG_MLX5_EN_TLS
 int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv);
 void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv);
+struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
+					       struct sock *sk, u32 tirn,
+					       uint32_t flow_tag);
+void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule);
 #else
 static inline int mlx5e_accel_fs_tcp_create(struct mlx5e_priv *priv) { return 0; }
 static inline void mlx5e_accel_fs_tcp_destroy(struct mlx5e_priv *priv) {}
+static inline struct mlx5_flow_handle *mlx5e_accel_fs_add_sk(struct mlx5e_priv *priv,
+							     struct sock *sk, u32 tirn,
+							     uint32_t flow_tag)
+{ return NULL; }
+static inline void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule) {}
 #endif
 
 #endif /* __MLX5E_ACCEL_FS_TCP_H__ */
-- 
2.26.2

