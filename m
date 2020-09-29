Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 873BD27DC02
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgI2W2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:28:46 -0400
Received: from mail-am6eur05on2073.outbound.protection.outlook.com ([40.107.22.73]:50784
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728684AbgI2W2k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:28:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CgTQKnzKV0nWhX/DAlPDVQ9KkoQ9L2knxjKfudOzc/1Gq5vY/4EkhKPrse4GY/xtYzuEt1afB9moUEcS/d5TQricbANt5Bg0Ib2PO/8/FoG7KNmLr197RIoI8/klXWveLdU7SaN/nRlAxr07y4bKF83hnmCBRKAU9MEFLCenjpyXRcNSjD4lh3HUzZvjOVliNLvb0v/JnpYQIG/rfBSusIFUSEKc1vMPwgp0gRphr0GwgueX5YDV6amPCF5Iqqbao00shLzHfDmBa3B2Jqa7uLroIUdZWU86APQmwkBZnSapujdEUuDGgpaNhVGN6m03GtFJUc1Zs06h8nGUlihk/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnZLdEc8VJJo+CWXuXvsARSuN/RgN4Fml2bm+glI1MQ=;
 b=Qk/RmKgheUHujg0np4IibkujLEfrsac6+tGwR3Dt69d4aPbY/s5Yx2hjhVKHqAtgLWHTKZMMkapYPvRXl3neiCYiMfXgmcLDGf2/18aPvvsJKrNKUGoM3lqj2o5+iXlzRshaYNsvgMnQ0CsDGAFcHaIPX/gDFtznKnPIfcRg8mou3F0Dt21OkkIAg9dvj8q1SFkOPhUyf841sLAKFx3h+EuxhUtl4XaaEUHLf4m+D9fBjZcVptvvHWsKfaRf+T1t/bI+5wNlfHTWkwIgGTZCLrpDS8dcwjYUndlVhBCjlGGnDBvEqLxTAT9nDqnlE0gRRYiXil2huABaiS7IQgw91Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bnZLdEc8VJJo+CWXuXvsARSuN/RgN4Fml2bm+glI1MQ=;
 b=iDfE6/xNwHCqPu/Orj4mJ0owZChRUCD8EK73ay+UVeYKB0PcTzEIaE05xowP51mQNWw9ylzl0qHArED9h9ZCAQGu/jbyrv9Lw/liA/6KmRn3qyK5UqhfyeE3E4VsI6eKAewNYG3zZFAQvxQMPQuo6POsdlFOnEyNtqFp66Xs6Ew=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 08/13] net: mscc: ocelot: parse flower action before key
Date:   Wed, 30 Sep 2020 01:27:28 +0300
Message-Id: <20200929222733.770926-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929222733.770926-1-vladimir.oltean@nxp.com>
References: <20200929222733.770926-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 86a085d0-a956-4c40-8921-08d864c6f0fa
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797DA653F8C28C5F017508EE0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y7JWHPPpZWVVyCTWnjiCdUurvpsPpg7dltCxg5fqDB17mPqzBIpgGHiXjwgIxJYLRo4817Q79IryUrzzBSZ78uA4BgCMSHFzF5sGdRrSD5Bq8HuxdX+OjBmvrD5+faacLuJ9YimJPFb7AnTodYPTw5B1Z6ZqsQaSXmON/hm2sk83hpEw4urZTYC+IYjt+/qlBAImJW49u/08+eYomGfe7TAFnY/J3tvBU1GHP5ZD0e+GIJPEZaD+9MLeUjPKuZzCgMMYbp2zbjpYSj7PR0qPTSHzPYpHS3CFfxU84Er75PWSaDyILrkde1kEnsc5q5D16MRUGIITwHg3zu26zM094225sswmcjgvDCmrDf3XNMTn5/U7B01/SaiwFbMNrBRmwh6LOvrOywvr3fNVJORzORnCA5lLHaaiYanpo5nXLJMTs6+L48YDfg2PeoW+WPgr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2YX3MCRUmTjkVyAaG+GiHrVWm9bRd6WFB4iQWEgq1CapN5aCIZ6zjNyO0b0qI4OoHWue4BXC4N9VTuRGhRuDVDVbdJaVOOB1AgosvrgX0bC7SlfqGQRsYcEqtuS2IbVgdzNJdV6cmLG3fcsne7jO8ER7qvwSJhupGa5LlTpRshEMNvki/yC+kMny3HvAt+LRydxzs2aTw0WfaabTGTO2VT7ejSb4odTUa42SF462owedQx0S2hCKUfGiJOsvevk5NBggIf4FyrSIj8ib8Se7DWAjVLCr3QyhEOoxg/NRicZijBoVzCpYLZPndgrRHMqeHUrvEXVn1QbwEaUTlXE719fyV9w/1RQrkzeFW0R3+caK33bz/ZTIC6dwUsQfRxsCP1K5/BO/EYXODCwalXJTy+yC0xAEnpS4ufgSMecmhqH9BtVVAtuftU/5+/564IF4J4O/CPTp68n3GiKwSYmMxoLJxPKZghBHU2XJd3ocmdhieY5beQ1U9sqvpl1ge7TmmOdexC+3RVyZLsJlIGzpPKL5oeqHymJ0qkk/RfPzMzXUE0LRlltdBUXrZgQGsFFoYhNKZzyCyCmQTn265XG49AIMzsQ0Cs8XJ21sh535FFn3Rx5mgQiWIQsY18FimhAUtWl9eaNcQrQi+g/9+pN7XA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a085d0-a956-4c40-8921-08d864c6f0fa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:08.4447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7pnPS2cLi9DDpwWajC59MzxEPWLio5f2uJ4iZ39uF1WOQ3opfUu2oD8ezN+gfdumGjbXA+Xzo7MlmluZTWx7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we'll make the switch to multiple chain offloading, we'll want to
know first what VCAP block the rule is offloaded to. This impacts what
keys are available. Since the VCAP block is determined by what actions
are used, parse the action first.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ec1b6e2572ba..ae51ec76b9b1 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -44,8 +44,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	return 0;
 }
 
-static int ocelot_flower_parse(struct flow_cls_offload *f,
-			       struct ocelot_vcap_filter *filter)
+static int ocelot_flower_parse_key(struct flow_cls_offload *f,
+				   struct ocelot_vcap_filter *filter)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
@@ -179,9 +179,22 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 	}
 	/* else, a filter of type OCELOT_VCAP_KEY_ANY is implicitly added */
 
+	return 0;
+}
+
+static int ocelot_flower_parse(struct flow_cls_offload *f,
+			       struct ocelot_vcap_filter *filter)
+{
+	int ret;
+
 	filter->prio = f->common.prio;
 	filter->id = f->cookie;
-	return ocelot_flower_parse_action(f, filter);
+
+	ret = ocelot_flower_parse_action(f, filter);
+	if (ret)
+		return ret;
+
+	return ocelot_flower_parse_key(f, filter);
 }
 
 static struct ocelot_vcap_filter
-- 
2.25.1

