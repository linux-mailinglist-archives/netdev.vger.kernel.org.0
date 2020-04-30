Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C731C03C7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgD3RVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:10 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD3RVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGwRfZhLxemXn1+fJzMkuVv8MHk73oNAPM1cRRD/gSyU+TaFoFUNg8O+GaMwSS4ETQC8mYwvQZ7jK5oRk9swfT5c6VrkvSmUuqRY3HiWEy2m3seexTjn9JJ/tRWW5HcMxThXtbP6BfW6R063J1Nne1U9meeYCi8tJ5Q1JlXTKXuvYvPB2+Z7sAyQ1wxdPpzLso2rxc/WTdbTtTZTrG6eLvYQt7/GWoPysI0XDY08ahe1Yv+qoLWzmUq4ghhGNa66yuErNIethTPbv16Q7RrueL2vagybfDwlHuxYXjDyjKPYARAxvCyrUPAtJI3dIh8zFZ6i5Du+7yeFwP/ChEf31g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38agFz43c1lcWebIUJ401ta8lHb3mEONUeHc1P7iX4g=;
 b=Pqlk/tGqqDP2jM7b8opjo4ajigEDbRt28xIQ9BIlFvtBhJWhCRChKQXCSrfDM46OXGgpRr+3xGaAl/B7PGZQspbYfHBjb3RImyxLhpzCkEJa8I+jvF7/7SWI8fSocURUzMmOONJvbe3usPMGjtzz6OI3+qAgXa4/UChRYh/9amu5k1N8//oQ2UDAqTA/Wt2egoQi54wwo2bZzgmhm33bE5J2cRBWfv+hVmLc08YlH6Y/onMT3o+5k/7tYYwugyhX+Os+uVIWDB+k0xntUhW6y7PKhBYYA/hME94IaemaW8hN0en/xDbCkNwdMbTD2BNOlX/cfq4I8Dy3Sdks34yfog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38agFz43c1lcWebIUJ401ta8lHb3mEONUeHc1P7iX4g=;
 b=m3md5OUhR50vevrYcbom9R4q86+8mwSSycAE3WZko6igoZHoxRP/qE8CM+5HR+j9ljdV/ARGgQYX9eV7aB4rcVAQgtfi0JbURYI0uJdQkjXNGAXp/86Ry1z73nsp3Vi97f4VZz3v0ZdAJva6Xc5+6TDUJpbN0NoufRuk5Lu6fvk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5e: CT: Avoid false warning about rule may be used uninitialized
Date:   Thu, 30 Apr 2020 10:18:24 -0700
Message-Id: <20200430171835.20812-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:02 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc01d8f3-2b89-4121-39c5-08d7ed2adc62
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296E184F949BCB91CB81D89BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uvmz634s+UoAs54rMu5NaNmzeZsAQBCxh5B8bcYfmfhizCB+5hu9nOgyF7VE6eEXiVM6M5eTlZwelNhekrpxSI6msfrTWUKz2YQv60hvbOcrZ0lLCYZ6CXpbQbhijZlwN48bbB+636c9lDoHrWIL1sIKvCNJDOud3LGkylVIkvmkobN4lhNuY4ZNB9LuIgQRQbRFFl6lWSj1EYmfzeMVcHHaRzq7pQBUyrPay6PVaagygC/163eByB1fXBBcRao/JCvnD8rdJ/QqH85r5+2FBVzj58HJqfZWNzxnjnrRHVISBkbhuHMoN106hVzy+pFuyFn7Sw07LjiRvN83oSPEs45Nhku1MdqqkoK7JME8JXW7gq4IFR18zdjcrUIaujOmhYrnra+fn8GI0X0lVuzKKmQW6ZJ/x7AGeZRsNUmJvmIbbwq/9mettK7gdp7GI0vLL5DR1X7cQ7/L56VC/AFTeXv/wozQjHwyWYdcbWh6LcBy3GpVzIJ379sAhu511MkS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(4744005)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5Uc6yalkHRzSDgzqF3M9kkTytFq1VT+eXJ24uJJT2jbTBxcY0g/M12hAKi0ocvgv+WciNlT3p6gYdEHvXYlYCe+GnZlEEGN0rWogUhxrBzS1F/d7XFr5CyqHeWaIxLds2u9cPgzAtwm6ZsTXg5f7+iJiUm1GrgHsbM7fqmpMFBLVSlGA1L1njYr7Ns0zMb6xHon9Mat7R5ArVOOxV23Pp3KM/bLbFSH65B45MXMSzIupYXojfe+3NJrxbCmPHvf3K6ljiu71wKSY2SH0DTUxgHKQE76VRLrpBJLLrFsnAcQwfiU635ShZhFAU6kSlVm5/aduRIvqVAYJHZoU8nCe13Y/b/BS8XVLYtaKMW4j5LuWPnYmfE1qbIFPa6zpjr1JVPC2Z2QqBM/HEmIJ9xe52ij/qHq+tCcPmgGSB7jJ46MzUhM8QTHRNoI8dWrubAWcDCAPiXNeZiu4S8ZaMK3Tu8nG6AAz4A9xL2rFR7fNLFlTISALQc/ECV0Anjs5c9vXyJaTtCg9jBKAVCNq+C0YZNKhS0yEyTc/TCyY49lDa5jfwbJBlqjs/MZDXzPaNf2nLukzMhddS7a/5K/KhQCeVpNqoVmLSZw+qazuNLAica6Imxxi9SYfoi9s8FUuimG/zeEw3BC/KWmnQxdfbZXuouBVWOmQgTz1x+gqQjS/RbquMRjXlBbtlV9Z73RK38gJqezZj249H7+Q83d8x2ijO/VihkFyjE258s2hFhe5sVE0L/DYQr7lwjw5hCC7R71wKU0XcaLNvWr+F5vp56Wb/pR67HEXJnxIFrlyyuohRlA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc01d8f3-2b89-4121-39c5-08d7ed2adc62
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:04.1766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBYEB23RYg90rsdUelqjBtlT7dNQW/J4UTLJhtkcqO3CcONV/Pi9EwOkunAFpGr4oeg+di5UewL2aTCdlMpelQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Avoid gcc warning by preset rule to invalid ptr.

Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 77b3f372e831..44f806e79e8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1131,7 +1131,7 @@ mlx5_tc_ct_flow_offload(struct mlx5e_priv *priv,
 {
 	bool clear_action = attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
 	struct mlx5_tc_ct_priv *ct_priv = mlx5_tc_ct_get_ct_priv(priv);
-	struct mlx5_flow_handle *rule;
+	struct mlx5_flow_handle *rule = ERR_PTR(-EINVAL);
 	int err;
 
 	if (!ct_priv)
-- 
2.25.4

