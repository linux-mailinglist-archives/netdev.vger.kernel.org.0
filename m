Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880234567D6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232864AbhKSCKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:10:00 -0500
Received: from mail-eopbgr1300104.outbound.protection.outlook.com ([40.107.130.104]:43840
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231802AbhKSCJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 21:09:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zm1BRstWm2u2reChpWOdmTocYx085bRiY2TnqBYr5ExE7eWgkD+NlCVr0GuZHBeE2gBekFKR2VIaF4hvKhWbEp1R9AVt9r213rH1XddJJR6OIg0SErFleJxUtIyjris6a2Pi+7bCqYPRhiotEGHEEtDW/0Dl989srY0gVAecPBlciuVNX68JwenPyO8nh/pCHGhsrRZKBV0Gk2Y6ds5gp9lz+d9tNC/tYhXpx/zoJ+QkwwFe6c3FAobQenD5v7ViudOl+MYRm649mybZwnF74jvsua5zIkWhRKZ5Qt9r+F0Irwkxq0vlpzog5fWjd9Jx0f0tgFxbkXXzvJ99P3T8UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TuyhKQDliC8I4qFoPNAaE88O5kX8kCM/Ysiv4nmtNu0=;
 b=AJ104sN3Csc12XDTwIQrlx6e8vtNZwuc9D54nXOe9194gdKcB0xXf3om69uD11fIUc2M7oRL5zyDFSV2jWuDIhZeXJMtnBFbmrrjngiE4hVAQv76oGMD2V06FF5xq/wzw0BvajuwlpEonYl6OX/O3smQ+B6H2SuUtDBXgOSUjU33qHzSPpr1qfJqEwgA0MbsBWKLI+Md8nF8ZO9SC92CFqVVc661tsQg5x4sqX4rQwA4l9d6PXJ6jYaj0RP9hHLHVrI0U90jcSqoJKrDeAHrAM/Y81TRRTz95xz7+nRZ9K+0O1kE6rjGLwRmEtV6TajRtgMtG8ByZV/n66rTnN1Gsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TuyhKQDliC8I4qFoPNAaE88O5kX8kCM/Ysiv4nmtNu0=;
 b=nwC1Mw8GU8Lg11GigkUPCb5kEwJSqdcdzU6iKTACTsSNmikTgJjF5jMxooL7LTkoCW65k8ANE2EOFTJnGVGT7ZCsMji53ChHeN24NUUGwC4lvhfZeY3ij2d7EIk3BLS9yEbCija9guVQF/nrNufc+4N6Vp+GF44dVxZBvGoYz9U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS2PR06MB3446.apcprd06.prod.outlook.com (2603:1096:300:6e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 19 Nov
 2021 02:06:55 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%4]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 02:06:55 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] net/bridge: replace simple_strtoul to kstrtol
Date:   Thu, 18 Nov 2021 18:06:42 -0800
Message-Id: <20211119020642.108397-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0081.apcprd02.prod.outlook.com
 (2603:1096:4:90::21) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
