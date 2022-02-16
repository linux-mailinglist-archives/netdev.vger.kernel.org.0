Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B044B8B77
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 15:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235081AbiBPOdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 09:33:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235071AbiBPOcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 09:32:55 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2068.outbound.protection.outlook.com [40.107.20.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60128ECC4E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 06:32:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIsNH2daRQuA/Uztzq/F4aIeZAbvxDdI7AJy+NzgoZgdwyscPSIhPuVjHQ/gj+m7fclt/xpbzH2X/KattAWD0Ha2NYBkNxsqCvD0L3yTncIJ7AAlWWI+AoqkYTdZxG5onjKI6CpGdWogB0QC6BJNrmEwhyCV0K991ppXrceZT9zquNl1EoiF/Pgr86jv54tnBoaiTRYf9BhqCaRwmoD1kK1/z0EEpYI/hhrFWkrbHjV9ZVILD8EgA0GbJ2zUAv43mUw4qSSFKHyU5LRNacFDAZAo/wC2MGTEsbgko04lS2wzcqT3YQrBql4Jg/GG70CY0HyACYuAxubtJFOz79QNXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLbkCbW6gmKsxZcx2vHRmvWilnsBQVknhDNHnR/AaxA=;
 b=RPAbfr0TUFwDjyiQKTYrXdCMLzYWsrC+57ClO5vuqXLf1W/g98Vbx42ncaXpzu7pkBkImSgDhiU50ok49o+CcKSAHUizcP2SVV/cFi+rlzGjewgcqLMWcby8QKeO6NXBJRtKRoV246DtyC9pQowru2tlUx9e3HQ/snvANAfIje68RW+EeS8VmvOz7y+cP4gbALUXzgp33UH9bBX0yqAlKPVwVtSx9AoHGHjJorrDXA5B9z7d5fnlRqHAK8yxQkcDCkAof0AfDZ2f6bp4kr43w0or3xzNZ/CtS4MjOvtVS1Nd8XxA4X5UmxtAnJhOPgR1PofjtHko4/MvZU5hb7aCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLbkCbW6gmKsxZcx2vHRmvWilnsBQVknhDNHnR/AaxA=;
 b=PAtT8ePYoZNho0LpfaXzK79xUzdfoPkH75l3cdWJjrE3A/qMK5glm+UHPxnUYyxZGg8Gr9592jc1uNNAqCW9cDH+pEmJJGoeVcz+9fB7ryPePZcZwFzAGBimot2qNr0dHGmzz/zc/8EWSs4xi41pbEChHuWcTN+vL/G7HuG23fI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 14:32:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 14:32:39 +0000
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
Subject: [PATCH net-next 03/11] net: mscc: ocelot: delete OCELOT_MRP_CPUQ
Date:   Wed, 16 Feb 2022 16:30:06 +0200
Message-Id: <20220216143014.2603461-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 2de5c517-19e1-43bb-91e8-08d9f1592eb9
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB68151ED47069347741288334E0359@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sgScEYIDiKizPG0C0pFtv2uMP//4Igd8K5vQpyPJvtiewKE9ZiJawuE9MrQ/dQB6N4nYAPBJLDpILK1kiLz9eW8qFUBYNoRUSmIaMaKPoVXSH3vLXfwZGkdvGpHCB0h2fCLuQ4zfxYoEfCuUUYwozyKsV9JzLwEgc0m5spqT3vXG1whexc0QvfYjwNyZL4iusaRb/cxx89LDciwAt2/0VFFQQupNyXIZz2UTb9KHRnqwYIns8Av8cEZ2QpGxbCL611QGzD320P6LN9rbSfcQrewEXFZvKUkHt+j5jeLiFnCFUzX9vWMqI94HfcS83yYhk3cwllRBgikxA+qd7yYHx2OlXOfziVLdEx9KvDKYBc3CbSpSsY3PV1lF7FZzN16Tn5poZFQFD8clUJtS2BBudlN6T76YmjQeUBw2mnkoVKQ5F6bNNT4sx038+VcZOfq5+mPcdK2GZtcxT/zHlYKyiRXfUZE5xvYciYo9TYEHoxIh+3gtGGJsempkpP+31TvoKS+DsT4Cc5uDAUzkVwefAu69toAf69S4L7ThNtBHpU2MYkT50wE2nRgnlhQ/+Ecdjc3WWwTVjxgjE3MxHAkEX0s232eJuNSyiCQH3N/qxUr6JIYB0zFSwSbmQQkZ858e3uKUYAWQgYe10TUBvDlpWs4s3Syh12deVOUGorw+xiXxrNxiNOiMc2bFcvQmjFzkoJXlZexezK5vc92Os0f7HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(8936002)(36756003)(5660300002)(44832011)(26005)(6916009)(7416002)(316002)(83380400001)(2616005)(186003)(6512007)(1076003)(6666004)(52116002)(66946007)(38350700002)(38100700002)(4326008)(2906002)(8676002)(66556008)(66476007)(86362001)(508600001)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?olYgjcXd+sy1ZnMiAcyxZXQYWY3p8aN27usmBM97i1YgZNIiRhxxbUEuqCs1?=
 =?us-ascii?Q?2SmpuQYuUqLhgln4XMVbwiB+sy3Yszn1I5joPYneB0UohpJXIzg0ggeosbta?=
 =?us-ascii?Q?urug7qGG9zl6vtESl2gxzrPt94yunXBh9uQOatf6sR08R3tzV2v7qOkIra9Q?=
 =?us-ascii?Q?PqISiF/Bd9BiW+69JwvNfBMFyoCsW/eI9VZo2eBGwOz4rDII0O+ErtNDsuhj?=
 =?us-ascii?Q?T9+b3d8qoC4jQO/HrIkOdvr/9jv6RFvb06Xe7Yuz1R8xs1lTnxWamasBbYW4?=
 =?us-ascii?Q?GHfI5Jjy7flT+0UY/CBXGkNzQgR/09shRhYFcOOvjqF0vs0udGF3GNqxCBCm?=
 =?us-ascii?Q?fdXndwnOqQa/geg0KefZrrgXQtXCNMS9wcV81YASgCjF5zDPUA3YLPTYK0yD?=
 =?us-ascii?Q?JJE4LSvGx7tSRj21vi5Kd4JhffJl0TazlNRjy5VSemwehlEFnIXDevi1/SrL?=
 =?us-ascii?Q?MM4ovWVrTHaNvDpqiqtw49oxkG7iKf2V4Xv2kHXX1PZ9CticzB8Yal8UU3nQ?=
 =?us-ascii?Q?m7CsjOkq22wYh7YZoNEr+mpLB9u3B99gEUPe17ItVh2/5k3eSs8m8KFi0aen?=
 =?us-ascii?Q?cqAgfNPZiFgmO9lTFYXBbCCVypG4KLAzZijkpOKnFve+CTeGqmoQxvqNI1Kg?=
 =?us-ascii?Q?Yf/s+ispvlHBLFyvwBHYfJwJ7g/mlII/MEN+TC1WPh9V3/8J0iEUghMpUNz2?=
 =?us-ascii?Q?jQ7Gzjn2pNDjp6IYTpTWWfGoKb6K1nFV4ah/G04fF8Lt1UDiHvX0eXZ+S5Vi?=
 =?us-ascii?Q?J4NiA2hSISciZIig9xb29XhDLUU2Oy9yYcn/gKw30pWFmeTaVtCMNPR3o1TJ?=
 =?us-ascii?Q?cRxv/etwnrxNzGVeIAYjPTUkCd/FHjChucDT47dHvhNAvvskR84GsJNrfI/3?=
 =?us-ascii?Q?uj/c+hZ3SbjHidsPF0OG0TeDm2MQfge6Z6EQsjosjH6zexFPhKDWQSZ3+f1k?=
 =?us-ascii?Q?xWO8e1SgK/TYdoX9RAjP84LUXSW5isgJqB5sRlZFH/HKLFghYi4ppn5i/r3R?=
 =?us-ascii?Q?WlMg5CIBngpEvF5Ev1wGGV4ZrlpU0po5UwMgxcvLZY4/VymQr2ofRYSI2KMY?=
 =?us-ascii?Q?Cl/XICR+EXGTHBW26uQztS3Mew90fCqDY8ddqGXq3tQ7hZeqiLu+CARqJRtB?=
 =?us-ascii?Q?pWSb+vgYqapMEAeJ3lz7h0g22daN5EVUU+FnuH6j1y1LCmJiebh8tYIfIRzj?=
 =?us-ascii?Q?hgTKjNP/MdmLQA8qLu9HNLsy0iGB6yktwb1bV1u0rC1oQm1T6fUEdG4uHWcL?=
 =?us-ascii?Q?2SknwCcdAO3k4bT2KjmVW8uXlNN/dyG4dIlsxQTWELrcAEp1dw6e/PmrXGkK?=
 =?us-ascii?Q?6oPptta/uiVNwQ0eRsfRgMIoDJz1HT7XOG0V+aai+I03x1lxqgnyrVsvoRbW?=
 =?us-ascii?Q?5XZSWvhPe5McjZ7mlXcDkJLk3BZqXmt0GKZBmAG6cpqRvTnDwnQ87imcC2a4?=
 =?us-ascii?Q?GIulO8IgQHJ6boOd1NgAuTIA/E01PGW9hnjeYhj93FeDgbWDHQ2f+xC7Wb7Y?=
 =?us-ascii?Q?RYYHuTab8O8kCSEG/nEDWulGn0U/AshGDCadqlt8nUJLBD9FHmYvyuvRqedU?=
 =?us-ascii?Q?Dcawx7b+LG3YX9nFgC54Ohtn501itorLWix8Tm+pHFl1aHtlU9NOQL0IbPSm?=
 =?us-ascii?Q?NpikbtPx609snRDzlqDbyT4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de5c517-19e1-43bb-91e8-08d9f1592eb9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 14:32:38.9807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2c2/Tc6ygOtYWAM22TGRCoZD5qVuqky3aZQKEZydvpvRVGqxnAYYjtB4gbw2E9eT6394KaBm8tzOL975fiQUeA==
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

MRP frames are configured to be trapped to the CPU queue 7, and this
number is reflected in the extraction header. However, the information
isn't used anywhere, so just leave MRP frames to go to CPU queue 0
unless needed otherwise.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_mrp.c | 1 -
 include/soc/mscc/ocelot.h              | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_mrp.c b/drivers/net/ethernet/mscc/ocelot_mrp.c
index d763fb32a56c..dc28736e2eb3 100644
--- a/drivers/net/ethernet/mscc/ocelot_mrp.c
+++ b/drivers/net/ethernet/mscc/ocelot_mrp.c
@@ -102,7 +102,6 @@ static int ocelot_mrp_copy_add_vcap(struct ocelot *ocelot, int port, int prio)
 	filter->action.mask_mode = OCELOT_MASK_MODE_PERMIT_DENY;
 	filter->action.port_mask = 0x0;
 	filter->action.cpu_copy_ena = true;
-	filter->action.cpu_qu_num = OCELOT_MRP_CPUQ;
 
 	err = ocelot_vcap_filter_add(ocelot, filter, NULL);
 	if (err)
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cacb103e4bad..2d7456c0e77d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -105,8 +105,6 @@
 #define REG_RESERVED_ADDR		0xffffffff
 #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
 
-#define OCELOT_MRP_CPUQ			7
-
 enum ocelot_target {
 	ANA = 1,
 	QS,
-- 
2.25.1

