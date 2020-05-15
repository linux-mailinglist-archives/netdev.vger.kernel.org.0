Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8591D5C89
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgEOWtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:46 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Id6k6oaeZ1aqL+BWt8fMvsCwYQcMb3aqp/BcTd1zWycvK5GjbLj2K0IZ6dMuhyZOsTNVny5xjkp/JBpO2V613IvAELA2rTVUwxeNcZ4byRpmdUHGxhVdKw0w9vaKasWGaKqXXdQqCfhWjgSt6rMq5LFeFoAfIM/gWOQYNM/LN0seaAyq4lYzJ0zdo3v+xLTbW/caCKhqFLJa5/VxLpAWPQjCMltL5cx7MFD7epZes+9R4HgIY5rZNkfGlbqqWKaRy4KLPL1a9aLYt+7AAcHomBeF4zDdbyynqUp1OvnD5JmpYS7rcdkpwR1Eayc4dxMw88Pb9wy55xZ6mAuRP6rLMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnbAHzxfdFgkt53zq19BhIUmc0gyvp3Cm2A03egyjx0=;
 b=cDW2Ro6jdFsAMvru6/QTv5gCJ1Hz6wzw6aw+0bNs7PrymChyi3XBZTL1eY61vFmuUrabJThAjBeFyQbt4hWlU/OPcok5VS1knqo6P7Xd1z2i03jTIx6Ro/wVJF+JAHmZb8xUljZQoMdSkwWl33JBmkHSbBWBz1TNQkXQVL24f7WHc7/aAxANnS1JKyk1hKrmAYst9gx3Wlwf9yy6m9pefEDQ0ce2UtwA/uInnr2rMsPLiG/Iwp/7uBdC4eb2r7KSxye3sJC3LeKKJnlJ1hWx969LRJhTOIU3XrjQljDs6n8pkTzpdkDO7T40OXUgkjA45rIMa0r+nrI0Q91zHbcnHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnbAHzxfdFgkt53zq19BhIUmc0gyvp3Cm2A03egyjx0=;
 b=A2axjYh9aRJaj3KcK06PmZHbxiwL7fZCT0pmTMSupLXWdfrQhz7Z4nBLw7eICkEplLeXnT9bfzFhExSPLo8exNpr/Azg6iKQePTIygo/WYMIQeJLLwoRY74Ed9aSWyCZe8gE058jyKFIfva+VvGqp+f3jGOfEkh1ySeqsDOwaWk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 08/11] net/mlx5e: IPoIB, Enable loopback packets for IPoIB interfaces
Date:   Fri, 15 May 2020 15:48:51 -0700
Message-Id: <20200515224854.20390-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:34 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: de8f4564-662f-4429-99ca-08d7f9223dd0
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200FD2A271A5FB8BCB9B8D0BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:140;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t3kZafa6znjs3Z/V2MPkpZk6IIX+aiG7cjaLM2aIV2RChFVChXNBc1sKRyZRjQ3H3JtpOB/ehNFyy051OGYxWGfQF2xBmkjEOCpPKHL8QXTDQgM0pOFSbzGrzrDIDf+5SlieoncEvMXBZbIA/nneD1EcIB6nHaYurtX0iK3FZnWHQQ2rfZcGPNLDbNFCOBZiKpiuuleE2kXAUyr9AUuhEEbgmZjPTTNZqqrQM/oppalb2iJ4GUZARTtjUrFet4U6/5SUj3GELZI2Q+SBoGkUt+3HiDzV+q6ZBCg015vq1SO90aVitKoKAX/xS+4rZeSDh3yYJuDvHHdFZNtZyQcFiNKZPrihUwhbRknzhCGoVSsOA/aY8OZ/sqmbcjXZvWuiEv+jIhlMz8nDIBTH7YS+43lT3vYeW+Jx4QmR+oh9+MUq4wDNt3l2fnS7EPHNpZYLumSwYv1fba83QAPDce4w7R6H3KkENh/kUgIutvT88RdVUZrHs0yRBgks9u1a2v7B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XtyFGvOE65Hx2ys0/PJy8S9zY544XkMyst5XEFIIWFrUNez9uvgvB9TBC7fZLzZsuohmD72DyD/E9q1lXldy17dol0ZV89pPnz7Rybw+npXjSWpFMIkrbiq/0TGOv02lpRapmup3xSbQaRBkTKAiEgnFtsDre5c0P9Oy2mwEXYHG/1LgDEmyraWVNeq79X/7G0rOzNZauxEHUMhIuZb3qXUVkWexu9lDeaxAwlZ44FxBSsy7b1S3cr2Neywv9G3DQulbsXDWvBmk30hBCK+/BVp5B/LYsDT/gyEVU/ng+9C/3qRBx/ZTr14SJJG/kSU6twGLG+pR9NLOoX53ovElIJ7DQl4JGsm5+c6FuKohUyM2WbFmp/Yk1K1BKoX5Z/e9U2uOl55E+ZLxUMFgTk5wJWIeqV0yd0FiHqPtWGX9Vgc8pNTX9qOk/sVIOBlcQdYg6WVOe8eQzeWc38l5Yo6RkGhUA2YYao8aDOy8Jw98MlQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de8f4564-662f-4429-99ca-08d7f9223dd0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:36.0368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsrUjU8x9rEaOqD1SwTfAP5Wu2pRtrdL07qwYkMUp10bgxjNjD/0Fj2jvIlhAfVb+PPIJ+vSxt+1mAyWBzE4Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

