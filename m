Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29626BC68B
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 08:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCPHJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 03:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCPHJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 03:09:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD7FACB83;
        Thu, 16 Mar 2023 00:08:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y3AXoHv8dyMquITZePnPGVTa3AjvcQl+pLJkEcC1gz/eqEotoScr2sjuw7fG7BLVctSTkC3+6smGNv17e9MLPAzoTYt9Omkp1UimYRLfUDaM81k7dfgWbrPeNcE4TDmFXG9sjNtezERJMLq5Jt6Hd2ATJ/3+qqCw9lulSlMG5x4LlnR7M6SGvnpl039aZQxJW+XNaHcRBPcvISorxGSpWXIJQOsfhjo5jM2KdS2uAGJsqWE37H4SS7tT4vBksoyeC+T4MZDkM+JQ6kqmz7BQTi+tumerZxP2zDxPYrTZH17M6RaDaDFqTGmOv/5BqshXJ5P2FgDjE6mnqAxmlSzaQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBx1jffNJYqWhyu2H2S/5sCPUkK2MrZICz6Oy5M/cY0=;
 b=MVVYNMFFEBm2OQPQwwONfa93z4ysHzVl5HyJW76GkarzGcvhoEnkVhLsSB+WOgWO5ytz5PnHyUj6PEiYbjvrkZeM3hiYNjItTlPnBVLGk9HvnS0reEMXAtZdE6Oigk3819ATnSBTxa5v35Ohvflbovt5zeDicTHCJBtfJ2PlUEd2MPdohbhMDQn1ii9YuZaKFTXGMV/C68Xfwo37ANzVkGnKPRmh85r0e+A0Ze+KwEyAEVh0iF+zpJyI+6MXnW+rVcpVNUqaDv323eVWL3w+GYWoBGkYv8FICIQjAqcEPNGtKTR/0tcTbrSsF86fsJha6k8lCSV6MfblNlPoxgKoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBx1jffNJYqWhyu2H2S/5sCPUkK2MrZICz6Oy5M/cY0=;
 b=e5y7tL5yQ8XBubjxh6soEar4phtigWVy1G2+jdt0gwtCRWOBPnjRghSeu6F2scM7aFQ5/BhvjkbsUxdlcpWegpKRaNBeUvivtH5TgGXo33t4u1JlFd2Yd7oLKZo8mX1K2wkmKd432BHmENDWmtWLPKbTsBjWUvqfnMSQ8D4TVGXHYam/K/rdeFZA7IuWVKNpzPKv4oR1Q6zTUMDFIvwG9DmfdMvbnCtSYGZvWXsRBG5lSglw0zVnHhJ+T8zXHAibHTYmsM+eIXRVSmtc2b9Is7ebn1Yn8v3KIcszTW8kB+0BogiN5DZAkSLC7/M5z+J9+KgQ8SASSCtNtjVj2AJASQ==
