Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12143E01C4
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbhHDNRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:03 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238008AbhHDNQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:16:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MurvQMntGQoBgjCKenlg6s0q0g0kDY5Wp/3cqMiuL76EsOuKZKHmSvNUfy38xBf5oAIKX0RuCUMuAKVwUp49n2Bf5u2aBiYmMbdcITQ6RCRiv2c2kpfGukLwsa59ejjHSZqQyWoO5OQdbFg6oTG5XkOk6WLlepds4trOT7MLNIKkkSIYxY2P59u94gJ/sHfPGAqFNdmjllLi4DHgKVpkZGaNfExhwMAHmpMrK0ViBgzX0ksXHI89/oqPsU1q+6iwV3ls/QIWNwaBXZHAa55iJRDmfXjnpf1GMlh7lsHnL6Cl7fHWa6x9XLVtdxzoHaFckgw0a+MsELJhLyS1HxCP+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ4VLjmrVUZqTzilbfHTVPCgRVFwI2Iy3E4oqB3Vfd0=;
 b=m1goNdBmikK+wfCzofbq84pb1Ok6ONnGRUDoroyChedQKe9qakkp5gE4aVtE+2NzvvI1RyE4a5PTFY373/Q0id+Ec0GMEo5oiLm8KJ6EkRGuFeVEAUjBFy5aJW3+Q/pCodfylclVcDhiIWIYJJVwkCYc+v5dZOmegLYvPXC+UftpOhX6w9swKyMzmfUNju0BabRx7WEyMDpKXOhPOsU4aZtBjfEyThbFH9rdc7TbxREknCdhTVOwx4EJcNgoPH8gqQllXxOuyQaCMKOXLj7gEIA8CcusroTN543kAKEVhQ3PO/xGKQTc0XZSTv+yUP+IYTpN9M1y+jKsqmmWo5NOvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQ4VLjmrVUZqTzilbfHTVPCgRVFwI2Iy3E4oqB3Vfd0=;
 b=Oz0IBlkCQqExn6n32AQTcygOUxpRRMYIWkoqLbH04LdmC5GobMa7WjJOc+2+tnuJ6g2ZyjHO9bytyPv0wloln7I/nkZgw2bMbcUhZWNsdpEH2YMSc5JUAt/UgB4Buok07BwtRNIn5TuBppflXDUHoJB8pKY48L75rDdASTk3zIw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 2/8] net: dsa: give preference to local CPU ports
