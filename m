Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EE820C442
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgF0VTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:19:02 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726601AbgF0VTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:19:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gns8uOhbHmIOSD6VTOFh2NHC6e0Y1n67wgc7hT0Ru9xQnwTSzSmTkctqm6hkI3tRsNDHp6lbxqVtHF4vnnWVqxiiymoRIoDcu8yCJGSzIWxvRMzJ2ntt9qkrFfNI/KisVmzs0XhqUxg1gfPjbqjStHP/3Xal2eoD/3aP2OjuIHqwhoYg37lkF+rcgq20QHL1QHkKQOvfqCA/46KODShsMOBptFXNczzliAhN9X8liQuuNfsF/fLpgi5gTc5tnU0uLpjwcfHZFYh8ELKDyXBrinyHefaRnQ+PmttD46pZeAaF1pPszTs6yVnor/Qppq/5yl5fGGceAuU12AGwWibaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2I3NP4Pu2yhyXb6f0GEbq51qCqrBCjvucd7Xl1D55Y0=;
 b=COT1+tBF28cR8t3uKjlcllmGqs6PrDc5meTY+6s9548nOOIQIY0kQED+AMI7fUISxNuR/aobv+QmQKd4xqV8OU6+Mi5XiS7EbKdkEKzJy+sc96BGt6P7kaEIC1ycxQvg/8NjiW06es4IbTAeIYVc60MoDDHlWuu8gVLQzVXZAsX79WhDpEAzOaXCyFMH+9IS5XDKWRu03Nj3asepHP5kbRTTQVMRsORloK9MBfGY0f0+EBnSuE7K7BAx34Kk+Iv4zUbOjti/uECxEiWaB8JGYAl0ECGo8X2IV+GHtm1bdoQmk9ox69GAlgH1y8VO+VEqIZj8Cw3QKDvCYRTsNpkeGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2I3NP4Pu2yhyXb6f0GEbq51qCqrBCjvucd7Xl1D55Y0=;
 b=IXAf79SfsRtSHB2IdCyXQqy+nlrGAs3/IbQmnqpO23NTgQnpohEy8O8ZlAgbU3Xc06nhB8g0++hUDBnPr04Fzsn/0CINszz+v2WH6Svu6H84Uwo9fX1vahA/BEmluiDj6hJg0PlWoyxbkuOf7KrQ3Mvzqj009US4XIkFTtF3WSg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [net-next 05/15] net/mlx5e: Accel, Expose flow steering API for rules add/del
Date:   Sat, 27 Jun 2020 14:17:17 -0700
Message-Id: <20200627211727.259569-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 793f1d6b-0951-4ea4-a3f1-08d81adfad89
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5134B38E77584DC646027C48BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0+halTllijLdkMPU/qoztZMlOwcml4qcUMt7P72HqJ+sJqGLTy/GkBzGq6epIdmOHI2j6De1DBMsFmOuZ16diVA6oHU38OdI7n1fbXmpE/HZ6fqHDv8iNU59KPTjGHoep9XmxntfR/Gy+QLRZR4QRjzZsSC0w63uC0Op54uRIy+VW7+RVPE4B5HAaxhu0XXA3+djE44k1e8r1XJN9RAX20tKknAU/MteCbDk7H0WDzknQX4gJHBVRmAnEtvI3al/nTeN0wP51rWct0EfDA6U23UsRB6LYOcWpKfKN0ftvImtHpvPvVfFg6h4VEtVxW5OkQmwQs48Nov3p0uaaPaDl0nFLsN5FdwHJjdXJKqXYqGRtqUMIZMDShwNMjJ6qzcs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jx6DUW5a24r0CwZvf8cp9mwqW/hB4lzIna3OdGsiJygVfdaL0mhUScn0Stlat89VTyd4Dwp1pxXHjqIo8OCWv7T84lQhZ9Sb/gOVJeBOD8tkdW40YbZ8xvRzpiPqB+Pe0NRCj5LzICROyNtW5w3dJCFolV0lOtsSAlVovpz+IeyvLMljlE4zQ8u2U//txcDthGbMoNgo6Cq+48qln28aCPZ0+zp+4JECWqPZTCnplD4HKyTjG4NbYiismUaasFvrdKs7bsiSEuhXCA1IWlbqlt8MUmF/bloYfT0sUqDMVGGFyRbtpnUs3EQf5qAp5ihRJ5lV5wrxGQ9UgloL4SUecUtmTXPwZxTHggasooPo7KHcozunasxINtuM0dnEYBkNJd00jfsq5GNNpd8Zd+/0tqrjn4KGhuas7tb3a/8xlhSXJlkDfGfKHk0jWeFE3kdHUzu6BB+Jq7J9iikyMngPI8H3DdE1ECyhIj9YZfsdQnI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 793f1d6b-0951-4ea4-a3f1-08d81adfad89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:46.6621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhZ4iSwrNqMBhA5ZEwCYfl6FBNgTv8P+91qLhjdHuDz8EjVKJNwGgvba+at8hZEtTYClxrZPMf5JsScBQrSkHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
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
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/fs_tcp.c      | 120 ++++++++++++++++++
 .../mellanox/mlx5/core/en_accel/fs_tcp.h      |   9 ++
 2 files changed, 129 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index a0e9082e15b0..4cdd9eac647d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -26,6 +26,126 @@ static enum mlx5e_traffic_types fs_accel2tt(enum accel_fs_tcp_type i)
 	}
 }
 
+static void accel_fs_tcp_set_ipv4_flow(struct mlx5_flow_spec *spec, struct sock *sk)
+{
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_TCP);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 4);
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
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_protocol, IPPROTO_TCP);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version, 6);
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
+
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
+
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
index 0df53473550a..589235824543 100644
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
+{ return ERR_PTR(-EOPNOTSUPP); }
+static inline void mlx5e_accel_fs_del_sk(struct mlx5_flow_handle *rule) {}
 #endif
 
 #endif /* __MLX5E_ACCEL_FS_TCP_H__ */
-- 
2.26.2

