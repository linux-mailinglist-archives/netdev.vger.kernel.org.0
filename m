Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CBB4B8B79
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiBPOdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiBPOc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:57 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D671375AA
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqqlSJQvCDk+m2EHq8yg1Joz2tgTg1aaFTMWZQCwM4EV28vB/p5xBGqUqcLjXrPabpEZhY7gvJtDPpQUMYem52PS9sXav7YDgWx6AFNFnc1xlOVnKV5oqK9vbkkfFdsBp9kBlEYajU9xZ6kkigsq7utIZl1kc8YYEhFP50eptqxSHFHMRyJP+5lNAIR00T7GkNBiH9ACgu1v2T0VZ45b5kYg97zH5y6lSZ6kvDNpRbt9lifd+V8KO1bWNKrHNxkR9PeWRiWUi0op1Qjpq5IhqRWDZ5qAW/P5dwy1dWEcfbIUlllcwBHHggM1O+eme10CDmtKMA1LyvysBsM70DEpkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYXiXIspkHBnY9f+77PtuYkUVw7jUnYXzakUzgH4ZVs=;
 b=ImiDMoBsMqHCuoA9DdrRl8r82BeOEsRq/eP0Qm9Zhf81Lyc2CMnHHxgRuL85cVtCVa8n1A2GHY/2ISzjyn7p+P/dF9dsynmesLZIgKpH57yZJ/v1SKPtdaZQ3Xw/xU7Fh0NgUZ7r+Xp9mfN+qXpCWjdOHCHwcHQyig69Xt4YruBkCmlc7dFkYk8r7w3A609KDOLhn1tEgTLWui1sf0BEdvbYA9jDDRzORaEpYC1Nsr5Zbd3gMysZ3i04zue871Qw+64KF/xr9xbU7ksu7ReZAd8iciUdecMuGEwd89KVPI3xsb21/aol2sjEiP8xJQ2MduFOLsF62Al5Pg4TYKszQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fYXiXIspkHBnY9f+77PtuYkUVw7jUnYXzakUzgH4ZVs=;
 b=Gz8gxzbgQiYGTiVbeMN/Cu06UfQicaAO6xajcxM5k7Qk7Bk1AgO3kTcH0u509SPQOTzgaqeFxmnGsDOpf1oeglifxgVFJnn6dYPC5C4FztyFxBnITG2eyA50nyY9YNWLUzP6Sp2So7wCZjBM5GiqHlqUoh31Kssui6F1GGYSg9c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 05/11] net: mscc: ocelot: avoid overlap in VCAP IS2 between PTP and MRP traps
