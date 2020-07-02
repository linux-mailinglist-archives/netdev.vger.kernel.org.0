Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2677A212F69
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 00:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgGBWUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 18:20:42 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:22294
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbgGBWUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 18:20:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q33jud0HgOHG4sXkyjcfgbd96P5irreI3ng6/dLDKgBwdsmZAxZddXilJ35YwPllYuKM00XhHfgXQlyN8lUBwLGc5pzEemHzFQstjlL2e3RFTKlSJWHC7FUeeBiqUE3xfbYEnuDUE96ZV3Qv09XJI/UnJa7i7twHIptWgdqRdJr9F8IT5v5yBRuvkbaGrM7v1ksI0Lp5Rq1PANSf8PYxTrNqBYohnzXf6GJhHaROTs5id9dODM6EGczPpbVt3HEXImytNKNZMh5X2t3+uPsMRL3HqdU7JRRxEbVon8+XX1DM0Cgd89mNlopSAbMnvUCoO0zzZpaNf71r5+ty7ZHq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRe0BmqTqEq7TXyl6SYlpkI1PH+v8sdhwjKllivbh+4=;
 b=gvBS2KJdEj3mu8LDH8nTmvuiUUjpc3a9m+03vMMU6JKSbj8X7YyMrRbaa8wXVhfiDSJMIeSkH+2k4F0p3bxJNezEla+n76y86HKengOkUMNeiC9oBiJyR6UKS1LvI67XsChqXQVcdJUT0bw8ogYAySgF+15rcZTOOi3mGSIiiXf+HNalJA4pO9NgV+/xoUCJcgy/qGiY51nsLN3qZvHv6AEaUN8mDyrwxrXfXR7iX3rY+dUHw9nxhft8lKqj/lz3dy0WqYY7Aea9LFWLd5FFXCL9zDymA88oF5d1BRhrh8Wb0dqv7DmfOfEjG0uZBDZAcuUcop+wPruQ6g39dO7ozw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRe0BmqTqEq7TXyl6SYlpkI1PH+v8sdhwjKllivbh+4=;
 b=EWuyoa1zPPQ01ge4ZsSRdfnsSshtQhVRRaFMEIImrss8j1A6xxWSnSm8dlQ6vWyXZYrSJ8S7xcz5aqTIFaKlUZVWJKvwLRZu7hVmIUsbdOHxjuUC1tW1fb4htYRaOk56uDO5GeTmj5eFhMadPDFQLnIMO43xQFsB6wlzWkqLgSg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 22:20:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Thu, 2 Jul 2020
 22:20:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/11] net/mlx5e: Fix multicast counter not up-to-date in "ip -s"
Date:   Thu,  2 Jul 2020 15:19:14 -0700
Message-Id: <20200702221923.650779-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702221923.650779-1-saeedm@mellanox.com>
References: <20200702221923.650779-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0030.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0030.namprd04.prod.outlook.com (2603:10b6:a03:1d0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22 via Frontend Transport; Thu, 2 Jul 2020 22:20:33 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80f51509-ce49-4fa0-67cd-08d81ed62429
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6109426900F2D9D29C0B6F48BE6D0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:655;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BW51L/cn4No1JdfNDwGfs4vtl5bmYLJseXu07jyjZhH9KhlvH1MieI8GG0TQSYHRALbOGRDqrVx3rYwOvCN87YZHPF8O5acKqbmdhlncDVKDkmS7kJ27eP/5nxMg0QmdrbDzilMRGfYg/xpf0LRw0dLCXOZtNdANoYKiVA0rGmAGAcrui1UEmbWQ7lBdjEqOq6aYbQiHQjaN+TVmVyxF5hnMT2jaRZYW6kL7MTMHKQXljwFBXdPruU9xLgGV2k7yhMgClCSq3/RV7BSPxMhwqvA7QmUPgJLM8RlU2m/eWtUrXoigJVubvkHA1ven7Wt2bSC0Eo+bE03JZAn3N6mYeh/TGupdQRkNtiHbRAYoC68xrC+ZXPn4vDqIqqj82y5f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(26005)(2616005)(316002)(956004)(6666004)(5660300002)(8936002)(86362001)(110136005)(186003)(16526019)(107886003)(83380400001)(4326008)(66946007)(54906003)(8676002)(6506007)(6486002)(1076003)(36756003)(52116002)(6512007)(66476007)(2906002)(66556008)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cXosLaNfRQGoK60g2tZx5I5/NRTsxPOJDgVwLgukRlq14KZIyclUWDNe33oPGwVdkOy6308I/MbjjLJSZk5pP8CBlrGESVQu6D9PbQXe2nWK/FSnuyLoAdDQf92paKiXRPmPiSCH5z0T4iHIvT6f2pF13Jm5VkVaPmNpqF+oL7ciDwyc9EwXZM5///jc8n4BbA/yvsmq7RrF4ALjEc4ml296VitgoEzbaXtq2DhYzB+nYtn0z2ZQ68/HbPyF66BVK90JuGNTHRuxUktUL7eZGLKDWdbIwA2OedGJoRcp7AnHX4ZeEEWpw3U3Sl9grE2u0Zux3qFrpzIXFRaIVJ5qaXuLhsEgEIhlBIiosuOO64XKZyZi3xz4F4HUOlpkCiUFRmZExtiFa69QAl16sOAq4DcAUy5DXju6ZQM3gVidKAs2FHNKfyrkxUJYz8qO4hgsNqVY4XxvWXOvj9AONr+c9FbCK8RgWgrpSGhUAFFvdOo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f51509-ce49-4fa0-67cd-08d81ed62429
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 22:20:35.4131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUrVCrtSmwInou84IkTxSE7LMX5bFQ/3cOV5myV9MLqdOpiMmV+zOXXqsfYc45JyvbJ3wmNbZPllyVmy5Rd7Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ron Diskin <rondi@mellanox.com>

Currently the FW does not generate events for counters other than error
counters. Unlike ".get_ethtool_stats", ".ndo_get_stats64" (which ip -s
uses) might run in atomic context, while the FW interface is non atomic.
Thus, 'ip' is not allowed to issue fw commands, so it will only display
cached counters in the driver.

Add a SW counter (mcast_packets) in the driver to count rx multicast
packets. The counter also counts broadcast packets, as we consider it a
special case of multicast.
Use the counter value when calling "ip -s"/"ifconfig".  Display the new
counter when calling "ethtool -S", and add a matching counter
(mcast_bytes) for completeness.

Fixes: f62b8bb8f2d3 ("net/mlx5: Extend mlx5_core to support ConnectX-4 Ethernet functionality")
Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 8 +-------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h | 4 ++++
 5 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index bfd3e1161bc6..5b554e79d734 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -13,6 +13,11 @@ enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_UMR_RX,
 };
 
