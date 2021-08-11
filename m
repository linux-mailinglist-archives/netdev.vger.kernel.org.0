Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE8F3E92F3
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhHKNqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:46:48 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:23137
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231240AbhHKNqp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 09:46:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HC9e0gI3cZvzKsE9IoPs+Tpxv/loCZ1DSutTyjrHjemUF1TmAA7Yaldn3Sr0Cb+AqjoyNfr0EwiQpwdlbDrw8nvuSSWl320HCuI5fy1rNEon0WOq6a/fgXfEzxYWAoYSqOdIYfY0C6sHbR9g60LomhwUS8Hll/HDkLuM+jMr87eypj45RZ3vY4IXWQJqvTmv22cy/GhyzdFIcibKRBI3cuq61Z2xaxKz8Na7nrq7iXLf12lTVhvZpaeWeHqZpJNwsLtUu+0QugvnmwTjaAZRksuea3PcWI+N3dDvP/hknUihpwv7npRBbiRgXaeP5pKx4dgozvpOVIa9tUhwTloSlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDpWpbgQxNPvLxtAWNwI8aYXcssY5bAW267PEgHS7aY=;
 b=kXhoPWT6/unQkgbRgPjSOusLmuMqNr7OxgGUYDVvIL4AA9YVEGcxWmydP9uKqstpbOe4mrpzx0QxTL2z8Km7qec36ZGIzj0H+Ky9WoFCoZOOGkokisX215FrLfqdt2dQY1ZgTJlvK+og8kTBlFtmigjCFST2H5kSwuh5n3Qm30JpNiBu1QoJ+WPw1X/16PKOlKCLLMuC1zgOR5Qy5vQCu6qE7DUYrR8wOqr2EuTjuZf7NY2+T2KH5IJm3mauRDFARd+++Wu4AwwuexJQAH6vc96nLZjh1CprWT+9uuTWJwxPtgcDuW8N8rLmEOUryOI5C5G2RfXAIl4K0maQWuX/dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TDpWpbgQxNPvLxtAWNwI8aYXcssY5bAW267PEgHS7aY=;
 b=iBMJkriSa48APFP+DPHgdqeWu90DfiJbbA/nNz0rugb2bMzDaL9Am2LtMJC4yOQV/s4KqNGeEhH+x1PTHWgUrLr9yYHZlXUH51gRzdIbqRuqUG/MmguWEBNTSE8WsldbSvfRVpz0pX6YicFPvfSdYBa73X85SxrfpvsmHyM9mt8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Wed, 11 Aug
 2021 13:46:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.016; Wed, 11 Aug 2021
 13:46:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: print more information when a cross-chip notifier fails
