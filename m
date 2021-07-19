Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CD33CE894
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351868AbhGSQnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:43:42 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:32129
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354910AbhGSQfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 12:35:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aPG9qe0Z9DD6BvPzzbgyigoWlCXfU2YtmFZHIpdXaZEDvdan3w1XkhVUrFqNLjoqwtGBahiEbJFSxoNkBhryXHvffUX/bCT6AGqKW12CNPrnwxzuerEAFzYaKGYT+VMo20JGT0A/wWBkGyATC7pvpvv6cv2Y386efL+QAp3QHo3G7e7KtYYi5iOaTg5WubtX2COcKuMdzRQDCB/c+QuGITGTjzFkFJ00jKiQZr7kENMMhmfsgBGeCz1JyeDDsokP6S9mKO/OQC3dlMCLrTytrFhcms2RSZenLVpFoCBWlGf3m8ffLn6E7BcH968XI3nhuRcZpJUVD8QJGskJxmOVpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xp5RBnETsVep71WfgWQLK1ReJibtbo7yAg/V0h1MAow=;
 b=XCOGPGyvWeqqwld1gEf4891Y/pRTQsykl3dHlBTvzdZPBWDUXyZou6VNTNFaVYWES8Y/x3YaIqE90DYG95vG3ZmIkR74r7mRwM/2jCgpM7++5cADFeZa7nB0BQnYgWfDAIorm+qL9GXmuUBR5qsKcXZMYyGicPJFcsVhF7rOiO1jbcKu6VtS9D+P1gaJW5rxDEZz2u+cunJWSEc0uz3OrXre4I9CGyecNl1/h1kMKPwzrUxi4tSDpMEKe6cCbYNiHkTERvkCvsIHt1EhKsqsOAXnebotIigC1L0NFp9LCJRL65o6x7qSk5PIxfx6hns0xCkDmBW5ZdYOpb0rb7kjXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xp5RBnETsVep71WfgWQLK1ReJibtbo7yAg/V0h1MAow=;
 b=Hm5GW7X/DKuepz2Pd7ghipsJfiHbSy8H4Rnenn8vC1faEPkzCXkPqbFefQhnUnYMuR5ZckT/niE7Opr3hZamw2S/Is9LwQIkC1cEHaHBBFQFfCP9e1uxCm2BiNVizvwwe0wzupos2vmKMFvHw8eyBt22pIuqggGB/+SDqR4P4hQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Mon, 19 Jul
 2021 17:16:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 17:16:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 02/11] net: dsa: tag_8021q: use "err" consistently instead of "rc"
