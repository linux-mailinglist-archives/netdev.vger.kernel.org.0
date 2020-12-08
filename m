Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A8F2D2A64
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbgLHMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:33 -0500
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:13187
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728225AbgLHMKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4Q9YrPBMF+eFiId6gv2sIE1SuIEPRaWipnSCQC4MdIDvIp7uHNXIzX4GlTkIUuIFy5THyB3OCaXZR45WCcpQcMb69aAL8zG3mhlmYq6J0h/lpL6kzowG/whHNTTXjvLPH/B4cLX5s20u+Yh/txz8fXqgO/fRgLaHT3mQvzAB5OPJRAUD8D++g0HCH8kASZgqPscyJQooQoLaDRfxMojl4q+tvL9JKK80J7OOKRy96oRWnngWzlOghUkgetxPvNKiceV7uK7eUQCeqWxrSH5tNKGyCIZrVe4S/S2eSY5vV/myr0EPXYosnhiJG2OTFPH+yQYlDOCBXFHzmgUvCAXyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntiixDI4A7drEzDtNKutSC4G83RAlXCKSEqnj4MT9AM=;
 b=Az6G+g1L/btOJoOplpgaKChvwshZu2h3mPyhDHOAQgNDaAWUiN5uie40+V2jEPIxtm7HFDEHPIm0S/CDTbqfFUp+LJbJMoy7kwKu41d1I+IqFWVg/oPTNtZQqWyRgyhjoDRF1lZawl2zOl3UlXyl5007MdGc7nSTFvb5dUiEKUBHoHnrvlphtKRuwBKRB4aAbFQbraY++fxvNVYlP5YJq0c53ALBAMV4MinyH+EQU4N9q8Zx0w16jX/xq24BhBGGpH4LlqSUOd6lJ2kVuJ1QUdrGsovEQHcdGrz0zyO4wDRn4xLYMXFFGPbzxq/ody5pFcI8krsFD/DqHsf1gB5sUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntiixDI4A7drEzDtNKutSC4G83RAlXCKSEqnj4MT9AM=;
 b=bq5J0jgMjGmm2xHpxnlOkdBT5+TeeLSkGTRrdM2x2Gnuu3uqNNpoSFat/FOJI+siknHORCpqB+W3BlriA1kVwMXFekW93c1gY3LZkb8rcEd/RTHtbsN8eCH/OR8IoVOwAZYsAv5gp5MzB5gG2BLY1xsjWfNb6uYrwGHmAdzPOpE=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:35 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:35 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 11/16] net: mscc: ocelot: set up logical port IDs centrally
