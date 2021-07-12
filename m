Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92D73C5F26
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbhGLPZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:29 -0400
Received: from mail-eopbgr80084.outbound.protection.outlook.com ([40.107.8.84]:42723
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235436AbhGLPZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDV0XoUPDvfUXJa0KqDIzQGApPaZ/8l+joXp4skiz02tOahXGfKTmrBEkhLNA9AAlzxWQM6t8wacnFxr0BvJUGidN6W2WdDrkUATzAPMgwpHYIou0z7ZUhbxaWYQZHAiHPWQugA40BFQKcFq9amqavETsHoy8qhWfwsUpvCS6YFhnGO3gb/L66R5Gin2gEllxvZYXltbAfUbvVuJuXeBpK+mdrYrIIBxErt6RJeCdfzYa0RKBpNZnXlTHv6OBTg4sSwRMO9m/5yNrbTTFAOeyaX7U95rs2vKMthL17HYXk1MWdtpJ/PAHWSpTaMye659Y4503uu9EYDpTbAl9QKObQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUkOP7QksTdvVdV7xF5imq5aam17tvE4PnomgW4NShk=;
 b=B5Uspd1mFokgun8Iz0YRIT9lphEtHCt3E9QNanjSg6FAbZixxgh5xslRvZxuebgJ3Xcx6nRWJVpXhHJCRCT2vLg/P4Ssi+nlEsOZSfsYeJZ+ZPeRcyMwm8X/fBKrSQQF6LqAlQe2aIujq6rOHW05h3QHlgOVftg2zeT/YyTkTrcFFmrdLI4ugg/Yb1YOHf1RZuvaUCUovRWfqqLC9FLbzOWCYo8hjY2/olYRW+drOo+OEE6mDyNFqG6kJFYpW45MCluamIacptnHzkk3Qiw0QZp+R2NrxgfaLWw50hnTCfTrenjHWRPGTYqjPLvdisCRRyS4XOviXyGErK2XzMWM/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dUkOP7QksTdvVdV7xF5imq5aam17tvE4PnomgW4NShk=;
 b=CV1+WPCNVsN7M4sOno25ko5DOvprwYghWT4jJPxZ9j6AMfffm51SKQMdkmgQFG9kxDV6DluXaxgbaBdSEoC0GgZ6J4fnlfY2az/jMJBxN24tdm8zCGpKr3RNRFVpXOUyRsgvmBhlbKHzOQBTVJNfpiQzDbb772ekw2UzOtNLF38=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6271.eurprd04.prod.outlook.com (2603:10a6:803:f7::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Mon, 12 Jul
 2021 15:22:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 14/24] net: bridge: unexport call_switchdev_blocking_notifiers
Date:   Mon, 12 Jul 2021 18:21:32 +0300
Message-Id: <20210712152142.800651-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c30bc30-4af6-409b-f6e6-08d94548dafd
X-MS-TrafficTypeDiagnostic: VI1PR04MB6271:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6271BA0598BA57F95A6BBB61E0159@VI1PR04MB6271.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUmZ8ToCVyUpCGTbleNOJHOwB8h2KEZctsa3sgjcsnwVTD4Hq+KA8xMcAnK8Kgiuxwllcyq7Wi6Q+f6uTGyDGoV0A8BoCJLhQyPy8HKVHatAt37rEObo2UJjJo9REJZABxhpnH24YpGM25ez9pLrjtj6m5c0OqGyvOigfQ0KNTthKCCQLgTsJd+8uxkeqg3KDly/0yfAJO4OfnJGI0w/u+pqcaZsyFWaJiPcRLfZGPu5nV7yHBtWJDViiMNEQkZnfwtljZPmnq1M5LrCjjPvq5hf/qW6Hf03iPbkHe4T/u840z9tpfkuO+3iml95a3SbYIR9LLJ5okppVmhhOppsmcyLFrASnvpayYtM3ONwxXQ6FeHcB5QziTBrTjIDj7Mr49FfDDfVlbeUiy1iq77CnBLzyZmENhLqOVkpcAy2AJ1qyyRCw8KMgyzUMJnW3cRkVLrFr7ARjXWyey+1bunXYkYNqkxvPb2Xofbl1TTSxReN9BtxFAnQEeO6+sOSYg+fD/sydMPeVdMqbWyCknird0QMGk67KwxplsHab+35iBqUyYQN4fB+6l8qod3vMupuzWbqvWTdTR8o2H/O+mHmV9cNCKvBaU/qcqRBF225QSxhNSWyGsgrtWM+u8LNdU7JcTQNbMYNEdf6M6UqjCIlBuIaaolB6ffcv/uCFYIhL7AUN+ss0X2KO6cMS0YUznNRYT6IepAnQbzu9A7y2daARw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39850400004)(396003)(346002)(366004)(26005)(2906002)(66476007)(6666004)(83380400001)(66556008)(38100700002)(8676002)(38350700002)(66946007)(5660300002)(4326008)(54906003)(52116002)(7416002)(1076003)(110136005)(6506007)(316002)(86362001)(44832011)(478600001)(2616005)(956004)(6486002)(8936002)(36756003)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Il71V9H5n2I8JOlseu2Jy5Bgda1i+M76RcS9sMzlM03SJHCMS79ukz8Btobz?=
 =?us-ascii?Q?KwJRrPjm2CIegF3oJaQswU1bQOqVWqyvGyXzDGNfsXjk5mfrKFaReclrcCJ7?=
 =?us-ascii?Q?fHV5gDjNMp9Y4asjaO9wbs0Xf6wto6JkGNsXvxPEo2csITzP7dYXcNuHckku?=
 =?us-ascii?Q?q7eYxPxWGKejg6rsBVOrfQzZWU9tUQBqvLM8xuIrv5KL0TAI5VTAsplEVfCw?=
 =?us-ascii?Q?rrApmFdEzYlW4aIBdsXQi3WNaUl4aT4ZJFJCf3IO5ztE/RQPK9ir5GSATITG?=
 =?us-ascii?Q?cDDEmj1kXas/o55ebbdbUN97HK/JR6O9PXh2bh+WOaool90gXzIV1qs/hp0d?=
 =?us-ascii?Q?h0E/qMuYuq4z7l2KTpfG7V2b9oop99UdpgXKPRiX8b5KvXyg7FdM6oMNc1i8?=
 =?us-ascii?Q?CVDo1liI7q3/cvgPFmntjw+1XXK8z+lHKjFMyqiYvcW01GgQAf6XFZT9qkJZ?=
 =?us-ascii?Q?FbPVta3BkXP+D1UJXxQ33VeIWtlm0c+uVHAPDdI1gma952UTHC6QREQiRThH?=
 =?us-ascii?Q?Lh9Z4yWDhM7OErd/sgYU14GH5lOn/Ovu95M/reXHq2sGfag7CG98ziCDUxR+?=
 =?us-ascii?Q?9yG4vKAP6CtJV6ZexZyTPUmcIYcjrrb4WYqUDn9wjkPXpUuFIT39ABG11cM+?=
 =?us-ascii?Q?v9gqAlT+F5kySpFjljL6162B9Zq5u2ow8cPu4Wfe/LaDlqIyuQb3GTRBWGwM?=
 =?us-ascii?Q?UkQOtUDCsfNuM6x/Eio/G7z+yxUxO6PTykfeTxP3jkbpskvkqpqDQ9YhKD7A?=
 =?us-ascii?Q?P/kLZjHRX03I8UfZUTcIOqylFIJ9vE3g4HxcnxYpl5Z/rwPe4mfHXa/egM3s?=
 =?us-ascii?Q?7Pb9hF3ey/9EXyIWJcWvPRwqLF61SQSBSfR715hQBv3KLJiDWsw93llQd0Z1?=
 =?us-ascii?Q?waeZ/ROxaSbbZDulhNdLmSQ4X+FjyMi6lW4h7scuC+h7QJnKx4EvzcZCrzHs?=
 =?us-ascii?Q?6+t5oPyr+pjJvNDktjeHBqjthHF10GNKaLv6HJY0//8Hd7fm18Eg69hXNeUd?=
 =?us-ascii?Q?/fLL7rI3ipDQ0/xwmzdrKkmBdT3c8zuopMd9kZLp2A6ZMq0mTPrz7Ft8W48+?=
 =?us-ascii?Q?Vb3I36iIRjceuWzH7LOauTefU2spEd/hRiiKo8DwyN5q9p4nnGcHyGQeXXtI?=
 =?us-ascii?Q?ykVPJjor/sD4Yp+y6r/x7/zEFr30/cEJq1Sbd2rfQdTGiGbPFmOMDs+CGiji?=
 =?us-ascii?Q?9ZMReuLV+RBfDS++0YmrUyYGtzWGrF+GbedSGGwnm+r6J+YboZpmL2Olw8C7?=
 =?us-ascii?Q?vN7ew83xTNQPsuUawzPeNHII1zLtvqnMnkANwl00SPpw06whfx6pxuFn7mBr?=
 =?us-ascii?Q?tP7HbCX5Nd3fjBazHFYMK66I?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c30bc30-4af6-409b-f6e6-08d94548dafd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:26.5243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gChXhlDjZm7O5JkMGIsFcVaD1jmGHjGC6CufUK7qhe7GoUSihdy/fw2QCNV59bSr/A7ahiffcgllMRi8k6trZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As opposed to the atomic call_switchdev_notifiers(), the blocking
