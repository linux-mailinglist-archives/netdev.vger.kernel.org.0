Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689522D2A59
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgLHMJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:09:47 -0500
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:13187
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729343AbgLHMJq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:09:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQPN+ThoSzNP/swK+Pu2ePrIEFdjuyMaY9FoR6fJ65HQzXc8iGmDJKjVGyLDV8AjV9MKvupOVfP+znUK6x/NjnE6gnhYjkNd8vn/0v50JqMkfDmWUGaEWHY3GVdO4G4VdkWtrJK8ioUzGGoOsrCLC1qYKo2GarNIvRPGsGuk6r6BPtFzmzaDQ9L66msWMevknc8eMyWk2KVoTBsFzlfgU/4TfJWlJxBof5U+EZHHiSNiRUpbjMzrYJ0WQHlOtRHJeFXQhyDtWbA1GYR9HskSR4ZlgskLen0MMiI8Wuv4PZzvgD5G4FEAdzE4kaezwG+VbwBFe/HtyWLLidvteFTvGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8CzEddcZ2lTnGOUJZnBEQa60I3qWsy/+rzWEAgQLZ0=;
 b=CZWjhjbvR97W6NF4WMz21r8iJvHTQlryHJ6JgN7egoAEg3so4tu2GOj28755a8X6ziDczsUYcgeJfplbvB9lkjZXodyRJrUAdO4mlW6kq+ddrr0yb2vL9HArGLaVFz7J4g1v66iUrvSIRCvDhpMtHIfY7EM54mQPFqpDjqUpRBMZQev/iENYp04XEaNdil4JdfLJ9t+M4DCAInpTxBQoul0KN60MJeK9XjTCqbGvGcNMwjC2PxJbovOQMNhS9KYYegO/jO8oPPkW/TUT0uHZTvVYlcE8UuFuo9lH0kGwsZXHDoT1ovlsNjHieMEb+ZVdX60g7u7IUC9zfTg2GckZAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8CzEddcZ2lTnGOUJZnBEQa60I3qWsy/+rzWEAgQLZ0=;
 b=EMTn0HkNTDyRJqOQMEf6KR7tOxhwbv0B9KgBLQQTZSs7+RPvRGZTjUU2fooJtr4SnQI8ju0npXeu+462psEulIlKGMpymoWdV17md8sDeF2EdrauROOsBBKR89iMs0hHaOTtsL91V5qJNucQ9dYkQuXeiarmAaFkUKYpCJ1YQ0I=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:28 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:28 +0000
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
Subject: [RFC PATCH net-next 06/16] net: mscc: ocelot: use ipv6 in the aggregation code
Date:   Tue,  8 Dec 2020 14:07:52 +0200
Message-Id: <20201208120802.1268708-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ebce3ef-686a-4ce2-d5ed-08d89b71f8a8
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB56934AC497EFFB9886EAF953E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Eo0RZKbKnmSF26VhumAIi8IEjLV/P+4O4MR43khbDMmO0FOE4FSheBGTl53+/4e5k8VycdFL5FQdDJJiNudYbxii/AoWa/EFEZX/9pfLRxjLnC/bP/mCgCCrEIFTbhbuOEh1GqfNdONZS9cetW7jQNkl4Pm28ao7OuCz+DjAmpitELZEjnIXybDr+JEqiksHUNJyjPfDRFRAWUYpDd1FR1hsjvF8agRaJiVsRVK7BWbBAvgzLegOj54AHgF7S9W8WHlQoskuOAYSIXHPIvefUthTgqFNSIybhvsxqe9czYVpahplL7OYTv90OYQbrVVj1wtoA9/PfL3rOapSQvh8MGjgegYuZQjpR/CmQaMjkq87tMLtpx6Hu1ovB3N1zHKk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mytDkpTU2tPds6WKbJqeKJDeeBOrIaLH1nGEpjUMC6GYKO2CkHPfL88y21XZ?=
 =?us-ascii?Q?xKFlIyOtlGKHH7M80MFNhLPEotqVVT30Wkmm2S5Qmx6+jG6nzlx5yH027H5Z?=
 =?us-ascii?Q?kRqBJ3/O6fpN2ULuQVbVmWX+gwnJbv5jX+pyQlxX1l9fnCtvjT556omkZTus?=
 =?us-ascii?Q?oiGqEt4BMdNnGXbOXiJYjJZRGRUWmURFtFhz99p8B3gJtr+n7l8Q3GblpoiZ?=
 =?us-ascii?Q?rq5fstAK61iGCctrdHcc3in0fDsgIQzjVReaaaHOoKIPhHPnziTxFl7iVuVA?=
 =?us-ascii?Q?ZzGHRL91TaT5G44TSz7Rll5hc3VSU9Z/FqMHQdTpGHy+ajqYnKvWkIWgu3bE?=
 =?us-ascii?Q?BHXtL35qw3j2xJnolfBM7rWJTI5uisYMTyQl2/aSVJgCUp7FL/OQlJe2sbbA?=
 =?us-ascii?Q?raRitefmtLnhnM37qUTj461LVtMbmNUTX4Fn683SuDaps1UM6JTJdnCbRmNU?=
 =?us-ascii?Q?xS9taWreqJflWjy/0IW2D1A1/6Itsaxge9h7lLO+6MQQxcKxjJvSmA8Caj4f?=
 =?us-ascii?Q?3CHMx6KlHSEPq6US9Mp/ghGbctp/s9D6bmq/YhU75WGuq5gKz1cPFtYtq7Eg?=
 =?us-ascii?Q?WI5OKYQ3d3zJ8MIBR/OUe6K4wP9r5FqyATiSBFHQlo1ymidxUe4bIlA6KRMh?=
 =?us-ascii?Q?nRCGjOr7yboeJMeBymwHCHRtCLXJ7MbgRLao+V+lxLRxCUfHbIJ0nvoorHF5?=
 =?us-ascii?Q?mypZ5LGrr/sYF7ZtKMetCnM3o5lTVH81ut96wFhEGFvrGmSXfNac1flw7O6N?=
 =?us-ascii?Q?V6IK4O6zMvMzdmzxZ3GEpMLCi0DfLmPNpzKm/AnR68YTXI4UCsVZYYZpCgyi?=
 =?us-ascii?Q?lOKYIb8UtC2ptG3gVQlVQec+HwkX3mhj0OtJSPbHFsE+sEXECyvi6Fw+i57c?=
 =?us-ascii?Q?6+x3aj1rH9AwFDDIWrCFem+IzyumcO2Y0YqmNAApE/nSqg/iosXyv4jEpNIp?=
 =?us-ascii?Q?q68cnYY5LISCYJsUsx5giOgY62zqO5z65f6Dy4zQSI1waWW9OXw8pwV921lt?=
 =?us-ascii?Q?2bhC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ebce3ef-686a-4ce2-d5ed-08d89b71f8a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:28.0458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MaTGTZ8liwrORrqJ6Hz9vP9SjgMMIzIs0kbbUomerbz3Nwu7Md5D2vwlXIzaGnLUio2J8vIySM39k2NLpyMjng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6 header information is not currently part of the entropy source for
