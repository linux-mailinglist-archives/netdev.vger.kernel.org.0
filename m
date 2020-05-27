Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E4C1E49C7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390916AbgE0QW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:22:27 -0400
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:63749
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390905AbgE0QWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 12:22:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ePfRQeMxz/gkrkrha0uMzpYwLuelHdhCU+dLUFF2JZvdnTgYtGwjzqMviaf4CNz4+hPaSkyRp2m+MCBDyzpHTTuw73xyBBLYwLQIhkb2FkLtdnuHXHIKOjXmr9z9If8kSJj5evnDomwbh+V+eTrkGSTqhVJ0DIBsolzMp48eB9cb8jX9qIctr2NvPSX9joJH+vuotPjbR6dYTku1yZMNqVuEt9Tpu2cPDZmvrclwpAhxVQrD2m7hAP/d6LWUOPf4ChyKDqIEXga3cYjshuY6fyFjG/+akfV/LfFwJhSs9uSNPzcc1mFiPCEvD1sIstiyLrMBwu0A3yWlgn5chFXRHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCS+e6zSVf0S/nC0SMw6yf3BHzTxt2QJNHlXtqU2br4=;
 b=PBl0NYu/wgPc16qLJrVcq3hz/mdx/3knGlMEuFAxCZDQk9LD39iF6eMeg3Tmbqn9is+SUHUvOs4fcPy3PQ3oFBwvAQL5/9cEgjHPHsStDcC8DLOeYPegv5k10vayKU5V6D6kx+t0iarqdAQe8n6GNMQaYH6zwi4Aas6uXQTsrtmDl5VunhyhVE9loVBVZAUKW6wAaGJnoP4xk2ahfTBfx6/y8q653kRmsbwweHEz3/AvM29pA4YyE3Nn5VHmY75fGZxUbF3Okx9uCviR49WGSZNSJey2lrp+6vcAVJo2GUqr9gtrgxmBxpJ9UYnTwpIbCyPTWS+2zzlGC5fAWLAGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCS+e6zSVf0S/nC0SMw6yf3BHzTxt2QJNHlXtqU2br4=;
 b=kxkx/uuMZkdeyhG1u9kV/cNrTkVS7cJYiRc5KoQZAlneJT204UiRWrysl+88jW0iDjv+Pg8S3B9+cr2xDTr7UHVgdKOeWktXspJeNMhJSouX5js5NpIjz56Bb2VCJ8+veEBd8sfYnEEIqnacqTRgtMmz3BOE+gqVlGMrK281bRs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7039.eurprd05.prod.outlook.com (2603:10a6:800:186::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 16:22:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 16:22:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 11/15] net/mlx5: Add missing mutex destroy
Date:   Wed, 27 May 2020 09:21:35 -0700
Message-Id: <20200527162139.333643-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527162139.333643-1-saeedm@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0071.namprd02.prod.outlook.com
 (2603:10b6:a03:54::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0071.namprd02.prod.outlook.com (2603:10b6:a03:54::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Wed, 27 May 2020 16:22:20 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba2686ea-d636-425c-44ff-08d8025a2276
X-MS-TrafficTypeDiagnostic: VI1PR05MB7039:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB70393453BDC4161A0FC24087BEB10@VI1PR05MB7039.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fo1jcHq82p/proGNZmHrPYT8cYZ7cMFgoLsuoTPsxVvFyhYE3FcldCen98N+BL+irIJClgc0e98E7TH6nUlMXvood9UhsFt7juy+jkp7V+7Y7CYeswXHu9qWxD2CWLkcharRxwoIawiM0o4LLWg0DAKLDkIhGePyUeFq9Y9EGZSc7/SrEeCrtlDjJ4hQOwjG1NSvRAq2/d92x8h0qYKeR/dId/tZ/YVAOu8KZD1zuD34aTZTlj2dVuimlGB+Z6dxZwqNxX1eGR5wg23P4lhanDOJ8A27dKJQWm4Zjvl2LQ3xWFa78KVVQ3wbcges7Rdg7Qagl1vhYpDBeSZH05KdmUks6vnx7Cd0hR0Z2KZdz70OtTQqDQ5lFbwXttply0U
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(956004)(36756003)(6486002)(54906003)(478600001)(107886003)(6512007)(86362001)(83380400001)(316002)(5660300002)(26005)(16526019)(6506007)(66476007)(66946007)(66556008)(186003)(52116002)(1076003)(2616005)(4326008)(6666004)(2906002)(8676002)(8936002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Aojo9AxS9KG2HF6XKyNR7pwwuymv0njBZP/Nr22kfCtX2vdkkzXwuXa/Qzpwxk0jWMyBJVxrQJgMZ4ns+CY124tRWTa5OlopiBNkF3yVSRiQTvc363wwbGVFbcH8X0QsycuZGmy/wC5yDF+0hO+YrSAOuMQSaY4m1D2MMIZqUnFFBItcb5lymKRnhLgf2cPU+vXc349j3eRy5YgwELlUuvkGt/LQDUsZs530weVNx4ELPwUpIYkcyY6uR0DJ4XDY4u30xhrSUER8Sj8bgGe8bBngoE4T3JYoJss5VI68HlH2CZdI/JtpErXGYYl/jvehihSiVsKg0+AKJEBKDhGFHW6kzWZnuc9/EI9AhcbVkf6evLxFAHSpEnAoYvGmyjbzlvEP5jW7jLswW1OMYsoKbC6SnfjLYXt6EXOtR0605cptHtouYiQjLEw4yyzJlpy0xEecl5JNzUcphH5mXmddgmL4sj24vDueM19HkFp3Qlg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2686ea-d636-425c-44ff-08d8025a2276
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 16:22:22.3532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l005+0BxJ/WFMzJwUj2eM8wShg97I5QD7pTs3rBXSmiqz7iREeswHci2Eya5EqhzWRObc8vn5Hy+dLaVS/IaZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7039
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Add mutex destroy calls to balance with mutex_init() done in the init
path.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 92f2395dd31a..30de3bf35c6d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1272,7 +1272,7 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 					    mlx5_debugfs_root);
 	if (!priv->dbg_root) {
 		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
-		return -ENOMEM;
+		goto err_dbg_root;
 	}
 
 	err = mlx5_health_init(dev);
@@ -1289,15 +1289,27 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mlx5_health_cleanup(dev);
 err_health_init:
 	debugfs_remove(dev->priv.dbg_root);
-
+err_dbg_root:
+	mutex_destroy(&priv->pgdir_mutex);
+	mutex_destroy(&priv->alloc_mutex);
+	mutex_destroy(&priv->bfregs.wc_head.lock);
+	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->intf_state_mutex);
 	return err;
 }
 
 static void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 {
+	struct mlx5_priv *priv = &dev->priv;
+
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg_root);
+	mutex_destroy(&priv->pgdir_mutex);
+	mutex_destroy(&priv->alloc_mutex);
+	mutex_destroy(&priv->bfregs.wc_head.lock);
+	mutex_destroy(&priv->bfregs.reg_head.lock);
+	mutex_destroy(&dev->intf_state_mutex);
 }
 
 #define MLX5_IB_MOD "mlx5_ib"
-- 
2.26.2

