Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468BA4322BC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhJRPYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:24 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:36421
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233092AbhJRPYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZqxHXWS8r2vlxOEY+IL5+YshGblnd3FyaslzefRF/s1dBmEpExvzN2vwYcA8o7hVEF3DpUrhJTzN5dwsdsYVvPXGsQqXH+SGBe+BG6y39j5gXKzXZXqk56rvIabo80i3lU9ZFPFCR1gnuqjSUUeU6FlrfgI0xpUpAe6mzcShrRMwpwbAIeK+XfB+BaDHxhYzpgoQTd1vbv7Sfb7vMryIoM9ow+apTvO/UFw4urx8N/bPfcjQO7u2qHnsXcyw5IyGDyw/SHfydbmYF9GjOChygCNNb6eh5oHglPm/czwyow3/3fPGp5Y5PYQ4CJPitqwope0B5BmGxFeunsMsBCl3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8tr9Q7HzoU4x2n9g2S3EJrVYxlM2/MuwLcDu5YdsiCI=;
 b=f51l+JkBVUzlgOZ5hFvcHisuEPzJQ+8yjBOhZ3e1wNk2KbWsgFoL1ZuvUIc3fEqtmTDtDiF9IArtd+Upc1iL3IsN/znjGKTRMZqypVa6qU5C2oApPiLe2Ga9yVOiLqnV2Qhoo13TCwkM2sZc/XNUThDTgiL1M0HBMLiq9JDRKks8w4mwFL3XPcjIgb21wdjkC1dADTldS2plvSZb/ytgfWGDObZIivsFBJ7aDrXJGCLUs/fhsPVsQLM+HTaeXG3AWa92HvB7VMd+BLT6amFwu6mhQR6abpI/sM8NU18gid0x+wzeeWL4JhA2//i1ZmpNkuWqHXWqjQiZZDsCp9s6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8tr9Q7HzoU4x2n9g2S3EJrVYxlM2/MuwLcDu5YdsiCI=;
 b=mot86MNaR+anwSbfu6CCgGEwcIouJD71TsuYxEH1RaANvyux5eyXD9n1fp935x5F2RL4xDOOr43on2NbAZyFtniv0DaeZ3oz8gn3QaZVneAqovropUJWV0NonLDgHuig+Z5EuoYFyDNgm13tk8dLd4nW8ACo16CkiHBKYXgHLr0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Mon, 18 Oct
 2021 15:21:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 5/7] net: dsa: convert cross-chip notifiers to iterate using dp
