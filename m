Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F1E435201
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhJTRwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:42 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:48103
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231173AbhJTRwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kMxv5uBqazZ3IHK/MOnsQecoNXWbBylu5wzNBZx0HYVeg7Fr+cL2IJgvKSRbr/GG0dio1j4/WDr12ro5Z/MwmVJNPa0ofy540bIYAGqoIBRuJhYRXg6POJinU7FD1V3kkfRlD7YWFYsuUT8R10ydGH2dDoSUoM+i1MXEtRFclSkZDFKI5OVg47u/4bizAjwfJ9D/5zf/sy8CEsjxoK81H6RsRcvAPMYaLnyvVHdHwSy3+XdFu7YaUocde7IoWvLmlJkGgsdq+jHX3aNVdb6BNJztn8pWAzWFDqScDRsjBcxd2qyrnvLWAWNsLaMn0dFNAAYxX/AvpLckJBdqhMOkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tr9Q7HzoU4x2n9g2S3EJrVYxlM2/MuwLcDu5YdsiCI=;
 b=CxhQ98wxWeoyea2n41pkGaeDEBosMDiDwJGAiUirOWWGpf2bCawgvKlAaV+64NzluO+qIgXppMGXBfu4WjbaApGCYH3ZnmOPQY/eABSs7B4JPPxOz01DVSjbbnfKlriiyJsCKDGZhVE0F51rFtZ3FXzDOZrZtrZANdaeI7FrYzW2P0RNtdjP+bQui8Kwhayp8LfViX/DDAnEe7T9OjIUU2OM4JxQxc7muX/OuPrCJDsGwmUEcq13wyZMwiKYqHMWi6ybG0/4zHsFKYTisL7hkB9976cauNCoroUopkTNAkbjypajMG57qmzIuqldvEnO0Ujte2dxAyd/NSGrMLPnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tr9Q7HzoU4x2n9g2S3EJrVYxlM2/MuwLcDu5YdsiCI=;
 b=bIggdTlE0160ENshfrQ2NEBTCkTmuLmC3K7qU5z2HCOfUQAcUmDG26SRyKjTbVWUvnjA0EFNztKT08qt1r5oTktFnbO5vpms7kljVI1xKEFT3JpV32sgXqf9vTiIX73fWUhwgzbK56HOtnyG4MtnOvQ0M/UrImKsuEqQ6XNoyH0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Wed, 20 Oct
 2021 17:50:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 5/7] net: dsa: convert cross-chip notifiers to iterate using dp
