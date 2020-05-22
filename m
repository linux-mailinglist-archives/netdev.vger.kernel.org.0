Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B6A1DF352
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387448AbgEVXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:55 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:15428
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387425AbgEVXww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKOaxMtAlGLAjYQzpXe9ydI9SCy9KqWWtZop1l6F8UInOLq5lHxT6NuE7KkCvIMFr0wzeILyjLQaV3iegh83HwHvwSnv5WE3/B9aU5RHiQ7Ef7sIqc2THx9nzW0xvWyJPGRJScReeeYAqOJBvkWn42zKKY4JKApL9ESrL/s3Twa5qDhLFUF5XRtgwimAmIYxeVA+qRAEVfdc2Sux0icdWTF/mbkDr2y9gmgYlWfe3F1plM+2SufKLsLjkF1gm4KjJSXjCchOkmp/mAA2mXtRFsylNLMLP9T4JJSmDkgZDRMT7zYivXlV7Uxd22W5rRBdy7mvtZPD38un0rGCV5UogA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StIM4k0xjCuoJCLhPLeFwlvin4biAFLU1kSRkG+0Szc=;
 b=K3kl0pC+UANkGsyFtzHVIDCqtGJWZCOO/tqCEeojpVK6XEyrY1LtnrBjhRIwiBYmYAXBX9u5N79wPO9FtOftxHezdu1VUs79aPuo5QkuNx5LJHS2sGnqiH/yFciA7Ahp6eEwc7USbeoFwgMP9pCJnbKyTb60SLTFajY4xH90FFxYaT8nbWZWqgKbE9cm2BZpi8mYmrks3+OgWBbuYYemzgDKwx7v3GfdEqU5RHEeLHygLSpuM8pPUMCOnBFdwjQkbqiuUmJQjm/gbaet/UPR2uTmG4TMmaXCuDn+FK1NOw540y+eXTR1iTJ+ovXuYHZ39Bw96jhkMOQlhhQauKTqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StIM4k0xjCuoJCLhPLeFwlvin4biAFLU1kSRkG+0Szc=;
 b=kMoxeaJp278gFXKpkK9BdZonalzTui2tD8mzM8V5WHmnFQTpiRVxzoiBac18PbqbYZ+Znhiahu8KnQvlMFuTJL5oi1k4ziIz9iec5br6LaosI6RsPwi0h18KZrOa23BEN6+oKBHjXS6I5giGK1uwPN6NcT2O9LZNZt2vTONbDw4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:26 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/10] net/mlx5e: Add support for hw encapsulation of MPLS over UDP
Date:   Fri, 22 May 2020 16:51:45 -0700
Message-Id: <20200522235148.28987-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200522235148.28987-1-saeedm@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:23 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3e423f40-b484-47ee-7fb0-08d7feab2d6d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45446E69805029A537831DC1BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TiAyQo+IRx2XWJPO6NVPvtJCaLLfrKf0jeQcVNiOAGo7wE+1uH4FfdVuaoTdTTJU4A4Xj8V5io02dBHbFIyFWgIpGDQ2TAPo+nHHPInNuqTUjHJ93I6DR2yvp++skBxf0ciXQCuVZw49nxfx2Po66PLqQdRlgjNjL1py2MTYWT0PFPTfzLzjqimxtkOtnTGizXhbIRlgA/M5GRzB5+rsXumCb9Ff2M6wz2Ouw+mqvmSLkNIKUDRh8HnKRNPyzAcvOaZmvAaqSjhR8h0z6Pa2/FLDVzmYxSYBLCps9bqMAHX9OUlw77pISM/9wqiDx5obQcupEEsP1iNN4nCL/5n21GwMrXDxHKAydE2HJ7I6P7WPqfX7QeYxEMBvzxiNcvPj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(54906003)(36756003)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gi504zCLT0jo2ljUzuxZJiXNQA3k2vWLMj+l8ga8KyLlyym7e4S1CXVsicA++0EDDEAFYGkjEfwTj/GQDlRRT+Ywnpu/Kl1zneC3kqpObJ8Z0UU28b5mMT64p9lQ55w2GFzSTeiYw0QLdYugtGSyhTRN57OetxHscfs7JqKnM1jbK6Tz8Z29AOSg/UOWCEb9oK2/JXM1eyjxc8ug4ZD0+KTMSoX7Bgn1XWHiub54UtsPsggRpAahLb+JPqFzI3X3cZpL1ZBmJ9mBT6IdP1bOmSkJE5olSI7TpLvZax33W6QBLgC9ei5nfOQHcqqoWh1X+QRvZVYTVYJI64QHVv44P5U+mhP/Tc9EOBXYQpWeE7oDvOOya2DJXEkFk1LdKzbWACab78r2MDSIOklxA5UJsaztLRE667BY7S/TcSLAIrGiiQPjICcmK8k+oRNCPwHtBUw8udyzEf3PlI0xHusZlZNsDRdlDZ80UNnY7bObRaM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e423f40-b484-47ee-7fb0-08d7feab2d6d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:25.4796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLWvlX0ZTYZMfne8+HOGxAaONvj1Fk0Jn3pQaDIpO3SUsvToazWB0vkBPzhD+FmWyEe1Nhc+C5lPUeicJi8sCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

