Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334112D2A5D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgLHMKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:10 -0500
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:13187
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729311AbgLHMKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWk9OhexDFmfEvyqSv+u3UVpmTrn2/DYbMHP06HABH1VLun5lURRSX5jWJVE1iAppA4pPUWr0FDxTlgvJFlofOEpj3gX1lrnPFIjPD8bG7gnZVSeoTwMZ0nZKAXJ9Nn5OM4iN+C41lLigYfoej7nSUvPP74Nkk1cwiGQpLWTSnY45wKVd6iB0IaoP5U0ZKbePMCQUstFv08LALnF/Hn4Fm8ciNpBULMNbAZAx5Jl6qyS6+RV/TgycxSubEk14QEF/j9wgIpL3XhqYph5AjfQdyEXQwJuCHML30GsNMW0Y3vVev77z0jzn5sGEBSuN9DFLa6gGB0wqLOki3b/6qd76w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxmwXWoBeVfTqsM3ZgGd7KJtBAO/Ap/XYUeGxFFQwD8=;
 b=MZ1m7Wz8LHzOE9w9ljWOVfcAVjFetpABJfBdNqMEVTi+ERSRmLZ4bhTcB7nw91UIX+yzctB79druTzIdXryu8ihz62fSFzSKxWaN+7h6gyBKkw5+ujCOYyIWtdS9wfrWSTckau8A1hkmXJkkEohp0bVW06cahmojj6yxGp/fZ7PK4wVhlGo5hppEmCa3mcLYEXr0F83XujmD4qepFpz+OOM1Wsu6bbL9VuQsn4dZnRz5yE7bmHQ6RpStziGT0B4tfFSkTxuUXMezfYKLggDtvpKHBsJc3LjpZntK1z3afpaaAe/5O5vK2mYN5akm90i2i/GHt10JIYD1r9jom/w90w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NxmwXWoBeVfTqsM3ZgGd7KJtBAO/Ap/XYUeGxFFQwD8=;
 b=tEWRGa8F/HpXlL3lTDxLfVpTlrhr9oaLgpUG+kHO+tUL5/EDJuz9qAcPHTX6SLIeBWi1FIzvwFzQ14csSQ12jMfyyuhntcT0SutDH26cIdm7mQG5OuqizA9BDzyD25aJGfw1m1y0paxDMVdqqpM4+iGOC+viVP6YApeSpRN0CtI=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:31 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:31 +0000
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
Subject: [RFC PATCH net-next 08/16] net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
Date:   Tue,  8 Dec 2020 14:07:54 +0200
Message-Id: <20201208120802.1268708-9-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 52e4c759-9ddf-4f1e-da06-08d89b71fa63
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB56936652EE85E55C7FFEB6E8E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAAq5SgVzwz3QQCHpDPTfdk2px7QhwAnMD607t3oDP41zXovwC1VgDM2AqN6pwncW/jgcYglbzha4QONuRFMjshmNzpdc3uwC8LUa7vEqwHIk4JdCfcL4mmrdnTDpwow8yrOvbQ1z6AVGNoh2o4tcUiHjpwQPXEwc5Na9p9gSiIw8kxjbgr5F4ZQo0lKx0ktSi2ij6ZLDhn8oDM6rsIEglkLkFCqqEXHkHH04zhTczNlXdttKx9B6U/pd9flD0qSk//XaFjtImXJdqkFVJk9/Arms2rh4sCyJjjDlsN4u0SE839JOs0RXoKfzr5ws8uWai8kFMDnSW4QECGKPhvGQmQVN7MoM7T8K3eL1Vy0nGIq9iCh2PMPUje8liIFY855
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/HDHCCm1nfUewc7lpjujhmxFsn/IDOar3xkU14VqGdhcEwXlNmy67RJcodJG?=
 =?us-ascii?Q?Wq+5Tiy3zRvwPaM4EoSfNh8mR/YtsroYO762zRzWvxVg5sdMTMPwuTDe8scv?=
 =?us-ascii?Q?yg3mNMNvnPHDD4pBCxrYVSHkvzhDHcfIsv64A/bPHj+1RLy6Vwa8SuG4uovN?=
 =?us-ascii?Q?Gwb3yKe1msqEWCpZ7qULCAFiWFzn/6jVlJjxSXGE4kOydyD+7WQFMCnRYANP?=
 =?us-ascii?Q?EWfnS9VKHYZ9uTO1m4W7vXZCVXbton5nxjNG6kKe2LGCbyIEqkddQPwrjv38?=
 =?us-ascii?Q?q5kjoSDZthyJwOGp7Pz01kXDziHA9XXyZ5a/nJ3FU7MgTFV4drsk/MDBftcZ?=
 =?us-ascii?Q?wHaHb05VSQtdC/wNzogm4pbOlUTy5iYxj3dIuXJcaj5l48Zz26NwBOly34Ka?=
 =?us-ascii?Q?+DcZlsHiW9v7LdHyOE05LB1jFBE2I1rrz1smFbguNGBhh6xkb5EofxbCNqmk?=
 =?us-ascii?Q?reK4iE4hGGl+xJBsjgOdNeKetqVCnc/hg82eDXkiUvy1WRwIdEUv94PZWnEa?=
 =?us-ascii?Q?sdyYw6xpeGvD5BsxxTaIWjKiPRW+Q1uSnnVBULHrneCcQJq7ZBOUS1zP8JKZ?=
 =?us-ascii?Q?hAxP7h+RLazxmd4PQWpMDSxiFYfkec+jmStFQrIB+USRcW6PWZZuLtSHXnIH?=
 =?us-ascii?Q?M3MPtdjJk++ODyIKeCO5IyvUixqtNZGn50m04CBAL/SfOZbTl7yStMIGYxm6?=
 =?us-ascii?Q?sHSct/W8RSI/0+XVYtKCrWkmTzcq2Plp4rSK9dInfznhEAcmnakl0s+hk/+j?=
 =?us-ascii?Q?SloRBi/O8Q9b6sBOKfKenRZkGXdZo/n1EzGj7sWAq2As6FR7/E0zJwxW27k/?=
 =?us-ascii?Q?5Sp1xkQ9q8gGcROVYrF2Xv8RC9ojwRmpdT6amdO2ePJ2YgCcMu3R0GSJxa0H?=
 =?us-ascii?Q?Y9XgtCEAVKROnYWQ+r9vV7oa2KbqAIG4Kb9cqbzkfYXhBelQov1sXnQqsqND?=
 =?us-ascii?Q?6DWXbs1IVuQcQaeKulHIfpgjqIZSTaalvZAzIDCrME7IVA+j7nyTxHos6qaS?=
 =?us-ascii?Q?IC6e?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e4c759-9ddf-4f1e-da06-08d89b71fa63
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:31.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAGZ/doje1oBzu/FU/TuuUSsScdkSfP06gVl5uVfbqmaFJ7S59EoHgnMkfccpyeVp1Xap7caCf3Znc2+5jl8pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The index of the LAG is equal to the logical port ID that all the
physical port members have, which is further equal to the index of the
first physical port that is a member of the LAG.