Date:   Wed, 20 Oct 2021 20:49:53 +0300
Message-Id: <20211020174955.1102089-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71e36618-204e-4a7b-57db-08d993f2138c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28619BA508255B704820B46EE0BE9@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AQZ4y2DYj6tqZR1s5dcxxYtTrBRmmkoTNPRsyWpp5ygDpF+TlhTkx9w7PoNWiut/eMwBuHZs4TrWF/YTW8+QWnMT+qVuGOrJ/IKnpXBzneI+bMIN4dz8WpJHJf9KcQKXyRnU1aC5JHai+7RM5YegXyC94SgorpLCaMKJVFaSMjnHLzsAQlvfzIaK/XnhvDrp/z5+GDBHqQRKh6d5uzvic6ew4qaap/HVBFOIkRExkFVooFeKm+E5gMRoE3shtaMNE8OnbLiLePIXnN4gjrTkJlCNORXmXL/WCZXuffcU+ufh2VBZePi/BkQm+Pj1UVxNkswbtUrq83iE4jQOre++PgGmLVLHt9sy/bhuo7uCAEysXZWS7TDNb4/LDgokMc387uYh3v0lWI4baFGPl103yfRYQ2RkrOGPXLsJncmfj7qndESeSJ8iKblBirmWV+T8gPYoxJ6aI9EknJSMcGTjjw5CeA3kTEl+5yt7VgXbI9Dt9r8Y3v6yNUWcKJSw1KBLP05PHDKPtEu4BD4nJsTBBOVDEFTniL8FGaFb0oYnHW+wmN3mPjrB9aNNwTM57OUCVg6PZG8ieqizW+H9KlmcUUIoDiJS0VPoSRfg+bADlk59h64ovkTIvzJmaJmY5EJiNq8UokFieUWA9CQZOral1UYcLl97D5yt3LW5lKh2bWYDmmh+1kneJg6Fa5yOqoTFkw9SYyqYNlXdbAFxmR6+Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(30864003)(6506007)(8936002)(316002)(110136005)(54906003)(2906002)(6666004)(5660300002)(38350700002)(38100700002)(86362001)(1076003)(6486002)(956004)(44832011)(2616005)(66476007)(83380400001)(6512007)(36756003)(66556008)(66946007)(8676002)(508600001)(52116002)(26005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VN9XS1mIcgcDr2M6k1AefkjAzSOdUklnMlES1wQi/iQjzBxJgay7qpbswnXi?=
 =?us-ascii?Q?EgSSJA9/PfP590NQSmMSUr3bPY+rJIXZvmQn4nMWAWqFw/Z+HyVjbgu47ktv?=
 =?us-ascii?Q?bQ3MujlZLUm/o+0zrAyoqAyGaSn/izjYwN6eXbT/pGY1RS2iS8d5t/Zl5Ntx?=
 =?us-ascii?Q?p3UI35nPGSzokxoBsA8/yTibuTj7L6QQiZftcwn71FfxD15GImTPkiNqh2dF?=
 =?us-ascii?Q?LfNr7OFHPNht6YkxIgOzX8iru4RhIwcCdwhRlIpbJuAukU8U+odSchxElXGO?=
 =?us-ascii?Q?eXHonz7nVfYQ6PX5mL6ZatNegyWOiTw7tdIwMfkpIW6ur0EKa8hreZMdq04c?=
 =?us-ascii?Q?0/ZNiqoEK1dWb7oKHSC0koAIwDshCi03lIuali2JXxD7CcZel+4uLaqiFoYE?=
 =?us-ascii?Q?JGuRSeTjLPG8c9jDH36aJXl8kf7wPiRcsqeiqRilsES7YkKqrcpW85E2d+oU?=
 =?us-ascii?Q?1Dj5aQn4y6UXWBkpfhaoY9TBvkGnnNNSwHysL58gL+aBnmGSXyCP8fh9Xlhb?=
 =?us-ascii?Q?iceugtlRq8tdEvSh4NVpAFhxYQVbT2lViMErCZmistuoohlSAIbdbB2YiIeR?=
 =?us-ascii?Q?HZY8nTakqa0yRBZI6ZGN9f1JJLNM7snw6t6WFMNkuH6U8yf5Ms8Idkp67DEe?=
 =?us-ascii?Q?TAWtz2s2plEuOiLXKFofyrSxQ8pKBMVzTkxzglLJAMdPCbv3h32wLNIUlK6T?=
 =?us-ascii?Q?50mJ+qlixuwxz7+o0yIfowBq+HqV+tMQj00OA/vQpHpU3LmKsX8lUsoEpcU2?=
 =?us-ascii?Q?4iRcLyHPHv13axNDUN+2kXPUzBIQ+UIPu/PZENWZOoaILb0Tfi5OkMOR8Aiu?=
 =?us-ascii?Q?cFPX4qTIrzUNxK+GQnoM+5ZbiK4Aa3RpXlfX8tYsvkgAainwdX6RgxXJWWqc?=
 =?us-ascii?Q?XUmrgtT5Ooaq7DPYhh0PGMEDlL+ACHvDT3AMIhQul7HSkzktScY4hLFeMqSe?=
 =?us-ascii?Q?rHttbYg2bwjXqFoBB2O7CtoGJCDvk/QHqS1dqnWsEsO3fWl6xr0vNFERxGaB?=
 =?us-ascii?Q?r15kZforb9g51+E/9josisbmtneMLU4PxNcPp+TNtDWKTqPX4jjG8uFG6v79?=
 =?us-ascii?Q?h+QbLJfepcw2H8kmksOBQ8XazcjD+AzJGxAaUChKj64Irkjjq9YtOb5XzT5U?=
 =?us-ascii?Q?+UQgi5itMb7/5pXIdRVKQh7tkQzC3bTYUq9rd7JTsrNucGvHKkVwggLXPcPt?=
 =?us-ascii?Q?dOaXWRIjWg6/YSCl3dQI6oOMISmXzrfkcoOHV5e04Eh5O2LU4B1g4p53F3q6?=
 =?us-ascii?Q?Z93oBF4zbmPwFDRhFaxNtFFYqSKFXjG+/n2OGIWpQeCBKP9wwwx1R5Zv81ZY?=
 =?us-ascii?Q?41OBWmYj6RnkJM2PT+E/ilPX?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71e36618-204e-4a7b-57db-08d993f2138c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:17.0778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /r49/jCr26zCK46T/V8nVBgqWSQYG0V692BQFXHod95N2RwCFbgQhitmN6jZ5Ro+qCnwhl/nWevKiZOtDaLkFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The majority of cross-chip switch notifiers need to filter in some way
over the type of ports: some install VLANs etc on all cascade ports.

The difference is that the matching function, which filters by port
type, is separate from the function where the iteration happens. So this
patch needs to refactor the matching functions' prototypes as well, to
take the dp as argument.

In a future patch/series, I might convert dsa_towards_port to return a
struct dsa_port *dp too, but at the moment it is a bit entangled with
dsa_routing_port which is also used by mv88e6xxx and they both return an
int port. So keep dsa_towards_port the way it is and convert it into a
dp using dsa_to_port.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c    | 129 +++++++++++++++++++++++---------------------
 net/dsa/tag_8021q.c |  85 ++++++++++++++---------------
 2 files changed, 112 insertions(+), 102 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 19651674c8c7..2b1b21bde830 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -46,10 +46,10 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 	return 0;
 }
 
