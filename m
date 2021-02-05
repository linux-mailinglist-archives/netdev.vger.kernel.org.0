Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C03115D0
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhBEWme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:42:34 -0500
Received: from mail-eopbgr50055.outbound.protection.outlook.com ([40.107.5.55]:48454
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230373AbhBENH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:07:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SrjMqKcpufZAvkrOmG6cxcSE6WzGmeqDirJHDyABkKawxsdK1XCS0Vq1z7uWu6GFRedYP1cEYLMoh8+61PtHHqw+EAyHDXU5UKwjI1Cxl+4ycfu/f1mMs2/KNuaSZt097wSBwYdl7l7GbXqiU7BUa3NyeNZUbwAEa809Z+Qoh4cpIoZC4hYP3dD8ThDsZvvhyhcZWpwEK/Su3UBFCpVrgDmHt0u1GgjA9JGGZs/0FR8x6Q06pcq/cdYziI0BKRv0WXEEqFNyZVJp+P0AKh7UFZKAQq9tiNcPL2iSxdsY+QeWuNkMQhzK2RCVHiNKG2UeaUTU+eMSKC+isGcg+JfXVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEsuV7KHvJazsixLqMGHAuT7jOzle/sdox0jiM/nJRA=;
 b=gxyBahjYpc0pvGkK+aMA1cJrLOzcnsvtveTB7ug6nBarpt5Hrn0Mps8P7+bdGQUhJtisSk0ymZsBh8RCnwjJIbE0CR50va+O0HjBGMFSLlWX9Xh8Z6expo8kqmR6BNNxDsGAl81NgJC8Q24Pe0/gpwslAnwVW26M/L99GqSLdTabTLV1oLhHNBH17ghXVOzuhDipO9w6ac70ZYs7i9xEHBitwvmTPOYe2laV5b3fu9ncqSSB+N2jUryQziuY4GxSna5wNZ5sMk0Pkv4V7Ooz67E14oq713lyqO5GHIp5Dzx7y4KvcrYfSwnf2CESoea4jFzHqrQmWRJY2Q9cI6swiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEsuV7KHvJazsixLqMGHAuT7jOzle/sdox0jiM/nJRA=;
 b=WWo2OEnQtYzriRwAFf0nSRqwnWTGgTcRXoZTbSsW8Rqv9WRTmv53hgwd32ZCur7Xb5BgNX9FjpCjLO2mdzgoyVLeL4NCoUzOXlO+1SYrLpp3LevYiwiGGDDcBp0Q3GnEKsF8IZAjz2o0fQ8g8bSNjrYJZ9rfFnUZl/d3lFd7Lr0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 11/12] net: dsa: make assisted_learning_on_cpu_port bypass offloaded LAG interfaces
