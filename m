Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4E598816
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343974AbiHRPuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344072AbiHRPtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:39 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF46257891
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KpN7x2JN6MtsVWF3UpEeQ81/VfNJgrmb7EsYUHfJoRZgPJCqaLGCDtIyvGMCXh66Iv00m7pORSN9QvZdy0raP7XXoXHRIrQoQuBSu3eyrFyDFSqnsjqKevF6oL6FodWrbahVcd4qvUZkb368EKade4801Rz/ONqm7J0BAeCUP/Q2KP/VPwsyWpfdsiPux5XpxldAqEGK4k7iiDS/Fl47qyF0Gjj9nld1OyDt9FRVNWK2jPTZ65dOEz0bl5u1RbXhHtcVCPstMLW2UjVkP/yLNa1ZDehv8cd271cVPVc9kTntES5+Tr56rWJClpjXenq5Pbml0gWeoG0hHGhXQfU1Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETIyNiwJIQMkevFvnIOKEg2MxqPpkfvSDEvbiksJThk=;
 b=X4jJ7K7LDd86hrMDHxxX36smtP9v5+uT+YGhCoIi1FvBTE5EiwgAc3XTb+bm/s06KiBSfnO6Xqanj30FUEXlvd3qAhhCxxOeHBdYM9MPgzPTzeuHp4P2XczMA3Lgn9kDfFlOXMO2SjqcEQLhqK6ffwQ+aTflPN+VKAvm3zeA5s7GL17cIZXNe1tHGIqBDd+/jmmJFj5BNJEW8o8wqcJYIGhEVCeapJxzx6tpiYHdg/WuVQCCHzMzQHKdbbLVNnPYVA8mxfPNK9hnpPhoqVZf74KnAAiPT0W/lu+hb26o42RpT8CQHvxq3++/kwBOy7RPsEqEPIu09hrBS2NoRx+HrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ETIyNiwJIQMkevFvnIOKEg2MxqPpkfvSDEvbiksJThk=;
 b=YPwfwNqkF92letYZx8GbC3uUlLHgjtEW32NVaGDCb16ub8OLytblCV1CbXbvYG+lg8Rmel/lEmG6LBIgRHN5MrnmOLt7DWnfE/R9DZ71qpo+oagV59STxf3W0Fa7Le4oCYXqNdFCLiZ/ybl2Qu1PffcujE1O78Xz4su9aCpqtpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 15:49:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 06/10] net: dsa: convert switch.c functions to return void if they can