Date:   Wed, 16 Feb 2022 16:30:08 +0200
Message-Id: <20220216143014.2603461-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
References: <20220216143014.2603461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:208:be::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dfed705-f78e-4417-1592-08d9f159304a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB681595321B6EBD60891DE6F7E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZKkF3YITIGjWr50LnsVQ7SynayBNH87PD6Z26Juh38OfF3LB27Nmnl9UH/NrBDJOxGYPoQhPzJeyDoqRkH+dPZviNEkE8+LlNxqv8z4mpM1BtIO5btLianaLsprYWipDZhDcdxNyhOi3SH0idV8G/UZIbe1SJslspTtQGGJNtfxo9fiRE5eIaCzzapKQ0EMLVdBKwE/6elkYANS1Em55Dyd4JhnCCNUSpv3cCI7lakr1NTbObKA+8n50KS1b77pmOQJIIGV8WsOLTbFPe1c/XZbBhfF4WMr8MB76T0tnl5Q+bv3CRtuk6PG1iqRD14Lc7GyWiPoZiBICuPSiPVwSSuY56Sd9tGbHJofgKzVnpkCLwLxyGvNomY6Dmokb3Ukmc9JbUdx1YUDA8oRn1u65ercGf7zzICtCpTgx/5iQrwRpn578iNA9Gg6MHe6hvp8k7ZAmCl7UxkSRJz+/q2Ld7M9idbM3r9KEC7P9vp11imMHL1vmJcp8+iUPoTBADwYVUoLZM+H33Sm/OIP1J9QPt0f2zFo+zv4+ekE2VCPT0fLcjt1EGSVMiNm0XfqJgVyLWmdGH+DGxqKbvsLpnAblu8uoM/e3EriQ7gHK3QezeAgSf9gwFIIr42hid8FBenWS6obAvX27SCTAaeiPhKctrG06QoOYVk4SJXZnymD8uaNWrNbMO7Y3PeWEj5UTweswfnSxLekkrc3syJBYwUAdFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X9R3ou09B6xji5NWa2H1KfLXld40pmQvVycaUT8kaDCaB9Y1AcZEAObpSMxn?=
 =?us-ascii?Q?38C3bsgtbzKnTX9N2lwHL+ZnMoY18pjZqYDq+vNOpbGsf0MgNwZF7uApm1bV?=
 =?us-ascii?Q?wg+O/4kARV14L6eALFczx7i0oKAN6ulcD9bWJ8XlPhgqpjVg43ayGAqr77l2?=
 =?us-ascii?Q?ljjZ6GM0flMM4MFPyK3HFbCFjkLoEfizl3JbpjRvj8Tbh5ZzrISApVDcDLVa?=
 =?us-ascii?Q?KosYn2Wp6eUsKeG+lXDtaMXCE2/DMQ/qChR7PYHEZqt+Mh7/cxPY4FghbTz+?=
 =?us-ascii?Q?F72M2j02eB61enk0vIhN9FhbAME3gdl08crt6s6O63l1+bLzPzmee0TE/503?=
 =?us-ascii?Q?HmgFrUuH78GGu+aXgefTYbBFRA27WFug1DDAnPygXs6GJqeaYH+Fns2DFwwC?=
 =?us-ascii?Q?Y9sLZo539hoaCSqQ9kvwkDZH6kjGt35l5wlRvPkBHusbwcygbWg8OZ7Lb1X+?=
 =?us-ascii?Q?mZ4NPe0iJ/uyz/DESP9Mb2ojOLHxC0qBDpcBXiDTqaR3TTGEZWsi5noOmZuD?=
 =?us-ascii?Q?o0GQs4Zuf0HnU13K/KV6L+SDN71vHW58ZlsdikvHjpbVu/yRy0+o/MjT3uGu?=
 =?us-ascii?Q?rrPTeJFUvxDQPWlBWd8BMNLNlz1t8cz1mp7TzzJQyxN2AnDxv3jWO0S6pmg2?=
 =?us-ascii?Q?BdxMHa1axdicSUVR2sqcQz78olJAAjw5qfLiA/rTe0qDjH0xEXiFnuxNxua2?=
 =?us-ascii?Q?0uPEW54DUiSx7Ao7TkNRETyqNO+PI7ZHp/vedwFAMvnHUjBW1AlPXSQoaLgE?=
 =?us-ascii?Q?iMjKHNqSCQSlpAegWVGtbjeWV7uLPYW8VaeHPkAFxd786Sz5lkVmAd+aXj43?=
 =?us-ascii?Q?a5eNMiXDSnoTfJhJ8vrGuFRyWIIktxMF7IJmzcnG191QGmDoK/Os39s3T0Nk?=
 =?us-ascii?Q?5HJBdFHJ1fYwoU4DAwvoT+V8K0sa5EoFwY8x7kg4XTYl/pq9+Qz8JFYQXt3O?=
 =?us-ascii?Q?24B96bo9vsE0KJPXm/3TIVzmDwFMIvoai3/d/jLndpr/CTmUk15yaPdDp9dz?=
 =?us-ascii?Q?pki+IQOM6GAxVyEFy2z56VF2eedXRCK/yXyjh1T3rhNY8xG3GyOdQ+3AXuXf?=
 =?us-ascii?Q?dJFh7FmSJX/ep0SZ4kN5RfltVOwp3y/lh5MtMtqlyJkhfcA4U0bmTywtsuLz?=
 =?us-ascii?Q?epHOZAltFisOGZhzHt3TV32l3BYaNqGWx4tM393c+ddwq5X+HABHn0ItWKpe?=
 =?us-ascii?Q?q1h1QTgR3k+qx4zQW+E6CMmbnSkZ3fBV6ZgwtpKxKwfZqQYLP8glQeeflmkC?=
 =?us-ascii?Q?hOBg/YBbxge0sQ/sOl5/x2m/yRipiHeUIWwPUfj+dT9rgk8GDWA87J223tQ+?=
 =?us-ascii?Q?6AXAoYd/sCtMfS6XnsP2DerJ4hbE69rsdWNaGXm6m+FjHjonyv6FAIAa3l3Q?=
 =?us-ascii?Q?BTYMtIq+o0GZ/uaEMdsr/jXfjb9IwnC7+b3CdvXYqXKn7NZ4JM//Y2uJ5Pyg?=
 =?us-ascii?Q?undD5z+bOET47eInjU7h1ciGEGIwbOI84EIDkXXLJ+g3hsh/86n4HJKB7VSF?=
 =?us-ascii?Q?JZ610LV4xWoUuDwoiiENTtt6dbJLVfRcmDxAoowkuKOR0YUuLv8mivwGnMEc?=
 =?us-ascii?Q?qTu+ogmdr6K6/QJYuNtkyzAU7Ry3onkL7y2W+mWR+CfCzPRSlMRTj9nEf7Ba?=
 =?us-ascii?Q?AhWyQ4ZzwkTOd15ZRRdb3fk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dfed705-f78e-4417-1592-08d9f159304a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:41.5430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: roWY4EkQdV4O/5QdfsfIf10iPoUATDaGAuHYcu09lGauAs83ZRF3k1n7952GXIRgaRvV0JQLcl2kAhDsPFBZNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN overlaps with OCELOT_VCAP_IS2_MRP_REDIRECT.
