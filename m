Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEB821A2C0B
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgDHWwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:52:10 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726512AbgDHWwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:52:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsT7cw+bEWos4ObJnHbxv0slezPBvnWgMFRIqcJpUDb7PhEtN11v0OFT11Ph9mqTurDKr8GnzOpQyx8FUvGT7szYCksu7dUAXBYm5eWIEJr4YdCiGdKfB/EsgVnu/N6AxMzHPCAG6UZnMLbHrJ4/S7D/mw0KJyG2PfqxNgaBxQvBbC1lN98JGuccmtJEdR/dCt1Fa3QZ8PFqpi6bp2QVzCUorgeiHCy3tKrJ8PaMg5ZQEgIc1WhSu4u5kE7+8f0DvHok4C/Bun5H062S51J16TCq76ICx/wUN3OFyV2oieoprTMZx+tPytzMFgUHeLC/F5BITjeiOx395U/WnkgNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNR2vwuOEKqtAI4bK8Wg4E2QWYAhpIZB26ap6VOvyFE=;
 b=WQFwtciPYXBGQ5YAWTfrUt1GMWyUT+8OAw2fTiQKLGE5jeEiXrl1VZc3Kuii9Jly/0kKkGZBQ3q3GXqb9uQQW73x1lae/be0wJGH8d7UANmcJx5zvi/mAAnLNVIEqVxvYu24cC+iIdXK9I++mdxxiWgmI89OXCdd24Qd98PsDcGbkW7EAIzHSIwlzAfMHDM4QkPsJJvXmRY9KLMkkc8RMGnlOBcWffAIzhEz4x8XCgTs9KUq2XkQg3hZnN8j4FEcCUX2dPs31JemnSYImCZhjrvTFBI4nkT9wcfg0ZLv5Iffn7BzCbR+lvtl3BoAhpQ9Xm76mXSO7pcvOrYVImtkcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iNR2vwuOEKqtAI4bK8Wg4E2QWYAhpIZB26ap6VOvyFE=;
 b=LDZa7SHYQkmJ2wXKNgBne5tuTHJLZrGkILePzUG3s4sD0VzBPdeEW3Yzyc0Rn2LIGx1VKibvQpo58poQURQywlLVcztLzrC0/Mee1O84E3dqrYoR0VJE3LgK3+35dkaBw1pgkxE9MbpNlEgnwUIbDlLIJQyYBPzsvMEuviJbQy8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/8] net/mlx5e: Fix devlink port netdev unregistration sequence
Date:   Wed,  8 Apr 2020 15:51:23 -0700
Message-Id: <20200408225124.883292-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200408225124.883292-1-saeedm@mellanox.com>
References: <20200408225124.883292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:54 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ca6c117e-d746-43e9-6eb9-08d7dc0f6fd3
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB636525F03505901E604BDFB1BEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(54906003)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WfeF2I+J11UIu+vplshM4TMq7Wt5TlRcWsHyIf1hpFrg4XlksppOfGzySqQXmyXIxqTZuRBMqlDkaewO7hOUdODtbE1zoMrNiKb1l9fODZItatq2H2jgLxAg6dLc/ZG/cexFUdUI0ihy5NhQYNsveEO/U0HC7rjsPYlWbuiB9c/WePyKcibY+7BypWZ2O1HqK3cl7jMy7rRjz5HqbsDCfJeCC1CRrObS74QhHRYY51p/TkboKfXb2qJ2wcxov6QzphwZF2Ixtm10fPrB6pj1dtcI9QYrw4Z1YlidQSAe6vNzI4H1IyN2rojX+ybpm+/oPCNtAUUbiyfA45VtqmUgLB772+BD9B3N6rn0lZ7JygKQd/Ox5B6JIPN2LQ3cb6ZSyEakupx60rwHyQGRszSDnmmkDrurSVaI0LRFRDyuWdq0PXnUGf9UGY8b5C4a0hU7GCwRi8WjatORzdbalnMWUChb4Y5QPe9GWSFEI0wZRVYOgpNBinWQW9sK7lbAviE1
X-MS-Exchange-AntiSpam-MessageData: jCEQArgVA4LJ5DF0uQw7rMjwh+VmVlXD/pQFme5K9f6kanxNdZgRB8MZmT/uG39nYp5ostXTaXceGXyQB0a1G10EuQyPYZS0aQOh8jGtCb2T3zqZ7M/1xjaqiO2iS8pRxDKnwlkOFHHcaCRLormsFQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca6c117e-d746-43e9-6eb9-08d7dc0f6fd3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:55.8899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TPG3B+Nw4vqqtU/3ayDQd6LPka6OR4aplqJKSPNtjj0nIUANefqPnDXtqZas8Qqi3cxtmGgbFuq+YpvfRK3zMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

In cited commit netdevice is registered after devlink port.

Unregistration flow should be mirror sequence of registration flow.
Hence, unregister netdevice before devlink port.

Fixes: 31e87b39ba9d ("net/mlx5e: Fix devlink port register sequence")
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dd7f338425eb..f02150a97ac8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5526,8 +5526,8 @@ static void mlx5e_remove(struct mlx5_core_dev *mdev, void *vpriv)
 #ifdef CONFIG_MLX5_CORE_EN_DCB
 	mlx5e_dcbnl_delete_app(priv);
 #endif
-	mlx5e_devlink_port_unregister(priv);
 	unregister_netdev(priv->netdev);
+	mlx5e_devlink_port_unregister(priv);
 	mlx5e_detach(mdev, vpriv);
 	mlx5e_destroy_netdev(priv);
 }
-- 
2.25.1

