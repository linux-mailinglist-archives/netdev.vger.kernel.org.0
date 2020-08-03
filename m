Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC2523AE5A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 22:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgHCUni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 16:43:38 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:25987
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgHCUnf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 16:43:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcChAzQpgDfXR5r+TOQTSEMYRbMfz9BRtYvB/1VL7dN36HE/tuCW+dngXbpYdZIcc/sjKf+wCcVO2r/PFQI1QFzFcmKSijosYwLd5EfN5ugofVn89Qu1GfYVTtKtxJMQ4a0LIk+vCL4SXvpZBfthV1EHqUmXtnoPcqAGyXpRB17PY6kI6+Gtwso+gXcg1CFy7sufml25L3ONtqcO0Sq3GN9HpccpAgBNaX/mohc70mKAwb/hkwF/NwaXAue34DX1poh2BOXLzxaRIiCODk1zC5sSs6edCETNBH9c2LAMzMlkuV1WAmY1l6gIJHzbb8XyB7jbkM0zoK6GcxLcGd7H5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2slUHR19lz57zdfRiuGs0OSk4xzxekV84QQCX3yW/dU=;
 b=XntzXaKWhYBZAz/qP9+87NkJp3Eyt5QzZBgA0r/bJBE7dJmk+d1HAnp8GZayj3w5SnCKPiH5g6lnrs7qiU4GH2MirNpPJUtMFVNhSFLK4UUz2HK8IbYEaqGEwL7trG3S2ivGFVC4cOG2RMGHP9xEzp0Yl6TRs1zoNk10tTINF8Qh9fRaM4UcwS4HkZIUMcjC4KNpRbCv89wMH7MqQLhKLU806M7JjfgkiCFlDtwLwF556QIUFfC51sJ99ScesnRCeiGAj5VxyeXoYtitAx42YBbYMKy6nloMJ36BidtEvXRa0LMS5yKcFUV8rshmm5YLEVJOOOY8fKnaTxWJvCDfQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2slUHR19lz57zdfRiuGs0OSk4xzxekV84QQCX3yW/dU=;
 b=HcuiFTqoA25FoLdhWVabDHvNurkguU44QsyF1QrfJswb5Maxwnl1wGUSDOavO0pEOQYOQmWlGAQueho0W/6qH9lMrEDkGrIiFoWid1GRYw0wGdeyKUjBHyU94kGFdrkdgZu9b4p8AL+OOrODzRfKAdpzG049/DZeq11JEJF2f1I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VE1PR05MB7311.eurprd05.prod.outlook.com (2603:10a6:800:1a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Mon, 3 Aug
 2020 20:43:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2dde:902e:3a19:4366%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:43:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 4/5] net/mlx5: convert to new udp_tunnel infrastructure