Date:   Fri,  5 Feb 2021 15:02:39 +0200
Message-Id: <20210205130240.4072854-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8542b12e-4efb-43f7-2ff7-08d8c9d66111
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863FB6F980A0AADA144E482E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pEegyLf+otkv6S6H0Z3IZryzSFxHGvZwYSHdvXF18ieInfV67Jlx85pbGYaTHkgW926ee63f7xsXIewJkzPG1saHKOlC1tduM+9bvJdXOv6HnJuS3y7pSb/HZjf5hRwGuXPnBSxUfKQUK7Dk8yBGONXn/P3KVXuk8ppYc5LXWoo9BdbIx8wl8zJStfAUpF4x7ArXnHLpHRHjPCsZtHifzTViUBjef837nZuBKLqQRtFha3wmhflGSftBEBnXDBvVBBzlKb4uTCfxBqmO9wky+YR1KRgOByGgD8cmNftQYmD3ezYVIPocfTZcQ1z6xbt3g370mklLsm6nGunAH2iTpU/tJrPSUmP0pDnjiZtYe6iJVPZACs2Hs0Iu0KBA9njxpscc++rr5fxaXbZE0s+/W6YmaSrV8OgiEUT+U7nmAKoEGt2aNUNfN6VJDewbysjuMzC9aEMLwfN2uozUZaeq4xBCYKfoNagem+Y6LJbClobKRmKDhc92mNtHHEzlKfKC6UlA7JaNdMjtf0EEnk0cDTKJf94PW2UVGcEaPC5e/+Duq5eKidvs6nWeK9CqurtO9PnbfsoVnabf+5fTI2nLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Shv6YkFSgKOroS3wSfDVplDB1jkViJgEZ6gBUldko8jQie0GkkTCFXIGmHID?=
 =?us-ascii?Q?o6/F1sY+04UZGPa9zonUio44ybBthI/1sr94s+i7w9in86wlqNLjHt4X0/oI?=
 =?us-ascii?Q?wFEp9st03m1GiAYcCrgyhIpyARRAMeUNiycD4Yum33CNICmHp1PMbjxM/sxj?=
 =?us-ascii?Q?JBhT9/8jjl5BLkcrGDikoMHGo/au9TCwBo7fA/a3VW2eRoBRXFc7bd2GHm/y?=
 =?us-ascii?Q?KFN955kPB1zgumQ26CznTAyrkx2Z9YoN9TMrqUnrJmQDFUfVFTO76zkk0QHd?=
 =?us-ascii?Q?xWpj7SRLiM+4GAhKJ21tzQ5WIy3BH6e3goFWf+blxGxdlf6HxxcVTFaDxGTa?=
 =?us-ascii?Q?U/THxGbA3F2ASWpduTQeEouuClnmw84cnKVdncfwjjzCBPuCwgFCtqO/m35J?=
 =?us-ascii?Q?3LMnKpH1Yex0ABzl9/e5n0B0ALTX1HughLMycJOO78Q/gyFzUgwauY5M0xMe?=
 =?us-ascii?Q?1vj46t23hhAe9Ja4eJQIJ73woonlJQI1R/NUZxaj7DOVaL86EW1hsP6T1Tcy?=
 =?us-ascii?Q?B1j83sNP3mLEmpNPZ5id1pJuWKctXaGt8jkqnIwwJEjfZsvv0YohnjbbI5PB?=
 =?us-ascii?Q?TQ7FY0yZRXSBkXCB1nS4qAFSs70WJ0v9ezKlcogxDhmqtWYD+6CkFWchUcDl?=
 =?us-ascii?Q?jHZt+DiUnVedAf/Z68sfVsldlHa6qRPv00VggkuBctLDJytjmXWB4UJtMY2T?=
 =?us-ascii?Q?idysEJyjHlPsn/tXLmZKRsoOS0gZt6MP8a2lTxyXin59UnM9pPnF0ka3/gK8?=
 =?us-ascii?Q?Q3ITvxiLGaOSKoWqahcQQiH0CNprfl1HsHzHhUoRupVxiT790wjowXmcABQN?=
 =?us-ascii?Q?K27W9Uo9i/P7IrDavZi91Pp6n0CJMhZfDTU2enH+/dhnR9cmU/Y7pWonEq8M?=
 =?us-ascii?Q?L37QRsjSGc2Ua4KO015c/wN04gHtApcVsAGomqBH1fGpraYqY2rhq+iuQef5?=
 =?us-ascii?Q?E4AQ9/jCCvOEvllqZ88qGVi/zzTI8nhQXsFl19ONh6JBhbqmBmTFC8GgCr4l?=
 =?us-ascii?Q?zj3vc9ApZLf5jsMVlb3JfFUPFGX+6p5Vs2KgEjEgUwGyWwjrGPWvtgHz6wh3?=
 =?us-ascii?Q?cL6YotJ9rQORoY5ybyxj4U6WbMXT9xaMjx0s2LaXIvd9wWqigJvwWRdcImUI?=
 =?us-ascii?Q?61SOdDq53jx26MungEJgg64TOq3kV6A1TrNN3u6YUnfTpVibU41MsCiH2boy?=
 =?us-ascii?Q?Sz3ffYMHbtZPWt7i5wMjM9xQc/xV/C3htvdKvBJFXozL8G8jMBStpw1t59+7?=
 =?us-ascii?Q?9mhXZ/mrlgo4jWTXKCqSpT2vIzp5JdzyaiTl4ad02ethppewr12Z2gjmKXCR?=
 =?us-ascii?Q?iULGJhtI5waCT2ChSjsFNtpT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8542b12e-4efb-43f7-2ff7-08d8c9d66111
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:06.5183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qfdp/Ax9mC/k3Wm8dYTpCiZ+/6nU4C2dwx4aNLg0xKKiRMrGzIu5DxfPKHRR6qkrSUon0MmbGXV9J6TWUPp2yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given the following topology, and focusing only on Box A:

         Box A
         +----------------------------------+
         | Board 1         br0              |
         |             +---------+          |
         |            /           \         |
         |            |           |         |
         |            |         bond0       |
         |            |        +-----+      |
         |192.168.1.1 |       /       \     |
         |  eno0     swp0    swp1    swp2   |
         +---|--------|-------|-------|-----+
             |        |       |       |
             +--------+       |       |
               Cable          |       |
                         Cable|       |Cable
               Cable          |       |
             +--------+       |       |
             |        |       |       |
         +---|--------|-------|-------|-----+
         |  eno0     swp0    swp1    swp2   |
         |192.168.1.2 |       \       /     |
         |            |        +-----+      |
         |            |         bond0       |
         |            |           |         |
         |            \           /         |
         |             +---------+          |
         | Board 2         br0              |
         +----------------------------------+
         Box B

