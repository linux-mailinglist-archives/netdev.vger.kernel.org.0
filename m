Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E2159C51
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgBKWgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:13 -0500
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:49622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727640AbgBKWgJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5uhB8I5RXuodR/ns761GM1nQvTlAgzpm+gJ5YdkcrNu7grXFkcqtYNnK2HyX2QULdxeeB+lJbzGldbiziaQGpxtgKmgLHIfFFIBccsjyWQMbwjHBA0U+2TtQy0zXYZStanvvSS7Euge5DGfYuJk0nVfptW82n5PoHFG5B9ImzafdqVjjL2x3J4fwfgm9Ax6lkqGF8Jl1qAzH2lYtqusmTG7yakkJnwSiQMB7lYTsZGdbiEQG/+uP/KVELtCHl3IUGt3LaKml/hmwDux36FvgJxYnSIWX/ssSR+JI4Sv7jODjmfn7eqBrqbQa67FtQwfQAlLpM8M92Bi1ci7H7xKEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAqOgmY6jhL8Yg5G7U2ep8lzbgl+wDyLO/eW6m9qqLk=;
 b=PsOizEkhOkTtQoh2LMhfn2lHhUqgR+nld2m/flG5iC2Ov+BAc5p9vnTtK9a/v1COF7i3f/zprOPBCH8mfiimLWXAQQBxJAgYyvLNY2LRhLWjyCB+40UyFrtMgqqE6z9u/G7erXOTtpVeogyOEO7Emj6kh5PrwjDSCOulqcPmeVkxwtLLONeA3CpHubGhtIMc+Nd1T/Y/D6qQnjnbNJ6Vd2XEk2a1Q0VKtorr8ZI+SgvGLJEFIxLpwBCpbvBKQLvV9z75mnCKMzGkEjkTmowb8vpy1fG73MB7zL3c8x/hl4moWnj8ZAORYx6Um7X+8uVgMOLW9V0cTwBgVIbJpgKyhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAqOgmY6jhL8Yg5G7U2ep8lzbgl+wDyLO/eW6m9qqLk=;
 b=GNCQyzG2mXbfH/Q+3kSKO1OLu4nEqrCYmt+QJAUgKCuWjGMJLNxroz4ow0LV9xEXmS/g78PfxUicQCULPimVquYLv8ENkpS5k7IUO1DAtX44gFXCCQZoO6jb2TSgx1ieViV/PkvELb/u6LzHK3ErQE3+W5gLzCXuTuCHfB1hcuU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 07/13] net/mlx5e: Set FEC to auto when configured mode is not supported
Date:   Tue, 11 Feb 2020 14:32:48 -0800
Message-Id: <20200211223254.101641-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:49 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 368c067f-e9a2-44dc-960f-08d7af42bf3b
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB43838F65C757F6F7EB738332BE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(110136005)(36756003)(5660300002)(478600001)(81156014)(6512007)(54906003)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Di9xBvP+kjg4QUlTboeWhBOIU4MdtIrCPRxke4pccH3aBxk7yFh7WGWEnpI1bjfkseDyn2CIpT4abhh0w1kHHsJo3PAwtyVhVtYZPBDDrBjpPg81WDsnY6+WUO5x8Zl0+uUQwDd70J3UH5DVu+ECWIlf/EN4QrfHTxB5ExMDH/uPSMl3iviZHkwbxzF8D05nT8/eRCBSw8UhzmSr4oVbIqAcJ/q6JbfCB29p01Q0R9U1m2eEt8f6Qyv1sypjMKDQIdks+m+5G9RLkJEn0x2hmuVhi5zO6ppekxMoObL/Nb0YIZCx7LLm9i0HCxswgozlhRxHOHzFU4Ildr6NwkiX4dyGcsP/6wgE/dc3PHen8wtajx02x2aUxR30tzXq93tdft11qwfxKGF1gQgDiqxZKEy5DC6Jw88vPQksQ7IBiFkYCMqxyUVobIPNIXf+pPkGoWlPBL4CW6pRxBxbV3stq9btIOKpOznUga7ov0RnTN2cxo3qEpho4maRGAK87lY31aBjK+B/UGCoHiB+dxn29z6kPf8CmMpMEEi7r0Ebzwk=
X-MS-Exchange-AntiSpam-MessageData: c7egVjoYTxqZ7lmaStptgU3KaMa/RRqqCpPbJoVj3muL9REhCwEtrePzpdW5y+TlAFhCBOsrMq0kVEZVDKHWVsXapfDP6Q/mQ5rpNqDS4Q1TW8x8OxCm6YBNLfDcUUqSmZ22z3dq/9O3PfouChdq9A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368c067f-e9a2-44dc-960f-08d7af42bf3b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:51.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cA3Vsx+/RA8y/p2V8th26xAI6eFbIZ/gPM22BU7CCYGVQWEvhpUt372fSmpeo9t/unXwQX2IiB4OO7sLh0LY1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When configuring FEC mode, driver tries to set it for all available
link types. If a link type doesn't support a FEC mode, set this link
type to auto (FW best effort). Prior to this patch, when a link type
didn't support a FEC mode is was set to no FEC.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 22 +++++--------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index fce6eccdcf8b..f0dc0ca3ddc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -501,8 +501,6 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *fec_mode_active,
 
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 {
-	u8 fec_policy_nofec = BIT(MLX5E_FEC_NOFEC);
-	bool fec_mode_not_supp_in_speed = false;
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(pplm_reg);
@@ -526,23 +524,15 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 
 	for (i = 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
 		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
-		/* policy supported for link speed, or policy is auto */
-		if (fec_caps & fec_policy || fec_policy == fec_policy_auto) {
+		/* policy supported for link speed */
+		if (fec_caps & fec_policy)
 			mlx5e_fec_admin_field(out, &fec_policy, 1,
 					      fec_supported_speeds[i]);
-		} else {
-			/* turn off FEC if supported. Else, leave it the same */
-			if (fec_caps & fec_policy_nofec)
-				mlx5e_fec_admin_field(out, &fec_policy_nofec, 1,
-						      fec_supported_speeds[i]);
-			fec_mode_not_supp_in_speed = true;
-		}
+		else
+			/* set FEC to auto*/
+			mlx5e_fec_admin_field(out, &fec_policy_auto, 1,
+					      fec_supported_speeds[i]);
 	}
 
-	if (fec_mode_not_supp_in_speed)
-		mlx5_core_dbg(dev,
-			      "FEC policy 0x%x is not supported for some speeds",
-			      fec_policy);
-
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
 }
-- 
2.24.1