Date:   Mon,  3 Aug 2020 13:41:50 -0700
Message-Id: <20200803204151.120802-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803204151.120802-1-saeedm@mellanox.com>
References: <20200803204151.120802-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0017.namprd10.prod.outlook.com (2603:10b6:a03:255::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 20:42:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 09f0d1fe-2e0b-4b4c-3902-08d837edcef1
X-MS-TrafficTypeDiagnostic: VE1PR05MB7311:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR05MB73116CF3041F972E1B645D43BE4D0@VE1PR05MB7311.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ioADO4sEqYnHTAu/E30hiq8BZD2bhQKaOrqR674hoZ9g5AB/kdB7v/mRwZPylqmV+9u9wBL67DdSVckfvwPbfp2T3s9zID54IprLzOGztpb1M1X7BRJMtAlYRUhwPdW5NRjg09JXF1AVuxoCbUjP5glaxdo8t8T5PYun0HESaYMhq4u4KUF/l3oP6axROnMiDizNb1TLCcJPF8247pZspC5+htcBirwYJVO9kwqf1teiV6l3vv72CcoYFZsY2TNNv+vHODl7XzbxzdbwzuWKWlFCjYGEFBH3BDrsB0LIT3R13sjqOiZHotQ62EMzbWe7nGz4ZRiN18vAPf6c+gilBr3NxCrLCzxJx+hjVRJcGvvWUTCRPLW3ZzgBNEWzq0cc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(956004)(1076003)(478600001)(110136005)(8936002)(5660300002)(2906002)(6666004)(2616005)(30864003)(86362001)(316002)(16526019)(66946007)(66476007)(66556008)(6486002)(36756003)(6506007)(26005)(8676002)(107886003)(83380400001)(52116002)(6512007)(4326008)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: C2S/aQdjshfHTNGM/4oOfO+El7jnf8ToNNSzv0oJ9al/uSPpFs4gbZfg94sAttHsbNqa2xiyAwZAz5tXBVKNKHwWWR516QR33azMKveBgsn6+rjBOUhRAfbhOYOZhU+YfBx+ARaKApJfUJ+rx01wRQRdEuFY6dZ6nH+9v5MQEWj3msOb/NCZLZILvrTZ+Tw6iMzo4AqeAWGSaCXEI0fdNjTn3XW6Ws/lKNn45xuBUJqjSHj+lC6AXns54yxl5KnjsMg4TLCiTa+9a1NghCMw0bJKrp3w1pV+GvmK5+EO0YBphZWt12Eao0wZU3vbT6d9zbCDb5C3Swl6DMM8S+NH0U4JOb8OJxYPjfQ1DMuw8fdBWZ6rPWAb74P7t+nkoaIo9QgHWPOIMDWgyB4k0QPFLJhe8Offr0dzRlyDF1VQOkDrp768pNpaWO9VKM6bGtX1zkdqh24TIWA4UcWKFKgF1CygjJAEOjtX53JQ80XwIfXVi+4Dtcb05z6I2IB47qLYviP+I3YjbE7Z3kIt/8+KBcTPQqI9vV76aZI3pR2capaGVlPp0/KByzJ5mjv8oR3ZqgoewBR8bR0iIuopzCxmSBTOcv16k9AqmhmH4RLeGkB2TGz0SXFlH7Z9yMzsyi7mQ86d/veobfnQnxyjJppELg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f0d1fe-2e0b-4b4c-3902-08d837edcef1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 20:43:01.0176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P/8oVAy+Qr6gj67uzg918DO+TUbKh5kfZqMYgBTFIPlNknVgQKMyydvVAbbuybQZg8E3BZVHXSp3qtfJ1E/zIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR05MB7311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

Allocate nic_info dynamically - n_entries is not constant.

Attach the tunnel offload info only to the uplink representor.
We expect the "main" netdev to be unregistered in switchdev
mode, and there to be only one uplink representor.

Drop the udp_tunnel_drop_rx_info() call, it was not there until
commit b3c2ed21c0bd ("net/mlx5e: Fix VXLAN configuration restore after function reload")
so the device doesn't need it, and core should handle reloads and
reset just fine.

v2:
 - don't drop the ndos on reprs, and register info on uplink repr.
v4:
 - Move netdev tunnel structure handling to en_main.c

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 121 ++++++------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |   5 +-
 .../ethernet/mellanox/mlx5/core/lib/vxlan.c   |  64 +++------
 .../ethernet/mellanox/mlx5/core/lib/vxlan.h   |   5 +
 5 files changed, 64 insertions(+), 136 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f2fa1307e90cb..0cc2080fd847b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -45,6 +45,7 @@
 #include <linux/mlx5/transobj.h>
 #include <linux/mlx5/fs.h>
 #include <linux/rhashtable.h>
+#include <net/udp_tunnel.h>
 #include <net/switchdev.h>
 #include <net/xdp.h>
 #include <linux/dim.h>
@@ -792,6 +793,7 @@ struct mlx5e_priv {
 	u16                        drop_rq_q_counter;
 	struct notifier_block      events_nb;
 
+	struct udp_tunnel_nic_info nic_info;
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	struct mlx5e_dcbx          dcbx;
 #endif
@@ -1012,6 +1014,7 @@ int mlx5e_set_dev_port_mtu(struct mlx5e_priv *priv);
 int mlx5e_set_dev_port_mtu_ctx(struct mlx5e_priv *priv, void *context);
 int mlx5e_change_mtu(struct net_device *netdev, int new_mtu,
 		     mlx5e_fp_preactivate preactivate);
+void mlx5e_vxlan_set_netdev_info(struct mlx5e_priv *priv);
 
 /* ethtool helpers */
 void mlx5e_ethtool_get_drvinfo(struct mlx5e_priv *priv,
@@ -1080,8 +1083,6 @@ void mlx5e_build_rss_params(struct mlx5e_rss_params *rss_params,
 void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
 
-void mlx5e_add_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti);
-void mlx5e_del_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti);
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 				       struct net_device *netdev,
 				       netdev_features_t features);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 72c91ff554653..8f26cd951ff54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4191,83 +4191,6 @@ int mlx5e_get_vf_stats(struct net_device *dev,
 }
 #endif
 
-struct mlx5e_vxlan_work {
-	struct work_struct	work;
-	struct mlx5e_priv	*priv;
-	u16			port;
-};
-
-static void mlx5e_vxlan_add_work(struct work_struct *work)
-{
-	struct mlx5e_vxlan_work *vxlan_work =
-		container_of(work, struct mlx5e_vxlan_work, work);
-	struct mlx5e_priv *priv = vxlan_work->priv;
-	u16 port = vxlan_work->port;
-
-	mutex_lock(&priv->state_lock);
-	mlx5_vxlan_add_port(priv->mdev->vxlan, port);
-	mutex_unlock(&priv->state_lock);
-
-	kfree(vxlan_work);
-}
-
-static void mlx5e_vxlan_del_work(struct work_struct *work)
-{
-	struct mlx5e_vxlan_work *vxlan_work =
-		container_of(work, struct mlx5e_vxlan_work, work);
-	struct mlx5e_priv *priv         = vxlan_work->priv;
-	u16 port = vxlan_work->port;
-
-	mutex_lock(&priv->state_lock);
-	mlx5_vxlan_del_port(priv->mdev->vxlan, port);
-	mutex_unlock(&priv->state_lock);
-	kfree(vxlan_work);
-}
-
-static void mlx5e_vxlan_queue_work(struct mlx5e_priv *priv, u16 port, int add)
-{
-	struct mlx5e_vxlan_work *vxlan_work;
-
-	vxlan_work = kmalloc(sizeof(*vxlan_work), GFP_ATOMIC);
-	if (!vxlan_work)
-		return;
-
-	if (add)
-		INIT_WORK(&vxlan_work->work, mlx5e_vxlan_add_work);
-	else
-		INIT_WORK(&vxlan_work->work, mlx5e_vxlan_del_work);
-
-	vxlan_work->priv = priv;
-	vxlan_work->port = port;
-	queue_work(priv->wq, &vxlan_work->work);
-}
-
-void mlx5e_add_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (!mlx5_vxlan_allowed(priv->mdev->vxlan))
-		return;
-
-	mlx5e_vxlan_queue_work(priv, be16_to_cpu(ti->port), 1);
-}
-
-void mlx5e_del_vxlan_port(struct net_device *netdev, struct udp_tunnel_info *ti)
-{
-	struct mlx5e_priv *priv = netdev_priv(netdev);
-
-	if (ti->type != UDP_TUNNEL_TYPE_VXLAN)
-		return;
-
-	if (!mlx5_vxlan_allowed(priv->mdev->vxlan))
-		return;
-
-	mlx5e_vxlan_queue_work(priv, be16_to_cpu(ti->port), 0);
-}
-
 static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 						     struct sk_buff *skb,
 						     netdev_features_t features)
