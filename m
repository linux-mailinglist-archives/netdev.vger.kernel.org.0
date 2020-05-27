Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014D81E350A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgE0Buu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:50:50 -0400
Received: from mail-am6eur05on2043.outbound.protection.outlook.com ([40.107.22.43]:6191
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728102AbgE0Buj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:50:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSmwtWcr87MItKU7++k/9rqHi+Y78wnzdiHQgZUIsAi+eaUErtlGLuk3J3+0CPC7+RtOBCRIuNmoKMGp0ur69SjaoC4tJnBiCNVSiAxCBem+VWZOGPdptQ7a+2n/hxyqY/Num5mrvbMSJ3N+PZ+aGoQ3QXu+9Obz/bwSmBRM+3BibCLw6UQ82lGBjxT3uKJ220WzV9gm3ONeK/vYElF8Jqk5vvrBfHsI90+v9l59NrHt6itjOCCMCo80PGJ8PzWHyvYXWJTSF/y8CL1eY93NBXVOXyNuUrOXrHq3z4x15xx4jg0yu7bO4ens6+JyLv6RzyaWE6WB3m+hAFrdM3pgJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCS+e6zSVf0S/nC0SMw6yf3BHzTxt2QJNHlXtqU2br4=;
 b=WioQxR5MljAvJmz0y3/iARczPvTAPqBEyxvlDrU/huIm+AddRSHZIGZ1TTal4oL5OZe/ScZ0S8UV877Goe8F68KXa5g+X+6sGQyN958wZj/f3/0WvwY/snSx6+HWtsUMGT86mmoL/Hrf+mfmVORiyxUsHx+dsaihd2UIVnrj6ZLxb68zCT5YotWJH6C3lH5+urPxdaEFGLlAwaBiN+KEMhnhvgt7sxBMYzfPNE5L/LKgsC2lSG93a+PacM5/u9oT0RGCBPkkmnVLj0Ccj4IhI4ewicpdlkguZBMhLLX9uZ95SHv7VJ55+EiIylJLPpMl5qx+8UPIHY4qUw6qDt7xqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCS+e6zSVf0S/nC0SMw6yf3BHzTxt2QJNHlXtqU2br4=;
 b=Ulw6kgOchoey48DKcKBqvZXG7haOykMvGfYigYgDi6aSMsPvf88LAqvMs9FnwyXM7ZyzDxv6jW7MCGNgAZDbiAD7kolbQyzld/xzfq0aqxRUVuAaLWULxeTkIUnZz7XdCQ89WuO73C9clCvx2O4/extsTOPzu5pzy0OdIMp0lsI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6637.eurprd05.prod.outlook.com (2603:10a6:800:142::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.26; Wed, 27 May
 2020 01:50:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Wed, 27 May 2020
 01:50:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/16] net/mlx5: Add missing mutex destroy
Date:   Tue, 26 May 2020 18:49:19 -0700
Message-Id: <20200527014924.278327-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527014924.278327-1-saeedm@mellanox.com>
References: <20200527014924.278327-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0061.namprd11.prod.outlook.com
 (2603:10b6:a03:80::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0061.namprd11.prod.outlook.com (2603:10b6:a03:80::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Wed, 27 May 2020 01:50:17 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4a1dbe1-ca8f-46ac-9c2f-08d801e04f4d
X-MS-TrafficTypeDiagnostic: VI1PR05MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6637548FB7B88CF4991227FEBEB10@VI1PR05MB6637.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i4RAVVEs4I7Uj7E49jRXvE1UrGmG7yxzf2pBJNKjAMrpUgOTDufEGQl9hg+VwNc7MeeVyIkPBfiujo1yVKvqlONVuMBXbg2JKmedH4ukw9Zf/8mRXZ7hhO2FQsodvzhFYV3XcyfIamZ/hpSvJtdT8D50YOTNoCJ5pGzUOoSixVoveuoQb3tN2M8Ws+3RGO6YpwWhDPAnKa6b5n2iI5C1vUVGPGyi2aE3cdmzB1dGpXVrkvGwF4XEFVZVdY0i3qchQ3XzDYtan/jTfyMUN0ZCUpimMtFi5udPlRXS1nkEZohk2mJ9bZ3Uwpv3IeoOOb99qdXfmGh05PGvYj9xj6fxASE5ld95m4M4xoQOktelFApFHfadzo4SQKw63I7CTUn1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(26005)(6506007)(6486002)(6512007)(8676002)(478600001)(16526019)(86362001)(2906002)(186003)(5660300002)(1076003)(66476007)(36756003)(54906003)(2616005)(956004)(66946007)(107886003)(8936002)(316002)(52116002)(66556008)(4326008)(83380400001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: a6I3U0fFcGz7TGXChMZkQP3mpIaM7Q1qouoX4W9+qQ8N3z7/WiA3pIKjScwIbWjoJBwERKlgY2Y4C6raXEiIV1R799mrxoT2yy6/TxTykB6p6p1PLmGpynF5CcNmNkfHMjj9YLKCkwllcwVxYHpUMh24cGqVMbnWEi4WXVUfxCooRdIBvTdFm0ttGJ2sOyBlwBmEaHDCr6KRr5FclaQw67blHFnE1oRpWSujANm1KnNuZF/CTMMXbranrcp62khchwZGyUEYvr32gkG2cj91KtKY0ts8AhCzeaw+zWH9s3ydcF522wEckusOubjPKF9dLttP8NGpoyc/P9Y69fs4fdkwS7x4wj5zc7U9nAxMoFgp684Rk793zWEwQvl+pD4kyedjMbjrGaQQD/VYG937k8M4ol5QriH2fsl6dTiYoOEJJTv5vDR5oQGTfSiKN1EYLK8dV4wQRBYdE7d+dGh5F0LVmI2DjKE5g275Y6nbtaI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4a1dbe1-ca8f-46ac-9c2f-08d801e04f4d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 01:50:19.0072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4vbvNzD6D3EpJQNky5GWzH0PINmo43NpoBvN3RMY9vRODUTLOBH3fS+J7xS2sExLPOZtu7uq3GgGOR1Clg+TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6637
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