Date:   Thu, 18 Aug 2022 18:49:07 +0300
Message-Id: <20220818154911.2973417-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4dd8ed5-fd35-4405-2f6d-08da81313f88
X-MS-TrafficTypeDiagnostic: VE1PR04MB6349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GixFYlQq/OwGcI/YBBA+0RYb465UO2T8u3ZrWnQ2W5AV61jOsKKaPecfwOD+y4EvhoYlYWMLKP6nQjuLVuvS4Z/H2+KwdicNAaxIWqmahsvBvHCYgaudTQDqfT5NVNrfih76Ci3VFzE33NLnkQWlCiRAKF1h2aZfIeUgRkBLGFmq0Zc7oyPZog9XkYhyq6esTzdYGfUBDbT+jPT5N/3Q4Wqo2ZIr4WRkqL/eKLPAAUmEz4cm0zQUWjBKhx+n64MX4CZJoknlf8n0CyDsADhTuN00dAlS5eZz+T8ac7ID4cTJ3l9FQs+HESji08fjC8q6mnKM467ioogsizWN4QNKt415sM4XY+DWp4irv7DsZkghAYEhP/uwPsFwRXOOrdsDFtXNqn0Rth/uqJvOtmXdGNHEN6g+nQZxJsVHHyJ8ig6tM0VQO5rHNktl3A6HNOSanUXVO+bZXCPHeFNPFamHHeQM5iHFmbh4jHdSql5wLHKtBRwEzNhnVBs4AtSwThCO+x38Bh+Gdl+QTkTm8O0NB9jDPQMYbMObf7SGD1txU+Phw0OkCXP+MFkHPvkzy2UCrev3bGHAktJW1uJ2R/3F75rTt4BpiNSajNN1NSdlHxEZ3Xade6kHTbzN2o0BFQeQr8IyM8SwE8CdgKuk0X2SlyDwNIky/fmH9RcRaEYxE2r9/hFwiqH4jgu50GKAxQ67U+gGe72GjJ1KUtgJUTaVqO1gTL8ZjoyXW1T2HmiR/4Ii6W+rph6GbBiKU5sfAYTv7kcm1/XaGJsfzzOfl2KJDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(6486002)(478600001)(41300700001)(6666004)(26005)(6512007)(2906002)(66476007)(66556008)(6506007)(36756003)(86362001)(6916009)(316002)(54906003)(8676002)(66946007)(1076003)(2616005)(186003)(5660300002)(44832011)(7416002)(8936002)(4326008)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fbtCs0RclWV7lBDMTJUu9MuYVCGUbfMUJosrDZsd6hQmSrHaQaQGMLOFqdSE?=
 =?us-ascii?Q?MnZ5Vip6Nz+csq9nvKqgIQLadZx8rVFxcU6MqNmv6ShhQZ9eADGiec7e6x55?=
 =?us-ascii?Q?qfDb/N3qwAr5xDUjtoLMp4fza1MSgpEa4XlTtsqEgzvcDcskcjRx/Peg07Fm?=
 =?us-ascii?Q?iiE8mL5MckTfLvYTgJpdBak4sy3xV7iWD2ZU3CTO3qeOw0fXQ9lqFmFe7TAj?=
 =?us-ascii?Q?wsxkE5YQtgchht9rEmHLka/adTang8Rs9h03dnUUl7nbPhlVKd87LTqD9me1?=
 =?us-ascii?Q?UyFy7va2YP3Yeh1LZM7DInLvOs68DtDY5uDbfUVmA8mWzoE73ZH7uPOoEoZI?=
 =?us-ascii?Q?XHuRmNZZ5lmTAa4pFGjHg3Vqmw/paNEawQnw8ykQcguQUKFU67VCKPUmp8cf?=
 =?us-ascii?Q?Hrsl3v0v4ZcLTSucME/9WAmWOHCfQAJY1RjH8ohxxJ+uilNHKurLWMzoXKdT?=
 =?us-ascii?Q?Yvs3qYdAUiab2arDPH8vSiEsGFa3W1RqgjOIgmmqIIsQIvNcGM1WHJwCERfB?=
 =?us-ascii?Q?W87Q05USuWYmlCDuqUqpDnFImpKtkYy8pc1zSCOWaO5ouWRNvUFLWBbed2Ky?=
 =?us-ascii?Q?lB6gEWuH3a9diVTOrgBYfKPK+1qFw8MYCETz9wl559OvizgJXrFXy2lE9567?=
 =?us-ascii?Q?1mdwHCX9EOHkQKe+l21xS7fVJ0XsCl4UA1ACXRIqK0jZPgzVpwn/L04fNGWp?=
 =?us-ascii?Q?YEkBql4I8POdUdjzsoIpjeCOt5O3GBAk3wCvRn6GTahQJAdGZWRMiLue6/mj?=
 =?us-ascii?Q?By53SkavsReWwvTAa63rTTU/QEG2XjGSoyFObouzvE6iy0MVqP9qoP1QJ7/L?=
 =?us-ascii?Q?8sf0RjzoFevxycjib8tWT0/ngtWuIEu044txith38Y1wcTv330Pud0TgVjM1?=
 =?us-ascii?Q?tRXfiSlb7j9bn1M4o7rooJE47xlWWdqZSGzJ2CQ/M5jakAiLCorsiS4Pyoaz?=
 =?us-ascii?Q?k0UtqQuyW9hc9Fwqvcl/fodTvYcOcWlyvt35fl6+xnvJThfsnV6b0WASVz+r?=
 =?us-ascii?Q?DgZe5Dz2qndTclxxKsg/oEJyjrRtVWSiAkhy2tmLBmk5cSaZi54mQcUpMfpH?=
 =?us-ascii?Q?WTvtWeoWvrzPOl2WefXpX+aYLHCMMf1Q4wQdgHDMlb8+2mkYi8jDkDLSCzzU?=
 =?us-ascii?Q?ybenahd9E50YAcModBUK8qxU1jd2lNvD0qnfZ2apYip7eNI5VI8q6i1TtSZ0?=
 =?us-ascii?Q?ta7b9QjXmmI7vuMq9l4BqEwBvoZiSKQGwcPusj0hd331yNf+sGdn0a6ZQxMD?=
 =?us-ascii?Q?Kg4/SAreJTKZc834aiItd/jonaSqU39gZZnHHUBsE+I64aXJozItABVk3ZBa?=
 =?us-ascii?Q?ft12aa9HCwkDLLT5noh6ZbPNpKmB7wKW2juFiOQ2uB4RLqTUE4jH4At5s5bt?=
 =?us-ascii?Q?CF/Qw+C4qvR9UZRnwB+2UInls0A1tPbFmg1ImoakankkcHYnJ4eeJcECbxsB?=
 =?us-ascii?Q?iMb6rSoUuQLKUj9KGH1Ov7HXEDcTe/Sj968uG8VZYH/FC7Kf7A5r98cXjgU5?=
 =?us-ascii?Q?ZmEgNojASAcgr3+REg1dWZUlHnqcd8bQ4C4SViNmw7awsFqdgIc2fwiGaiaL?=
 =?us-ascii?Q?LuCyEc02r1DUK0u2UH5PdI5GOYdFMpDP5VurK5TYLrp0uQ5pPe6HgcQI7fbu?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4dd8ed5-fd35-4405-2f6d-08da81313f88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:34.7179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wa2ZZLqRV9VMqkEx3z8xHRrk60/ftJ730KE6mO+igGUu6zCJUDK27gXbF0wAoERq2FHG/6i3nFotLKV2Ybxxrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We try to convert the non-robust cross-chip notifiers (dsa_tree_notify
and derivatives) to return void, and we'll suppress errors inside
dsa_tree_notify() itself.

