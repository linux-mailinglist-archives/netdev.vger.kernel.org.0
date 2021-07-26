Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5153D6503
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240122AbhGZQS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:18:57 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:59207
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241842AbhGZQQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:16:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6CCX9SZeCSUsUbKktjiScMGhQC4a6TKC9KjLJbDGLisc1lMYpPzow1GXRQMM9HdYCPUje3Yy08H6PncQT7qy5vWeqAupY9Wk4cCX5EzYFkZ7dnkcBt1uFQH9MhtfPkO4vPw+gLSO7cTfVj54Xw4ag+2CS8LMXXhm5W/a5/IeQfayQFWmtAYtwgq82kxS/McIL73TqBjSKN0weSCSrZlCeGOgwuR/tQfnHbKhk/4mqdbFF3Opu3u7PK3JxYmQowFnFq2MnCc0S9r3nfO/aOZqCdLOQqu8EMxbiXAc2y1b9/qVuhSH55tJXmkpIEASi+uFu+oO04O2jEj7ocUwe7YqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glUPOV9fjji5oiTAHlt7feLpOsGwWSGXaG3IUHgvQrQ=;
 b=gitExVG41SREBLmWvbIzv+ZPRFyY1qoOpBv5DGPmNTIo1K6RyFhLU1bVfrmjTr1hRGN6G43gzS5FOeoI8koDNDUIgaknxqgm22IYKoQmfLRDwv2XZuq5z6UgHoCpAn7h46fI+eewo0leQ/QFufSmVWimO3mF2Fihtdtz1j54tzAPy0H8/NdU5hszXWNJb2V9lXMrccoJ7tB7NObhQcrClxc97meQ4alVd170UFmxHejhBxkAi2MFcNVoXfYUfauvJ4o0oR5jcgspCmMg3wo3bB9qWgxxa9aINzf3jF50ZIbHmlFKaDbxK4nFluOPzd2soEWsRfOuVcVX/KgtWWjqYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glUPOV9fjji5oiTAHlt7feLpOsGwWSGXaG3IUHgvQrQ=;
 b=TpjWR/KgkIwDUHskdOBuFvbPOtHFPugVk2xvwiqnZaeQiNt9lpyyB/ETaJIvEsSEW29phVUsJFMVDrpifjRHUvnOjOiRYaLkOVr123mdJ36lms4UsW9Zs8hIZu8c5VW1jF7aGDHjvl2OLZSmuW7hcqcIRcmbMVW6imX7aycKA5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7328.eurprd04.prod.outlook.com (2603:10a6:800:1a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Mon, 26 Jul
 2021 16:56:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4352.031; Mon, 26 Jul 2021
 16:56:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH net-next 3/9] net: dsa: sja1105: remove redundant re-assignment of pointer table
