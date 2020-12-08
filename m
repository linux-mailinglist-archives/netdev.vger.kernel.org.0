Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D12D2A5C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgLHMKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:05 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:17934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729311AbgLHMKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUYuuu575Rz2P3x1czDETAIvJu8jkbu0Wg/tdbgfzq+juUzkLX6AagUrbk+VCYVvcVcGoips5DWBQaxS+KGJEyGxkoxuvM8zOOWLcC76p2Ru1BxuVEQ7utj2nFPXxkFYmBW3fBIAiFmQcALQiEFQClELp/X8GB3MY8Bg4H1XKi2RKkFua6VPqrD3q5KI/6TEPNYcvcNUmEtbZY6O/95wFLgHyJ2Tl3QYW4qETz6TKLvRHAFF8UysIBu9SXJ4hLXIwSvGs2gQK26obMrmf97CZqS/17VjRYjylBEyFfSVMclNQV0RGwfpX6TpNkJU5/i2lgn/OP5DG7q9vhWTt8vQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRETVR006LNcUpsPbVaccUpm+GSdPynh4RDE95Gucqc=;
 b=JXgiMGWwbPlVvVBrWq19nY7X7NuZ8xZJ0LtEri4bgNwJB5uLPL9Ay5vr/t97SnIB4VyG8yYGQKcFGHBIoRRql+dSzYTNAHY9SpnHNAvwEhIGjKMKAu2RCTRing2Pwb/1kn6/X7atKcL/5koVFxXjUCwyH9luUAD4wU9VVpOH/4GiqNndAStAjAEx0Fq/qJzS3sxGT0ms4L5pmb3wIt6JLHi3JC6mM4nZGWgb7YqeM9cSKwW4KyT/T9igvFWU00xnROKfEF3gFliTDdNapHo7R7LncByc8zUucRFlXrbS8FuTzxOS17TbcPVxBMAXUog26fadkk0nXsUia0ehvpCmPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRETVR006LNcUpsPbVaccUpm+GSdPynh4RDE95Gucqc=;
 b=YguYu4F6n365gNUjX4NyIlnuiGRuuDXR66k1l0OCO8XzxuIcaMB9kh0+uvzC9OXarUosWyTdjqOBvjT+MQbGryQ5hFHiZuHU6HI3BNM5oRThzRXozfLThbWJoYNmY9gSMhXHGWt9Wjv/ExpwiFOu6Z0W71n/csN1Ewz0+J30y9Y=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:29 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:29 +0000
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
Subject: [RFC PATCH net-next 07/16] net: mscc: ocelot: set up the bonding mask in a way that avoids a net_device
Date:   Tue,  8 Dec 2020 14:07:53 +0200
Message-Id: <20201208120802.1268708-8-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4cb8ef8c-356a-4f11-d46f-08d89b71f97a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693AE883949B7DF983F88C2E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ITXkVngC0vikOVXfRHYqi8HtpeTsEsSSCUtIoP4kHYV1ALusz5cRTofjndrdndrH5BjG5lFe1+m+HmQdXzxjoTH5+6tZm4mXwDVtnfJUhdV7Obv5rm7nWXuOgXPDhi8fJsU6eupL/lyQdt38YWFBrAOxROFdW9V1ASv62YcIwYKIDcaBIz9j2+TDK2MqHp3J319b0aX6qLGTNYu0ESlAr+x4rkoGO/xGLj3x7qismPHIBwGYNYeGZc1YCjDKDypUgWfcmLENHc6mmj2QCc6n9J/4eZ+n+cUW0mY9qeKSKq/L0XbSv+RWo1ODKe07kTqw1Fl3q0oeoOyXan1YVLBSsdw+jsQYfjnBK6cJssltPUWYpuzFkLu37vTs72I/nuZ8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RJnG4w86fDs/UGQqdxj+tsQyHaLoKz7uFWHYdNWq+GDXIOd3kFg4Yin76HKk?=
 =?us-ascii?Q?x68s9FDQligoafUZKEm48Wsucx2Ls4l04RbeobzwqSjo/QetkHyrSgP4UWvw?=
 =?us-ascii?Q?/kW0WhHf5ygVyGNXxurLIWrXm/YzZJQeaN7+8sZJcflI63QAj+HU81vL4uTO?=
 =?us-ascii?Q?/CM75TX3vysDuWw/4m+K2YjVZtK4E+tAJK3VB8f7l1GL6+jNYIh3Acnn8Vd9?=
 =?us-ascii?Q?PjnCypx1VZp7X2H6XdEytWDQILp5NvVUzUGlMseVS0mxRv4cXjsxEGS+iSTv?=
 =?us-ascii?Q?ERU09GJssWSQIzmCXmO9cMAfID1OJcJYnG075advvPos5vH+B1HFGWuiO0ZC?=
 =?us-ascii?Q?VIszymzQNxcx6spuTKGcpbm5M4+VaZz27Lh8vITE94QI5XJSGRKHjIA8wFoH?=
 =?us-ascii?Q?NTu9cfVSQk0nkmo60YthPMxaTP898ai+M5ZmSIPvJ56A68RnzAhvbLV9QoaN?=
 =?us-ascii?Q?1ZKFkQHMlJhRpoYC5Sr/D3UDEmI7bCWPqU04Qb52/G+D5qnogOKKGQJdps3p?=
 =?us-ascii?Q?esbRc3lfMTJyfceLjy0BPBzbroR3WNcZxZ8nj39+P6rSiNdSv+ozJEf9pI8Q?=
 =?us-ascii?Q?3B1ZyZ55Ud159rWUTsjG3FJeDiAqJhMghM2xW4CKnotTCAjLTesDxNV/hG5c?=
 =?us-ascii?Q?PKTWvLmk2UEm7TlrBayK2cuoNGnssKUVMeha82neIyYm1DMo2z0znASy8sXl?=
 =?us-ascii?Q?w1K56OfFS4AoNSwVOJhqpdONpA2PP7U5jPL41Wuy2ZXlJmlpEvLOg1+8z/O3?=
 =?us-ascii?Q?h/VuM4fUbY5PM9cKmZX/glNt49znqkZ11FQ99uA7MZ1M8pHNAf14aAVn98bV?=
 =?us-ascii?Q?CMjYJtNvmR3UbcAE1k5+5ec3vm05hAZ/T04m2VSsUWB6Mkk87Enl8VCRJf8L?=
 =?us-ascii?Q?XewFHPfMDm9T3ME5tPKVpzF4bB/fNLoOY6FRDeDtukcYqGVcjY5T2kpH2bCJ?=
 =?us-ascii?Q?nOVtWmYJi0i/TaBWxFOLa4ruHkx38kiVlplytGSiPd+iOWmYOtbY4VL/86pS?=
 =?us-ascii?Q?iatE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb8ef8c-356a-4f11-d46f-08d89b71f97a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:29.5509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i7kL7jqa+0XwN0CrIRHUoYygrZEf6sFvuKiLSuu0vflA5WtkprMeU3zck/IwH9Ri7zPoCrhYFdP9ha60ixxE+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since this code should be called from pure switchdev as well as from
