Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DAE191C54
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 22:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgCXVxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 17:53:35 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:6069
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728241AbgCXVxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 17:53:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TThkg5MozFVzHKUt4PouoNc5yxmVjTIZKnXJBCW5JH6REDfnKGSKXdeXT+ynXmAiy2ZubMx1xWWaZNqSVfmIotoV/C4VC6f6PnXQ+b4wD3wEwKJmxJuzXF23yRude23zj9Qptdn1deGAMU8uQ07k8SSrekGmOEuYdw8sllgzaNbL47JnD9lZydZzRN3OPzyciXqSPgU8tV4Qaxl0zQGFVnWKAh19KXuWlZoOAsvaIPV9lg4uuWA3nTGLtHZwux47iDMkqsqge79PyJb0ssDFHwpHaJw2cI/xr7kla4FyACv7Mv/TaxCP8/Tlke/yaxkqNHH+lyCwRfXLyvlf4xR4iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOID2ZpcsiL3J6u7frxJzH+vBdAWXDSUchhBQnGzOh0=;
 b=QWxoLoE23aHnfsrok1vEN0QstjuZDGg6MtGU72FtEpsy74IxKlAwB0bBuxVox/oSf8ZmDmLjGXxIQBtBXBcV/kjhWGSBP9CwbL/UQkzOhYkhFLv+aUMcBy7AoJxtPy81VChG+8RcmjR29poM6plDCDHJXMV/XST57CNm9t3a0OVsUycqTTRbJalp0fwI5leAwBUivOgIolp7dNqjl+TLpK+NUss7hvPiTOw6BIC7tK6dRWG3G+MPj+6fOaYWpWs86zsmxqenmBtzQwYveijnQwwP8R5uOUT7WQWSFANW96mhLZlRl6rImLnIyRf7RDJexJcn0LiXBlqeRUDWv9J4xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOID2ZpcsiL3J6u7frxJzH+vBdAWXDSUchhBQnGzOh0=;
 b=qlB3qA2iQTqLZF2fuNbNLURhRajeC2VyirOIU2+FlE5H6mghjRHwIm4ykM3P6+CvVBWWrbbKTqvdwQMxC5iUbkqND8NhzChfGNeMvEqOq+nx8tzu3y7KNdD9EysL1nSwvQaqIP57VFHSGVrDOaGBnA+DJk4EnoZGERVvAapQv3g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4973.eurprd05.prod.outlook.com (20.177.52.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Tue, 24 Mar 2020 21:53:31 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Tue, 24 Mar 2020
 21:53:31 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/5] net/mlx5e: Do not recover from a non-fatal syndrome
Date:   Tue, 24 Mar 2020 14:52:57 -0700
Message-Id: <20200324215257.150911-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200324215257.150911-1-saeedm@mellanox.com>
References: <20200324215257.150911-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0049.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::26) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0049.namprd06.prod.outlook.com (2603:10b6:a03:14b::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19 via Frontend Transport; Tue, 24 Mar 2020 21:53:28 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc8bc26b-d507-4107-2d63-08d7d03dca88
X-MS-TrafficTypeDiagnostic: VI1PR05MB4973:|VI1PR05MB4973:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4973F76231957FF780C21C71BEF10@VI1PR05MB4973.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(6666004)(107886003)(54906003)(8936002)(2616005)(16526019)(8676002)(81156014)(86362001)(956004)(36756003)(6486002)(81166006)(186003)(66946007)(6512007)(52116002)(2906002)(5660300002)(6916009)(66476007)(66556008)(316002)(26005)(6506007)(478600001)(4326008)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4973;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KuhQWy8mABrRKr5tiDg/wW9+ezzJNSq3J3hmL8EnZhiqJmH9+d8GWpe6RTaAb8kGR+Ms8SUqcMSGbuxAQ7Kdv/wMnbBquowWoAWHy0JIQnPn/wUdio9VTUymG/ZeBNsLuCq08WY4c6plnXryUq0gD9EHHUKEP5nneip5anHJcf51MJDjEO8dmh4xTtduU3dz8Hw0msxQnv5jbWewrG29U5iFMPCTtUB+B6W6Vq6YFMxOk2TZHDmH75xO2eznk9vPtbCTAW7HsIBWhL1s8T5nWe+NQAggnkVjbWKqkTMprDU7MRSDaWabZ7Kz56L1G4m1WjaHOAMqKfg/hQ3hxD15tGXvQDNkHyi/6yPGrdHujQycDvb6nmNzLX+dYqUt0ZYJVghbKzFFgzS3alKASS8Xy7/G94QSJWDy/BX9bCHOzVk55aozKn8pkqIv5Vn/Pbo5dDGFtyxbJPHkXudq9T3gsin3k6ZgUHkdM/QFV+f5qC0mFLmlI/DFGA71QS5gyMVX3KdZWhYicg4WPayx3B05OH/iC2XYasPjXenBnJkesmA=
X-MS-Exchange-AntiSpam-MessageData: z2Q9pz7LIj29wSOS4XDd0K1MxJWgljp6NlNmiJbRposN2eNR6V6zwKo27gfFziQj+21IUd2sdC7QCUkvD2WztdZW4ocWlWwryk4ruEoGMet8R5bMhzFygM1NoLzA2D+4/figmfbOFjIzzEd+pFCYiw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc8bc26b-d507-4107-2d63-08d7d03dca88
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 21:53:30.9247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vK2+SBXqz+HC+y6upZOFZR/GdxefFRUl2Vpvfv8JGlU2YL6UqovwRVyPHLOuD4eeXkFUew+42TpHN9tbJmJG/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4973
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

For non-fatal syndromes like LOCAL_LENGTH_ERR, recovery shouldn't be
triggered. In these scenarios, the RQ is not actually in ERR state.
This misleads the recovery flow which assumes that the RQ is really in
error state and no more completions arrive, causing crashes on bad page
state.

Fixes: 8276ea1353a4 ("net/mlx5e: Report and recover from CQE with error on RQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
index d3693fa547ac..e54f70d9af22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -10,8 +10,7 @@
 
 static inline bool cqe_syndrome_needs_recover(u8 syndrome)
 {
-	return syndrome == MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR ||
-	       syndrome == MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR ||
+	return syndrome == MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR ||
 	       syndrome == MLX5_CQE_SYNDROME_LOCAL_PROT_ERR ||
 	       syndrome == MLX5_CQE_SYNDROME_WR_FLUSH_ERR;
 }
-- 
2.25.1

