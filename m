Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B21682873
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjAaJPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbjAaJPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:15:00 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD85DBE7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:12:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P4nlYNkZPWxv5tblCm5vXIA2jkomb/uInzMR13oRT6pM9TDPkz3G9Se/gi00oVplHsT9u6Xl6TpIa15A8ZpL282d4gOlSbVZdRyj8wI+Ls+sa2ngxwBZ6dYG8bfyZYQTRdFt2DgDxJ65iK3bc5nkj8jxcdvT/8K/bwMwnzHyBRgAO5IGptaE6fMSPh+a5fW4ge680Coz99kgvVAJGdgam3D8iKxD5NXuyErDXDqwVdEO9S2uJzHKj6+nqi+3o9vZYbwiXZSDTSdPQoFjk4o3KkpZJ7KNvt6IhphQxrn+l8U46COPz2qO9XdmMVZJev0vVaAetmUDXrJxUvhsluv85w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wcwUzYUG+rb2I4tzd2HMnff1dW5JMaJB/T7Aj74IWoU=;
 b=c1W37lG1gJTqvatvv2C4IwIzWt7IObLX6+Objej7tISPMOcU80TQ9BQX14Er/viuStgXFTY36GA0zP+8RfHdJPzn24zieQzfN/vxOmEJhGn00cCELv8fpo9crfMxkMWr7ccEN4/2sN8TL4aEY6cRUzqKRqizrwWW7GJUheQyqpOKOHdbfA6JsQxkIOpSG6Kc5mxdEJJiNrRaTk39I1epoOJWXvvVg98cy6hIwIJppGGBu9v+Xp9Zl1S1i02m14qZ9hsa12lfe4tTbXIjCXl9oM5twHiZP4mscOs/iiEmSwk+M8QzFkA9rfZxKxYMRwxtSBEp6WVb0gfXc0YuSOppBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wcwUzYUG+rb2I4tzd2HMnff1dW5JMaJB/T7Aj74IWoU=;
 b=gk9P0Oix0BQpCR52pv1kE6c1Mer8GGspKRPxFqxSk2WizYvz8BrMKskhAm2/lH8A0Eb9r9IwXCQGRbjUje1m/UHJsZefaBz/3tEvhI0rMTbpk3NT31iEhfhro1sbkNGBddeCJ7r9I0m7Nsrmkqf66D55R/rYvEJBCS6E7V+rGci3ewoxlSJmiGffHEMgWGDmu4IGhKOKQOJpfZ4uFS+w9XFR8Msqu9vHgRX99BJC2elvgM/BCta9CG7P9GCaoV2tAuZJCntn+wypd5JsJv8qXILpfAEp0n7ZBtPZcDdaB6TtV0U3YLjS5Qmtk7wOcDodOBVKTy82fFtvVcAjydTUww==
Received: from BN1PR14CA0027.namprd14.prod.outlook.com (2603:10b6:408:e3::32)
 by CH2PR12MB4905.namprd12.prod.outlook.com (2603:10b6:610:64::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 09:11:11 +0000
Received: from BL02EPF000108E8.namprd05.prod.outlook.com
 (2603:10b6:408:e3:cafe::c4) by BN1PR14CA0027.outlook.office365.com
 (2603:10b6:408:e3::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 09:11:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108E8.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Tue, 31 Jan 2023 09:11:10 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:58 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Tue, 31 Jan 2023 01:10:54 -0800
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
Subject: [PATCH net-next v7 4/6] net/mlx5: Refactor tc miss handling to a single function
Date:   Tue, 31 Jan 2023 11:10:25 +0200
Message-ID: <20230131091027.8093-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230131091027.8093-1-paulb@nvidia.com>
References: <20230131091027.8093-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E8:EE_|CH2PR12MB4905:EE_
X-MS-Office365-Filtering-Correlation-Id: d4d5b939-d55a-4ecc-4b78-08db036b1870
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKSAN95AtFYLj69so7WOlWMJ6xPt+CbQXlY8IVpaRlVsiuiSFhYEPutuDQnuvrjHWwoyzrbAcxr6hLWF0pvu0ibIOqAUz2t8M4VG3jGOjBgN4cAlQg7rlZeldKpXKc68lFkc1y1TM1ckuW6zJWwxWieS/S78ZUg+OHbUoMtD+jTiRUzivbabK7baczXFm8OrR7cOOfUMZSX2BUu07QO0Y+PN8E1WNqfEoywBrDJDfa13f/cyrDfxQuCauNERLllLedOxzK0eFZKL0MshrO3EWohOPmGunbbRa4+9zr8XdPm1Mfkb/Ewexixr4QfZWUH5cAtfT28LdG22mjrKx0sqjIZ5tqhFZGUr6Bj3xZxdfw1ile8e5ULmX9BNMUK0HEXeQ3LXff2DGdo4wfKkEF9coHzH2QiD1G7fHgDhWN2sAMf8dxt7WeHqR1KCceJJtMV+oqI1GBf65IR8EuE4N3mcZr++guEfM7LQJYbItk7W1+nju7puKZAlrPTI5qOHPI8F9aE6+vY5aBL7ir/TaTKFz7LSghVG6rB/gZVbwdlbbYdBMEwPh8QwHIVdavZYeEv4ipbHIrvmqc6S5lbE1R0vnEoydsuLPW3/ZKh+E8Ff+tprg5hjAqBHOwa9Os8Iy41D2ONVmC7Llz7+lGNMRbkiNGFfaL+nMREXtP858Uz6fEvIuB0wkK4Gj8ViTtVPLS8VhmYr7OMoQXYyH37w4ApTxQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(107886003)(6666004)(40460700003)(41300700001)(2616005)(336012)(1076003)(478600001)(186003)(26005)(110136005)(54906003)(316002)(8676002)(7636003)(83380400001)(70586007)(70206006)(4326008)(82740400003)(8936002)(2906002)(36860700001)(426003)(36756003)(47076005)(356005)(86362001)(40480700001)(5660300002)(82310400005)(30864003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 09:11:10.7578
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d5b939-d55a-4ecc-4b78-08db036b1870
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4905
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 224 ++----------------
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 221 +++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  11 +-
 4 files changed, 231 insertions(+), 229 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5..4438c2a8d4ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020 Mellanox Technologies. */
 
-#include <net/dst_metadata.h>
 #include <linux/netdevice.h>
 #include <linux/if_macvlan.h>
 #include <linux/list.h>
@@ -665,232 +664,53 @@ void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
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

