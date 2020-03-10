Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77D417EE1B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgCJBn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:28 -0400
Received: from mail-vi1eur05on2047.outbound.protection.outlook.com ([40.107.21.47]:6053
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726569AbgCJBnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4mf45Kfs/lqHckMvzL52fMNY5QRAn41Uy7Ah9m2lsQHRy9LLZtatq1n4BVJA0995xYB103FPX3Rv3qxP5RtnDkAlmQCsD4oWX3h18p+t1Qyv+RxEzeXa4dvQiqRrSOCBrwZ9BrYYPruuTsaTp4VOx5ZDGoF4CKHCxINIgHwmP7Dm4U4rtt4xFSHISVzVa+6OF+n10QV6rfBQQ3cHY7YI4sEkGCMZwO3rP7PN9MYnNoIZiqQJmkqWaLCebvbfZNX4XKiPc2DoLid7bHD0EM0i8Su5FVqNA6b1hx6Aeb6HXVX+YTi2W2fM9fWXywXr1spVPiaSLUqJrg2EwqNwGlZ4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhOHzYv/XZU+6AqcQwDHDVN+wFxMhcHFtLTt4UaqvNI=;
 b=UbvApO904Ql7HluH5cF0mI8AH7aw9UygJzzrRIaovHlxFaZVS2IjGGs3xCO83srOqCBenXLu+gOJP+NPsFwTCIKgda6FAJBWQFl8TK61G0wAzOaSxCl19Ta+A6oWNXmAaqkSr1WCwcHfKHDH7MXTUYZ4VY1b4AxNJDEBul8zsSTbPLan94dXGa3Tg/ZHVmsLSW/WC1R0lOCtVf3ta1hdyAyyr3xB8XNkAXEYTlGRUFx0S2aF3/HQP/P+73n++J7YuQg2bA89aXYFJt+Kpmk1u1fCCQDeY/TYG2uQnNU16tZ068yfiD4cCroPXjDT5J1/Hwq+/7Isuw1lj5//YF2hiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MhOHzYv/XZU+6AqcQwDHDVN+wFxMhcHFtLTt4UaqvNI=;
 b=g8Tuj3BC8a0AirXJysqFekwGJAi3a1qm/tOu2Rkn8SDd/ukf2iRKznlhKUSorf6j3jlNYTvue49iGhuqhyULks/8eDQWiLzm4SS0OjzsnN3h2V13TrF88SMTF8xp6pJx7uYW/S5GvKAyI61vPeZ4EmUjtX/wKfH1HOwfdLM46Lg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5533.eurprd05.prod.outlook.com (20.177.201.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:43:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/11] net/mlx5e: Fix an IS_ERR() vs NULL check
Date:   Mon,  9 Mar 2020 18:42:40 -0700
Message-Id: <20200310014246.30830-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310014246.30830-1-saeedm@mellanox.com>
References: <20200310014246.30830-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:12 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 254aa407-3e07-4a3a-864b-08d7c49465c7
X-MS-TrafficTypeDiagnostic: VI1PR05MB5533:|VI1PR05MB5533:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5533873E48AA5AF020CC1256BEFF0@VI1PR05MB5533.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(66476007)(16526019)(316002)(1076003)(66946007)(66556008)(8676002)(86362001)(6506007)(478600001)(107886003)(5660300002)(81166006)(81156014)(6486002)(956004)(36756003)(2906002)(6512007)(4326008)(54906003)(8936002)(26005)(2616005)(52116002)(6666004)(4744005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5533;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4gP1ridKikbL3o5V2f/yrWifoaU+zXBM7JtqzWJzgEEPt5dI7NSVcUQwYCARXU503Bwb3mzNs1WGt/BF8JjkqPvkR0wKSB6/d14QcuB6lfYAswFBNLSB5B+6a905p1FDkCz0iOnLuB7U49MMraNHbUfpoOIEUTvVf88Zg5jPOF9yDwRDRVMOQTmW4YKj5eEmh6MGPacGdOFWeYcK0Ah/R2ANZD47D2lCuow/TUvlm0pVHVRO9PmWOhLgmUWwHXtlgVhZv3I/Yw7NzQLhLk9JpErHT4f3XzSRg6II+BsNtrUjijRl8Ug64GeAWg1chNdxU2eg/6270m+BVHc2KLKFNtX66WOzxY/LTFUVy5fkCvFCmQYxuZBvZR1VIl5Z1dem97otKTyQbPszeNRXTTFErMhCzC5wo8pn6puUVXla9rZb5xbhQqZurufqeGeWxpphVwtmx0MmMJshNWoiVf7eAFG90rE68/PrxDPzEFclQDuqfkhkyavg03mBe2o320YLv2E1lbnOxRTV49lGbxVjR2sXIsvwU6Q/jix2OK6vOUU=
X-MS-Exchange-AntiSpam-MessageData: vNjQaoz0bZ0pJop4dc6ex1Ib6Rf/24qq3Uy1TcoZKUx65EtCjob2dOTi+P+cfS8M72O03/gFtiDBJfShK/g1zm+zxFgu5jtJK3m8GRwLuJUuFJiYSNz//7hgdEmVjlPv4d0y5lA+lK/WtfM9TSoxQw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254aa407-3e07-4a3a-864b-08d7c49465c7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:14.1481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 24ta92LaFKVDAf1S3c+xT5OcwoW/z+i2aDwLDkjaJVgaTfTzx6HTG210vzWzS45Ca0BnuqYvW4M0j5bMtEmi3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The esw_vport_tbl_get() function returns error pointers on error.

Fixes: 96e326878fa5 ("net/mlx5e: Eswitch, Use per vport tables for mirroring")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index bd26a1891b42..3bed4f0f2f3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -198,7 +198,7 @@ int mlx5_esw_vport_tbl_get(struct mlx5_eswitch *esw)
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		attr.in_rep->vport = vport->vport;
 		fdb = esw_vport_tbl_get(esw, &attr);
-		if (!fdb)
+		if (IS_ERR(fdb))
 			goto out;
 	}
 	return 0;
-- 
2.24.1

