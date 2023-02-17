Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C9969A474
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjBQDlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:41:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBQDk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:40:58 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644335A391;
        Thu, 16 Feb 2023 19:40:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYOIuBJK1ClpgZjt5RfIG0FVSgyLg6RFzDhHzHMPlwZdSq+oO4tNpXeL2gaf8TGSwjQ7NsukQbg9Q3nOTze7tjBdHdmSSzWL5gg9DXEB3Y4Hgv3cyg94FKoxNJM77YCED1O1ue5Py7OfsBiqhwtHW9vVopo4TgNP/asq1AbQmNJzHUQXdVWZF+LPexnn8nR9EnP6cpT94MlOLFn3XCRQu62e1+0yBkI/zwk9x5yPgFK2YqZ4uYBg/dLG9vFCULZPQbaPZalS3EcY9z4DlpeOPyg/0MqWKTNX3UyoQPjDD9LUUfOCquD0AukrcfnhtzZl681OlscnlnmGpdnxOnfQVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHdutjr3Ry7qO4Ua4HQOdXZW4TTDPZlm+PQ81DQP29U=;
 b=gvklkYkCe/PwZqiJJ2HO+uq486rY2EBoCmfW1bfAb6o7eQUmmTgap0mJ5cYC/eSypW0IEYHlg1WIpOEmoi3EITQ3fp+7vqk4fj4KagpkBf54YBDK1mdb/G/HH4eBMdhfvnnoJ7MeVLG+f24ls80jM1BhM6JXAX2tAnSQ145WXBrssEusKbJCdpAsq9caSU7MY5j89VJZLrEFEL2U1uxMSKl2768qE657heu357aK9UpOd8mojJ46lik12q2SFzrgpUJ60G9ak9Z5Q9xD5B/+V40sbygZAjWB3OWP9gQ6DNpRu0nbKkVQx5zQ46OGmkA57OCZELBN4ORYR9VlG+Hmeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHdutjr3Ry7qO4Ua4HQOdXZW4TTDPZlm+PQ81DQP29U=;
 b=bnkngb1dSVW67vzcp2HPu5shYWcdDkD+Evgf+OcxjaKXAjZJPzzdcOXEJKkgi5z8Y88LsCN6vhhQgWxHXiBdKyWOD4j1kVmoJ0lUY2woU19Sc/fNRIRYxGqYt0q1bET7byVqpPgIOQxIlklpnpQfEbDrt6lIGmHvxXSS35JknYHiUsxHFDMD/nVCvtt8vcC8rIvIrlm8PAvxlJGQbeK+ZdPMLE1dwFuLckWgkwDPd/BELaPHJJ3NbccFhOk6thKfyOTkVOwdzT4C0R4gVaJC2h2QPG1CbWGLEmGXWo34EwKP+GuxPrizK6ZmgoKZXpajKJzbHQEhrmbtVhAViAoUbA==
Received: from BN9PR03CA0897.namprd03.prod.outlook.com (2603:10b6:408:13c::32)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.21; Fri, 17 Feb 2023 03:40:17 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::80) by BN9PR03CA0897.outlook.office365.com
 (2603:10b6:408:13c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 03:40:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Fri, 17 Feb 2023 03:40:17 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:40:04 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:40:00 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v3 5/5] net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