-static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
-				 struct dsa_notifier_mtu_info *info)
+static bool dsa_port_mtu_match(struct dsa_port *dp,
+			       struct dsa_notifier_mtu_info *info)
 {
-	if (ds->index == info->sw_index && port == info->port)
+	if (dp->ds->index == info->sw_index && dp->index == info->port)
 		return true;
 
 	/* Do not propagate to other switches in the tree if the notifier was
@@ -58,7 +58,7 @@ static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
 	if (info->targeted_match)
 		return false;
 
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
 		return true;
 
 	return false;
@@ -67,14 +67,16 @@ static bool dsa_switch_mtu_match(struct dsa_switch *ds, int port,
 static int dsa_switch_mtu(struct dsa_switch *ds,
 			  struct dsa_notifier_mtu_info *info)
 {
-	int port, ret;
+	struct dsa_port *dp;
+	int ret;
 
 	if (!ds->ops->port_change_mtu)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_mtu_match(ds, port, info)) {
-			ret = ds->ops->port_change_mtu(ds, port, info->mtu);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_mtu_match(dp, info)) {
+			ret = ds->ops->port_change_mtu(ds, dp->index,
+						       info->mtu);
 			if (ret)
 				return ret;
 		}
@@ -177,19 +179,19 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
  * DSA links) that sit between the targeted port on which the notifier was
  * emitted and its dedicated CPU port.
  */
-static bool dsa_switch_host_address_match(struct dsa_switch *ds, int port,
-					  int info_sw_index, int info_port)
+static bool dsa_port_host_address_match(struct dsa_port *dp,
+					int info_sw_index, int info_port)
 {
 	struct dsa_port *targeted_dp, *cpu_dp;
 	struct dsa_switch *targeted_ds;
 
-	targeted_ds = dsa_switch_find(ds->dst->index, info_sw_index);
+	targeted_ds = dsa_switch_find(dp->ds->dst->index, info_sw_index);
 	targeted_dp = dsa_to_port(targeted_ds, info_port);
 	cpu_dp = targeted_dp->cpu_dp;
 
-	if (dsa_switch_is_upstream_of(ds, targeted_ds))
-		return port == dsa_towards_port(ds, cpu_dp->ds->index,
-						cpu_dp->index);
+	if (dsa_switch_is_upstream_of(dp->ds, targeted_ds))
+		return dp->index == dsa_towards_port(dp->ds, cpu_dp->ds->index,
+						     cpu_dp->index);
 
 	return false;
 }
@@ -207,11 +209,12 @@ static struct dsa_mac_addr *dsa_mac_addr_find(struct list_head *addr_list,
 	return NULL;
 }
 
-static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int dsa_port_do_mdb_add(struct dsa_port *dp,
+			       const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -242,11 +245,12 @@ static int dsa_switch_do_mdb_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int dsa_port_do_mdb_del(struct dsa_port *dp,
+			       const struct switchdev_obj_port_mdb *mdb)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -272,11 +276,12 @@ static int dsa_switch_do_mdb_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid)
+static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			       u16 vid)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -307,11 +312,12 @@ static int dsa_switch_do_fdb_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
-				 const unsigned char *addr, u16 vid)
+static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			       u16 vid)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_mac_addr *a;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -340,17 +346,16 @@ static int dsa_switch_do_fdb_del(struct dsa_switch *ds, int port,
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_fdb_add(ds, port, info->addr,
-						    info->vid);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_fdb_add(dp, info->addr, info->vid);
 			if (err)
 				break;
 		}
