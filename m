Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1388844412A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhKCMTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:19:33 -0400
Received: from mail-eopbgr1320138.outbound.protection.outlook.com ([40.107.132.138]:48192
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229816AbhKCMTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 08:19:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvtGDj2r5XdHy5YvvCKUAjqkbd5PY0+L743hnERRHaRVTM3by4ndBhRd5PsX8wtvi2VHwAG5BFUQmBsS3J5bw9Es1IP5ARM1zlhlw6J+dbtplhPXxeyTv1O1EpAJtj0zHmJND86TPe0rcpIXdqor209CzmPX06eluPMU4wWiINi6Bgh+BvnubmXK8BxBB4omFMXwvhPMoa7UHpT9IK4mY1fRyH1ExmxSDbNuZTbeVB/JC5qtlH1skS4T1Hy4uZqnQqbY6UWIDoGY1JbjO5bmX1Bwg+wmxVpIfCC/P07ejW9wB8WkzIbPIKIadKAHw7BkQnCUnn0UxQ06GbDTNc5NIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GnZThIqAPn27zDqQoJWh7/NIAbPxl4keba9RB/z6ugQ=;
 b=BzlUrZUJBHv/9D+o8WOQwEVDyE6NgDwiifJyEoNox9h+FsN1I7kkHCTY/z7sro17GzEj6Ga4Cck2rRlqkefgWvwrVedFlP4tosU6xQJUc6OJ8a1ZaCkhJcNvy0EW8hYf2aYnEuGt1hM5UcPJ8451wQ/mro/gnKFrD0D2BPo02aCL+TjCtZlX3PDo+hM/6+Nn9lGMsRN6SKkeUouTV7uM8oZ3eKDP8GwEAbLeaIGHbV1dwU8d56P7Isyc5Z17VOG15gW6/8kErQ9yNQtFN9HQcZP/IjOEnvH7tgrnRIm4ziiMmot6sLOpeUWBvgcqHECgT9R9MLp3feOQ2xtrMo+w6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GnZThIqAPn27zDqQoJWh7/NIAbPxl4keba9RB/z6ugQ=;
 b=jzH/jGOS9M7EJs5RBwfySDpr4bcsYYmSFBAq0wiBel3Qw8Dbl+GTQcECAwLi8Oz6aqo4ytsTWcU2M4m+82/RgRq+UFNSWuTReag3M1FGNGYoCcqXSL8Mz1tCbTXkXOLYVw5vDnbD2oeWCysaTawkibNHyPcAwSKc+RvXGpTWl0U=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK2PR06MB3282.apcprd06.prod.outlook.com (2603:1096:202:33::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Wed, 3 Nov
 2021 12:16:54 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768%7]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 12:16:54 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Guo Zhengkui <guozhengkui@vivo.com>
Subject: [PATCH] devlink: fix flexible_array.cocci warning
Date:   Wed,  3 Nov 2021 20:16:06 +0800
Message-Id: <20211103121607.27490-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:203:d0::14) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HKAPR04CA0004.apcprd04.prod.outlook.com (2603:1096:203:d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18 via Frontend Transport; Wed, 3 Nov 2021 12:16:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23e39a97-cf67-4c42-d213-08d99ec3d2a4
X-MS-TrafficTypeDiagnostic: HK2PR06MB3282:
X-Microsoft-Antispam-PRVS: <HK2PR06MB328291C128F4EFA0177707FBC78C9@HK2PR06MB3282.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CqMN2MQZTCBt/vSg+UPRUX8I2+zn6ljgiRpNTkMw7c/x2bF8eXigqbWN9BMQIX3p711SgEUSZNNbYgL17xZWaAnKrXJPqL1g/KTrMlJGSMk1eoSMj0yA8t2PNlXbQHcOdoPH1Te5tym7M83LSBL7h2VnusAmfS8X0N2Jx+NJdBBR1NYHCUnkhmv6VWS84hOaE5NYSTe5cHlT3XKUJvsNhHCExY5jrAqMlgR4h96lEYG/TtGLPoKdEsMm/Vu5zZDiA3Sv+tZGHFUQDHjGrxY9NRjGv0nCHEBQ4EuSwHPrUS1s6/yC4I3JGqN6hJUW0A/GgQY8pPEyNQZKLS/nqpTIqAbSYmqtWmKWQtD4yDqS3svmT8uW5FxSDqdkc19GRT3d64laRVlGiRx4emEneKUN8dR7o7lWqAeNcz5nG+hEw7gLgfRQMEU0M1cFW0aj4Rz0Gs7fOnm4T3nxn1RgbuZYIV+MjLOfbdM7MMNwRCBfBeXvWrkmzUmokQCnjF4xPdKeaQhQVLUUKoOMIwqnHRtRKKqZtO05xysVXXLAfNNoP2Xvzjbcv2EWDyxs6ofL7bak8cRzmqSw1Bwo4wVH4B8NU9lkyVlu/NTRdzUCjv8v1vXwfb6vFepBztvaiIXX/zaKxEEZCDhvwr8PtyJwE6UD9YDMhPwB5mJHt4+3apscLCmxhfpUDXxhjvCiz8U582hNveU5dRsgv9/YpdLmlcyR9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(38350700002)(38100700002)(5660300002)(66556008)(66476007)(36756003)(86362001)(2616005)(6506007)(186003)(66946007)(508600001)(6486002)(956004)(26005)(107886003)(6512007)(83380400001)(4744005)(52116002)(2906002)(6666004)(4326008)(316002)(110136005)(8676002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+xuxNLk7G0uAkxqALuUvbHunO0a2mrL35vHCQ0GIb8lJQRnAmq4Je2Qmp/ZC?=
 =?us-ascii?Q?B023Vyxgf/Qld50ZOSfIpQgHozHKiElQ5mthbPszwm6dX/vU976rc8yy6MDk?=
 =?us-ascii?Q?lYtUvInXTaCxHRXxv+APnmHczGcRHVbbbz9P/deZ4KR/lIEt+WZUWFxZgMXa?=
 =?us-ascii?Q?IcIAOg8HPUtP4q5zQ887yy7UfZZwZn5Wwn7nFAeyrx/CNE0RZcWTz4f1cfMz?=
 =?us-ascii?Q?t2LbAB5+A7GSQ6nUbQbuCyksC/zY6UDkS7ZjxKVSJEFVwTb+EUhoBtITIItT?=
 =?us-ascii?Q?uEqrUesLRAV+fDFXdB8tL+zSfDibnlZeAB5DmuHM7Qi06Mo7H9RNxISZtLbI?=
 =?us-ascii?Q?8Ai0/01m9h5/lGuKFluaQj0rB5M9yCeWtjMBWwEpgSoGv5QYlj3HbYNOb5Zu?=
 =?us-ascii?Q?2aQNTgTX8sQD+i7G3tWXifATgAU68N/VqbCew+a+qB/j6v0PhFPEJfX8uujM?=
 =?us-ascii?Q?+c+/k1gUvkz53jgiZylETKl65d8r2dQHP3bhlY/guAFhLzuROnDBuJijvhc1?=
 =?us-ascii?Q?Ux2YQ1vBWK6xx0IBMbTyEiQmNgVpVYpQhluIUE0Jq+Cvq4FOhbuJfL8SaOxy?=
 =?us-ascii?Q?VwLM2O94iEucMM/VIiTEdGD3tpD6KdOjaz91T9h+KDyuyOF8vsmoHC16fJyM?=
 =?us-ascii?Q?TEX6TAaNXIVqxruLhSRlWTpGpsdW/hNHzTCxrKzZFNl+GtmWpx4F8/kt8Vs5?=
 =?us-ascii?Q?6GhiP9IxHoHM3DJNiET0M1M7J/DYMFAxTGZBLJnY6tq+EO+c8PXJTHVciik3?=
 =?us-ascii?Q?FnuBC1C3qU+Ny8H4T3NS6OxWXXSN+UZgSXMmEXuM5jvJJRK1WCBabh0pkRPd?=
 =?us-ascii?Q?CnfQrwJpjMBUS88MZps9oj8IWmHToy/PD+h0ftPMouUzDJS/3IUbwTJWkj9K?=
 =?us-ascii?Q?ugMcMEB3MiO0YPIKEjO5tdUuN8bRUY1qgrgxqyNXQ2PCEy2GE58Bp2kz8myx?=
 =?us-ascii?Q?4vcots9D73ST9k31VIw23x1Y5phGl4E3C6YMT5HBCcFn5yO9IoHlIn/XwDH0?=
 =?us-ascii?Q?ShMgcWDtx4aZDtai6tkS6L7R/iEt3WjNsYVXLv9Fg5tqA9vIRo58tM9xPN1T?=
 =?us-ascii?Q?CDNWUom37daJ2vOQBbt2WpVpVDi7MuZUJ6uT6/PKwfYpLemdXhHaP4zQLZeN?=
 =?us-ascii?Q?tot5Utnq1lk5VJyzRMDcOvQredm5ETO1Un6J4+awoXwT8StvBST6oQSlqsEL?=
 =?us-ascii?Q?St2IW509ZmauiuqEN7zm5GsWJI6B8FIOGGkVwVTN5NG1q4ReBMBF5Awn+/HT?=
 =?us-ascii?Q?xl0/v8tg6kFNiOFb1purttu8/Jd/ZlRtACGWyfBSqoldaKR++t1Yu9SIhDLs?=
 =?us-ascii?Q?gPpDth0bED6tJ3IcdXWoYzAvEDoEDtxMS3bBluQsKMQ/d8vzAIexRyZrMk5e?=
 =?us-ascii?Q?yDnLYbJPjZD4/NnSrHrQIIIVS6tyqfJ1xwtwrIGEr3T83VP9LAvsfLbbhaq3?=
 =?us-ascii?Q?DCeCCGKc5AiRm55NJ8FBrBWxO3Feu8amNrqfm51fYKungkz10RcvJVcYjQqV?=
 =?us-ascii?Q?h1gKTH2jGz4KHLpni5Lx+wk/w9H7Hefbxz2/osE6crZIoSPO2xE7Yg9VU6gT?=
 =?us-ascii?Q?60MKnlG5pRcjPzrxq1cH/EvQ7j9LOhHgDyzIPrQ3C7gvIbvJCf6HxcknildW?=
 =?us-ascii?Q?88FzYmsHUkhA6fVhZsX32iM=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e39a97-cf67-4c42-d213-08d99ec3d2a4
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2021 12:16:54.1063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5AYl4JY5I/LNlIaIPAOq9R73Bt5NINpSPmNHTHQ0pYxdpfawKjOwSoF50VBFKGF5oRr9Y7k0wws7l4ZgNIiYTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3282
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./net/core/devlink.c:69:6-10: WARNING use flexible-array member instead

Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6b5ee862429e..5ba4f9434acd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -66,7 +66,7 @@ struct devlink {
 	u8 reload_failed:1;
 	refcount_t refcount;
 	struct completion comp;
-	char priv[0] __aligned(NETDEV_ALIGN);
+	char priv[] __aligned(NETDEV_ALIGN);
 };
 
 void *devlink_priv(struct devlink *devlink)
-- 
2.20.1

