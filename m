Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54E23DC1D5
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhGaAOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:37 -0400
Received: from mail-eopbgr40043.outbound.protection.outlook.com ([40.107.4.43]:13735
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234449AbhGaAOd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBMuBQzbo9J46STbk+MVMaTr4j+z+JaCrx899Z85eaPJz+g4MJYPm2a8A5ZfI04wkvmi1dc0W3JQnrkYhxYdHr2nLIiX8DXfQk/1cYgOVf/8aV52W1I1ZVMYdtaICNqPmTcE0Ll3Xg+NxQLX/YH2YEbq9ti58f6kJnEfmRhHejwG0SsbxBdDv1Vm2LFstFTsOlawJhXsruqZitvOPP5Vv10sjxVmWEuvBgmVuE9tYfVtAj2gYWL6JsgbaicY5nDvKWRAlUMaoYt5gRiEtqmrkbpM/2j9h922+rtrPV5JWZkRLLHwiJH2B+7sO3S5eeDV0ivd2lfAhnrCnoHmqTgIHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ4VLjmrVUZqTzilbfHTVPCgRVFwI2Iy3E4oqB3Vfd0=;
 b=Pl+VMfLPZlxcnrnqf5NAUWafxqG51tlqad3jVcipZ4vpQzl5mZht3MSpfl7MdFVFCDbKjqx8m313z1kmrtRXevIFKITO7himvwM+JR4eYFgj3ke1ksRxPV1ex39OEqOAeC3MP7eGn3AQmRm5jrFCL/fwkHuIUrIK2rYSxns8f7dOSrR3uIb24q/+l2kS5DVG6y8NF1u2mYch/pdFj6F1Hzle4VUIv+R1xd4BsIFw/kRtYMyllKQtgIfrKQMAQLACwNuI3OVyM2XaQGlQVuegNuu8MYVxBv2ChMoI97dB7pVAthAxCATg+H6lkc9SLc4Q4481hehzSgWQhiJ2iy5IAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ4VLjmrVUZqTzilbfHTVPCgRVFwI2Iy3E4oqB3Vfd0=;
 b=BM8UYRFBjIj51chpYXbhh+cb2FpsQjgoa02RqeWWvQY9qVtCGf+w3g6cUsjfGyyFxrPVK//ntC1vUeWWwiqQ4UH6VorNEhA6VW3Dm68DzGhHafyOSwdSPNSk6CYQ0LbpZ5Zcu47l3V2iEyHOMwzgMj4CQk0y5j0OyGGeCCbgCB4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 02/10] net: dsa: give preference to local CPU ports
Date:   Sat, 31 Jul 2021 03:14:00 +0300
Message-Id: <20210731001408.1882772-3-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a462c3cc-56d1-493b-ef93-08d953b825b5
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB651103069E82DBDC28361328E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /5HNXEswtZwEWikRXk5odH169lSXTuvyef1wp9jE3vqrJG6tVSn1E2seEM3TeGXRccz+RrIc/ExwjbjtLoUkLu4l6NeR6mZLJqgWtSDGj0kH4JBXye6K2/5Tiyh0TVTN1WjXPCvvadQy67bQf8EFHv6U5wZAPddtUuds24EFPVpyHQWMdJq3BbmqsDrnC5ttbKm0d54q9ds9bxlrcC2g5MVHNQWvCXajVN0FsD61IhFQpbou72OyFtNYzVPHuRo+coMa0rWIAxmJjLFT9nYagDYbiNqhjkdz6Z2BcdIss4Wwj4zfaULmmqWr13+J3iT8ySC73hrI7UZc4cO+IO4C5NlhCAxdJffmsGLPieLOL6bmP//yhV8wfOXHsLyI0D1FvUiSN2MZW/0WQmvMpNajgPFwi4UJuZWzMrz4ge4iJWBZEuMkm+Sm/msa6n7uu8Kimr6w9Oc4/Rst6jtla6oD4/D6A9oVP98/FAFW0LHP7nxUvafDw4Eq4rfAOXSsUswrQX1OxWWwoxdfI1OAzUJFbOHPAXSY35XAUNCwMOBicNZkZlnGQV7tf87mXk937qcMC3f1MUpeFekHn+lEf6dRmj/7ly56+lCCvEA84YtCyQ15PSp0vBiHxMcFEs8RC7VQqJD1ZhUL67kZ80k9FbqYL5IehpksFxqElh+K637wk3S04cCXGk0VBkxWXyjIaJ2OIPGELltnexWYCaDeGj4VIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fyOeCcoBl9KMA+8XKLjOzS8XH7gjiFuqUtICaRAxoh8ub2Q5bv9DCL1Ezy8D?=
 =?us-ascii?Q?dk42bGW/g6VO5IiLwdH0fRLh6Hw3vqG6RRCpS1qyd1qiNFDCNpab2jDz7EqD?=
 =?us-ascii?Q?xEzCJhwMFUssoQSeKVOeHMvKHfHmTI6B6HBDg0+3wLhfM3ohmpSS0CSokYaF?=
 =?us-ascii?Q?mG+W7R/0cWPceRjEqIASQWFDMel180RW6l+bmpfns6DKpZUlhOX+c4+e6Ytr?=
 =?us-ascii?Q?QCUL089t07P9n9TLAObcjwBMhmuYtySoNYbNyrGEAAc23QvE0bUO0m6Gr/vX?=
 =?us-ascii?Q?1ILDm6qaBpjP+5Jchq5Tc8OWtU5j4jSSFB35IKPJ2NtkaR4rVOepHq65UOiX?=
 =?us-ascii?Q?sYN1RcYuoL92fVSML0r3+V5ecSzW3etLiaDpClIZtw5qhAnJUYqDVtR3mgiH?=
 =?us-ascii?Q?unw0C7L85vcwPypSXYFJSbiiEL3cNNnhua2L0HarClKrmRFlGqEZDc2ZNfhh?=
 =?us-ascii?Q?pKiSFSv9S/rKOS4GpJRYImIZ0hHUzOt6ZVHD7RSidsPHhUBxi2jDII/NI/m1?=
 =?us-ascii?Q?uu+qWanXPYOG8at/3Q4OhFuYcrRsZP/xGqOEUoU3TUc32reBR+V+6tW9Xdku?=
 =?us-ascii?Q?wTGs7Ukck+WjMh4lMzRYEfI1DjuQk9qt0TvHDRIt4mpaUaiSNcK/7+QYOXCq?=
 =?us-ascii?Q?Ynb5QcRda+ToWW9RmrbHbZXffspiuMjEcAgf5lu5+nGbEhO0pKUSFOPBzvxJ?=
 =?us-ascii?Q?V4VWROw3nVWBIY6cR/PgY9DT7WYZXO2AN2+HGY0nGezpOgflZi2oqHS3LNeg?=
 =?us-ascii?Q?SagSkvdFQTzQIbWPAyirQdrNQPDuxRkt+zsmcckPVirDhqMpGkdt4mriYCoi?=
 =?us-ascii?Q?bYJRHzc5JlnM1k86+n7sdJQhmdsjn13/wKXqJBVoqNfwKZqEhRGeNP86fXHs?=
 =?us-ascii?Q?FAfKZ0i9Z6AW4tjIFIOZG7h2vOQwySOPdpxz8dtcY6vbDbodwRXM9PuRG2R9?=
 =?us-ascii?Q?owgPy3TplPiKhPqeO3BS0fwFXfMims7Cy4B5z2kjqLGaoAIxkdQkRxo7BHct?=
 =?us-ascii?Q?GpAp1bLnG/KRm7LTVmI3Q8Ev41QGfppNPgTH68Y1axYO+A9EG7lasTTONu08?=
 =?us-ascii?Q?5emtVt8tCmlNGRyj7qVlH/jMCk4vwAHR9B89P0R3G6irfngC3D9jkdFOOgbn?=
 =?us-ascii?Q?DTXizVD/XDOzaBwcSFjKRz7y+vpZg9rubXnaATzLHwsvcC3cWgHBpt3fZLC3?=
 =?us-ascii?Q?JVLKLaKSPKPL72DmQukDH9uk6v4VkGDDPiSXnEoxYkUGkov4mF/4OwVmKJ8Y?=
 =?us-ascii?Q?40R9EyPsyY+8Q/7o+VZ0iZ1bhHwcjdhdI8KRwvolj1HvcKm5ZKWiqDf45DKm?=
 =?us-ascii?Q?reJbt7MEfdZSP2Nspkg80xaG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a462c3cc-56d1-493b-ef93-08d953b825b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:22.3053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7CN8wux9mLpYHFO3PnA+sT7Nea8gGf4Absrxs4NQy/B603kzSn3RECm5Ibpmo/2OquoU9GefIBuy0LT9dv6fkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Be there an "H" switch topology, where there are 2 switches connected as
follows:

         eth0                                                     eth1
          |                                                        |
       CPU port                                                CPU port
          |                        DSA link                        |
 sw0p0  sw0p1  sw0p2  sw0p3  sw0p4 -------- sw1p4  sw1p3  sw1p2  sw1p1  sw1p0
   |             |      |                            |      |             |
 user          user   user                         user   user          user
 port          port   port                         port   port          port

basically one where each switch has its own CPU port for termination,
but there is also a DSA link in case packets need to be forwarded in
hardware between one switch and another.

DSA insists to see this as a daisy chain topology, basically registering
all network interfaces as sw0p0@eth0, ... sw1p0@eth0 and disregarding
eth1 as a valid DSA master.

This is only half the story, since when asked using dsa_port_is_cpu(),
DSA will respond that sw1p1 is a CPU port, however one which has no
dp->cpu_dp pointing to it. So sw1p1 is enabled, but not used.

Furthermore, be there a driver for switches which support only one
upstream port. This driver iterates through its ports and checks using
dsa_is_upstream_port() whether the current port is an upstream one.
For switch 1, two ports pass the "is upstream port" checks:

- sw1p4 is an upstream port because it is a routing port towards the
  dedicated CPU port assigned using dsa_tree_setup_default_cpu()

- sw1p1 is also an upstream port because it is a CPU port, albeit one
  that is disabled. This is because dsa_upstream_port() returns:

	if (!cpu_dp)
		return port;

  which means that if @dp does not have a ->cpu_dp pointer (which is a
  characteristic of CPU ports themselves as well as unused ports), then
  @dp is its own upstream port.

So the driver for switch 1 rightfully says: I have two upstream ports,
but I don't support multiple upstream ports! So let me error out, I
don't know which one to choose and what to do with the other one.

Generally I am against enforcing any default policy in the kernel in
terms of user to CPU port assignment (like round robin or such) but this
case is different. To solve the conundrum, one would have to:

- Disable sw1p1 in the device tree or mark it as "not a CPU port" in
  order to comply with DSA's view of this topology as a daisy chain,
  where the termination traffic from switch 1 must pass through switch 0.
  This is counter-productive because it wastes 1Gbps of termination
  throughput in switch 1.
- Disable the DSA link between sw0p4 and sw1p4 and do software
  forwarding between switch 0 and 1, and basically treat the switches as
  part of disjoint switch trees. This is counter-productive because it
  wastes 1Gbps of autonomous forwarding throughput between switch 0 and 1.
- Treat sw0p4 and sw1p4 as user ports instead of DSA links. This could
  work, but it makes cross-chip bridging impossible. In this setup we
  would need to have 2 separate bridges, br0 spanning the ports of
  switch 0, and br1 spanning the ports of switch 1, and the "DSA links
  treated as user ports" sw0p4 (part of br0) and sw1p4 (part of br1) are
  the gateway ports between one bridge and another. This is hard to
  manage from a user's perspective, who wants to have a unified view of
  the switching fabric and the ability to transparently add ports to the
  same bridge. VLANs would also need to be explicitly managed by the
  user on these gateway ports.

So it seems that the only reasonable thing to do is to make DSA prefer
CPU ports that are local to the switch. Meaning that by default, the
user and DSA ports of switch 0 will get assigned to the CPU port from
switch 0 (sw0p1) and the user and DSA ports of switch 1 will get
assigned to the CPU port from switch 1.

The way this solves the problem is that sw1p4 is no longer an upstream
port as far as switch 1 is concerned (it no longer views sw0p1 as its
dedicated CPU port).

So here we are, the first multi-CPU port that DSA supports is also
perhaps the most uneventful one: the individual switches don't support
multiple CPUs, however the DSA switch tree as a whole does have multiple
CPU ports. No user space assignment of user ports to CPU ports is
desirable, necessary, or possible.

Ports that do not have a local CPU port (say there was an extra switch
hanging off of sw0p0) default to the standard implementation of getting
assigned to the first CPU port of the DSA switch tree. Is that good
enough? Probably not (if the downstream switch was hanging off of switch
1, we would most certainly prefer its CPU port to be sw1p1), but in
order to support that use case too, we would need to traverse the
dst->rtable in search of an optimum dedicated CPU port, one that has the
smallest number of hops between dp->ds and dp->cpu_dp->ds. At the
moment, the DSA routing table structure does not keep the number of hops
between dl->dp and dl->link_dp, and while it is probably deducible,
there is zero justification to write that code now. Let's hope DSA will
never have to support that use case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4f1aab6cf964..9ff928ccddb0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -311,6 +311,9 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 	return NULL;
 }
 
