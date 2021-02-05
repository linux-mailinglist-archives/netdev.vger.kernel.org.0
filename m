Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552833115D6
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhBEWn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:43:29 -0500
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:21318
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230259AbhBENGY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:06:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/bhbdIzSVYJvaSHGaI2LlnbhTCYXOLTs4jODxfCY6jmsQYtDKugrOda49wLHHy4rn/5uwQkyV5vBJ51EmaSfgcUDEKM+hkVLDuVd9ELhk/FKL6Zy5zUSIWFdIaTO+FM06GG5lIncBi6NP1SQNCwSze8Cc5J3vjnASDv3aLrBEykBr6y4PiX5noz2dwcnQ8FIrZEaCXOvYf9XTYnguhuiCx/mP1gAg+XVBG5EzaT+Cdp5WCsKQx0Rinxg5sJlYQ80iZfpYy1MN5xdcJ5sidfa+mFvbT+/KjGeCqhEDLRxlj9N6qh9XE4I1Iaq8K6ukOA36ayJc2TQmklcbc6do7YoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jAIPQ5E3ivqoM71TxoK/YFQZDNwL+v2ItpwkdDO5mY=;
 b=NDiUqiANkVjeSPPMkF4fXuS5R9KrsF+nSocetCAsaBNwN3XiDzxeVJpPIsc1eVo7wDXSGdBPsXBtuIIyrE6DyusMMxvfNxpCjnyoDKkUyaYNpp7DrPz+gWFbAEv9sD5LoLxQiYdbutaBQuPW73IXC2uT2rRsENwcukHWTsUIeOZ6J/DC94vMakB5vf8YLwRAGYnwZsmYPfL/wvDDy5c3AWxlrBpjMiS75j9KEvHT46YHFbESbCwIf/NkyHK7smOQbPuGqJxJTGnO8HBdXCbBqegUmhipRh3AktBawzssk0nRpPaJe4TI+FV1JFl+QvqtGELZXj3jiekcgsX4jTs3Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jAIPQ5E3ivqoM71TxoK/YFQZDNwL+v2ItpwkdDO5mY=;
 b=LMhBn3+nXxazmPU23k8G5GHpEP0Wr2n17wjKuBajm22Klpb3Yj/oqjfiyHCWRYrW2+etzhm28SQaBy2VZZTer7sfAdD5bghn1Njk2DlMNq+cY3j+FhzFdHa5fsEJ3rWkyOxu180zundwn4h2ViOX4i6lfp7OPD9EYEtLtm3DTVs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:05 +0000
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
Subject: [PATCH v3 net-next 09/12] net: mscc: ocelot: rename aggr_count to num_ports_in_lag
Date:   Fri,  5 Feb 2021 15:02:37 +0200
Message-Id: <20210205130240.4072854-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3feceb77-2f3d-42cf-af34-08d8c9d66007
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286337F2AA5018644C98948EE0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rgyPWRrPwTe1H/M2jk33VBAlDcJFP9FP2fYpenU7n+3Gp6w10Fbv84axK52FvNgmsZmrKV736AYsH1jeetfDmhS0qualdmpFNAYOCob692BAKI2PyZCSncDNVgtKlPDm1MTZngBmkhCrOblbGzII6bnkJFKdBqgHrI2KS+c89WxTr4zkMwBDuzTwGmpWN0/xPY4pgmZDOYYaS6f/OpYHZZpcFPdgQL+0w59mc8ezaAoC1QF4xvcE3lo5zV0+Sqm5WkkyYRUGf8fG/gEBqeh41hL4EM6YsvEBkbC6ixbbINmgxQfeoJI08WQh38xehMwhUIxfNF1dZ7XeQuMze9aJDVxPpECJ9/JRMQbQ3VS14xmZWeKAvmGjNju0mcBsIpdp3VedWd1kL8GXQHgdmQvp6SRDtXRDyNhgoP3SSsA6uckrvD2S10nMCyQPJE8Y3mYqe5c4AakfdqwEaaIxkkDTZm4sU2PtoKUfv299Oje7AkG6rMJphtKGUIh+2lbWGA7EfAIeUL3gT6P1cw4S6righaAG59fl9MDsBuLTT/6f0M37wBZqEBDyjHeqzjIuqXLCiQKQ8HKTAwLP7KJXZYCZMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?unL7A7qojVCZIoLRSI4nJfg4bbv/k/hIG3IJIvWVPusvMuEqaJtGZ6+/hRgn?=
 =?us-ascii?Q?2CKEaEBkNPAJ7DXCN/u1f2VmEwVUmJ0gE8L0Y+b0JANGMFcJXMd+guOj7WZk?=
 =?us-ascii?Q?wxRaGNNOLRO/bcKPItA7e9Z2E6hnBYKxf20ScN8oDj3czi/pU2zZmviBHvhe?=
 =?us-ascii?Q?klAFLENBUuhRHqXx4lElks/qPU5E4witOIx+56A8JglowsnOykvMv0Oln9y9?=
 =?us-ascii?Q?PMDEktdKmsvExxZvx71lBkHHUSZs3suasW+uUj/wlp/Jplb9P2FkZUcvy1oc?=
 =?us-ascii?Q?C8N9PJzueQFrOhWsmgBbH2hXfRJrTVmqo/ZJgHdcZxnMTYIE5EMHEXRA8NFW?=
 =?us-ascii?Q?WiW/D+hUd+nTgyqfZ55Hh8fEr/nIjakkB2mvDlsGAuBEJOIfRjdTdb5OcI9/?=
 =?us-ascii?Q?Qr/G4xAIALoD9seq/nQHGgU+GlyH0Iy9AQ7fQbiwGBq+UATDc/GQqpWIH4Ip?=
 =?us-ascii?Q?QFP1cNtuSe9YUuRoOJ/nIaXa/Zs4sTG7cVFhwo8yzUY6lc2n5JY39h8fBW1u?=
 =?us-ascii?Q?0W/k1g1QGfto0KPHw8ppQdNaiFf3ZoqwsCLU6zMLx+Wf6Y1Vj7U8r9lC6SID?=
 =?us-ascii?Q?GOQYU1GTMlFFjQ32xhOw4qrpqG4Da3JcfCR1LnXOPnxZ9idk7Rz5LSebx4jY?=
 =?us-ascii?Q?xNSDGq6rWQJ5noWcnWpiPHYUbiy9klcvN7Od0mkSZkTEmPEbkN2xjYydQ6ie?=
 =?us-ascii?Q?jCw032PlQ39LhfDyP+U9LNFunyy4ZaerYVij/czSpWX5BanSFPRednP8BS62?=
 =?us-ascii?Q?icQcJUrgXu4q/X6A1p4eRAEBTmLBN41MUhHOP1Kt3re2KLlVJbrqP/uFkmRp?=
 =?us-ascii?Q?uNXz35sbmbcnaLSX9qfFwlF+qhitY9MZNLI+znf4gzYLFCiH0yxiXmXLLScS?=
 =?us-ascii?Q?HuoAXGpAe7tlF/InvsjYvZEXq0N6sW96/I+p8BmPoHuZxH9isb5reU11ahCC?=
 =?us-ascii?Q?xLHhyOesam9xSPfCvQwf7CzvJt26VQkUbqSLEohxuW7n7IWvR9ShHUvAmSUo?=
 =?us-ascii?Q?EKMoq7HEP6k5gDwVXOLCpyVWZoMhYr0sY7cuGMhBPNdWB+KmaOTfvmGDUzzw?=
 =?us-ascii?Q?B9Oqz/Gn0Q+CBbVtGFmtZnHztOZ3misf9+E42h+TFBfd7Uz83pPMuots90cr?=
 =?us-ascii?Q?B6oiP0kKv3SFo2eW0aGqPWBCb2qxgfB+UOe3FJXXdunMZhOJYR0MuQTQUlYQ?=
 =?us-ascii?Q?djo2RXpsB+idEi6vYrqeincua5SRdgL3TKFc7CeqDpwm8GdaZaqD37xOl6Hp?=
 =?us-ascii?Q?9MOClkaxnCKRGQBZ99vVODOg5ph0xbmC8z55NFd8/dVEBgSK7IHQZyHzAsoI?=
 =?us-ascii?Q?gBBREGE3uc6Zgw8qHXNDfZia?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3feceb77-2f3d-42cf-af34-08d8c9d66007
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:04.9972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zQE4ZpzRMZ/vUkGUO+WrK4GrRtEokmvJROzKJPhnxzObp0KPTCBKQMuo+c/6keEgJxfzg/WV6nzwU4g67o+xyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes it a bit easier to read and understand the code that deals with
balancing the 16 aggregation codes among the ports in a certain LAG.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index c906c449d2dd..380a5a661702 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1298,8 +1298,8 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	/* Now, set PGIDs for each active LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
 		struct net_device *bond = ocelot->ports[lag]->bond;
+		int num_ports_in_lag = 0;
 		unsigned long bond_mask;
-		int aggr_count = 0;
 		u8 aggr_idx[16];
 
 		if (!bond || (visited & BIT(lag)))
@@ -1311,8 +1311,7 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[aggr_count] = port;
-			aggr_count++;
+			aggr_idx[num_ports_in_lag++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1320,7 +1319,7 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % aggr_count]);
+			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
-- 
2.25.1

