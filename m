Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F9A3E027F
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238509AbhHDNzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:55:25 -0400
Received: from mail-db8eur05on2061.outbound.protection.outlook.com ([40.107.20.61]:28896
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238480AbhHDNzX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:55:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPFPDJMb2GY5hhERcDWnyQoPj6RbPyhdJ2v8BqMPlhmURd1lRM3bNI4OmEQ/lwvr/qrI4qER/wmlZaWpYpgsIy4G/DHFGq1e0ZKV7kGNLUGEGzcE0TrWHkzQdZkagRAZm2GYoDPOi+Pd+oX1S2zOAQCV2bklhV8zbE0DKbWD8N+dfb947dQ9tQmU6PVM7BETj6XWSraaoKj8pMPXUGGfnyxtaIoCSVY7npfuR/EBeGmKdPSdzHb+kJmEQhsZzVLK6uRD4kHdQi6sRLHO8SJ7OxVl/Yt+Ir2OK4eX4otzX11z9tO13ndA5mAvMbVkj2ClypHT18qmCaimLM2/gVOLKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiJmFmMYJsZ9bUIo921mVVDZtkXXOj2DhC3Iy290hC8=;
 b=G6TX9aTpZoP4NrM2BN8uZDIres30ElA0gWW9Y41rSTRFkyuME997sr50BD09myHFAz0n7i0H6zZ7mFkxVAElOLK0HRVq68EoTit4Dj0oStqFajnGagL45DrD44bQVmI6BxV+c6AOFtLQ2o9QhQUbqlVEVJ5GLo1DntuctekBVu0WeSXtdAnPGHtNk3SanNVG4IyQDuBkim2GzrZlWF9vPVDjd6X3zo+K6gimZUa0sYmB7XyLqfdrd0nxqmNCrhHUeu8bx8epz9GlCZgzYx2OFM+/bwQM6lASBCf+8VxwC8obqZNvTXtfAjntpBwsO/b39I3MbCjJL7zDr7kPJ6A1dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiJmFmMYJsZ9bUIo921mVVDZtkXXOj2DhC3Iy290hC8=;
 b=orNLNWZjCyG1Zhy/dCrNrxLF9D1LiJGtj/53EiF85bA1+Ze9KH/WLiQgQ6WwAVvG7YQtwbKmKCgAWuOFxxrAW/mEgYgLtqhWP22o3ziPcuKaGR0rAAkAy4B2RSlM+r7lZ/2l4eMwmK+27S5hYyWpbIopBPu7MlXf3RqJhaDOjF4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2687.eurprd04.prod.outlook.com (2603:10a6:800:57::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Wed, 4 Aug
 2021 13:55:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:55:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 2/8] net: dsa: give preference to local CPU ports
Date:   Wed,  4 Aug 2021 16:54:30 +0300
Message-Id: <20210804135436.1741856-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
References: <20210804135436.1741856-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0155.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR01CA0155.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 13:55:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6cd462f-b5f4-4dd0-6f59-08d9574f78db
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2687:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26878233B506CDD61AC928FEE0F19@VI1PR0401MB2687.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFR8xRhlk6tNjIU+N3t0PA7ODTPp3VxYvdhSceRW1s9JasIGF5VMPhLrH/IUdbsyJ5GPEj1D2ocakVuPtlgD+GLyZLUM172cIhJyzz/HWVSXq2I9Td+yPUOnmqgFeEkp16VVfLN1MwpWKhl5yi9Ote29ccz00WsOxmg8ZIwpN7KWMV9tpkm+8eDsSaxU7j7vCZd/66MZmThcnVJte1HVyo5y+SUW54VWh/Yn9ecsOhk64KNtqdw4wdgGzz1YguLhxN358NEIVp25fqF842RlFlOij13TFDCGf/A/bSRb3v9yzlhsxS7zcyO3E1gJ8Ll8DjQWiHrJS1CoOWFl+L7WrSOuRJW+GHCUKTdmli9s5U3bLIz3jgozGf7gKWzKBWcNKmtbXGFMbxngxGSbaEcIkTetblWivrEobKFB8Qh9YjgTe95ap+qsRJpgUw5lRx6iwBuG3gG01c/qST+ef+BMiWCNG1l3hawD4Y9y5khbY8GMbIyqJvOCNKOKFgETP8oqVHKiwN9x2M+8vEQsvNs7mdNixkgmW/k2klnfOXvRLK6yTcLow8DaB2aPcr39T20AmDe0NzB5fpJcb7ffuOtPmfSVJ4xl5cuhPXCbeChlsxgRaHTsgXBM0EGd8ytKmOaUxk1KXis8c+2zH9qCz/1IHiWgd6ECEnrQu9SvM/b1sTdki/x1WDaxVdWirTAZBJaCn5SR/G80Cd5JI8d2ZrZAXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(6666004)(6486002)(5660300002)(478600001)(66946007)(1076003)(66476007)(4326008)(66556008)(54906003)(26005)(44832011)(38350700002)(86362001)(2616005)(52116002)(8676002)(6506007)(2906002)(36756003)(110136005)(83380400001)(38100700002)(956004)(6512007)(316002)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fn7bkNxfZESRy0Qa3HdMVhEl9lj305zsY9b2r4V+OB7uU2fxDv/rNQOKt0sR?=
 =?us-ascii?Q?cxNceIUq8//t86wHM9CyzdmBFwTXPStb1WLKjmuJCFzPOVby2CUrE0pBnEWv?=
 =?us-ascii?Q?eFaj+7zuxsh710fEtvyoc5uHUPJQoEjV29LqB+9m1YAQIgkCosSONwnrJQx3?=
 =?us-ascii?Q?aUg9XprQZnEsiZUG0k8g4wUTwWi5lree4EtaaNx+yw3rOVxl5trQZGJJ/fNY?=
 =?us-ascii?Q?5HaY40nijg7Jsx/x9I/MPwWb6LsBKPYavU3dyQDFJrg2og6ZZrmEzzneFPnL?=
 =?us-ascii?Q?/0cxp7Bnxkj5U83C1ZGqik++ZpScM2Qvrwy/B/hmIgGKFBIFpuBx3JQoH6m9?=
 =?us-ascii?Q?yDlAnnnexq0M61Sg1l2qa1BqXjVK3P56cUrQIanGU+t1zIzCQBv5pVVG/Pod?=
 =?us-ascii?Q?XT8FIR10EgoVu1yq0YFhb9sD2TIMnc7F3Pyo7ahdFOnAja+Xt/2TaomNgKhS?=
 =?us-ascii?Q?xWw+/FKNQa7wmbfHeOOIsf+wF92Sld5HS5tpSF8jlD8PqqmIPdC6GhjOt8w2?=
 =?us-ascii?Q?34l3t3RSTZ7Bno6t53M91E/37tiAWHYUuYh/RIK/kuguIcCYPXZB9SuxqNI/?=
 =?us-ascii?Q?oBXQffe8T/ZiQPIKS+uDvrZ6C+LiCK2j7pBVJTVJVgzcgn2zKmMbvb4dfAOj?=
 =?us-ascii?Q?PT+6zBGLJ2SRNAP9dcJADVRyoitvocsyYNlM0FUhONg+xyrBU5YQY4d1G12A?=
 =?us-ascii?Q?Ft6Dv3eQ9HLx05QECBwyA0t+wRza49S2/WBcpsem3RTDas/yBEwfmnU8CEH9?=
 =?us-ascii?Q?mZLz0KUEmmg26bnVi29mfeDby7MxK0TgDSeDbjRGBRQCyU8V+RG6k+105jWY?=
 =?us-ascii?Q?JVQ5iCqqTu6tgZwP25gV/iAwRXtYVfXGtJuyl7JqbDMqvKypkQndYNuSFu8e?=
 =?us-ascii?Q?1/jcIaMrcdx6qXq0pD+VIGDF2po/gA2s2UB9LaWreimyJoPJtD+6C7kY6fQg?=
 =?us-ascii?Q?1imlhgSE4IQpBWdK3kvyYsOb6a0hbNvhptguGECSKENBDIbF/fcJzQduFPo9?=
 =?us-ascii?Q?imShnHvM358pd1xaVYNL1yQMEladIUjMdMrvOuJp/q6m0KuUYxPmKKxM2J8j?=
 =?us-ascii?Q?IQrvwicc3X3hBSntm8ReR/ofZBWnpNMmfmBLCgYnrzr3fao0TCrRpy42o5H5?=
 =?us-ascii?Q?ZE2plhzqAfhq9+zh0VkNw5t5mTcXXwDPY10zgKR6BRTLA7Yweg42bTN+lY/I?=
 =?us-ascii?Q?YSvUS0I7Q2b4peNU5J6onSfk95NFHc7717KGNH/Yljg25KA+kfd9E+7/xoKL?=
 =?us-ascii?Q?lR3omObZ8fGOPobqY41jHTwEpBMZM7msixby0cPUyvx9z+fhKcIAxSlURNhX?=
 =?us-ascii?Q?SeGH2l+h3AHeTExn3ckKAIvy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6cd462f-b5f4-4dd0-6f59-08d9574f78db
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:55:09.2954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiaqDiXhBB3NN8nOL59Hd6uBDlHnoT6GNuM23+rwnnPi2n8mUMdCW3U5HFiLSE24QqkqZBL0Aau5KwmZFOyu5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2687
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
v2->v3: make dsa_tree_setup_cpu_ports() not reassign the dp->cpu_dp if
        already present, which makes each port get assigned to the first
        CPU port. This coincides with the previous behavior of
        dsa_tree_setup_default_cpu().

 net/dsa/dsa2.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4f1aab6cf964..a4c525f1cb17 100644
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
@@ -321,14 +324,47 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
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
+			/* Prefer a local CPU port */
+			if (dp->ds != cpu_dp->ds)
+				continue;
+
+			/* Prefer the first local CPU port found */
+			if (dp->cpu_dp)
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
@@ -921,7 +957,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (!complete)
 		return 0;
 
-	err = dsa_tree_setup_default_cpu(dst);
+	err = dsa_tree_setup_cpu_ports(dst);
 	if (err)
 		return err;
 
-- 
2.25.1

