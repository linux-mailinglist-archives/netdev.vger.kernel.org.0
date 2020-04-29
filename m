Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA031BEC3B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgD2Wzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:39 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727122AbgD2Wzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAkxO5bza//HO3JuVksKmSUh7uZXOULEhcwf2WtqBYc9S9wXeyxOsciPLae9t7jVWvp8Iws2pVPxvBYLI7ixBjb/GBCw0uj0SvL4I3voHzzoKd/2FUmlKdwrEfV7aEF2jm6YJMpnYyXbfhFAXgRx8NdK7fpf6F1z5tVpSvFHOyovuLMvAd6yEaXtBUAhhZUAa72wiLJDyVtsRtIJzDYcE2RwwB6w9cgj2v4bGBcrv3QkhQEnXqx/eg3YMoaCW8Z6Ln0Z4ZNP3COu0dCHgQHYcq4QquoFM+Cxjv+V/JcNekOM/DAaKBKI6tnLXvY5FC5OffrDc+HHSDQtAYCP9FWJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AAhFgVc2ZVICs48Ge6eX4rh1r93rthSxi81KUUQU30=;
 b=MLibtTc9nixrLQjd891b4td7D+5XleSSO8rp1sYODWtJ4EHY2WHvy01cjByNO5Gjc1kAHnWQKnZ+l8VobXO7O9OQqSGmMNfW1nCMuMMAJS58M3NP97/zUZUTW9+J7DQlBnfLIGI/QSHaOkqNLLfWJos8VMBz6zi9xlu9Yss70bfXvWx/abKMMU3s6bSEKKobfY2/0sz+PKgIvvJPu0yJbgoXY+2MC0TEcpwdKJDdV+vbQ1eSuwcak/ruPKx8wdUBMD3fTtyv8IUfiBccF0sIyWZNUdzn88BZzGvyNUkRmz3do89fRnV/ic7Bkg8PFADxjSDkSKw258PVEQoym9ZM+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2AAhFgVc2ZVICs48Ge6eX4rh1r93rthSxi81KUUQU30=;
 b=WjZfglOW0BJE/5sodhoif6PIbiAfSrBqp7nbWhGK5dmbbi6mDLcQVL7sHVKf6V2wgo9ZINms8M6JbNgJYjyncb1kLXq3B26jBZht+1kDRvTY7AoVH5fZMx45ixDhhGfEKl6cvh+HL/8WSzgOrNWyYhrK2FNqlsVuL0n9GYGtVfc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/8] net/mlx5e: Fix q counters on uplink representors
Date:   Wed, 29 Apr 2020 15:54:48 -0700
Message-Id: <20200429225449.60664-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:23 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4d07e70-57bb-4a6f-e765-08d7ec90675d
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB52478B76EE6BC98E08D32C89BEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:514;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rejNYiKxWrCoIba7QXntTxhZBWqoq+Y0kKqJk4MqkT9o1k93zMrLkgUX1g9qhYslLe6R19Gxw+Tikl+QbHfJRUbo4otl75cfteSqOW4UZLqSmIzZanngXxRGWDsiIfkx9wto+F3HdZVJM/6PtHn9aKsqWEvsTHsCAS3ixHKH2vz35vbFk4ziT/4xSjedQAwZHYX1TKg1F5VBfcbcMO6yz/mA90Ea8HOhke+I682rie7Bfq1Lz9XBuQQIQi+ogemEcYBWCp+BYkbgzvnuY7oN4tb0CugMTYVSZAxnv4XF4AsJ0twgHBhPpOj77FdkFdesY4JZekGMvZis6CeGjo4mA++WkEgra5Dn8Nlyprvtej/hApbMDgFYfJvjldURYlGq0ypNRGO8wCj4F5oL3e0O/+qZQ86EYxw8hEjzfn+1/Hh0TCaNPt1a+CM/urFUy7EVuJJJ52KnGrX8p8W3K+L8wk2NtgcyVAL9lzMrKixFlPTdEKdQwwYwSkFsAdT3ul9S
X-MS-Exchange-AntiSpam-MessageData: A98w95YJ1VmTYRZucQWvSU46U/bEKPHowKYlOtn8a4AicKiD3VmkdQKBNbhKg6nGgEyiXn3Pz+zYLXe8tRxwDhDY+KJfp+91CkAG6xFOnX1Tp+aZIsu56vymJWLzrePPw56jlDgtGG7/g502O3Vk1jjYpY4B0Zy5cYWCGScAU0NrNu4zC+ht67SqOzLQLxbCq83GopX3GawN5gQjutpEUUc8d5IoEeRozcPj4+lrNRs0y/BrybKN6qeV84twexIWyTVHoTh+u9rCIuaUwiajGTTi7e1ZmjSP0by4HuTcZWrDeLsgWEACN8Fx/QkYv+c3BtWZaGU22pc3+5QZ4+6ietrbEjCg/MfwrAty2RfhdEgj/ng8L+M7aLcxmigVAYX4ySH0RmImF2xyeqsGrMxQDxNQpKX+TB06LKFIMIe8f16zfSjQBJn+DJaaw10oqWY4V5j/THTi/jXN0wTQQ7brV2qwWNxfU7OU/uONDmsJ18GMpZNZ2QrnrtqaKCDdUkIAqnfd3uPFYxX+LEd52d38qDxGzks3J37pSkFXIKQi6FLpSKIFceZG0F9WcSy0FLjOURwtWTTuXgRWK5lBdIoMHSbYs9FmSQeqk2n+0XFEP+WdxyGszs2mwR1TwkC/o/rkuNqqc+I/cJiGpYQDhMwl8tZ3tZIAfmxqXEf3/LAelzg4lqhvIlIf2liZ3GnRvu2mhi6SkuOLm1MNW5jpndLtA0TugZtp0Ol8zyNVOIAdPvUKjcEATPjk7gyd55VjfZ43+r7SMPjX6HqF7pbNmB403xj4Z0Naak9HxnRmS75mIvE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d07e70-57bb-4a6f-e765-08d7ec90675d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:25.3455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wfgn8MwDIGpMUOpY9pQmCq/QuYhMZ0TgnXK7KB5N6ArLOpIDq968CYFCPoy6LcLoiRB4NC5wbv/y49Z81RAkqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Need to allocate the q counters before init_rx which needs them
when creating the rq.

Fixes: 8520fa57a4e9 ("net/mlx5e: Create q counters on uplink representors")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 55457f268495..f372e94948fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1773,19 +1773,14 @@ static void mlx5e_cleanup_rep_rx(struct mlx5e_priv *priv)
 
 static int mlx5e_init_ul_rep_rx(struct mlx5e_priv *priv)
 {
-	int err = mlx5e_init_rep_rx(priv);
-
-	if (err)
-		return err;
-
 	mlx5e_create_q_counters(priv);
-	return 0;
+	return mlx5e_init_rep_rx(priv);
 }
 
 static void mlx5e_cleanup_ul_rep_rx(struct mlx5e_priv *priv)
 {
-	mlx5e_destroy_q_counters(priv);
 	mlx5e_cleanup_rep_rx(priv);
+	mlx5e_destroy_q_counters(priv);
 }
 
 static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
-- 
2.25.4

