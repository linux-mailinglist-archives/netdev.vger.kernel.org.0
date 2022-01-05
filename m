Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E0485C29
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 00:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245337AbiAEXLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 18:11:44 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:32794
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245333AbiAEXLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 18:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPVoh/ZnVEiFxoV0BocRgdwWJwxJTcWxmw8eu9dfRlznsVzqRF5Ft27Gd3nJ9MtcZB/dkBSfTj2r03Lv0LgmokkdmxHxgZ6t4RIXwmHQLcu4Ey3uMhR9u1r9tMYZ2aG4z84yKrCJdw0mAkFyo1k7YQV9bg5CjeiCs8AJTSsRQwAzvlcGOER0I80Kb6Le/Y0PugFo3e152axATGQo60vjfq8nSAHo4e952m54Tgfzm4C+RhYYVJySCIYVNGc8SaKEPtruHBRJCpBWq+XgWuw/X1OAjJ2h1uxyINbY6ob5osdvgkmn+ue7WKW5T69eiFIrNqUJ3c0NOrDSmZhAoVaQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Upnww5Kxt3iRPOD4GahoCuVg0nClluPFx2CbK6aZWAA=;
 b=cg70gZMmHSnmnYMEoBmnZhijWAQBQ+vYPlUSqKZuGbEARRBPnT9hsTbXA1fpqAMbaqWtqvAiLdGitbZONz/n2upSeGDCvSvWZP6Lr1NGulFVZvvAW4foOl/jP5UBBlirXWYSyiVl+95SauwQeTMBB0jUMtnTr+mepYPVdWLiXN+eApbplB4pgr8lLE0e+ChrJ9uUpnKeoopA6S3Dd1P7+udeHELIwc/OtqXcWZtdLqYbgNZ3N/klMxoJjG9V+0DnXAulYZXmXEtLUn12BRkuFTP6MoUMc8gS6QiwXrGnrNEdqe1d3Zfdj8oOlbSsQ3PR98S9UVFoxfb3f5VgHu/EtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Upnww5Kxt3iRPOD4GahoCuVg0nClluPFx2CbK6aZWAA=;
 b=KSLEdb4AWkopqLqCmhlqLiQnecPcv8M8ywTbkuBKSvhPN2swGBavKqSixMTFoLInuhlJbfzdkZ4mLg6o/4tKQeU/sAKuykAiQwmiD1VKZT3QJn+gR94mp7/oM0oODBXRdz7RjVzCGj7hjZqwagPObSHkdJNaNhUfJ/JtyInT4RE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3069.eurprd04.prod.outlook.com (2603:10a6:802:9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Wed, 5 Jan
 2022 23:11:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 23:11:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next 5/6] net: dsa: first set up shared ports, then non-shared ports
