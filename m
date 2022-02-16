Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6294B8B73
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbiBPOcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:32:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbiBPOcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:51 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9DEA8EC7
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HstbA8c9NrhogT4xiFMEEZxlXgjSGQwZIOU61fV/vvZqnA20Y+Ob4eglpVmAPpcynkDNoQXUPbSsNnY6cEkLgtDeb/+xFxxdYgtuyc1gjXrjtmuCmscPiCc6Ub4fMeagMBySeGkX1CvtUHoV3LeoMy6KGMJP7C6/APsX9pMUgU34yFhv8qE4s00K11SqwmbEpRuHgJ42tzdaofg/Nf/u7oIggMJXzwSHpzcUla+Izr7k/b0gsWti9BH/fWgXu23X1qeGo9VBuWTsYmN88wkrXdTL283tyeWlBMaIcduj+Dkz/A7SBYhiJNG+xQ1cLen0FpGnhxbN4RJ2h9+eUcfxdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A4P+8o0yeSHyOq9NIp26zVfLnAYdXPAattHTDlX3vEc=;
 b=FwOC7o/hPC0v7wQV9XULj1q8M+o39zMpoRp5WT2zpKwfrruAXOKsqU19nW3Qm6EU7q/0nktkr+Vz/qDI0UuDmsrR3Aj/5fMI6vccyNJ2hg043vuj09dnZv7zczrDAxmuhPVToChziFS5kQCsDBGEeAs5ZQMMFMUMSm8ArLJCnatUBZiImgNuYaYlffZDMZ95Orj85mKGGEGi6ZkDUJa9X3Mscex3fPIRz17AmQhotXYNNMoLWeT3Ex+5NPfQW0/Xa5lVfcCiCDZVZVl7L4ZdhPIeMb/t2aj33gYelGesP7b9eQvPzV3O4gxd+hhZ7h/JA/aNn8vyCgs7iEATgytUvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A4P+8o0yeSHyOq9NIp26zVfLnAYdXPAattHTDlX3vEc=;
 b=ZY6RpaNuRXrkEP+mF/YbgHuhq/qyRva4T/P2YfzTDvATfWLShS4Q6GO0d3r58OsvbwrBUlwyKlH0ChsYvC4VxOrRSx7LVYDBp7BBUbDAEH4GHR/bMEjM73ExOQEUSb3Ux34HoaShqOuiHEj856eT1TAFpEdOVoyk8VoS0+Oznrk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:36 +0000
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
Subject: [PATCH net-next 01/11] net: mscc: ocelot: use a consistent cookie for MRP traps
Date:   Wed, 16 Feb 2022 16:30:04 +0200
Message-Id: <20220216143014.2603461-2-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d308203d-79ce-40a7-7061-08d9f1592d2b
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815D8AEB2AB5DF10D8D845CE0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVmTKujxE1NAVf6b4vLNk2Wxe8R6eCoVe6J+ilemJ76dLNn8zgPJ3pBt6PIEZ2EpGaMDSpHKjIyUZl3oc1/7wCuHCCO/C1vq46D/EMbS+X55VR9yOXNjio/Fmxm5QA/YwrSdLAztHrpHYQmuT3Q9vKdQyy/7OopiNRoTiEnUPZtH8sAfzq+sXodTXST/JrtEjP5c28+PtgzVnKqQdpAs4i+elMkMeE7KMKnWi28kj5Ly0JKsNw0UxK6iQpcvVQ07FzlubVJ68Bs8hPuFnK6nWl2pisoo5/GjB2hXKrTilpVT5E7wBWfgMZ5pcIqt+8R95Tgm6JsRdnPvJzXnTUOTEVsJ+yw7f4tlCsk228W7ujbZ0j6CqA9yxXVuXeum7aY06w38U3AOviWj2yTgrVclzkaTxjUWfqiRGW5AY2Nd5c99Oy8g5pF35pcJGmlqyFzXjLhGlApqMRe6+rpi4mv+LDOkRQwko0jjHHo/tUCk61nX2MzKXAU1e4AbftcFJniosY5S054Cyr7bL0MsulBQdGyowaowbCHh93gaVERa7iYmXGPMDwQ6ltFok5IROKT8oPerYaVTNrGSgeKu76HTjMEy0zrLU8whlTW24eGXOPLphzpKTRat17T/shTKIyl1NopKwXXV5xUBF7FSCs11ZMiERGTzIHMhfOdWGF27xT8Lcti1bh3N0jQAck4AaoHUP1x7mdRMl9qCbFMMHwOBUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O1eFSSduGNsLvpf3gr/3u7UWQRTQZyZl35sSuG8P7U2ia4Co0bPuSSqBw+Ju?=
 =?us-ascii?Q?UsrAqmmQotr2ia/HrLJJQnOFM823VlwkKkb9d83XZTYZ4WVrVm8MAb7lT1K+?=
 =?us-ascii?Q?4agB3ch0sINnsKINCSp+0HBNRgVdfUZX9/QUFdOVzFvpP/+yK/oHYr7niK2J?=
 =?us-ascii?Q?dF+mrJi0nGlWa781xvKEIWF5wCtlcCu9GXkV46FlWpUpKIDYvR3/lrebMxS1?=
 =?us-ascii?Q?6kZwyzxfISKdCSMvv2U8tCCaT2RSjfqBBoclk9XIoIus5B56FB1TYkPRX0ox?=
 =?us-ascii?Q?KAlJ1uBx95T+bfAiP+nuLYZsHxRqw3DtRRACW1hkplD6Rz1NpFEjdZlNBViH?=
 =?us-ascii?Q?hs7yLvSo9hpFXNcMno1IgJ4KbIP8EtmNtH5gRw0i/A1qkpW707QiIE2Zbeaq?=
 =?us-ascii?Q?LVE+DZfEb7rzKJx7SM9/SwKiyHumWDBWSweEA0aXRJ3HJ3et6dh1JH6IH5Un?=
 =?us-ascii?Q?1OSEcyjlTM0abN0NO6H7eAmer0YV5CFiSTn544PMh1MG80eipScXyEirBCRg?=
 =?us-ascii?Q?CmdhbivGYvyMgzmlzCPBysdTRIVBo62YbTdOR1m1qUXj/UVi4v7ZIqi+KLWC?=
 =?us-ascii?Q?klc1ovJ9wLPmRUUj8FRrmgT7SSX1JkwPsshI3G3iM2spBi2BWR5HI/3jgqcj?=
 =?us-ascii?Q?gPKSX/0H9TdFfC9I2Hew+JeU2i9jfRFtzJPlaeHE2BN+Azkxwniu4mEoTcyA?=
 =?us-ascii?Q?+qgwYQFVBbmNd2jPpK0ttMLM7WUP6Ri6uuz9zhqHM+3nhCejm5s83RaFa/bA?=
 =?us-ascii?Q?m++KcONW8/fTo69UYBYa8JR/YUUiDZlgcELSmNVgcMFauRDxgm8/Me6hFY36?=
 =?us-ascii?Q?bHyqP+vQlcfokh9Buw7NH+pDxVYGBzgf3NKtdCq/VD3+Qh6D94FVUKZNKZnz?=
 =?us-ascii?Q?7CR3om8sKfCs2hoLw+3LaYoaQOi1u7EfnnoQYPzdgkGpy+jAp2mBy4Ze9U+V?=
 =?us-ascii?Q?4MAuIvONc51I1Jg6XqEqyH3JtnJIbWLBc1IpqTR7NMxqS3mMrp+sxNKzc0Hp?=
 =?us-ascii?Q?N7uO2VvDM+RSh2r7LlZVe5mgihzRylSGV7BhPi4CM3COBp+LJ5cKAg94VJOA?=
 =?us-ascii?Q?3OzQ2fcbLjVpZtmY8xxIwLtCIZC74aOrAXGoA6LXgZsXDTCJIqKsseQm5+et?=
 =?us-ascii?Q?nc08j0k62lZi/wODwMy3p7QoVpH7zClYPIxodIfz1hN/mOpWPO7PriayIbWo?=
 =?us-ascii?Q?uY9gYjgFVwjI6Xy1JdWqTOJA+fGqVOD1chTqpp4aQdxL6567q5pHd50elimn?=
 =?us-ascii?Q?0VKHEVH48xBTZluwya6XKQLZbndhfuZ7u96zVNcHihhAt0SO3WEtN1pN/f/a?=
 =?us-ascii?Q?wgFaICt4l7kHsO2f+1S2UsWBwcz3BbFI9G7QRC9Teg31BtrGGPRkUU1m6xX5?=
 =?us-ascii?Q?07snNwnZBGegRh1HfMpPfQ467DObFOOh5AWpol2MeZGWr8eU7MMc0PRPQkbE?=
 =?us-ascii?Q?APX9gXWja0jib2ISienuCFv/9JRJwGsypcz3GuMHAUgUm0RGA+KM0F4kt5b0?=
 =?us-ascii?Q?m5AA7WigYhYI0T6U7r7opuR2zLKfASH/7E7c2eKbcb55+of3lVqprkJNq33/?=
 =?us-ascii?Q?oRwyqFUfafQX3bcN1/RufdWGGSjj1MTTM6wSGqjzAgLcpP4/d+ToyWCdXU+Z?=
 =?us-ascii?Q?3MJ32gSHCS0QBD45MhljMaM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d308203d-79ce-40a7-7061-08d9f1592d2b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:36.3559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RmZqzkZTlxOPkt8ypYvca7nsoSnd36MnuwdycDElvba4ksjQ/dxqX60fr1qLoqgq8Xb+ZiBaI+pyyA9IFnCubQ==
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

The driver uses an identifier equal to (ocelot->num_phys_ports + port)
for MRP traps installed when the system is in the role of an MRC, and an
identifier equal to (port) otherwise.

Use the same identifier in both cases as a consolidation for the various
cookie values spread throughout the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_mrp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index 1fa58546abdc..742242bab6ef 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -186,7 +186,8 @@ int ocelot_mrp_add_ring_role(struct ocelot *ocelot, int port,
 	ocelot_mrp_save_mac(ocelot, ocelot_port);
 
 	if (mrp->ring_role != BR_MRP_RING_ROLE_MRC)
-		return ocelot_mrp_copy_add_vcap(ocelot, port, 1, port);
+		return ocelot_mrp_copy_add_vcap(ocelot, port, 1,
+						port + ocelot->num_phys_ports);
 
 	dst_port = ocelot_mrp_find_partner_port(ocelot, ocelot_port);
 	if (dst_port == -1)
-- 
2.25.1