variant is not called by anyone outside switchdev.c. So unexport it.

Note that we need to move it above the first caller,
switchdev_port_attr_notify(), to avoid a forward-declaration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   | 12 ------------
 net/switchdev/switchdev.c | 28 ++++++++++++++--------------
 2 files changed, 14 insertions(+), 26 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index e4cac9218ce1..68face5dca91 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -258,9 +258,6 @@ int call_switchdev_notifiers(unsigned long val, struct net_device *dev,
 
 int register_switchdev_blocking_notifier(struct notifier_block *nb);
 int unregister_switchdev_blocking_notifier(struct notifier_block *nb);
-int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
-				      struct switchdev_notifier_info *info,
-				      struct netlink_ext_ack *extack);
 
 void switchdev_port_fwd_mark_set(struct net_device *dev,
 				 struct net_device *group_dev,
@@ -340,15 +337,6 @@ unregister_switchdev_blocking_notifier(struct notifier_block *nb)
 	return 0;
 }
 
-static inline int
-call_switchdev_blocking_notifiers(unsigned long val,
-				  struct net_device *dev,
-				  struct switchdev_notifier_info *info,
-				  struct netlink_ext_ack *extack)
-{
-	return NOTIFY_DONE;
-}
-
 static inline int
 switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 070698dd19bc..7b20b4b50474 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -22,6 +22,9 @@
 static LIST_HEAD(deferred);
 static DEFINE_SPINLOCK(deferred_lock);
 