Date:   Mon, 19 Jul 2021 20:14:43 +0300
Message-Id: <20210719171452.463775-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719171452.463775-1-vladimir.oltean@nxp.com>
References: <20210719171452.463775-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Mon, 19 Jul 2021 17:16:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68ee17db-394a-4264-a4c8-08d94ad8e459
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407DC3DE2A7373B0958394BE0E19@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XeYjFXRE4fgCoWzxIAMA+9lhDViwEpXnlLK+75Yxi8iE1B/O7Ft/nZRqfTSDKVNDexUCB+JL/OeAYmMDiYIPGbM5k617PBFeOl781LoNUwD94KciMe+psoJdvGP5TcPaNNfKgRlbR570gcNgqRzwzctonHBEP07RCHuIM1DL0txExVY7/6NhVxXXlV7jZp6wfmJ5WgI1oYSsV+8+hOPR8Ag86sawxCl+NRABNHRGjUMdBoXEEZaLL4cM9qfPohEkSTqhqDJJRCBlueKqVCaoyQjjDUoN70ZzQZEPKXtj8TKddEkttLivYbVK6Q9VQGJCsC/yODSfrLV90YuLHXJTBAgX6bvfiZJzelmkglKOmlCkadKKE9oa+mH6ovUKO7t9Ny8VNADuBwZyrD+P87DGeVhS+2SSAnruuMA0Acdw5KebfRpG6NbO8Ao0Kzy9G51zAXJrl/uGQJW0aGO0Zzk+MKiFXlr7bTJxiT2rX9wO1OasDVKJL2zSaYskS7TIu+Up6jKgLxGKyzl8DV7tmyhAT0MCbAqcuUGOPSemaytt40HgQMEQhHPJOSS4HnHS4MocAmK+2xgdhd1tN6JwWAvFN7cROUiWoT6+aVwKaqoiRwrn+2OMSPzSp6KUyXguV6xlxLlFbCytn/8yCQkBkQ5F3azl734u+MMJFWM/wLURDqZ1lW44EHt4RdrqyBDCaWvIK7R1oEU5vapdKdMtkJlF/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(366004)(136003)(346002)(376002)(6666004)(6512007)(86362001)(36756003)(52116002)(8676002)(8936002)(6506007)(83380400001)(316002)(5660300002)(66476007)(4326008)(66946007)(66556008)(110136005)(2616005)(956004)(1076003)(6486002)(54906003)(38350700002)(478600001)(38100700002)(186003)(44832011)(2906002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WBjLlKCCEKC9jdg5RS0V7/5BN9CD7hchtq/vfwg8Uz+9ftwy8EH/zF4nl+Hy?=
 =?us-ascii?Q?WKeaddP5+Hg4kttYCdjCKnlyEwtnrbzT2Aw4o/p/oVMv/YT+ahzhUAn0zgBp?=
 =?us-ascii?Q?xKTAoIBQlDq/tvDkRZ44Z/E9fVLqY36nh3J0G7J1ajyDcib14N5nKoXSZqCl?=
 =?us-ascii?Q?Ec6OslL+S+N3fM9BVOHT3ug4OTRl4FRQ9BcPsbHdMSYYb9NGaiAEEC9HjjCj?=
 =?us-ascii?Q?3+ZHNglmV8kCwz7OEF95XMu5z4T+Ox7rXb6Aj25FU6u8c05sZBb/gGhruk5/?=
 =?us-ascii?Q?o/J8rhbrgxdeYANYQLECp8uDajWKqbvTJYVUQL6YPxQjEcaEkNBPkVZmJBnc?=
 =?us-ascii?Q?Mmk53Q0C9Q+jdKNSLSB1cbwwLfNeYuOH3//yvU8yhD4zPVBy/fpIICO97TpN?=
 =?us-ascii?Q?dXdeUlXWtTTjF7KKA1ypMUk9C6AZCGXg6m0/JBaf0rgkI9cHyf6IcOF2/zvl?=
 =?us-ascii?Q?uh8fwuyHREAdaXsXxTuroFADMSCl2EaqGxuhKu1dge9nZYc4dPwCJynwa+TV?=
 =?us-ascii?Q?0b9T6hAn1bPv9YkD7etY3owVvhX2kzFQU7fjv299v7OrjITKiWit4kcgXRAr?=
 =?us-ascii?Q?ECjT6yOeJICcCpH7Lrgo/r2aihW2d1vaPlgcvcJu4uqnl+fy+9w54JYyuFQy?=
 =?us-ascii?Q?/svs0vPQ+LgCriuFmiNi+37w9NbPCTU2F5vBCGTk11UtN2vwvoNIsHtnl8Ob?=
 =?us-ascii?Q?MqTOKRFfRfLIv+sH2YwjPvxe6Q8vxWHGeHE9mXvpf2/Psbsme4o+Bme3OAJ2?=
 =?us-ascii?Q?XnYbugTeg9pTjLwoYdQ4wJyF4N4C8bG3FgZqOLH1JGkYyxsT1FKwrW3kCqJ8?=
 =?us-ascii?Q?/cMsGXD88Gbm7WxAk7nPo/Ihtg7WGwp6VSMRuVffzKMaCgPC97Zgi1L7dbuU?=
 =?us-ascii?Q?4b79C3ZvV6TeJUQoXNmBPaC5fozR747y5OE2FXab+g3sBAECuJcnToEl9D3c?=
 =?us-ascii?Q?qxg5Q0CbX6+pRUOYKJuLy5YlG1PblQuDF/P4+Q18p7khDhbGrCxhCQCU2VtP?=
 =?us-ascii?Q?tMpjZFRtqJPO8lCUVyrWlmbPy1/oWei8qZDuOydVVdM+vSKxb7PstdqPC7Qw?=
 =?us-ascii?Q?x9BFvcdpp3ZmGCniyLheC7mw3QE6vNVVJ/6tMeBAaJo532qSlkDz4NBSkp0i?=
 =?us-ascii?Q?mGtmADFnhHABShneB/JhrljVGBNYu1ZbNC3+2WtVhdy3QJvWq92+LSYvz3ta?=
 =?us-ascii?Q?H7a121f6RW5qEqbdFzwKjNABfMWHGZtaRq2eXJVqVv/GElCJxS0IdCsqF0r/?=
 =?us-ascii?Q?eIaNU7CrgjeMhiAOI2R4l4lz59v/w0wzcpSfnWGBsfZK2cFdWKV9YuGCapPh?=
 =?us-ascii?Q?xRtSGbvsn8LkOMMdeAtqR+9t?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ee17db-394a-4264-a4c8-08d94ad8e459
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 17:16:05.5516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JhzVrNAh01qKViv/juDeUpZGmSvkFDnYbNH2yl6mMEnJm31bXlDnOMj7RbYs9nlci3XcwNWaPWEw+RMCKwVY+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the tag_8021q code has been taken out of sja1105, which uses
"rc" for its return code variables, whereas the DSA core uses "err".
Change tag_8021q for consistency.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 46 ++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index d657864969d4..1c5a32019773 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -259,17 +259,17 @@ static int dsa_8021q_setup_port(struct dsa_8021q_context *ctx, int port,
 
 int dsa_8021q_setup(struct dsa_8021q_context *ctx, bool enabled)
 {
-	int rc, port;
+	int err, port;
 
 	ASSERT_RTNL();
 
 	for (port = 0; port < ctx->ds->num_ports; port++) {
-		rc = dsa_8021q_setup_port(ctx, port, enabled);
-		if (rc < 0) {
+		err = dsa_8021q_setup_port(ctx, port, enabled);
+		if (err < 0) {
 			dev_err(ctx->ds->dev,
 				"Failed to setup VLAN tagging for port %d: %d\n",
-				port, rc);
-			return rc;
+				port, err);
+			return err;
 		}
 	}
 
@@ -357,20 +357,20 @@ int dsa_8021q_crosschip_bridge_join(struct dsa_8021q_context *ctx, int port,
 	 * probably use dsa_towards_port.
 	 */
 	int other_upstream = dsa_upstream_port(other_ctx->ds, other_port);
-	int rc;
+	int err;
 
-	rc = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_port);
-	if (rc)
-		return rc;
+	err = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_port);
+	if (err)
+		return err;
 
-	rc = dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
-					    other_port, true);
-	if (rc)
-		return rc;
+	err = dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
+					     other_port, true);
+	if (err)
+		return err;
 
-	rc = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_upstream);
-	if (rc)
-		return rc;
+	err = dsa_8021q_crosschip_link_add(ctx, port, other_ctx, other_upstream);
+	if (err)
+		return err;
 
 	return dsa_8021q_crosschip_link_apply(ctx, port, other_ctx,
 					      other_upstream, true);
@@ -391,18 +391,18 @@ int dsa_8021q_crosschip_bridge_leave(struct dsa_8021q_context *ctx, int port,
 			struct dsa_8021q_context *other_ctx = c->other_ctx;
 			int other_port = c->other_port;
 			bool keep;
-			int rc;
+			int err;
 
 			dsa_8021q_crosschip_link_del(ctx, c, &keep);
 			if (keep)
 				continue;
 
-			rc = dsa_8021q_crosschip_link_apply(ctx, port,
-							    other_ctx,
-							    other_port,
-							    false);
-			if (rc)
-				return rc;
+			err = dsa_8021q_crosschip_link_apply(ctx, port,
+							     other_ctx,
+							     other_port,
+							     false);
+			if (err)
+				return err;
 		}
 	}
 
-- 
2.25.1

