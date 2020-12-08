Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96332D2A63
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgLHMK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:28 -0500
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:17934
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728225AbgLHMK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QU36r5h4q1buqJUYpAud492qtFDvH1Pi1FAjbg4EwQXTClbpMbXf0XiOWFVhJpGfWhC2ILeEYBirsP0QJxnuC6qx7HBI0xiV2BimPDANju1te2fpeK6ctUPTYcPlUaCQgNYTMQYK0YL0e6rbGbqIKdFA/uZzwIwpXaxdLkzx2PGPBphPIb5vtFo2LbFoRWd6OP25eCVPKu3kUtjYoPC4H7Rcr2hOBYl3cccWZP948dwVGLTFXn6OErM5vR7oA5VxNQr3Fybo2zwgbJlC1idrRIiOJ/JRCcJ8CMH4wEfZN6ZoSj4pBsyiGILdSoN4FZHP8a/KCSInqlZRsNCPduvbOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qux83wrs16eIBVb2JDmK4eQdIy7C7nQOfT88As8AhAQ=;
 b=XUOpcXxRyVevudE7IzSC/BcAy6+RObvsP2jXWrWw3ZY2pCnMhrtJxA+j8PgvK1XTrEjR9FWniCwVSnRMqOG25K1ryF3cj3KyxsskEXbr2b4u0ZBlDPmtsZR+Ugc9uHaKfV7hpjgcv5yyh7p74JvWVrAhmENg9tBCYrP/WYcPP2Dk0WgPPQVxFJJhxuLKQGPDQU/N/yD3AJQ/S7SvcnTQSpetQtsYRFRgAV/m9CPyFbyRzwvTOnNDUifnBHCvwFULzXjYpy9F8rs7vzgJqV8Uoc74YMsymOniiNTIdOOM7p4mZv+28+F5e8QILWQ7zUiTUlgN6NTDdfguPJM5IEh20w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qux83wrs16eIBVb2JDmK4eQdIy7C7nQOfT88As8AhAQ=;
 b=Gw3R83wv7vgvN7hUNRadFZ1QjCQzynrEuXw3aSQInnFibIaYABXlE/SjLOvjzc195c5HSM5BYEhgt0G3pR0RhTer/wOCcU1mYHM+p/hDi0bwZmpE2d9yDT5ZkjZMk927wIOWdJesZweh18eoTmeQPacTQ5K96CIqs0L/9TkOh7s=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:34 +0000
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
Subject: [RFC PATCH net-next 10/16] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Tue,  8 Dec 2020 14:07:56 +0200
Message-Id: <20201208120802.1268708-11-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ce04669-3603-406c-bcf4-08d89b71fc47
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB569375711C46D9C3CAC718DDE0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLM5Y+TL50Q+pFoTAcl94wSFwiZMsVXRYrH9kTk412fkPLRjs4qALO44yhnn9FIgTxOf24zlJc6keF5rYHAHE42+sDuTO86WrxzfRWHwulHdiMakKybwZdfaYOe1nKA8VQ2DCidzBFmGRbJKm/zWk8lP/AfNcFJLcpsPRR3MRme1WjcQ9pGX5BvK/vckQcTMu1VxswEs57QDNgY4BSrzbsiBXRPu7Sk5/+RqvQb9ku8AeyASpMqDSwBkxtqHlMEdsGS5QTjTOSh4sdZT4t0/iGiCPcUE/WGRkFecoHKjNz9XRRNEyrSR94AoxelqUvF95Crkd7t7UwKGD86ZzAkXkyGZz4nj8EgXwIaYPrH5Z69rEyKS4Nm7Cip4n+Xcw9xG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YIaWfWMAMprg6kVliT/uDUnwbYYIzdZ0gloYvkn7UZrRP9Z6Eq6Y0SO80fnv?=
 =?us-ascii?Q?ctE+17UAAP0/sKFdg77nVh7UJS+N3e1hVa6br+B6myrqgRh9LjB2RKxRsV6X?=
 =?us-ascii?Q?iV13vUEhpQqAECXVqH1ELPAmHXrLGwONwdQw1pzko/jClLGVZQvrs3p0OsIH?=
 =?us-ascii?Q?80f6UNmjcq5Nk9n+9XEIQTUFy5JvVu4oEBcwa+fWAB9snN7r7HmhPtsBnBch?=
 =?us-ascii?Q?1NsdJY01VDW1HCos4dbd/RRAV9QjHfIla4HHX/IAsWKqJ5/rz9FX1Pj66heB?=
 =?us-ascii?Q?4tI8gZuFdPFqbskabHO3obm3ryAJRo8jhGSGwSqAJGl9RPdSZrR/9/xyk2ZV?=
 =?us-ascii?Q?GZkJVYMdd2U0gK2ObFXeP0tU+AE+fQoJkmEvjSrmxMxsg6P31RAAkd7FhRBW?=
 =?us-ascii?Q?UGtQmlof/rGyaXxVTlDEto1DSuQmw0jTk/DmJt3S+YpONvflVttqwwpvJUUG?=
 =?us-ascii?Q?Fzf0ercBPJBiXitkC/o3RyVIfH+YBbs2Vp3oSOB8z+dkcAUvAFnRXxaiCPmN?=
 =?us-ascii?Q?lSegjy7hs3aceEj89CHywh+/v+dnp700Q1Ktn3ad9giwf6C0m4BgqUZGR1wV?=
 =?us-ascii?Q?TxpgebRNzaAvN0JpzFcSw6pgvCQBCntuCL33YSb29hKl4JdCss5PiuxRVUa4?=
 =?us-ascii?Q?q2lSSB+CZo3hcMCuyZT3E2l3nPl5DK5fUlIFubbRBpUlIZ5fDJ8e63/h+xRK?=
 =?us-ascii?Q?1X2FXhNeTF2xRAUSR9IEMzs6i9DGwcLx4/S0HFznYjPttP9yYya61KjFuImk?=
 =?us-ascii?Q?3PzIgtOOHl5NUhg1YGQ2uxxseOrlTVlaD6isdyrOj63tbwLOV2sDlSGGQS1d?=
 =?us-ascii?Q?5o4m5f9AaPMEpNJGFKfD2IfvL9uVLYeLAcIPaMmBtk6iDI8IjNbrznPXWcY+?=
 =?us-ascii?Q?UcJKQCQhjmk/zIygH7RYqRlVT9Wu9allDFIZR9O7G5R/S84L9qBNyhiteXcf?=
 =?us-ascii?Q?yDfYlhpPQXe0a1rH2H1nSTgMaQaJNlPQFIofOYRml9nkm7Hgft41kNg+npDh?=
 =?us-ascii?Q?EXVM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce04669-3603-406c-bcf4-08d89b71fc47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:34.1063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEKjC/Hm7HKR53j1O+Lj7Yd9x66RyeNkyS9ejsgCDrY7y+7EgQH0LwPdTsWeafcTuriIvSZ3lgH7aCYs0p/+Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applying the bridge forwarding mask currently is done only on the STP