MPLS over UDP is supported by adding a rule on a representor net device
which does tunnel_key set, push mpls and forward to a baredup device. At
the hardware level we use a packet_reformat_context object to do the
encapsulation of the packet.

The resulting packet looks as follows (left side transmitted first):
outer L2 | outer IP | UDP | MPLS | inner L3 and data |

Example usage:
  tc filter add dev $rep0 protocol ip prio 1 root flower skip_sw  \
     action tunnel_key set src_ip 8.8.8.21 dst_ip 8.8.8.24 id 555 \
     dst_port 6635 tos 4 ttl 6 csum action mpls push protocol 0x8847 \
     label 555 tc 3 action mirred egress redirect dev bareudp0

This is how the filter is shown with tc filter show:
tc filter show dev enp59s0f0_0 ingress
filter protocol ip pref 1 flower chain 0
filter protocol ip pref 1 flower chain 0 handle 0x1
  eth_type ipv4
  skip_sw
  in_hw in_hw_count 1
        action order 1: tunnel_key  set
        src_ip 8.8.8.21
        dst_ip 8.8.8.24
        key_id 555
        dst_port 6635
        csum
        tos 0x4
        ttl 6 pipe
         index 1 ref 1 bind 1

        action order 2: mpls  push protocol mpls_uc label 555 tc 3 ttl 255 pipe
         index 1 ref 1 bind 1

        action order 3: mirred (Egress Redirect to device bareudp0) stolen
        index 1 ref 1 bind 1

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |  2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   |  3 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  2 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c   | 88 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 18 ++++
 .../mellanox/mlx5/core/lib/port_tun.c         |  4 +-
 6 files changed, 114 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 3c1f12c7175f..e5ee9103fefb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -38,7 +38,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)     += en_rep.o lib/geneve.o lib/port_tun.o lag
 mlx5_core-$(CONFIG_MLX5_CLS_ACT)     += en_tc.o en/rep/tc.o en/rep/neigh.o \
 					en/mapping.o esw/chains.o en/tc_tun.o \
 					en/tc_tun_vxlan.o en/tc_tun_gre.o en/tc_tun_geneve.o \
-					diag/en_tc_tracepoint.o
+					en/tc_tun_mplsoudp.o diag/en_tc_tracepoint.o
 mlx5_core-$(CONFIG_MLX5_TC_CT)	     += en/tc_ct.o
 
 #
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 9be1fcc269b2..e99382f58807 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -4,6 +4,7 @@
 #include <net/vxlan.h>
 #include <net/gre.h>
 #include <net/geneve.h>
+#include <net/bareudp.h>
 #include "en/tc_tun.h"
 #include "en_tc.h"
 #include "rep/tc.h"
@@ -18,6 +19,8 @@ struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev)
 	else if (netif_is_gretap(tunnel_dev) ||
 		 netif_is_ip6gretap(tunnel_dev))
 		return &gre_tunnel;
+	else if (netif_is_bareudp(tunnel_dev))
+		return &mplsoudp_tunnel;
 	else
 		return NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
