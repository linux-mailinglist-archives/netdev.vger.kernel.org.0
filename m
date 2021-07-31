Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1603DC1D8
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbhGaAOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:45 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:13735
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234751AbhGaAOm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8UGxS9Ca/txF37LQI2Dj6/UKbUnd+ifZnvdXQA74ehqWFyyIsb2kzQqx11Rt/VzqTlPqUqCSIkfHKEmaFpzVsPkgrZK6OwfIHYinOtU44oiNh8YKxBK8plnA8otm1wjsyT5nG6gg6hmZ1owRwz3kEFmRx9eyJ9388j+8dQJqzovNr97+PBRMRFXo1HR6KSxs6KfUMdstl21ZubTwh30uVHfeMxxFTE4ETAIOcM2QSW/pW/kte8+HPkO5r4TWNCl8qfv40ZjwiNNekpdl8GcXqybSOZPhQpcvZ+BygBA715RkxtEFhBmRH6l77uWnXkZXSKNRCsL0DbvxNjiZEkAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyfrO73Td4dAMsnNDSs9GL0mHeOp2mgHZ+jyCZdu2xc=;
 b=Vg/cMblyWzlIFfaiK+UOhuO7g7Uq+Tzw4cpRXkAb5VeVJcDQ5ExVtdlLyUVIYcrJOSOCe0wo5Ee/K0EbUFbrYjTcG/Du81mVmwgkNxW9J35c5NOlijmCB0FQu+89Xj4IhmGIyY4XnsPQcFheFz3DZoXi1md5Eskn34eOTDbdbGnyeGHhOHPsdJbd64tOEMKXWCzK5A/m5pmsBukxhNYwmzHjG4sHPPL8LJcovwgyEUPT1UIPALEfwQjQq7FWX+PzdaI3yQMlNog0H7s4zEmA1A1hXanAF4RUb5bZ8qo4TVEUf8t3BZjkCWea8995OevXePuHEvbQFQL9PQkvjXHUuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyfrO73Td4dAMsnNDSs9GL0mHeOp2mgHZ+jyCZdu2xc=;
 b=R3XJu0R8xz9iZNnOBEnSLQGuj/QBnab5AUim6awkm9BN7rnUzQg3xA8e9JLpgMKDRU7lQB293XGeU2pzRIY0Tn0g+ZkNKfG5ot/Fm+N/1YfZrOxsr5jSu2L9mmrU0aXBGpZV1POrf3/wup/MCUIT1rvhQrCzaFLNavEU4ng12fo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 06/10] net: dsa: sja1105: suppress TX packets from looping back in "H" topologies