Received: from ubuntu.localdomain (203.90.234.87) by SG2PR02CA0081.apcprd02.prod.outlook.com (2603:1096:4:90::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 02:06:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a88e5ef1-61b5-4958-7abd-08d9ab01424e
X-MS-TrafficTypeDiagnostic: PS2PR06MB3446:
X-Microsoft-Antispam-PRVS: <PS2PR06MB34462ABBE06A06E05A41DFCDDF9C9@PS2PR06MB3446.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLWNjzyDPUTP3joml89VUCfGvg1tYFtD4p0mpFcV0QTlku6LduVeZMH+U+xt9uAmjxD4iVEFk1mkfty5iRGuibqhiE5fnk9Go3pF+l3S3MlKFc48S7wcd9mQVlHaJCs8/heXkxVfsjJBQ7AN90iV17Znhwnuh2kHngKwTNBYPJ5SqmdpBd4cDVZDn7a0gtB+3n2GdL8i+Rnuh0JC1tmrR6Ik/XhNyjYq50q29T3EK5uuZ8s3G6eF7+YVHebqxe9Ae+lMhcLi2sHvq3ueH1iTA7PdODctKjcvbWCUFOodoM/C1rHS76/iv1UKcKlkDHx5PHO2tV+6mrbiXkLY5Q+Hyj8rZOQV07zmR/YqwuPiSdD7ViCra7F/yxfU8zFIhGzzze4YTovCIQRSeg2EgfC4edXMta7wv1/uZWC1wdS/01ewRwznffSmm0rDuE2vtAJXRR/oLBEHnCLX/MXJ6D7uHbT80QSBVnC99fgTq66eaZ948GQWMAf0ZfVa4j8nqV7YwXfErJ/xa+4TlJDcbqJE3uz6EoENGqfZ/77HpzR3SSx+BcVYjFq3PkG2hxo7Njp2Eaayu633RTMOf72hpDxVaPwskm0FwbWPhx2w5n8VmKWhOzo8ICa4fEtustdAv5zkesUXIUNF14G/0fEVH7qUQTsjTVaxyRalT5eoDZEHLZT+Fm/+E1n+yyK+BJ8rMbNk5bR7Kr05HF/uA5+2X1IB6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(5660300002)(110136005)(38100700002)(2616005)(38350700002)(6486002)(107886003)(956004)(4744005)(26005)(508600001)(6512007)(4326008)(86362001)(36756003)(8936002)(8676002)(66556008)(83380400001)(66946007)(2906002)(6506007)(66476007)(1076003)(316002)(186003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YQSGUCLrq7D8ExDcwwu36tjsyA7kuFZEdjJDUtNOE4uXFVxBC85P2mWTvsLG?=
 =?us-ascii?Q?X94Y7StVSVtMtz1klRDkZLLihUzl2gha9VPJtZ0+pO0VhbZNfQE9XglbV38+?=
 =?us-ascii?Q?nb7CD3PpbupUhfm/bORUJyMKqSs4+jG5OAE75okACD2me05hJj/U/OZVn/+L?=
 =?us-ascii?Q?Y73fe0rYYBiMW1PR3CnxViRi2Z8XjkD7Jd1YhETBsoyDHRT60gofstl0/1Es?=
 =?us-ascii?Q?lKZ3N1PhJvSbq6MhyQRRz2/rpyqXGzh780VUxSn+C36NO0Rx10zv5jZuv2QZ?=
 =?us-ascii?Q?jZiQfszxBKqrgYvESOgDGreeB7FBuuwPajbeuKI06ihAWQwwWIEcWq75lj//?=
 =?us-ascii?Q?xRZE0qKnOnGV1NXfSOQFKn37LjJmg6sGuvdaV5O/k5RergmMpOi85x8jBNqN?=
 =?us-ascii?Q?bW9DIoKhJv1iNu5qNZTizAbhRyWFUWg8CnHkxA+MXVQ0+IPQUTvYbT22zOsX?=
 =?us-ascii?Q?3A+/DBVF/Ys0R8knCG8Flt0a4QpXSSi3dniQQhEd9fnko/YXE5PCwaBPm4Gq?=
 =?us-ascii?Q?1jLo+tz3vRosy5NwFejaeKVIJ+3/luKQT//ptkRAeK6g+Tk7LqY4Q8UTrBxr?=
 =?us-ascii?Q?UbPvZ+CxCO9vQoyrFE8NzfQOjzkgYvLBRf8Nfgrbjjq36DVEofebyKfDncR+?=
 =?us-ascii?Q?rRDoSsgry17BI8f/huSOtOIhBKTSmI2mSRBUHmU+EIFE2X5tqGfWF4jsshKk?=
 =?us-ascii?Q?7Al82LkHAuNnN7cPKmi5ieZdlEx8m671YQrAIY6UMyQBUK7qGDzFcWWApKlq?=
 =?us-ascii?Q?motqGyti6FuiipCji8GkePYM8LMETue9ETtm4bQ8tjdOAhDuHjknKX5OHsJA?=
 =?us-ascii?Q?6oXRcmryGKAG8tsyRcPxKNf+BJm4tVpdzzPr5xVjY07SuQH+/9KHC7+9GO7T?=
 =?us-ascii?Q?8Q630PKnk5uxnvuf5viLiCV6U5+uz69lX4UL4vbT1NAM9Sj5iOspurs5dNai?=
 =?us-ascii?Q?lNqH9sTFA0DW1S6gyVH3PDnqoU9DjMOgudhe9oo4vZ1Gfp0GsqCyp2QqmFSO?=
 =?us-ascii?Q?6Ii/qIw0bGCQYCPBpdpmTiQ8Bqlf26YN1kSDM8KkdtUtVVz5cmlI5nLtTotn?=
 =?us-ascii?Q?b+GLvFuzFKSv2aiFmrYyjz9AfaONcF9Fbd85lZqZflDN8wU8Y39EpciRtXB0?=
 =?us-ascii?Q?rCkOYGpjQ/3S8ZhWD2/TvDH3/0RUYG7nfMe4hjS9tgalwnobSSCymDB9VH3h?=
 =?us-ascii?Q?oWDy9EjyVNiTiImGjxQj/IgNO/jno37yLRgw3PvPwohpXOhi1htv2Nrhc4Ep?=
 =?us-ascii?Q?/4ndO+FKDxqoJfaPBWRWD5BkKfvNXlC0HcFupgnYObpHAL6fvGV+bW6zLrnG?=
 =?us-ascii?Q?hoWfjaOLphmJ8k90p4GfCUVNUU3gABCrk70a19iwBy0BlD3JBQ+3MMY2HBlH?=
 =?us-ascii?Q?r4iG+D9vSr+TJD29eZFD6DVj9G8Sa72ILebaURSn3Ff3ylHE7JtdclHbBwdX?=
 =?us-ascii?Q?9BVecnMfIudRtbV5BmH5oHsfgVFWKfvR9jaF0tCDuwScpiWUldD7e04Dtp0D?=
 =?us-ascii?Q?lv558CQWLtQSLg7Y8brsZe4GlSnMngXJ/JZmCJDbJ6rmaqToBcygjeG27rkw?=
 =?us-ascii?Q?YAq7nKZZx6vOYops3XjGeqYK0qTYYRrVy3ZFpBsZWue03MNihZ2OsdGqDtFz?=
 =?us-ascii?Q?/XXJC4ADbmX/4680PlqwVUY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88e5ef1-61b5-4958-7abd-08d9ab01424e
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 02:06:54.9872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPLMm6aw3dR4oCFrr+DC8VyaU4fxxe8xWaLkHf6paS1TkdURqinQzTZpbThMOrsQ0GnCacGWdiU5FyEanvohog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB3446
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

simple_strtoull is obsolete, use kstrtol instead.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 net/bridge/br_sysfs_br.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index d9a89ddd0331..11c490694296 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -36,15 +36,14 @@ static ssize_t store_bridge_parm(struct device *d,
 	struct net_bridge *br = to_bridge(d);
 	struct netlink_ext_ack extack = {0};
 	unsigned long val;
-	char *endp;
 	int err;
 
 	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
-		return -EINVAL;
+	err = kstrtoul(buf, 10, &val);
+	if (err != 0)
+		return err;
 
 	if (!rtnl_trylock())
 		return restart_syscall();
-- 
2.33.1

