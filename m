Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4959A67FE1E
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbjA2KQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbjA2KQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:16:47 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA75C2367E
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:16:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DghLrEgyDrfF2UWRz/DCL1cLTtV3m0bt4orv6I0LtAzdqh41yNE3YXt4wRT0YZsqAu4f5IVaxyoGTI1UlkR6VeXKHI6gysHBQTaM6w5LA6rlGcqMJDYIFlOFHOPa7ntI6D1X7V+qyfKwNlGcZrL/ufyrf3zn7J3mInGfC5rXaXonDPDebH2ZP+Jp1zFjd2gzGukDyk013f4pInVticisvIpqg0cAHPTHlCVlejqSGo903jitmGuhXcMspM3HJr2wuGBR8c2cixyKPb+gjYnl5Px7rndXkl7fEod4PSUgDnlYz7aqpLtq4QRIslJGWwpzHqPRKJK7LjxsNBEVbPzBeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBujnEJI0doy+O+P/uGnS+I9OZT7urZaOeEHG4CXhJI=;
 b=O8wjxeyKOVw6e7t162v7UL4oXcvFK3HgSwe+QWRg5/eogFwp5jkjI1Pq/1aRLfEmj0sRIrtCaP8X475SZD+3ojcPfZnhr+eTC8qdA+uk+F4acWF3yi6rQe9IcofJtEjqnIoC0CbJAHlIfN4PJSmE0GIvzNtrwsHm2J0OdDY1tZJ2dQqmkBznKOOia4k9hV/iA0QAzN1XdcGoNdjyk2NBzA1WtNHyP1kdCiVrEDHUaIooFXsXNJ8CMCerybrsukmcLuvNQBMEMaCWAA0uqeqx1m8NubA7IFSo0jGq6XixSq4stEYR91BZLped9TLVYvuM3KF+s6HJOTbYZ23yXCx2EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBujnEJI0doy+O+P/uGnS+I9OZT7urZaOeEHG4CXhJI=;
 b=GzcJgulkm3i8Lv2xiYtGk/Md7YeWCkoKzWm/oFhVJ7HFwcOvoRCkEd+IJWGzm0Fh8VyTWrqATanQT/5uytsB5bwrART89iV5KMN2urCVExa6hi1grzNcVu28L1vTVfccMzuy1oAAmLg/Jl+BsnZhVy+38/IGXcCYLNPbJkkzhYi6c59Udwng4PqAmS+7DCLvLukZX0btgPi400nHMjTMqbSQy3MoUeAJMnypuCjQBNOXBB57cVqCjOW+wt5PEiVxzzadjiIbxATMTmjIYaaRAlYMAb4RsmByd/QKKZrGwp6+pdPAbCZ8Hnd8VI2Qa58r18N2nkuJYy+jHu08sNeAvw==
Received: from DM6PR07CA0120.namprd07.prod.outlook.com (2603:10b6:5:330::10)
 by DS0PR12MB8414.namprd12.prod.outlook.com (2603:10b6:8:fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.33; Sun, 29 Jan 2023 10:16:34 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::c9) by DM6PR07CA0120.outlook.office365.com
 (2603:10b6:5:330::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.31 via Frontend
 Transport; Sun, 29 Jan 2023 10:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Sun, 29 Jan 2023 10:16:34 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 29 Jan
 2023 02:16:33 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 29 Jan 2023 02:16:32 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 29 Jan 2023 02:16:29 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v6 4/6] net/mlx5: Refactor tc miss handling to a single function
