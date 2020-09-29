Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F0127DC07
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 00:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgI2W3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 18:29:03 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:6339
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728684AbgI2W3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 18:29:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/BAsGyJ/XjkaP4sWhqvKZ8U/KefH8d9UfXETSFtXcTGU6/cyCrco10mM0MLM/XyWllN+tSHgfEhVkjdk5DyY3Jv1RZfiQlVyXSKGwiuFYXKzZPMW9FKbhzcoCsx2fwDg0roZs4vrUHrzbGPzqDCRsFt3bCW9hVIsAzrHb1RoM+H4W2fHvvh7FEzN1BgxDaWNNRbpQjq4rAdRTl6UW3FJ+8QDEvnAa2VoLC2tLdM/+CA+up2TCDw6i4+jqYISTnRWXqXE9SqTmIJmMqwnD+i6BF4gg2w2mSyGMo/9xOzR0dQiBAwgZsVj1zqy0/cLB3KrM9NZ82loo5W73D0DqNsgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUuzxGXFH8XtIj8GhdgWRSoVYle7fUcYr60yOHjnhyM=;
 b=DmTvOzOz3WpTAizLOfgVaJvMkIAEEHLLLETQ3mR81XtKBef0/0VPgY51yx49gn/4SuvfNCkmQSiHB/xbQbJgjiyoAdv7v2DquJ+y4XRTNS1lfODAKMEbhDvC9MLdQCWCof57YUI8Avc1vqNgJRhZ+mZLKPaheIMSLd/wtBOryF3zlrf3xJS6r/+A1Wm5bqtLIcsQykVSCTlCI6cA13+HCTULXiLwH0JQbBeW7PNzd4ha1clqMB3BacaArRsQ1ojcJGLfOsNVzODCl+N9wfQL31Auc211O2rWfCU0HGv2FxKH6JRPAFGxgdd5Rd7kMFNaVFOTVRmwdsqqDgt/MYUaAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUuzxGXFH8XtIj8GhdgWRSoVYle7fUcYr60yOHjnhyM=;
 b=W+uR9vVQrbnVMdzuVOLLMuIK8q6VyzR+3Rm326opus7a2S8PYuNb9wOZdi4frgYgUscJUq96D1gxeryXRm9LfOqPJ+7g2ht2o08leWBjbbOAfjIKL6EVpMIkc50goxNkq8q7YWrGY33HnPPSEeUx0IWG/NwxVAlFlA9tBU0fQ14=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.25; Tue, 29 Sep
 2020 22:28:18 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 22:28:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        horatiu.vultur@microchip.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, netdev@vger.kernel.org, kuba@kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 12/13] net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id function
Date:   Wed, 30 Sep 2020 01:27:32 +0300
Message-Id: <20200929222733.770926-13-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.26.229.171) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Tue, 29 Sep 2020 22:28:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fce795ae-ce01-489a-8c04-08d864c6f505
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2797E2B44EF318582945B04CE0320@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zOQQwuFZPnrBVkqEnDz+DhZcQGlS06W6U2dCesIdmnqIiszzpbTDdQ6cs3s+plkZU71mAMWShedypUxMe8YMjB2B/BLqKD0dD2OGI+AiWq8anJ+akhlSrvLEclE6dQUPi+Q8tuUEM9VfzEjt92VYTla2zb69MsuARoeM9APe6nG9UfE3Kl2VPuNq23S6pRtctGgszvy3/19LRJLKZ5gEKC1LXM/A9KFqODpajQlxAGDCGfCWNxEiAKfvK0dF6FnlhzSm/CrrMNbkc2MAcBQVEo6+CeMnAmeOxHm78SPPbo6EX5LmZVL6ZqqwktjC9xgsIBrMfBz0NG+fLJKOWvWPLO5/ZyQfVwLNUxyfifmPqHiJtCJzQcqGRf6HPaJDrrt6I7uxMIgPdUMsDAxxtN09eFawkSNbUZbEB4+C6TaRSRRdEKoNoqitHcEUbn44R93x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(8936002)(956004)(478600001)(1076003)(66946007)(69590400008)(6916009)(86362001)(66476007)(6486002)(316002)(83380400001)(2616005)(66556008)(6512007)(36756003)(44832011)(16526019)(2906002)(186003)(6666004)(52116002)(26005)(4326008)(6506007)(8676002)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /RE1hC8gl62Fo0eD03RQIxQKlsZyk0pIGnPtQwpWo//8dwr7D+nNWz8qvT3J2tAnivkOQX6QnCPbnF94+2DY7T3Hrr0f77/hvZvCBEt1FLhwXr9K+TXC1oGMVzfAV26aXTJPaTGOTZcRNG3FtoJLQDTJQBRkUQSPGGK/HjD9ceMaul9BwHhxFLXPorp3ceiyI4vdX7kj+I4zhkTRq3u/XKVpE3bkIrWU3RGSakjvn7i/+VxCZKUE/SmwlmV58H5wfPf9f8+ssIJ2N2hAPxEMa8XtX5iq+/9X2qFiPxPIFlVnoYlOm2U9KS1NQ1lzOvb8sjYXAE4MKgvDbB3kkTTfWLY+6Y/RB2XpVGnJlDR3KHKlz4VCU3F3R6wBWgRj7W2gsl/Wf5/+Imz8UtmgLAr5OnPo4m2RBPyXvgKYEjS5q9cvGSjho/T8ebnDF4/d2Fg55lkW6hePnMFbb+jMdpIPyRyXrFsKfUjOMDZtHGv/2+uctwPIb2VlqfQ59C4s7zR8OlzEt27vvPFUZbigEtqJpdYpia7ACIKt7JOQJzuK46Ii4fZYgIxdIsLvOyyp1wIfAlv4XLq2TG97GqhW1iPEn/zn75HWyx3WB2jx71RnwDHBBk4/6lYu+cC4BQGdJjgZAPh4h+nmMKI3UO+1lYrx6Q==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce795ae-ce01-489a-8c04-08d864c6f505
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 22:28:15.2777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNhVUmbmB61+RjpO4bUNoL08RhyzEDhWJBK8MoCbUADrod2dIagVVdJ+dMa2q3c8rAZba8iyZFNbcdPQpmnRUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And rename the existing find to ocelot_vcap_block_find_filter_by_index.
The index is the position in the TCAM, and the id is the flow cookie
given by tc.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes since RFC v2:
None.

