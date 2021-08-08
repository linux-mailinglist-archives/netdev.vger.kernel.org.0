Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00713E3AD7
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhHHOgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:36:20 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:17029
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231825AbhHHOgO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 10:36:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhuQ9z3jyOLw6OwzMw2KRG/k3hCFir9gKETAi0r+zWNxWqwOvVGUcNN2b7N4mtQy+NTWa5TQSmjBCUs4KAHQ+pD/apPiZis0xnyqlru61KP2lHb4e069TPzgvp74my1ys56QyQQch2W1uWNdcuEEWQCc8GrcFRkkdfgzHEwS9Kt0Gh4RHL7qGtwPwHfSSZPBRc5K5Rpz4/ZiSzrgHzlFL99zadez6tI3hOQo2lfQdYM3cRCIv02YyKzITecyDWYssUq4O3Z7WkSv2oEMzCAvOhHX7D5qRQGtidGdkaZYkAYZgPURyWu0BBWq7Gsux15RuOyzNa0fXz03ZqVz1FE/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sdk60Yfjh+myoEeqT2Z2gVN+a/ECsZvt6gey/Z9dTQo=;
 b=L8x87XCw0z3NANkStA1oLgpsYjX0Px1FKegs+ssobajkwoviiF66S0ClQMnVXbkLyOXpGqsE0ZatM2x52lwirukItW0R4DMCiuDB1wi2SxpwTHrrHMD9MOtQs6p6//IIWM/Gx5S5yIOmTqL513rZ/biw+A92CMzPRKtBF0tD1vpGBbfmOjQ1+pWm0EBAFLI1qO+aiuj/ynBtoNsofUHQOASIsPCTkbGTeM/PDOk/EfE15vWIzGmZ2hInvY6sns/zXl3kNujlYVFjg378oir3nMQPURb3QnT666zoiomSuFOtf3UZcoo59x3zXkplt3K7CysF7nEUgHBzT5Fy46ywlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sdk60Yfjh+myoEeqT2Z2gVN+a/ECsZvt6gey/Z9dTQo=;
 b=AHhbOYySzgu3n4qB/2on6MJM6aIgJcb5PuNcEc7bEjQW9y/ScKgRXbNwSc3Z30JOfJtz+Kv7cjnmWR5DpwmK0o1jxx+zQQCNNx5RcDkQKB1rGPhMOZhOxv3RGxfNNu0D7xIFKpi1j/F8bkFEEyLZajnXEQjRq568a/atuxozAQs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 14:35:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:35:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 3/5] net: dsa: flush the dynamic FDB of the software bridge when fast ageing a port
