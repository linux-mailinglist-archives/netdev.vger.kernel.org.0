Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC914AA3EC
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 00:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355466AbiBDXDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 18:03:35 -0500
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:8869
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1377831AbiBDXDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 18:03:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd2aCcrHoqm6gj2LMUgDIQ17PPIGWxB6ftIJw7uT8F2wZJYcXxfU+6/+ivE2WWL9OvAAX/1Jg+t/rLrE1lES3mf6AnNn5oP2TKU5MxpagBx4Qgdc+QX0pterbfrMENyjYTvPL+ySH3qGRrNEQNc/hjyKE6vVFfuTGgxGVQ7shokri672GFOJz65bXRoEaaNmJOmhcad34DNruGe97usbFX2oB505Pz1AfLdnHM5aRnN6AILuOgqEBRRcAPLOqQeHrSLOhUglWU8KCVRikiiBuMgYZoQtBAP3pxbcx5vUj1GRw5ML72dEJBDTiMjpzteNLDI+YgNiHMMvniVuBNf2MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2248sQal4THMZm/daPw9Gsgyeb/RELEja29d/LfJIag=;
 b=M7y1dxx5wnk0g86Fz8Tqk/GXlixwQLAtzYLp+xMvwHPAik8L0dEIR/AW5DDzTKoz5SHfAgkV/7W8noPuDp3RekkUEHPr0Aw0kPFU3Q+Lo5Ir+rJiXoC+JHp1QZqBiZ2v6WdiV1iZtjc5kXgqN2gjKRjhAqEZG/KlOdXt3A3dFtORS0PQqErzeWtvXF88YH2YwchfHzXisgvOS/TeEpSh/g5NjAf0VcbZP/NLSqGmQDQ7R3Q2MAF/bO9l+SAMEkGoLIizZTG5xaVbhiZg9GgZP9HVuEdWOS4+7FAPBytqK9JElweaFilbasE/1EaKxE1TDmdFu9GxTzHa4hsNxySvPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2248sQal4THMZm/daPw9Gsgyeb/RELEja29d/LfJIag=;
 b=iuf6u+SuWTKHeRWvv5ofSdDT1CUGveAVZtvrADt2Z0LR39mQ7ivzUHsecfLvrjcgJm+vy7emMPkN/9m4H72imS36LIqn75YGjc362z2odw0EoEDZolCVWrXoigT5bPD/BZBEny8k0YTjkjlg9cUwKmx9Q8Ahg1TEq9hS4VpzgrU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8401.eurprd04.prod.outlook.com (2603:10a6:20b:3f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Fri, 4 Feb
 2022 23:03:32 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f4d7:e110:4789:67b1%5]) with mapi id 15.20.4951.012; Fri, 4 Feb 2022
 23:03:32 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net] net: mscc: ocelot: fix all IP traffic getting trapped to CPU with PTP over IP
