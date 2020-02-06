Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1414154D9C
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 21:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgBFU5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 15:57:46 -0500
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:22890
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727526AbgBFU5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Feb 2020 15:57:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgdtL1WfS/B4CD5+J03zbanHCEcPxs0N571h72Y8W7szJ6Zil8zm5nP5I7CqxEz52OeqxE4najEHf9WSx63fLjz8qeqdc824BL08NOeIkpohbT8AT75Mqt6lyGKy+KahuWnyms+vBr0XPKwJc6qr3JxqL6/uOieoMW9qiFi/tdJyZeJiEGhIu+OxaJ6Clzvme/WoETkYtuxJnmRhigIOPLVdy/sMI7bBJTCSlID2GwzjgIYKezhyvDqp3/fw0MUPVquIYqfP1WH0dISpUaRphgkJae7JwUF2SKPoslT09tqf+MXIBnSowK9+gUYEbPjRtqD3Ua6cAUIm56kmtVAWuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfZXhrb3RpqSNouZIm5byAise7LVCqiU0jk6jGNYENw=;
 b=itKKcZI1ceGR5xoiwZPZVWc9nsr/QGnQiQaDdPr65KnOqNlTCBxFocgHhXGSvYaBbMmPGvMnOtGhi/pofnnzK328xlRm+QaxUXE02+A+N6WF+5pZ5yTzgQcfCqO6C78mXr8ps0ntCv9kxmiIOA2Z63kWXoVca8n/xyWYYIFjQmeMtkBXyh7YjMVKLB6F5TVsqdcWa4aZokebcZ7R979Es+m5HrTJp6rdKcgJNTCIBBdXekonuKq4KJ/TNnasGy8vXrZK9NYt4rwEUdHZTW5qqnLdiIcqJ4ayuK5lPhIt2k/pxCyMe+Nwl76VZXRRMXSBOxrSLKB5Sd+jDEMl3WtdJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qfZXhrb3RpqSNouZIm5byAise7LVCqiU0jk6jGNYENw=;
 b=RYo8elbm3JH+sAtFE0rMzYlSA/HfdG13WPNBlzNlras2EjgdDf30R0mmmkAFuE48NuA5heL3zPJomB8kaD+5X+LRiqxXPjP3JtgKQb7hd03pm3+jL8uOIXfhu48B8TVRAszn0cOvkpciiM8Wf2Zf9/o6ZTy+i/Y5r6v/Bg1toBs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3280.eurprd05.prod.outlook.com (10.175.243.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 20:57:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.024; Thu, 6 Feb 2020
 20:57:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/5] net/mlx5: IPsec, Fix esp modify function attribute
Date:   Thu,  6 Feb 2020 12:57:07 -0800
Message-Id: <20200206205710.26861-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206205710.26861-1-saeedm@mellanox.com>
References: <20200206205710.26861-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0005.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BY5PR20CA0005.namprd20.prod.outlook.com (2603:10b6:a03:1f4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Thu, 6 Feb 2020 20:57:39 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: db84eb5c-c616-4ac9-35ab-08d7ab4734a6
X-MS-TrafficTypeDiagnostic: VI1PR05MB3280:|VI1PR05MB3280:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB32804E22EDCAF02A0E2DCDCFBE1D0@VI1PR05MB3280.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0305463112
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(199004)(189003)(86362001)(4326008)(6512007)(107886003)(26005)(5660300002)(16526019)(186003)(6506007)(8676002)(81156014)(6916009)(81166006)(8936002)(2906002)(478600001)(36756003)(52116002)(6486002)(316002)(54906003)(1076003)(6666004)(956004)(66476007)(2616005)(66556008)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3280;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fxMc8w/a5uStU0vLkWhL4ha5ZLfX4PzTvgYUbMsEfmvibMh0/TthNxpsr78Jo8m9rlwKxenTTM4vWFK84Go/rf0yvjFOpQH2FArmUBvu/cEwseraPrTeMwyU70qb4Xl+BvT4KjZLLHdcnAPJ8OnpLsrAZZUpOXQuSpYlSoXuJwgUrH3yIb6g7ZHFZfW/U48zM0zwivZDSxoEt81eOmQGCpuW2szBvMsV8TGW5Dd26igNcSVWDEjQ2PhJ0YgRJybjfSl3380uEDZfPhLW3biqKhMhDBkkltqdmrhXLxBgR0vziE1wAtdYduJ+99bCR70snvMjxe9ndGlMUy6xURBUz3QPEoC8/7pFrKL/hUO8+FItnKhZbWUqOfr+tGlcAk24slv4ZQ/8mNZD6QK2gCA2/TX+8IZE98/AN2lP60RUei23/rkcWjCWAynOmZbUUyN0utz5WHoo35oKv5P1DxiOIjz7vSLOhgXW+gFDIQQ32Erto7bNRPm4/i/q7hWgxiiyfK4JcZbXDNZVp9yk3BmKaN2NIE3cr4P9tJvJQeiIy7M=
X-MS-Exchange-AntiSpam-MessageData: F4nftIaio+AFisfEYeMGYPtcfXdLk99VPdaJgqMxP70g5geY0/bfxMaRqHuJY0JhSqf0Dksuqi4moTYdOThkUoqOJTz5lHGopwsYhb5t4+uW2HqzJ6z756Jf9C5Y0Xj+NoiXlScFJziyNBC8U/4CDA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db84eb5c-c616-4ac9-35ab-08d7ab4734a6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2020 20:57:41.4517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjYGPt/wN0hBgXKXmkcTjKysSqgqIWW5LaAQpTIC0aCZ9UDXEsqjRelW3LDY0KczGoYidcXHobi6m7MsAJH3ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The function mlx5_fpga_esp_validate_xfrm_attrs is wrongly used
with negative negation as zero value indicates success but it
used as failure return value instead.

Fix by remove the unary not negation operator.

Fixes: 05564d0ae075 ("net/mlx5: Add flow-steering commands for FPGA IPSec implementation")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index e4ec0e03c289..4ed4d4d8e073 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -1478,7 +1478,7 @@ int mlx5_fpga_esp_modify_xfrm(struct mlx5_accel_esp_xfrm *xfrm,
 	if (!memcmp(&xfrm->attrs, attrs, sizeof(xfrm->attrs)))
 		return 0;
 
-	if (!mlx5_fpga_esp_validate_xfrm_attrs(mdev, attrs)) {
+	if (mlx5_fpga_esp_validate_xfrm_attrs(mdev, attrs)) {
 		mlx5_core_warn(mdev, "Tried to create an esp with unsupported attrs\n");
 		return -EOPNOTSUPP;
 	}
-- 
2.24.1

