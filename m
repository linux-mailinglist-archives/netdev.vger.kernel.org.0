Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A0027C20E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgI2KLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:24 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:43453
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727982AbgI2KLB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtZh5XJmsleIK/6sp0YEgHkIYMjOVhp0o77PIeQqGyr6rCIxegNUU7pqBaUGb8ai5/YsllfpNyY3NU1kHd1mBS2WJeFOOYTX89jg+t5pqNUWjshSrZfVAofr4sacXnFjmV3KvLxOVPggEkaub3o2x+GhFi+KR8+G36+5NA/KPIALgsLlecwfXVk4btABXJlEo6ZH73Lw4McH06/YOkUs9z/lM2g+hMb4qMhDBluabcfdyBKvDefPVQfjlL0/5gTRngtwU5YHx7sGKlv3WTXsiGUnBo9bWdPy84kw2+MVpT97Z78jVcX8KgNC4BkFIterOUsATSb54nhB0j78bKoWaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD0m/WQf8cpcJ+te43pP8z5EOOKl04NxwS73JEcfb0E=;
 b=AS8ntnkbOdUKEObBtKjQomrAZczij9pvYfqszfSJjr/x41/lxx/1WI8TwcQBq7M3hzy8jZWyN++UEqPutJTEl6N4+Jyov22hPrkHh6G54t5PtX189SmO1SsAnWFnbLvpvRvD/r2IilbmY5KHsSeYlFlrLLgaqkI+54Wgtpq6YelrgL57sXLT96ygnNriETs/7ckJkCLDdr6toSyVP4kWVQf2Ei+CmUIBFZ7V6KScoyFbAQjr9C5dEbGp2UY0Xm0a79/NasNOEOxXnE6kpLy0sikPaFoB6B0Tp97dn4aKEhstwb3sgkI0nElrMEI88+b8OYRaBkjrRaasKLl8zrASAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AD0m/WQf8cpcJ+te43pP8z5EOOKl04NxwS73JEcfb0E=;
 b=mnYItksL6P6dqxDRL8t2RHiuwdNV9u4JIVLYWWIQbSNbzyJ5BJPW3Ambo0NrJK/9eWWvYnK5oJbkus+uUjMARybjuNtd7S8ii5T/Hy6uyR2pb1iCsNVg9mASspOnjeTVB0ei0oSF746+8+JDhpLgwIAgLXZpxx+vw2DOErQQfx4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 08/21] net: mscc: ocelot: auto-detect VCAP ES0 and IS1 parameters
Date:   Tue, 29 Sep 2020 13:10:03 +0300
Message-Id: <20200929101016.3743530-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
References: <20200929101016.3743530-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR08CA0112.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::14) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 83bde8c1-83be-46e6-188d-08d8645feb61
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB529543D5F52D1D216EE0CBF6E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pt6tEYqZPepl3DcP5k2a5ZXz6XbMkYECbblnx8ajSN0fJjCagKWt3E3gkjkv4dfdM3O+zSQyrLRwe6QVEu8UNB0ZIR9/B5+ouFR+FnBp/ctWj1Xo11eFABO1KOely7BpNJ4H9OfhmSHHWmbpj1jvXewdKpPrDsLurErEWjRfqcF6gKMiL9Ar+qv7aRfnUtbJHAxkwJIY5K6whk45NUTdOPHWwnOBnG1SwnxenPTspV7X+kxRoRvSHX8IAnvw4hNq4aRz8zOjdRCWUZN6kOoJ3FfJ31MIU9bs0wz/oYeQek3lV0xSpIlDplSkBP5/DPedH11Utjadvrhf9rMMBsWG/itvgDa0P68FrVh1PDLr7Kqto00VdrwE9/Trv3bjCpNybpB0MSGadxmOcw+xEx/EMTexGkBArMxnm9Gjq9f5kE5XoZJUH451Tite1R1Z/36L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(4744005)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: N+HOIxq1RyAcunWJ0GSSHGbchkPnRcLyw70rNsuJcsHHbm3AETnvgdhrLlfcEmInvGoLX4/E3FUykpTKDtUmx1PBXK9Yb9dePDj/A/DwA7/dFIat+o4knSlQ+H4XG7nXNcAidC5h/+pz888tjH7q+EaecDPQO5MPh9Ivd3srQww0vsO7XNJZRq2T4Ryxb4sYGfqIIw2YMYLQGHe+3NBkSeOyX2pZ0JIYj7i66BvHn9lME28XZUl2L5BQOu8DRhRQlI24G5Q6MzYmpysJ03DIVZvxT3tTG7l8VbY88YR8dBSkwQ5z8AiEilKGJAJBWJmSh6Ji2+lpP4CwXw2eZEUUjcgdxvqk35on3NiHaVhyYp4eA9vtjtLddtb1lhhxxbmP1WuJJGP3Kyfs27/7tcUP6o9SE+FqwC//Shx2ed8+gZ3luXph32ZEHjrOl2xDDkTRhAIX9zgS6xRBkiAmTXH2HQIdow8duLWkA4kh03hHUDHbWe1GAU9eRhlIfLPgFlUOwXgPT52zdnRrmGZQWs2w4H2UH6f6R9Om7zuFW0ztw9xVBfOz726EFMHynU8+8Crax+6wmGRePmBPS1wYxOEFTjh56MuEy06mKBEA6yacePhqwHYF3ox6fcLnAH85ZLjqQrrT4J5YEOWbwwQAlyQMnw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83bde8c1-83be-46e6-188d-08d8645feb61
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:40.8773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+Z4qpEsG7Gm9LNGFE3bjm45jtHeq6qJjUAcOMTylyuI8ZXopXDpGKwNUFNKOHkdh9gAWIzQEz0wjv0CBqMHIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 8a9ad0507b99..2eba6b5385d1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1467,6 +1467,8 @@ static void ocelot_detect_features(struct ocelot *ocelot)
 		 "Detected %d bytes of packet buffer and %d frame references\n",
 		 ocelot->packet_buffer_size, ocelot->num_frame_refs);
 
+	ocelot_detect_vcap_constants(ocelot, &ocelot->vcap[VCAP_ES0]);
+	ocelot_detect_vcap_constants(ocelot, &ocelot->vcap[VCAP_IS1]);
 	ocelot_detect_vcap_constants(ocelot, &ocelot->vcap[VCAP_IS2]);
 }
 
-- 
2.25.1

