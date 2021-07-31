Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535173DC1D7
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234737AbhGaAOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 20:14:44 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:60521
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234520AbhGaAOi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 20:14:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADprBsB4j4sIiBoQa3HagBVt1AmVF4lTD9kB2h+GMrTicCl0c7P971vW0I1wBdJJsjADMkh8XjSGyTgnI909i4UL5kXy/9K48xtC4xkwd48tSaCv0wnoLJeC4/dxXyEjFosLe2o0el6i6Pn0V2mHRV7ReBlSkfJRN4ASgSf+coQR+dOlkaDQ9IdLtaijEIXrFAztizV4e2KOooIZ8+LRRDlGmx3QpDGdy7pG1CsbjvYoUzNF0/1PYCdcTCA3TVJLBzCNKOgEsLpHQUgj2scDdpFDDv0ot54p5lMh3uO7jp1yCYR4lDqkOK7fCmUA6PXNKHtjZ9O3UQ1loIEcZ5sY5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FUbX4vC43iGoyFViHGeh8jv2RK37AK+Gwbm2JgVWoQ=;
 b=elnWu7WdYFHHewy0t2LIYtuUns5jToFCSnohDxUNaKXmL8Rk+qHgMFE9HaVdck/EfjTHEhxVoDxk15hDKMQbnH0RTclmzq3+FosORCurlASy7gXLWvgL3agG580SmJi2Ydtst5Ey3I9e3UkSpLzMCnHbiYSFx8wcG2xh8Ow3dnZi0m86xILOXstNQrkL0gTArAacN3+s5e8+vIiZxWrTZW0Y3OhF2kEm+eZtCkGqbf1BMmIBuCMZxy33fz9rg/rH3tV7mHKktTcbtdtOrDIOmi3e96nG8cJXudS2SntwgGBGyQwp3E4J8cvE07v5JEK+1wryS4V6+sDA/BOkZQi4Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FUbX4vC43iGoyFViHGeh8jv2RK37AK+Gwbm2JgVWoQ=;
 b=U6DxzYChyhisFaB36yYLkfiHPtJw7l1MC3D2sKv6WXJrVkcxrDL6tgXKYUo9S7Ps1OrGlXsLG/ojCLk62Lpxvwnadc9Tls8gnsgN/5gKSLDKkZxYyIt/Tp3AtNen798aK1+qeSyGJDric/33z6NSs7fjJLKZpmyaeGq/FolyyZE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Sat, 31 Jul
 2021 00:14:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Sat, 31 Jul 2021
 00:14:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH net-next 04/10] net: dsa: sja1105: manage the forwarding domain towards DSA ports
