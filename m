Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5F152FFA7
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 23:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346795AbiEUVib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 17:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346786AbiEUViS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 17:38:18 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2066.outbound.protection.outlook.com [40.107.22.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B92F532FF
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:38:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofTL1UEGYglmmejpYwQ0PrPBQidzw6W9ur5+NjWb2Sv2gnmFmJrpiXx6Z0Ul382r/FmV8Yiy9k6+iDgTQY7AsmfSqO3hwoj1WRrRkk5/DcR4OyLOMB6gZNhEwHGaaK3in1TFZE+CX+nvfyFP8fKPMd0JQv8c3ONzBFjb5c/j2uj0nRlubAgH+QYdBhV+wjDb9Mhv0p3or3vA79Vk4u+fuxvkkFuteUtKhATU0TanERWXDckovanldIUUQfCpZVX+Z5MiRxPsENvnesODuLck2VRc+uH1Yra391dULZ8rvvxZ4deLDSHiHQQRrqBUuNIPrYKU24oOcW/sf9xhQa/dEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDlTloIpa6EUEbpw7Qwl3qE9gxi/h/Gezie1iv6Yg3Y=;
 b=EUrOKBhBrpZmflI2azH+zz2GyRUQOJF4m1BOxBLsGE+SRfVoPzhvol31FGBC+nsJ2x35b3lTUj918Vt0Ec9NcD1jIZbWpj8YPgnTqZpDocSCq+SJSXlQF6lSqpSrmLHBVXpD6ZIIsEqm0yXgBv+N3Ju77l2IyH9+Ha2TxR8elMve473YyJgvyQxxPgFXh4NIGlVSZKg/xdBIRvFmDAlScBulhCJH/somUbQO6o0GDA/ZOp7Hnnkg3gVMDpqYnxEhivU6a/bJUlSkLGWDXd/JSmm9kRnQnMrzr8G1Y/JgmKFeKS8hS1rk8wjYLDL9P3X5x9OQ8k4AsmsO9bletv4q1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UDlTloIpa6EUEbpw7Qwl3qE9gxi/h/Gezie1iv6Yg3Y=;
 b=KYroqAsKQifI4MNKt30Fq24WF7INraA5m91AhnvaXkhJsDUh2iJk8PynQYdyqLeJ6m+K5Lfk73zUx7PYpKGL4ReTKd2JJZqYkylH6oEu0GIL+lvlHw0ZTxRbPayILCn73xCohZaGbN9mDyLuLN78lMtl1t9ZmeTW04G6Zrc5Uu8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6275.eurprd04.prod.outlook.com (2603:10a6:208:147::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 21:38:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 21 May 2022
 21:38:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 6/6] net: dsa: felix: tag_8021q preparation for multiple CPU ports
Date:   Sun, 22 May 2022 00:37:43 +0300
Message-Id: <20220521213743.2735445-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0079.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1591f129-f24c-4d7f-e35c-08da3b72311f
X-MS-TrafficTypeDiagnostic: AM0PR04MB6275:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6275F4810AAC46AD8F03BA3EE0D29@AM0PR04MB6275.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+KHZmtnP3EOBg/dn+12/5pVsTcsB/oIdiiW6t4TVtL6njTcR81s8OFZEmbwpx9+/Y/BuoRO12be89ETqqHkDTAKMrJVbgZKlqHv798SNp25CcYFJcaDxb0nCNrsHwYTg1idtsXmAhe5dDzXRKo6RBYos6ofkBdd8bSQtCYSvZdgx/Zxu8rA3MUD5Zx/NFeo4rsO/sHy0GwbzAdfFislvCLSfr5iPGM7wAm3tVRgHUzC/oGLY0l9YJxiSP91ARIDVpDsQdHWC+11NjimBJ7wtCVuGRWy7IKv7CsOBEg9lJ9SU8a7RvK9WlYEiAL7fE1BIQVU50G32Q5doTuYkmsOB8VEy9mUrE3yAKfHhThSd6ldZ76MQX7ERHtibUy4zqgyScs27umJV+nJZbNQkY2MokLjYdUo5zw3qsmh8mgstCIOSK/9opaCrMBNNmlznysuQEfqsniHvsfDYY1Ou4iewJ/NZwovFF+NqLtnpvpAnSdBVFmWUHsI6SBaQNmsUJpuDdZ+6EnvS/WmjVYh50tE4YcvpQjGu6aMDSbfiNfJgzNZVUWRiOwgOPqPL9Kg+95/J24tbsxOQWnx+/cqe74Qvw1/Xi2ZTBVi1NTJ/pRWt0itWMrtZixYWd7WE1Y1LmBWExlfKPfF6XkR4BmRf3vJRQSy7UKAROvNBuTpdLmDlWYmz5smu02R6tvHy2agTasLIjM+0MV6mlsj1HqY4xgQrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(86362001)(26005)(6512007)(6506007)(52116002)(36756003)(2906002)(6486002)(8676002)(66946007)(4326008)(66476007)(66556008)(54906003)(44832011)(83380400001)(7416002)(2616005)(186003)(508600001)(38350700002)(8936002)(38100700002)(5660300002)(316002)(6916009)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a8xurdgpP5Q5J6ruLlPVDjYR42RHqhpinhPV/lQAv5U1S38dOPsE1MWHt9I0?=
 =?us-ascii?Q?jejCJ9idQ62AvQr8bL+zKIWET8ZPaMoZIcMBg8QNHTFTQXGFgMuHNE0A1A5p?=
 =?us-ascii?Q?2L7uR4Hs1fXO+fLljAamMqS/7+Nf18GCewtv8nD6nl41L4xdHX16B5X81P7J?=
 =?us-ascii?Q?lvG9TMN3zAG5+Rme4l6eCaJ4Fw8OEbSMdA9tJ+VoGMlsUzBK1bpmZ8vrI6dJ?=
 =?us-ascii?Q?FyAmjvxdpbCQlSIl0ENRIfuLJyETeR3bKCYSdZCXi0FjC7W/EyEQ6vfWNUxM?=
 =?us-ascii?Q?misLJNnLTZHUyf47eirsMBSdUMfPBXEe6AYPmWPamKnbWxrXviZHTNY9aLOR?=
 =?us-ascii?Q?uZV4rswH4PFJ4ZwJna8qDD9mIHZxNQ/dzJZQz8TR9lFGzXUEJOOaFS1+3T+p?=
 =?us-ascii?Q?QWV13em+BKtYfIStp7KL8WS2WOFiF5YpwGnhdZHdTW79XmaeiyM/ThJbH1/2?=
 =?us-ascii?Q?BB2DFRbx38aEnjZ8n2e1iaJtp7E7pf8Pk8VAyiU6UPBnEpFOWXYK+STlMlVY?=
 =?us-ascii?Q?kXgBDiMfEgZWMc/eed1HuieK6zuddb2zD+uB5syBoFpjEt9sVuVMYSDZ8BWa?=
 =?us-ascii?Q?S+fuiGfcnUO+6YjX6sb2wfOXVOb1rBjjWPRrvOd2O95syaSCqeoSa9tIW18Y?=
 =?us-ascii?Q?oiROG4u7jncb+5d19SgKUsDI138/cl96zhyMGjaayCOYyvgiSAWd2sLTKvIl?=
 =?us-ascii?Q?/aZMWgVP/HPjZnThDPztu8uqXzy1upQFAtkEg6SzgkSnAAgGacJXZDPBMF1O?=
 =?us-ascii?Q?b2FJJsw9nqpkqZE9i1+YqCNPJlGvXyWG7i2r4LSn5o0H3DfwmlMtCMbAcq/k?=
 =?us-ascii?Q?wCvtj9EPeOo55g1wLqqJga0FgWGQ8Pa0BYtXUKZsxhR/pByX6vNR9RTC3vVI?=
 =?us-ascii?Q?y6h2v8hbRbsy6DFXn8Y4g5rwUPhMd+lGAper6P7Du/rrm8nXyD5i64JHyAIn?=
 =?us-ascii?Q?iPm6jJs8OvcLx+qNRj6PHxRsVGFrfm1CyK/XYK1NM7djVhnIwVAhh+kJX4JG?=
 =?us-ascii?Q?0Qf7cebct0tEGWxD4SWuKyv0yFYXX5Na1bkBkknLMd8zJE3JWG0EeKZ7TFkP?=
 =?us-ascii?Q?L0XEhyB+StdcrUAISa+3HtMb4Tof4b5MvI/24Bo1qoKmUxd61AUo6R0ZsO1E?=
 =?us-ascii?Q?i0OaxWA9dL6/AfteYQtNFJ02YlUyLOj/q6o53yJgazLVjPYz8bQHeE/iyOHx?=
 =?us-ascii?Q?rue3hWoDB6c0Md364QJF3eia4vzlcXeuW2T4xigt+aQuQHoFV4BvOXPZTcGo?=
 =?us-ascii?Q?gFcbMhdk1EOCFooc1S2tfD+LHWGBambKuITc1p1eyI6SuF+78UCZXZSy40O8?=
 =?us-ascii?Q?0CcxPR+D3+9b9gAanxy4RUdyyPj8KT93V1+vzRfZj9g5aDkmnisw6RS9THXy?=
 =?us-ascii?Q?vN0HbYfkuM5yvOqnowqXXHXafKCqxjIVz3q/Xbvq+zZXQQ5IFtoIRqFweX4p?=
 =?us-ascii?Q?g5gTfFD1sfX8702rY9IkT8EDOMmEq8UNT5pIa85ZnghLmKmPItp0LdQd8I0p?=
 =?us-ascii?Q?JXWxVr8QvaaJgov9RMXDdc4KzTr2pob0eAo10J6GaSzCMJRTKbft8YlcKtPx?=
 =?us-ascii?Q?R+mpU3AW33wAwLshwHtiYNBHSsn4FT4A+gdZkvrMMSJTTG/ZaSJtYjEsOuSX?=
 =?us-ascii?Q?pXMu8H1HYXk7nbeulHREHC2OJWphmQzEfmEAJoBH09WtqxRUvXF+O+LpA15V?=
 =?us-ascii?Q?TeLXN9mr/vz+Xzbvx6bHWLkvO3TNGmMQr6hnN8ZkNT3UABtkzTr8DrixsA9Z?=
 =?us-ascii?Q?Bkcq6Z+LyOl2WDtqeA/1ySXkQnXL9UY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1591f129-f24c-4d7f-e35c-08da3b72311f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 21:38:06.4549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xrHgiFdrYpyf4btActmQd25RY/eM7zgFf09gTZAooJbGP40A+Xnm0P6RKhk7O0yn0t7FuFCZhjOjUdirQnECNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6275
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the VCAP filters to support multiple tag_8021q CPU ports.

TX works using a filter for VLAN ID on the ingress of the CPU port, with
a redirect and a VLAN pop action. This can be updated trivially by
amending the ingress port mask of this rule to match on all tag_8021q
CPU ports.

RX works using a filter for ingress port on the egress of the CPU port,
with a VLAN push action. Here we need to replicate these filters for
each tag_8021q CPU port, and let them all have the same action.
This means that the OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN() cookie needs to
encode a unique value for every {user port, CPU port} pair it's given.
Do this by encoding the CPU port in the upper 16 bits of the cookie, and
the user port in the lower 16 bits.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 104 ++++++++++++++++++++-------------
 include/soc/mscc/ocelot_vcap.h |   2 +-
 2 files changed, 65 insertions(+), 41 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 01d8a731851e..3e07dc39007a 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -45,24 +45,26 @@ static struct net_device *felix_classify_db(struct dsa_db db)
 /* Set up VCAP ES0 rules for pushing a tag_8021q VLAN towards the CPU such that
  * the tagger can perform RX source port identification.
  */
-static int felix_tag_8021q_vlan_add_rx(struct felix *felix, int port, u16 vid)
+static int felix_tag_8021q_vlan_add_rx(struct dsa_switch *ds, int port,
+				       int upstream, u16 vid)
 {
 	struct ocelot_vcap_filter *outer_tagging_rule;
-	struct ocelot *ocelot = &felix->ocelot;
-	struct dsa_switch *ds = felix->ds;
-	int key_length, upstream, err;
+	struct ocelot *ocelot = ds->priv;
+	unsigned long cookie;
+	int key_length, err;
 
 	key_length = ocelot->vcap[VCAP_ES0].keys[VCAP_ES0_IGR_PORT].length;
-	upstream = dsa_upstream_port(ds, port);
 
 	outer_tagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter),
 				     GFP_KERNEL);
 	if (!outer_tagging_rule)
 		return -ENOMEM;
 
