Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728422786E8
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgIYMTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 08:19:37 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:28384
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728148AbgIYMTg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 08:19:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBvVdRZmETHSvPoqWS1Sdx2mmvq9LQC2jF4ovh7l8VZLm8LrnaOSpszC++SqGZs5lNlmrUKY3d7zEMCCga66KVmi+aoHMfY1qqIBgj3AHJYN1T3F2P5qEqpt/rpLYYmZQRDqIsdMcX8kp22UPXLhh2Iy7la2GH5N9eIT7tjneBjDz9RQyMbFckc/oXODGUALxfZzNbYyk/SdK7NtGx4+Azvs4fKbhqAXY9hUkkhJ0Enx4PGMQFCJbI7KNXGIODUTiDBw9AquaTwfbGWOnILWxnyV1WW1zNzIhHn993ja1VFqnIPxpP1b3F7WXjU1Do+5rFpWPIosQEsxqIFmU/Nofw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a51Ml+fzk4AgCiKf9PRGbQYqpSeyr0CQnigfZifzeGc=;
 b=JIqe4Xzu5rTYkJfLpAXRhayll5UCbk12HVxmvH9APuCfGJM11OMAtMffybICWcEPNdRNhiGL9W1Qau46+6GBbWyI8CWiWJVeanHTX7j0nZh8NEsRP4wsB8SFHjC3Gru/ellmxXWxlinTO5A1Cb+kWy0BPoecBDXXgVOvDkIQbvVP5ObFbOGRmljFV6KmY6BfAScGpeQ0wQJzwh5QJZH8w5e7/2VL36slhtuBLGnqmkQ923TdgIOY75+PVMT7mUo0kLGOhsfgjORhVeu1W6/TyBF8ynwCErWDawEc0GxFv0SaCxTYzK9cKPIRhRakpcFNE9gStXws0HEAbKBRyPUbKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a51Ml+fzk4AgCiKf9PRGbQYqpSeyr0CQnigfZifzeGc=;
 b=MlwdfBCEDoOMVcfBVoSMwMLicwiKIjQ0noIKN8WR39sajyN5dkZIv49gN9SRMeapmSkA+DWSaBU1n/RPfeKkw/LPW0/6VLoVE8KhXkeSljjEYODhaynzi/6oMD20xOmFd8KUozO/dXDdxwOVCk5iyKwu1L3rAWeXuQDtbwNZzUE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3550.eurprd04.prod.outlook.com (2603:10a6:803:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 12:19:25 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 12:19:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH net-next 05/14] net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id function