+static ATOMIC_NOTIFIER_HEAD(switchdev_notif_chain);
+static BLOCKING_NOTIFIER_HEAD(switchdev_blocking_notif_chain);
+
 typedef void switchdev_deferred_func_t(struct net_device *dev,
 				       const void *data);
 
@@ -32,6 +35,17 @@ struct switchdev_deferred_item {
 	unsigned long data[];
 };
 
+static int
+call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
+				  struct switchdev_notifier_info *info,
+				  struct netlink_ext_ack *extack)
+{
+	info->dev = dev;
+	info->extack = extack;
+	return blocking_notifier_call_chain(&switchdev_blocking_notif_chain,
+					    val, info);
+}
+
 static struct switchdev_deferred_item *switchdev_deferred_dequeue(void)
 {
 	struct switchdev_deferred_item *dfitem;
@@ -306,9 +320,6 @@ int switchdev_port_obj_del(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(switchdev_port_obj_del);
 
-static ATOMIC_NOTIFIER_HEAD(switchdev_notif_chain);
-static BLOCKING_NOTIFIER_HEAD(switchdev_blocking_notif_chain);
-
 /**
  *	register_switchdev_notifier - Register notifier
  *	@nb: notifier_block
@@ -367,17 +378,6 @@ int unregister_switchdev_blocking_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_switchdev_blocking_notifier);
 
-int call_switchdev_blocking_notifiers(unsigned long val, struct net_device *dev,
-				      struct switchdev_notifier_info *info,
-				      struct netlink_ext_ack *extack)
-{
-	info->dev = dev;
-	info->extack = extack;
-	return blocking_notifier_call_chain(&switchdev_blocking_notif_chain,
-					    val, info);
-}
-EXPORT_SYMBOL_GPL(call_switchdev_blocking_notifiers);
-
 static int __switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
 			bool (*check_cb)(const struct net_device *dev),
-- 
2.25.1