the 4-bit aggregation code used for LAG offload, even though it could be.
The hardware reference manual says about these fields:

ANA::AGGR_CFG.AC_IP6_TCPUDP_PORT_ENA
Use IPv6 TCP/UDP port when calculating aggregation code. Configure
identically for all ports. Recommended value is 1.

ANA::AGGR_CFG.AC_IP6_FLOW_LBL_ENA
Use IPv6 flow label when calculating AC. Configure identically for all
ports. Recommended value is 1.

Integration with the xmit_hash_policy of the bonding interface is TBD.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7a5c534099d3..13e86dd71e5a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1557,7 +1557,10 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write(ocelot, ANA_AGGR_CFG_AC_SMAC_ENA |
 			     ANA_AGGR_CFG_AC_DMAC_ENA |
 			     ANA_AGGR_CFG_AC_IP4_SIPDIP_ENA |
-			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA, ANA_AGGR_CFG);
+			     ANA_AGGR_CFG_AC_IP4_TCPUDP_ENA |
+			     ANA_AGGR_CFG_AC_IP6_FLOW_LBL_ENA |
+			     ANA_AGGR_CFG_AC_IP6_TCPUDP_ENA,
+			     ANA_AGGR_CFG);
 
 	/* Set MAC age time to default value. The entry is aged after
 	 * 2*AGE_PERIOD
-- 
2.25.1