Date:   Fri, 25 Sep 2020 15:18:46 +0300
Message-Id: <20200925121855.370863-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9af75815-cd41-411a-aa6f-08d8614d3dfd
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3550:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35503A92585C81FAB2F88BAAE0360@VI1PR0402MB3550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u9Rqa4UfOpvg2rdGnAJrr4DMNmsvKHUkL3cHLIdIDNz5oajVCQ4bE8B0TEBJxEQWJ4ASdzZ8YmeYZ/jwzgAJQbdtqTp6gr7TfvCUSeH92Ytvb+pDDupLLvWv/tYVWUB7LQLAm02lcBmw9Pti3w1DfxHLSCZEphtc7tIiue8guxerrMdzBE+LRW1Y233RYbEB6+wTgELjVfKEJjP0kdeoRSORgqfMEto9Yy1FwrXhYjvZ7mTqm0zMvhzSvpitVetNuqvLZndBV4lYxQxkMno3R2jJeXS67UjwUPS1s4Hdp2R9RFp/FE/SATWUTjQEJM52sZ0HqYZTzAa7oLZCiO/WewK/ckcvr8n/uQpmwYzFbe698ULbzQELHez/00bm/yeE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(66946007)(66556008)(36756003)(26005)(4326008)(8676002)(956004)(2616005)(69590400008)(83380400001)(86362001)(66476007)(44832011)(52116002)(6916009)(6666004)(1076003)(6512007)(8936002)(6506007)(186003)(7416002)(5660300002)(6486002)(2906002)(316002)(478600001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zSTFvfgz6lHppK0PDMKoAKu2Inf3puE0YWOgxNU9mBsK+Ldfo5dbPirD9tPNPxNY+LO7dKVzR8rOCOxCME5jnk5U2eJI6MK37g2sqx1FuQLh52ZWaVPMn+AE/4RUGZJEqZpAXKWJXn/pF0BOlSUrc7TQgWr4Um3riCzXSRWvX0HEQJByhqfUhZz1qWRqED2qd0JYT7VSm1aQgSCGBVi53DuW7MZGn+/+EGz/C/ZrW47GsrfGIeBF+zNwKBKyQe6gkSaHeTKayM5Kstx6s1sYKEoJ+y/06pfUQnp4g0uWZOwck9pMwo5uuQKvCDLaXZvGrJBTNGBOLIkSmtts1KzegI44R9qfbaEV25UbCfxSMeD1QhHnT4hG0Hr6gGnNB29MaBT2n1925WM2vZ40Yn7UR3+50DX0v9KAWOnQ/me1avxOWetMAnq+GZmJS28FOBpm/CRCIgR2JAQdctRolayQUtCdtGc4T+BhzPQnm/GdhW1M5RfqPrAh3tzocOpU1p7gmFuOYqCxiC+WQK63gTo/kEaqvrAMFNb3g1QuZO++MCXZ5F0smSOpJONNd0srOqBiL6imFyRDoI9s0gbgQ7IiOtK2Ln58e1nnkto+kUJz3rF6JdxjQr8z2oo+iyY2ed2tP38Dux4q9Xm82LjhDeHbtw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af75815-cd41-411a-aa6f-08d8614d3dfd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 12:19:25.5284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TMeKJrLerCUZrV6qj5UwGuZ24srcYVo4ReI+clgZLVTuR3BqqGnT5Cl9zNOaMN1Nzfu+0Pfq48sLUCRvJ/NYZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3550
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And rename the existing find to ocelot_vcap_block_find_filter_by_index.
The index is the position in the TCAM, and the id is the flow cookie
given by tc.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 26 ++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot_vcap.h |  2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 67fb516e343b..6c43c1de1d54 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -731,8 +731,8 @@ static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 }
 
 static struct ocelot_vcap_filter*
-ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
-			      int index)
+ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
+				       int index)
 {
 	struct ocelot_vcap_filter *tmp;
 	int i = 0;
@@ -746,6 +746,18 @@ ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
 	return NULL;
 }
 
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
+{
+	struct ocelot_vcap_filter *filter;
+
+	list_for_each_entry(filter, &block->rules, list)
+		if (filter->id == id)
+			return filter;
+
+	return NULL;
+}
+
 /* If @on=false, then SNAP, ARP, IP and OAM frames will not match on keys based
  * on destination and source MAC addresses, but only on higher-level protocol
  * information. The only frame types to match on keys containing MAC addresses
@@ -827,7 +839,7 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	if (ocelot_vcap_is_problematic_mac_etype(filter)) {
 		/* Search for any non-MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_vcap_block_find_filter(block, i);
+			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
 			    ocelot_vcap_is_problematic_non_mac_etype(tmp))
 				return false;
@@ -839,7 +851,7 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	} else if (ocelot_vcap_is_problematic_non_mac_etype(filter)) {
 		/* Search for any MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_vcap_block_find_filter(block, i);
+			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
 			    ocelot_vcap_is_problematic_mac_etype(tmp))
 				return false;
@@ -878,7 +890,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	for (i = block->count - 1; i > index; i--) {
 		struct ocelot_vcap_filter *tmp;
 
-		tmp = ocelot_vcap_block_find_filter(block, i);
+		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 		is2_entry_set(ocelot, i, tmp);
 	}
 
@@ -930,7 +942,7 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	for (i = index; i < block->count; i++) {
 		struct ocelot_vcap_filter *tmp;
 
-		tmp = ocelot_vcap_block_find_filter(block, i);
+		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 		is2_entry_set(ocelot, i, tmp);
 	}
 
@@ -954,7 +966,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	vcap_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_vcap_block_find_filter(block, index);
+	tmp = ocelot_vcap_block_find_filter_by_index(block, index);
 	tmp->stats.pkts = 0;
 	is2_entry_set(ocelot, index, tmp);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index b1e77fd874b4..9e301ebb5c4f 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -237,6 +237,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id);
 
 int ocelot_vcap_init(struct ocelot *ocelot);
 
-- 
2.25.1