+	cookie = OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port, upstream);
+
 	outer_tagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
 	outer_tagging_rule->prio = 1;
-	outer_tagging_rule->id.cookie = OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port);
+	outer_tagging_rule->id.cookie = cookie;
 	outer_tagging_rule->id.tc_offload = false;
 	outer_tagging_rule->block_id = VCAP_ES0;
 	outer_tagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -83,16 +85,19 @@ static int felix_tag_8021q_vlan_add_rx(struct felix *felix, int port, u16 vid)
 	return err;
 }
 
-static int felix_tag_8021q_vlan_del_rx(struct felix *felix, int port, u16 vid)
+static int felix_tag_8021q_vlan_del_rx(struct dsa_switch *ds, int port,
+				       int upstream, u16 vid)
 {
 	struct ocelot_vcap_filter *outer_tagging_rule;
 	struct ocelot_vcap_block *block_vcap_es0;
-	struct ocelot *ocelot = &felix->ocelot;
+	struct ocelot *ocelot = ds->priv;
+	unsigned long cookie;
 
 	block_vcap_es0 = &ocelot->block[VCAP_ES0];
+	cookie = OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port, upstream);
 
 	outer_tagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_es0,
-								 port, false);
+								 cookie, false);
 	if (!outer_tagging_rule)
 		return -ENOENT;
 
