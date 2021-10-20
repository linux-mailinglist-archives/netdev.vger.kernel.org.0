Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3900A4350B1
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbhJTQye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:54:34 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:30178
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230361AbhJTQyd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 12:54:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KubvsHjHGLxL1MxpFcP4YAVDOPBYkhyKUDLzgYeBlRAL7oLeosvNsK5s4MhZ/juqerig9VE3cv6xatPFu2wJkxqDG/O55ChB0TZ+viD7nkfniuyKTEqWCeOYwfC+oRWl0dEHNTZ9GaA5KbaGbBRMNyXhZwIAt+WkYHtZLTBGitdC+1hriBF8f6SUnmpQufGHZhehnYJkMTo118+brg8vOKCMCXLKIGRs0RWZ8Cu5PYYLD8rxvelhm6AYRuylFLWZv9zadtnuVLlVZ+EMhGNXFRLwpwTIubwSjmQgarvHXX1eZ/jsFU3Y23lGj2mbUQKzYVxz6VIDv9og1jakLXAgmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CGNmk+Bo5MBy74UyFXeKnXc/W9IGQji1Wy197RzejM4=;
 b=POUONUf1jwBkUI8WSKJv1DvFmqDJicHffTVnRA1FBJPQzGV+Fv6hJFy6zymYuPapRwQgVdfAEPjt6kaiDSc6EQkHSOJRbyJmnu1GLHSYGHtexsj3brUw37PIzmXMkn4qsvr8DM0Re/IDZG2ojLaFYvQELlT4fV9nYuwhDR1nJPrvl7ua6eNt3jG6Q0Z9d8/amKnlkmmiDuN+B6+dOliVMesmVh1d6m7ROr7buUBKWqLTcOc7yGMi2OVu0YSe2p5lDBMjPIYSiKgD8DayntVVtFWOXWKEb0cYWmYgWHsyOujQBuTmW2085PG2BSqfWyXtLysosAE9yXXCCK+XwPWmuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGNmk+Bo5MBy74UyFXeKnXc/W9IGQji1Wy197RzejM4=;
 b=RpBGO0t/QMKjQJX15dVSAXG1jUIUBPCznkvzxx8RTBUgF/HbrDM0ZoTpuc4KOpf09JI5mxUF9iEZO+/mpt6EfCcNWGM3mAEhUL3xaj2Uth6fEdXcMu3QCLOv/Y3FtA7kNWnDSEc1TD2scUjh+20mxye4vLScd+bG+DHv867i6DM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5134.eurprd04.prod.outlook.com (2603:10a6:803:5f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 16:52:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 16:52:16 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH net] net: enetc: fix ethtool counter name for PM0_TERR