Enable loopback of unicast and multicast traffic for IPoIB enhanced
mode.
This will allow interfaces with the same pkey to communicate between
them e.g cloned interfaces that located in different namespaces.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h        |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 13 ++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c   |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c   |  7 ++++++-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h   |  2 ++
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c  |  2 +-
 7 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 195162b9b245..ac385ac93fe5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1082,7 +1082,8 @@ void mlx5e_destroy_tir(struct mlx5_core_dev *mdev,
 		       struct mlx5e_tir *tir);
 int mlx5e_create_mdev_resources(struct mlx5_core_dev *mdev);
 void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev);
-int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb);
+int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
+		       bool enable_mc_lb);
 
 /* common netdev helpers */
 void mlx5e_create_q_counters(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
index af3228b3f303..1e42c7ae621b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_common.c
@@ -141,10 +141,12 @@ void mlx5e_destroy_mdev_resources(struct mlx5_core_dev *mdev)
 	memset(res, 0, sizeof(*res));
 }
 
-int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb)
+int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb,
+		       bool enable_mc_lb)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_tir *tir;
+	u8 lb_flags = 0;
 	int err  = 0;
 	u32 tirn = 0;
 	int inlen;
@@ -158,8 +160,13 @@ int mlx5e_refresh_tirs(struct mlx5e_priv *priv, bool enable_uc_lb)
 	}
 
 	if (enable_uc_lb)
-		MLX5_SET(modify_tir_in, in, ctx.self_lb_block,
-			 MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST);
+		lb_flags = MLX5_TIRC_SELF_LB_BLOCK_BLOCK_UNICAST;
+
+	if (enable_mc_lb)
+		lb_flags |= MLX5_TIRC_SELF_LB_BLOCK_BLOCK_MULTICAST;
+
+	if (lb_flags)
+		MLX5_SET(modify_tir_in, in, ctx.self_lb_block, lb_flags);
 
 	MLX5_SET(modify_tir_in, in, bitmask.self_lb_en, 1);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0e4ca08ddca9..65e2b364443e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5275,7 +5275,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 
 int mlx5e_update_nic_rx(struct mlx5e_priv *priv)
 {
-	return mlx5e_refresh_tirs(priv, false);
+	return mlx5e_refresh_tirs(priv, false, false);
 }
 
 static const struct mlx5e_profile mlx5e_nic_profile = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index bbff8d8ded76..46790216ce86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -234,7 +234,7 @@ static int mlx5e_test_loopback_setup(struct mlx5e_priv *priv,
 			return err;
 	}
 
-	err = mlx5e_refresh_tirs(priv, true);
+	err = mlx5e_refresh_tirs(priv, true, false);
 	if (err)
 		goto out;
 
@@ -263,7 +263,7 @@ static void mlx5e_test_loopback_cleanup(struct mlx5e_priv *priv,
 		mlx5_nic_vport_update_local_lb(priv->mdev, false);
 
 	dev_remove_pack(&lbtp->pt);
-	mlx5e_refresh_tirs(priv, false);
+	mlx5e_refresh_tirs(priv, false, false);
 }
 
 #define MLX5E_LB_VERIFY_TIMEOUT (msecs_to_jiffies(200))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 035bd21e5d4e..7db70b6ccc07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -262,6 +262,11 @@ void mlx5i_destroy_underlay_qp(struct mlx5_core_dev *mdev, u32 qpn)
 	mlx5_cmd_exec_in(mdev, destroy_qp, in);
 }
 
+int mlx5i_update_nic_rx(struct mlx5e_priv *priv)
+{
+	return mlx5e_refresh_tirs(priv, true, true);
+}
+
 int mlx5i_create_tis(struct mlx5_core_dev *mdev, u32 underlay_qpn, u32 *tisn)
 {
 	u32 in[MLX5_ST_SZ_DW(create_tis_in)] = {};
@@ -456,7 +461,7 @@ static const struct mlx5e_profile mlx5i_nic_profile = {
 	.cleanup_rx	   = mlx5i_cleanup_rx,
 	.enable		   = NULL, /* mlx5i_enable */
 	.disable	   = NULL, /* mlx5i_disable */
-	.update_rx	   = mlx5e_update_nic_rx,
+	.update_rx	   = mlx5i_update_nic_rx,
 	.update_stats	   = NULL, /* mlx5i_update_stats */
 	.update_carrier    = NULL, /* no HW update in IB link */
 	.rx_handlers.handle_rx_cqe       = mlx5i_handle_rx_cqe,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index c4aa47018c0e..79071a15c4ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -92,6 +92,8 @@ int mlx5i_init(struct mlx5_core_dev *mdev,
 	       void *ppriv);
 void mlx5i_cleanup(struct mlx5e_priv *priv);
 
+int mlx5i_update_nic_rx(struct mlx5e_priv *priv);
+
 /* Get child interface nic profile */
 const struct mlx5e_profile *mlx5i_pkey_get_profile(void);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
index b9af37ad40bf..f70367018862 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c
@@ -347,7 +347,7 @@ static const struct mlx5e_profile mlx5i_pkey_nic_profile = {
 	.cleanup_rx	   = mlx5i_pkey_cleanup_rx,
 	.enable		   = NULL,
 	.disable	   = NULL,
-	.update_rx	   = mlx5e_update_nic_rx,
+	.update_rx	   = mlx5i_update_nic_rx,
 	.update_stats	   = NULL,
 	.rx_handlers.handle_rx_cqe       = mlx5i_handle_rx_cqe,
 	.rx_handlers.handle_rx_cqe_mpwqe = NULL, /* Not supported */
-- 
2.25.4

