Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2692D2CF2EB
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbgLDRQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:16:12 -0500
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:45157
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbgLDRQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:16:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sti70oXTTdlBgqyOyMGP926o4ZzMqaCE2sUKdSSyRaKirgsJ35sNM1jBS8ZlZjsc+x6+KPh3Ad5okot8NDC3tCE4xt8j8PpCkXKwXSnf27KbFzTUlJ+HFYLR+Tz4ijRHvdgUTHv1dszc+pFD9oRlLdc1us5UzYobTZe3m8UKSxmQzPX66Ub8joEQjTV5qwYeyb2/CS0Xhf73fpFsHFSdEdQB+weKb3zXp/buH+fyow9McuP64m5YfElFs/1bY5uTIVQp3CRlWDxczy10LnxxADdCC5//eyqXa1+vaBbBW5cA6DuSxTRStAE9gFySvmRWmANGCgNvJ/sNMoDNCyWSAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVpIvVNwi7bDBOr+UUe4QbiJb8sg0pbBIhIey46n0Mo=;
 b=YSiHLOl7NgO9YG8ZGNbzbVblZE9HIPLzpuC7ZQEtzOXvHvJ1FWHtBAw1AgvwqCdCwZYj/OEwmVQEym36iCRLHxmbOQlhW6mlSao+GoWBVigsvdsnvEYJvFtXQJs2LKcWPud5it9u0j0CIgtueGEH7p3uib4LjbTtHvThWmqRywTeCLrEcbOSrfPXtRWj6/WiPwHg5VKw/++zOGMsGT1Mm9FbKhBKbCrR4epy6Q94PhbR5NhqnnLPmjxKQTFrdNFu5aIPmtcC9k5v95Vk2Z3yK3QaSHvWU+yX+9TyARvUQ/Md0JrfGlA5+RB6XUxWsDFUGerEM00/cPgfU4snRsyeYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVpIvVNwi7bDBOr+UUe4QbiJb8sg0pbBIhIey46n0Mo=;
 b=F3DTMz6kM6/7IxKKEB1EWgLYS5XTwXCRNyMuUf73WoAFHEZW+DttgBpEpPFFFvNSaG8R+NxYMlV0biuak1l0lXH8/2VatK34GO0A3Tl7Ruf1ve9aXVTXn9OaeGdFoXXwfJ2jHUwpHwuY41Zpbybsb1e5hTX1DoxcWLD0xQc1GNE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DBBPR04MB6123.eurprd04.prod.outlook.com (2603:10a6:10:c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Fri, 4 Dec
 2020 17:15:20 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 17:15:20 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] enetc: Fix reporting of h/w packet counters