+/* Assign the default CPU port (the first one in the tree) to all ports of the
+ * fabric which don't already have one as part of their own switch.
+ */
 static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *cpu_dp, *dp;
@@ -321,14 +324,42 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 		return -EINVAL;
 	}
 
-	/* Assign the default CPU port to all ports of the fabric */
-	list_for_each_entry(dp, &dst->ports, list)
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->cpu_dp)
+			continue;
+
 		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
 			dp->cpu_dp = cpu_dp;
+	}
 
 	return 0;
 }
 
+/* Perform initial assignment of CPU ports to user ports and DSA links in the
+ * fabric, giving preference to CPU ports local to each switch. Default to
+ * using the first CPU port in the switch tree if the port does not have a CPU
+ * port local to this switch.
+ */
+static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
+{
+	struct dsa_port *cpu_dp, *dp;
+
+	list_for_each_entry(cpu_dp, &dst->ports, list) {
+		if (!dsa_port_is_cpu(cpu_dp))
+			continue;
+
+		list_for_each_entry(dp, &dst->ports, list) {
+			if (dp->ds != cpu_dp->ds)
+				continue;
+
+			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
+				dp->cpu_dp = cpu_dp;
+		}
+	}
+
+	return dsa_tree_setup_default_cpu(dst);
+}
+
 static void dsa_tree_teardown_cpu_ports(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
@@ -921,7 +952,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (!complete)
 		return 0;
 
-	err = dsa_tree_setup_default_cpu(dst);
+	err = dsa_tree_setup_cpu_ports(dst);
 	if (err)
 		return err;
 
-- 
2.25.1