Date:   Fri, 17 Feb 2023 05:39:25 +0200
Message-ID: <20230217033925.160195-6-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217033925.160195-1-gavinl@nvidia.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5eb4af-372c-4f6b-8d85-08db1098b00d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EzYGJ+2mhDFTkj5xGJetraKOAN68Vxfs/fgowPDMXJ6v9PfYIdsCeQTNQo0isyrt1fxuxd1UrGS6vR069gJXN7q5oA4jjBKYh4U9PEPVs7NaFIHP3nCBlg8otmN++4ARq0N/ORRLVe3POhp6IofIHAYUzXAdZ/JQjfiE2F3XprSc1mCPyGFPztCU8FZNjijIcR92S02Gs3bJXUaKWVMLMLVMlss/GBXnLEZJ83hziMzQHcgf8iBD4QivgIHWpXe4J9Fqr+yH4DDuc+lGEkZhsQFIVYthpO6Osfdlz+3MtBCCwhcsKzJrCPkCmP6pA070XEq/vlXed7SjMpRx9SFfUjy94PTQcUUuNGgGzYHQIpG9PG15+fvcoaR8D8VMSmMrgtdGwNrAolZJFcewdmDmGjIOifxn+DDLRO+b1N3U5jGXdk66qnIDHtYlOKNL/4Ul0aV76P/hCoYb3zuytQaeh1PZhd6zWgD03gjCo1Gnwx41OebJg9Eofo+jCPuhce9S9O985+k2QolZg1vyfao0R7w5lcigBZJflolc7HmtBiXLMXYWcOxCwKDEt5wqf6SlenXbuNEgb5raeTcAs9QOZCUHlzgHqbMKHylLsd2/dhyow90vbOnha1cTCwtjUsM4UNQG3bA1rhCkD2Tft9yiZwLMAFUMR2Niascod5scNPuJy1d+iG4e/0xyksl7k0BPUZVSFaH/HWs06CKmX7RtCQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(396003)(376002)(451199018)(40470700004)(46966006)(36840700001)(107886003)(1076003)(8936002)(16526019)(186003)(6286002)(41300700001)(6666004)(5660300002)(26005)(8676002)(2906002)(4326008)(70206006)(2616005)(70586007)(83380400001)(47076005)(426003)(7636003)(336012)(40460700003)(478600001)(82740400003)(36756003)(54906003)(82310400005)(55016003)(316002)(86362001)(40480700001)(36860700001)(356005)(7696005)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 03:40:17.5777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5eb4af-372c-4f6b-8d85-08db1098b00d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add HW offloading support for TC flows with VxLAN GBP encap/decap.

Example of encap rule:
tc filter add dev eth0 protocol ip ingress flower \
    action tunnel_key set id 42 vxlan_opts 512 \
    action mirred egress redirect dev vxlan1

Example of decap rule:
tc filter add dev vxlan1 protocol ip ingress flower \
    enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
    action tunnel_key unset action mirred egress redirect dev eth0

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 3 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 1f62c702b625..381b6090b759 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2018 Mellanox Technologies. */
 
+#include <net/ip_tunnels.h>
 #include <net/vxlan.h>
 #include "lib/vxlan.h"
 #include "en/tc_tun.h"
@@ -86,9 +87,11 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
 	__be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
 	struct udphdr *udp = (struct udphdr *)(buf);
+	struct vxlan_metadata *md;
 	struct vxlanhdr *vxh;
 
-	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+	if ((tun_key->tun_flags & TUNNEL_VXLAN_OPT) &&
+	    e->tun_info->options_len != sizeof(*md))
 		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
@@ -96,6 +99,61 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	udp->dest = tun_key->tp_dst;
 	vxh->vx_flags = VXLAN_HF_VNI;
 	vxh->vx_vni = vxlan_vni_field(tun_id);
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
+		md = ip_tunnel_info_opts(e->tun_info);
+		vxlan_build_gbp_hdr(vxh, md);
+	}
+
+	return 0;
+}
+
+static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv *priv,
+					       struct mlx5_flow_spec *spec,
+					       struct flow_cls_offload *f)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
+	struct netlink_ext_ack *extack = f->common.extack;
+	struct flow_match_enc_opts enc_opts;
+	void *misc5_c, *misc5_v;
+	u32 *gbp, *gbp_mask;
+
+	flow_rule_match_enc_opts(rule, &enc_opts);
+
+	if (memchr_inv(&enc_opts.mask->data, 0, sizeof(enc_opts.mask->data)) &&
+	    !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, tunnel_header_0_1)) {
+		NL_SET_ERR_MSG_MOD(extack, "Matching on VxLAN GBP is not supported");
+		netdev_warn(priv->netdev, "Matching on VxLAN GBP is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
+		NL_SET_ERR_MSG_MOD(extack, "Wrong VxLAN option type: not GBP");
+		netdev_warn(priv->netdev, "Wrong VxLAN option type: not GBP\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->len != sizeof(*gbp) ||
+	    enc_opts.mask->len != sizeof(*gbp_mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN GBP option/mask len is not 32 bits");
+		netdev_warn(priv->netdev, "VxLAN GBP option/mask len is not 32 bits\n");
+		return -EINVAL;
+	}
+
+	gbp = (u32 *)&enc_opts.key->data[0];
+	gbp_mask = (u32 *)&enc_opts.mask->data[0];
+
+	if (*gbp_mask & ~VXLAN_GBP_MASK) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
+		netdev_warn(priv->netdev, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
+		return -EINVAL;
+	}
+
+	misc5_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_5);
+	misc5_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_5);
+	MLX5_SET(fte_match_set_misc5, misc5_c, tunnel_header_0, *gbp_mask);
+	MLX5_SET(fte_match_set_misc5, misc5_v, tunnel_header_0, *gbp);
+
+	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_5;
 
 	return 0;
 }