Date:   Fri,  4 Dec 2020 19:15:05 +0200
Message-Id: <20201204171505.21389-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: PR1PR01CA0032.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::45) To DB8PR04MB6764.eurprd04.prod.outlook.com
 (2603:10a6:10:10d::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by PR1PR01CA0032.eurprd01.prod.exchangelabs.com (2603:10a6:102::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Fri, 4 Dec 2020 17:15:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3c474bcf-756f-409c-c564-08d898782d93
X-MS-TrafficTypeDiagnostic: DBBPR04MB6123:
X-Microsoft-Antispam-PRVS: <DBBPR04MB61237960213152062F86195296F10@DBBPR04MB6123.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEmWXDrNZxiwyXjbgTMLfp/pAWcVqH+9HQyTO3Rry/0zd38fUJGskOx1QssuyDbUvksMEqVUmbJJ0/saJq2eEH7FiOBiRyOsgmKHP4WtUpbqa1NFLdQfQjGOS4eH3dgK9XmptEU7JePe3jd2I7GTG9J7Xrei+Kt7SJOGj5YzByxVrgdh/MhWqMaSFUwjCZAHWNK3YthG6ZUEtnp5N31idEIeu2rKxjn6bB91OUwgx0hboxU0BTeUxp3tHBfcmFrBoyfR/dpwsan14NsrzbMZmL03R29g374TaM/4n4+dGTNZjcH5sVvkKTz3G+0xgg1TwYLDIxB6LJKbW5Bm94GiGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(376002)(136003)(26005)(8936002)(6486002)(186003)(2616005)(6666004)(7696005)(5660300002)(16526019)(52116002)(956004)(478600001)(1076003)(316002)(44832011)(8676002)(66476007)(4326008)(66946007)(83380400001)(36756003)(66556008)(54906003)(86362001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ipbZUMow4XwntOUGI2d5UFKRAJWvNjTg/OSpBOTheu/XIIp71gogLj3YLr3p?=
 =?us-ascii?Q?W2sKzngka3mhdlDH10ZbdVKyRg+c+n3GJ2tAnkXXtuuThOhMlfZbAkm5R0wz?=
 =?us-ascii?Q?akES+AZ1XpNhFajyLJ2CErzp6pZ9I82NAd8aTWGpDbpnsp8np3eNoyBTpSAT?=
 =?us-ascii?Q?RNxTUM7+mTc5RN55cmD7QZ0P2C6ge+pPze909U/5e6YDd3M3cmI1gHIYdgQj?=
 =?us-ascii?Q?c5kBwb0pGs5zeE2wtNkpRSIuOMZyKi4G6Hdi0N2bHY4JimKndR3C49OZZKCM?=
 =?us-ascii?Q?+o0LM9top1Nxyqj2uSgEy1U+ivx3Yv0u+Ofj6hyl8jPSgm69FQUOGLUwPJfc?=
 =?us-ascii?Q?uzjBbfeTYlEuTlmPQyYRu2Qbo+QUdINEbQUC6ZzpTs4eHPrakGfQx7e5wOKH?=
 =?us-ascii?Q?tb0o486aFfBVrBji9bSj3PEHm5AWGkDi2FIV2Qe6pdYbIRnDO2IsZ1MGF6AQ?=
 =?us-ascii?Q?YrLIGpSWE+8R+cHlPBM3LZB1WqjSdDOfo+4kolU/gZ+hWNFbz0xvaYnnCzMw?=
 =?us-ascii?Q?YJv0YXU+1qGxY36Ze25Vjm1eDScMJ7TmeuJaMzPEybpkJaXyf6A4uGTRmTM3?=
 =?us-ascii?Q?dianeTZCWAPFpvQ5QbnFJQXwDgTzNS2OOdeyEdcPB8oP/2XfcCvN4ZZersh7?=
 =?us-ascii?Q?g/RS8/BQFGL2M2u1sBcHKxkuMIH0kfuCj8wJNDaCjxslmp55CS6CLKSUuvm6?=
 =?us-ascii?Q?abJZ5p4HY8lwESFS3yZjvXLbvN91OAmT7dtcAMSfeb+vZ4lZ0Y/XNnRhEihl?=
 =?us-ascii?Q?kosajc0+AfRslG+WslxTr2RsVx55f9+wreWMl3YiZulH/kazZ+nQzlG5RyWS?=
 =?us-ascii?Q?Cc8ReJgY7yZoYc5PP4gHAvZoB9/P4L7BxDEEMMpDBuQJUA0SxtXvUM1s/HyJ?=
 =?us-ascii?Q?D1EXwcDkAiqGFvXrpkcG/2fVMgdBeZfmTctzwVHYwZVquGfaix1xUjZIk5st?=
 =?us-ascii?Q?Z5Vj0mwTY+ej6uFQt40S2yf0TnqQrHakdpl0wb/mIdh3d4WZWuXQDwdrttlZ?=
 =?us-ascii?Q?Jkhx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c474bcf-756f-409c-c564-08d898782d93
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 17:15:20.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CA6xXQoDmrWO6GwnFQOuesUvW13OKipF/u5EpeHC7Tzpuz0XFPzR7tEiXXr0VJLNM4n8tXwELyKACNKKJ8+eiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Noticed some inconsistencies in packet statistics reporting.
This patch adds the missing Tx packet counter registers to
ethtool reporting and fixes the information strings for a
few of them.

Fixes: 16eb4c85c964 ("enetc: Add ethtool statistics")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 10 +++++++---
 drivers/net/ethernet/freescale/enetc/enetc_hw.h      | 10 +++++++---
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 8ed1ebd5a183..89e558135432 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -143,8 +143,8 @@ static const struct {
 	{ ENETC_PM0_R255,   "MAC rx 128-255 byte packets" },
 	{ ENETC_PM0_R511,   "MAC rx 256-511 byte packets" },
 	{ ENETC_PM0_R1023,  "MAC rx 512-1023 byte packets" },
-	{ ENETC_PM0_R1518,  "MAC rx 1024-1518 byte packets" },
-	{ ENETC_PM0_R1519X, "MAC rx 1519 to max-octet packets" },
+	{ ENETC_PM0_R1522,  "MAC rx 1024-1522 byte packets" },
+	{ ENETC_PM0_R1523X, "MAC rx 1523 to max-octet packets" },
 	{ ENETC_PM0_ROVR,   "MAC rx oversized packets" },
 	{ ENETC_PM0_RJBR,   "MAC rx jabber packets" },
 	{ ENETC_PM0_RFRG,   "MAC rx fragment packets" },
@@ -163,9 +163,13 @@ static const struct {
 	{ ENETC_PM0_TBCA,   "MAC tx broadcast frames" },
 	{ ENETC_PM0_TPKT,   "MAC tx packets" },
 	{ ENETC_PM0_TUND,   "MAC tx undersized packets" },
+	{ ENETC_PM0_T64,    "MAC tx 64 byte packets" },
 	{ ENETC_PM0_T127,   "MAC tx 65-127 byte packets" },
+	{ ENETC_PM0_T255,   "MAC tx 128-255 byte packets" },
+	{ ENETC_PM0_T511,   "MAC tx 256-511 byte packets" },
 	{ ENETC_PM0_T1023,  "MAC tx 512-1023 byte packets" },
-	{ ENETC_PM0_T1518,  "MAC tx 1024-1518 byte packets" },
+	{ ENETC_PM0_T1522,  "MAC tx 1024-1522 byte packets" },
+	{ ENETC_PM0_T1523X, "MAC tx 1523 to max-octet packets" },
 	{ ENETC_PM0_TCNP,   "MAC tx control packets" },
 	{ ENETC_PM0_TDFR,   "MAC tx deferred packets" },
 	{ ENETC_PM0_TMCOL,  "MAC tx multiple collisions" },
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index eb6bbf1113c7..4cbf1667d7ff 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -267,8 +267,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_R255		0x8180
 #define ENETC_PM0_R511		0x8188
 #define ENETC_PM0_R1023		0x8190
-#define ENETC_PM0_R1518		0x8198
-#define ENETC_PM0_R1519X	0x81A0
+#define ENETC_PM0_R1522		0x8198
+#define ENETC_PM0_R1523X	0x81A0
 #define ENETC_PM0_ROVR		0x81A8
 #define ENETC_PM0_RJBR		0x81B0
 #define ENETC_PM0_RFRG		0x81B8
@@ -287,9 +287,13 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_TBCA		0x8250
 #define ENETC_PM0_TPKT		0x8260
 #define ENETC_PM0_TUND		0x8268
+#define ENETC_PM0_T64		0x8270
 #define ENETC_PM0_T127		0x8278
+#define ENETC_PM0_T255		0x8280
+#define ENETC_PM0_T511		0x8288
 #define ENETC_PM0_T1023		0x8290
-#define ENETC_PM0_T1518		0x8298
+#define ENETC_PM0_T1522		0x8298
+#define ENETC_PM0_T1523X	0x82A0
 #define ENETC_PM0_TCNP		0x82C0
 #define ENETC_PM0_TDFR		0x82D0
 #define ENETC_PM0_TMCOL		0x82D8
-- 
2.25.1

