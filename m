Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD292786EB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgIYMTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:40 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:28384
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728319AbgIYMTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQXQHJu6Y1ptLkgPxp3Qqz/I/ZnATAIGPmQvleIyv+UHGh03+nijG14y/P+mDnontj84yUt6Pru8xWkVsbfdllG5lEwJUrkWmOBHuvT5Nq4Ia+HGrEmlBW1223SiRPlnpmxs/wWXAf6kuQ3gwWon/BufEtRKxfsiDkS3yWbtEST4bih4PsETOe7XjkygjSJD7ddEqGD4ZBSE+KCrH6qg8mOiolpXwmsL8gXbHU5ICinL7lJzDv+vjaxVO/wxQnhiut1Cd9A1AMSSNkyDZ+U+4VAJdV+AUojaPhqNGB0YpbLRtzJ01YtS9EmKlqfSjNUlPHq1bu/OoBQfXIfFKgN47A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZLKTsyDljLP7bBkqqC+Wz5Oqsr7Za2R2yflrxGkoaQ=;
 b=RzYmYgRtOaahuFa/TvtVjY2hlLlGAxqMx5VKqv9gUicimoV2SVGOa7R5JqjIuaSji1TzaZQt80WmxcmUiBLkZznDwQxUUXJYs3sJVqjV1b+a9BBtkJSBozuAjwI2GJvrlQ+KEYQa8b+8p6+3gDdftDcOVYgWkLOuMMiwoshv+yd/ewPDw0suzC4PJPm4PuWaXg2hvk6Ul0XcDcIkXcaPnuJRR9eX5/8Y9gBB2jm86eFU8GWKWeLJe/19xqhO8B4Hw9VI0fbhusSRBETEt8SVdRDdGy6JER18iqTg1qfe/Xrx+fo6gQgA2dBjpwOdNH5L9xYO/KYEotASyV8LY6UoMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZLKTsyDljLP7bBkqqC+Wz5Oqsr7Za2R2yflrxGkoaQ=;
 b=GGv+P8SK1y0wn+NgsGOCsIRFd7ajA1CQvaJYKgOwbRGf8rpkC71LxWv1Tzqb99E+1+KMEViAvaDoBaVp4U3WozSsgckGma6+s5Lrrr8jJ2NHIbNsYtJAzTz9bLHOsGwhvwxSkoUu9MY6VgDQAJtf1rfCXrpVu0cgYLHYeyYdHTo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 06/14] net: mscc: ocelot: look up the filters in flower_stats() and flower_destroy()
