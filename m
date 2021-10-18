Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB1B4322B8
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 17:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhJRPYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 11:24:13 -0400
Received: from mail-eopbgr20040.outbound.protection.outlook.com ([40.107.2.40]:12514
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231921AbhJRPYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 11:24:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kxd2C71TLDjduxayVJqgFa4fSA3t++RJCwdWomguPMooApXRyI12mxNVu9dS9jklHk6qPiq1C83AVBeqSbmPZEC8VxCGdknO9af6BptQVHZTA/UbQah16oNSJsbLJ5Ub32/b6kC5Zlv17m/RmuDG7lTrkamqmVxvxHcgNv89FWhiGv0SBxnv/hkKvJIAJX5zimbjHmdKv7QGGgUikD3SJbeO5SJ+cu3HPz8FYu4PV8If2gOrIcWBoPAr+VpbwBhzHn9CB/GxQOFKKAZ9Te7S7SY7M21UYersgXoHwISZh1hnht/GT0EoRGx9Qa0XkY5Tchrlzam7aybBbL0lWh/HUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kxKoQzxWqeB/UyNPP97c4PtW96krePrHG3DpO56Jvok=;
 b=SlX1CKmZxRBHo+XPVInazVbU2jntPTjY4Uq/JcnGZhPlbYJLOSaG6rGqYG9ONJV7Ze5Bfya57oEfCsslbe+A0Woiyz4cAxRGdhV3RLFgHzuTvPEZChozFFHQF+6wcXqUHoW0xfI0VzLKOWJfcvyE20PyzdgiGXkrGWUleC5KT1rF6mxyLAi3Xz924XJTtOc/+HygcZod/81E5AhYJTIcDwiz4ooAqM+tgM66LFTYPcQ9GftnuBYPDGMVoIgfZk3lz5zy54qojS/Cwz6lqZllvBkshiRSQrg23v67jCv85rTKukIE6yJvEyyZQetreOVULBpwsSsXzO4KXyUs6L53Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kxKoQzxWqeB/UyNPP97c4PtW96krePrHG3DpO56Jvok=;
 b=BWcL0Rw6YLvYYWqaPoK7JDzICrr7UOwyb0KsXvLQW+kb6AJiE+/lAPXukBxQhZ6u+knIlPEidA5PXmhUdBqqW00IYRoGH31mzz3fEisu61h4rsZoI+mQD9g4CqoHzw9OrNAD/tNDVTEk8eSW0s0FGDzJ4Qkds43PqaJHDZ99Rh4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2799.eurprd04.prod.outlook.com (2603:10a6:800:b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Mon, 18 Oct
 2021 15:21:59 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 15:21:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 6/7] net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
Date:   Mon, 18 Oct 2021 18:21:35 +0300
Message-Id: <20211018152136.2595220-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
References: <20211018152136.2595220-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.184.231) by AM0PR10CA0063.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 15:21:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1213920c-290a-4843-6ee4-08d9924b0728
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2799:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2799A6626EA703035D31338CE0BC9@VI1PR0402MB2799.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gmyEUhVY4SHqli/zPeH3jdVUyEXuea/qRBr8QA4a7zDKISTRXYm/HNUnyh3sUMVO3gM+tN/WKT8ucK/QwVSoL4Y0I5jTJ9pBdZ3bV2iNniSRMZl5/kFFnOpuDpywoSArUskgq0ZB+JeRstyrNGZ5IKLc+gLkVGf035WU9DSsNi1SuDjloL0VpikDTXkL3+OUSbSL7IbgFXRRYEowpJnmmX75gejwGNS/yi/13YPczmB0O5vvANP2xrE1ha4aRalBXHGi1fwWuLnXUwP2YxRFRs0aPXVZZcrdBf9Nb51upJyR+i5ibQZIFI8OCSe9bCo/sQcx8wUDlHJ2EwFvFD8H8nAeOEQ2fVbo3Z67AsnXkNr9OTLF+yuurHU9+dN8XFdgEioswrBVeRoVGRM4iPqg6xjARJ26wllJqSviHlA1Lpht7TK7LEjSj5k7r5qnMQIhXn8fmTFWdmXbXsk8v+MjhQgyhqJdVQ7r0UB+6wacHQZGrqYBS66ezjdvzWgM5K+EV0N/XX+m6MfvPeAmLnqao6RHeYX7QAR6kGljJvqPiVTdgXCWMazcMWqtF0AwlMCYetzLaSsD9UEuBE18TO79BSGWh0TTJG2MLuEDYPVvB6RjnHkjqAhrLhJ3AnXDE/u8yuIRdH2E5Uz/Mi4NxKbqGvv4VmYPK2xcnpgzrihLFaM8fAmE5sLeNvhn8FzjZL2l7dOAmS02yu/ihAaobloePA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(4744005)(6512007)(186003)(6486002)(54906003)(8936002)(26005)(83380400001)(38350700002)(38100700002)(1076003)(2616005)(8676002)(2906002)(110136005)(86362001)(956004)(4326008)(6506007)(508600001)(66476007)(66556008)(66946007)(36756003)(5660300002)(316002)(44832011)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ztuTxuEvtqQuAhTbKHEKrcka6WHb+v27ppK9Dtow4PtAU8rqmnxhlUTCPQUN?=
 =?us-ascii?Q?aBlOO+DJ3acI0Zok8gT3rB5+graGtfX5mymD37k6jMGWCh2ylH+LoSHAxgjQ?=
 =?us-ascii?Q?RxDA74JoO8t75ygO+dESrIaFIG3zugfQBwk/LQTBeMd2sWrt7+03lPp1PA2T?=
 =?us-ascii?Q?RLOti7wV8kWI/vU4OVvXV05AqQzfmOjwRzyTLEh4JgKfD632SoLDJ6QSrqHQ?=
 =?us-ascii?Q?R8VGJcLNOZvrBS5PANlDxhSwXMJCL2tRWFalNRwQl/xKDarTtxyZJC4ctIhL?=
 =?us-ascii?Q?UbJtQnb4miqPxvr7smD95bmyBfhTZY4EKXGpAqWfvCfg9g9F/XSxhE9yVoFn?=
 =?us-ascii?Q?Oj4Goygt/5udRsZwZGWpX+V7QVHl5WwFCKc+240EOWbODDVqze2qSELnE4tB?=
 =?us-ascii?Q?47o024ZaqhXgYm0xZ6F8iqQeMbll//RNlyZ4PBdyTVRdd6o5PrQR8smvsvnu?=
 =?us-ascii?Q?/eV9qYTvVIfkSQTKew6UiTm5Q7oCJMOr/68s0HmriqAaaO5CQerD7s04UXx7?=
 =?us-ascii?Q?tpKwsZVMB3iWN7acKX2Xn8a3L5rADmrhmX5MWaSJCmAqZsnH3nPPk3sHmkc4?=
 =?us-ascii?Q?yAv8ubRSs+vBfQw9hgWc8rVBQYviev5TgBbs7VmLuDV6ZmsSlCvAiLJDRrXM?=
 =?us-ascii?Q?Y6/Oqy9bqrC3Igl5KpvrtPw1xaO+naAQdHoKBysreSJOncOlG6K4Zjtuc0sL?=
 =?us-ascii?Q?IUFQHLz8iZwV8BEkTtPxh1gSqG5RydOeqWZSAbTfo7s98RgzDCZnRtDsNR4i?=
 =?us-ascii?Q?9Pu6YO9cp1nAlbq2q10EhGjiSfcpyd3T4JWSw+FEDcxZLAjHSIzW41IhPfyB?=
 =?us-ascii?Q?grP08GoPq9Ia8ptk4nkwnNU5PDql5lRPq4tG4oSq7V3P6IqAd3g1v750WB/1?=
 =?us-ascii?Q?7uzAlgmNeKK2pcq1tyDUIB/+zeUzsLMX+mdzka0bcGQkCluJXub7LjCO3GMx?=
 =?us-ascii?Q?4Rk0G3J1Lf4DX4WyJh7G/zjdX6FRbkj57CCMTBN9hyUw+EbkbbnDWsr+J9IG?=
 =?us-ascii?Q?6pdtIWI35BDDElAnyb/t/HAIYvGBA9LlnKLkK8BXOmsYmIBBZ8V82J/tFUTH?=
 =?us-ascii?Q?qVK+fOGy4CTep65cCajLCH0NRwddqcu4QkhTIiiUb9VWvWKliAsyuNmrQG4C?=
 =?us-ascii?Q?MwDj9X729VsWCihOHk63mfHaqb1uDxC0McGSJ6EknI3AEip2VXXEh6AuyXdy?=
 =?us-ascii?Q?yf6zCQLM9rkVdU8RF0UGaNaEnorIyBImg3jzP8eJ3nMDQyEIuakVL6cZ43nM?=
 =?us-ascii?Q?73HC5x6xGv+kMduLGtSUdCokBfUAtv0BQdroZxKozg0U8Jm0NFwpppWHtIf8?=
 =?us-ascii?Q?/oyRueORkYCIpT6Z/6ZYQDJM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1213920c-290a-4843-6ee4-08d9924b0728
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 15:21:59.1377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SzwqxR3HXfYnR5aE0RhSPVl4RFOFvLl2yeqLorWCIljrGJGUQv30+9m1MhoFNu/mDdWMVnzWdUoRPdxkZ8BzIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2799
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the remaining iterators over dst->ports that only filter for the
ports belonging to a certain switch, and replace those with the
dsa_switch_for_each_port helper that we have now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 2edede9ddac9..8b2d458f72b3 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -158,10 +158,7 @@ static u16 sja1105_xmit_tpid(struct dsa_port *dp)
 	 * we're sure about that). It may not be on this port though, so we
 	 * need to find it.
 	 */
-	list_for_each_entry(other_dp, &ds->dst->ports, list) {
-		if (other_dp->ds != ds)
-			continue;
-
+	dsa_switch_for_each_port(other_dp, ds) {
 		if (!other_dp->bridge_dev)
 			continue;
 
-- 
2.25.1