Date:   Sat, 31 Jul 2021 03:14:04 +0300
Message-Id: <20210731001408.1882772-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
References: <20210731001408.1882772-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0161.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5947fd04-4add-405b-682c-08d953b827eb
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511F48705C3DECD4E70CE05E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dn1EOLtuJ3jTrzqMPwRcHxUkbVMYjuKqxc6E094p/Nb+Ntdz+/lAB08D5FqbeSbrzFnynUsH1MlLWwmttLHz0FSShmcWVk9EMVk36iN1UZbHHkLf6b6NKQSpKyZJTiW9+UnF5eQUn1VIqjx0LegkMwJhTULFlhqW7D2izOdGXhQOTyfswsZwyua2V/YqID/LR8nLamZ6ciCWZrysgYWhT3HY5n5keXiouKFO461/N27HuhPbd38kWiTkduH5rQiNEFR7Y2XlV3t/fJZNf33CCej1ar466TTblB8ELomQoPR7HuFzwFz7HDmiv5atMiUDK4BkSw4ac6t/22hkv/UNiVHI8XYzKrRbU9665L1BTG18ZjPp4whk4wKNfrhmZSM+NWDmhOSo2KkmBYDeVxbTBkjBptQhGiCZNlgvfQAnD8/TAHe6OmKy/hZw/VaFJoOMLZrNc84VzRtvr/RQme+BNvWER1A97AHmOQU3QhixPpZVovkG4lYtshxkhbbM62j7vG2/DCmgRJ2BFBEpSnZZDAH5WpMH0U0BM9kCFtW9/hlvmJ+EV+5yuWhnhyA8cHRi2uu8YM1USCq/39EmTInCK9xwlT3A0hhe73tc09N5AhEeLJFvFbbPe33qHOcO2OkL+JnMXP4H5hyQq7ZOzHvznjFub4hwvQ0cz+A+w3UI8vXACZrqRsy0+SSacYEo1lbSIdpvEl4IAUgQyHWGzY9YlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y57fEVB2PFJqYonHvctmnh02qVtithhfLGB/sVMf45/djfuTTiHI4deoA374?=
 =?us-ascii?Q?epn1PgGGXU6UFhzk7BH7YnlY5RLZl/LOa6mbM88vVede3H9Y9wLDJdxO2I1B?=
 =?us-ascii?Q?ck8XGqFb0JJDuT3x5e6MZwHwfh710qY8S7tVZADbj/lfEVRD/OokrrrVgdyv?=
 =?us-ascii?Q?NFeqjYuqsYvqZ+khSiKyKe9+wC7a2PCYxOdDYxW2eMja6rxZEtB1WLIkPkTU?=
 =?us-ascii?Q?QwGI/HzPTmo3HX2nJ1fwq7DA1WhyHw5ZNugnVR2uG5ANJxg/Kjfew5dXBm9L?=
 =?us-ascii?Q?aOhbsjYLp9GagCUoyLvxZH4GxWiGZe2yHMAMcxHokpJq74jgHrD64Iet+0X0?=
 =?us-ascii?Q?Z9+rb/3LLWF/KChvng2Bp34ePLO085AKr922QOO6EZlSbcrtoRkggU6vi36n?=
 =?us-ascii?Q?+rYDXosrCuHB4jJNwpDijv7BfTKS77TscyGvKtnPw9RUbn75VQLwUFSPdYsj?=
 =?us-ascii?Q?F2Xb5O00LobM7Y9+HZMBcirqGNd74n7atkyJMaqeEB02xUd9nbQhENU/pCOb?=
 =?us-ascii?Q?lz+aK1rEBEZNRwOFKfZLICyQIGTTU3YdSgFOfzQqNEZtqfRlbjmFZKCK/puF?=
 =?us-ascii?Q?78xxqmnSAzfTkJistzTwzwnMowTtHXrI/hjg1V4ka4MVmzQpDdEnZ3ANFNcq?=
 =?us-ascii?Q?7YIjSDKROpl98xLVZuyCAcPvnIJ5VW1TYnRHgZXSSE649PcRahvI46JhBLca?=
 =?us-ascii?Q?YssFpylS3eoqvMk3JgwSJav3LZVfJ4EoDQX/hTARgfHWJ4raveoHwEsT2hP0?=
 =?us-ascii?Q?Aylr1uiAJiSsmYYPYgfzjHVw0y2P0/MWimYjIyV8A4TnfeRy/hmw9W+p5McW?=
 =?us-ascii?Q?aJ1czJzouT8d5JMtaEpEFH+8KIMIiq8B1cOn7lL19bFP//zmkWRnntypdbpc?=
 =?us-ascii?Q?LCwlFRcThIadZw3PDR5qKWuiHBfdeN9hYOx75M68FTDKth3ROUi5pPCds2bx?=
 =?us-ascii?Q?kY6FU9osxOMRIlZUnSO2/TMaN5xN8uHbG0AxJMDj4cE3j4fGgItwf8SW7BjA?=
 =?us-ascii?Q?ujUQv4EBHtkqnxDZqXOIFjOwX6iY8ZA9SkVJ0ArEiIJg7SlRDSOEFBrCihGi?=
 =?us-ascii?Q?acSilMWOATVuIXc4NeWLlpwSwM/D01ILNoYmYerXZzEwH0XxOqKXYVetuB8S?=
 =?us-ascii?Q?bmjzo5fIf0bYh8xM8uTC+z46Pm+1w6BtZHcFld6saJS8CAy1eoxvn6qWcD87?=
 =?us-ascii?Q?NfSELKJrUVZzTpRGYNxB7vOf3h1eF/Yj186MC1OMnRP25VSQn07TNXEkeWxn?=
 =?us-ascii?Q?zXWL9GxwztZ0Vn2N3CthsSn/sJ2ZxC5mS4SWBB83mjwK/XUOXeKoojfAXpD9?=
 =?us-ascii?Q?bnM7UofNKotfrT+pMaxSl4zr?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5947fd04-4add-405b-682c-08d953b827eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:25.9971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwMfnLaxgR0nQ/4RvQvIbMJdUjJWpvGXMJ36uSJqhAhyqpBLmT6sbEoRUHPZCbkEJTjTReaUMlFUsOMAiu+Ynw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