The code gets a bit carried away with logic like this:

	if (a == b)
		c = a;
	else
		c = b;

which can be simplified, of course, into:

	c = b;

(with a being port, b being lp, c being lag)

This further makes the "lp" variable redundant, since we can use "lag"
everywhere where "lp" (logical port) was used. So instead of a "c = b"
assignment, we can do a complete deletion of b. Only one comment here:

		if (bond_mask) {
			lp = __ffs(bond_mask);
			ocelot->lags[lp] = 0;
		}

lp was clobbered before, because it was used as a temporary variable to
hold the new smallest port ID from the bond. Now that we don't have "lp"
any longer, we'll just avoid the temporary variable and zeroize the
bonding mask directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 30dee1f957d1..080fd4ce37ea 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1291,28 +1291,24 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 			 struct net_device *bond)
 {
 	u32 bond_mask = 0;
-	int lag, lp;
+	int lag;
 
 	ocelot->ports[port]->bond = bond;
 
 	bond_mask = ocelot_get_bond_mask(ocelot, bond);
 
-	lp = __ffs(bond_mask);
+	lag = __ffs(bond_mask);
 
 	/* If the new port is the lowest one, use it as the logical port from
 	 * now on
 	 */
-	if (port == lp) {
-		lag = port;
+	if (port == lag) {
 		ocelot->lags[port] = bond_mask;
 		bond_mask &= ~BIT(port);
-		if (bond_mask) {
-			lp = __ffs(bond_mask);
-			ocelot->lags[lp] = 0;
-		}
+		if (bond_mask)
+			ocelot->lags[__ffs(bond_mask)] = 0;
 	} else {
-		lag = lp;
-		ocelot->lags[lp] |= BIT(port);
+		ocelot->lags[lag] |= BIT(port);
 	}
 
 	ocelot_setup_lag(ocelot, lag);
-- 
2.25.1

