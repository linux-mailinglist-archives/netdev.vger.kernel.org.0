Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FBCA4B0DE0
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbiBJMwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:52:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239293AbiBJMwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:52:16 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2082.outbound.protection.outlook.com [40.107.20.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A702643
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 04:52:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbJnQMpuG7wXDq4SGGaeIz5syAvc1JGtoYAqAWcH+kTA2ki0AS1j/r/Op/pMxjPVKID8KmwgdfhCqpigJCzO8F1uMOjNYo6iKbiaDGlvRJ+C7bDsFKw7OM8YCSvoSk/pvlo/Nf7TT5Tu/5gDei8b0BOvHfUC09gLIbwE3pLhkekvQ442k0mafXASQnOgQEG+R5WikGUBVFavZ/6hqfJ+Z0OOJHevUAG1N0FBfwM86XHZonZe5xZGMGxpDjSjTsPbFrUEmpTCTODTCK4tv75lFO7Gv8scwsy4+dQ36IZ/yC6j2Juo163FYZN//pA4yQXdxXhlll0Od31VFwWomplFsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R+fPLScid4OcbeqR7qHAjRE91HjIsUDEbwyfmGB/1ug=;
 b=RcgsBehYkMuSlQN24Aka1ooRq06E1g3eQFcB6xPn98OGp2IB9/VaOPaQdZaZ5crAMvTV9lx5mayOB7OoV/Oi8loaVde+J8FFoC1/nLdEQ5Pj18fZt1ynoZJZTa8S89xKgJiXO9N9sPj2FAVlvF03d8qYHNXZ7jIhyFhQdt5zbFyoyrtqh/JIJGbkjgRGfcv9hwHrloaGPEoJ9nbh7bYfIeKROwjrtxvNwTRMszQfTgyszbOfeekxwYT/TNBHoiEnnxPyCBLZiAFLpwLHqDZe4+pJnLvb9vhapD+muK7cJsfwbrK+s+kjUnTgUnCRxmJbs6PGOfrjJ4gkTQZTok4+qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R+fPLScid4OcbeqR7qHAjRE91HjIsUDEbwyfmGB/1ug=;
 b=Zi5eOO90bundMUB1t8K7KQly4yNZ5eZirtEiCkLPfv4OlUI49gTTI/APnZU2mELCP6PrIOEUx1OkbBVPqK6yJzMLq+odTH6bjbxxiXe3USPZ9eSPIeSyfBqT9WQwKkPnUTztWVkOiZBhytM71u+hDzDq7Vx6R5ygImU8rG9IMkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 12:52:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 12:52:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v2 net-next 01/12] net: dsa: rename references to "lag" as "lag_dev"
