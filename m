Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B932938AF42
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 14:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242769AbhETMzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 08:55:02 -0400
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:57731
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242713AbhETMxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 08:53:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLRAMgOYPEI+JfVrAbQulgbvn/++nH8gtz4hldHdMrrxobSMk2zguzJ6jfB+xWa5a6hgQwYLTiZtLJV2blB8vMSb10wpxVWukAg+1pf+cifl9IcKxFQzY+YKycDTFq8wMTw+OQXiK//6bPyIopsf5czztXW+ODgQIutCsOIg8V+K8IoDuGomTs7U0slFvA8CHMrU6gfoUjUjQs3P0FhgptEXvzKzi31Ml8f+hw3dB4Ck7+YfmLAnYj5NTfGAWLNraEBIA/xbBcqH+lONg3NAZ+TZMzz9eZ4oIvbl4wv14Og9yfZB2aUZ5R3Z5c9veKun43GhzRuUG2DvHO8Few6Pkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyCKQUw31Te1w2jaesK0wy8ITcci/llwDmppkE83LC8=;
 b=Xuq3RGxLJE8K5jf48oDzQQIZyyu+00EVaqKxiVfRG+zpOmiG42lRMqcoctenSuG4L05AtDXk2MHswLS8qt2lCsn0MC63h1i1qIpolXq8TuWiiUady9LuSlfehficeF8UiKrRT3SurZd+zErh4/9oZomMgmwE4TFiFLAt85rtEM9BdGqnDrW8h2FTMnipjk5HVE9OM7b7h11sP/+3H2fPwTU5mNHnODfsAdcwBN9vhoYCVVu84hjs7ve5sT/qkVkhB1Ho2ohff0HWpxjlwJmj0Uj9+yHUCnq48oajqgwLJo4sZPvATuKg2pyud87LyyiN5WgIOBHMwp/tAlhNu9KHbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyCKQUw31Te1w2jaesK0wy8ITcci/llwDmppkE83LC8=;
 b=J4nVDSR7x7fK4ivEXHPUNbkWWE3kpas+OjlPZweMfIRQ1OA7JIaUEfnK9a8RrkxBDZ2kDaNISQOcTgarTfEq22rppAtYSiw9KqZgLzG3mUKkChWHRO+PPDjymUjy+8MtOiDKnIHEt5KQXezYXRiUBFSI0wgXCOWkvd3UJWEqbfg=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6345.eurprd04.prod.outlook.com (2603:10a6:10:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Thu, 20 May
 2021 12:51:27 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4129.034; Thu, 20 May 2021
 12:51:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net 1/2] net: stmmac: correct clocks enabled in stmmac_vlan_rx_kill_vid()
