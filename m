Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDD41D5C84
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEOWta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:30 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726247AbgEOWt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wvxcm74sn2GI7B5FN1pSugreLNfG3BJxRPQnzoiUlvw3sUFtedz+8czaYcw50HHNctaiaALReCBriYe5izyV8urqRNOlFAKVRj2Z1QxHFrxALn2bROZ8iOEXXxqAbU4ITXzaq5q7aDNrlRlv+UVtIE6zt4qQTmMsXrUzpam4yooMoQ7zAKPADsvk7XRiuOUnmLjNBrycnlxE9HOeU3QVu9wkOcRmJtA7aiCgqLjuqOYTqGurWz7u2fjEzCkNT6ni6/eaH0Fug2pWkUfdkx9erSelXF+lDBnXDqBFmqb0wvf3nVpQRJhJhqrHkXpQPjgQyTkhg9Qtaycei/C+6rKwpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18mR1bPN2ZbNrzwlb1FwbkYdqaUKZ6k4GIngNXK7qWY=;
 b=b7sbUHNbbwOWVXHDJ8nKRCp34sQRF+jR5ojaJB9Wx9QnBtWPXY05mpSfZ9jzZbew8U7cq0AB3QJj9cOCCN1cnApuQinYUrwX/aLIUetelIukAKSaPge76vcQjFKXwur98hoA4NxhgZoXve1634KKuYkJHt1zUL9YCPidOh3z7UxMjjKGBNwZGtGqH/zWPAlouE4dzjvNOCCPVI5sn5fDmfDg2SJWiLwuAYcbb0HpBTIrhmlF7GWvepUWNIqV54ECoWI1G818mHQcOhmulZUHRfoNCyQYrtriYoPpKnCrXeJUHp/8904RWNg0Gz6lXR9Iuou8kfVr6cdUBD5aGAtvDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18mR1bPN2ZbNrzwlb1FwbkYdqaUKZ6k4GIngNXK7qWY=;
 b=Wfbp+/LbkpH/1T8tvHRONTdeercqQJbXum036AImzD48/PJCPz2vkRkGZSiBYnunfh0HiHqs2pWjZGho+jUaAZc4/g7S58Thq5CHHLMamYCri2YN+MnkXlnhfZtMGkOKOr3ClgIjt6LR8751m+8XypelaOtRX+FVbbRNg1kYXiY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/11] net/mlx5: Have single error unwinding path
Date:   Fri, 15 May 2020 15:48:46 -0700
Message-Id: <20200515224854.20390-4-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:20 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d8cc8fa3-444c-49c4-c861-08d7f92235b2
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3200F0A01F0CAE16527C088DBEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:119;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: St383Ymork87gz9jgawbh/ZLAQve3BZlv7oewpjCAm6lm7xakTfdwcBdgqDTQuPlQ0InfccAVj267n8G/15n++floHEdL7WRNKXHcZGhyur/Kch/y0+7GoIyvZyzaBkCpITfQHSWoMM/R8t0I8qGv48wHdlIQSdTX0nDTec2oBDjsQW66j5HvqZnKNMEaH9caI8ziAGm+F9mljLNvOcFWv6zGJ9431aNlcWKMhUQHz6djia1ik0j6ZT+IvzuIKvaqS7I4byw8uFmPvKp4vCUzJtbVMz0wYpKJkVydFa4/tzh+0wZ+Y0UyZ6M66G/5j8VAXv7zMIZ2XpjjuRAHuCe84+9T2TVH4vTpt4y93RiHdv+PVpw6QcO5UFB5n6q8/Jms/NBbJyj0ZP3bnVNUqnauivzejyWT3ubkpYGT9/rx2HdA8Ttt4aqFYoXi490FrVKjcFyBka+aOkQIbrkOXmvsI07kdAqyO6I7AeQvqisA11U2VTv6fHMkan1Ume9in7r
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: EKdpzdJqyJoC4xMQXyboxgUf2oR9OCwsvlzF5l6IMeEex/XtKsHb8ajRnk9o3jCL7wxXThKsY2mkZYXtvhBCyzuOGXmXV8bJHOxB8qMWB4miR7xcVmSa46Irr9H2Ed3pafB2Xza9bR28DQsd7CLzxpSr5eNssmloxBenG6wIGEmaSOwsg4qNuv+NaxM0r77UZ5eKJrYa4GnnRhC1qIwFZmr4YiN+h5+LD9eaJjseEMYL/3k/sYQOnVYFMz2Syd6RHWiWrQGXJMphDofklDgmjh4Qr/XpNphRUKsRPriZsPoeoU5cXrfXuzOoN5xKJH41LA1LUA/Fdz8k5ZvMI0/Dm9O1/V9XkpIv5zC0UcwkflFGrGmWEOChWryLT2t2rWivJSkADZ2fphLFeYKC4xXDLugAuzLjuNLhJzVwf78FTXXupF/DuNo+iO1T1pIz4CjhimfabbeQiL+0cXAhHp6Ts4AC3FzeFCiZZzFiP/U8i3c=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8cc8fa3-444c-49c4-c861-08d7f92235b2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:22.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +54DALXkseiVfXfO8FOikBwa51XQtza++eUjqGaQ2M1AF+OlaaRVdi9u9o0M8X5tYpoB+7c4E5hltQuyydQYsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Having multiple error unwinding path are error prone.
Lets have just one error unwinding path.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 742ba012c234..2e128068a48c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1217,10 +1217,9 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 		mlx5_register_device(dev);
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
-out:
-	mutex_unlock(&dev->intf_state_mutex);
 
-	return err;
+	mutex_unlock(&dev->intf_state_mutex);
+	return 0;
 
 err_devlink_reg:
 	mlx5_unload(dev);
@@ -1230,8 +1229,8 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 function_teardown:
 	mlx5_function_teardown(dev, boot);
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+out:
 	mutex_unlock(&dev->intf_state_mutex);
-
 	return err;
 }
 
-- 
2.25.4

