Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C94069651C
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbjBNNoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjBNNnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:43:19 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6EB28D23;
        Tue, 14 Feb 2023 05:42:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7/emDYTwxe4gqe3vu90GpVjnZKm26olRmG8W9AKSDf43UVXtTIgcfMFx23jehUOThG7dRNv1tz/uGV8C4/Vcxg2I87UmTy5glxZW5ffoqNohkr1MPuluYvPnpMIXHOXApPoit6vbeV3CddVXSLLaPKcO70ceSLCaB3bATRYbjfRzbqZMKddA9o9gSmYbkN9MXz/aNmJQGlpQLWydkiBSCGw3F8FkCFgs5aukSBR6oGPZ2Evbe2cWp+GQd2QGxIiFLkeDFRXfZJLg7WU3bfJ39PWAg5sOWijF77k3dh8YnVbtvHe0YDn/cWUbXs8gCLdiibtLrffunSyvVeA1ZRd6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZBh5UJ5BJF/xXDbaFbIwbi2wn5VnQVZ/ilhZu08ofc=;
 b=Ts+O4rZUNZWIctCDBf8IRfiWsyK3KRuGOfQja/mRd12pJkj4fWP7YN9MdCZue52iVCf2oKd223khNwfiZnb5jj+Pzq+XdsoTc4QNBIyawawZzMRipK6m40KoF9eI691khZMfbugeXaO4HkpyUYY2SdBMhZhKUucFmG1L5uEpnwWoXL/wX656UonsYXcR8C3tggAcydAXiVXwp5WopZQbmNzMjCQMPG2x98crm5rdIru146Er3Rp9zN5P6ygrLbEWjw1VjAAFVkJ9XkM9BZ07sPUizmllbITFzXZ1OmmJ5adVqNaCJioeIZ7sMZMZ/DGbLvYdewjzRy7uPE2tYXXKLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZBh5UJ5BJF/xXDbaFbIwbi2wn5VnQVZ/ilhZu08ofc=;
 b=uL0X4wtrLMGN088A7KinS+2IJMKM3GPtBzlCwaKg62hGtliSK2nB+wWTsgSyQLLfuDidFwfITULI5FHZ1qVewPfvQR/HG6ER7hBHTLY5+14QzzjKuk2UPz4JzDu1mHjyaT6o8022ELLq0zKFdVbHISlWx0gMHADgJ81aN6vSITl/nuS0+045Bo83zUB4TYFURSyg0ayLbarES7RysgeUe2xDyOoplUYB1tv+/sh47Snemf6R9aXYFXxghm6iugixN+VRygjl78fbZa6S0CLU5oR0yZzGM+ESg4UNbJ91Z26Y/oKN4g6jge/FhHWgl9+cm9Ozho+GTEwUgDR1eNpYrw==
Received: from DS7PR05CA0088.namprd05.prod.outlook.com (2603:10b6:8:56::14) by
 DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24; Tue, 14 Feb 2023 13:42:23 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::5d) by DS7PR05CA0088.outlook.office365.com
 (2603:10b6:8:56::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Tue, 14 Feb 2023 13:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 13:42:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:17 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:42:13 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
Date:   Tue, 14 Feb 2023 15:41:37 +0200
Message-ID: <20230214134137.225999-4-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214134137.225999-1-gavinl@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|DM4PR12MB5820:EE_
X-MS-Office365-Filtering-Correlation-Id: d74e38db-73a0-4cb7-a791-08db0e914d4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oMsg14ELCKC3D5ZJYHKA8U/vigJ9KVHywMOUDvakK46tKpQt39M1t4+IVFz8M1EXG1nikyQDP2upkjaDJKtkpS4GcJFyJapBBKubqV3NjWeHgLukBsSXTOPzP8LumYFV9Tjv1rU02rBi6cNHGywcOF8szvt9KWw+g95TByFF0BtQJ39UEUQz7EbcH5f2g/j3VWYP88BhhCJGnkI3yOpv3tIwUTT77EbPRGUpSTceKRevINa4x26HGZzhJq4KAdUwSDLaszg4zVYCl34qtKoRVjO3OtCpdkQvZ2zAA+dw1LQGbrSB98YzU0pDSou9LIshzpkRdeuUUSrSec/MYonqHauQJnLhXIHokKUhND72TDpsWRmBx5KvNu5dYCZIN9Bn5Ar0pzJxq52t62DzJiGwyL3enFoajkaMiuAZTYmecp7uzf9EmmHz2A50bVbjLzg9/yGeLZFJo93YCqymcKrWImoRVo3r6yWLBSYCAjwlBdmT9Wt7xMAe7enwQn/Vo5nbvR0THSPJ5V14lSmyiwpBvTX7adNut7yI6ET00//dzjuDJsRfv8dIh9kPgOh4rI/A9Q+nzD9L8eTHxUtm702iGwCsU0KzfBQBKbCUL4MolApVw3gdgXv4lhlvjvb9ATtqztSzqi5TYTwARJcPWvcA3acuUZYeINHH1pqD41IMWrvACHGKOOJ6uLe01A2t6z7vupySFJXW1EX3zyOb/LGLyw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(86362001)(1076003)(36756003)(8676002)(54906003)(110136005)(316002)(4326008)(70586007)(107886003)(40460700003)(2906002)(82310400005)(478600001)(2616005)(70206006)(6666004)(7696005)(41300700001)(8936002)(5660300002)(36860700001)(82740400003)(356005)(83380400001)(7636003)(55016003)(40480700001)(336012)(186003)(6286002)(26005)(16526019)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:42:23.1632
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d74e38db-73a0-4cb7-a791-08db0e914d4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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

Change-Id: I48f61d02201bf3f79dcbe5d0f022f7bb27ed630f
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 85 ++++++++++++++++++-
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 ++-
 3 files changed, 100 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 1f62c702b625..444512ca9e0d 100644
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
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT &&
+	    e->tun_info->options_len != sizeof(*md))
 		return -EOPNOTSUPP;
 	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
 	*ip_proto = IPPROTO_UDP;
@@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
 	udp->dest = tun_key->tp_dst;
 	vxh->vx_flags = VXLAN_HF_VNI;
 	vxh->vx_vni = vxlan_vni_field(tun_id);
+	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
+		md = ip_tunnel_info_opts((struct ip_tunnel_info *)e->tun_info);
+		vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
+				    (struct vxlan_metadata *)md);
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
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Matching on VxLAN GBP is not supported");
+		netdev_warn(priv->netdev,
+			    "Matching on VxLAN GBP is not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Wrong VxLAN option type: not GBP");
+		netdev_warn(priv->netdev,
+			    "Wrong VxLAN option type: not GBP\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (enc_opts.key->len != sizeof(*gbp) ||
+	    enc_opts.mask->len != sizeof(*gbp_mask)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "VxLAN GBP option/mask len is not 32 bits");
+		netdev_warn(priv->netdev,
+			    "VxLAN GBP option/mask len is not 32 bits\n");
+		return -EINVAL;
+	}
+
+	gbp = (u32 *)&enc_opts.key->data[0];
+	gbp_mask = (u32 *)&enc_opts.mask->data[0];
+
+	if (*gbp_mask & ~VXLAN_GBP_MASK) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Wrong VxLAN GBP mask");
+		netdev_warn(priv->netdev,
+			    "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
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
@@ -122,6 +189,14 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
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
@@ -143,6 +218,12 @@ static int mlx5e_tc_tun_parse_vxlan(struct mlx5e_priv *priv,
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
@@ -160,6 +241,6 @@ struct mlx5e_tc_tunnel vxlan_tunnel = {
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

