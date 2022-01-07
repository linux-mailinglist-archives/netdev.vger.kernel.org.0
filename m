Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533FC487977
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348043AbiAGPCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:02:09 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348020AbiAGPB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hm0w5Jt3kw1gRFmTcsBgxowc0qJVlJxaM//2IHfAzDfstzpUZF++lPytUs1PEdmfKgyBzCSHX0MPsre4C9XjispIO2X9e+7gha/bfNoGhstj94cz/O8kyMH5KQbQxPtlWB0djhYyp16KM3MiAs+18GU1kbtzb2aWjcunD9bkC8PN3hn98YBUKTyaLXg5bDLU4rAekzTwaIX0U38p7GHfHp3MH19tO4dP8Knj9aRqDmLDi9E5FL09ZbcP23KBop1hF/L6bHttDph2gs0ujRj/ruWznR99hHCeVsQt38hhDnwsKWjQOQLYsnsE9avjU2ux6LuGvZ5c1LKURK6KEedRbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+YTaUzAsRUiyeruf0A62TE7U/YPsQ0eXsJEk2epkDg=;
 b=I6679DuhQfOsaWTCX0SC/mmAWmOkkPELIaWrMsyqx7I5bffyZ770fZ1CJIjL7XsNtjJzl7JG3mLXq8wOGJQCy0PdzhLzqvrTWQhknP9O3AbUwT22AQLXEQefycGPdm/V9rT9m6AbKEvVk4uQ+vE4vf7eFt/OcRWwbODnfpKCSK7iRapZReTAAqfK5LD5lBp/5Xc/qQbj4G+ul4JM4mxzjG8vr8xErP7KOLpjiYC6EzfFAG/9+KGfDLqGASbhnTFL6r6RQqUQra2vPzu8lbA1vvwU0df/uY7EyaQsR4IRmAYrP8HE+G1LrfYm1LXbtSnMuOyX3tr0cDnpqv+t7HF2Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+YTaUzAsRUiyeruf0A62TE7U/YPsQ0eXsJEk2epkDg=;
 b=nAGL6uA4iEMPQg6mf1tlzIN5PNZv9/uuNV4ODIyGwy/L1U4bDCTTbwAlJYq9UTKkhWJKZJizka43K8SjhEPxXe/lEh2HlEoLAuEixapVPVG8n9eUEHNGe9UcDGZzdtOE59F1qhgTUYhCeVOFlc3aWugxfg4/aNQNRmlmtuby+WQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 10/12] net: dsa: refactor FDB event work for user ports to separate function