H topologies like this one have a problem:

         eth0                                                     eth1
          |                                                        |
       CPU port                                                CPU port
          |                        DSA link                        |
 sw0p0  sw0p1  sw0p2  sw0p3  sw0p4 -------- sw1p4  sw1p3  sw1p2  sw1p1  sw1p0
   |             |      |                            |      |             |
 user          user   user                         user   user          user
 port          port   port                         port   port          port

Basically any packet sent by the eth0 DSA master can be flooded on the
interconnecting DSA link sw0p4 <-> sw1p4 and it will be received by the
eth1 DSA master too. Basically we are talking to ourselves.

In VLAN-unaware mode, these packets are encoded using a tag_8021q TX
VLAN, which dsa_8021q_rcv() rightfully cannot decode and complains.
Whereas in VLAN-aware mode, the packets are encoded with a bridge VLAN
which _can_ be decoded by the tagger running on eth1, so it will attempt
to reinject that packet into the network stack (the bridge, if there is
any port under eth1 that is under a bridge). In the case where the ports
under eth1 are under the same cross-chip bridge as the ports under eth0,
the TX packets will even be learned as RX packets. The only thing that
will prevent loops with the software bridging path, and therefore
disaster, is that the source port and the destination port are in the
same hardware domain, and the bridge will receive packets from the
driver with skb->offload_fwd_mark = true and will not forward between
the two.

The proper solution to this problem is to detect H topologies and
enforce that all packets are received through the local switch and we do
not attempt to receive packets on our CPU port from switches that have
their own. This is a viable solution which works thanks to the fact that
MAC addresses which should be filtered towards the host are installed by
DSA as static MAC addresses towards the CPU port of each switch.

TX from a CPU port towards the DSA port continues to be allowed, this is
because sja1105 supports bridge TX forwarding offload, and the skb->dev
used initially for xmit does not have any direct correlation with where
the station that will respond to that packet is connected. It may very
well happen that when we send a ping through a br0 interface that spans
all switch ports, the xmit packet will exit the system through a DSA
switch interface under eth1 (say sw1p2), but the destination station is
connected to a switch port under eth0, like sw0p0. So the switch under
eth1 needs to communicate on TX with the switch under eth0. The
response, however, will not follow the same path, but instead, this
patch enforces that the response is sent by the first switch directly to
its DSA master which is eth0.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 29 ++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d1d4d956cae8..ff6f08037234 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -474,7 +474,9 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 {
 	struct sja1105_l2_forwarding_entry *l2fwd;
 	struct dsa_switch *ds = priv->ds;
+	struct dsa_switch_tree *dst;
 	struct sja1105_table *table;
+	struct dsa_link *dl;
 	int port, tc;
 	int from, to;
 
@@ -547,6 +549,33 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 		}
 	}
 
+	/* In odd topologies ("H" connections where there is a DSA link to
+	 * another switch which also has its own CPU port), TX packets can loop
+	 * back into the system (they are flooded from CPU port 1 to the DSA
+	 * link, and from there to CPU port 2). Prevent this from happening by
+	 * cutting RX from DSA links towards our CPU port, if the remote switch
+	 * has its own CPU port and therefore doesn't need ours for network
+	 * stack termination.
+	 */
+	dst = ds->dst;
+
+	list_for_each_entry(dl, &dst->rtable, list) {
+		if (dl->dp->ds != ds || dl->link_dp->cpu_dp == dl->dp->cpu_dp)
+			continue;
+
+		from = dl->dp->index;
+		to = dsa_upstream_port(ds, from);
+
+		dev_warn(ds->dev,
+			 "H topology detected, cutting RX from DSA link %d to CPU port %d to prevent TX packet loops\n",
+			 from, to);
+
+		sja1105_port_allow_traffic(l2fwd, from, to, false);
+
+		l2fwd[from].bc_domain &= ~BIT(to);
+		l2fwd[from].fl_domain &= ~BIT(to);
+	}
+
 	/* Finally, manage the egress flooding domain. All ports start up with
 	 * flooding enabled, including the CPU port and DSA links.
 	 */
-- 
2.25.1