Date:   Sun, 29 Jan 2023 12:16:11 +0200
Message-ID: <20230129101613.17201-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230129101613.17201-1-paulb@nvidia.com>
References: <20230129101613.17201-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT062:EE_|DS0PR12MB8414:EE_
X-MS-Office365-Filtering-Correlation-Id: bf56dd98-40df-4048-206d-08db01e1e62f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TWpsgHXYkYamfQmExCEdeW1+0ABWDTTPj/d0+z2RyP9rLARbq5XBwgI6Az7RAuX0UefW6MLA0rMDSaRXzaHYQtHJ1Sp3fF2m2dfOhWeC4ZyLE/IT1QQAqG5JDsgECliPHX/iDVyVwh13F9um4wHqRAB8YvIC9aTd72alSWPsswwzNsIajB7aLZubt04Q5kTiEujaL/SDPeXQQMphUwy26BFZdabFk48c6kLDF+vc5GWpFBOGDL82UXQ2TZ7OLltXaigSNvW9H/RJx7QZZ3aknfnZpG3/Fym761JPrgbuYbe+F5xRVZC4o6rpue9p8gGYCwdPM7I0Ypb7GQYo2EVuA5AosyzqTnuxxc4AljPFIaO3s1EFY/OrKlMhCJTbE2yqOYQ7xRkc4kSbJA4saHKS8RGR7hQ15q17ZT7w94OxU4w/WrrwvOaA+pLvBYEyHAh7Sh7LSah55WEqe4kpl7qbIeJn3HdN30Q7xKqy84xHH59jgFRYDRqv0XUOBHbzFV3Mpl51KL4upaCIoGoGQeP1h4gsIKvkXQr6GS5qRzLXyKldHMZtQmKa5iAxxY+h4hsbRq/HyrajHN8/p55BdR4Smpw1wg6nN72XWA29vnhN7S5kxKOsqfRa0p6KsxUqAxy+xMG21Xw7j/QYt4SPHRp6Pl/gade31qjP181ml5tB0yI0VJnWry7pfKZ8wcqPKtZPMIYwVcAAMtkuH542AVG14w==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(82310400005)(36756003)(7636003)(36860700001)(47076005)(2616005)(82740400003)(26005)(186003)(40480700001)(5660300002)(30864003)(2906002)(356005)(1076003)(478600001)(70206006)(70586007)(8676002)(86362001)(4326008)(336012)(83380400001)(426003)(110136005)(6666004)(40460700003)(107886003)(54906003)(316002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 10:16:34.2768
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf56dd98-40df-4048-206d-08db01e1e62f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8414
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move tc miss handling code to en_tc.c, and remove
duplicate code.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 225 ++----------------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 221 +++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  11 +-
 4 files changed, 232 insertions(+), 229 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5..69ff212eaad8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020 Mellanox Technologies. */
 
-#include <net/dst_metadata.h>
 #include <linux/netdevice.h>
 #include <linux/if_macvlan.h>
 #include <linux/list.h>
@@ -665,235 +664,57 @@ void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
 				 mlx5e_rep_indr_block_unbind);
 }
 