Received: from CY8PR10CA0044.namprd10.prod.outlook.com (2603:10b6:930:4b::7)
 by MN0PR12MB6293.namprd12.prod.outlook.com (2603:10b6:208:3c2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 07:08:54 +0000
Received: from CY4PEPF0000B8E9.namprd05.prod.outlook.com
 (2603:10b6:930:4b:cafe::c1) by CY8PR10CA0044.outlook.office365.com
 (2603:10b6:930:4b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33 via Frontend
 Transport; Thu, 16 Mar 2023 07:08:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8E9.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.7 via Frontend Transport; Thu, 16 Mar 2023 07:08:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 00:08:38 -0700
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 00:08:34 -0700
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v8 5/5] net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
Date:   Thu, 16 Mar 2023 09:07:58 +0200
Message-ID: <20230316070758.83512-6-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316070758.83512-1-gavinl@nvidia.com>
References: <20230316070758.83512-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E9:EE_|MN0PR12MB6293:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8c2340-9184-47e9-44d9-08db25ed4d89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxBv6Qq3tkJb2lZOdV6g2oRlBgP+Lgd6W3qwXplQMQ4ElCSHf1X+b9w9UxaaSj4C5F+jBTwsVJB8ETANP3CTvVW6OY/RQgpKG5oQ5uD0lG8thatbfJWh7zGjUfR7bB017q59cqyZR2tZKun+t4RchccLa8mWc4pIUeg9EgFocc17+WqSZNBof6PRWkqjWXEof2JVbji60Hw3OcqZRif+vZh1d6yktZ4ssKX4xPC1Ix9Lzsc8/ZdZI2wZjcPx7yi8ZO4U6ZYMyVC3ot9zKwi97ydqu2XWs6/ye6KnbjILldbp8yb84uTAVk5qmYTP+RZ+JOLaeDpCZJwgii0FmyyTy8di67YrJrDTTKLeFcn235NuCTch8gqrxZw1Lge0HBfoNL2b0RZnM4xke8Y+X2WZKLiUf7r8jkkvk6Gc/4KV8uBiCgKGxwqjHNUP1vEBP3iYJucKeRAHGt64S2iHau2uyBH6bmLMVyccC0TIP5RXW3zzXRWCuVnkCVoy0QeRlMIlMNC6FFbzuxJcIR6F6fAbQVgAW6GkLG0Zjps2VwrPX0QMMCS/VIXc+Eb4OVJ+HqodzfLtEWvIE15cVSwgN/C+gZvtUXBiLgFtTbgJHTZLK5KD4pTSmzn9eGzL2QjFb9r/8UhXZJ0dWpqkwo+iZx1EqVehJdIE/LfRN2kUinXd+LvpUPjAIZ8JpqBLi4K3FG+Hia0tT4a1qOG2OPDKfND5SylY0/rRT8Qex8BnCFYDkGT3e0VA9/f87IQy8tgrGQOZ
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(36756003)(7696005)(316002)(4326008)(107886003)(6666004)(478600001)(54906003)(41300700001)(2906002)(8936002)(5660300002)(8676002)(70586007)(110136005)(70206006)(82310400005)(7636003)(82740400003)(36860700001)(55016003)(40480700001)(86362001)(356005)(2616005)(336012)(26005)(16526019)(47076005)(6286002)(1076003)(426003)(186003)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 07:08:53.9813
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8c2340-9184-47e9-44d9-08db25ed4d89
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6293
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 72 ++++++++++++++++++-
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 3 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 1f62c702b625..a184d739d5f8 100644
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
+	const struct vxlan_metadata *md;
 	struct vxlanhdr *vxh;
 
-	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
+	if ((tun_key->tun_flags & TUNNEL_VXLAN_OPT) &&
+	    e->tun_info->options_len != sizeof(*md))
 		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
@@ -96,6 +99,57 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
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
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
+		NL_SET_ERR_MSG_MOD(extack, "Wrong VxLAN option type: not GBP");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->len != sizeof(*gbp) ||
+	    enc_opts.mask->len != sizeof(*gbp_mask)) {
+		NL_SET_ERR_MSG_MOD(extack, "VxLAN GBP option/mask len is not 32 bits");
+		return -EINVAL;
+	}
+
+	gbp = (u32 *)&enc_opts.key->data[0];
+	gbp_mask = (u32 *)&enc_opts.mask->data[0];
+
+	if (*gbp_mask & ~VXLAN_GBP_MASK) {
+		NL_SET_ERR_MSG_FMT_MOD(extack, "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
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
@@ -122,6 +176,14 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
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
@@ -143,6 +205,12 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
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
@@ -160,6 +228,6 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
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
index 66d76e97a087..70f1788b560d 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -404,10 +404,13 @@ struct mlx5_ifc_flow_table_fields_supported_bits {
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
@@ -895,7 +898,13 @@ struct mlx5_ifc_flow_table_eswitch_cap_bits {
 
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