Date:   Thu, 10 Feb 2022 14:51:50 +0200
Message-Id: <20220210125201.2859463-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56b827cf-be57-4e39-5860-08d9ec9429bc
X-MS-TrafficTypeDiagnostic: DBAPR04MB7336:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB73361E87F3D65FE9E7DF0F31E02F9@DBAPR04MB7336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCDMjKc93sd+hYu81gkhvlTWKKiDCBGQLI0X4hueE0vBGACG4t8oDGikcP2Su4o77Rerg1B6wqOQzL/CZ8SZIigsEl3JoH7axaSFR0VUizBEOUxjxegs7X7JBv2o/oV8TmCsoxjXy690Au3OeTk4gsVGyQYhJMvsl2e3WhEdOpHkMiN0adaHxzyBv/bINfRoYe85GyNU63/13RGar3vssQYKVR2eFvD7RrcG09HjTXjvC529KKYaYvch8MnGFYFjk4JgEPEsZ+81ZlC+WZvHxRRsDehah7awTTjts4Ji9YH/yB4+D2l6rM6tGJxyLdHyuYXZuBHQRuXXhfSWaszWmYeTqRkc8V4BRQnIhAt3ofZpogzgoa4wuGLZ1zCOh1YnVckxNejY9Ano3CaJ2FUjS5kKWWj9SDRhNew8L2d0FwKq9TRnTOShXnE9mIjJGlrbntj+DHkqRQmi/AmO01jDzpej8jYKA8TmY80J3m4vpmXKN/zkTCUNDN6HCU6AXyD4nT0z8tIv/XeeUCNJWvOy44sgIaTQFe3g5YApjDJG3KKz2RVC5Czn0AKFktHKoJzx0JsKGFG9DOKJVez4kKAKpFyvNkyN9T8L3Bo67AJ58ZNx7etohG5dixjNGfG5lySH/vQbnttZZyyW18gZTfAvMxZ4TnPN0vAeZAJuihZXFXpxw6geHXyOLffRpur8pntLq3sVul2NF3QvFyQrArHY0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(52116002)(186003)(26005)(6666004)(2616005)(83380400001)(6512007)(6506007)(44832011)(2906002)(7416002)(5660300002)(8936002)(4326008)(66476007)(66946007)(508600001)(36756003)(8676002)(66556008)(6486002)(54906003)(38100700002)(86362001)(38350700002)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5RhfNonhPHxPzil/lhhv+1paWjJ756b82JZhriMEzuHGeQzM13TfKnx1nCON?=
 =?us-ascii?Q?53NtbT6O0zvgqeg9KXjZhhI7/LhJgHX3wsnYWv//kVxlmkGAQgSzgS7AneRp?=
 =?us-ascii?Q?j4sf+MJqEHStanU8p7a0H63ckmZ2t3FSgDQK4OMZhlPnphA9Y8NL91RhTEFz?=
 =?us-ascii?Q?q2ak+BM5PHyIDZLwSzns0ZI3BP6ZBNHWh5kP42bFE1cKWZPwrS1wWsYvioWm?=
 =?us-ascii?Q?mJDLaD7Ahc98e/FQmBDBG2VNMPkte1q8jO+f7fMef1GS/bDNFS+Bqsj1ADFX?=
 =?us-ascii?Q?1l1go6Dw6uPzsTB9CQbRfjqfCiZS+9v2eUtiIs7dNOb+7+DMS+1f49yF6qkq?=
 =?us-ascii?Q?51E6EJ4Nh1XJVYmIBY7Dq4+4hWiBOnEbJK/rQNcPgoKV10SHeGHUH1ufKae0?=
 =?us-ascii?Q?R7XFbp+Wsvzc/iiYSc5Y4Ehoei/Vpnga9A6X0xGtaZKPPcKzb5CqVCT6lrmH?=
 =?us-ascii?Q?I2gZappA0RE2qUjyzVZNcxCy43IVRjpWJZ3IV4ie+c46XnngxZysNMKIbfO0?=
 =?us-ascii?Q?5rjkYwpQznb/1hWiBZ8n3F+vBCzOSW1fkhtuGuNw+5zAvUDMO7K4uPWazCcw?=
 =?us-ascii?Q?LpsTFS8Nf3CH8PrqkDgrkK5uQQfMiXKBNNtE+l3QVs+iddZWF4cVh276xqay?=
 =?us-ascii?Q?EePUr+aCOdzlam672Eb7w77y8Vj1wPoiFnJnumuxqCdQRJvGWNv3vEXkh/wx?=
 =?us-ascii?Q?GhfCuiAjB6KMfEwXuvjMR8isgDaPt+vSpuJxTRfXxNouUey4ZnQYday0Fe7V?=
 =?us-ascii?Q?OIvRAiAtYSueFIgxZyPNvFgrByVYktQi7P+ufbDo838TvTz4vuV6/k2AUhMO?=
 =?us-ascii?Q?j67kO9NOJqNbhrtJMnksIcyzT8l1WheEvmzADS9r19wXw3lq2ARYz/mDnOqK?=
 =?us-ascii?Q?yo8fZZ+CZBx54yyeaRcWNWa43RT2dnUh/C5pBRxI6ZGr0xoLGI9huac44p6k?=
 =?us-ascii?Q?uCq5TQpHrEN3jxavlKjlcCndby2GLoGQwhEI1+auybrFRvQ8lr1Z82kPNsho?=
 =?us-ascii?Q?6rdvn5o0trXfFZZnCTz9jhWiuOzWV0RZdDA+jucVh9/csXAc9GPMu7PbAp5v?=
 =?us-ascii?Q?D9pIwBKgqQ1LPbxWuyEm8hnzIrwLRJcU0Uu0AnlU8AAFJ/pHPtd5ByizLqje?=
 =?us-ascii?Q?F/d9XtUBe7ho3nQocM8K3ruydE9sUhCvzvHrfukIlpAYAB7NsOGBtYtMm8c5?=
 =?us-ascii?Q?+7WxbzJ/Ql/2gMJvrMCr9YUmEU+Mxnz1m3fwYBeX5RfMSjzAdk1tCFEucgNR?=
 =?us-ascii?Q?puvcKRMio+JLsfkRC4xog19zQcT2j37lckWKbM6EmyrgAfbVpkvozAFlCt2y?=
 =?us-ascii?Q?k7UXoOAk00wx51DvXypp7ejTIiHa/gO5FOPb3lOJDJ2lIWmIUtykz8wC+AvZ?=
 =?us-ascii?Q?CbLy4y60heTKxbXgXCyP1TZn9ppCBqMYcVe5Ucj6rHgoHsZJ1fwcBwY8Vxfy?=
 =?us-ascii?Q?YHQLo59PCchgXtJi6Yz+m75B/SjrWBdI9gjVxLn/sFTnbo71KPYhdhiiB32k?=
 =?us-ascii?Q?hekCcravRQJrbYdyxOW08ta1YqmNicBp4xEZGmvAZ5kIiVkqXtcdy+SjrXx4?=
 =?us-ascii?Q?NMlVOKrKnwcEb6Sv05wtFKHCEhbNKYXi9aSMGq5FXqXM2d3cjcS2KEhFA0bM?=
 =?us-ascii?Q?2TrRdRmIhXvLoP5GAtgIKQo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b827cf-be57-4e39-5860-08d9ec9429bc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 12:52:15.1191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdGOB41IdG3gae1zECqVJ37p129u46zdhnQ8e1sjzWUd0OuhSiyFYPjUd3V4i+0CS0d87dJr/Ww5FLvNJtUrMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of converting struct net_device *dp->lag_dev into a