Date:   Wed, 11 Aug 2021 16:46:05 +0300
Message-Id: <20210811134606.2777146-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
References: <20210811134606.2777146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM8P190CA0022.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Wed, 11 Aug 2021 13:46:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 839a71fa-96a2-431f-f3d2-08d95cce6531
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6942199C2836E32B63CDBC95E0F89@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BwijqHaouV4Xo10vZ2zbP0OE4c5uPjgiSPwV8PbtHWzHWuir6dbA8DixdTX5md4cNgoj/pdfqb4wVVZPv4w5CCdW741Nka4dDkZQv5TPUNBhK8d5EBznawTOhnR60jqVDI4FFmGpWb7Y7ADiq8D22W5aENRw1eDgH84OIibsyuzNmivvTCBbnUFdrKS4u1iSxGVD1kia/tnYOhdOyNf9ZrlE3u4asFlBuf8AHCKCG+Lf1rbwyFJ0NvAz0b27Omyd6dBCsR934Oq5lIQrrF1/4OmoTdE5yA+m6J2JV1BjZfDxJyQusCSf/3WzGjKx40L6w+V5SK5/5exZWp1fvl7mM7igzLcK6at+YuSa5aVPNjAiTi7X0ZOcUI7QojC6fMyhrFVyyz1uUDHz2btKEE4SStu57CTKb+et7YKTDCKCgioXobnmQbAbT2xXDWXy/SkxOr/yVBugqxiXKw3BZ5Zv8Ipv4aUOL4L8eTUd+Mv+doGPHOfkbAV/H7xmu1PbEhBUGBNHKnztQCDnY6+2n73McCV/hL8g/AE8mYw4nXIECYZk+eZUda2mbS4NHNVhoWFld7K7/E7kx7hRIJQc0Ln7043Yht44D1CX3wQ6N+PT4BFa5J2FTXB7HKHRoSypo894tyD72Zi+TTGRA1dr3hyhdo9tCy9ydui+QLg6Fu4HDNieFohajVRtUe7xtXkq4HTMTTQ1odP6BcqrLmyZuiwzLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(8936002)(478600001)(54906003)(6486002)(316002)(110136005)(6506007)(186003)(26005)(1076003)(2616005)(956004)(8676002)(66556008)(66476007)(83380400001)(66946007)(4326008)(6666004)(2906002)(52116002)(36756003)(44832011)(86362001)(38350700002)(38100700002)(6512007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0rFL5qQ7CJBd8OkLUVfMT/9nab6ntjPnj2IEz+4Am9fxdL8+mbGfpc8J8ujf?=
 =?us-ascii?Q?IdBuGmCpqK94YRx6Wv5QsYzaJcBWkQf0jBxw3tR+MZiyLisk7U12VmCPHcWo?=
 =?us-ascii?Q?VyJHhy9N7hYkXYF0IlyLNJjVtINujbIaKLpeuAgs4J6jSJi2qGALwdUYPlPY?=
 =?us-ascii?Q?AD2yiWaBhCYe7BDbhLvCJk5sChFUHMyp49m1LMDaGnkYuL+/Zcq0KziwTe6P?=
 =?us-ascii?Q?pL046G6StvbXxgp458Gylc0hGkfzWoS9mICL9sw5LHBvsMMAqh/5R1vB4CN3?=
 =?us-ascii?Q?5Crez3IIJ+TRtncnxmTAIZJuG748l9FQd/GhppyGUdquBWMuSO/qtnxTmE6c?=
 =?us-ascii?Q?m9E0N7yEalog3WYz+KE1Nz6cOqbWAVNIIWppDMBrSeuTU+59ri1EBA+FvEAR?=
 =?us-ascii?Q?bT/2ENw0rNcTF2rBOX5SN+wUyxio+5QWE+SEKyy6HL/+dDg6ZXKQmmSwYMae?=
 =?us-ascii?Q?AG68QjUPkpF5vgkV0AVhbkqaUsOw5fhol3lJEoy5I50RhhhJGyzgN6SZlwMt?=
 =?us-ascii?Q?lXaBeKD5AJzbTnmhr0RBsrJT8vEFpos1akc2E3pauIKQCNhyWJN5zm1ObPhu?=
 =?us-ascii?Q?cmA7dkB1SyBuZfkzIP5CIb9pizlso7855OA1HhmFfCsfYHax3p/9KJcrQzU3?=
 =?us-ascii?Q?BBFhzI/Uxu8eb9YXNYczRkwKG3OP1ds//HSPefh7foxnK4OsW1fiRhdhmN4i?=
 =?us-ascii?Q?ai3ddJs/LH7i3mIuQHawR/I6JAUSYPPR+QhzNmA3sc9Mhc5Cc5zAq6H2sznu?=
 =?us-ascii?Q?zo5HtLFqEuLcpQ0kL3HjM4HCbAem4RUrVSuieGR/ZdSchAHbKrCzPr3Q59ig?=
 =?us-ascii?Q?F7EqVdt3fVwJ54JpJG7f9GmFdYCXBYdW1JhYLu+5hX3IBsUOHnyVjEaG8PTC?=
 =?us-ascii?Q?gkG8RUL7VZVl2IAGVfxUnHvEcoDYivLxIxUnnxRBSAImT3euqhAy0BAxioH+?=
 =?us-ascii?Q?LU+2bUy7/S08l54znK9Mqi8M+jQI9IKMPLDnq1Nzzm9LU1V5viJLihSJ0UIN?=
 =?us-ascii?Q?u0UkcTnoZYZ7psh25ePSz59ZRzG+7oxAFaXDHTFhAfJVfpnbkijUqoIUrK+G?=
 =?us-ascii?Q?m1DS2Xg/EFyoZKpMEw2eEBz2jrB4lKbD8KXQD01FN79klJGB3whRQtbceHGj?=
 =?us-ascii?Q?puigwLj9ASA88z7TMYEm4aIJaUDtJpqPfjKGBMG7kGguEtDEvJfQpnHLfNPM?=
 =?us-ascii?Q?P+5cCX+GoIHcfe30g2k+xWU9e1YFOz3OFh41LtFOvDAA3ocH1k78SF1GyQt5?=
 =?us-ascii?Q?Mm0Ui8ePg4DHDUVZ8UQYtrkCO9CKGP7TYnnYYrCNRdVK2cGT4vSziXz5ceFz?=
 =?us-ascii?Q?4v7m7IOHeL1Hf/CvvslZBmaq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 839a71fa-96a2-431f-f3d2-08d95cce6531
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2021 13:46:18.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YsUHQDYFgX32TF+2TAtaLnSozN+JqH/GPEOA+Z2u3ZcF6WAAyZlgP9miyxi36Y99gbfbqZCTq9EfiSDpZOtiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently this error message does not say a lot:

[   32.693498] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
[   32.699725] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
[   32.705931] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
[   32.712139] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
[   32.718347] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT
[   32.724554] DSA: failed to notify tag_8021q VLAN deletion: -ENOENT

but in this form, it is immediately obvious (at least to me) what the
problem is, even without further looking at the code:

[   12.345566] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 1088 deletion: -ENOENT
[   12.353804] sja1105 spi2.0: port 0 failed to notify tag_8021q VLAN 2112 deletion: -ENOENT
[   12.362019] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 1089 deletion: -ENOENT
[   12.370246] sja1105 spi2.0: port 1 failed to notify tag_8021q VLAN 2113 deletion: -ENOENT
[   12.378466] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 1090 deletion: -ENOENT
[   12.386683] sja1105 spi2.0: port 2 failed to notify tag_8021q VLAN 2114 deletion: -ENOENT

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 831d50d28d59..ee1c6bfcb386 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -426,7 +426,9 @@ void dsa_port_bridge_leave(struct dsa_port *dp, struct net_device *br)
 
 	err = dsa_broadcast(DSA_NOTIFIER_BRIDGE_LEAVE, &info);
 	if (err)
-		pr_err("DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE\n");
+		dev_err(dp->ds->dev,
+			"port %d failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: %pe\n",
+			dp->index, ERR_PTR(err));
 
 	dsa_port_switchdev_unsync_attrs(dp);
 }
@@ -525,8 +527,9 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 	if (err)
-		pr_err("DSA: failed to notify DSA_NOTIFIER_LAG_LEAVE: %d\n",
-		       err);
+		dev_err(dp->ds->dev,
+			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
+			dp->index, ERR_PTR(err));
 
 	dsa_lag_unmap(dp->ds->dst, lag);
 }
@@ -1306,7 +1309,9 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr)
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_HSR_LEAVE, &info);
 	if (err)
-		pr_err("DSA: failed to notify DSA_NOTIFIER_HSR_LEAVE\n");
+		dev_err(dp->ds->dev,
+			"port %d failed to notify DSA_NOTIFIER_HSR_LEAVE: %pe\n",
+			dp->index, ERR_PTR(err));
 }
 
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid)
@@ -1333,6 +1338,7 @@ void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 
 	err = dsa_broadcast(DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 	if (err)
-		pr_err("DSA: failed to notify tag_8021q VLAN deletion: %pe\n",
-		       ERR_PTR(err));
+		dev_err(dp->ds->dev,
+			"port %d failed to notify tag_8021q VLAN %d deletion: %pe\n",
+			dp->index, vid, ERR_PTR(err));
 }
-- 
2.25.1

