Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7259B3E01C7
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 15:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbhHDNRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 09:17:14 -0400
Received: from mail-db8eur05on2086.outbound.protection.outlook.com ([40.107.20.86]:63904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238360AbhHDNRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 09:17:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AX7FZ8EOvLsmvWV060XAvT0UaLzivpBB4MMtuc564Uinj4+BCEV4IKWunb75JJFQUm3Sz9CHjXlIR3W8nvvayie79swlJ//L5Waw5WfwZGFf+9tojW6cLauEFkk2SllUG4gJhGhj4Lyuzj52ivLAQpftvix8EyNorX1GbWY92qKwOZxULoBOC+3cQQBo/uZRmBsCKHBiMHKD19R25aNJ5p2XlBD5kkJ37pDwn3wH0aOpiE+/+3GcXy1EN97K/XeGE8ZQr7H/U8RGnT6L7WdJ5ZCc2SZcczkfdHkFGUAbR5nvbGP53R9PzAwM2QkggJw6Gvks8VvxYRrcGNoWPyz6xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FUbX4vC43iGoyFViHGeh8jv2RK37AK+Gwbm2JgVWoQ=;
 b=mwB42miRfhtuZtVHsl01zrOx5HQIgB8gV8GN4kY6eVYl42ayNSHtNCXIkm9htAfB/T5qswMbHpkrRGq+uw1oJ0sITsqFKouGv6lEYwQmdSlXYSmphgTimfOG6ikiQ+t042f+voTrLQiHzsWsORiyxtyxTY/Z6fTrTWhXMYA6w13aeMSh+rQgnI2nld4WPiGD9JIDlvF8P2s8D7aXmlp+vr9wLLYT3UJ41Sk015+Y41+TCYzvpzsIOxqKQDlmhVeryfh81+Au9Bv/VoHuWH2PLhIxaRpqj7VwV5KOPrTlGmqh2xsFQ1iaWl/Nz7xK2wIyLhhBIuhBi/v7fS/HfOY8ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+FUbX4vC43iGoyFViHGeh8jv2RK37AK+Gwbm2JgVWoQ=;
 b=YfDP/M4AYhXDi26/sRmVAH7iFR2X1vbXlhOTrHwSBOogNzmxzFLTA8gqUpfDQjLVsk9m7RfAEq/qxJg4mPNamgVcI7oHRgDqAP3hhgLQEulBhhMEuwY1SDJcCvImoNxD04CurdczDZFIcxTCnQFW5Ttv3Byp8/qveILfg2J1aPw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 13:16:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 13:16:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 4/8] net: dsa: sja1105: manage the forwarding domain towards DSA ports