-static bool mlx5e_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
-				 struct mlx5e_tc_update_priv *tc_priv,
-				 u32 tunnel_id)
-{
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct tunnel_match_enc_opts enc_opts = {};
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-	struct metadata_dst *tun_dst;
-	struct tunnel_match_key key;
-	u32 tun_id, enc_opts_id;
-	struct net_device *dev;
-	int err;
-
-	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
-	tun_id = tunnel_id >> ENC_OPTS_BITS;
-
-	if (!tun_id)
-		return true;
-
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
-	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
-	if (err) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
-			   tun_id, err);
-		return false;
-	}
-
-	if (enc_opts_id) {
-		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
-				   enc_opts_id, &enc_opts);
-		if (err) {
-			netdev_dbg(priv->netdev,
-				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
-				   enc_opts_id, err);
-			return false;
-		}
-	}
-
-	if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
-		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
-					   key.enc_ip.tos, key.enc_ip.ttl,
-					   key.enc_tp.dst, TUNNEL_KEY,
-					   key32_to_tunnel_id(key.enc_key_id.keyid),
-					   enc_opts.key.len);
-	} else if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
-		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
-					     key.enc_ip.tos, key.enc_ip.ttl,
-					     key.enc_tp.dst, 0, TUNNEL_KEY,
-					     key32_to_tunnel_id(key.enc_key_id.keyid),
-					     enc_opts.key.len);
-	} else {
-		netdev_dbg(priv->netdev,
-			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
-			   key.enc_control.addr_type);
-		return false;
-	}
-
-	if (!tun_dst) {
-		netdev_dbg(priv->netdev, "Couldn't restore tunnel, no tun_dst\n");
-		return false;
-	}
-
-	tun_dst->u.tun_info.key.tp_src = key.enc_tp.src;
-
-	if (enc_opts.key.len)
-		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
-					enc_opts.key.data,
-					enc_opts.key.len,
-					enc_opts.key.dst_opt_type);
-
-	skb_dst_set(skb, (struct dst_entry *)tun_dst);
-	dev = dev_get_by_index(&init_net, key.filter_ifindex);
-	if (!dev) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find tunnel device with ifindex: %d\n",
-			   key.filter_ifindex);
-		return false;
-	}
-
-	/* Set fwd_dev so we do dev_put() after datapath */
-	tc_priv->fwd_dev = dev;
-
-	skb->dev = dev;
-
-	return true;
-}
-
-static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
-				    struct mlx5e_tc_update_priv *tc_priv)
-{
-	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
-
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (chain) {
-		struct mlx5_rep_uplink_priv *uplink_priv;
-		struct mlx5e_rep_priv *uplink_rpriv;
-		struct tc_skb_ext *tc_skb_ext;
-		struct mlx5_eswitch *esw;
-		u32 zone_restore_id;
-
-		tc_skb_ext = tc_skb_ext_alloc(skb);
-		if (!tc_skb_ext) {
-			WARN_ON(1);
-			return false;
-		}
-		tc_skb_ext->chain = chain;
-		zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
-		esw = priv->mdev->priv.eswitch;
-		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-		uplink_priv = &uplink_rpriv->uplink_priv;
-		if (!mlx5e_tc_ct_restore_flow(uplink_priv->ct_priv, skb,
-					      zone_restore_id))
-			return false;
-	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
-
-	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
-}
-
-static void mlx5_rep_tc_post_napi_receive(struct mlx5e_tc_update_priv *tc_priv)
-{
-	if (tc_priv->fwd_dev)
-		dev_put(tc_priv->fwd_dev);
-}
-
-static void mlx5e_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
-				     struct mlx5_mapped_obj *mapped_obj,
-				     struct mlx5e_tc_update_priv *tc_priv)
-{
-	if (!mlx5e_restore_tunnel(priv, skb, tc_priv, mapped_obj->sample.tunnel_id)) {
-		netdev_dbg(priv->netdev,
-			   "Failed to restore tunnel info for sampled packet\n");
-		return;
-	}
-	mlx5e_tc_sample_skb(skb, mapped_obj);
-	mlx5_rep_tc_post_napi_receive(tc_priv);
-}
-
-static bool mlx5e_restore_skb_int_port(struct mlx5e_priv *priv, struct sk_buff *skb,
-				       struct mlx5_mapped_obj *mapped_obj,
-				       struct mlx5e_tc_update_priv *tc_priv,
-				       bool *forward_tx,
-				       u32 reg_c1)
-{
-	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
-	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
-	struct mlx5_rep_uplink_priv *uplink_priv;
-	struct mlx5e_rep_priv *uplink_rpriv;
-
-	/* Tunnel restore takes precedence over int port restore */
-	if (tunnel_id)
-		return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
-
-	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
-	uplink_priv = &uplink_rpriv->uplink_priv;
-
-	if (mlx5e_tc_int_port_dev_fwd(uplink_priv->int_port_priv, skb,
-				      mapped_obj->int_port_metadata, forward_tx)) {
-		/* Set fwd_dev for future dev_put */
-		tc_priv->fwd_dev = skb->dev;
-
-		return true;
-	}
-
-	return false;
-}
-
 void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
 			  struct sk_buff *skb)
 {
-	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata);
+	u32 reg_c1 = be32_to_cpu(cqe->ft_metadata), reg_c0, zone_restore_id, tunnel_id;
 	struct mlx5e_tc_update_priv tc_priv = {};
-	struct mlx5_mapped_obj mapped_obj;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct mapping_ctx *mapping_ctx;
 	struct mlx5_eswitch *esw;
-	bool forward_tx = false;
 	struct mlx5e_priv *priv;
-	u32 reg_c0;
-	int err;
 
 	reg_c0 = (be32_to_cpu(cqe->sop_drop_qpn) & MLX5E_TC_FLOW_ID_MASK);
 	if (!reg_c0 || reg_c0 == MLX5_FS_DEFAULT_FLOW_TAG)
 		goto forward;
 
-	/* If reg_c0 is not equal to the default flow tag then skb->mark
+	/* If mapped_obj_id is not equal to the default flow tag then skb->mark
 	 * is not supported and must be reset back to 0.
 	 */
 	skb->mark = 0;
 
 	priv = netdev_priv(skb->dev);
 	esw = priv->mdev->priv.eswitch;