Date:   Fri,  7 Jan 2022 17:00:54 +0200
Message-Id: <20220107150056.250437-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d3078f5-e2ea-4973-4535-08d9d1ee8d62
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408C2EFDC92623E49715AADE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DUpsBOz5rxzMFNPLxGM9JzPYHzwNoWqRI7tLGhpGVM1bGxYY+zxbzydbPGTNgPvND6Tq7GTsMlWydyqHQuBAzOBN2vfs0n2REnIsjG27rjxNdx1NDKNe+yHa2F8GqE/1ZIXslpqRdiQyhHSBWMQuO+nHOhBcLniwORYjpYzVF25Npsu+FPWEdSewQ4NGG6UQWnMRr7N0QCW5me8X3dSTFHDS095QAd3UC7LKa6Gs3ofqpWSpxRtV04kDbvGMaO2TlKn8j0Zee6BlLZ5bD8819nQRY4vteZ/za7VTTR5czkyKOUpAetaCjjpDHZE7NvkueOKeqr139JMRVeHTQOe1e+M11loWZpHXsf+EyhQMRz7fmT4lBvx2KThFfT1Yf8Xf2jKdnsBVjetxgZrhwgRBusdElwRYyUvyvrotbcSToWAqvo6dnB5y2P/1Vb4vmkWV0F3ZRxVRGQf9mmmw6DwB9dcRsWMillIo8c/7zr31lvUKrrvRi5k4fVidrDL3hM+aQamnquXj5OBnJs1CpbLbsAXO/l83ECHgKJbVagSxxbcB+71ypMjE9qROdjnrljMkFJ2+i25p/pO0LesN0GdVL5Kct41Gs3TqmLI0tAiMvYEUyRgKjSdOVIOKCObCODc82y4OcoYYBzv5VwmP66E4uqY9DS3WMoN5lBBV1QvI1mr4fJ2A3vs8lV2b79lc69v118chxTBiWX29mnhB9njHnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eaY9ZkgjliKXg6p0+Sif6Bw/O5kkJYHbrdPT6DhqW4/IJhL4w0TChpmOaD1l?=
 =?us-ascii?Q?CqBZDf4AiSC7WR8DVe0Ly3F2Ah0YO7jnKnruykVpn5agoX4bdqwFXHADxiyK?=
 =?us-ascii?Q?nnVtAViaT6YU+bxucqQVduZbHXf0Pv0sueisWNsvOv/fY3CVv4SUHcAAco+8?=
 =?us-ascii?Q?sVfDZONcTC8Bwq4hZaWE4GxD8uRNhtql0rs2UR3ZVWay8rsmvTnt6EWNHsWq?=
 =?us-ascii?Q?sffVnqTajlmKCQYKO1t/iXZ1sEI3qJwY6eE9jAsgetMwBtkq4VdZi0aGNfas?=
 =?us-ascii?Q?EdC/2+yn9YeP6FWY76LnFC68FbxygPSL4sG/4NPu1lUQcSEfR4lryV8E1RM4?=
 =?us-ascii?Q?hLZlgGi5f2kHtKrprt97xdI0/mZt9G82qaBzkmGOkMXmf/fi6wFMnJpscAuq?=
 =?us-ascii?Q?Uz6Pk/c5zGp7waLlGbibX+15IBAMTE908KUJeUkrR7rUPYN0II86AEoNfnxa?=
 =?us-ascii?Q?aVCu5cPir3vD93l7zjemxmy55RAUnz4K2ujXdJz99lGdIfC2uoZXvofgyTK4?=
 =?us-ascii?Q?11AlBMt2+G+CESjS91N02F4+5ymeJFcAd+0Y66hssaHL+cfoXdsdY8US+MDG?=
 =?us-ascii?Q?U8iFauzPCVAtyDCGSod3hzo3PqRQvpk/LDTa09p70mpFdd4cp6AIbgrTyWwI?=
 =?us-ascii?Q?AXguKeiFXG4h4Qtm4kxFB8lCu5DpvPIR1qKLqscYtvCSW4dbT8razM0smJnG?=
 =?us-ascii?Q?IqCYMUkjg3PBofrhk5nxvLjoRan/aAkJWH49JWx2CoZVzp2jByIIjwKGAhlL?=
 =?us-ascii?Q?DpL8CzOrzrKGbDNtCq0Bt2YeqZiJ6GFjarhTGPI7m79j0zBDdZJW5JdxRNTY?=
 =?us-ascii?Q?X0SWJJkq++M2/bvhxBWm8A3O1t088/tSG6tzFEpuWmqlkFhdwRQklczXW+NH?=
 =?us-ascii?Q?3teTXpRFrq7+xIJN93b0ayxcNPBS5hgxPo8NQXLAHMrpkY5ZnWlF/l/1m0Pz?=
 =?us-ascii?Q?mTCkupcoeX4wfC1vzLxXQSvixM/bnPBFzwM6nqS20jsGW7gb7XjzHhBW7bUc?=
 =?us-ascii?Q?TBihJOqh4mqcTayZ0L/PPAa3O0npcb9SEmpFnPyBchtf+6b3IrJFSCvG9sv/?=
 =?us-ascii?Q?aIVzgXyL8f6kbKmVM7Z20npCVSCPXSO8T8zjvGaaY8aQkCF4PhxzUdIEc0oB?=
 =?us-ascii?Q?6+KcKq6lpaFyni0xbbK5UHD1wKSVW4R2PBUT7F8HFtmBjpwBYeAzNKJb8gXD?=
 =?us-ascii?Q?NEXYDnhw/EJign2mkunjju993VNHuxm4Yu7Wxht/1omBjhGd9oSWja404q7b?=
 =?us-ascii?Q?nZa4qYF92cg72/1Yv5ZBFPK47DGdaIbKJt0B090ojkxNgum/GRybLCDlP9po?=
 =?us-ascii?Q?Rnu2gqk2ncA3eqnalyX7GZr0zFAV17Ox2nJB61/qNINa9ZTSmzsg3XFry6qF?=
 =?us-ascii?Q?o9kxKElK9IV0IaanrevgN46j0hzf7MxTpSsJcf3PHAkfdTQbmx94vsV5Ped/?=
 =?us-ascii?Q?CNPIr9hcpG68U1wpMSONDZ+IA8lULLnd0a2qe/iQ03WHYiM2G1rxgae+boJu?=
 =?us-ascii?Q?0yUwd1quf+5726xxIgq/kPQHVh3THXmsJlMREYHOktwLh3LUBsPPWB36sSTx?=
 =?us-ascii?Q?pm2SNrZT9YVIy6kO/cuaI0zk82gg70hJPlHsPXx++wuA4XTLX1QDt3h7bPdF?=
 =?us-ascii?Q?m7qMWZwBt4Yo5+oYVH/ktKk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d3078f5-e2ea-4973-4535-08d9d1ee8d62
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:15.5491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pgHY4OoZsT3O+8lINUgAPTwVCLj1MA04PcDyRuwI+buz2spzUBXyuK3j3EGaARtMjx6DgCCg96Y9q5nGTWkilQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The procedure for installing a FDB entry towards a LAG is different than
the one for a port. This patch refactors dsa_slave_switchdev_event_work()
into a smaller function that checks the net_device type, and if it's a
DSA slave interface (the only one supported for now), it calls the
current body of that function, now moved to dsa_slave_fdb_event_work().

