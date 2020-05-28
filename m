Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658521E52CF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgE1BSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:18:52 -0400
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:32229
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726519AbgE1BSt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:18:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgdSlw5j43c+sOZAuXam6v9hU5b/XHPJGychSpfGc3lc72E1RfvlZQrACkrjGMdeQsD95DfrVrWlJQ+L77K5wmNtsn+3XN8ios/G84wB9sON4wJanjH2FTPkxxZ9RnCAc1U4glN/N0sOoo1ADAZonnQbGljh8+zlf3htLf4l+W9SJPXFVPxVRYcTDWaSpkjTHIjBig/gpOBgt81oqqEb0ZM7Y+irhIULjK7XIywuNtTo9o+Cmt9tpPF+K6me/ZZcysIwHUBV4Zbj7bpxdLu/Mi5XC4TxAb/GPQkAwAY5W3UGNlcAImjT2VXHCt4zt8U0BRASaOytPwGGegFSLGNnOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCS+e6zSVf0S/nC0SMw6yf3BHzTxt2QJNHlXtqU2br4=;
 b=PpdGVk/JCpUMZMg3pb4apItrSrtCXUMmtXlzGfjWWqcaj+fIm3yQWIdTIUNh530BHupmtAydxfBqMnBcQko1cM/1NUEWFRlXbQK3QX9dw/qPm34IYWlr5CcAorjyQf+Cmzo48fxPjVQmJcE1zNb64H3+3L6wBRZUJBtOGwhi9R0FyteGlYjA7xfw+PlImFWAPQMnycoKeSeZaHle1SyIyVl13LrCrvqt2pUXnGKCrSx+EpoE1VIJvCyu6wSmcO5GnGLMrtSPZdIrBz5sh1A7YgLUWaFZH/COd8TBRChtIzN6apdqDIgQSCNs7DcCM8n+iIPIGnch/fkCzeu04yK2TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCS+e6zSVf0S/nC0SMw6yf3BHzTxt2QJNHlXtqU2br4=;
 b=fbzPyYr33KNKiiqjm5lXE0hawmxqJME3B35cSagJd7lbcrVzGAlcjn3c621KaqxOC9oHBuq0gYzrZUDnCxqw0QEFuSPmSAtCQZjz6mpImIMrc/BORih23FprMogCtVRQGDJr2ZYUx+nB8YPjaHcMhlA5lzzTpe47VPxgNwBDboo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Thu, 28 May
 2020 01:17:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:17:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 11/15] net/mlx5: Add missing mutex destroy
Date:   Wed, 27 May 2020 18:16:52 -0700
Message-Id: <20200528011656.559914-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200528011656.559914-1-saeedm@mellanox.com>
References: <20200528011656.559914-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0001.namprd04.prod.outlook.com (2603:10b6:a03:1d0::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 01:17:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 76df575b-e265-4e35-f7b3-08d802a4f09a
X-MS-TrafficTypeDiagnostic: VI1PR05MB4368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4368CD46C84EE9CA98F808A3BE8E0@VI1PR05MB4368.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TktJpRritKIESuBty3HtLSlPdDsFOSxHXxoCBGmTAkBCfzlsgv1hltMYmbRFecUktahXndKQ6sJ3fmgVL3fiBeCMoKGI1wGVZ3KZo3Alt0cP3L9YiixLA7MW4v3yarp1PlBNOAujAKynny7WT/B2u9iUY+K+IdRVAqOJqD85VofJFIE3E/ppfvLRtOA99sm/FaQGscZYN4TqAPaW9QcLwdAVFm37hqBACxZAjCCrAn0T3vkRlApT56poi7pT6yiDkRSvmhtySgvaN6+LOEyi4XKc9HelwHuMSSZjiKXufaaEFRBx6q5D8yZXh/Co28MQYo8oHqOzFoqy8bMTD75Yv0wgrnzAWSx0ShDZhr217bIWrUa/i1HZVOgpKGQ5njKq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(26005)(54906003)(52116002)(66946007)(66476007)(86362001)(316002)(83380400001)(66556008)(5660300002)(6506007)(956004)(2616005)(1076003)(6666004)(16526019)(36756003)(8676002)(6486002)(478600001)(8936002)(2906002)(4326008)(107886003)(186003)(6512007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a2RdaUlxQm/dp64uR4jDH5Za5K19enbQseulcuYI2jn5GizfktqLMS+/6HchkruOlWj1tMYduJ7SJLNbxPVm3TI+VhfRtQZ2QJRZ2OatdhEyJc79rxYr147e0P7uHBZsiLlpEaK+HGmb3PbkQ207mjgNllQCVsAQfsRLlP6ev7S3hbkthDlpGW0Rs3UaN0kcrXB4kfmQdtqy2vF9u8eCOIJ3F37gXlPJmlQFZoWbeti8TUEZRsB78me9S/1Hi+Bbvw8dQQnFB8LMajeeEREThoygtbyp/um9f6NW+lPbQ9C18wdBQfms5iZeYFMLuIUz9Q4vUQPFQDhls/DKKfC7PLe1dU0XJR/JrDGGuwOsdsR3ywldktlDr5jopsryZvKn+YvQTdByvciKLYnwUdoy/oCDNCbQTJjRJo37O8RWektRCTP2HmH/MQLipEdnAr0vQTCFR+XnOa6G7FPgpakBEGGDaIKZqfhdIisOJBZH5Dg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76df575b-e265-4e35-f7b3-08d802a4f09a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 01:17:51.0263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qgEWRigZLOf/iRB8dfI6DkWr6ce6CAus2twHMH/E+eDa11XvMz+WJBohON79HGmhQWzAKiUZ7b1KCJBoVh0zgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
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