@@ -102,12 +107,14 @@ static int felix_tag_8021q_vlan_del_rx(struct felix *felix, int port, u16 vid)
 /* Set up VCAP IS1 rules for stripping the tag_8021q VLAN on TX and VCAP IS2
  * rules for steering those tagged packets towards the correct destination port
  */
-static int felix_tag_8021q_vlan_add_tx(struct felix *felix, int port, u16 vid)
+static int felix_tag_8021q_vlan_add_tx(struct dsa_switch *ds, int port,
+				       u16 vid)
 {
 	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
-	struct ocelot *ocelot = &felix->ocelot;
-	struct dsa_switch *ds = felix->ds;
-	int upstream, err;
+	unsigned long cpu_ports = dsa_cpu_ports(ds);
+	struct ocelot *ocelot = ds->priv;
+	unsigned long cookie;
+	int err;
 
 	untagging_rule = kzalloc(sizeof(struct ocelot_vcap_filter), GFP_KERNEL);
 	if (!untagging_rule)
@@ -119,14 +126,14 @@ static int felix_tag_8021q_vlan_add_tx(struct felix *felix, int port, u16 vid)
 		return -ENOMEM;
 	}
 
-	upstream = dsa_upstream_port(ds, port);
+	cookie = OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port);
 
 	untagging_rule->key_type = OCELOT_VCAP_KEY_ANY;