Date:   Mon, 18 Oct 2021 18:21:34 +0300
Message-Id: <20211018152136.2595220-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b16f5051-e9da-4f41-3c36-08d9924b0699
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2688:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2688EA655B0FAE485C116788E0BC9@VI1PR0401MB2688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nblRku1G2c4S6AselVR7KnGz6dMGFwjmK3LyqvfGoRg+zaHcA/LdjTdqRBd1x2l0XkUdNTZDJ23yNuWloLPFrxi11MBOlvPiNlptsbnDp6sIYUPPYKTVWQllGY/K9022xfkzNmDwyxdTAx4n0MENyNVMgjBazc3LfIYA+t+F/hPsrtjY8TxQ7jz19j+NVzMZqlK5FE6Z1LGrGiKEmP3k02WQFzC6u5cwcETbw/WixxgsWRyUvPYqjqUMmx7MH9DG1v8c6sXu7eE9mc6P5BlljdEj8cQcXk4IUk7MyFPqaZS9SfmNVWbt8/kIv+RP7Tniy9PIo2KxBim+d6aXqetKkHg+XMgXkk9jr6oDRvUH4bBWucwTkp6rrVmu++b2yv+I3qahrhlsKMOOKvHhtt170EoOZGFT1/WUKwtnXB/HYfK+VQKLEy5gy4MQ7YPtUuve7KwAW+3uMbHTGYZk7+3Irq/OidkDl46tL3MOfmaVzOoatFMloot4uaodJIvrn08XD+rjaanU7hu4J8j4DI/QYiXvoXR3XHDGBLNwnsvT1qLIN7Qe/lDZhvAhlbvUJH6dfdE3L4/qPOJZva9m8CFpNu3UOnR6u0PfrvjMu/tbBfAw+Zdit0DptLhnmzJBJ20KNpPBifErtl9XbQmNYBWKLQTOweEYQr38ubTLzb0lKg97AAovB4s9O7cZP2pjcYv/SLyDtNmg5gtL5jz6LULygQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(110136005)(956004)(2616005)(316002)(83380400001)(1076003)(54906003)(66476007)(8676002)(66946007)(66556008)(6512007)(508600001)(6506007)(6666004)(36756003)(2906002)(44832011)(30864003)(6486002)(86362001)(38100700002)(52116002)(38350700002)(186003)(26005)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HdCXUPE85F1LPNSEsdQAGrSMxTJWNFT17yxkaZMCnFSN3+Fa8lvVGSc6sneR?=
 =?us-ascii?Q?WvG2jODClv4teUTNg8jL4BxI7S4DK5u0SqJ5SJUb0IkKjvyOUJNaGU11v3DX?=
 =?us-ascii?Q?YDBpMVndcJH4OBcUB22jRSYcJWg9sxuD7JwJ46U+RhcR7+lHLE4DO0cm3pQU?=
 =?us-ascii?Q?JtlKWn1x+/OCjT9/P+9QWDOvW1tPPQhsnlTXz8C663QjkXS+QjXuvjrdb6Wa?=
 =?us-ascii?Q?HXHQA56/XZsrA3TwoFdExnxF8ERPV8KFa11edjxrF/UVhlqu5UJhm3mGcOM1?=
 =?us-ascii?Q?/iCFfjABsMiTbC/hN5MT6JMxeCASAyh0II8Ekx3By7v9apMZHInuTrvgswLP?=
 =?us-ascii?Q?ItDR8/Pc42LNhJSKIZUJmvM0IHzBEjtncraT5BvoHbo6uHDuLlGF6U6C+6G2?=
 =?us-ascii?Q?rwsCdUW9rfLQp7mGc1plrK5a8dP8O2fI0qHL3IR2+plM8jtI+t+9a48Oqc2p?=
 =?us-ascii?Q?wa9QRtyf5rRoEquNNTjdaC/k4FcU99SkdY0QNv7TOqn9Z6SV5RRLKSuXHBPx?=
 =?us-ascii?Q?/WwZ27gEgfpanRmgCXY5BwUoOTmzmY8GOGFV6MarLfw1C+jYeD7qZOpYYxQE?=
 =?us-ascii?Q?QHS4GZLWkHedkHYNWHt/6srAG7akqRDypdyicGtgQ8PtmHs7Ivk07ErvxBN4?=
 =?us-ascii?Q?ByLAqoZhOpNFwo2Lx6ctvmGoMvWXbhnttvKPtXHZLfwUQRHrsVViR3IP01Ot?=
 =?us-ascii?Q?770ojAKn2EzVTJOHl+uoice/I4ZrilIZnvRwsmzIzEBRa2FMC4fK9lIz4OYY?=
 =?us-ascii?Q?esuo2PhEmcTTgAUqHK+lxL6Tcz+9CH/PCjXcDSvCaUKsggIEPuk6FL8W2TtC?=
 =?us-ascii?Q?gU+y6c/3Sre0pq+OniAYfeKzsjUsvbCz0EsOE2/84sXfePSqasfVWMFMY/oI?=
 =?us-ascii?Q?Byl1ewtUKnkXVf3+0GVvGA4kLjshlnsfdU9G+m6mGKl1d8C+D+ffhgsEUbCL?=
 =?us-ascii?Q?EloH2i8SeppGqGGAc3hkl7DFZC9jRjPZ/J1qREiYDSs3z9DxB3tFxTjrLA8v?=
 =?us-ascii?Q?hlTuageGpsH1xl9MhLf48yTBDb1q69OStSg59Fp3VPPCifAQZwRveQFkXkxK?=
 =?us-ascii?Q?QzmuZwCf+NWOQXZiTeobTltMRS80agxekoHHtOA74ag5HWn5mJjNMBaW+v/d?=
 =?us-ascii?Q?FRiBNEMfsQHYqdJYFy5dZvOCbq6J5eMEGL7arjINiSjRRX8UC+VryeIQcsEG?=
 =?us-ascii?Q?SVuJHhw+sfsbM49RHVE4GpobOwjrKtFCvNKZdaEz//8cfMwP1WXUWX6Zr1JS?=
 =?us-ascii?Q?dZAnIFYnSLGQ5/Qb0iS3sqTXLXtmehuQMSlJJhCbUDFOFm0yfWsIc+1rHLOm?=
 =?us-ascii?Q?Yg5x5OgcYiffxwXHceighkWm?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b16f5051-e9da-4f41-3c36-08d9924b0699
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:58.2083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T7WgO0nJb3PsBdKaTykuhjWPWKcPBRr0tstrKL8XhyYzs7b3iCiJF4+fxzfWf6hAOoZZiHrWN8Qr0SBNDkwSIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
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