Date:   Wed,  4 Aug 2021 16:16:18 +0300
Message-Id: <20210804131622.1695024-5-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM0PR03CA0083.eurprd03.prod.outlook.com (2603:10a6:208:69::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Wed, 4 Aug 2021 13:16:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c45303c-3916-42c3-cf8c-08d9574a1b8e
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3967ECC2282FBAD8C948240AE0F19@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2pp+UzoTgdtO4KXOgJThi/k6gRX2HJiifBfr+l9GgjtsIdtQq43oq77YyqRIlEotBQQy9nkME2u8qLyPsiUk074rkHbx5gFDcFZVy2qwfs3o4ytJFSwFcQwe2/I6AuD0y86PHBjXKY1KWMZIzSUNNFiYkj8wF9WuVQVrzJC5Pg2tDQbDlLEFBPxe9x0SXspf3724hs7I06vzJg2/zK0XlS4cFpLG+u8diK54n84jodSTGCo21iY0hrsFzLStLJEbvvHtKuViIoRLYWi49dwbA/bRcLgd2siwaMYJ8wUYj9Q8wat+PjWzgJY0pkGsFhY0n7ZUI8L317ioxckhvDweL4rcc3J3OkcKXJ4CY9sd6tUzc+LZLGLUlpzJz2U4yxETO1EO01NpN0yp/tBUnzLg3MZpxZvwW20I5OiJZRkEVa4U8aTib795b53yaXSaLY4ZYPOswCGlFyN0JPPp5kyXogoFvsTZojjj/T0dxSKUJT/pTAhK2eRCxYd1VeH5RA2xDcubg6pOG5+H0GHuFrG57CEesPDdD861Q4KpyE6SZWVvjeCfymLKH4dGh+mBpT5g5W7zgiBVM40QnpT4v7cVs0BPdbveZbQziccgSiUEm808Q7CrmKc1CHeV5slv1Vx+z5n5FcVF+IkoG32IIUOOztl8mpHj81SQ6gxbhWOlM91bUMIKzlCrmHjuvZfHwD0H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(478600001)(36756003)(1076003)(66476007)(2906002)(6512007)(66946007)(83380400001)(66556008)(54906003)(8936002)(86362001)(5660300002)(8676002)(6666004)(316002)(26005)(6486002)(110136005)(6506007)(38350700002)(52116002)(956004)(2616005)(4326008)(38100700002)(44832011)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NePi7wxh42bkJJo/VhUdP6r8rXcK3FLYtT1kbXEHP7ZhluhVUWNcmVZVtRcE?=
 =?us-ascii?Q?1VKEqUYtVwPuETzft0SvxLrUSRQoZ46Ey7I1xR2esXI58KSMLnS+fIUcVuZx?=
 =?us-ascii?Q?AO3NpKIv7858KyBRZC+37Nov9L5zyBVVqvmCpWHL7KaQKFOA+Foy6KoI5X5z?=
 =?us-ascii?Q?PTSj1nZ72GVaitjGIvmXA93j3xRPJN93IdwHWvIQi8v9glh1kZWyNPknbrgt?=
 =?us-ascii?Q?xUz0NHN9UWcUtUpQINLAKk0eC4JQd2OWBWRSP8YPDCDEFFy1az7n1QBQqDDK?=
 =?us-ascii?Q?B2XxcU/WHXy3yVug+3BTZ/LkbB8HNWZJKRwFkV99Sk2Bre9sjBMpISPh5MVq?=
 =?us-ascii?Q?PqEYNJx+3t3/clhshnthsWdVaa2xT681ePdIt/aqojr/mB0LbD3l2IhB0xay?=
 =?us-ascii?Q?zuSjYsu8wXRnA/dP3eRVvEwha2wZKMnHW79bzBUZjz8g5abi5WMm4L/Gk1tr?=
 =?us-ascii?Q?c3VAnOPXBoZBjV5abZb/rtB/yruLCFz+QeGxT81I1yiU1PlupLEjyKpV9BbE?=
 =?us-ascii?Q?J4qvxOBjIM/wyTAuvXyVirIcuoiNA5FL9a5bdSnKxz4sMOJfk0WBud6RS86P?=
 =?us-ascii?Q?EVkrw6EaEZOBkNWryKo4/51yXI6pDI0W+rt6WxPmb94YAq2j5Zbgy2zy1akm?=
 =?us-ascii?Q?QXlGoH16htUN2XkPiQQeQtadhTgAjsnumVldhH4nE4hY/J77UeJY6bmr1OjK?=
 =?us-ascii?Q?7qViJ0saELaB8UzBkP0Ds2CupVO58M6upupC6iFNVD7BBQnraR1Y7TQg6wEf?=
 =?us-ascii?Q?sNpPKab0SHFFltaLnqG+R+J6Nyev6Aoo+jRjVwmxrXRoXtFWiBJQdVjFd4Mi?=
 =?us-ascii?Q?WsSb7X08YiEFGST9jiG217cgBHXcxKurdY7axtH4vihQNqCswBINZJ5tZ+1V?=
 =?us-ascii?Q?yZgfaK7bdhlZuqXPcCCiICEp9dZWp4LiqsNbMNBHdQNsZupPEpwEcjCbrWfB?=
 =?us-ascii?Q?42XhkPtI4dqVryojmzqAgvi3ty00i4p5FKlfUdKv6gE4V17ztZ5YDqPgkXXp?=
 =?us-ascii?Q?I6/+gTDk4tH91YKpBskYp+e9ClpTvlbxs27S9NIzqm0vWfW8YNc4G5bhx7ti?=
 =?us-ascii?Q?rBHrKj11ic3kSSYAMVz22JzUWAUQVWabT/RMi0JVpVbkEjBqJTKhb48msjMc?=
 =?us-ascii?Q?jOjNVdB5IIXquyGiEeVw+myUvk7m/fjUkAVgHzWGzpSY6YaUQHV/mY1goRsW?=
 =?us-ascii?Q?ARCL2bX1dqHJf7LC0/7grteqtDYSJkCiyilbIXlZoC1GFqiXlqgfAkdVM/oJ?=
 =?us-ascii?Q?UQOvJem1AhXncI+t0b+7Ya6NakYli5xzDtIWXKh2UEQmPHfJuwdWQU8eRC5l?=
 =?us-ascii?Q?7ljpOPmfJtbkHuxTme/QVoPI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c45303c-3916-42c3-cf8c-08d9574a1b8e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 13:16:45.2555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGi7/McikVo0vjJP0XNvQiSDWW32HSkJemVEkqB7mDw47HuMUSK3RVxPEzlvnzEkjm3ypp6xIKO4qPTc4tRS6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
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