index 1630f0ec3ad7..704359df6095 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h
@@ -16,6 +16,7 @@ enum {
 	MLX5E_TC_TUNNEL_TYPE_VXLAN,
 	MLX5E_TC_TUNNEL_TYPE_GENEVE,
 	MLX5E_TC_TUNNEL_TYPE_GRETAP,
+	MLX5E_TC_TUNNEL_TYPE_MPLSOUDP,
 };
 
 struct mlx5e_tc_tunnel {
@@ -46,6 +47,7 @@ struct mlx5e_tc_tunnel {
 extern struct mlx5e_tc_tunnel vxlan_tunnel;
 extern struct mlx5e_tc_tunnel geneve_tunnel;
 extern struct mlx5e_tc_tunnel gre_tunnel;
+extern struct mlx5e_tc_tunnel mplsoudp_tunnel;
 
 struct mlx5e_tc_tunnel *mlx5e_get_tc_tun(struct net_device *tunnel_dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
new file mode 100644
index 000000000000..ff296c0a32c4
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2018 Mellanox Technologies. */
+
+#include <net/bareudp.h>
+#include <net/mpls.h>
+#include "en/tc_tun.h"
+
+static bool can_offload(struct mlx5e_priv *priv)
+{
+	return MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev, reformat_l3_tunnel_to_l2);
+}
+
+static int calc_hlen(struct mlx5e_encap_entry *e)
+{
+	return sizeof(struct udphdr) + MPLS_HLEN;
+}
+
+static int init_encap_attr(struct net_device *tunnel_dev,
+			   struct mlx5e_priv *priv,
+			   struct mlx5e_encap_entry *e,
+			   struct netlink_ext_ack *extack)
+{
+	e->tunnel = &mplsoudp_tunnel;
+	e->reformat_type = MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL;
+	return 0;
+}
+
+static inline __be32 mpls_label_id_field(__be32 label, u8 tos, u8 ttl)
+{
+	u32 res;
+
+	/* mpls label is 32 bits long and construction as follows:
+	 * 20 bits label
+	 * 3 bits tos
+	 * 1 bit bottom of stack. Since we support only one label, this bit is
+	 *       always set.
+	 * 8 bits TTL
+	 */
+	res = be32_to_cpu(label) << 12 | 1 << 8 | (tos & 7) <<  9 | ttl;
+	return cpu_to_be32(res);
+}
+
+static int generate_ip_tun_hdr(char buf[],
+			       __u8 *ip_proto,
+			       struct mlx5e_encap_entry *r)
+{
+	const struct ip_tunnel_key *tun_key = &r->tun_info->key;
+	__be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
+	struct udphdr *udp = (struct udphdr *)(buf);
+	struct mpls_shim_hdr *mpls;
+
+	mpls = (struct mpls_shim_hdr *)(udp + 1);
+	*ip_proto = IPPROTO_UDP;
+
+	udp->dest = tun_key->tp_dst;
+	mpls->label_stack_entry = mpls_label_id_field(tun_id, tun_key->tos, tun_key->ttl);
+
+	return 0;
+}
+
+static int parse_udp_ports(struct mlx5e_priv *priv,
+			   struct mlx5_flow_spec *spec,
+			   struct flow_cls_offload *f,
+			   void *headers_c,
+			   void *headers_v)
+{
+	return mlx5e_tc_tun_parse_udp_ports(priv, spec, f, headers_c, headers_v);
+}
+
+static int parse_tunnel(struct mlx5e_priv *priv,
+			struct mlx5_flow_spec *spec,
+			struct flow_cls_offload *f,
+			void *headers_c,
+			void *headers_v)
+{
+	return 0;
+}
+
+struct mlx5e_tc_tunnel mplsoudp_tunnel = {
+	.tunnel_type          = MLX5E_TC_TUNNEL_TYPE_MPLSOUDP,
+	.match_level          = MLX5_MATCH_L4,
+	.can_offload          = can_offload,
+	.calc_hlen            = calc_hlen,
+	.init_encap_attr      = init_encap_attr,
+	.generate_ip_tun_hdr  = generate_ip_tun_hdr,
+	.parse_udp_ports      = parse_udp_ports,
+	.parse_tunnel         = parse_tunnel,
+};
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1614b077a477..2cebbd03bc57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -48,6 +48,7 @@
 #include <net/tc_act/tc_csum.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
+#include <net/bareudp.h>
 #include "en.h"
 #include "en_rep.h"
 #include "en/rep/tc.h"
@@ -3685,6 +3686,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	bool encap = false, decap = false;
 	u32 action = attr->action;
 	int err, i, if_count = 0;
+	bool mpls_push = false;
 
 	if (!flow_action_has_entries(flow_action))
 		return -EINVAL;
@@ -3699,6 +3701,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 			break;
+		case FLOW_ACTION_MPLS_PUSH:
+			if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
+							reformat_l2_to_l3_tunnel) ||
+			    act->mpls_push.proto != htons(ETH_P_MPLS_UC)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "mpls push is supported only for mpls_uc protocol");
+				return -EOPNOTSUPP;
+			}
+			mpls_push = true;
+			break;
 		case FLOW_ACTION_MANGLE:
 		case FLOW_ACTION_ADD:
 			err = parse_tc_pedit_action(priv, act, MLX5_FLOW_NAMESPACE_FDB,
@@ -3729,6 +3741,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				return -EINVAL;
 			}
 
+			if (mpls_push && !netif_is_bareudp(out_dev)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "mpls is supported only through a bareudp device");
+				return -EOPNOTSUPP;
+			}
+
 			if (ft_flow && out_dev == priv->netdev) {
 				/* Ignore forward to self rules generated
 				 * by adding both mlx5 devs to the flow table
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index 8809a65ecefb..e042e0924079 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -144,11 +144,11 @@ static int mlx5_set_entropy(struct mlx5_tun_entropy *tun_entropy,
 int mlx5_tun_entropy_refcount_inc(struct mlx5_tun_entropy *tun_entropy,
 				  int reformat_type)
 {
-	/* the default is error for unknown (non VXLAN/GRE tunnel types) */
 	int err = -EOPNOTSUPP;
 
 	mutex_lock(&tun_entropy->lock);
-	if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_VXLAN &&
+	if ((reformat_type == MLX5_REFORMAT_TYPE_L2_TO_VXLAN ||
+	     reformat_type == MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL) &&
 	    tun_entropy->enabled) {
 		/* in case entropy calculation is enabled for all tunneling
 		 * types, it is ok for VXLAN, so approve.
-- 
2.25.4