+static inline bool mlx5e_skb_is_multicast(struct sk_buff *skb)
+{
+	return skb->pkt_type == PACKET_MULTICAST || skb->pkt_type == PACKET_BROADCAST;
+}
+
 static inline bool
 mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, u16 pc, u16 n)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a836a02a2116..ee4cc723d225 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3558,6 +3558,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 
 		s->rx_packets   += rq_stats->packets + xskrq_stats->packets;
 		s->rx_bytes     += rq_stats->bytes + xskrq_stats->bytes;
+		s->multicast    += rq_stats->mcast_packets + xskrq_stats->mcast_packets;
 
 		for (j = 0; j < priv->max_opened_tc; j++) {
 			struct mlx5e_sq_stats *sq_stats = &channel_stats->sq[j];
@@ -3573,7 +3574,6 @@ void
 mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct mlx5e_vport_stats *vstats = &priv->stats.vport;
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
 	/* In switchdev mode, monitor counters doesn't monitor
@@ -3608,12 +3608,6 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
 			   stats->rx_frame_errors;
 	stats->tx_errors = stats->tx_aborted_errors + stats->tx_carrier_errors;
-
-	/* vport multicast also counts packets that are dropped due to steering
-	 * or rx out of buffer
-	 */
-	stats->multicast =
-		VPORT_COUNTER_GET(vstats, received_eth_multicast.packets);
 }
 
 static void mlx5e_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index dbb1c6323967..ce023f1c45d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -50,6 +50,7 @@
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
 #include "en/health.h"
+#include "en/txrx.h"
 
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -1020,6 +1021,11 @@ static inline void mlx5e_build_rx_skb(struct mlx5_cqe64 *cqe,
 		mlx5e_enable_ecn(rq, skb);
 
 	skb->protocol = eth_type_trans(skb, netdev);
+
+	if (unlikely(mlx5e_skb_is_multicast(skb))) {
+		stats->mcast_packets++;
+		stats->mcast_bytes += cqe_bcnt;
+	}
 }
 
 static inline void mlx5e_complete_rx_cqe(struct mlx5e_rq *rq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index f009fe09e99b..f028971016d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -114,6 +114,8 @@ static const struct counter_desc sw_stats_desc[] = {
 
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_mcast_packets) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_mcast_bytes) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_ecn_mark) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_removed_vlan_packets) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_csum_unnecessary) },
@@ -243,6 +245,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 		s->rx_bytes	+= rq_stats->bytes;
 		s->rx_lro_packets += rq_stats->lro_packets;
 		s->rx_lro_bytes	+= rq_stats->lro_bytes;
+		s->rx_mcast_packets += rq_stats->mcast_packets;
+		s->rx_mcast_bytes += rq_stats->mcast_bytes;
 		s->rx_ecn_mark	+= rq_stats->ecn_mark;
 		s->rx_removed_vlan_packets += rq_stats->removed_vlan_packets;
 		s->rx_csum_none	+= rq_stats->csum_none;
@@ -1458,6 +1462,8 @@ static const struct counter_desc rq_stats_desc[] = {
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, xdp_redirect) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, lro_bytes) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, mcast_packets) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, mcast_bytes) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, ecn_mark) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, removed_vlan_packets) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, wqe_err) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 2b83ba990714..86af203f5b05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -119,6 +119,8 @@ struct mlx5e_sw_stats {
 	u64 tx_nop;
 	u64 rx_lro_packets;
 	u64 rx_lro_bytes;
+	u64 rx_mcast_packets;
+	u64 rx_mcast_bytes;
 	u64 rx_ecn_mark;
 	u64 rx_removed_vlan_packets;
 	u64 rx_csum_unnecessary;
@@ -286,6 +288,8 @@ struct mlx5e_rq_stats {
 	u64 csum_none;
 	u64 lro_packets;
 	u64 lro_bytes;
+	u64 mcast_packets;
+	u64 mcast_bytes;
 	u64 ecn_mark;
 	u64 removed_vlan_packets;
 	u64 xdp_drop;
-- 
2.26.2