Date:   Mon, 26 Jul 2021 19:55:30 +0300
Message-Id: <20210726165536.1338471-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
References: <20210726165536.1338471-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0078.eurprd05.prod.outlook.com
 (2603:10a6:208:136::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR05CA0078.eurprd05.prod.outlook.com (2603:10a6:208:136::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Mon, 26 Jul 2021 16:56:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fdc2f8f-ec03-492b-00e3-08d950563fd5
X-MS-TrafficTypeDiagnostic: VE1PR04MB7328:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7328834DC26F4684CD41FC00E0E89@VE1PR04MB7328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hxd1to1Csta9e96iQYxDSnh571atv5lve+zzCxDnHAivosTJ1SnqHZ6lOFcPCSHxxae5SzP+4Oatr8saKSRfpNmDbNni+RznYFt4zPM76BS4RDRPctv+CxHgeBe2YbinJikkRxbOxV2Pc2cc95hy3yEzLGmVmeQC4e8X/o4jVALQzv3NA5KSYjQCy0n/RJ/JNM412kOSo/Svqwa3QAAThpUXgFMHUJpFtAirH5E+k1xt0gMAeFsQPUeLrapu67pK8ZPln94vLzSdEJU6eBy67o0UtSx+9UqvFVor9ygUnSLrHui5iqmc0rYo5+7Edpv4q+cuNFU8yjC8IEYfUwdOLgzTo6VdAYR6DpK58zMmGWZslvsqNSWBITysGZ02duu0wiLpx8By/VXAhcXuPMFh+mWHXEjnCPnX4uqEmM9mZUxI3mRkZJo19HiGzO00DHpOzhQgULxf/0QRhodfmw3PL2niSGI93+Ks4B1rnxAnrkqF0c/rDtoA9JXClppcOd6FO3hISuoxLqV0HOerUFsiKAGnLh6F45jt02YP0rxH8+7i02fIU6QkGsKs5WsFsFAiD7nVK8t8WD5Dj/oJfkiKJlTAXZBo1dHoCE1smIJF4sxC+VS4fKQkSYl/g4OPyw2C5j8pGvZceUScIx4PcDhF6h4ljUbBAM4KCaIvTImHabpEUfuakOp7aitQuEAcjzmfw7+5qC4MQfQkdJempQD67g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(136003)(346002)(366004)(36756003)(38350700002)(38100700002)(83380400001)(4744005)(478600001)(44832011)(956004)(6666004)(86362001)(2616005)(2906002)(52116002)(8676002)(8936002)(66556008)(5660300002)(66946007)(54906003)(110136005)(66476007)(316002)(26005)(6512007)(6506007)(186003)(1076003)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aqtRSdxmAAZmUo/VNAh291372zx2NBdymyYDWSYgDuug337FlXjekJjJAR/x?=
 =?us-ascii?Q?sBjSrnwH0jlz94/8czZgKgbvE18Ke+OSS5qadc18zs6l1ntuLo29kqZz+V3g?=
 =?us-ascii?Q?3UQPVELihdRFnSi4LrW0fP8Sk61nKAzxyM8HXMDLGhni2zb9C1b12P+4nYNy?=
 =?us-ascii?Q?zYLLfaqCaLiNaBikGUkZV3Pw3AWyUWUT6KKNXi8pQGQuCA2tGP/hNCTPIxi1?=
 =?us-ascii?Q?zl28faCzY7BzQZUl3FHKsDJ5WiG+FoWoIpAgq24EWQkwivVYfUOmwfcoCbzy?=
 =?us-ascii?Q?d/pwGHt0E7t9smVMLR/D2PKspqwxt7AMbG8pwPksPMOYWEl7CY2KyZrqkfQ4?=
 =?us-ascii?Q?fGjImnj+89wV7SG3Dz5SssGn15BgxZJCEw8g3YmpmTb42P5iTAXf1CZsht2I?=
 =?us-ascii?Q?dbo5RkxD+1eqPe8kpVJdMLEEDN181tGaCON2hnd5pUkIY21TLfR7s2b41aun?=
 =?us-ascii?Q?LOjvBb84AfVG27Za8KTKsR36AL254RQ4TYI3Tf7R5sK2L9t8FNjxQk78rKf8?=
 =?us-ascii?Q?Myqd5pJUuCdbP4D9G3AmjsEOhCxnfWN2lM76HmJVxZPH9xTILhqLIQIsRMp8?=
 =?us-ascii?Q?Gp8HWd+zuHj0rvUgalNlFV9OoI+V4ja7v8AoHO4hsMDU0eSjvfpzOCi8Yuc4?=
 =?us-ascii?Q?TKHJrRmnoeQS5qBt5PEk4vk9WvjiAl1xRlG77+fxq2JRIBBLZonnZNabJybW?=
 =?us-ascii?Q?jLYcKoBIdshXDc5ddCQnFu44A5s5KI11lIZzIlTT+biuP7igGMmRQkLoOkcL?=
 =?us-ascii?Q?ShQPvz6rSacCusMZc8LsHw6t7AkguuQEnzNk5yGqeSzEkzPoZLW9SjR+HjPN?=
 =?us-ascii?Q?MJaRFgQdC0GJhd9rc7V2aj3ZfRKynv+yHKD5ZcJ8qTd0xSMZMXOhJLx/oWz0?=
 =?us-ascii?Q?N2lbeaFozd+DbQcqKdf5A53scdbYtNPCode3Xef6+fmpimxsrST19cyO3Q/x?=
 =?us-ascii?Q?yP4zRhGqPQHtLCPt5Osa5Nk8bTRzbid+ET5hKDHctCcIqRqJBThyKw1MwVrF?=
 =?us-ascii?Q?xbbyOP/5XZr7ruddLzDVPrIAixrLuZ74R5MO4CWmvR5sDV0YQao+faiaT+x6?=
 =?us-ascii?Q?2jc0b9GpoVOBNP3AThx/vDs5SOn7CljDtkkAOVaQKt/6RhLOJ9g7xIbSrt07?=
 =?us-ascii?Q?S9CcmHPKvsRl+QeblmYvr77fbQxAlE7+kDo6t8lLikpRzxdNZwK8F7aOgxGO?=
 =?us-ascii?Q?yrfnwy14pC5Eeod8GxuXFSuFMKM0W0WBHcb9zapBDLiL5Ors3aYL7lh2HYE/?=
 =?us-ascii?Q?KAA6x6/LiYJPVcl5ufiWHU/WFOviEbYJ+kXHlIvrpUk9R5yQngtSOA175PhE?=
 =?us-ascii?Q?MYuQ4+/zpq8A0Yytu/y9Fk7U?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdc2f8f-ec03-492b-00e3-08d950563fd5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2021 16:56:01.9958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMdXSjqnxPVuoOM+yNMgddjVLx1XeWG3PW9EmAc55r0x7w8mraBQEt8Ci7BhNiLXqkpNglhN5Wi6r8d1cW3ARg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer table is being re-assigned with a value that is never
read. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 07bb65a36083..4f1331ff5053 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2163,8 +2163,6 @@ static int sja1105_build_vlan_table(struct sja1105_private *priv)
 	if (!new_vlan)
 		return -ENOMEM;
 
-	table = &priv->static_config.tables[BLK_IDX_VLAN_LOOKUP];
-
 	for (i = 0; i < VLAN_N_VID; i++)
 		new_vlan[i].vlanid = VLAN_N_VID;
 
-- 
2.25.1