Date:   Wed,  4 Aug 2021 16:16:16 +0300
Message-Id: <20210804131622.1695024-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
References: <20210804131622.1695024-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0083.eurprd03.prod.outlook.com
 (2603:10a6:208:69::24) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2700edde-94ba-40d2-9e28-08d9574a1a73
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB39676B45A89541297BAF809AE0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XGZaEwGKo98Z1O7FYqx7jpQJpLDVNqae1hcJ4XCwo/yyIfWfRSC6plO95o/iy/eeapiikcKS86NcYaTvj9zyD6AN98Qt7YwmQXfKjjjU/XUrQwjgtP6flI6AGiNHAbr/2PYuVRvnF06J+8h15x2/verEhLtqtZikcDJyRb1WWz9+a7MyUS6JtyUdCAD/EOya4empebFmxTJHwR+JdbZc0dD9f5sWB4hVtUWMt4Ycr/AkNZ1oS8Otk7G05ux+Mfkx0YJb5e5kfbVX7Sixx/xZGY5GFFCut3GdEGF2+VqvfdHo92+qFKQdGXItQL+Yegg3VFeD1+QGQIYKWJWXL0FZimqwKfBpK8RpOp4kCjmLI1fMIucM4uqhcpEpHe5PZD1IsEzBwjldbGOcN+nsS+3xVegAqiB/kgrkfqXlMSXb3Gqqcc7hm6OYDYZrOxYtOtSDssP69Y7nHxRRoGDwl2qxwIPxFVx9l+PONk9BgEmBk/glZWIYPhxXN8g1RjPpkL1MnWbvW+f1v9gVRS2Mz3UZuD8qaRt99J8xek7Pu18T9yflgk8Kit0HEuacwQbvXl72KBNx1hlMyfPAZCoKxqfuIgR59pgtZEcDIdjutzrtACvjJ0B5HyBen77uCubEgE0loWHg2v3NNBtoAU53MDR4UvmDNNXna9daZ/TbklwqT/mwlKmapq9HuTQJe1P1dAKrIy611bVegMEofeuOwe1mvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OVkTQbyrMG9z+tzzi17Y8UEpnK248KrihpzFu9kMsnCTVcPu3+pYXQc4Jx/n?=
 =?us-ascii?Q?kFZ7V/qSW0BBZez31ZrXx2vcdv40+uCSyY2/lumGpaldO00h/iNPFxUfrUx3?=
 =?us-ascii?Q?mgLRnR/GbmSIgtitXfklNuRQlAbjYNg5IXA9/fJySdCTuuy61dXPfjNzZHuJ?=
 =?us-ascii?Q?aIgXfNRQXLjQMUnuKwR6WDWA55HAJEnb0Kv38u1jMuJGiUVmhdhOcgjXbWI3?=
 =?us-ascii?Q?BMRGOQTTGjxig4D2qnZ5L9SVRTUEWaPb0s5mlQN5F32fKejdSSc9dJbrqUh8?=
 =?us-ascii?Q?Bhlh7pxw8IWUeqEd56FWyq0tE5rh7KVfzpLvc577dla6/fk+C1EkcuXibyAU?=
 =?us-ascii?Q?qOfbCBa6nnSG9m5wDO11laYHawOrMAmazLDco1RA2qOZeaT1uaYDXas4J3EX?=
 =?us-ascii?Q?kp3GH0J+uX0GEKN/eq+vFAUdQDHCcslOA20HZq/HlfoJsbPfUlLtqFVHe7JL?=
 =?us-ascii?Q?hFCM5LxK93aTyhB/vkQ3iCUFCCT/JfgOSYK6+DnzAuqK7HNsKW192mxfnfNo?=
 =?us-ascii?Q?sHFqUKQpBUtZ4Zr6OJHj4J12xDfcMPediXoF825FnufTSgE6Lp7L8zXX15/z?=
 =?us-ascii?Q?pDxhJniwAcDDzQgLbKnH1NrfjRKEqFjYsiZy75LHlA0XdLSM06G4XUaryDXY?=
 =?us-ascii?Q?WTCkdc3ipy8UzVOgmM0Me9Nj6L71p5rNxD+NzS+6SPctGi3fcaiuQ6cBlXlZ?=
 =?us-ascii?Q?fgfa0Dw+4TpVuB677h5h8yBaIQs8OmKP2nT5MZV6dKCpk3+n1JGzIzCA3gpY?=
 =?us-ascii?Q?h06WjSzV+HEZG5rh3Hvx2Spy+HRgzfLiWeo4STF+Ki0Pp0uhfxz+KmL1I/5J?=
 =?us-ascii?Q?mBhryMkNeyWzJgJGoqvcu6iW1TFJwNf1Ca4iJfKgPD57vCZ28/+loBuu7chX?=
 =?us-ascii?Q?yw/jmoQuQoBOJGY0YEfwjtKC+YvqyOfkN4jbLza4mGh368BRXzV1G6he6v3W?=
 =?us-ascii?Q?886yB0kmNoatsx6ayAPkuB9+EwUq41CftnUka6nxyGkrwbKdbWFQdKfd8D21?=
 =?us-ascii?Q?PiHNq70U7kcintyT4S9Ko6xZSczVaP5xIntaoBX2/sAsmjhFNDFfkZ9E7oWH?=
 =?us-ascii?Q?muZtDkQV4vsKuNmkJb0yNeU1BerrhsFReSQf6KKazPSwupAJ2uqFKHlTBKp2?=
 =?us-ascii?Q?593Wdjh6Mi1ypldG6MUoOrppjS4rIe4NNr7bdBv29W1Ijt0srFXy3hdSE94x?=
 =?us-ascii?Q?i16WEut9XG9ZqqZQua8/ILy/AgTIrZDFsB+osM7Ppa6LRXmjy7s2ISAj9Wx+?=
 =?us-ascii?Q?WJZER9O0Nx07oJObStzke2BVnnZI32KvRoH+9TRHqe/ACihmGl5FfyNP0cg2?=
 =?us-ascii?Q?s91rRtKr3wAuPgAXLzHGJAES?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2700edde-94ba-40d2-9e28-08d9574a1a73
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:43.4176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhUtl0ATyEuTQf7/vp9JEwXG0mQpGS8dOoU2T8XekYPEQYHcmfhA3nZblmMxT2AiPuu1EOne3ka7I36DUzgtDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
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

