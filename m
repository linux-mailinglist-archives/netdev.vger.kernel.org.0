Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA394C14F0
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241318AbiBWOBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbiBWOBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:38 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E432B0E86
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jO0ouDZyQ7aNcC9Rm3XYSuhYSFMRu//Y6ydPRVFYRNCNYgEofsfBh13sALxOxR2XVDicCGV9/rZNZDimj6luzos/F4aS5LPlOCNDWrZS41b4z6Awdgm90D55QTIadxR7tc4WZIj+N+pRHW1MxkowzYuL5JUxz5h0FtKpKfJr2zhL2vMh+WCWK39m0l0vc+VbEP6XrB+d8IukHCoYKeoSS5S8eKnV7ztll+8UL8k5zM/Lp/xJShfOXNjnVdB4UrVN9ZpE2/8EEyJOEnChpbuh6d61Gieb6GTwqENOZMkrY5JplBjap82+YeTMn8+aRn+B7Bn8j1RLqvIX1I4g2O0ZoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NLFgScpWwieisALhH+aw6uYuWV2BLS9fYBbLRfmGDIw=;
 b=DSKEUaGIKSstxmICT8tH3Jly0nc/yexpR6l7s55z3mwUH3fVBsMMW1ceCo0BNcBjjN3uh9ezRTZDYpD75f/Wuomnzq4E1zuNJ6bMaP6T7aE2V4uUr7jeSn5uiXjEd2VW8dJfuIggIIXX9QfuJ5Nod4izL76rk4mSgx8rBreit/cy00eqHrfb+jqCk+laa+89S08h57UbXNDBH77rGon1THLk4WFJOQJlK+1ynyPBjDPlZ6B+IqbDKJPbhjwgHLjVRMBATiP9lOFRuRYXhFOZXZRaaTFZ3uJj+rpRxpV/PMnqzOsYJLNYpHWkCljEtKZ0tSlkS85rkAIKXThWgjLbaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLFgScpWwieisALhH+aw6uYuWV2BLS9fYBbLRfmGDIw=;
 b=GceZUyzxPg9rbtG2uTUNdS9sIrdBkYEs99hyL9SPi/RsD5Pw8Z71don1iLFUHOEcEsrIPPBpsN/kZpg7m9IBWl3vxoTSXuLSjeIiVH+Wzp+spIk+eHowe60EvdFwjihGyxf47rMffbyp8RO/njJxgcbtBFx5YTdlcT72rNS0Acs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 01/11] net: dsa: rename references to "lag" as "lag_dev"
