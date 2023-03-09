Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0666B25D7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 14:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjCINtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 08:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjCINsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 08:48:39 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2064.outbound.protection.outlook.com [40.107.96.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2003C785;
        Thu,  9 Mar 2023 05:48:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1Ycb33ubHEsTbZYp88wd5mqjZRnVIRijeqCS7Xa9RD4h6SQ5znsPO2xE+x9kTVlPWsdYbl6MCVPifHP7K1ifHctjz6yDzPywQF6oyFrxU35zwg8U5HkqKU07cWKqQ2/XRPWNtWdNTGc+KgsxdzFCFJ6ECOnBlptcYgsS4HuK9ndEc3ls9egmLqk1OaCCXsBbyWFacJ0fL8+5BrojBK9C7i7LKhBuz/j9sLfnVp97FKmHGIAbntr4VNhFcJmTXYOqXcj4j5pbOVXiVqGIwCtYhJhLo0RGFX099jTxKYhySZAiPl3qPgT5LXAr9fbeBEgYKKKWe7TpkQpInpQZ4J4wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECDUJuNnJm8LlrEOk8STOlmoSzFscNLVzXsnQEIa7BM=;
 b=HTHwGzyE4r5Kf/XZjTbVQzHtdRQD06E1KvdnBHObO2NztIrnbpjagcaILwhvggeAzIP2t9j6GHa78hMlcZ4qdDTb5isp22d9R6z4mtJ8ny6V+Z9qH6IzPurdSJ8MnlnzQl68cVwtCBpUo4Sd3PfN/j7kLrcys8bEUyDrnQrOBGxtR43t85Yb3Lp0eVz2UO68TIQ19rrPepNH8ERFRjxdgLv0ljr6Rp7LcNBKh1+WbYRZ4cuK89Tm1YqhHfnLyRE4VMsQSIXaqHvZbZ6itftUYJqbdMRVygSBSbCfCEAUhP5mb9D8lhaXWjaS2etoKURFFc54ryQ7sKH4ACiKQejVLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECDUJuNnJm8LlrEOk8STOlmoSzFscNLVzXsnQEIa7BM=;
 b=XUO30lxJprdrFrXaSfZ4h7k6ZWw8a888Zn8df9M6QbdOrgBFUAqtyhiPCC/zSmVwGEcvtCmf2g3HJnzvtCU9d2w34SOsvduq89ZQUcSUADac4KfLSjRA+wzvP2yCF4ZRjdNyfUKjkD20baPvyECYPIIHnjBKKG2JxnMr+pEw4ZFzl4c7kHXaLgPs3gIT79FVxbMHhcMzwtIga4Vhx56NwtwHeu84fsvb9yhxxl8zqW0eqv7GkQFAH4U+w97Sp+Xa9JxZ6QEd6lCFEIFraYit+cJ2S9R0W0y6agTTw2j3ukl0vfN0brjDJnK75aOz9cgsRhIT03ucFvDLu5ul5hJKTg==
Received: from BN0PR04CA0068.namprd04.prod.outlook.com (2603:10b6:408:ea::13)
 by BL0PR12MB4962.namprd12.prod.outlook.com (2603:10b6:208:17e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Thu, 9 Mar
 2023 13:48:32 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::1a) by BN0PR04CA0068.outlook.office365.com
 (2603:10b6:408:ea::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 13:48:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.19 via Frontend Transport; Thu, 9 Mar 2023 13:48:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 9 Mar 2023
 05:48:18 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 9 Mar 2023
 05:48:14 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v6 5/5] net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
Date:   Thu, 9 Mar 2023 15:47:18 +0200
Message-ID: <20230309134718.306570-6-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230309134718.306570-1-gavinl@nvidia.com>
References: <20230309134718.306570-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT041:EE_|BL0PR12MB4962:EE_
X-MS-Office365-Filtering-Correlation-Id: b44f49b0-d19e-496f-ced8-08db20a4f873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQpcJzjK70oxyDu6q/GknMQkm9dZmi/rQZ4R5P7N3v55MAoZfT1GYQY0oPvdTZ58lI2VPZPi4mZiBRRggYcoSuyssEEdNRHQ8AM73U0ewoZACp7txCN39IaNFmNMnqh1LL1sjrjNlBgUM/8yPkEUH3uznCT3tmQzmGcoA9SN20sf0ihLtQ1sTFA/4/pr6jTVlkNahqLF2TyU01iSChHHgrBiZZd9kRdI4bIoD4fTJtC5K1cpSthStUsLHj2OuQNJai4LAWXS3QZoLw0D6whDB3GjHuCSYp5rAnjNWbKaOBZAlCRGO/8xxMrYJfVBn6XIwhup9Xw8ntANZgL+8P8/Z4gF/OGKEGKiB2NpDiIQVCWhgeRe4aols0JVP2rPwdbDHaEvS1T7G6IFqUWDI8XEAoQxcx3NseZ4FufUWlaEjKABkiWTmD4hJjqqa/S7e6WsbCxnXNlWFXk8aIvt3kM4neK1bJAwVrDjDNdou0kXXcUOhq/p+cop85WcAlpvmJNDoXy8RRnT7WaQbz0cMbtU1nLoYdmpW2ALwupeb2AyTg73cs1Hyjd4RpiXRHHRLWsn+YCY9WUJOFaOG6vk+xSJ5O6VcZiYanQzliNVBF+dPzyPdAeBA7qdioHeyd/3IDj6EKqhLV3kNHBPGZnMEVV/6xWzRyT0AVCZaxtClupatOLyhTnBmJJcgfaK9YExe2wPxp5/x+VQwAxEiwXW3pphkZ0czqIERjlrEp9oBzknSnk=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(136003)(346002)(451199018)(36840700001)(46966006)(356005)(426003)(8936002)(6286002)(7696005)(16526019)(83380400001)(186003)(5660300002)(478600001)(26005)(1076003)(36756003)(107886003)(7636003)(36860700001)(336012)(82740400003)(316002)(2616005)(54906003)(110136005)(55016003)(41300700001)(86362001)(82310400005)(47076005)(70586007)(8676002)(70206006)(2906002)(40480700001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 13:48:31.6090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b44f49b0-d19e-496f-ced8-08db20a4f873
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4962
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
 .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
 include/linux/mlx5/device.h                   |  6 ++
 include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
 3 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
index 1f62c702b625..570561f6a1b7 100644
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
index 5ad5126615a1..163cc0638c37 100644
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