Date:   Tue,  8 Dec 2020 14:07:57 +0200
Message-Id: <20201208120802.1268708-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4029e702-2e60-40b4-1282-08d89b71fd16
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693FB3CC87D11AE6520302DE0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8NodFvsU1h1uCUeXUYl9qIjhJ0BtsthyhQNof40S7Qdo64J5i0aL5FHq6DpVEtL4N42enrnvoJFTzmmB6o0GakRjTLu0CMc2GD19U59Es/qlJKBbCZKJvQmrMzyjY1d9dzNYfQYkjoemHTxlvLY5aUF3OwCXEnJWXHs7L8Rsllt/e/IO+tAklMgscxNsNty9OKYvnkmui1zq8NM6IdJczc33vaO1qCaeWc5p/fNjGYEtXkqVhnaUzdUpI76XSKYPwOKxLglIXeK91DADhRP8CN/tvwCYD6fpq5Ei8NH1R8JFaV5p2wodkcaNBxrLABF1olPMMgXz1GH7GcEp93KTdL3/sDGWzmsnaaOydgSHQaDIcKC/2jY8kHFF98OF41H
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+Kv0Xwkhukqgeh7HKQQgAKYQwML/6Ouy+kBxulx1neqHcFr6oxkU7ZIHY4B4?=
 =?us-ascii?Q?oJ3t6jsb+1ifSS5abeAGo+2X01SrwZhOQDE3RChabydZNClsnPxxARC/tKhs?=
 =?us-ascii?Q?u5Qr5UFOr/7rUJwcp+pbbDuoucXBxLwodr5bHyiD6fThR9fftyUQgusBLKjw?=
 =?us-ascii?Q?v7ySYxPLj+wSv65ydQd9Fg6RAObLZoPbEmtLQ8v11CFfNBplfrx8DEFtAxzH?=
 =?us-ascii?Q?63keM8Jl3LdfiFGACypW7vs4gczfOMDtsl5/LilR8bRrc3gWJjh8v2X743x0?=
 =?us-ascii?Q?uypKJlsuv5Iwiv6cWES1Ss3ioFwep0XeQZNt9cGA98itv8MT1cttQSwr5a8F?=
 =?us-ascii?Q?9DkAzg6d8zhcqmE7z0IDi/xqDCnq4BtxPFhRCbYudCSnuFx5yXNXDjy+UVb7?=
 =?us-ascii?Q?VgkhsCoOkeJ565NjsypTpH1uodmbZ7WlAWtUyqHseG7nA7uv+vae+yV3anzy?=
 =?us-ascii?Q?TjGZFOK3+tP3L6gyvMUs1NvjMMFtMAzgbpZmkoMMj9aZpyzj0ZpS3xor8Mmf?=
 =?us-ascii?Q?K3iG5lI2kVh1RlQyoQFe385DySIs97Bzt9gLqvns+5mvhqIGEGbqXamlP8yU?=
 =?us-ascii?Q?xhQqVMCwcRDcUP5RR9Eymm0az9nI7YHuvNXHiTNLhlfekw5AdbE5u+pQ3HmW?=
 =?us-ascii?Q?MauP5sZadspasHd8pqyAuH1pIKAD/A7WVxIoAc79YBJEprXQcCg+TxxxpNA0?=
 =?us-ascii?Q?vMscSwx3/IYtuacmAugFE9VdTrw46BXcAAAJcQpkqV4i0TkKxSUjgixqikSo?=
 =?us-ascii?Q?PkjB+ohaada9tAq9B6srDmpf1YY6WiCUPW5ZBpHSbrz7yWSrFGFVtbWJd9jE?=
 =?us-ascii?Q?1d4sVmwGvLyjzEzaNz3kRkSlKEh+wvPt7JrJBAWXv3M8FOpTT76xm2dE1/1W?=
 =?us-ascii?Q?slrv3CfxuBb2MR6/yKGERVgl3/wWI+YRcNjp62m/n7eVluQiQMnhj3NGTzA6?=
 =?us-ascii?Q?d0X+eHvqJnwr3BPkz+f6G1swanZuGrCqnxQHOtKIjAqQM4so+eCidcqqCTzU?=
 =?us-ascii?Q?izL8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4029e702-2e60-40b4-1282-08d89b71fd16
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:35.4605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGfwmx9rRjMPAb181BXt45VqWOI1JCg7Ro+HTSBbAjg5ltzxlTyJKe58cBXSkOXd6oADHgJSUcTg8SdGd3wuJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setup of logical port IDs is done in two places: from the inconclusively
named ocelot_setup_lag and from ocelot_port_lag_leave, a function that
also calls ocelot_setup_lag (which apparently does an incomplete setup
of the LAG).

To improve this situation, we can rename ocelot_setup_lag into
ocelot_setup_logical_port_ids, and drop the "lag" argument. It will now
set up the logical port IDs of all switch ports, which may be just
slightly more inefficient but more maintainable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ee0fcee8e09a..1a98c24af056 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1279,20 +1279,36 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	}
 }
 
-static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
+/* When offloading a bonding interface, the switch ports configured under the
+ * same bond must have the same logical port ID, equal to the physical port ID
+ * of the lowest numbered physical port in that bond. Otherwise, in standalone/
+ * bridged mode, each port has a logical port ID equal to its physical port ID.
+ */
+static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 {
-	unsigned long bond_mask = ocelot->lags[lag];
-	unsigned int p;
+	int port;
 
-	for_each_set_bit(p, &bond_mask, ocelot->num_phys_ports) {
-		u32 port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, p);
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct net_device *bond;
+
+		if (!ocelot_port)
+			continue;
 
-		port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
+		bond = ocelot_port->bond;
+		if (bond) {
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
-		/* Use lag port as logical port for port i */
-		ocelot_write_gix(ocelot, port_cfg |
-				 ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-				 ANA_PORT_PORT_CFG, p);
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		} else {
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(port),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		}
 	}
 }
 
@@ -1320,7 +1336,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 		ocelot->lags[lag] |= BIT(port);
 	}
 
-	ocelot_setup_lag(ocelot, lag);
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
@@ -1331,7 +1347,6 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
-	u32 port_cfg;
 	int i;
 
 	ocelot->ports[port]->bond = NULL;
@@ -1348,15 +1363,9 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 
 		ocelot->lags[n] = ocelot->lags[port];
 		ocelot->lags[port] = 0;
-
-		ocelot_setup_lag(ocelot, n);
 	}
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
-	port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
-	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
-			 ANA_PORT_PORT_CFG, port);
-
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
-- 
2.25.1