-	untagging_rule->ingress_port_mask = BIT(upstream);
+	untagging_rule->ingress_port_mask = cpu_ports;
 	untagging_rule->vlan.vid.value = vid;
 	untagging_rule->vlan.vid.mask = VLAN_VID_MASK;
 	untagging_rule->prio = 1;
-	untagging_rule->id.cookie = OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port);
+	untagging_rule->id.cookie = cookie;
 	untagging_rule->id.tc_offload = false;
 	untagging_rule->block_id = VCAP_IS1;
 	untagging_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -143,11 +150,13 @@ static int felix_tag_8021q_vlan_add_tx(struct felix *felix, int port, u16 vid)
 		return err;
 	}
 
+	cookie = OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port);
+
 	redirect_rule->key_type = OCELOT_VCAP_KEY_ANY;
-	redirect_rule->ingress_port_mask = BIT(upstream);
+	redirect_rule->ingress_port_mask = cpu_ports;
 	redirect_rule->pag = port;
 	redirect_rule->prio = 1;
-	redirect_rule->id.cookie = OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port);
+	redirect_rule->id.cookie = cookie;
 	redirect_rule->id.tc_offload = false;
 	redirect_rule->block_id = VCAP_IS2;
 	redirect_rule->type = OCELOT_VCAP_FILTER_OFFLOAD;
@@ -165,19 +174,21 @@ static int felix_tag_8021q_vlan_add_tx(struct felix *felix, int port, u16 vid)
 	return 0;
 }
 
-static int felix_tag_8021q_vlan_del_tx(struct felix *felix, int port, u16 vid)
+static int felix_tag_8021q_vlan_del_tx(struct dsa_switch *ds, int port, u16 vid)
 {
 	struct ocelot_vcap_filter *untagging_rule, *redirect_rule;
 	struct ocelot_vcap_block *block_vcap_is1;
 	struct ocelot_vcap_block *block_vcap_is2;
-	struct ocelot *ocelot = &felix->ocelot;
+	struct ocelot *ocelot = ds->priv;
+	unsigned long cookie;
 	int err;
 
 	block_vcap_is1 = &ocelot->block[VCAP_IS1];
 	block_vcap_is2 = &ocelot->block[VCAP_IS2];
 
+	cookie = OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port);
 	untagging_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is1,
