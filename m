Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAD127C215
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgI2KLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:11:46 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:9902
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727983AbgI2KLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMOJ4StCNXoR4Vh4jNAPnhbMdV5szkRcj9BHPE8xQDnLsrEJtql07w003bQj4Je0sUkFuUDU63KQPLzxnaVMHLkhXwe+3cAuAHah1hgtAdrIe19cUU6rtlxLHjdTgRpSKJlRcRQBRnVpDmaNw+vjO93ha58rJ3MjitIwREgLme7ePq7ZhT3dEPn/9S2LGOWLhlhuUMLnHLa+tpzROSC6Fwe6uzXr8DDf2D/PZGPdhxo4mr6zWxlOHojW7rUAQQ/w4R2O21PM9dNjLjlzMviL0bTPVJxOWn8+3zXfVLlch0n+X3Xt4t73V6eHkqO3Fs+o7EOEoBuJfZnbkhMY6UxDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02BR7ZVaistI8auHdo83lBx8qVKq8Sb5Z3NYj4+YDOg=;
 b=GZlJXXNdjQzORGtOsEvtig+HW6w86NWl4TkqL5o5oZD8N8OxCWCG1Q1Qhe+Yu7kBcygMZGyZKJIgYNoh9oYNrxNQ6w+a5SYaPmC5k1hKAgzlqKTNAwAxthRig6A3qj8MbbYRcDB6Ut9+aJRc+gH42jYPotognHjK8dUZHcqjYqKaWu3Q8HM7Zk9hZO0A2InUNXxu1fIHt55AyLqrcjR9xcac+hwsx1d0Uw3R9QOMwxTdCs6hiXrc4/133EHKtfpZ8P+8DI2DR0+njABWmdO/+IAnIOl9IxoeG41l2RkFFBdr3Z0/DAk7r8jI1xvXBlSJc/7nZnGfSalAJXQqrpmtwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02BR7ZVaistI8auHdo83lBx8qVKq8Sb5Z3NYj4+YDOg=;
 b=UGOE9b5wbhLOBpVaxNOItoe8yL6kvn2xoNM106TNXTd9tdtZCBk0oDxxg70YI6xcJ6dxpo0fM44P12pCKFBJpB50apT09Vx3qvy6+SOEUPssjtp2n3kxa2gL+dSjCAE3luhmeJ3qoMJI9Qr6kCTIPq3UdA8obbuYo3GA6d/YrWI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5295.eurprd04.prod.outlook.com (2603:10a6:803:59::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 10:10:45 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 10:10:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 13/21] net: mscc: ocelot: look up the filters in flower_stats() and flower_destroy()
Date:   Tue, 29 Sep 2020 13:10:08 +0300
Message-Id: <20200929101016.3743530-14-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by VI1PR08CA0112.eurprd08.prod.outlook.com (2603:10a6:800:d4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 10:10:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 29bf182e-3a92-49ed-aa99-08d8645fedeb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5295:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB5295D4103BC099E5D3592E76E0320@VI1PR04MB5295.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBViykk5CSJqeEi3I6r5s2vhgNqpRUA2/K3jT+JzL1T3hF/O/QY34jeqZ7CgW35/4iaHt1rNY0AYyVBuz3IHwx9sTnXq5lCH3d0wnLqED10CIJkjloEJCS4CjZJQSUV+IJsA8aPOtS+2A95gEWX9b2ALghviWZulHrxTqERGPdu/BKU7U7/jhl9GWMeS4Vdt3Yuw3lH9mKK5QSa/o8019CDHV5hGe7+PC1feXmGnoK/eWLXSVAVW5ifb3336O0q/eje3u6Mx9ls1Czfa+S2zw+ehHG17tTVVqgj97PwSWQspI+fnsHAcD0e6cQcsVmQKLfZw/NBPAcFXmKv783YCOepr/7nLC3znYSaJmPXaAOjiXQ1zMi8rmB6F+UP1lQkgwo1P/VUsyhwmQUs9sxVilwQKnjVtCWu5LXwI7p8bZ6HivL9fyeyDBDtmhwAjhfak
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(83380400001)(69590400008)(66946007)(4326008)(8936002)(86362001)(36756003)(1076003)(5660300002)(316002)(6666004)(7416002)(52116002)(2616005)(44832011)(956004)(66556008)(8676002)(6486002)(66476007)(6506007)(478600001)(16526019)(6916009)(186003)(26005)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uRkMoPgBLtJ9CuxLAUfr8C3vtc/GUjRtyVrNwE+HA25ZWpcpa1aQlLTg/s35BXJ11TjY5n6U4//62V7pmn2cteVQxYqWwmAMcqduJ8dk3Lqlgsd34HicLBrPvYAVTNTUhPZbOcWdBbTcC7AE2D3cUEd2f9YvHug/jrw1Gi1Amv1HC0mKuz92sBtJaxPzlfEWig9BYSDVIeWTf+2lrqQmzrsYVMonfeSrfXhWBVbkhgDHYkZxRUHnQixdddNnDzFmdYufUHPeUQ4GQE2UtdwGJ58jtwiQu7d95+pWQNlvdsnHt5J/eiT87p3dCZjwQ+faq5aVMTtN0kn3rU5FMKQ1SSiBssq6G2MbGstOEq8rt/mHwcXNlrZA/Jr4/axGjSULD378UOtT7C3Nd5aXhqJFXYfThymfgwGLCWAILf9VHLIUn3PX62e3ttC2H2IWjmo9498g3V1R3hbWBHLNJzYCFyuy5VbwR5JlQq19u1xcsp0OlBQz/EkE5rwiwcadYdzw+Z6RK8M0IWOlosvza1wQeLMhslrS8SN89Ec6Se/Iyf+UoWKM7uS1Xvcu+SmZJUNJwPBrBRqciJy4VNlNZxFJ+K1fe2pOP/mqoiT9w95+2defm3/RxCrGcANHMXezg3nYCbGjLgVVmtytk15l2V54gA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29bf182e-3a92-49ed-aa99-08d8645fedeb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 10:10:45.0919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wsv/QvAqeDC5kXw8gho5Ri8bCwG4X4pWoBq/tO8OQoDgBd9KRV2dA3x8i3xodQG1N60rUNLFOIpDP2EtOzsmLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5295
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
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot_flower.c | 23 ++++++++++++++---------
 drivers/net/ethernet/mscc/ocelot_vcap.c   |  8 ++++----
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 542c2f3172f6..00b02b76164e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -237,28 +237,33 @@ EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
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