Date:   Fri, 25 Sep 2020 15:18:47 +0300
Message-Id: <20200925121855.370863-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925121855.370863-1-vladimir.oltean@nxp.com>
References: <20200925121855.370863-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0007.eurprd08.prod.outlook.com
 (2603:10a6:803:104::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VE1PR08CA0007.eurprd08.prod.outlook.com (2603:10a6:803:104::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 12:19:25 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9cfa627d-2d2d-4313-7743-08d8614d3e6b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3550D9C1EE3A6E7772FF109BE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BUOUl8ttJ4bP8CSo4UhSQrnJuz7UJ9Bp41Wr0FLkUeiVCtt9bS/SocGzdGMaAVWVVENTvHmsa2QwxPtq6r/yPjwbS2b8D1s55IJfBhNVvq9/jq5RMjDWHWJXE7kftOaS0SqI5oPxexqSOPw4qORgZGf6N3MDdi2kD+cX8hMN8La38psUxIfjlLp9MkIqrmoNDQhbbMYBaWRVGZ7a34/AMMpL/MxaM+Z4Zw5lc9EbB+2P0Cxip4mHLWrR/cKDuQoe4cNMA4uoytALWLXyA+WpNTe7F271DQ7FuEvtLgQPCXLMQPyQVlqhwnrBf/E3YWvFv4myPp/BJ0X15ElLTN0NEKkmz2tHUhrwQLqiFwycZg8R/5hof0JvzyfQSaA1FcEp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Q7ZL+edIjesJSJzzfsBBmGFnIf2wbnwKlPhURaVBUGND/k9/5DtmND3h5rMcSR+BGRRi+9r/JGU9n9EgJZXR0ZMvHQRxVCfY8fEGIncSd21/TrLF+osJ2iIAFxTQgTnFcLVDXO5/9I2zhWo29IiJquvy5nUbSXCJwDWT9cPOx0FGnuTO0Sh0yxfyHxJkbb6C9q7DGtG9q0FMqJ7zR7YjyGS+3vUlvE8kvFDqqyFY+sXlHgvm3KZkvlRo8P/KaUFBTBag6yPk7UaX08epPVLcF49g4RQB8GOer9EZbVXaQjAVXQ+/KPn1nxkEcYqA1iyzCjF3F+8+MltPN9BZbuUkjb8872H9fJRiH8JZmvnlWxtK63ieodDdfsnSLHsPv5XFWvN+TbDJK1ZTKlIkvQc5+jU3npQEUDqq9a2ssF9U+bbZoNiMiygnZCzWfr/h3WKqHtgPbgU/OcYfeQqbo3Zynpf/f8TGG+LdLG6K3Pa/LdXe3H2mNm1p8SHpDf92AIHavVGSxwnrn6OZdzv9KInql8/FxAkj0MHlQzm37fVc2GP38PN58uRBue2UJkcxX6G+R1vnul6DtQwj4PRm3Wnx5TNr6CrDPmWnNi7L7Q1olMUB6+LFJ4IaZeuuBOhtQu447SP+gd8cRnYcHC7tGlS7vQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cfa627d-2d2d-4313-7743-08d8614d3e6b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:26.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHKVYJUPVJS+sEHpol9HUu5HkQInteWsPkSiAj0LuBFhnEjZx66ziJ5my8xVtrivS26Sxnszo/jZzPR3+FfjmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a new filter is created, containing just enough correct
information to be able to call ocelot_vcap_block_find_filter_by_index()
on it.

This will be limiting us in the future, when we'll have more metadata
associated with a filter, which will matter in the stats() and destroy()
callbacks, and which we can't make up on the spot. For example, we'll
start "offloading" some dummy tc filter entries for the TCAM skeleton,
but we won't actually be adding them to the hardware, or to block->rules.
So, it makes sense to avoid deleting those rules too. That's the kind of
thing which is difficult to determine unless we look up the real filter.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_flower.c | 23 ++++++++++++++---------
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  8 ++++----
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ffd66966b0b7..9910fcafcabc 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -222,28 +222,33 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_vcap_filter filter;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter *filter;
 
-	filter.prio = f->common.prio;
-	filter.id = f->cookie;
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	if (!filter)
+		return 0;
 
-	return ocelot_vcap_filter_del(ocelot, &filter);
+	return ocelot_vcap_filter_del(ocelot, filter);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
 int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress)
 {
-	struct ocelot_vcap_filter filter;
+	struct ocelot_vcap_block *block = &ocelot->block;
+	struct ocelot_vcap_filter *filter;
 	int ret;
 
-	filter.prio = f->common.prio;
-	filter.id = f->cookie;
-	ret = ocelot_vcap_filter_stats_update(ocelot, &filter);
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	if (!filter)
+		return 0;
+
+	ret = ocelot_vcap_filter_stats_update(ocelot, filter);
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, filter.stats.pkts, 0, 0x0,
+	flow_stats_update(&f->stats, 0x0, filter->stats.pkts, 0, 0x0,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 6c43c1de1d54..8bb03aa57811 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -956,7 +956,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *filter)
 {
 	struct ocelot_vcap_block *block = &ocelot->block;
-	struct ocelot_vcap_filter *tmp;
+	struct ocelot_vcap_filter tmp;
 	int index;
 
 	index = ocelot_vcap_block_get_filter_index(block, filter);
@@ -966,9 +966,9 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	vcap_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_vcap_block_find_filter_by_index(block, index);
-	tmp->stats.pkts = 0;
-	is2_entry_set(ocelot, index, tmp);
+	tmp = *filter;
+	tmp.stats.pkts = 0;
+	is2_entry_set(ocelot, index, &tmp);
 
 	return 0;
 }
-- 
2.25.1