Changes since RFC v1:
None.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 26 ++++++++++++++++++-------
 drivers/net/ethernet/mscc/ocelot_vcap.h |  2 ++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 9e1b023f2d00..aa6f6a770199 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -769,8 +769,8 @@ static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 }
 
 static struct ocelot_vcap_filter*
-ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
-			      int index)
+ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
+				       int index)
 {
 	struct ocelot_vcap_filter *tmp;
 	int i = 0;
@@ -784,6 +784,18 @@ ocelot_vcap_block_find_filter(struct ocelot_vcap_block *block,
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
@@ -865,7 +877,7 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	if (ocelot_vcap_is_problematic_mac_etype(filter)) {
 		/* Search for any non-MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_vcap_block_find_filter(block, i);
+			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
 			    ocelot_vcap_is_problematic_non_mac_etype(tmp))
 				return false;
@@ -877,7 +889,7 @@ ocelot_exclusive_mac_etype_filter_rules(struct ocelot *ocelot,
 	} else if (ocelot_vcap_is_problematic_non_mac_etype(filter)) {
 		/* Search for any MAC_ETYPE rules on the port */
 		for (i = 0; i < block->count; i++) {
-			tmp = ocelot_vcap_block_find_filter(block, i);
+			tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 			if (tmp->ingress_port_mask & filter->ingress_port_mask &&
 			    ocelot_vcap_is_problematic_mac_etype(tmp))
 				return false;
@@ -916,7 +928,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	for (i = block->count - 1; i > index; i--) {
 		struct ocelot_vcap_filter *tmp;
 
-		tmp = ocelot_vcap_block_find_filter(block, i);
+		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 		is2_entry_set(ocelot, i, tmp);
 	}
 
@@ -968,7 +980,7 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	for (i = index; i < block->count; i++) {
 		struct ocelot_vcap_filter *tmp;
 
-		tmp = ocelot_vcap_block_find_filter(block, i);
+		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
 		is2_entry_set(ocelot, i, tmp);
 	}
 
@@ -992,7 +1004,7 @@ int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 	vcap_entry_get(ocelot, filter, index);
 
 	/* After we get the result we need to clear the counters */
-	tmp = ocelot_vcap_block_find_filter(block, index);
+	tmp = ocelot_vcap_block_find_filter_by_index(block, index);
 	tmp->stats.pkts = 0;
 	is2_entry_set(ocelot, index, tmp);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index 50742d13c01a..7db6da6e35b9 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -221,6 +221,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
+struct ocelot_vcap_filter *
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id);
 
 void ocelot_detect_vcap_constants(struct ocelot *ocelot);
 int ocelot_vcap_init(struct ocelot *ocelot);
-- 
2.25.1

