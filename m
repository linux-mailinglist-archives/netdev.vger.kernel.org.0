Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEBB647AA0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiLIAP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiLIAO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5BE8F716
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD09E620DA
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041DAC433F1;
        Fri,  9 Dec 2022 00:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544887;
        bh=B/9Vdv0b+Kpf/fcLXWbdgp157Jctbd9XNtF1MZnpSuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qcft6F8aspmk3MHkJRY6R41NeH0p1XouAFS0DUftAVR5m9508R4txDlTLnJ72M8NU
         MdcdbBowBiWmPIzGOGgy6weTCj2IJMgHnokGP4CPvMAoPRQ+K6APA484pCsVYesXvm
         Gd82En0uI0DiyTF8bSYvPGo9g3EWCcxjkr6WWQc20M69qVzXAxtyW3lXq/4aMLazLh
         GlYtoYpMgXaMNj4zUd+jrzYGmBWlN1UUFrWhFrCcW6vxQ3h1o1W/bwdoMpNbaEu0FH
         9ARm5+kNcVNfLNf5QaMgZylcylmWUWMh47Dgd49XSWImyFzpV/8V2xQY+rO7pFMXaV
         cE7zqCeM4Kzvw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Or Har-Toov <ohartoov@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: [net-next 14/15] net/mlx5: Refactor and expand rep vport stat group
Date:   Thu,  8 Dec 2022 16:14:19 -0800
Message-Id: <20221209001420.142794-15-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Or Har-Toov <ohartoov@nvidia.com>

Expand representor vport stat group to support all counters from the
vport stat group, to count all the traffic passing through the vport.

Fix current implementation where fill_stats and update_stats use
different structs.

Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 94 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en_stats.h    | 16 ++++
 2 files changed, 90 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 623886462c10..75b9e1528fd2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -85,18 +85,25 @@ static const struct counter_desc sw_rep_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_bytes) },
 };
 
-struct vport_stats {
-	u64 vport_rx_packets;
-	u64 vport_tx_packets;
-	u64 vport_rx_bytes;
-	u64 vport_tx_bytes;
-};
-
 static const struct counter_desc vport_rep_stats_desc[] = {
-	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_rx_packets) },
-	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_rx_bytes) },
-	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_tx_packets) },
-	{ MLX5E_DECLARE_STAT(struct vport_stats, vport_tx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats, vport_rx_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats, vport_rx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats, vport_tx_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats, vport_tx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats,
+			     rx_vport_rdma_unicast_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats, rx_vport_rdma_unicast_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats,
+			     tx_vport_rdma_unicast_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats, tx_vport_rdma_unicast_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats,
+			     rx_vport_rdma_multicast_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats,
+			     rx_vport_rdma_multicast_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats,
+			     tx_vport_rdma_multicast_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_rep_stats,
+			     tx_vport_rdma_multicast_bytes) },
 };
 
 #define NUM_VPORT_REP_SW_COUNTERS ARRAY_SIZE(sw_rep_stats_desc)
@@ -161,33 +168,80 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(vport_rep)
 	int i;
 
 	for (i = 0; i < NUM_VPORT_REP_HW_COUNTERS; i++)
