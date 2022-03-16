Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2514DB99D
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358014AbiCPUnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358003AbiCPUnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:43:15 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30072.outbound.protection.outlook.com [40.107.3.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74586E4F7
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW+fGCoXDifgZgjaQJd8f/qP8hM0SuM23kz5ifEZNNs6iJe8q/M1+JbXQ+KFFXCqEulpxzQcG9ZctgfMn2Lpxt40FcjuasjRYogl68SVlqQ8ivhZ02MAZK/mUwsT22yQbIvYDmYkNJdZCKo+S4apJQD8u/1fMP9CcKR1QdzWkBMTM3oTNTGI0YQkp52byKNSlV2UKYvT5+dvx7f4mXO0Eeesw+cYyuzoEAWR+hsx7gnlizqLI/pL6K/zfNHd08c611hnb9ag+sOeyoc+0H6l8Fu3aQR+5U+GgWho57katkstZ0HBxQ/He9ov+NZBRNP/MmPGN/bUiDfiA3xWvi0z0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0LRXOLk0xFXjevUMFgZEThdvIF4AMUKQveREGmHaft4=;
 b=I1dEapPAQYxIoBynvpCBw9S5Ft3g/6cOf3qEB5HDabntMQiDWj4pnGzxk+pla+aZTrJ3atkggjuGOxCKdOM6Uk3VLQMNsKSx8pJ7b/oL9WfpQBjdRFQirXZF3NmjZPs4Xf04F2ikM8yM3uHZTgTFACWMXukrg/g3Je+C/UxmHQlPYEic1/EuqpGPo57i4kh7mdrZMAGLEKP43nQ3u7vDXj1U3oS7VFRHsYHDctqvJD0k1KtWTYrEFT5CF0dc7NWR60gSHTJMZQJUHQTiKi7MP3pGZy+R14ERBB8oQce3D2iXXpiQFt7rGHdg9iSQO4YCucKveBmh+MDwSoEK1yYG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0LRXOLk0xFXjevUMFgZEThdvIF4AMUKQveREGmHaft4=;
 b=DT5AeQKXKIWgcYZKHM8CHsI0y63sZ2ywzBOUlu+SkyS4AVZlZmOINrTBUVQe2Hnz0vKuRh0eIJEzbKkse2zidA84xubV1FqOf6gxRPCc5kNAFapzh/09sgl5EnZuLVmyFcFQuallJK38dQoNdNLfA9VJOkQD22i7cfO89PAC8YQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8398.eurprd04.prod.outlook.com (2603:10a6:20b:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 20:41:56 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5cd3:29be:d82d:b08f%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 20:41:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/6] net: mscc: ocelot: establish functions for handling VCAP aux resources
Date:   Wed, 16 Mar 2022 22:41:41 +0200
Message-Id: <20220316204144.2679277-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
References: <20220316204144.2679277-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0037.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::25) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99045e8b-80f8-402e-20fb-08da078d6939
X-MS-TrafficTypeDiagnostic: AM9PR04MB8398:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB83980F5A44EE4FC5826E737FE0119@AM9PR04MB8398.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BF/YcqLJ0derPLAKsVdHRlF5X4sTmrdcHTzYOOgoTue32Ea/p2x0JWFqGL3t+45bmCmG0zElq7t/SBZBVTuCLNaqKzW340Bv6KsF3UR8Nhu8DaB1V80wzhkiozx/2pbqerzlZVsUSV019KqQM8/kwrs0NNhyEQW7PbrQ1K+KJ7AMAjSlikQ3ON38w96fe88rdc40i1jdc8AHDDsD/co1qTHETWV4eHYp6LZr/K8uwqOEFqzKUL4QsAOkrwedmRfuZxnU+MZUysN2kaIjPJ0SfGUZHiWVK25WkzY40oIaJ0iu7LSGtUjt1t4SEtaKo/nbRcRRwj4Fm8hgSXWCb21/2Evoyn4wVfX1lr2ZLtK1azOYR/wm8LZKhycMQP6+lW6v6RtmCx62gTOkoOsz86Rvt0PwK/H3IzJ907XT+etK+BOhyaTxGd3n+TVBtR7rEMQN9OBoHjM+audieKOP7AKIhTsbzUt1TKLnfMoZIJCJZBRagRpT5PzwzGur+4GNW5oJNcizgvoNAcoLIdshtX4HE3VgiM8T0oRhth9nRl+VeOvUpEGsMKID0RIAqG/GISlje98hlVaMyOrpNu2AGMHlt87wqDEIPQ3QXlzds+gz3da14J9wMWqzBCqIFY/ReEm95bs3pmzbSjydR8w7K8o61V0oEK/w1Zv6dcZ8As5TS/OBtKZ2ZjTPQNgtNxbIfiEXH/NaGiuNG8Z6ysa4kOHr0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(2906002)(6916009)(54906003)(4326008)(6666004)(8676002)(26005)(186003)(86362001)(316002)(44832011)(36756003)(6486002)(38350700002)(66556008)(5660300002)(83380400001)(66946007)(66476007)(2616005)(6512007)(1076003)(508600001)(52116002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HyU1D7RKjJibWVhChIZb3a5oNAuMYI1F1Sw9KOAmSx9H5pPoIVDBsXCGXCh7?=
 =?us-ascii?Q?OPgFZVkBg+FZFpwEd64BHN/hjfAAKJ+OggUL0GUP8IoZ+UMzQ32Ut9pRFJuB?=
 =?us-ascii?Q?XbGTPzF/X6qoNsR6WEYN6x6KZKFvxoDbx2EFRpXUQbJwRewbJyM3jgL97P0A?=
 =?us-ascii?Q?PywflsQT+N57a/2XqkPmP3KzNau2tM4hf75uTGPoK4BIh6x4QSm0EeaG/A5H?=
 =?us-ascii?Q?g5kt1OFvgafZMWFJ9i8nBa9Ddon3p8OhkkUqSasRHVCBDNWFQNtevS6BW2ug?=
 =?us-ascii?Q?/0oSIdY7pD+RPp7fX/YmzKza2teYmzF2sxHCeTdmmx69eKA/e6rv18+hGcSL?=
 =?us-ascii?Q?P6X99DyZLdkBzo5axR8g/iZtYEUCgP8YwIdZH8i+Ucp25ZweMmRDECK7+Vyd?=
 =?us-ascii?Q?fq7OTxb0hQXUvtZQhxf70nd1nMSQuWeaLPPtI5R33ixbupcQx8OAZGwjlRR0?=
 =?us-ascii?Q?G9eHxxOSslgZsjToRg32gNEDYjZOEdycyOFjVEzOriYGRqaje+vjHtFtX8gG?=
 =?us-ascii?Q?/fKFJw6VYSgdmA1nuS2EIvPT42DA1rX+3QVJmHh1FFY5OUQH4xtCAQ2bXi/m?=
 =?us-ascii?Q?1Z302rGT+9tVyWWn9+hS/mnw2zPeJ3qhETuqWfykUSOnTC6w8GkZA/rhIeoc?=
 =?us-ascii?Q?RTPKQQpfqzhJ95RsmpiYNohyV04b+XeTrT077qciZq1TA8XbgXf0KNFUMHhF?=
 =?us-ascii?Q?bLTHuNugde96WFR7w6lsWK/J295w0Nsp7FyDYHu/BO7d6tvGGj8oGYXnty9o?=
 =?us-ascii?Q?8DqWmm0Jf61jyY6Z3FxPVHFXTibh7gKlzzqFXvU0MVelCm+hrb7TVGYoQq/x?=
 =?us-ascii?Q?Uo+iF7t8ziNmPIIPZhXFZa41bt8ue+ExqQWwlzaAmPxEYSgLloXcwqU3IS4u?=
 =?us-ascii?Q?QLBcWwIVhHE/offB+p/E5f7hxPg/hvj1saQsyQpaXCCgUo/jJiu69dkLqtAe?=
 =?us-ascii?Q?0Z+LWYGjmw1aziv9uWkqJhPGNYZcFgxL0UlVyjH+LXKbYcTqR629LvXQYm2i?=
 =?us-ascii?Q?DeW1YJRaali8bvnzmKYY2oNbiDfoGfJ6V+cTURYqoQzYxiZ63rIIt+HUx4dN?=
 =?us-ascii?Q?z/FJf+4gzFa4LLRkHYqrGBBqYSI5DuT7meCkIG5sr0KoSUFh4U9udRNuaxLL?=
 =?us-ascii?Q?aXiwFCuV+ZlTsmGd73eLPCMEQBXt9JiIjNmbNt2QXFcmdAYD/MWT5eCuVfee?=
 =?us-ascii?Q?ZREmzxRTb/wSsQmX7b9E3+uqN/38Rns+Fnp6d0zTpNLewwxBfs48+/YZHtqG?=
 =?us-ascii?Q?y+motbaglqfJJLbbVQpib7vXKnxQbQCGl5w89KaIFrsKdmyjXV5owPYpOEuL?=
 =?us-ascii?Q?U/RDGQ8FQcfComcjCJx0jCnr1fMcJVJbF2w4pPX1Sw+la6uPFhxB+IAKmkze?=
 =?us-ascii?Q?SRN2tel2q85J2cz1FsepPVPQQHPKFKCGhF9B7b3jMTZkZXX7NiF0f9+Y08/o?=
 =?us-ascii?Q?dqfwkuo2V+3iJMwLdNJJGffpB0q4JmU2ocb6YCSK4+iJujkzMB3zcg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99045e8b-80f8-402e-20fb-08da078d6939
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 20:41:56.5043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3plLPoQHec8PF2/Xpal5JBuLBBc2ADapHHQc292PBOEK/hToidxGJACnrEfMcyAfG14TSwcTy6pxM41SVQY4dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8398
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some VCAP filters utilize resources which are global to the switch, like
for example VCAP IS2 policers take an index into a global policer pool.

In commit c9a7fe1238e5 ("net: mscc: ocelot: add action of police on
vcap_is2"), Xiaoliang expressed this by hooking into the low-level
ocelot_vcap_filter_add_to_block() and ocelot_vcap_block_remove_filter()
functions, and allocating/freeing the policers from there.

Evaluating the code, there probably isn't a better place, but we'll need
to do something similar for the mirror ports, and the code will start to
look even more hacked up than it is right now.

Create two ocelot_vcap_filter_{add,del}_aux_resources() functions to
contain the madness, and pollute less the body of other functions such
as ocelot_vcap_filter_add_to_block().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 41 ++++++++++++++++++-------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index b976d480aeb3..829fb55ea9dc 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -955,12 +955,11 @@ int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix)
 }
 EXPORT_SYMBOL(ocelot_vcap_policer_del);
 
