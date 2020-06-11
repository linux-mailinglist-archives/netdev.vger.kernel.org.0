Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3A1F7099
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFKWsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:48:09 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgFKWsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:48:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpOvAKM7lQ5DW+1XF3+8vTrxi0pHa7wHwjWJzJnw0y4QZB55zcvnIR0DDiys+lVYEcf6PmeImNWTbZoYkRkaDyA/qTV73WQdDKed/2CbtLTaMSWqEQi2rbkWtOGN2jx1AjCOptQHAd+u4/UCDh55fLUgz7QnLa4U6xNtU77/VT2/hNv6NGxrxhgiuOEkgRECNb/ETcVsntgHk3Tf/+pAOL8U9xvHYV3l4wPYqs9HxY/KWkNz//Bxa11cy3reMot5OZQ42rpMUJ1faUHP91gMSbAa+X7Z3elGGkPF4pEqdMDMzJERcp4vwuArVTPH1AO2fUNPVXrLPAc+72n63GEn2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh7OD6fJ4+m/Za1E2/jQ63b2/9b+B6d+GAyQRDksUbA=;
 b=noI64fnIJIiLts4ZgWrElAva8ldRV+jwNZOty+n7x0NZqm/lZ6iuLFp8l4zcbWIzYN3U4NfbyMP05gCqy2ESHLwBZbbVQxfO63kuWVysjxcyUaiPGPH9HC9vQHJzD0qSs2BBnahxDD8Fa52VBbAlRIJYnzQo5B0hpjrKBAVUBElQ0xxq9uPXih8qF2FCxQ4XwDO45smozJ3qcfoUsBizec4dQRy6QrVlR2eVrqM3rBQuln7JDixXbsv7Z3/xb9ObDlrzjmaVYJMvmKJ2FamROC/+/Osmuz0YwCpQYsQprF5MktI+JygAzCZCAi46kw97EBr4Oq525RrjHkknBtv1ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh7OD6fJ4+m/Za1E2/jQ63b2/9b+B6d+GAyQRDksUbA=;
 b=JFK1w/Rq+Re5mFELN+B78XbZJD+/dgsV/eXmxFxn70DjjpsUbCMORtGaEMdCR/GGqE6fObZpFEuOKScWiTAxhl+SO97K3C5bkHgzsuXM1o2g0tjGs79iL30IHktuSkw6Cc0Z0sLS8O3ahz5rtYE/+KuNASm52MHH6F0mChyfcgg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/10] net/mlx5: Don't fail driver on failure to create debugfs
Date:   Thu, 11 Jun 2020 15:47:07 -0700
Message-Id: <20200611224708.235014-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2ee0a35-2f4e-4646-09f2-08d80e597c4c
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB44640C80F6751B4682BD0ACABE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:36;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8QNj91I68nq55SWEIvj3+JCB9qa4r26UKDC9mXoa8PrY0dx7RvzJ1HHqGR+mRfImjaR3CZHGEH+p8LNiket3vJzYZr89z8GIv8YzO5zJDMlrvCPzj4KTaIElVw7qA4RSReFCzG42Coeum510jeCSjcGGUEOXkYhfKGxLoWXWofl0tgITps85OUFt9uMX2WaKgZIIlyptbaDksYpUMyyXBj27QBR/eL5bG9Oa2aSHCz176LweUICsUQrMFDxTnfR/m0o2wL9Jor68Pz5Ktj3b+ubxrR4dBwajK11vNcecUiRnxx0UEN+2dE7jiaOc+1VMVQrzZIoSHyO2P8ZiT10gePYcbMfPBJYNWoegJ5fpdUNRouxe1sYqwrbGcCdge2oJEqajxsINB+404GxhIpc6t37h9k/56ypZHiydEyf9jpBOIKZ6k5R+ZFH2wovM7ykjL5nSWR0wOtnMEn8Q/lHXjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(966005)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BIT9ZtW82RYbd0bTEv59W4TwTVmm3xYw/J9wN4TEvjjIhUfZmD3vqG1Y8BNAxJAGztpMqnKLr4JNIT9sqQ+lbfWpRMPL3xM73d+qeFZbVrtH9T479ySU2AvNs4tZZYYwO8oAJdq2CfyRu8bnvfycuHhDqC/Ce+ZoUX9hojOCpBvEtRMImi1UD/vIKYhf4Sw9/1xust1CF3wyu+glpExvtdO3YDfnFJjLZmlURyvj7ANWZY1LCBQ13dQdHjkhuzxWRGBUZSlbbd/7P+EnARQ4ewYBcUXVOWxnOidE967HW9UqscDcASfFLm4b5USLbBQZ5IJyPcJS1T8RHt7D08IU5RJNv+kwjzw9QdDmqHQZT2/OXOEl/8dDBeMhavGlfsDjtRKtaVV3dYO7433B9VnHA8NuLHWUWDziJj0Hlw5jbrXA2HLmK8ScjOtlgMFA2C05aMNL/pyY83LURhXgWeQxtYjJyYSg3bev0yRe/JZX6CY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ee0a35-2f4e-4646-09f2-08d80e597c4c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:57.7578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rN+xuCcG9UTeGsfbNy/4yage2sG2OR5dyAYqoEr+lkNSVuaQTR6BLDxGcqfTwjidWhfVxSHNUJpRN+bn7XyVCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Clang warns:

drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:6: warning: variable
'err' is used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]
        if (!priv->dbg_root) {
            ^~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1303:9: note:
uninitialized use occurs here
        return err;
               ^~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1278:2: note: remove the
'if' if its condition is always false
        if (!priv->dbg_root) {
        ^~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/main.c:1259:9: note: initialize
the variable 'err' to silence this warning
        int err;
               ^
                = 0
1 warning generated.

The check of returned value of debugfs_create_dir() is wrong because
by the design debugfs failures should never fail the driver and the
check itself was wrong too. The kernel compiled without CONFIG_DEBUG_FS
will return ERR_PTR(-ENODEV) and not NULL as expected.

Fixes: 11f3b84d7068 ("net/mlx5: Split mdev init and pci init")
Link: https://github.com/ClangBuiltLinux/linux/issues/1042
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e786c5c75dbaa..8b658908f0442 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1281,11 +1281,6 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 
 	priv->dbg_root = debugfs_create_dir(dev_name(dev->device),
 					    mlx5_debugfs_root);
-	if (!priv->dbg_root) {
-		dev_err(dev->device, "mlx5_core: error, Cannot create debugfs dir, aborting\n");
-		goto err_dbg_root;
-	}
-
 	err = mlx5_health_init(dev);
 	if (err)
 		goto err_health_init;
@@ -1300,7 +1295,6 @@ static int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	mlx5_health_cleanup(dev);
 err_health_init:
 	debugfs_remove(dev->priv.dbg_root);
-err_dbg_root:
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
 	mutex_destroy(&priv->bfregs.wc_head.lock);
-- 
2.26.2