-							     port, false);
+							     cookie, false);
 	if (!untagging_rule)
 		return -ENOENT;
 
@@ -185,8 +196,9 @@ static int felix_tag_8021q_vlan_del_tx(struct felix *felix, int port, u16 vid)
 	if (err)
 		return err;
 
+	cookie = OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port);
 	redirect_rule = ocelot_vcap_block_find_filter_by_id(block_vcap_is2,
-							    port, false);
+							    cookie, false);
 	if (!redirect_rule)
 		return -ENOENT;
 
@@ -196,7 +208,7 @@ static int felix_tag_8021q_vlan_del_tx(struct felix *felix, int port, u16 vid)
 static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
 				    u16 flags)
 {
-	struct ocelot *ocelot = ds->priv;
+	struct dsa_port *cpu_dp;
 	int err;
 
 	/* tag_8021q.c assumes we are implementing this via port VLAN
@@ -206,38 +218,50 @@ static int felix_tag_8021q_vlan_add(struct dsa_switch *ds, int port, u16 vid,
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
-	err = felix_tag_8021q_vlan_add_rx(ocelot_to_felix(ocelot), port, vid);
-	if (err)
-		return err;
-
-	err = felix_tag_8021q_vlan_add_tx(ocelot_to_felix(ocelot), port, vid);
-	if (err) {
-		felix_tag_8021q_vlan_del_rx(ocelot_to_felix(ocelot), port, vid);
-		return err;
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = felix_tag_8021q_vlan_add_rx(ds, port, cpu_dp->index, vid);
+		if (err)
+			return err;
 	}
 
+	err = felix_tag_8021q_vlan_add_tx(ds, port, vid);
+	if (err)
+		goto add_tx_failed;
+
 	return 0;
+
+add_tx_failed:
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
+		felix_tag_8021q_vlan_del_rx(ds, port, cpu_dp->index, vid);
+
+	return err;
 }
 
 static int felix_tag_8021q_vlan_del(struct dsa_switch *ds, int port, u16 vid)
 {
-	struct ocelot *ocelot = ds->priv;
+	struct dsa_port *cpu_dp;
 	int err;
 
 	if (!dsa_is_user_port(ds, port))
 		return 0;
 
-	err = felix_tag_8021q_vlan_del_rx(ocelot_to_felix(ocelot), port, vid);
-	if (err)
-		return err;
-
-	err = felix_tag_8021q_vlan_del_tx(ocelot_to_felix(ocelot), port, vid);
-	if (err) {
-		felix_tag_8021q_vlan_add_rx(ocelot_to_felix(ocelot), port, vid);
-		return err;
+	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
+		err = felix_tag_8021q_vlan_del_rx(ds, port, cpu_dp->index, vid);
+		if (err)
+			return err;
 	}
 
+	err = felix_tag_8021q_vlan_del_tx(ds, port, vid);
+	if (err)
+		goto del_tx_failed;
+
 	return 0;
+
+del_tx_failed:
+	dsa_switch_for_each_cpu_port(cpu_dp, ds)
+		felix_tag_8021q_vlan_add_rx(ds, port, cpu_dp->index, vid);
+
+	return err;
 }
 
 static int felix_trap_get_cpu_port(struct dsa_switch *ds,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index de26c992f821..c601a4598b0d 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -11,7 +11,7 @@
 /* Cookie definitions for private VCAP filters installed by the driver.
  * Must be unique per VCAP block.
  */
-#define OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port)		(port)
+#define OCELOT_VCAP_ES0_TAG_8021Q_RXVLAN(ocelot, port, upstream) ((upstream) << 16 | (port))
 #define OCELOT_VCAP_IS1_TAG_8021Q_TXVLAN(ocelot, port)		(port)
 #define OCELOT_VCAP_IS2_TAG_8021Q_TXVLAN(ocelot, port)		(port)
 #define OCELOT_VCAP_IS2_MRP_REDIRECT(ocelot, port)		((ocelot)->num_phys_ports + (port))
-- 
2.25.1