Date:   Sat,  5 Feb 2022 01:03:21 +0200
Message-Id: <20220204230321.3779706-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0020.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e0c3d63-3f52-4aca-d005-08d9e83290c3
X-MS-TrafficTypeDiagnostic: AS8PR04MB8401:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB84011CA9C12718B79910CFAFE0299@AS8PR04MB8401.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JGBjdpGjQcQs+2ss1ahbXbV7ICWPOqCKjVA2JVIBfVUXZl5OdMv4vaRNhtSRrDslbINx7ZHDJITc8av9ptpmuCFmgKdMrjW1FgIc+/NMRIHOBDAvhAdzYDERVY2e20KfjOYrXgS+mfdtpmTy8J1SWvSFM6C7nPGF/XLT/uSJuxXaSHT+lRXw2DkF/CNldYciRRVlbgQj7PvKDVcOE2Evo0MawI4lIt9yt1Dl1O7BvLkXBIQWsl92McHMd0Sf02WEm8iAeSuJIo2IRL2gKdEwuFwgtvd1xX+jw6KUAcGspu9323Yrz9vRduhjWghxGki4WPSz9JbfpcghfXNFtdAcZujnbd8ABaldB7+jl7pqxkoVA5rDC4qEh7H7c0xCGHNepwhYP81p4VkkiYr9lPLkDNSwoTc61B4mMt8XIahdTloiOfJXhgMJKWS46uWeXNZpS7twUB0ZgPkuf6u/KhkWAFzmKxLIxufqIYfboENzIn2bPLYI3XtkGxN3FkN9hh7ct8vTK12mH3NFIDHC4jPDym6NYd97zemvmMpj4jRwyJUXTGWZZ0aHQ7FpiiSCCwkb7UpqMYytfpr2ORBgxOUMb3g93mFJs784DY0XEOYg7LRFlqIDERPzSOWYp1rJixQW5yXdndH4p5qO7hwooXiD7sZhT4s5pGAswWUmKKbANC+UoTek1lYCLG9eR9StpCoz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(66946007)(44832011)(5660300002)(8936002)(8676002)(66556008)(66476007)(1076003)(2616005)(36756003)(186003)(26005)(6512007)(6506007)(52116002)(6666004)(86362001)(38350700002)(38100700002)(6486002)(4326008)(54906003)(316002)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3iR8XBG9PpZrmzOoeqU/U6JQNCh5vruH7S1ZHpUrJ5zd4Ipz6lCbL9G9u2zb?=
 =?us-ascii?Q?ENowmK/KV7MT3EuG0LjmRzjOrGNeq+KCF2QPmhMq/rk946K5rfqTv2ft+gEq?=
 =?us-ascii?Q?PNNFgdIy1hHm8pSuhIU6LbkJK3AzNw77bjsZh85DuHnO+TntEsxxDbHcGYH/?=
 =?us-ascii?Q?9Zyebq1n4HzYJy13JwYVe5qCBXugspwomeeIa1Uy2XPb0Vw4N0ZhBsVl3AQE?=
 =?us-ascii?Q?UFjVCxTLUHtnNF95uLU9CzNFnQkiLBmCAG78Kg73oNn4syhUGQgaXZZ97eR1?=
 =?us-ascii?Q?/a6V9vvFjd1qhfzbh/lfGwmZTOvkE6WlvCdbD/gnZFoZjJ+vOKPFM/V0GDih?=
 =?us-ascii?Q?CdIFV8JzliJEWl2MdjhN2Tp+Cum6ehcM8NILorml3ldHsoeVnLuIoC/WY7ua?=
 =?us-ascii?Q?u3MhHn2NwcnxWJQnvAATMsxrXdzwjhiW2BwLfc5IUbIrDZMRlT2yQilCD22c?=
 =?us-ascii?Q?jshXLlavc7XXt/6R3EKUFBx2uiPEfNR5ZXA1lg8Uow2D9OyvOIdu/6haATAX?=
 =?us-ascii?Q?qkj+s/8vMT5df3SRRjhSJa62oUVwbrvdUku/0ryjqZ/k8BXk69nBepfd7bd2?=
 =?us-ascii?Q?l60xk69Lk3rkYmytXmfe+Xx1ZH6nukmUM65BPZvlu5Q2zc3Sod4DxoyWE6PH?=
 =?us-ascii?Q?v1Tqwpvjtn4YOrler4nmC2AT6AfiOw7TXklH3O5tYBhAF7fIRfMEoHEk8l/o?=
 =?us-ascii?Q?DbwyMFzw/o4eA0kaGof7eQOkvPMFFkw2nN8Az8lNrL3O6RHW1/Klnzfv5Sd+?=
 =?us-ascii?Q?KEMFjBFsTMf1MBhvRDRs8ovEbJzhILAdwQE35sRTg2na7acntReQbFMZRMCd?=
 =?us-ascii?Q?Xvn4uX37//2MLCqW2TmlKeY1PdXj4FECoj0S7e93wcpvMb2cSPul1MuvJNNc?=
 =?us-ascii?Q?Frl27JaJ/tsOQ2E1GfokHwE70O9c0nZnMVt549NgoKAeyITabTuVMMBr8TxZ?=
 =?us-ascii?Q?lm0CVTtORFnxK3erPoLtL89r46F0vDxfzgtEpMXF6CaD7PX1r22RQDVZ06TF?=
 =?us-ascii?Q?V/b+Fy6yPpb6nPBkvWjzLJZmgmtK+qxYwAL+kkYR/AxJJNgExJ5+oZffouKQ?=
 =?us-ascii?Q?QxMAWyxfuUAZ0YixMcw1qWitoo8czwj/vAvDwqWhY/JUALWaVQfdi34x7iKK?=
 =?us-ascii?Q?J7aXj+xD4UyDEjEbo0yTC1iTktKdez4S9PFxczs40idoehGhLgM9CZZ1XZJN?=
 =?us-ascii?Q?ppj8lSGRYOaS2AePkH9AuSkMLgXrI/OnieRFN5+ouaiNvVQ3/UOl5W99Qmii?=
 =?us-ascii?Q?2B25NeebjB1294xggq3seGTqgiR4flDHazemB5KzjXojibzEaTlG/0k8NBIU?=
 =?us-ascii?Q?vHBmi7Ry5/nVviBKR3mDcyIqduC56f7oKjMI3xsN/rRyUOXlL0UewaeMetpd?=
 =?us-ascii?Q?Spa9fELJWateFCPsMrGUKRyNPwtUzA39dcu2KGWMPjOceJ9xfoiTIs0lq4tm?=
 =?us-ascii?Q?H52l+70PRsibhslrwcPw1GdCSxKF0n9mMpPHCui0NGnYljZqtYKLH5UiYVbL?=
 =?us-ascii?Q?oTIIUFdxqxl1Fi9uxw0hMJ2xvZRjWt2qL7QgnPdYMM4xwBQTZU3L+LB0Fb8L?=
 =?us-ascii?Q?NrOfohMhf8TmUghWNkBncYvGDDl7JLDOFijnUVukotrX0/F6DfcIG7pFLUx+?=
 =?us-ascii?Q?IPg0RzK7GmjQ1SltLxduGjk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e0c3d63-3f52-4aca-d005-08d9e83290c3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2022 23:03:32.6427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4bi2X/JN/SOBE3guDmL3ypWaVFQz8tt50rO/M3EVaWpJLOTd5SWYP4B0ikC1fOGU0pe720syzuVuseiL9QzqtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The filters for the PTP trap keys are incorrectly configured, in the
