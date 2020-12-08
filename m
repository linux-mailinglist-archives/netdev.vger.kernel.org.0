Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0532D2A62
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbgLHMKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:22 -0500
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:11267
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728225AbgLHMKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dPhhKf3SHEAbH6Lh81eSNcHidEJJoJRCF0b2r1K7wMrXBUpxiZ8k/Ygr/0Q4HGKB6uMukPd/VsKN/P1wBYi0hxlj9W82gZh0WHGhMETiCYPl/xBJ20MUqWslkqcfOYdX8F06tWzD+mrofYQRoaibwSk2GVFtGhBy4pqXk4I0aoSJH142PTwfk+PkAfJpYIOg6yncst/YuEF+N0ZFoMoWDCMaWOZKMGHUNO1yi4Dze7TZSOmU3jOk1eHWT5oQGipeQhOlIL+16U+bLFjr4Dwyoowl/0G41jAfZ5FWZjQg76qxTWNszwcgenb3O2gikqghnTAt1DxgptlShjFeKm+3Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQ+yDshFxLrHsMJoy1p5icoXZrMB4r2eRlp5oabdWNo=;
 b=Qmz7RwV6Rg39rzplHhH4ozmtjMeF0UgJ8R2AFtAvMl3gcZIuTbN4x0LdrBlBZR/Qso3oEjWKQnWtjI9dAF6FrYyGvtqOoPfb75vX+IZWANRg2/dxfnrFTQbT/KOK5TI2PQGkikCvO/RdGrb+7khrKByZXkzQ5YPUkAsnJ9s1ztjREjjMALtRr9B3K8a3N2tfNj5NOSLSIJsmgRWaNdL51OcrKO2de8WUnnlK3/0XdRZs08wiAsBB6ei2xkizzk2beTAt2dMCqe5VM+RYz6MTBoql9dKcAboGrvd5enTNC8bTx30kwpzG9RaFsXG8pG8Y3wPMlZGRoDo4QYaDmw/j0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NQ+yDshFxLrHsMJoy1p5icoXZrMB4r2eRlp5oabdWNo=;
 b=TOoRLqSshAa5wST1Q4CEV3DCGrUGsSZ/REF6cxZbx0BUK0nNc6Tr1W9K8cwlxAflk4OZz+UFWraHyjHCyEcfkdH9Oy0nlbioR5HRPj4pVqrodLkoCu0RVp1ukLMZOu4/eR55ANmGWC5jX36su08FbxMwYg6RqGjsRnVFukqLtPA=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:32 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:32 +0000
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
Subject: [RFC PATCH net-next 09/16] net: mscc: ocelot: use "lag" variable name in ocelot_bridge_stp_state_set
Date:   Tue,  8 Dec 2020 14:07:55 +0200
Message-Id: <20201208120802.1268708-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c7cc400-7e1c-4272-6b27-08d89b71fb43
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5693D959393D9240DA9D97A3E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKgqkXYG3lYtHv3ZW5z4l7/9xwyFT1SawQ9n1WxINwP8/0Iw7A+lgrZGj8b/g2biJDUXLiWnn97B6r83j1oDEtqDzIhRv8W8jnIFEq/zog+e1S39w3iYB1zlyxnMsVdnvKllbaCImekraHEn2aF4Ebe82g+LpyAn+b1dOS7Gr49vLO8hhah3LMTeUPMCSLqCiIRu9IvNWRJR5X/Ry11jRVWSCRjOkfQ0KjabThdJFFykbNptjBtJ4ebkHH0j492vAa8wEnW0SlzBUMGsgppQdReBXY3HckSgh16WgHwK3FJuN2zr4A/32TSSwINVmcgCUK3oiv97PHmdxe8uwZG7RG34Yq41dbvKBy3q8LdoZuIEq/T8euBE0SOruU6WmMWp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WzepqqrznlE/WIeLL6wnmdKAZ0kl379ZbN+ozvlQ2L3hxyVa+9mLLurTNyrM?=
 =?us-ascii?Q?59Z6XaPkujcAYbypVF9hXD/Ro46vMBApr3Vy5r2rotkBGx0x6I46oilci+uE?=
 =?us-ascii?Q?1/L9JRy/AY3e8W3a2M1AjimhqMgSYUwr9SWrV1sMyF5oPomnY4luRC8GL076?=
 =?us-ascii?Q?mO//OiWqSGAqReelosLRtnKFYbsNql09FotPRpR34EU1S0SZIt9vrI7QQKfT?=
 =?us-ascii?Q?GtqxiAUSuJdsLmtXTE07oiCxKyygDj3EgqLAWvfgzH3nWG4cAQkBP0Vxp86f?=
 =?us-ascii?Q?gtl81YvhB/GxApFPRv7YibL23+4u8YetorgDnkFBN6hbWphtnQdypJ5SsoSO?=
 =?us-ascii?Q?TLx3ozy+OdjeHTkBJFVyvUX5tSkZfPXqsc7QFPNxS67yXxqhcs+2ieb/q/l3?=
 =?us-ascii?Q?ia4XI+1xbyn5yga238GYNy0FxK8C0vyqX4/Xx3qS8mQm8/spM/s87tQQXaO7?=
 =?us-ascii?Q?hT/KTj/VD87z27b+RIlWiz3gp8ex4kQMGqayIwmvZ7FEdEAwJGnFX85ILGkL?=
 =?us-ascii?Q?5nOeUBEtyeocZvZi27N8qpeIdax0+LvKso+df0BYYJKFI2tsQPIcCGeBKaSo?=
 =?us-ascii?Q?mfrgxqmhPYvG7VHozBUQ8ChUpjyAocFTG3hRysAi3ROsQoVSzwlvO5Ig4t2u?=
 =?us-ascii?Q?Hk/km76y3Bo8auaH3jsGF34vKL1LMrAQOkHeIoctUfTKCgEcLX2enaoLUR69?=
 =?us-ascii?Q?qFcsqYL7h0T6qXalgykOaf3cxzRxZENpBonHYGTWd+PgvqpxWL2RX5Y61PN2?=
 =?us-ascii?Q?MZnyKVCw1R7mg82pWe88B4eBeMs3g+iHrF+J7e3++G4mYgum70I3o6dkQ2Ig?=
 =?us-ascii?Q?LRIfvr5hxVBYnCtIe7r8n3+NYkZEojEsXb6chszaddlbe/zld27XsAu9yr5d?=
 =?us-ascii?Q?jTq6nu7ZiGjaximc+6pZ+DK3cDiTczYX3vQOnxIYenTXpOhdnNoEcAYdnKbZ?=
 =?us-ascii?Q?06tcDz7fLeTQ1H1rPdOa/CNyQlwLyT1HySmYShVJ0cogR2OfAPs/7E1h8/Vt?=
 =?us-ascii?Q?mBA2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c7cc400-7e1c-4272-6b27-08d89b71fb43
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:32.5032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7d4g/alotSbBV3uz+WHSehPe9IgrCIamRfH2utseZ1pBBzSOOXy6+bCSxJ70u95CuvYTWejeirvnbb6m1NRusQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In anticipation of further simplification, make it more clear what we're
iterating over.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 080fd4ce37ea..c3c6682e6e79 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -903,7 +903,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	u32 port_cfg;
-	int p, i;
+	int p;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
 		return;
@@ -928,14 +928,17 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
 	/* Apply FWD mask. The loop is needed to add/remove the current port as
-	 * a source for the other ports.
+	 * a source for the other ports. If the source port is in a bond, then
+	 * all the other ports from that bond need to be removed from this
+	 * source port's forwarding mask.
 	 */
 	for (p = 0; p < ocelot->num_phys_ports; p++) {
 		if (ocelot->bridge_fwd_mask & BIT(p)) {
 			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
+			int lag;
 
-			for (i = 0; i < ocelot->num_phys_ports; i++) {
-				unsigned long bond_mask = ocelot->lags[i];
+			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+				unsigned long bond_mask = ocelot->lags[lag];
 
 				if (!bond_mask)
 					continue;
-- 
2.25.1