Date:   Sat, 31 Jul 2021 03:14:02 +0300
Message-Id: <20210731001408.1882772-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (82.76.66.29) by AM0PR02CA0161.eurprd02.prod.outlook.com (2603:10a6:20b:28d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Sat, 31 Jul 2021 00:14:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fa6de38-f6b9-4be7-3b3a-08d953b826ce
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6511400B75FADE3FCABD2620E0ED9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKjI9OKtrHo5KUp+9ZeF1TVvO6KSCgwsFE7PBR0GtRG+ihQus4zjbQzuBq0MYGSKF0OqMoRdcX/uJb2dvZ9Wka8Rgc53jtgolMCnklzGjdTShszM3K83oGma0w3UzyX3PnJ00AaogZ3bEzhTzUTCiWS+7tS6h9HFO1e7DfIbX6K41M7f3wEHUo09/lZGljDqo6Z+eCS9ok+17t5CwTvkQpT7CokL4/7nbJtjNQ731F92eizLRA4z0jGHYzsqhilZWs9XnDlALguZqvmYR7P43AMHBHcJS7F3Cz7jrfjQQiL0qQIsbtvjO2pTok9Qvzw6eA+P6m3+4RwNet55+Dh5Qy1j2yWjEWLD8tgRr52n0cLlnDrkvFE/F28Eq/9/rgWv7e045zKCAGl8rZZzN8xs9fPehrocOEtvkszcZ3BLWgeWB9ExsnjIYJPBYJFJ+aMlPkLBXeTIikFX7O8k2nW3WxMw7SiBScN0zAabYK2bhz13W6lN35iVHofCvaj+JkWf3nclf3fvR3OvsFsWOezN+K3Nt8YM+St+9Mn/OYWF+1SJYGDYWA1WZbZsanrruNkTlXicw20jFBSrzFi4AaiawOm47lo/D55FjA7TTcQ42/anfpOeQ4OUb1eHqJjW3AOSgCpWiq3cTfjOVTfh/1+CN77hVNve73YizGYm7KObIz0UyYVP7uHGKnGqqGqm5UsF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(186003)(8936002)(6486002)(6506007)(52116002)(6512007)(508600001)(66946007)(66476007)(4326008)(66556008)(956004)(5660300002)(36756003)(44832011)(38100700002)(38350700002)(83380400001)(54906003)(2906002)(8676002)(6666004)(1076003)(110136005)(2616005)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a5UYvJHYlErHZwcafnsuzkKO5osZCkXkDLQxkoUThJF5+Hkor5HCCvU/vAtP?=
 =?us-ascii?Q?2PclYCMmlWBbpxSuDzQqUx6GNYMBiF3tmSgUtPStOl0sWfV7Fmta4s9vL29b?=
 =?us-ascii?Q?MYrmWXJRHDOkI0J8Ddki3t/4wRbgXxdF81BB7gdt8Ow6hulHcD2++uDX0C62?=
 =?us-ascii?Q?DLlP1AGy8uf0FfgymY1eITRfLj7BB/Y57BxQy2AZjrp+pU35KPbG3ntMEnnt?=
 =?us-ascii?Q?fEwMmYVo947wKPJtVSpSJvXEcKGgMCKhQONd0qo+HXP+lpkwpdluRutAlUa3?=
 =?us-ascii?Q?Okuwaw6djcbk7CEE3pvp+VEYtJNJmg0sYb7Y6Ut2oXw7arJXbD+ZiCeM4jZx?=
 =?us-ascii?Q?JhRm8UOywEs2josCFtN8xsWbjSoS8WKXhFLZPL9IdEkqXeqlISEP0BOZUFSt?=
 =?us-ascii?Q?QKwoCUhNa7/VPcF9S4HLBzVL/OQpcXqn0l3d4RYIy0vdTxKYyMX9BdEXnAl7?=
 =?us-ascii?Q?iWh8zDvqS8mFh0XjXTkzc+CArzJf1WK71/T7FdwvBFqwyG8YCuw1ta5Thn59?=
 =?us-ascii?Q?rKCD4JC97oRAa3rORX5sVMyL1gZcuYRPmE+Ny6Xl5bf7CgFSjKLo9ngD5ilo?=
 =?us-ascii?Q?Ahr39hVYzwQV80k/B3REVAkimRO2eSbYoG0oHu0quesp1CXmWYcsQBcTNvQO?=
 =?us-ascii?Q?58LSfser4XoavjClF6jCyqoeFRjlMVz/rDWJvgHcndKfwnNRXVQCqempL/7f?=
 =?us-ascii?Q?A+fJHJKvw6yYKKcdM1V55UNXSt+HAJwaTzPc32UJ62NZ+2eM/WUqyJpBCZ58?=
 =?us-ascii?Q?9Swq+2gmdBJZTwJVlb3LG3DtS8rATcjXRvhray0HxTE5y9MWf6Vi8azfmBzA?=
 =?us-ascii?Q?LuOlS2sDoeIGmeNnV+KOJkxS1iMj2x+hwATSZ3NrSg3UHm1RmsIIMZ6UdizS?=
 =?us-ascii?Q?TKU3qjoPeNF6ARENBK6d18uON4td8ZMsTJKi32zuXj0Q/mQhy5KR2Uk3MBsm?=
 =?us-ascii?Q?HaKALrRKTHJz78ZqwbkYb5cYaJ7XBWqA54QvCuE2lbx/2+0bLNzSs3HfAPUS?=
 =?us-ascii?Q?O/jIVBJYP9++8zqpXpOwPqcuSgGg+9HuLBC9TxWEcQ0jvtXT97jsGThVALu2?=
 =?us-ascii?Q?iypL9aMawLLgnMDgWecTERKow4ebUKPXcrimo7aSWIwWcBvub9ONdw8fvwYs?=
 =?us-ascii?Q?PJADOCQiCApusWHpp4XUfVPGaXmkljaf2/6mEWgJlbvwCfXVpCsuCH8TSpeN?=
 =?us-ascii?Q?HXkES4RsfoNEEkMBSi+meZ4+L3dP1s4jIm5vPcgSp7MpJpNO5Pf3MDUrVwQx?=
 =?us-ascii?Q?5HYwvY9PjutVHj9lPE5NoABvkr7g0tKqhLMakkV3ZNzRZDjTnQ1epdtllIdA?=
 =?us-ascii?Q?2Hsuy+Tu76LOFk4D2DFUB1Vg?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa6de38-f6b9-4be7-3b3a-08d953b826ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2021 00:14:24.1562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D7ibPJr6LH2RYZJl3dERGk8ryLlUCOCm0wWOApXZOIqS9ekW1jJZ1ezNtXC+kMAX1j7sdqF7igM3864HAgjTQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manage DSA links towards other switches, be they host ports or cascade
ports, the same as the CPU port, i.e. allow forwarding and flooding
unconditionally from all user ports.

We send packets as always VLAN-tagged on a DSA port, and we rely on the
cross-chip notifiers from tag_8021q to install the RX VLAN of a switch
port only on the proper remote ports of another switch (the ports that
are in the same bridging domain). So if there is no cross-chip bridging
in the system, the flooded packets will be sent on the DSA ports too,
but they will be dropped by the remote switches due to either
(a) a lack of the RX VLAN in the VLAN table of the ingress DSA port, or
(b) a lack of valid destinations for those packets, due to a lack of the
    RX VLAN on the user ports of the switch

Note that switches which only transport packets in a cross-chip bridge,
but have no user ports of their own as part of that bridge, such as
switch 1 in this case:

                    DSA link                   DSA link
  sw0p0 sw0p1 sw0p2 -------- sw1p0 sw1p2 sw1p3 -------- sw2p0 sw2p2 sw2p3

ip link set sw0p0 master br0
ip link set sw2p3 master br0

will still work, because the tag_8021q cross-chip notifiers keep the RX
VLANs installed on all DSA ports.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 84 ++++++++++++++++++--------
 1 file changed, 60 insertions(+), 24 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 74cd5bf7abc6..66a54defde18 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -475,7 +475,8 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 	struct sja1105_l2_forwarding_entry *l2fwd;
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-	int i, j;
+	int port, tc;
+	int from, to;
 
 	table = &priv->static_config.tables[BLK_IDX_L2_FORWARDING];
 
@@ -493,47 +494,82 @@ static int sja1105_init_l2_forwarding(struct sja1105_private *priv)
 
 	l2fwd = table->entries;
 
-	/* First 5 entries define the forwarding rules */
-	for (i = 0; i < ds->num_ports; i++) {
-		unsigned int upstream = dsa_upstream_port(priv->ds, i);
+	/* First 5 entries in the L2 Forwarding Table define the forwarding
+	 * rules and the VLAN PCP to ingress queue mapping.
+	 * Set up the ingress queue mapping first.
+	 */
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
 
-		if (dsa_is_unused_port(ds, i))
+		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
+			l2fwd[port].vlan_pmap[tc] = tc;
+	}
+
+	/* Then manage the forwarding domain for user ports. These can forward
+	 * only to the always-on domain (CPU port and DSA links)
+	 */
+	for (from = 0; from < ds->num_ports; from++) {
+		if (!dsa_is_user_port(ds, from))
 			continue;
 
-		for (j = 0; j < SJA1105_NUM_TC; j++)
-			l2fwd[i].vlan_pmap[j] = j;
+		for (to = 0; to < ds->num_ports; to++) {
+			if (!dsa_is_cpu_port(ds, to) &&
+			    !dsa_is_dsa_port(ds, to))
+				continue;
 
-		/* All ports start up with egress flooding enabled,
-		 * including the CPU port.
-		 */
-		priv->ucast_egress_floods |= BIT(i);
-		priv->bcast_egress_floods |= BIT(i);
+			l2fwd[from].bc_domain |= BIT(to);
+			l2fwd[from].fl_domain |= BIT(to);
+
+			sja1105_port_allow_traffic(l2fwd, from, to, true);
+		}
+	}
 
-		if (i == upstream)
+	/* Then manage the forwarding domain for DSA links and CPU ports (the
+	 * always-on domain). These can send packets to any enabled port except
+	 * themselves.
+	 */
+	for (from = 0; from < ds->num_ports; from++) {
+		if (!dsa_is_cpu_port(ds, from) && !dsa_is_dsa_port(ds, from))
 			continue;
 
-		sja1105_port_allow_traffic(l2fwd, i, upstream, true);
-		sja1105_port_allow_traffic(l2fwd, upstream, i, true);
+		for (to = 0; to < ds->num_ports; to++) {
+			if (dsa_is_unused_port(ds, to))
+				continue;
+
+			if (from == to)
+				continue;
 
-		l2fwd[i].bc_domain = BIT(upstream);
-		l2fwd[i].fl_domain = BIT(upstream);
+			l2fwd[from].bc_domain |= BIT(to);
+			l2fwd[from].fl_domain |= BIT(to);
 
-		l2fwd[upstream].bc_domain |= BIT(i);
-		l2fwd[upstream].fl_domain |= BIT(i);
+			sja1105_port_allow_traffic(l2fwd, from, to, true);
+		}
+	}
+
+	/* Finally, manage the egress flooding domain. All ports start up with
+	 * flooding enabled, including the CPU port and DSA links.
+	 */
+	for (port = 0; port < ds->num_ports; port++) {
+		if (dsa_is_unused_port(ds, port))
+			continue;
+
+		priv->ucast_egress_floods |= BIT(port);
+		priv->bcast_egress_floods |= BIT(port);
 	}
 
 	/* Next 8 entries define VLAN PCP mapping from ingress to egress.
 	 * Create a one-to-one mapping.
 	 */
-	for (i = 0; i < SJA1105_NUM_TC; i++) {
-		for (j = 0; j < ds->num_ports; j++) {
-			if (dsa_is_unused_port(ds, j))
+	for (tc = 0; tc < SJA1105_NUM_TC; tc++) {
+		for (port = 0; port < ds->num_ports; port++) {
+			if (dsa_is_unused_port(ds, port))
 				continue;
 
-			l2fwd[ds->num_ports + i].vlan_pmap[j] = i;
+			l2fwd[ds->num_ports + tc].vlan_pmap[port] = tc;
 		}
 
-		l2fwd[ds->num_ports + i].type_egrpcp2outputq = true;
+		l2fwd[ds->num_ports + tc].type_egrpcp2outputq = true;
 	}
 
 	return 0;
-- 
2.25.1