state changes for any port. But it depends on both STP state changes,
and bonding interface state changes. Export the bit that recalculates
the forwarding mask so that it could be reused, and call it when a port
starts and stops offloading a bonding interface.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 68 +++++++++++++++++-------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c3c6682e6e79..ee0fcee8e09a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -899,11 +899,45 @@ static u32 ocelot_get_bond_mask(struct ocelot *ocelot, struct net_device *bond)
 	return bond_mask;
 }
 
+static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+{
+	int port;
+
+	/* Apply FWD mask. The loop is needed to add/remove the current port as
+	 * a source for the other ports. If the source port is in a bond, then
+	 * all the other ports from that bond need to be removed from this
+	 * source port's forwarding mask.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (ocelot->bridge_fwd_mask & BIT(port)) {
+			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+			int lag;
+
+			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+				unsigned long bond_mask = ocelot->lags[lag];
+
+				if (!bond_mask)
+					continue;
+
+				if (bond_mask & BIT(port)) {
+					mask &= ~bond_mask;
+					break;
+				}
+			}
+
+			ocelot_write_rix(ocelot, mask,
+					 ANA_PGID_PGID, PGID_SRC + port);
+		} else {
+			ocelot_write_rix(ocelot, 0,
+					 ANA_PGID_PGID, PGID_SRC + port);
+		}
+	}
+}
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 port_cfg;
-	int p;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
 		return;
@@ -927,35 +961,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 
 	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
-	/* Apply FWD mask. The loop is needed to add/remove the current port as
-	 * a source for the other ports. If the source port is in a bond, then
-	 * all the other ports from that bond need to be removed from this
-	 * source port's forwarding mask.
-	 */
-	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (ocelot->bridge_fwd_mask & BIT(p)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
-			int lag;
-
-			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
-				unsigned long bond_mask = ocelot->lags[lag];
-
-				if (!bond_mask)
-					continue;
-
-				if (bond_mask & BIT(p)) {
-					mask &= ~bond_mask;
-					break;
-				}
-			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		}
-	}
+	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
@@ -1315,6 +1321,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	}
 
 	ocelot_setup_lag(ocelot, lag);
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
 	return 0;
@@ -1350,6 +1357,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
-- 
2.25.1