Date:   Wed, 20 Oct 2021 19:52:06 +0300
Message-Id: <20211020165206.1069889-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0120.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0120.eurprd02.prod.outlook.com (2603:10a6:20b:28c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17 via Frontend Transport; Wed, 20 Oct 2021 16:52:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 586b07af-9e82-483d-0a68-08d993e9f8bb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5134631095384BF08201E355E0BE9@VI1PR04MB5134.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7syzs5inC7Buzan1x02mFkffPym0HKWrRqE78wysP7vvOxGKoFp5TLKfMoxn4Wq4LXsVxBF69lTzNSsr3MiILf+Qmcq5uwFiazSI9RvBS3kZraNkwJJ3mP633l4EZ/SUJW/yVIt4atIVCERfTe7qtfbZ8cQCtt0dbH6U5Z/ITGRlPkp2gpKRSkmBdL2f4RyixRhuEk37YlWM7OxQBaPEbuYcM8fQTohTBhX1sEHB+ZZTTLIfY2Maqh4tfepHfPHZATcmrdIzGkrXVuCFYYa52et+UoXUzUqN6cq+uHziOrGSOO83y/ZYg9/2J5gtXS1LRrnE6pL86fF0LW2e9Q2N/cYki6KwS7lcWhY/uHUbjtcsrZEfYA1X9aKxa4Pmf1K7vJHaArQatcB4r77lEiJIeaoWGBt5FFMAlxM8EWNv/Z4/sFmy2bpbz1RrYY5e9vp6JVdb3t6oBamDW2VcN2g/bAxq4dpUfKNcfJ+NO+GsNGUYm11rFfUaQ1LQLtCUZgMT/vX5/eMGgX6lVMQWri3i8SWB9W+2hexiJY3DXdYOcpSYEwy7GCN2Utaqm75it5HeyydI8o50AzbrhAEpAwnqZICvvREhi+ktuSQN2e1Xb0XXKLZEDjgubxFUsMTaHPw6uvbNVJz6HRkDumptsnW3STAaZ0jyIshXEIIBwmfg4B5qpMJ93H72qyGSPv9IrForgbKImiKmMNfhzN1QNVHwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66946007)(66556008)(36756003)(956004)(508600001)(6506007)(6486002)(44832011)(6512007)(5660300002)(26005)(83380400001)(52116002)(186003)(2906002)(1076003)(2616005)(38100700002)(38350700002)(86362001)(6666004)(110136005)(4326008)(316002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uOJSKcLxBFXdf1AKrUae3lll6UhplU5kky8I4a9mPIreKRgsUHak2fPHaiqD?=
 =?us-ascii?Q?+Cb5Lbxr7isVJJe4agMxgGqoW9AinG1XTC9NMIBwY2VpM7ti9RwrcJsyh5Cl?=
 =?us-ascii?Q?xNGl5Gj3iNnruA435kDtWjzajNdinkYy/uGFc7c5Zd/zL1slw6sHHutb1FyI?=
 =?us-ascii?Q?G57t1JkUHEXpDs57hmzFXTFDyc04c3EWkhE4vLK2X/7QDtvw7IwuvimlEgLv?=
 =?us-ascii?Q?ld1UMkz4hFFkqFQKmF18DR3VRfZKcEtep+YqGGv4ljDROw5rOU6RdnfLHmcn?=
 =?us-ascii?Q?EYfJ/HScN2ZMwM+t4pexqCMPxcyty0Jt21LvQYzU7WetXF40lPdsUOSuF9TI?=
 =?us-ascii?Q?79Yen1bqoVtqGNcx2+CBWeYEKGYiDEbvQctvFk9XX4BgNxGiCzUVZaeGpqiA?=
 =?us-ascii?Q?SZpVzMiuBNbdv8nezy5rEyD516EZ/ucb7a0PjM2uOPl4RtNfRMswqeulah3L?=
 =?us-ascii?Q?iWG8z67/aV5/1Tkq6dYgA9nuNyTYgQIGY5uIMovVtWS4i0DAJaFVeVRHN17U?=
 =?us-ascii?Q?B2kfA6lMD39avp6SAYzutouk2g6Wxjx4zdrHEjlmeqMn5lTS+nCdDq1qrKHS?=
 =?us-ascii?Q?PgqrcbQXYTYOse3iG4qC1ibGzq1wJw6CkoYzBUlHEJnZJLaHGzV+Vy9istbI?=
 =?us-ascii?Q?G/GKjqwfGPDtmXRqzTvk6jLQswG2rPuq/9TZB3Mtv+z9iltDDgW8V/L3Al9A?=
 =?us-ascii?Q?mUWq33M1MJ3mXMB/CRvG3tNBxakchCLnUd+AEYAMpVPLFfor7F/Nh0LFWn8h?=
 =?us-ascii?Q?keJZxnrrhP32fF3QMx955hv6Afqx/vUm4qaumibyzeCyR4Jjtbw4S2MBxSbe?=
 =?us-ascii?Q?ORTJoZA9btM4XOV4x7dLte9FoE1vfIilvMuqiLvByDK3k8YryXpB2gXekL/Z?=
 =?us-ascii?Q?RnofyQYKh8ukHYHWNsNcBlx4Z5wqUIKU2vcb03IhY0XWQk/Y0WyjJa5FzTO2?=
 =?us-ascii?Q?JbOPTroFKD4URfrOZU8ZDlWEfSQPRq5mLo6Swlh1KrQTrsro8Fn2GXXr+vsZ?=
 =?us-ascii?Q?cpV+qa5DcU5x1vH7IScEqf4pr65Op7abpOcbUgibiccqyAQFfKrgs83CNyms?=
 =?us-ascii?Q?X+1cJYn/odI0o2XVPOxeHAZfDIyWEXmFMpL6UwV0JhLM+aQllLALPep6wMo6?=
 =?us-ascii?Q?9uYxMBmZ8mWWjLh+S95MNME7P3TDkRegrSVmycbfYXfyJO6mXSJvm8+PMqTP?=
 =?us-ascii?Q?YAI2qCh6le3jS7gdPyENCqiO9OC5dqB5nEuN3ENS92vV2YWkIAbtI/vX8Us5?=
 =?us-ascii?Q?nx6e5JjAya0Wgkep7WajcJ3jdHYOLehxaAifzC84Crx3iBpFNMiFRowzP21P?=
 =?us-ascii?Q?OEwZJG4gsA/WaC7tSDDZIGHF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586b07af-9e82-483d-0a68-08d993e9f8bb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 16:52:16.1635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2GTI+TAf1llhHY6zL5mYGYeRkrkSaoV9IkWFbgLSrONwmSBgGycQ21kuhBuXzLueIJpAOy5ycHpHbIok7+uaJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two counters named "MAC tx frames", one of them is actually
incorrect. The correct name for that counter should be "MAC tx error
frames", which is symmetric to the existing "MAC rx error frames".

Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 9690e36e9e85..910b9f722504 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -157,7 +157,7 @@ static const struct {
 	{ ENETC_PM0_TFRM,   "MAC tx frames" },
 	{ ENETC_PM0_TFCS,   "MAC tx fcs errors" },
 	{ ENETC_PM0_TVLAN,  "MAC tx VLAN frames" },
-	{ ENETC_PM0_TERR,   "MAC tx frames" },
+	{ ENETC_PM0_TERR,   "MAC tx frame errors" },
 	{ ENETC_PM0_TUCA,   "MAC tx unicast frames" },
 	{ ENETC_PM0_TMCA,   "MAC tx multicast frames" },
 	{ ENETC_PM0_TBCA,   "MAC tx broadcast frames" },
-- 
2.25.1

