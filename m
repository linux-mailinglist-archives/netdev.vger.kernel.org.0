Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20821AD1A
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 04:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgGJCbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 22:31:12 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:54404
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726446AbgGJCbK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 22:31:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+rc3AopCQK1k/koYg6uwRIdTkkaSnmDe0NwWJo+/EHtP3naFeMgur2TbxhkdT14qCR+Cs5ciOcd8T7qepG/618AGAAFJvl43IaHsFx9Amawu4CgFQ/tYNRdZ53mfCUx7z5bxB4/HdbIh7tzCDotzMF4PPyl3YBktRhJA7K5ji5g+kHoW/lw/9EjGh+Gcl8H1IYqlHK/FAfiWODIs2HFl7vgtwaqfJtoB+lMAM+SVcdDpm4cAGtzOrltTs3UDIVXM40WDD4TvQApB3tkmej8VhiVnKmDyuW1RfaTdp8K8dKVzVcsilk3UEn9U56txydkQ29hieDvJBNgxHmRSX8g2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uFV4Utb690VVP8chwKDnKTpYTQov7O4yxwQ8KAYRl4=;
 b=NOhAiP8e/Ga1k7qdWkTbgggfgTORDvlt57LVdW2WP+XSAvn40GEDJnLrC/P8Gn26y/BWoS9LcNH2o/bsBkCy9X2ThPPlZXsnCGHiN8bTHu/+ss/ZKpEQqSZ50Gf1AkS8Ux2r4MnpkmQY2yXhmaOuK/EBGbMLWYoEPmhnEVJXursamn+fqsqgJLy9kGqwP2M3SxnEx/xKk5K6cx96TSJUFdVt2K+k/0VNt5Vn0EW/rDMs86hh3yt4iW8kSJDkp9cofkX8C3lnWmlzt2ySOtdcjDrnu36EjynN0QORsmYRVLaqpVxeSXM/nPGkK6aLeAw7FHfYuROxtIDWg/QyU5QPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uFV4Utb690VVP8chwKDnKTpYTQov7O4yxwQ8KAYRl4=;
 b=nnOyuGx17hT07ZgC+6cQwcP4zxAvjoz1UbAh0W2bEabuiJcoPq/BM/n0oho16iObf5HT9bbmGyPvsmNGVAfFDS2ZFpuguvJeGuB2T911fRQAxpAZTVLF4zm437OkDgjS1l+gpohdfrwxwS8Z2c18QnYEjmr6ergquQ69xD7fxtg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7120.eurprd05.prod.outlook.com (2603:10a6:800:185::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 10 Jul
 2020 02:30:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.022; Fri, 10 Jul 2020
 02:30:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 5/9] net/mlx5e: Fix VXLAN configuration restore after function reload
Date:   Thu,  9 Jul 2020 19:30:14 -0700
Message-Id: <20200710023018.31905-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710023018.31905-1-saeedm@mellanox.com>
References: <20200710023018.31905-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0064.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::41) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0064.namprd06.prod.outlook.com (2603:10b6:a03:14b::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 02:30:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0bee506-8e2f-47f2-410b-08d824794812
X-MS-TrafficTypeDiagnostic: VI1PR05MB7120:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB712010ABED6D8BA0A359691CBE650@VI1PR05MB7120.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VV1Em3SAZT+bFC5mhNFuqj0Q3kpqsYqItIoOQJi0cA3aqda+b0InZ27q3pTetu5yei4ov5lGeDrUQs9WZHD5UuogTVQA2ixkSoFxEn2qvwYgGwOxMHXadtP/RvfjI1s9pqLlv5HyYCttJXyX1kkKLIow1Dau4t4Mg9VTNTOKVz7oveT1Rr0Q5dgltvK+0EGbWHMnGLxEo/MVVYvgtApAcSJajwDHPP9abQFT9pHskK0JjppsBAb8OX3mxN3gErC28H5ThfffIYp/2xIrGdTMBDq/J+F4msO1qlrTX4SjkxgE5K/GFCsUo6O7Bv7O9p3rYeiZhG6potnRCX8+g1V2qweHJslyuijVhYerYfKLQ+1QYrn9rJ7F+OF3ExU4X1s4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(478600001)(26005)(4326008)(86362001)(52116002)(83380400001)(956004)(2906002)(186003)(16526019)(6506007)(2616005)(6666004)(5660300002)(8676002)(8936002)(66946007)(107886003)(66556008)(316002)(66476007)(1076003)(6512007)(110136005)(36756003)(6486002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3ArVy/+HYcJwc9hT/Xgdy+SqRz3Pjo0VlxqXhPSQH8JJaQIQDq7BwNnHnN/dijZp5UVmSLCkaM70ybYDM9UnmNlwL0+M8ojO0oaiG+nCAbxMoyZoA49ONoABz4qXFZ7n6tEHRgMSrcJU+8ckPae6tYHXSl41zyZrqd9qckGlAsOkK1B0udXSZrffZIguB+6XcbFIHkrg4vtgzM8eveZ5sG+C6IFn/UMYLxEUYyf7AkKlycPa9SgeuEdr4zMc/vliSBKXtXdQsXg6RyozdtH2VEL8TMe92P+lunNPgtvx9950rYRgW4evAXfuIU1lK8gN3SCrthFwbbVr2Hm1rcTXHoSLK3dE4Dr6CsX7UBXDpNgIu6Vv5iNVemNaGNZvIYOa3SoXstMmhlwv3BKUOY93QBiQO5biYgHLE+c7XCSyGyi25Qc66Rm0ZPcRUfilj9cZF1KcZO3p5SeX9D65eTxXN7buSzgUatyZseDbVk7FzhY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bee506-8e2f-47f2-410b-08d824794812
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 02:30:59.3702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aD3noteN3zLDsTh4cq6iRsSGiHwF2NC6v1B/NRvif5yPoPSrHy5gkIjW0PzLskN/uZRE2sHGTeBgqmH5yDOVtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When detaching netdev, remove vxlan port configuration using
udp_tunnel_drop_rx_info. During function reload, configuration will be
restored using udp_tunnel_get_rx_info. This ensures sync between
firmware and driver. Use udp_tunnel_get_rx_info even if its physical
interface is down.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a836a02a2116..888e38b21c3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3104,9 +3104,6 @@ int mlx5e_open(struct net_device *netdev)
 		mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_UP);
 	mutex_unlock(&priv->state_lock);
 
-	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
-		udp_tunnel_get_rx_info(netdev);
-
 	return err;
 }
 
@@ -5202,6 +5199,8 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(netdev))
 		mlx5e_open(netdev);
+	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
+		udp_tunnel_get_rx_info(netdev);
 	netif_device_attach(netdev);
 	rtnl_unlock();
 }
@@ -5216,6 +5215,8 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	rtnl_lock();
 	if (netif_running(priv->netdev))
 		mlx5e_close(priv->netdev);
+	if (mlx5_vxlan_allowed(priv->mdev->vxlan))
+		udp_tunnel_drop_rx_info(priv->netdev);
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
-- 
2.26.2