As part of this change, the dsa_slave_fdb_event_work() and
dsa_fdb_offload_notify() function prototypes were also modified to take
the list of the arguments they need, instead of the full struct
dsa_switchdev_event_work that contains those arguments.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 71 ++++++++++++++++++++++++++-----------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d087b0ae0a7d..3f2bb6ecf512 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2391,64 +2391,69 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static void
-dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
+static void dsa_fdb_offload_notify(struct net_device *dev,
+				   const unsigned char *addr, u16 vid)
 {
-	struct switchdev_notifier_fdb_info info = {};
+	struct switchdev_notifier_fdb_info info = {
+		.addr = addr,
+		.vid = vid,
+		.offloaded = true,
+	};
 
-	info.addr = switchdev_work->addr;
-	info.vid = switchdev_work->vid;
-	info.offloaded = true;
-	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 switchdev_work->dev, &info.info, NULL);
+	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, dev, &info.info,
+				 NULL);
 }
 
-static void dsa_slave_switchdev_event_work(struct work_struct *work)
+static void dsa_slave_fdb_event_work(struct net_device *dev,
+				     unsigned long event,
+				     const unsigned char *addr,
+				     u16 vid, bool host_addr)
 {
-	struct dsa_switchdev_event_work *switchdev_work =
-		container_of(work, struct dsa_switchdev_event_work, work);
-	struct net_device *dev = switchdev_work->dev;
-	struct dsa_switch *ds;
-	struct dsa_port *dp;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 	int err;
 
-	dp = dsa_slave_to_port(dev);
-	ds = dp->ds;
-
-	switch (switchdev_work->event) {
+	switch (event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+		if (host_addr)
+			err = dsa_port_host_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
+			err = dsa_port_fdb_add(dp, addr, vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
+				dp->index, addr, vid, err);
 			break;
 		}
-		dsa_fdb_offload_notify(switchdev_work);
+		dsa_fdb_offload_notify(dev, addr, vid);
 		break;
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
-		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+		if (host_addr)
+			err = dsa_port_host_fdb_del(dp, addr, vid);
 		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
+			err = dsa_port_fdb_del(dp, addr, vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
+				dp->index, addr, vid, err);
 		}
 
 		break;
 	}
+}
+
+static void dsa_slave_switchdev_event_work(struct work_struct *work)
+{
+	struct dsa_switchdev_event_work *switchdev_work =
+		container_of(work, struct dsa_switchdev_event_work, work);
+	struct net_device *dev = switchdev_work->dev;
+
+	if (dsa_slave_dev_check(dev))
+		dsa_slave_fdb_event_work(dev, switchdev_work->event,
+					 switchdev_work->addr,
+					 switchdev_work->vid,
+					 switchdev_work->host_addr);
 
 	kfree(switchdev_work);
 }
-- 
2.25.1

