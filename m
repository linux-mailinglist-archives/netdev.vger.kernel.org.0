Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE5227C210
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbgI2KLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:33 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727663AbgI2KLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeGqCwy2ZRN4UA1TeV67x/+fsmk3xmBYk22Df1wdi9eenf/f0JaU/rTOk1iO6+JonGAbMDIOOaCxGq1gtZy0GxSsUdpGEqEpvoEYSvTDfmXPqZSg4Mk6Rmd5uzkz93TZZV9madzkVHu0x+lbtmtl58T/AjZT15F1k/VbHQCt6mtzVmtPSg1QuAes3EbISgsejGo/Jg9B2JRa1Ugcvb5gm+Q3ypaOoPqS1RMbOrL/3sJLHZyzI50XZCTg0awtQG0X2WtJ0QbVDVsTLpLBTqE9BIoCUTLcygL+KGBVY7E8qYF8LBiV/ZJpVb2grsoep/+1W4SPj20HTz6I7BJz9kB/pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAQHaH6jP9W7cr4/TTUuL14HM01Tm3F3AjKfFqLadEo=;
 b=J4IX1Q5aL6wSBSbUuJwgwiaNoHjf4prld0yARhGzv/0HSzeYCcDO+XKBuTryaRig/MuU0/H1NP4oAazfVStSAwrwv3K3qmwgwuminV0+G8xHX9Zi3qoIn/L7eZu1JSBBORlGi0bnWsmYBDK0yuSeJq+8DiBYHppmt8zfnML0Br4SZ4/H3zUgsH/LnnukfnCi4ACl0xBuqlBloDoD4IRN8T9qPXbD+TLEUeoA0r4VOJy3jYztpP4Bnu8rCX2FSXa7R2BSQP1t2wvBwjL4GqRBmlfAIL+9l39l47zYL2mUYjiWDTDS65nFmcoDkR0PHdJowlR0rWVgjw/IZiD78Kqneg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAQHaH6jP9W7cr4/TTUuL14HM01Tm3F3AjKfFqLadEo=;
 b=fekXlHapHPXLXa6hauVQQGOdkEzCLEOlLVZkmiwW8SVKI8TDJ5WbtarjT2WmhqUukBY4qt4DfdVxqno0ka2ROSon6IjKnmZU1+xFqcq/C/DHPKnzsRUXWWwUk9buPpxOa44Ih5gUUEzSvaNlPStRxVJW+036Ijsa9LNowjGodEk=
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
Subject: [RFC PATCH v2 net-next 09/21] net: mscc: ocelot: parse flower action before key
Date:   Tue, 29 Sep 2020 13:10:04 +0300
Message-Id: <20200929101016.3743530-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d40b3032-0000-44ce-ed4c-08d8645febdc
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295520B7F77B90A07C00E63E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KfpzatBbgInnaIR6oo0uH++p4TdFPnFUovwS08f8ifg/uvTdLeFy6rxIMLMK3forkCRK74T4vpdUR9DiC3vhouNSecvpyn/cvgDiEK8zrSQManP520vNftsb06yjG++HVk7vnOOOkObiHWQ9SUCrSUzdrkJos08OKPFYbDUQ3Sjqh/Ct3v6fHgcF4WC45eok2JesYKMGLWwEnI0POpyysHDep7tkXhHvZJl+nWUa4SIRTgkXFbYYNVxJNDE/Zw7vnSxCGbv6NnClLFo2xvFt0iVD9kQzumbvwaJ46BTWC1GD+v8a9SnNGGYHLRs/0iI9ZN3QCO2ib9Jtslb7hvWq6+fyu01x+zpj7FkTn0EBzGKv9pd4lAGS8646QDkR9RRb/xYxmmglMxUEVSohGRVzI/w1ntMzoqlWtdEYRwpIsSRo4jTtplx7meIBbxMAZ/NP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: So4Rbis+m5auBddhjDGitrrNAG1ltW03Xw5E7C9bamT1v017b+dFoYyqS+YEI7O/KDwoOz9GDyMIG9VqTmEQFnQoyQeZ8G9bJWXKmepox1NFa5iZd8WY9J/IYsJu09OUrYoI59dK2T4EglKWaAcoEWjyv16RH6jRW38GbJmQLAjjwqc3ezlrE+KzWIGtVUgvFiUPDvVX6oP9eKcStG2EA2HVIVdkRx7kJg+RkGFnzAiqJ+y2J9o5lLTKHwXbas+rIEYBBaMEHb/2Ak8EYKvv1jVEd3COsfwILOaN+3TUbWuL0ba/e/ckoXr5Twwcw+377ypIBLpb5JC4d98WhexYIL7hB/PwBFoYHMw8dKU1D+IS5LKgM3vwLVL6q3Ur1o4zyPegrip1ZNtwkJ8iCouNH4ZCs74hSpQnk8gVoru39nzGqn21kJ4EHEOwXIAPotNiTh8fp1+DtIQK2tJ5ZDp8BMczrmV7Yv7eMku/tclEUF5EAyEtDKlHOjxZN8gudx4iuyWpTA98tXreBy73JtLCK2DBsSEjIHLccZFixnYQqzp3jUlD9pgjPu9LOGb1AhUMF1NJAfRWvtRhGYV4Zlpe+gqI0eKQPnG8CcAMrhNlcg3QjCc9KbNB6TRaUYHNRpqGgmtGYJ23Gs+F84HggGPv2A==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40b3032-0000-44ce-ed4c-08d8645febdc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:41.7398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNrHc6fBWlXMK/3lGi9aQvbhuoW7ll9UreeafngDfYnQPJTmA1QtymSXEDwGNcL4iqj1dEKVWpFRngaISGArTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we'll make the switch to multiple chain offloading, we'll want to
know first what VCAP block the rule is offloaded to. This impacts what
keys are available. Since the VCAP block is determined by what actions
are used, parse the action first.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

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