Date:   Thu, 20 May 2021 20:51:16 +0800
Message-Id: <20210520125117.1015-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
References: <20210520125117.1015-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR06CA0095.apcprd06.prod.outlook.com
 (2603:1096:3:14::21) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0095.apcprd06.prod.outlook.com (2603:1096:3:14::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.32 via Frontend Transport; Thu, 20 May 2021 12:51:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cafbf416-0caa-46e6-d020-08d91b8dfb06
X-MS-TrafficTypeDiagnostic: DB8PR04MB6345:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6345F2979DACFA3939A67FE7E62A9@DB8PR04MB6345.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:151;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kD+qDhAe2R4q6IB3Hway5ALYSkJYZdVbGm7OFtIIIjh9nezmHfPJmtU2Td5XJ6cuWz5yMWwz6hwofIVk5iz0agce8QXa3riiT5CHVuSOyuTDGpWzhfz4p1ixb0+KNSxDk2dxwVeDA98KVGZpdVIwDJ/t05sOxz/YphJJHoeaBO3xOHwVIJ3y3rwuQuiwAuhOSGwOqVJ96ZIooG7ZJ/hfxbEi7q9/a4nBJ/HGUwaWriBurKN6n56En4paPKSOS9P5321Aox2iEQmSmK5POeB87+jfvB5XSaxzlU4H9C9YxPwBg3IVtNqf9jXww0VMkaqkfGGujmttrfaQ9KBQ9KiCfMrvE0NSQMhOq0fRWU2xp7Vsij+idEyzrkO7CnRc+ps3OfXJueVedJzMnzn3eqWG5zAEzz029SUmuRQoEM6Gx5Bcr6y4HAEIknR6ja0qsZKC1kZSoV1wZSX/JNfajDMwn4xOgABP7pguaXVAoyo+6OjBab3pwt2PswQK7P9YBPgtlDR/m6LSJYTwQeTu7biB1CAvjkbDqkg3pgsE2Ygj8aHkgrZkoJ1JxTLJKA5IRwC+f0Xg3c50YE1s9IzW4kA49+UbtHo04LUMDGL9zFmgoAAA/4n//qWS7L68nGM/55h0i8z/es2ZiSa8InkR9lx6LNgHnewhtDiod3X5VZ/dAAXYLSXE2WVqkOZQdtLTxbN1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(366004)(136003)(8936002)(38100700002)(38350700002)(6512007)(956004)(36756003)(52116002)(4326008)(8676002)(7416002)(1076003)(6506007)(5660300002)(86362001)(316002)(26005)(83380400001)(478600001)(2616005)(66946007)(6666004)(66476007)(66556008)(6486002)(2906002)(186003)(16526019)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qeK/tXs4I++ScpCO6clqbbkQvB+xS9nnRGf8K3rwA1WpYqsAonp0cm2w+49i?=
 =?us-ascii?Q?EYtTfDwrj6j4K8Rxs2deoZU2+IAXRJuZ6bgwbe3l51hFAhgl0pEYDELnpamr?=
 =?us-ascii?Q?QK6bh7nn3diasitJe01Ozdtwcs+XTMxopy04heVmKh/PmWU7x1O0/ZV7Pxwl?=
 =?us-ascii?Q?We5hyh8q6ryqlTk7NZi78PVAnzIui8JOz711SDZ8GkvAPKlBF7rggfsJ83Y5?=
 =?us-ascii?Q?8JNS58R0AuppKKSGQ4AuSdkZdIH8ap9joyFlizBy1ZPwMG3ilsC0bDCrosU6?=
 =?us-ascii?Q?0g7yeWPjDNd0Ah9t+YLpUAgdoqx5eXx9vcz3v41tbTVh8CB3/75jMeajCV+x?=
 =?us-ascii?Q?qJzUXbSm4BoZfo3SlVJIVBktrL/aaGjkE+CMqt85Ff/zh/3kST4+ltOHBXfQ?=
 =?us-ascii?Q?Y5RXg/jw4Xh1XGOCvDc/GAKrW5vvSi+9sxUG3MV4u5w+AOZxW7FicNotBT2G?=
 =?us-ascii?Q?QBnSpFmS5gGVaen8OPklzw+n8EUfgwUc9O8cpjQeJFT/Zy6AAVeio3rsbAqp?=
 =?us-ascii?Q?av881/rzzGaU4WEuiIh+fiav+e0zRJBZ8scpwHm8we5N/8z+4kovQBkFyRPX?=
 =?us-ascii?Q?kkx6Ej0xCNcNG0Eddmcz9zTOHpo8kKnrYlNyBfmXRZ02sI2PmfpAtw0Dp3+e?=
 =?us-ascii?Q?xf36MqFOoGAdpGRA148t83PjKiv5SWJWn19iJZoVGX/EOvGtLR1m+zg7xPkf?=
 =?us-ascii?Q?l8eFkL6tHTIlYccl2s6zHWn416O60zTrOGLpWfEdOS/90uGASA+OjE95ArME?=
 =?us-ascii?Q?YvklhAI8OwBlhMMyJegUM1iMwRsFAMVliqvXAXgB1XVAEKXYTKZuqYW6miXj?=
 =?us-ascii?Q?YDoftXU0A/Ris2zG8dWgkh8PJW0RRJGdCjUCX71pOmhbJfVCQvVLqrEjNvz7?=
 =?us-ascii?Q?APfOHhYwthvQiowWLROJQl31UlyRm11ZqwtKt3NPw+OYOEncwS8ht2TZyzXk?=
 =?us-ascii?Q?pZ3fZiUWKH+Xop7i5/HAgipsy6LMAKWmcoMQ6ZpIi5ORs2yy7Rp/GtsxOVLQ?=
 =?us-ascii?Q?2afrxsQ1xw5kH4UETV6ubbBmNktK1Ju2VPo2r/0LvBQ8BqyDTBAFXY6fJMdP?=
 =?us-ascii?Q?jbXy4CFjOFXwUA2UiwCm8eqQDzhxfMZs3Lp2D3D7jkP5VBIZc+HkCCdtSvT1?=
 =?us-ascii?Q?phUtPZ7oUAPhb9GAyzm38bURmSPStomuYNnHuqaubsn5hhggxcinoj8t7xxu?=
 =?us-ascii?Q?Vpgx70Vvbx1C+UBvdmR0uoo8xZzucWB7kqSRMxaHd0FfL77YM2/s1o/VFxsu?=
 =?us-ascii?Q?hmU4L678Ae7HSbWgE5266JA6eDaGK/jn/Kb7oxrrLMvXuwZLcw2dBPsj96ez?=
 =?us-ascii?Q?ZQu6angMJprkcX3mLWbJE8hO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cafbf416-0caa-46e6-d020-08d91b8dfb06
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 12:51:26.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUS6XcjLH+AsR9CiYEqLJ8kwfUA2AYnC9WRsUZHyCkznw54KnKovczhYfIa6C/9dcgBXKGZMDOzC+c/B2ZBvIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6345
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should be a mistake to fix conflicts when removing RFC tag to
repost the patch.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fea3bf07ae89..df4ce5977fad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6191,12 +6191,6 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	bool is_double = false;
 	int ret;
 
-	ret = pm_runtime_get_sync(priv->device);
-	if (ret < 0) {
-		pm_runtime_put_noidle(priv->device);
-		return ret;
-	}
-
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -6222,6 +6216,12 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
-- 
2.17.1