@@ -4597,8 +4520,8 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_change_mtu          = mlx5e_change_nic_mtu,
 	.ndo_do_ioctl            = mlx5e_ioctl,
 	.ndo_set_tx_maxrate      = mlx5e_set_tx_maxrate,
-	.ndo_udp_tunnel_add      = mlx5e_add_vxlan_port,
-	.ndo_udp_tunnel_del      = mlx5e_del_vxlan_port,
+	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
 	.ndo_bpf		 = mlx5e_xdp,
@@ -4869,6 +4792,39 @@ static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
 	}
 }
 
+static int mlx5e_vxlan_set_port(struct net_device *netdev, unsigned int table,
+				unsigned int entry, struct udp_tunnel_info *ti)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	return mlx5_vxlan_add_port(priv->mdev->vxlan, ntohs(ti->port));
+}
+
+static int mlx5e_vxlan_unset_port(struct net_device *netdev, unsigned int table,
+				  unsigned int entry, struct udp_tunnel_info *ti)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+
+	return mlx5_vxlan_del_port(priv->mdev->vxlan, ntohs(ti->port));
+}
+
+void mlx5e_vxlan_set_netdev_info(struct mlx5e_priv *priv)
+{
+	if (!mlx5_vxlan_allowed(priv->mdev->vxlan))
+		return;
+
+	priv->nic_info.set_port = mlx5e_vxlan_set_port;
+	priv->nic_info.unset_port = mlx5e_vxlan_unset_port;
+	priv->nic_info.flags = UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
+				UDP_TUNNEL_NIC_INFO_STATIC_IANA_VXLAN;
+	priv->nic_info.tables[0].tunnel_types = UDP_TUNNEL_TYPE_VXLAN;
+	/* Don't count the space hard-coded to the IANA port */
+	priv->nic_info.tables[0].n_entries =
+		mlx5_vxlan_max_udp_ports(priv->mdev) - 1;
+
+	priv->netdev->udp_tunnel_nic_info = &priv->nic_info;
+}
+
 static void mlx5e_build_nic_netdev(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -4912,6 +4868,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
 
+	mlx5e_vxlan_set_netdev_info(priv);
+
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev) ||
 	    mlx5e_any_tunnel_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