-static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
-					   struct ocelot_vcap_block *block,
-					   struct ocelot_vcap_filter *filter)
+static int
+ocelot_vcap_filter_add_aux_resources(struct ocelot *ocelot,
+				     struct ocelot_vcap_filter *filter,
+				     struct netlink_ext_ack *extack)
 {
-	struct ocelot_vcap_filter *tmp;
-	struct list_head *pos, *n;
 	int ret;
 
 	if (filter->block_id == VCAP_IS2 && filter->action.police_ena) {
@@ -970,6 +969,30 @@ static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 			return ret;
 	}
 
+	return 0;
+}
+
+static void
+ocelot_vcap_filter_del_aux_resources(struct ocelot *ocelot,
+				     struct ocelot_vcap_filter *filter)
+{
+	if (filter->block_id == VCAP_IS2 && filter->action.police_ena)
+		ocelot_vcap_policer_del(ocelot, filter->action.pol_ix);
+}
+
+static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
+					   struct ocelot_vcap_block *block,
+					   struct ocelot_vcap_filter *filter,
+					   struct netlink_ext_ack *extack)
+{
+	struct ocelot_vcap_filter *tmp;
+	struct list_head *pos, *n;
+	int ret;
+
+	ret = ocelot_vcap_filter_add_aux_resources(ocelot, filter, extack);
+	if (ret)
+		return ret;
+
 	block->count++;
 
 	if (list_empty(&block->rules)) {
@@ -1168,7 +1191,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	}
 
 	/* Add filter to the linked list */
-	ret = ocelot_vcap_filter_add_to_block(ocelot, block, filter);
+	ret = ocelot_vcap_filter_add_to_block(ocelot, block, filter, extack);
 	if (ret)
 		return ret;
 
@@ -1199,11 +1222,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 
 	list_for_each_entry_safe(tmp, n, &block->rules, list) {
 		if (ocelot_vcap_filter_equal(filter, tmp)) {
-			if (tmp->block_id == VCAP_IS2 &&
-			    tmp->action.police_ena)
-				ocelot_vcap_policer_del(ocelot,
-							tmp->action.pol_ix);
-
+			ocelot_vcap_filter_del_aux_resources(ocelot, tmp);
 			list_del(&tmp->list);
 			kfree(tmp);
 		}
-- 
2.25.1