@@ -362,17 +367,16 @@ static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 static int dsa_switch_host_fdb_del(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_fdb_del(ds, port, info->addr,
-						    info->vid);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_fdb_del(dp, info->addr, info->vid);
 			if (err)
 				break;
 		}
@@ -385,22 +389,24 @@ static int dsa_switch_fdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_fdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_fdb_add(ds, port, info->addr, info->vid);
+	return dsa_port_do_fdb_add(dp, info->addr, info->vid);
 }
 
 static int dsa_switch_fdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_fdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_fdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_fdb_del(ds, port, info->addr, info->vid);
+	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
 }
 
 static int dsa_switch_hsr_join(struct dsa_switch *ds,
@@ -466,37 +472,39 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_mdb_add(ds, port, info->mdb);
+	return dsa_port_do_mdb_add(dp, info->mdb);
 }
 
 static int dsa_switch_mdb_del(struct dsa_switch *ds,
 			      struct dsa_notifier_mdb_info *info)
 {
 	int port = dsa_towards_port(ds, info->sw_index, info->port);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	return dsa_switch_do_mdb_del(ds, port, info->mdb);
+	return dsa_port_do_mdb_del(dp, info->mdb);
 }
 
 static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_mdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_mdb_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_mdb_add(ds, port, info->mdb);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_mdb_add(dp, info->mdb);
 			if (err)
 				break;
 		}
@@ -508,16 +516,16 @@ static int dsa_switch_host_mdb_add(struct dsa_switch *ds,
 static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 				   struct dsa_notifier_mdb_info *info)
 {
+	struct dsa_port *dp;
 	int err = 0;
-	int port;
 
 	if (!ds->ops->port_mdb_del)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_host_address_match(ds, port, info->sw_index,
-						  info->port)) {
-			err = dsa_switch_do_mdb_del(ds, port, info->mdb);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_host_address_match(dp, info->sw_index,
+						info->port)) {
+			err = dsa_port_do_mdb_del(dp, info->mdb);
 			if (err)
 				break;
 		}