@@ -5217,8 +5175,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_get_rx_info(netdev);
+	udp_tunnel_nic_reset_ntf(priv->netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -5233,8 +5190,6 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(priv->netdev))
 		mlx5e_close(priv->netdev);
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_drop_rx_info(priv->netdev);
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3db81a8cfc1d0..e13e5d1b3eaed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -658,8 +658,8 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
 	.ndo_change_mtu          = mlx5e_uplink_rep_change_mtu,
-	.ndo_udp_tunnel_add      = mlx5e_add_vxlan_port,
-	.ndo_udp_tunnel_del      = mlx5e_del_vxlan_port,
+	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
+	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_set_vf_mac          = mlx5e_set_vf_mac,
 	.ndo_set_vf_rate         = mlx5e_set_vf_rate,
@@ -730,6 +730,7 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev)
 		/* we want a persistent mac for the uplink rep */
 		mlx5_query_mac_address(mdev, netdev->dev_addr);
 		netdev->ethtool_ops = &mlx5e_uplink_rep_ethtool_ops;
+		mlx5e_vxlan_set_netdev_info(priv);
 		mlx5e_dcbnl_build_rep_netdev(netdev);
 	} else {
 		netdev->netdev_ops = &mlx5e_netdev_ops_rep;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index be34330d89cc4..3315afe2f8dce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -42,21 +42,14 @@ struct mlx5_vxlan {
 	struct mlx5_core_dev		*mdev;
 	/* max_num_ports is usuallly 4, 16 buckets is more than enough */
 	DECLARE_HASHTABLE(htable, 4);
-	int				num_ports;
 	struct mutex                    sync_lock; /* sync add/del port HW operations */
 };
 
 struct mlx5_vxlan_port {
 	struct hlist_node hlist;
-	refcount_t refcount;
 	u16 udp_port;
 };
 
-static inline u8 mlx5_vxlan_max_udp_ports(struct mlx5_core_dev *mdev)
-{
-	return MLX5_CAP_ETH(mdev, max_vxlan_udp_ports) ?: 4;
-}
-
 static int mlx5_vxlan_core_add_port_cmd(struct mlx5_core_dev *mdev, u16 port)
 {
 	u32 in[MLX5_ST_SZ_DW(add_vxlan_udp_dport_in)] = {};
@@ -109,48 +102,24 @@ static struct mlx5_vxlan_port *vxlan_lookup_port(struct mlx5_vxlan *vxlan, u16 p
 int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 port)
 {
 	struct mlx5_vxlan_port *vxlanp;
-	int ret = 0;
-
-	mutex_lock(&vxlan->sync_lock);
-	vxlanp = vxlan_lookup_port(vxlan, port);
-	if (vxlanp) {
-		refcount_inc(&vxlanp->refcount);
-		goto unlock;
-	}
+	int ret;
 
-	if (vxlan->num_ports >= mlx5_vxlan_max_udp_ports(vxlan->mdev)) {
-		mlx5_core_info(vxlan->mdev,
-			       "UDP port (%d) not offloaded, max number of UDP ports (%d) are already offloaded\n",
-			       port, mlx5_vxlan_max_udp_ports(vxlan->mdev));
-		ret = -ENOSPC;
-		goto unlock;
-	}
+	vxlanp = kzalloc(sizeof(*vxlanp), GFP_KERNEL);
+	if (!vxlanp)
+		return -ENOMEM;
+	vxlanp->udp_port = port;
 
 	ret = mlx5_vxlan_core_add_port_cmd(vxlan->mdev, port);
-	if (ret)
-		goto unlock;
-
-	vxlanp = kzalloc(sizeof(*vxlanp), GFP_KERNEL);
-	if (!vxlanp) {
-		ret = -ENOMEM;
-		goto err_delete_port;
+	if (ret) {
+		kfree(vxlanp);
+		return ret;
 	}
 
-	vxlanp->udp_port = port;
-	refcount_set(&vxlanp->refcount, 1);
-
+	mutex_lock(&vxlan->sync_lock);
 	hash_add_rcu(vxlan->htable, &vxlanp->hlist, port);
-
-	vxlan->num_ports++;
 	mutex_unlock(&vxlan->sync_lock);
-	return 0;
-
-err_delete_port:
-	mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
 
-unlock:
-	mutex_unlock(&vxlan->sync_lock);
-	return ret;
+	return 0;
 }
 
 int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
@@ -161,18 +130,15 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 port)
 	mutex_lock(&vxlan->sync_lock);
 
 	vxlanp = vxlan_lookup_port(vxlan, port);
-	if (!vxlanp) {
+	if (WARN_ON(!vxlanp)) {
 		ret = -ENOENT;
 		goto out_unlock;
 	}
 
-	if (refcount_dec_and_test(&vxlanp->refcount)) {
-		hash_del_rcu(&vxlanp->hlist);
-		synchronize_rcu();
-		mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
-		kfree(vxlanp);
-		vxlan->num_ports--;
-	}
+	hash_del_rcu(&vxlanp->hlist);
+	synchronize_rcu();
+	mlx5_vxlan_core_del_port_cmd(vxlan->mdev, port);
+	kfree(vxlanp);
 
 out_unlock:
 	mutex_unlock(&vxlan->sync_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
index 6d599f4a8acdf..ec766529f49b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.h
@@ -37,6 +37,11 @@
 struct mlx5_vxlan;
 struct mlx5_vxlan_port;
 
+static inline u8 mlx5_vxlan_max_udp_ports(struct mlx5_core_dev *mdev)
+{
+	return MLX5_CAP_ETH(mdev, max_vxlan_udp_ports) ?: 4;
+}
+
 static inline bool mlx5_vxlan_allowed(struct mlx5_vxlan *vxlan)
 {
 	/* not allowed reason is encoded in vxlan pointer as error,
-- 
2.26.2