To avoid this, make OCELOT_VCAP_IS2_MRP_REDIRECT take the cookie region
from N to 2 * N - 1 (where N is ocelot->num_phys_ports).

To avoid any risk that the singleton (not per port) VCAP IS2 filters
overlap with per-port VCAP IS2 filters, we must ensure that the number
of singleton filters is smaller than the number of physical ports.
This is true right now, but may change in the future as switches with
less ports get supported, or more singleton filters get added. So to be
future-proof, let's move the singleton filters at the end of the range,
where they won't overlap with anything to their right.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/soc/mscc/ocelot_vcap.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 14ada097db0b..ae0eec7f5dd2 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -15,14 +15,14 @@
 #define OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port)		(port)
 #define OCELOT_VCAP_IS1_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports)
 #define OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port)		(port)
-#define OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports)
-#define OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot)			((ocelot)->num_phys_ports + 1)
-#define OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 2)
-#define OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 3)
-#define OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 4)
-#define OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports + 5)
-#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot)			((ocelot)->num_phys_ports + 6)
-#define OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port)		(port)
+#define OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port)		((ocelot)->num_phys_ports + (port))
+#define OCELOT_VCAP_IS2_TAG_8021Q_PTP_MMIO(ocelot)		((ocelot)->num_phys_ports * 2)
+#define OCELOT_VCAP_IS2_L2_PTP_TRAP(ocelot)			((ocelot)->num_phys_ports * 2 + 1)
+#define OCELOT_VCAP_IS2_IPV4_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 2)
+#define OCELOT_VCAP_IS2_IPV4_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 3)
+#define OCELOT_VCAP_IS2_IPV6_GEN_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 4)
+#define OCELOT_VCAP_IS2_IPV6_EV_PTP_TRAP(ocelot)		((ocelot)->num_phys_ports * 2 + 5)
+#define OCELOT_VCAP_IS2_MRP_TRAP(ocelot)			((ocelot)->num_phys_ports * 2 + 6)
 
 /* =================================================================
  *  VCAP Common
-- 
2.25.1