struct dsa_lag *dp->lag, we need to rename, for consistency purposes,
all occurrences of the "lag" variable in the DSA core to "lag_dev".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 12 ++++++------
 net/dsa/dsa2.c     | 16 ++++++++--------
 net/dsa/dsa_priv.h |  6 +++---
 net/dsa/port.c     | 20 ++++++++++----------
 net/dsa/switch.c   |  8 ++++----
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fd1f62a6e0a8..207723e979c3 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -182,12 +182,12 @@ static inline struct net_device *dsa_lag_dev(struct dsa_switch_tree *dst,
 }
 
 static inline int dsa_lag_id(struct dsa_switch_tree *dst,
-			     struct net_device *lag)
+			     struct net_device *lag_dev)
 {
 	unsigned int id;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag)
+		if (dsa_lag_dev(dst, id) == lag_dev)
 			return id;
 	}
 
@@ -958,10 +958,10 @@ struct dsa_switch_ops {
 	int	(*crosschip_lag_change)(struct dsa_switch *ds, int sw_index,
 					int port);
 	int	(*crosschip_lag_join)(struct dsa_switch *ds, int sw_index,
-				      int port, struct net_device *lag,
+				      int port, struct net_device *lag_dev,
 				      struct netdev_lag_upper_info *info);
 	int	(*crosschip_lag_leave)(struct dsa_switch *ds, int sw_index,
-				       int port, struct net_device *lag);
+				       int port, struct net_device *lag_dev);
 
 	/*
 	 * PTP functionality
@@ -1033,10 +1033,10 @@ struct dsa_switch_ops {
 	 */
 	int	(*port_lag_change)(struct dsa_switch *ds, int port);
 	int	(*port_lag_join)(struct dsa_switch *ds, int port,
-				 struct net_device *lag,
+				 struct net_device *lag_dev,
 				 struct netdev_lag_upper_info *info);
 	int	(*port_lag_leave)(struct dsa_switch *ds, int port,
-				  struct net_device *lag);
+				  struct net_device *lag_dev);
 
 	/*
 	 * HSR integration
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 909b045c9b11..c73c376d5d2b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -74,7 +74,7 @@ int dsa_broadcast(unsigned long e, void *v)
 /**
  * dsa_lag_map() - Map LAG netdev to a linear LAG ID
  * @dst: Tree in which to record the mapping.
- * @lag: Netdev that is to be mapped to an ID.
+ * @lag_dev: Netdev that is to be mapped to an ID.
  *
  * dsa_lag_id/dsa_lag_dev can then be used to translate between the
  * two spaces. The size of the mapping space is determined by the
@@ -82,17 +82,17 @@ int dsa_broadcast(unsigned long e, void *v)
  * it unset if it is not needed, in which case these functions become
  * no-ops.
  */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	unsigned int id;
 