Date:   Wed, 23 Feb 2022 16:00:44 +0200
Message-Id: <20220223140054.3379617-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1622b48-a8c0-48fb-b5c0-08d9f6d4eefd
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB870126A3ED6FAC4BBEC6EEAAE03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cy9WZTRjp+NxiWXgLRMohVZ/AA8xnZ3Y6002Sem5j/fd5HtTzCfYkQekUDpLiIy9i2mV7TTkPK4ChcNC7lhl9hp61Xuxd7BCTpqICN7CSDGvwm7Wlh+a3CCQcMhs0wbyRYNh5jT+ACze7CF18HHXu2wrhC70HmVTaUT4jpZfu4Ru0Yp3ldxSjpV68ismnedhHBD6HTb2BY31+PFUVERvBe4VsuK1j8YtnDXb/nnjFA5B/dJXiRNwFtW5r4J0IeQqiXSmQBBkXTG2JKwrgrnQnqAubnN81hBhrAe/JtQg2Q35YqAGn+Pi+aNGQBLwqg8r4U1sehVSX+RT+b6hRukbjRS+Xu0g9LBq14zEgi3W/iy/vJOfgIe4AJfq5qfFVCnB3ebXGqzj7mISpBV37SJQDFHv9KR/4GkVe7kn5dcWnFJPPIj4W+1SDCf+cY+Tjm0CghmcCjtecShyZpyZ+T0XqwiREp/22wnr3smsYLil4pt2Ml+QggokJvNyuAkBumkHizjUsl7cmcWahDFgch5JlrJBijvqMZMpVvpBTAD2rBBdjp+nMyV+VHdm2NltHwTRyj4540adlMo0rac4+aEU3Ts4Jo3d1Vd/i3+e4twRHfHjxk0q1DFn9h2sTTcxZR9eKSnuWx/1TFozk3pVTOJXKeJzBtJmAnkTiyoUVJuC1ptWIxfQFY5wcEWleqJdVgDFU+MdGMtacnPUgcJYGeRJ4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(8676002)(26005)(5660300002)(86362001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c6ztClEf6tyxuo7iwWlLkbN2YHug+DacXb2ObXpChb7FZ0EOZEDy0Jjc0jj5?=
 =?us-ascii?Q?dpv3Yf+8wlNKbVhsQ4qyHkNe2S4ZukCTWi3pBmFMoLjWJfM32tY31cW5YB/T?=
 =?us-ascii?Q?J7VNEpnCv/vDCiqoG/e+qbzY3CciAw8Mm7mdJch+JVS/cJMY8q3jpYz3ki4d?=
 =?us-ascii?Q?LBZDsBpKL8FNpqQswt+tjherPhQ3Gyudl9KAKrWGHCEQpEBCQrdmZJjBjzpf?=
 =?us-ascii?Q?Ejy4ZnYvG5AWM5m2KWW5LGUUIpvdWYmwYD5FYzIqwUgIX7yHjWT88CFqesFi?=
 =?us-ascii?Q?p9D3uREMx0A+P0fdB2hrTfg5aTgull4UjZlgtQ5yr0WV+QWYNbZoIkLYD5U7?=
 =?us-ascii?Q?wrjbfBIBup8bNz0Ew5DR7CDEMhOz+HGffqcW1LfnI9Gvfjjo860IB/F7RupZ?=
 =?us-ascii?Q?ZiS2drTualwHL17Gbq6J4er64KeicfyNO8iMEAuguDupBsJoC9rcBQ2LEg8q?=
 =?us-ascii?Q?bGIjZhpj68GahJrkOY/BQqkhRD1JS3BwcbJtGS1QFw931KawEFdM+csYjwvQ?=
 =?us-ascii?Q?AaBjZEa780b4Wn/P5AvSBhbiNqiVAm9KqBEE3CL60srS7TTSa4K/umnveUru?=
 =?us-ascii?Q?6YL7UjfWs+/MoaZNCMO0oGgtbnzhROdO3PN7xAHvnmm0evWE4C8Veswx8nys?=
 =?us-ascii?Q?ICRCFpR5ZSsgfJieHM731FFiI4ynKMMZ1QJYscVud7ocHuruYBkERR7cEK/Y?=
 =?us-ascii?Q?68CLtDcUrbixImTCfmsRZxUnj7gZ7ITZZ39NU0jlYQ+PuzUkbG/6+AbD2Xs5?=
 =?us-ascii?Q?86HjveQuGiqbN2Xvdwx5UoUBTd4pNnVmgUquxXs9PJN2tqXrn7OzsUgiKx1a?=
 =?us-ascii?Q?6AogmMqXaQPsYXgwmbpV+gpbIYaq51u7zvoOVS744FXAo6qP/eUdhAuKXZj0?=
 =?us-ascii?Q?dhMwjG+WZVyksz0llMXqpqxY1LD/HyioEEaXh0U8oVYQ7jFAZTEOWwrbZLAR?=
 =?us-ascii?Q?cFUDaOF0xwFd9MypMLRU5eLAPbBoGMDujxRen47pnCwKySSsNrmVbmMni9eA?=
 =?us-ascii?Q?Ohz583h5hK1QoT4xtOvcxxsmX+yx2vosspa880OYCv3FvHHxhY9Xn3FnISeg?=
 =?us-ascii?Q?/HubokxDQb2T/NNOUZXpDLdhIxxYcSv+kgo2K4n3eeAOsIwrnUfXzMv171Wl?=
 =?us-ascii?Q?fL7gGbB60AD8Hqm4MjYg7nmwZ5UB03EQ4gYbmCvoap/eVtyFWzzLwj90UAqS?=
 =?us-ascii?Q?H29MgXXAnHl9gh3PjIepyGffxK0/hVtz2+oPafgw1HK3n2IumtFQiyFp77Zz?=
 =?us-ascii?Q?wLisLxZji+wYZnC2Ub7sOKi1zfQZ+S4KcdRUGEHqXq4uVr2WjNiaRn4MFSJH?=
 =?us-ascii?Q?/XmtMiOUZEKCb2Yb3RBHSLv9WyL8zGo16F5BPyZ0PSPIxqBU9DSzzMNRaopZ?=
 =?us-ascii?Q?HBCxrkn9jcVqLxhGfJgdXJSLLRHHxvd0xvjQ/K656Y5WvbwCiJgs/AYb3J0c?=
 =?us-ascii?Q?TrKYHhW1sgnf8ChY0IoaZHdAoXUYlh3RPwyBXPX7UQ5Q36UMeCRVBwBd4y0A?=
 =?us-ascii?Q?heEwIitO3ig2gPnJSh4Vhku5Y1a/mSu6IEEF38BgaWn0BArYRzUkENzwrESx?=
 =?us-ascii?Q?+1Mj0Mozhc6Izxietr7AY9ST3TnG1ovp8vmQUglrb5819cEJMYA+u6vBasqw?=
 =?us-ascii?Q?5tT++vpoEhEaMdeZYxhi9/Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1622b48-a8c0-48fb-b5c0-08d9f6d4eefd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:05.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CrdxTKm/mXXBv5Ivxs+CI6Audp03/9FXlzi6HvCtdEX15hAK+eESTBYUFCadcO+vsZhxdkOZNnxitBlx46mNFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 include/net/dsa.h  | 12 ++++++------
 net/dsa/dsa2.c     | 16 ++++++++--------
 net/dsa/dsa_priv.h |  6 +++---
 net/dsa/port.c     | 20 ++++++++++----------
 net/dsa/switch.c   |  8 ++++----
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index f13de2d8aef3..ef7f446cbdf4 100644
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
 
@@ -966,10 +966,10 @@ struct dsa_switch_ops {
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
@@ -1041,10 +1041,10 @@ struct dsa_switch_ops {
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
index 408b79a28cd4..01a8efcaabac 100644
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
index a37f0883676a..0293a749b3ac 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -76,7 +76,7 @@ struct dsa_notifier_mdb_info {
 
 /* DSA_NOTIFIER_LAG_* */
 struct dsa_notifier_lag_info {
-	struct net_device *lag;
+	struct net_device *lag_dev;
 	int sw_index;
 	int port;
 
@@ -487,8 +487,8 @@ int dsa_switch_register_notifier(struct dsa_switch *ds);
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
index 66dd2621cea6..fafe019dd02e 100644
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
index 0bb3987bd4e6..c71bade9269e 100644
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