sense that is2_entry_set() only looks at trap->key.ipv4.dport or
trap->key.ipv6.dport if trap->key.ipv4.proto or trap->key.ipv6.proto is
set to IPPROTO_TCP or IPPROTO_UDP.

But we don't do that, so is2_entry_set() goes through the "else" branch
of the IP protocol check, and ends up installing a rule for "Any IP
protocol match" (because msk is also 0). The UDP port is ignored.

This means that when we run "ptp4l -i swp0 -4", all IP traffic is
trapped to the CPU, which hinders bridging.

Fix this by specifying the IP protocol in the VCAP IS2 filters for PTP
over UDP.

Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 455293aa6343..354e4474bcc3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1432,6 +1432,8 @@ static void
 ocelot_populate_ipv4_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv4.dport.value = PTP_EV_PORT;
 	trap->key.ipv4.dport.mask = 0xffff;
 }
@@ -1440,6 +1442,8 @@ static void
 ocelot_populate_ipv6_ptp_event_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_EV_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
@@ -1448,6 +1452,8 @@ static void
 ocelot_populate_ipv4_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV4;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv4.dport.value = PTP_GEN_PORT;
 	trap->key.ipv4.dport.mask = 0xffff;
 }
@@ -1456,6 +1462,8 @@ static void
 ocelot_populate_ipv6_ptp_general_trap_key(struct ocelot_vcap_filter *trap)
 {
 	trap->key_type = OCELOT_VCAP_KEY_IPV6;
+	trap->key.ipv4.proto.value[0] = IPPROTO_UDP;
+	trap->key.ipv4.proto.mask[0] = 0xff;
 	trap->key.ipv6.dport.value = PTP_GEN_PORT;
 	trap->key.ipv6.dport.mask = 0xffff;
 }
-- 
2.25.1