It makes little sense to force all dsa_switch_event() handlers to return
int especially since they're going to be called from a function that
returns void to its own callers, so stop that and convert functions in
switch.c to return void where possible.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/switch.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4dfd68cf61c5..e3a91f38c5db 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -104,8 +104,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	return 0;
 }
 
-static int dsa_switch_bridge_leave(struct dsa_switch *ds,
-				   struct dsa_notifier_bridge_info *info)
+static void dsa_switch_bridge_leave(struct dsa_switch *ds,
+				    struct dsa_notifier_bridge_info *info)
 {
 	if (info->dp->ds == ds && ds->ops->port_bridge_leave)
 		ds->ops->port_bridge_leave(ds, info->dp->index, info->bridge);
@@ -115,8 +115,6 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 						info->dp->ds->index,
 						info->dp->index,
 						info->bridge);
-
-	return 0;
 }
 
 /* Matches for all upstream-facing ports (the CPU port and all upstream-facing
@@ -871,7 +869,7 @@ dsa_switch_connect_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
-static int
+static void
 dsa_switch_disconnect_tag_proto(struct dsa_switch *ds,
 				struct dsa_notifier_tag_proto_info *info)
 {
@@ -884,26 +882,23 @@ dsa_switch_disconnect_tag_proto(struct dsa_switch *ds,
 	/* No need to notify the switch, since it shouldn't have any
 	 * resources to tear down
 	 */
-	return 0;
 }
 
-static int
+static void
 dsa_switch_master_state_change(struct dsa_switch *ds,
 			       struct dsa_notifier_master_state_info *info)
 {
 	if (!ds->ops->master_state_change)
-		return 0;
+		return;
 
 	ds->ops->master_state_change(ds, info->master, info->operational);
-
-	return 0;
 }
 
 static int dsa_switch_event(struct notifier_block *nb,
 			    unsigned long event, void *info)
 {
 	struct dsa_switch *ds = container_of(nb, struct dsa_switch, nb);
-	int err;
+	int err = 0;
 
 	switch (event) {
 	case DSA_NOTIFIER_AGEING_TIME:
@@ -913,7 +908,7 @@ static int dsa_switch_event(struct notifier_block *nb,
 		err = dsa_switch_bridge_join(ds, info);
 		break;
 	case DSA_NOTIFIER_BRIDGE_LEAVE:
-		err = dsa_switch_bridge_leave(ds, info);
+		dsa_switch_bridge_leave(ds, info);
 		break;
 	case DSA_NOTIFIER_FDB_ADD:
 		err = dsa_switch_fdb_add(ds, info);
@@ -976,7 +971,7 @@ static int dsa_switch_event(struct notifier_block *nb,
 		err = dsa_switch_connect_tag_proto(ds, info);
 		break;
 	case DSA_NOTIFIER_TAG_PROTO_DISCONNECT:
-		err = dsa_switch_disconnect_tag_proto(ds, info);
+		dsa_switch_disconnect_tag_proto(ds, info);
 		break;
 	case DSA_NOTIFIER_TAG_8021Q_VLAN_ADD:
 		err = dsa_switch_tag_8021q_vlan_add(ds, info);
@@ -985,7 +980,7 @@ static int dsa_switch_event(struct notifier_block *nb,
 		err = dsa_switch_tag_8021q_vlan_del(ds, info);
 		break;
 	case DSA_NOTIFIER_MASTER_STATE_CHANGE:
-		err = dsa_switch_master_state_change(ds, info);
+		dsa_switch_master_state_change(ds, info);
 		break;
 	default:
 		err = -EOPNOTSUPP;
-- 
2.34.1