-	if (dsa_lag_id(dst, lag) >= 0)
+	if (dsa_lag_id(dst, lag_dev) >= 0)
 		/* Already mapped */
 		return;
 
 	for (id = 0; id < dst->lags_len; id++) {
 		if (!dsa_lag_dev(dst, id)) {
-			dst->lags[id] = lag;
+			dst->lags[id] = lag_dev;
 			return;
 		}
 	}
@@ -108,22 +108,22 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag)
 /**
  * dsa_lag_unmap() - Remove a LAG ID mapping
  * @dst: Tree in which the mapping is recorded.
- * @lag: Netdev that was mapped.
+ * @lag_dev: Netdev that was mapped.
  *
  * As there may be multiple users of the mapping, it is only removed
  * if there are no other references to it.
  */
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag)
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev)
 {
 	struct dsa_port *dp;
 	unsigned int id;
 
-	dsa_lag_foreach_port(dp, dst, lag)
+	dsa_lag_foreach_port(dp, dst, lag_dev)
 		/* There are remaining users of this mapping */
 		return;
 
 	dsa_lags_foreach_id(id, dst) {
-		if (dsa_lag_dev(dst, id) == lag) {
+		if (dsa_lag_dev(dst, id) == lag_dev) {
 			dst->lags[id] = NULL;
 			break;
 		}
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2bbfa9efe9f8..9bc6dd4a5855 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -74,7 +74,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag;
+	struct net_device *lag_dev;
 	int sw_index;
 	int port;
 
@@ -481,8 +481,8 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
 /* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag_dev);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag_dev);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..bb42ac7ed53f 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -440,27 +440,27 @@ int dsa_port_lag_change(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_CHANGE, &info);
 }
 
-int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
+int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo,
 		      struct netlink_ext_ack *extack)
 {
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 		.info = uinfo,
 	};
 	struct net_device *bridge_dev;
 	int err;
 
-	dsa_lag_map(dp->ds->dst, lag);
-	dp->lag_dev = lag;
+	dsa_lag_map(dp->ds->dst, lag_dev);
+	dp->lag_dev = lag_dev;
 
 	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
 	if (err)
 		goto err_lag_join;
 
-	bridge_dev = netdev_master_upper_dev_get(lag);
+	bridge_dev = netdev_master_upper_dev_get(lag_dev);
 	if (!bridge_dev || !netif_is_bridge_master(bridge_dev))
 		return 0;
 
@@ -474,11 +474,11 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag,
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_LEAVE, &info);
 err_lag_join:
 	dp->lag_dev = NULL;
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 	return err;
 }
 
-void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 
@@ -486,13 +486,13 @@ void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag)
 		dsa_port_pre_bridge_leave(dp, br);
 }
 
-void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
+void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev)
 {
 	struct net_device *br = dsa_port_bridge_dev_get(dp);
 	struct dsa_notifier_lag_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
-		.lag = lag,
+		.lag_dev = lag_dev,
 	};
 	int err;
 
@@ -514,7 +514,7 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 			"port %d failed to notify DSA_NOTIFIER_LAG_LEAVE: %pe\n",
 			dp->index, ERR_PTR(err));
 
-	dsa_lag_unmap(dp->ds->dst, lag);
+	dsa_lag_unmap(dp->ds->dst, lag_dev);
 }
 
 /* Must be called under rcu_read_lock() */
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4866b58649e4..d0d59f2fd445 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -468,12 +468,12 @@ static int dsa_switch_lag_join(struct dsa_switch *ds,
 			       struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_join)
-		return ds->ops->port_lag_join(ds, info->port, info->lag,
+		return ds->ops->port_lag_join(ds, info->port, info->lag_dev,
 					      info->info);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_join)
 		return ds->ops->crosschip_lag_join(ds, info->sw_index,
-						   info->port, info->lag,
+						   info->port, info->lag_dev,
 						   info->info);
 
 	return -EOPNOTSUPP;
@@ -483,11 +483,11 @@ static int dsa_switch_lag_leave(struct dsa_switch *ds,
 				struct dsa_notifier_lag_info *info)
 {
 	if (ds->index == info->sw_index && ds->ops->port_lag_leave)
-		return ds->ops->port_lag_leave(ds, info->port, info->lag);
+		return ds->ops->port_lag_leave(ds, info->port, info->lag_dev);
 
 	if (ds->index != info->sw_index && ds->ops->crosschip_lag_leave)
 		return ds->ops->crosschip_lag_leave(ds, info->sw_index,
-						    info->port, info->lag);
+						    info->port, info->lag_dev);
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.1