Date:   Sun,  8 Aug 2021 17:35:25 +0300
Message-Id: <20210808143527.4041242-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
References: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0003.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0003.eurprd06.prod.outlook.com (2603:10a6:800:1e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 14:35:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50dbb95f-a24c-4333-97a7-08d95a79d148
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301731F0EF9EF02D8DD047DE0F59@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aj6BegeCGTwL70JCIzDB5+C99RRCyNurAF8j/uEB6QT0oUDjc80S+SX61qH+zlSFABNjV502kNovPufpWKMbQnSWuKxcRBHrrsavfAiV03v92wZgS16vRia4pNH3z7qHRW0KhIisQqsTOBi/OtsgKfqhLaf/OrZiwb16CwF/vo45i1KxZYiHAffR3gh7EswIIlboLFx61sW90kUOPew3x6U4QL1bE9bhx9WNVBL3790wWSU9ekdWhdBRe6ZQR1vbiH+EFUjwpg6VKKeq4H2TWZzz6st4pFDh5iOSw9uSf18IlLM7DQ2ohej3olNQ4IgayJeBehQ0qM5AEV4vFXrs32NimdYIAV5x/l8X2CgOBciIEWCLJx0sZwSph9x6j959ysb4Uu6kXpG4z9ZsOacMotl6sXA6ijhEL09Wd2jm4vsM+nHmut5o91GvFoEyDffHJ5udmBvluHiyeVxljRHvWwhL+0ohFkJ5/9Q4Vqv4Qp146PAyd7EQSpW6wnQJhcxZ+PwZNlQG3ofjnu2cZvQVOOKasf5zz+bK3yUGfVO+oFOmeDyB8aT9DJBDm8cftAoTaz9X7VZIdltrolEj0fZQ9raSNdSYf5ieWhHsKwIGHjL5rbw9LuW1LcLW16lMs0sEs2fF/onyfMkc3o+3Kn7xo9QNHwjER5DUW5AmgUpBYAwqyOldKo1YkrFGxEJTjOkpkBxLUDNZzb/Y+CDCd7z0iQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(7416002)(36756003)(8676002)(6486002)(6512007)(956004)(2616005)(44832011)(4326008)(6506007)(186003)(2906002)(1076003)(38350700002)(38100700002)(26005)(52116002)(66556008)(66946007)(66476007)(8936002)(83380400001)(6666004)(110136005)(54906003)(5660300002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1dSI65mM5YFzOTWXnyela9TeK1vx3C8JwqD78uHy6ZxJCg+ZfWIWqn5w1wC?=
 =?us-ascii?Q?0inSAtVNbL4o73WfCXz+KOJsKwIlPvANx2h2ccpuiLCUstRmtEHZndDVkFj7?=
 =?us-ascii?Q?G3Vom1EANDZsKSmYqQ2by8g4vo7mqXzft47ShZsN6qsdHTWpzpnrVxyqcwcr?=
 =?us-ascii?Q?I/y+/HMxqZU5e4MOAjxod3Iitq3EvyyN3A8vJcSIWey+xVMgFnqdaHsjFV0H?=
 =?us-ascii?Q?Wa0Oi/ALTNkPBKXcfSQINYIX+mtY1nH4xdVKVYTIPPg5q+U3t4RNXUyH1m4E?=
 =?us-ascii?Q?p0uftdzmDWMeIMRT0FMRGG2beTL/fjB3JxoP2xdzciAMQY4Cx+WhLpbL9POM?=
 =?us-ascii?Q?xLNNkJT6ANp5GZnFXZTwWXSmfrHJ4e8VkGBI7Dt3UeHOjhxmcnH2vX61c2Ea?=
 =?us-ascii?Q?6kThtutIldf/wfXDFrdIIvAn3s3GAYOdQD+SoFSLJwh2mSXjykCxStU/1Rzv?=
 =?us-ascii?Q?rFSMA+amInozDPlVYnukL37SIufxvbrDyeo4Q/FxjIJN8D+8DU/LM8mmGCIY?=
 =?us-ascii?Q?/25Sq27vJRbd+WNVJZPRvjStZzXwMMeqeDpqXrJ9V9LWnxoHD3E/NkKi+SML?=
 =?us-ascii?Q?5EytAi2HMF4jYNAJ8RLdbj31kedUVHDW+UhlYAzUnODL2ApaIPX1QKuxH1Bs?=
 =?us-ascii?Q?89ekLyVJyvpCWEoAuPHLaBRubEqFy8T9Bf3kd8s+m7RciCrSGhcl4EShDbiY?=
 =?us-ascii?Q?lJTQORwU0fKxQLUBm93BLDrjIEgteBcGL7odbNGvbe2NKyrSdXmk5MJbmMaw?=
 =?us-ascii?Q?y69Hxywx8CRWAimHVpk5n+C7mgB5ZaP5NegbM+gYfs4P/9Xoxid0gCL9+57l?=
 =?us-ascii?Q?RMUn0DKe2678usWbzyxi4gwluttx2+7tHlxqamXh13QLeqc5JxUuqFr1r7RV?=
 =?us-ascii?Q?dO3s89HliSuWrH5o81g2Bvbw3iwb44+QALa+vgTUbWzmwkoRDrgTyuBq688J?=
 =?us-ascii?Q?i6EEOd4JnZjEcijAuXmpy7YbGuZ2nsZ2qbv6uCy+zF2yOeCPu8LAwdsYFEgB?=
 =?us-ascii?Q?lD/pbrYIwSh++m7U0UfvErwdgvzNyGbC5jMr0u28J/WxCXcBYdmM2CTIQ35f?=
 =?us-ascii?Q?Kb6P2GhVDTOTMdiQWSWSDiGnLiIwtMqOHScUvkQXEsj0rZvi9NbbANTe/2/v?=
 =?us-ascii?Q?8u6sxEFb6qmaPrc9zbRN6Hbv+0RXcNuK5EDnVZ8hWLkRqJ17SW/eNTWfnZMB?=
 =?us-ascii?Q?gMcBsWaSM+5XhhoQrMqH0c2g0TyEcClftADVZdGZJsSTQ97cnjFrzaAOfKyY?=
 =?us-ascii?Q?QvTj52iS0hwv8Sr5ubnWwVxJeXzeisB9fPPAAWCXwwsTiyo+EFREPcxxfvMU?=
 =?us-ascii?Q?z3hUAmKeD9goPKKWdGLwzq8O?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50dbb95f-a24c-4333-97a7-08d95a79d148
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:35:49.9633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zhZ7HfgB5XWEoWKgjAs6OZW2soaXcW0XgQggbzAFPoO7dQ10puvf71EjoWid9YQQZY2ebGfKzJ4/JkB6xRxow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when DSA performs fast ageing on a port, 'bridge fdb' shows
us that the 'self' entries (corresponding to the hardware bridge, as
printed by dsa_slave_fdb_dump) are deleted, but the 'master' entries
(corresponding to the software bridge) aren't.

Indeed, searching through the bridge driver, neither the
brport_attr_learning handler nor the IFLA_BRPORT_LEARNING handler call
br_fdb_delete_by_port. However, br_stp_disable_port does, which is one
of the paths which DSA uses to trigger a fast ageing process anyway.

There is, however, one other very promising caller of
br_fdb_delete_by_port, and that is the bridge driver's handler of the
SWITCHDEV_FDB_FLUSH_TO_BRIDGE atomic notifier. Currently the s390/qeth
HiperSockets card driver is the only user of this.

I can't say I understand that driver's architecture or interaction with
the bridge, but it appears to not be a switchdev driver in the traditional
sense of the word. Nonetheless, the mechanism it provides is a useful
way for DSA to express the fact that it performs fast ageing too, in a
way that does not change the existing behavior for other drivers.

Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index a4c8d19a76e2..96a4de67eccb 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -30,6 +30,24 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
+static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp)
+{
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	struct switchdev_notifier_fdb_info info = {
+		/* flush all VLANs */
+		.vid = 0,
+	};
+
+	/* When the port becomes standalone it has already left the bridge.
+	 * Don't notify the bridge in that case.
+	 */
+	if (!brport_dev)
+		return;
+
+	call_switchdev_notifiers(SWITCHDEV_FDB_FLUSH_TO_BRIDGE,
+				 brport_dev, &info.info, NULL);
+}
+
 static void dsa_port_fast_age(const struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -38,6 +56,8 @@ static void dsa_port_fast_age(const struct dsa_port *dp)
 		return;
 
 	ds->ops->port_fast_age(ds, dp->index);
+
+	dsa_port_notify_bridge_fdb_flush(dp);
 }
 
 int dsa_port_set_state(struct dsa_port *dp, u8 state, bool do_fast_age)
-- 
2.25.1