@@ -122,6 +180,14 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	if (!enc_keyid.mask->keyid)
 		return 0;
 
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_OPTS)) {
+		int err;
+
+		err = mlx5e_tc_tun_parse_vxlan_gbp_option(priv, spec, f);
+		if (err)
+			return err;
+	}
+
 	/* match on VNI is required */
 
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(priv->mdev,
@@ -143,6 +209,12 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
 	return 0;
 }
 
+static bool mlx5e_tc_tun_encap_info_equal_vxlan(struct mlx5e_encap_key *a,
+						struct mlx5e_encap_key *b)
+{
+	return mlx5e_tc_tun_encap_info_equal_options(a, b, TUNNEL_VXLAN_OPT);
+}
+
 static int mlx5e_tc_tun_get_remote_ifindex(struct net_device *mirred_dev)
 {
 	const struct vxlan_dev *vxlan = netdev_priv(mirred_dev);
@@ -160,6 +232,6 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
 	.generate_ip_tun_hdr  = mlx5e_gen_ip_tunnel_header_vxlan,
 	.parse_udp_ports      = mlx5e_tc_tun_parse_udp_ports_vxlan,
 	.parse_tunnel         = mlx5e_tc_tun_parse_vxlan,
-	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_generic,
+	.encap_info_equal     = mlx5e_tc_tun_encap_info_equal_vxlan,
 	.get_remote_ifindex   = mlx5e_tc_tun_get_remote_ifindex,
 };
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 71b06ebad402..af4dd536a52c 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1357,6 +1357,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_ESW_INGRESS_ACL_MAX(mdev, cap) \
 	MLX5_CAP_ESW_FLOWTABLE_MAX(mdev, flow_table_properties_esw_acl_ingress.cap)
 
+#define MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(mdev, cap) \
+	MLX5_CAP_ESW_FLOWTABLE(mdev, ft_field_support_2_esw_fdb.cap)
+
+#define MLX5_CAP_ESW_FT_FIELD_SUPPORT_2_MAX(mdev, cap) \
+	MLX5_CAP_ESW_FLOWTABLE_MAX(mdev, ft_field_support_2_esw_fdb.cap)
+
 #define MLX5_CAP_ESW(mdev, cap) \
 	MLX5_GET(e_switch_cap, \
 		 mdev->caps.hca[MLX5_CAP_ESWITCH]->cur, cap)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1e530a8a2cf5..caef6aa20454 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -399,10 +399,13 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
 	u8         metadata_reg_c_0[0x1];
 };
 
+/* Table 2170 - Flow Table Fields Supported 2 Format */
 struct mlx5_ifc_flow_table_fields_supported_2_bits {
 	u8         reserved_at_0[0xe];
 	u8         bth_opcode[0x1];
-	u8         reserved_at_f[0x11];
+	u8         reserved_at_f[0x1];
+	u8         tunnel_header_0_1[0x1];
+	u8         reserved_at_11[0xf];
 
 	u8         reserved_at_20[0x60];
 };
@@ -890,7 +893,13 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
 
 	struct mlx5_ifc_flow_table_prop_layout_bits flow_table_properties_esw_acl_egress;
 
-	u8      reserved_at_800[0x1000];
+	u8      reserved_at_800[0xC00];
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_support_2_esw_fdb;
+
+	struct mlx5_ifc_flow_table_fields_supported_2_bits ft_field_bitmask_support_2_esw_fdb;
+
+	u8      reserved_at_1500[0x300];
 
 	u8      sw_steering_fdb_action_drop_icm_address_rx[0x40];
 
-- 
2.31.1