The assisted_learning_on_cpu_port logic will see that swp0 is bridged
with a "foreign interface" (bond0) and will therefore install all
addresses learnt by the software bridge towards bond0 (including the
address of eno0 on Box B) as static addresses towards the CPU port.

But that's not what we want - bond0 is not really a "foreign interface"
but one we can offload including L2 forwarding from/towards it. So we
need to refine our logic for assisted learning such that, whenever we
see an address learnt on a non-DSA interface, we search through the tree
for any port that offloads that non-DSA interface.

Some confusion might arise as to why we search through the whole tree
instead of just the local switch returned by dsa_slave_dev_lower_find.
Or a different angle of the same confusion: why does
dsa_slave_dev_lower_find(br_dev) return a single dp that's under br_dev
instead of the whole list of bridged DSA ports?

To answer the second question, it should be enough to install the static
FDB entry on the CPU port of a single switch in the tree, because
dsa_port_fdb_add uses DSA_NOTIFIER_FDB_ADD which ensures that all other
switches in the tree get notified of that address, and add the entry
themselves using dsa_towards_port().

This should help understand the answer to the first question: the port
returned by dsa_slave_dev_lower_find may not be on the same switch as
the ports that offload the LAG. Nonetheless, if the driver implements
.crosschip_lag_join and .crosschip_bridge_join as mv88e6xxx does, there
still isn't any reason for trapping addresses learnt on the remote LAG
towards the CPU, and we should prevent that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
Patch is new and necessary due to the recent introduction of assisted
learning on the CPU port.

 net/dsa/dsa_priv.h | 13 +++++++++++++
 net/dsa/slave.c    |  8 ++++++++
 2 files changed, 21 insertions(+)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 263593ce94a8..8a1bcb2b4208 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -209,6 +209,19 @@ static inline bool dsa_port_offloads_netdev(struct dsa_port *dp,
 	return false;
 }
 
+/* Returns true if any port of this tree offloads the given net_device */
+static inline bool dsa_tree_offloads_netdev(struct dsa_switch_tree *dst,
+					    struct net_device *dev)
+{
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_offloads_netdev(dp, dev))
+			return true;
+
+	return false;
+}
+
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b0571ab4e5a7..e5c227e19b4a 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2215,6 +2215,14 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 			if (!dp->ds->assisted_learning_on_cpu_port)
 				return NOTIFY_DONE;
+
+			/* When the bridge learns an address on an offloaded
+			 * LAG we don't want to send traffic to the CPU, the
+			 * other ports bridged with the LAG should be able to
+			 * autonomously forward towards it.
+			 */
+			if (dsa_tree_offloads_netdev(dp->ds->dst, dev))
+				return NOTIFY_DONE;
 		}
 
 		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
-- 
2.25.1