-		data[idx++] = MLX5E_READ_CTR64_CPU(&priv->stats.vf_vport,
+		data[idx++] = MLX5E_READ_CTR64_CPU(&priv->stats.rep_stats,
 						   vport_rep_stats_desc, i);
 	return idx;
 }
 
 static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 {
+	struct mlx5e_rep_stats *rep_stats = &priv->stats.rep_stats;
+	int outlen = MLX5_ST_SZ_BYTES(query_vport_counter_out);
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 	struct mlx5e_rep_priv *rpriv = priv->ppriv;
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
-	struct rtnl_link_stats64 *vport_stats;
-	struct ifla_vf_stats vf_stats;
+	u32 *out;
 	int err;
 
-	err = mlx5_eswitch_get_vport_stats(esw, rep->vport, &vf_stats);
+	out = kvzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return;
+
+	err = mlx5_core_query_vport_counter(esw->dev, 1, rep->vport - 1, 0, out);
 	if (err) {
 		netdev_warn(priv->netdev, "vport %d error %d reading stats\n",
 			    rep->vport, err);
 		return;
 	}
 
-	vport_stats = &priv->stats.vf_vport;
+	#define MLX5_GET_CTR(p, x) \
+		MLX5_GET64(query_vport_counter_out, p, x)
 	/* flip tx/rx as we are reporting the counters for the switch vport */
-	vport_stats->rx_packets = vf_stats.tx_packets;
-	vport_stats->rx_bytes   = vf_stats.tx_bytes;
-	vport_stats->tx_packets = vf_stats.rx_packets;
-	vport_stats->tx_bytes   = vf_stats.rx_bytes;
+	rep_stats->vport_rx_packets =
+		MLX5_GET_CTR(out, transmitted_ib_unicast.packets) +
+		MLX5_GET_CTR(out, transmitted_eth_unicast.packets) +
+		MLX5_GET_CTR(out, transmitted_ib_multicast.packets) +
+		MLX5_GET_CTR(out, transmitted_eth_multicast.packets) +
+		MLX5_GET_CTR(out, transmitted_eth_broadcast.packets);
+
+	rep_stats->vport_tx_packets =
+		MLX5_GET_CTR(out, received_ib_unicast.packets) +
+		MLX5_GET_CTR(out, received_eth_unicast.packets) +
+		MLX5_GET_CTR(out, received_ib_multicast.packets) +
+		MLX5_GET_CTR(out, received_eth_multicast.packets) +
+		MLX5_GET_CTR(out, received_eth_broadcast.packets);
+
+	rep_stats->vport_rx_bytes =
+		MLX5_GET_CTR(out, transmitted_ib_unicast.octets) +
+		MLX5_GET_CTR(out, transmitted_eth_unicast.octets) +
+		MLX5_GET_CTR(out, transmitted_ib_multicast.octets) +
+		MLX5_GET_CTR(out, transmitted_eth_broadcast.octets);
+
+	rep_stats->vport_tx_bytes =
+		MLX5_GET_CTR(out, received_ib_unicast.octets) +
+		MLX5_GET_CTR(out, received_eth_unicast.octets) +
+		MLX5_GET_CTR(out, received_ib_multicast.octets) +
+		MLX5_GET_CTR(out, received_eth_multicast.octets) +
+		MLX5_GET_CTR(out, received_eth_broadcast.octets);
+
+	rep_stats->rx_vport_rdma_unicast_packets =
+		MLX5_GET_CTR(out, transmitted_ib_unicast.packets);
+	rep_stats->tx_vport_rdma_unicast_packets =
+		MLX5_GET_CTR(out, received_ib_unicast.packets);
+	rep_stats->rx_vport_rdma_unicast_bytes =
+		MLX5_GET_CTR(out, transmitted_ib_unicast.octets);
+	rep_stats->tx_vport_rdma_unicast_bytes =
+		MLX5_GET_CTR(out, received_ib_unicast.octets);
+	rep_stats->rx_vport_rdma_multicast_packets =
+		MLX5_GET_CTR(out, transmitted_ib_multicast.packets);
+	rep_stats->tx_vport_rdma_multicast_packets =
+		MLX5_GET_CTR(out, received_ib_multicast.packets);
+	rep_stats->rx_vport_rdma_multicast_bytes =
+		MLX5_GET_CTR(out, transmitted_ib_multicast.octets);
+	rep_stats->tx_vport_rdma_multicast_bytes =
+		MLX5_GET_CTR(out, received_ib_multicast.octets);
+
+	kvfree(out);
 }
 
 static void mlx5e_rep_get_strings(struct net_device *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index cbc831ca646b..37df58ba958c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -463,6 +463,21 @@ struct mlx5e_ptp_cq_stats {
 	u64 resync_event;
 };
 
+struct mlx5e_rep_stats {
+	u64 vport_rx_packets;
+	u64 vport_tx_packets;
+	u64 vport_rx_bytes;
+	u64 vport_tx_bytes;
+	u64 rx_vport_rdma_unicast_packets;
+	u64 tx_vport_rdma_unicast_packets;
+	u64 rx_vport_rdma_unicast_bytes;
+	u64 tx_vport_rdma_unicast_bytes;
+	u64 rx_vport_rdma_multicast_packets;
+	u64 tx_vport_rdma_multicast_packets;
+	u64 rx_vport_rdma_multicast_bytes;
+	u64 tx_vport_rdma_multicast_bytes;
+};
+
 struct mlx5e_stats {
 	struct mlx5e_sw_stats sw;
 	struct mlx5e_qcounter_stats qcnt;
@@ -471,6 +486,7 @@ struct mlx5e_stats {
 	struct mlx5e_pport_stats pport;
 	struct rtnl_link_stats64 vf_vport;
 	struct mlx5e_pcie_stats pcie;
+	struct mlx5e_rep_stats rep_stats;
 };
 
 extern mlx5e_stats_grp_t mlx5e_nic_stats_grps[];
-- 
2.38.1