-	err = mapping_find(esw->offloads.reg_c0_obj_pool, reg_c0, &mapped_obj);
-	if (err) {
-		netdev_dbg(priv->netdev,
-			   "Couldn't find mapped object for reg_c0: %d, err: %d\n",
-			   reg_c0, err);
-		goto free_skb;
-	}
+	mapping_ctx = esw->offloads.reg_c0_obj_pool;
+	zone_restore_id = reg_c1 & ESW_ZONE_ID_MASK;
+	tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
 
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		if (!mlx5e_restore_skb_chain(skb, mapped_obj.chain, reg_c1, &tc_priv) &&
-		    !mlx5_ipsec_is_rx_flow(cqe))
-			goto free_skb;
-	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
-		mlx5e_restore_skb_sample(priv, skb, &mapped_obj, &tc_priv);
-		goto free_skb;
-	} else if (mapped_obj.type == MLX5_MAPPED_OBJ_INT_PORT_METADATA) {
-		if (!mlx5e_restore_skb_int_port(priv, skb, &mapped_obj, &tc_priv,
-						&forward_tx, reg_c1))
-			goto free_skb;
-	} else {
-		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+	ct_priv = uplink_priv->ct_priv;
+
+	if (!mlx5_ipsec_is_rx_flow(cqe) &&
+	    !mlx5e_tc_update_skb(cqe, skb, mapping_ctx, reg_c0, ct_priv, zone_restore_id, tunnel_id,
+				 &tc_priv))
 		goto free_skb;
-	}
 
 forward:
-	if (forward_tx)
+	if (tc_priv.skb_done)
+		goto free_skb;
+
+	if (tc_priv.forward_tx)
 		dev_queue_xmit(skb);
 	else
 		napi_gro_receive(rq->cq.napi, skb);
 
-	mlx5_rep_tc_post_napi_receive(&tc_priv);
+	if (tc_priv.fwd_dev)
+		dev_put(tc_priv.fwd_dev);
 
 	return;
 
 free_skb:
+	WARN_ON(tc_priv.fwd_dev);
 	dev_kfree_skb_any(skb);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index a9473a51edc1..fea0c2aa95e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1792,7 +1792,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb)) {
+		if (!mlx5e_tc_update_skb_nic(cqe, skb)) {
 			dev_kfree_skb_any(skb);
 			goto free_wqe;
 		}
@@ -2259,7 +2259,7 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 
 	if (mlx5e_cqe_regb_chain(cqe))
-		if (!mlx5e_tc_update_skb(cqe, skb)) {
+		if (!mlx5e_tc_update_skb_nic(cqe, skb)) {
 			dev_kfree_skb_any(skb);
 			goto mpwrq_cqe_out;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab6..6275c451e32a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -43,6 +43,7 @@
 #include <net/ipv6_stubs.h>
 #include <net/bareudp.h>
 #include <net/bonding.h>
+#include <net/dst_metadata.h>
 #include "en.h"
 #include "en/tc/post_act.h"
 #include "en_rep.h"
@@ -5562,47 +5563,221 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
-			 struct sk_buff *skb)
+static bool mlx5e_tc_restore_tunnel(struct mlx5e_priv *priv, struct sk_buff *skb,
+				    struct mlx5e_tc_update_priv *tc_priv,
+				    u32 tunnel_id)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
-	struct mlx5e_priv *priv = netdev_priv(skb->dev);
-	struct mlx5_mapped_obj mapped_obj;
-	struct tc_skb_ext *tc_skb_ext;
-	struct mlx5e_tc_table *tc;
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct tunnel_match_enc_opts enc_opts = {};
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	struct metadata_dst *tun_dst;
+	struct tunnel_match_key key;
+	u32 tun_id, enc_opts_id;
+	struct net_device *dev;
 	int err;
 
-	reg_b = be32_to_cpu(cqe->ft_metadata);
-	tc = mlx5e_fs_get_tc(priv->fs);
-	chain_tag = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+	enc_opts_id = tunnel_id & ENC_OPTS_BITS_MASK;
+	tun_id = tunnel_id >> ENC_OPTS_BITS;
 
-	err = mapping_find(tc->mapping, chain_tag, &mapped_obj);
+	if (!tun_id)
+		return true;
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	err = mapping_find(uplink_priv->tunnel_mapping, tun_id, &key);
 	if (err) {
 		netdev_dbg(priv->netdev,
-			   "Couldn't find chain for chain tag: %d, err: %d\n",
-			   chain_tag, err);
+			   "Couldn't find tunnel for tun_id: %d, err: %d\n",
+			   tun_id, err);
+		return false;
+	}
+
+	if (enc_opts_id) {
+		err = mapping_find(uplink_priv->tunnel_enc_opts_mapping,
+				   enc_opts_id, &enc_opts);
+		if (err) {
+			netdev_dbg(priv->netdev,
+				   "Couldn't find tunnel (opts) for tun_id: %d, err: %d\n",
+				   enc_opts_id, err);
+			return false;
+		}
+	}
+
+	if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+		tun_dst = __ip_tun_set_dst(key.enc_ipv4.src, key.enc_ipv4.dst,
+					   key.enc_ip.tos, key.enc_ip.ttl,
+					   key.enc_tp.dst, TUNNEL_KEY,
+					   key32_to_tunnel_id(key.enc_key_id.keyid),
+					   enc_opts.key.len);
+	} else if (key.enc_control.addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		tun_dst = __ipv6_tun_set_dst(&key.enc_ipv6.src, &key.enc_ipv6.dst,
+					     key.enc_ip.tos, key.enc_ip.ttl,
+					     key.enc_tp.dst, 0, TUNNEL_KEY,
+					     key32_to_tunnel_id(key.enc_key_id.keyid),
+					     enc_opts.key.len);
+	} else {
+		netdev_dbg(priv->netdev,
+			   "Couldn't restore tunnel, unsupported addr_type: %d\n",
+			   key.enc_control.addr_type);
 		return false;
 	}
 
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
-		chain = mapped_obj.chain;
+	if (!tun_dst) {
+		netdev_dbg(priv->netdev, "Couldn't restore tunnel, no tun_dst\n");
+		return false;
+	}
+
+	tun_dst->u.tun_info.key.tp_src = key.enc_tp.src;
+
+	if (enc_opts.key.len)
+		ip_tunnel_info_opts_set(&tun_dst->u.tun_info,
+					enc_opts.key.data,
+					enc_opts.key.len,
+					enc_opts.key.dst_opt_type);
+
+	skb_dst_set(skb, (struct dst_entry *)tun_dst);
+	dev = dev_get_by_index(&init_net, key.filter_ifindex);
+	if (!dev) {
+		netdev_dbg(priv->netdev,
+			   "Couldn't find tunnel device with ifindex: %d\n",
+			   key.filter_ifindex);
+		return false;
+	}
+
+	/* Set fwd_dev so we do dev_put() after datapath */
+	tc_priv->fwd_dev = dev;
+
+	skb->dev = dev;
+
+	return true;
+}
+
+static bool mlx5e_tc_restore_skb_chain(struct sk_buff *skb, struct mlx5_tc_ct_priv *ct_priv,
+				       u32 chain, u32 zone_restore_id,
+				       u32 tunnel_id,  struct mlx5e_tc_update_priv *tc_priv)
+{
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	struct tc_skb_ext *tc_skb_ext;
+
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	if (chain) {
+		if (!mlx5e_tc_ct_restore_flow(ct_priv, skb, zone_restore_id))
+			return false;
+
 		tc_skb_ext = tc_skb_ext_alloc(skb);
-		if (WARN_ON(!tc_skb_ext))
+		if (!tc_skb_ext) {
+			WARN_ON(1);
 			return false;
+		}
 
 		tc_skb_ext->chain = chain;
+	}
+#endif /* CONFIG_NET_TC_SKB_EXT */
 
-		zone_restore_id = (reg_b >> MLX5_REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
-			ESW_ZONE_ID_MASK;
+	if (tc_priv)
+		return mlx5e_tc_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 
-		if (!mlx5e_tc_ct_restore_flow(tc->ct, skb,
-					      zone_restore_id))
-			return false;
-	} else {
+	return true;
+}
+
+static void mlx5e_tc_restore_skb_sample(struct mlx5e_priv *priv, struct sk_buff *skb,
+					struct mlx5_mapped_obj *mapped_obj,
+					struct mlx5e_tc_update_priv *tc_priv)
+{
+	if (!mlx5e_tc_restore_tunnel(priv, skb, tc_priv, mapped_obj->sample.tunnel_id)) {
+		netdev_dbg(priv->netdev,
+			   "Failed to restore tunnel info for sampled packet\n");
+		return;
+	}
+	mlx5e_tc_sample_skb(skb, mapped_obj);
+}
+
+static bool mlx5e_tc_restore_skb_int_port(struct mlx5e_priv *priv, struct sk_buff *skb,
+					  struct mlx5_mapped_obj *mapped_obj,
+					  struct mlx5e_tc_update_priv *tc_priv,
+					  u32 tunnel_id)
+{
+	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
+	struct mlx5_rep_uplink_priv *uplink_priv;
+	struct mlx5e_rep_priv *uplink_rpriv;
+	bool forward_tx = false;
+
+	/* Tunnel restore takes precedence over int port restore */
+	if (tunnel_id)
+		return mlx5e_tc_restore_tunnel(priv, skb, tc_priv, tunnel_id);
+
+	uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
+	uplink_priv = &uplink_rpriv->uplink_priv;
+
+	if (mlx5e_tc_int_port_dev_fwd(uplink_priv->int_port_priv, skb,
+				      mapped_obj->int_port_metadata, &forward_tx)) {
+		/* Set fwd_dev for future dev_put */
+		tc_priv->fwd_dev = skb->dev;
+		tc_priv->forward_tx = forward_tx;
+
+		return true;
+	}
+
+	return false;
+}
+
+bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
+			 struct mapping_ctx *mapping_ctx, u32 mapped_obj_id,
+			 struct mlx5_tc_ct_priv *ct_priv,
+			 u32 zone_restore_id, u32 tunnel_id,
+			 struct mlx5e_tc_update_priv *tc_priv)
+{
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	struct mlx5_mapped_obj mapped_obj;
+	int err;
+
+	err = mapping_find(mapping_ctx, mapped_obj_id, &mapped_obj);
+	if (err) {
+		netdev_dbg(skb->dev,
+			   "Couldn't find mapped object for mapped_obj_id: %d, err: %d\n",
+			   mapped_obj_id, err);
+		return false;
+	}
+
+	switch (mapped_obj.type) {
+	case MLX5_MAPPED_OBJ_CHAIN:
+		return mlx5e_tc_restore_skb_chain(skb, ct_priv, mapped_obj.chain, zone_restore_id,
+						  tunnel_id, tc_priv);
+	case MLX5_MAPPED_OBJ_SAMPLE:
+		mlx5e_tc_restore_skb_sample(priv, skb, &mapped_obj, tc_priv);
+		tc_priv->skb_done = true;
+		return true;
+	case MLX5_MAPPED_OBJ_INT_PORT_METADATA:
+		return mlx5e_tc_restore_skb_int_port(priv, skb, &mapped_obj, tc_priv, tunnel_id);
+	default:
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
+
+	return false;
+}
+
+bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct mlx5e_priv *priv = netdev_priv(skb->dev);
+	u32 mapped_obj_id, reg_b, zone_restore_id;
+	struct mlx5_tc_ct_priv *ct_priv;
+	struct mapping_ctx *mapping_ctx;
+	struct mlx5e_tc_table *tc;
+
+	reg_b = be32_to_cpu(cqe->ft_metadata);
+	tc = mlx5e_fs_get_tc(priv->fs);
+	mapped_obj_id = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
+	zone_restore_id = (reg_b >> MLX5_REG_MAPPING_MOFFSET(NIC_ZONE_RESTORE_TO_REG)) &
+			  ESW_ZONE_ID_MASK;
+	ct_priv = tc->ct;
+	mapping_ctx = tc->mapping;
+
+	return mlx5e_tc_update_skb(cqe, skb, mapping_ctx, mapped_obj_id, ct_priv, zone_restore_id,
+				   0, NULL);
 #endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fd..4fa5d4e024cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -59,6 +59,8 @@ int mlx5e_tc_num_filters(struct mlx5e_priv *priv, unsigned long flags);
 
 struct mlx5e_tc_update_priv {
 	struct net_device *fwd_dev;
+	bool skb_done;
+	bool forward_tx;
 };
 
 struct mlx5_nic_flow_attr {
@@ -386,14 +388,19 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 	return false;
 }
 
-bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+bool mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb);
+bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb,
+			 struct mapping_ctx *mapping_ctx, u32 mapped_obj_id,
+			 struct mlx5_tc_ct_priv *ct_priv,
+			 u32 zone_restore_id, u32 tunnel_id,
+			 struct mlx5e_tc_update_priv *tc_priv);
 #else /* CONFIG_MLX5_CLS_ACT */
 static inline struct mlx5e_tc_table *mlx5e_tc_table_alloc(void) { return NULL; }
 static inline void mlx5e_tc_table_free(struct mlx5e_tc_table *tc) {}
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 { return false; }
 static inline bool
-mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
+mlx5e_tc_update_skb_nic(struct mlx5_cqe64 *cqe, struct sk_buff *skb)
 { return true; }
 #endif
 
-- 
2.30.1