@@ -526,13 +534,13 @@ static int dsa_switch_host_mdb_del(struct dsa_switch *ds,
 	return err;
 }
 
-static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
-				  struct dsa_notifier_vlan_info *info)
+static bool dsa_port_vlan_match(struct dsa_port *dp,
+				struct dsa_notifier_vlan_info *info)
 {
-	if (ds->index == info->sw_index && port == info->port)
+	if (dp->ds->index == info->sw_index && dp->index == info->port)
 		return true;
 
-	if (dsa_is_dsa_port(ds, port))
+	if (dsa_port_is_dsa(dp))
 		return true;
 
 	return false;
@@ -541,14 +549,15 @@ static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
 static int dsa_switch_vlan_add(struct dsa_switch *ds,
 			       struct dsa_notifier_vlan_info *info)
 {
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	if (!ds->ops->port_vlan_add)
 		return -EOPNOTSUPP;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_vlan_match(ds, port, info)) {
-			err = ds->ops->port_vlan_add(ds, port, info->vlan,
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_vlan_match(dp, info)) {
+			err = ds->ops->port_vlan_add(ds, dp->index, info->vlan,
 						     info->extack);
 			if (err)
 				return err;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 935d0264ebd8..8f4e0af2f74f 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -138,12 +138,13 @@ dsa_tag_8021q_vlan_find(struct dsa_8021q_context *ctx, int port, u16 vid)
 	return NULL;
 }
 
-static int dsa_switch_do_tag_8021q_vlan_add(struct dsa_switch *ds, int port,
-					    u16 vid, u16 flags)
+static int dsa_port_do_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid,
+					  u16 flags)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_8021q_context *ctx = dp->ds->tag_8021q_ctx;
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_tag_8021q_vlan *v;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -174,12 +175,12 @@ static int dsa_switch_do_tag_8021q_vlan_add(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-static int dsa_switch_do_tag_8021q_vlan_del(struct dsa_switch *ds, int port,
-					    u16 vid)
+static int dsa_port_do_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 {
-	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
-	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct dsa_8021q_context *ctx = dp->ds->tag_8021q_ctx;
+	struct dsa_switch *ds = dp->ds;
 	struct dsa_tag_8021q_vlan *v;
+	int port = dp->index;
 	int err;
 
 	/* No need to bother with refcounting for user ports */
@@ -206,14 +207,16 @@ static int dsa_switch_do_tag_8021q_vlan_del(struct dsa_switch *ds, int port,
 }
 
 static bool
-dsa_switch_tag_8021q_vlan_match(struct dsa_switch *ds, int port,
-				struct dsa_notifier_tag_8021q_vlan_info *info)
+dsa_port_tag_8021q_vlan_match(struct dsa_port *dp,
+			      struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
+	struct dsa_switch *ds = dp->ds;
+
+	if (dsa_port_is_dsa(dp) || dsa_port_is_cpu(dp))
 		return true;
 
 	if (ds->dst->index == info->tree_index && ds->index == info->sw_index)
-		return port == info->port;
+		return dp->index == info->port;
 
 	return false;
 }
@@ -221,7 +224,8 @@ dsa_switch_tag_8021q_vlan_match(struct dsa_switch *ds, int port,
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	/* Since we use dsa_broadcast(), there might be other switches in other
 	 * trees which don't support tag_8021q, so don't return an error.
@@ -231,21 +235,20 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 	if (!ds->ops->tag_8021q_vlan_add || !ds->tag_8021q_ctx)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_tag_8021q_vlan_match(ds, port, info)) {
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_tag_8021q_vlan_match(dp, info)) {
 			u16 flags = 0;
 
-			if (dsa_is_user_port(ds, port))
+			if (dsa_port_is_user(dp))
 				flags |= BRIDGE_VLAN_INFO_UNTAGGED;
 
 			if (vid_is_dsa_8021q_rxvlan(info->vid) &&
 			    dsa_8021q_rx_switch_id(info->vid) == ds->index &&
-			    dsa_8021q_rx_source_port(info->vid) == port)
+			    dsa_8021q_rx_source_port(info->vid) == dp->index)
 				flags |= BRIDGE_VLAN_INFO_PVID;
 
-			err = dsa_switch_do_tag_8021q_vlan_add(ds, port,
-							       info->vid,
-							       flags);
+			err = dsa_port_do_tag_8021q_vlan_add(dp, info->vid,
+							     flags);
 			if (err)
 				return err;
 		}
@@ -257,15 +260,15 @@ int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info)
 {
-	int port, err;
+	struct dsa_port *dp;
+	int err;
 
 	if (!ds->ops->tag_8021q_vlan_del || !ds->tag_8021q_ctx)
 		return 0;
 
-	for (port = 0; port < ds->num_ports; port++) {
-		if (dsa_switch_tag_8021q_vlan_match(ds, port, info)) {
-			err = dsa_switch_do_tag_8021q_vlan_del(ds, port,
-							       info->vid);
+	dsa_switch_for_each_port(dp, ds) {
+		if (dsa_port_tag_8021q_vlan_match(dp, info)) {
+			err = dsa_port_do_tag_8021q_vlan_del(dp, info->vid);
 			if (err)
 				return err;
 		}
@@ -321,15 +324,14 @@ int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
  * +-+-----+-+-----+-+-----+-+-----+-+    +-+-----+-+-----+-+-----+-+-----+-+
  *   swp0    swp1    swp2    swp3           swp0    swp1    swp2    swp3
  */
-static bool dsa_tag_8021q_bridge_match(struct dsa_switch *ds, int port,
-				       struct dsa_notifier_bridge_info *info)
+static bool
+dsa_port_tag_8021q_bridge_match(struct dsa_port *dp,
+				struct dsa_notifier_bridge_info *info)
 {
-	struct dsa_port *dp = dsa_to_port(ds, port);
-
 	/* Don't match on self */
-	if (ds->dst->index == info->tree_index &&
-	    ds->index == info->sw_index &&
-	    port == info->port)
+	if (dp->ds->dst->index == info->tree_index &&
+	    dp->ds->index == info->sw_index &&
+	    dp->index == info->port)
 		return false;
 
 	if (dsa_port_is_user(dp))
@@ -343,8 +345,9 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 {
 	struct dsa_switch *targeted_ds;
 	struct dsa_port *targeted_dp;
+	struct dsa_port *dp;
 	u16 targeted_rx_vid;
-	int err, port;
+	int err;
 
 	if (!ds->tag_8021q_ctx)
 		return 0;
@@ -353,11 +356,10 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
 	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	dsa_switch_for_each_port(dp, ds) {
+		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
 
-		if (!dsa_tag_8021q_bridge_match(ds, port, info))
+		if (!dsa_port_tag_8021q_bridge_match(dp, info))
 			continue;
 
 		/* Install the RX VID of the targeted port in our VLAN table */
@@ -379,8 +381,8 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 {
 	struct dsa_switch *targeted_ds;
 	struct dsa_port *targeted_dp;
+	struct dsa_port *dp;
 	u16 targeted_rx_vid;
-	int port;
 
 	if (!ds->tag_8021q_ctx)
 		return 0;
@@ -389,11 +391,10 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
 	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
 
-	for (port = 0; port < ds->num_ports; port++) {
-		struct dsa_port *dp = dsa_to_port(ds, port);
-		u16 rx_vid = dsa_8021q_rx_vid(ds, port);
+	dsa_switch_for_each_port(dp, ds) {
+		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
 
-		if (!dsa_tag_8021q_bridge_match(ds, port, info))
+		if (!dsa_port_tag_8021q_bridge_match(dp, info))
 			continue;
 
 		/* Remove the RX VID of the targeted port from our VLAN table */
-- 
2.25.1

