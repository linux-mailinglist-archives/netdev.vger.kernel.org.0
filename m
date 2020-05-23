Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8001DF39C
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387526AbgEWAl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:56 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387510AbgEWAlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCPT+Ouxqt6r/o4pgZA74U6Ll9UKU2I5QuL2vYKooUYIrugWi4A4BNEeOMO4zPe4ktS9gcvyre1J5b2OIvAJ8+grlZGzWKAPdbgTyVXIPSX4vsDWYoCP+Rr2F5URKKO1048gQY/Edi3Me2OmCfl6wDr2JEfTgX8sFymewd3Kg3DjyypMi0VEv+SDZaa193v+UIrXEadjot0iEc00pchz7rrDJWtnZB7demfadzQNi6ORnsB1ZcFqRQrVpUOVYz4aL3j2/mNff9Nqd1JAuYqDuVyfC19Wu3TvfbNuYsZYRwiz637nZONyQWSO3ElT4/5GODdIOBcAm1fo5/ZZm91gPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIehc+NmIFO8JX5efFVoeHcotSpZmegxiJwIhTRXwwc=;
 b=m8h1T5byT/QHfPEMuhBdqYpY89XVd9CguRul4xBxoKZ7mUrvrIECUpcvLu1Sw23JHzhU0NHJeSf9mDqAJN9NrW2T5o0Tyt6Pvq8j/hmSfWOgHsiA5WCXZ8mIQYCdkyH8VWFMq/bkq6ERtwu2VTV5OX0u+AOcrx+uogHR8JBsYRtfPwSsIM8Lx2wcWrP1BFVELM/nnwjlFisgxaKtpnOMhAyEs9EKRiO4//Xh5TIE/3XtRf+RQ0MGtDuZMdWCmuxGZUWjX/xA8a8UWWV9xQzLG9S9rRx6W+r67hYRihNLvA/bv4HKyYB8MFvBHutqBWMlfHkX4rQHsFV/81H+kpUQtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GIehc+NmIFO8JX5efFVoeHcotSpZmegxiJwIhTRXwwc=;
 b=fmqm2Dsh1/OoBxaiwsJNU6sBHAaXbY+SQAgkZbYTWQVqZPTSAmnlhtvDoBhcrZmoNdpDLatgPVk3r9TISP3Ps5+BRlKS7LLax8v6b9CyT8GI0wsEYMOmND8wmGXs9N3qtCzP6FYtUH8z9LPe4s6ru4S1sXiSOPKVeSCVTydk6+U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:39 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:39 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 13/13] net/mlx5: Fix error flow in case of function_setup failure
Date:   Fri, 22 May 2020 17:40:49 -0700
Message-Id: <20200523004049.34832-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:37 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00019157-1da4-4dc6-bde1-08d7feb20dc9
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5391C0AF8EC94A2558312034BEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AdnVqgQ7lB5bRAq0bZ3AufcNvk12G9QgX7gRr7ajBD5iFmjAoQBKbMi47o4XHOdwN1MjE7hr4w7313NcuAUlDCjTNJHk1PVNnSGReoC4b3Z3xS7wfp2C4DMQX4jVmhzUzFL+QP24RwoASqP6M+RRo3eyt3nfDtv04jaRLGSWRynxtouf/KMWqeBpHiqH9dJ7uHSnesp8wIf8jYSp99aZJD9imy6K17Sfbt9YF18oBVJk3Jn41oIDTBoq9eiZLcOgAolxtagtcYO1GsYSmDSGp/+VO6HEtcU3/gcQLmOMEo4rIc/N41DAzBKF4IQ8qIV3sxzefRsfyNIzlGowzYN/79Hfm4k829Lw8s7kh3L1rk02yk5UP5KDWtgEUIuOjOhG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OlO7uf8rAaidQwXR1rju5MhQRGpyXuhl8nzJ6p5Sx5Dixezs44dILkFt7TDjnWlqrSsPODG1cD4sAwVKO06M7NjPFdE5jJZpRRfFAdrsScImJs8F7wnab1IKHCQAqtvRG6QMpwz/zmVjNHk5EdhCalrH6mcd5eL06Gz2zm5YyEXQrbfFNo0kNxakDbwFJi9wTucJuqfQXaDGm5VxQ/IKhLiKs2fF5G/g6x8TPMqlABID9psFeIt7FiQR7dl2mU8MVkXj9X20w3w9Ns+zVRajqUg+Q2WS9fVnaoAY/ua/SXmpabM9Xkyq3DwQKQOS0iUGjhm6npWu8lpO+4fBnaqkBpNK6ia08gV0K4FdTn8hupzHWYXXo/PCyX8DJaB/bw+5yWKIYAfe51RAlsm0AmenqgNZ2Rh4d8/WMsKGnbur+k+lwaH2WpbzLsGT8vV8WCmg8lF4VXeMQLumiJLZQmDWWCmN3bmDfsVwY48UOLy2LUQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00019157-1da4-4dc6-bde1-08d7feb20dc9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:38.8681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L7Vdsuul8GKtFeInDmlZhWHLa/+4w2MtWxoPJrtoC1K8PjwXc5/edy1LQgHRtrLfEmxVnFz/Y9AkUpgBRDcjYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

Currently, if an error occurred during mlx5_function_setup(), we
keep dev->state as DEVICE_STATE_UP.
Fixing it by adding a goto label.

Fixes: e161105e58da ("net/mlx5: Function setup/teardown procedures")
Signed-off-by: Shay Drory <shayd@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a61e473db7e1..c1618b818f3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1195,7 +1195,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 	err = mlx5_function_setup(dev, boot);
 	if (err)
-		goto out;
+		goto err_function;
 
 	if (boot) {
 		err = mlx5_init_once(dev);
@@ -1233,6 +1233,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 		mlx5_cleanup_once(dev);
 function_teardown:
 	mlx5_function_teardown(dev, boot);
+err_function:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
 
-- 
2.25.4