DSA, we must find a way to determine the bonding mask not by looking
directly at the net_device lowers of the bonding interface, since those
could have different private structures.

We keep a pointer to the bonding upper interface, if present, in struct
ocelot_port. Then the bonding mask becomes the bitwise OR of all ports
that have the same bonding upper interface. This adds a duplication of
functionality with the current "lags" array, but the duplication will be
short-lived, since further patches will remove the latter completely.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 29 ++++++++++++++++++++++-------
 include/soc/mscc/ocelot.h          |  2 ++
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 13e86dd71e5a..30dee1f957d1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -881,6 +881,24 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
+static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
+{
+	u32 bond_mask = 0;
+	int port;
+
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+
+		if (!ocelot_port)
+			continue;
+
+		if (ocelot_port->bond == bond)
+			bond_mask |= BIT(port);
+	}
+
+	return bond_mask;
+}
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1272,17 +1290,12 @@ static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
 int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond)
 {
-	struct net_device *ndev;
 	u32 bond_mask = 0;
 	int lag, lp;
 
-	rcu_read_lock();
-	for_each_netdev_in_bond_rcu(bond, ndev) {
-		struct ocelot_port_private *priv = netdev_priv(ndev);
+	ocelot->ports[port]->bond = bond;
 
-		bond_mask |= BIT(priv->chip_port);
-	}
-	rcu_read_unlock();
+	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
 	lp = __ffs(bond_mask);
 
@@ -1315,6 +1328,8 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	u32 port_cfg;
 	int i;
 
+	ocelot->ports[port]->bond = NULL;
+
 	/* Remove port from any lag */
 	for (i = 0; i < ocelot->num_phys_ports; i++)
 		ocelot->lags[i] &= ~BIT(port);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 50514c087231..b812bdff1da1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -597,6 +597,8 @@ struct ocelot_port {
 	phy_interface_t			phy_mode;
 
 	u8				*xmit_template;
+
+	struct net_device		*bond;
 };
 
 struct ocelot {
-- 
2.25.1