Date:   Thu,  6 Jan 2022 01:11:16 +0200
Message-Id: <20220105231117.3219039-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P191CA0081.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb552f8f-3fc6-4020-87aa-08d9d0a0b776
X-MS-TrafficTypeDiagnostic: VI1PR04MB3069:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB306995E2B8FD461B5EA71EF9E04B9@VI1PR04MB3069.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: geViv8RxZO6thgHVQwzgZ9vnQRVGniSxnkjWr0elZicC7I52Z37JdUrskig2kUBcJd8fA0NvYZw5+Oo6QyR0qls7Vr40xP2AEsDvbZLzMHjtNMd5lK1YV0AwibX8IO/QbDRl3ThFTlCM4Iis1WaukqpES26fdCbUYO339aYTlD0V4JGjEeBI3XNODP5yW0BJ4Ay9M7VuyIJJsDptDPUI5fhz9uDTWL7hebicmgqLmsTKuAkZA9BZSr9E7NDlSOzH2p6KZaaQUVYqgj08Xgl2tIE439lAnVsPa1uQeT14BJ5palqlyeqJ4dH1iEMfoRpA+pOvC6eBwHT9rBru+Fcb/b6U9emgcFjvb8PsoEixXxO2a4qCcWiHG+XOaUtfDRDZso1bynbre0x5U8r1hF/8A8Ycqs03lW2l9VILVBf995jaC6intk0fsG/lpxB44SIiCCi9F41uUM5N/K80imTh5YkRigB0LK5tYA2g6DZ1J3zbf/lVhc9h8Iqbt3fvRhuxrD15t7m8h1tVcHg6bbWU66NAtRkWTh57Whj4mA7nlUBJrskqxe57aikPQljzV6vY7gBvAe6RgkKCndd1o5imiu10D4tGiE1lqu57IoojCtN56QNh7Ku61U4bY6Al1xu4A8InG56ng77ZC7WK3dxT7nvND2MD2is2JkcxJ0z3+b0f39/1CxVSsmSZgsQ2YmjZ/uJxEOH+WTrhrtR7rCWmyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(5660300002)(66476007)(66556008)(66946007)(36756003)(1076003)(38350700002)(38100700002)(54906003)(508600001)(6486002)(6916009)(8676002)(4326008)(6512007)(316002)(2616005)(2906002)(6666004)(44832011)(6506007)(52116002)(8936002)(26005)(186003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1vSLJlQ3xeh3fM4GmJb/qD2W9Zuvs4vxqcRWqe1ExbxUq/7fvonIxuErqRs1?=
 =?us-ascii?Q?/V4h9jGFpdm81NGmOUYlu3XaiIJWW/d0wp8tjFxOESP1fjXOg+GWJir9s9fm?=
 =?us-ascii?Q?Zj7SoMbvjxY311JEJwtiJhLx4JQgc6lZIx8yHP3fcPgPxxZi4bgEehld+6yj?=
 =?us-ascii?Q?cwzf0AK79bH7plZL/sU3xrwrSKt3C7NaLk16YHno+OGmM/qnLBAK3LhxwJ4T?=
 =?us-ascii?Q?vePlKGTPwk87h6JYj0HqImRtuM/PCH/nFayu46nOaHOVRNpjnOMk3KuPsXQD?=
 =?us-ascii?Q?69iYRKnKpUX/8XtmE5QhvDqqHm4STpIF+X3NRX+Y0RXgMroBP0n1/nTHiu71?=
 =?us-ascii?Q?XuoKY24izalyM7ILnrqN+8FqKMgJqytZF8UO9OSI7J8sQ+pQwIzUP4sXjKC5?=
 =?us-ascii?Q?OaRCB04yxQSu5cw63JbflipKx0yGhwNrsW/bIkRIVbcDwg6hKxzooMXqYlOV?=
 =?us-ascii?Q?MaKVUJOa9gRaMv/A1tCPp7pyLpoUWdMsAxv3p0Wl8D1Ca46/AtrBZl5WtevN?=
 =?us-ascii?Q?leam6PhzZcHMRJntS9Omz5qgDc2xcqLdiyvEN6fxcqAuLLWf2u2V4tBxl2R5?=
 =?us-ascii?Q?heQkaOjGCtPhInM318Sg6BYDldWexww0tsFyUAHZNg2AzDtTGEjHmeSCJHHs?=
 =?us-ascii?Q?ixxZMelcPbR4kC2mAvmnzyOilv4UCK1PyYFUC+PtDXf7sbcTLCrwiOFjzyxq?=
 =?us-ascii?Q?QSHgdqvQ36wKADwDzln4uh+fk3FsPF1o/MHa1A5mWbLOLWG2sbpCoaQ0YVwh?=
 =?us-ascii?Q?MTl5YgQX4h2s0dDvE9fUwb+tHj4o70ewrQxGDV46xUpkARF0jQdh5hySN4Si?=
 =?us-ascii?Q?r0fsaro+YO4uWpbhSbQ8F3ew3JzN0RGWty6ex7bwsUIMiX/bV+XxfNUFFAT3?=
 =?us-ascii?Q?0yfc2Td7qvLECrhkdqYvF+0KP3WQ2/IPhsaIExsGaawk537Z051oqHqZHW5+?=
 =?us-ascii?Q?QS6vbajUengAI2CBCgvSFKwFmEqqrZf+L04sOdrmVU7e94Jd7MIeFCBB0PGn?=
 =?us-ascii?Q?ZyT3FM701v9j3kK4inveHpCqyIrm4NhpTs8214KdPFOOtBlUV5a34fs3X/nA?=
 =?us-ascii?Q?ICCp/ELx2VaM4OwSq+zv1rPVfeHYWFSWyPJpBjbScdhZMUAYMO5eJKyx42ey?=
 =?us-ascii?Q?XUih+1cgeKT/SUWfPvAoQccshYLw/heUFpSj9veXIm/Ag2DoEqhGrgzUhDCM?=
 =?us-ascii?Q?SQYrDA1rayIFFXyhyxhoqjvAcgj2NnhNnP624lbwSjAL2cLPLVXZIL4Jbw1/?=
 =?us-ascii?Q?agEcG/Gr2qad9fDmPOa8YYKE7yy42hdtIpschZibmxEmmH8HBfI5rtKdP7lD?=
 =?us-ascii?Q?OsJBUZ0ls7/i7T83sp5ht35/Hi5Ett6RfqIHXhVPFXADeBXPG/4GhRedm9Q9?=
 =?us-ascii?Q?bNMhlilrF/sbn8P4E76FGzKjNu2+HYSn63zD2M3k+MUJuYqs9U2mAF0P8US0?=
 =?us-ascii?Q?clUuLUVsi7dn+3nWkDte/uPz5gNqBwZcG9F2+2j10qqFmacdi4VAHwdOieDu?=
 =?us-ascii?Q?XxKPMsT0yV0+wWPJo+DntkYJ+GC5Wfa9Ba3QrXfpo6/JD32LiZr+nO+okizE?=
 =?us-ascii?Q?er8VazUzqHofGhQQEwDc65g4XWslaqTYaPs1hISGKjqueKUKUdKmWTTm4ZMq?=
 =?us-ascii?Q?0dO19AWAqvgtM4UJo003F18=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb552f8f-3fc6-4020-87aa-08d9d0a0b776
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 23:11:34.2697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSQILnIyrJxwxD5ux8vCN8dvXHsQVFz/FG2y6CfboT+qwePVEw5Fr3ASXV0rLgPe3p0oTPxQRoIKiB6FzHDsSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3069
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit a57d8c217aad ("net: dsa: flush switchdev workqueue before
tearing down CPU/DSA ports"), the port setup and teardown procedure
became asymmetric.

The fact of the matter is that user ports need the shared ports to be up
before they can be used for CPU-initiated termination. And since we
register net devices for the user ports, those won't be functional until
we also call the setup for the shared (CPU, DSA) ports. But we may do
that later, depending on the port numbering scheme of the hardware we
are dealing with.

It just makes sense that all shared ports are brought up before any user
port is. I can't pinpoint any issue due to the current behavior, but
let's change it nonetheless, for consistency's sake.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 50 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 52fb1958b535..ea0f02a24b8b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1003,23 +1003,28 @@ static void dsa_tree_teardown_switches(struct dsa_switch_tree *dst)
 		dsa_switch_teardown(dp->ds);
 }
 
-static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
+/* Bring shared ports up first, then non-shared ports */
+static int dsa_tree_setup_ports(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
-	int err;
+	int err = 0;
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		err = dsa_switch_setup(dp->ds);
-		if (err)
-			goto teardown;
+		if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp)) {
+			err = dsa_port_setup(dp);
+			if (err)
+				goto teardown;
+		}
 	}
 
 	list_for_each_entry(dp, &dst->ports, list) {
-		err = dsa_port_setup(dp);
-		if (err) {
-			err = dsa_port_reinit_as_unused(dp);
-			if (err)
-				goto teardown;
+		if (dsa_port_is_user(dp) || dsa_port_is_unused(dp)) {
+			err = dsa_port_setup(dp);
+			if (err) {
+				err = dsa_port_reinit_as_unused(dp);
+				if (err)
+					goto teardown;
+			}
 		}
 	}
 
@@ -1028,7 +1033,21 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 teardown:
 	dsa_tree_teardown_ports(dst);
 
-	dsa_tree_teardown_switches(dst);
+	return err;
+}
+
+static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *dp;
+	int err = 0;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		err = dsa_switch_setup(dp->ds);
+		if (err) {
+			dsa_tree_teardown_switches(dst);
+			break;
+		}
+	}
 
 	return err;
 }
@@ -1115,10 +1134,14 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_cpu_ports;
 
-	err = dsa_tree_setup_master(dst);
+	err = dsa_tree_setup_ports(dst);
 	if (err)
 		goto teardown_switches;
 
+	err = dsa_tree_setup_master(dst);
+	if (err)
+		goto teardown_ports;
+
 	err = dsa_tree_setup_lags(dst);
 	if (err)
 		goto teardown_master;
@@ -1131,8 +1154,9 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 teardown_master:
 	dsa_tree_teardown_master(dst);
-teardown_switches:
+teardown_ports:
 	dsa_tree_teardown_ports(dst);
+teardown_switches:
 	dsa_tree_teardown_switches(dst);
 teardown_cpu_ports:
 	dsa_tree_teardown_cpu_ports(dst);
-- 
2.25.1

