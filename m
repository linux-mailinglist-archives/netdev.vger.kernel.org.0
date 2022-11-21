Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE51632478
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiKUN4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiKUN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:36 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238F9BF801
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNAcYAJoZS7+A+mAoiLTQ7Tn2xxc2phn7Z75tyvqARDbuvpw+pxva4M4QGYHhbO3b16L7nxBOCZIYGNhFUeT2HmoCx71ZmSb/yQNl0/mPQUU5sg1iI8FRB8og29faTSiiL3mMbvDgq0UyrlEN0Y4criG2PAaZ7iMpwCBDlGgmjWw9VLryyzU0/eWKe+82Cpp17FquhUMb0dQpVXJNSqiwb3+KdnMqPsJSgoKKXuWfJyX23R9Jj4MAaJ5aC/gN/nujDW7orsMtP/5lgkSdyJChpx9HOD431vImVaFTk5T2did0/+rUaUJYelKrzDKSA+LOil9KYmS0n7O7LBcX8lhPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjwtxddB8a2mhSXj0OduxBQORHDOCAQwG905wk0JL04=;
 b=TRFm5yhs30fJukpRlldzphxPBDutR7eEY/i612fzwaNFQUmBw650xB7iPk2gvQGBT9jNtqpNSDwLPYHUqVas9MJW6+SUz7IEAwFRBoy9rH4KvLS+MBzw3nUryN9hFDux6P2xgLuGCcU6RtQBp7ylSW8Z2923JAK7PSzqL1a22XeMeo7xbHBxezKvDcb/PhDiIkzWI42j+cwfyfFq08IIrZjNuqJpdR6KgOrHg9q2jrMtaqPkygJ5Vj26KEyQQWPANn2FfUajj+WCDPcJaInf0yZp5Lf7hHx+nqBIXSxMk3K4nsr2mj9zZF2Haff8cykOdkjEVRLdlTDvaRJRc8EcnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjwtxddB8a2mhSXj0OduxBQORHDOCAQwG905wk0JL04=;
 b=JRwu5ND4nhtHHgfhcNif004QSFvPm5nkrN7Shha1E3FhfBWZyMt/WSol42C/TM11cSxozxMm8QHIKWfTyjeKbBV7DHXijyPgR8IzY2maBFJY0uE5HEV3uOv6wPzMRdjuOTlclSS+jJ5MndT042gphH/6mLWRNltEMjQSZzYIYqA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 11/17] net: dsa: move dsa_tree_notify() and dsa_broadcast() to switch.c
Date:   Mon, 21 Nov 2022 15:55:49 +0200
Message-Id: <20221121135555.1227271-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f958f58-d5c1-4208-2b77-08dacbc82ae6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //qCkf0MFPXkMaGCf5ehBa9yW8UEYuIkCp3pO/7aJr5dOkDseGTeqnAgB5cND2bbB/JzarFGcXwUzHYL5qsL/lYKtdHEYlg761Y162ZI//Yqj1/JyUjo7CH8bX2jbs14xsR+RDAVKLCt1xL8dBCNYrgE3fy2xpaYBj02hVs82afSV3ih5fojEAtlH9CzRyLhtCYaNcaCbH7HsjGWrS6GiLUSZTrRU10qe129cuTOVrjVpc3WGOoeLP2oOBMbdcXqoivXzqa93NOrFodfHhCDlkClihNnogi3rcMWRrYsQyC03lBh/WBNb1vwLIbIiohSAR/7h0akD2RWZp0nXgmVCFL4/pT7++pMMws69dDcSgRlfL6BbXEQvYepkMjwY5Z6+c3RRAp1uDO3ShD2WNw6lxPsKYFiKoMKKbaDOypah62lfWKcJxnIknB2vL3fTeRilaXMDnUdpvYA76q5Z2HTGit0R0iygOqZp2uwTNCNvSDYwqJkSZzhJQpSwQ8cVzToOheQty/OJZuIjd1jEZjbLTsflioDEfDgRd4YFh9IJ8H7AL9FAQD1A34jcUKrrlPq5A6yTmJFb+LYq11gevwhuHmbVMvbVpXeaERwwqSSuE3d9L+o3G1+8RxFJR4KLpCP/JYIMRRtQfgJlq/fZrrUSud/MjFF0pm7EvnkL322P/LYSSw+1AeqEt1BnA2vc06Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pQQoQSCLKz+Fpd+QfvorLdK2wI/Wy/pEpwmUqmuE521ZpHK3f5yGfb67NQhq?=
 =?us-ascii?Q?azRAGsUVGYVgbEvEvMCp9OTBER9R7NcD3j4SsC+v7y71LQsqB+lfWnunLaAx?=
 =?us-ascii?Q?J7FwIt5Lo483ETT8F7KSXEE7ottayJ2RCewNcJogFrPLloS/PJS1VdOoJUqR?=
 =?us-ascii?Q?5uoGyum6K71jgaivAR/gVS3/TH6bHKvhYHn3XYk8EniXu9WnMMikXyXmgXAu?=
 =?us-ascii?Q?gY2EC8HHofveKNrS+JGGAfWTrl9l/9tYUBPrp5wbnxSUcGtridpTvtta4vKN?=
 =?us-ascii?Q?613InOxWJWnxjPMceQ1VtO4FhoRYfuDK2l6LBZdPs4rIDAQMG2jYLCI7m9Kc?=
 =?us-ascii?Q?8UUu1VGVaIp/Bw1dPECHEpbZrcNzKq9ASk5IMiarYpVUmWy4lh+UJ6cuzX1D?=
 =?us-ascii?Q?68e1TNjBn1wfkzw2lOEnPtkTgezfUaXXx+wxiDfTa/a+OWXN+j6zSkun7fBw?=
 =?us-ascii?Q?aXWo6s4UnLbby4Pc33U4eGvb4a8Ngmw1oxqRJA+rU7I6BMojDR2Mwzisw2Il?=
 =?us-ascii?Q?1e2Ub/n5GLCQFSBuymb0TMufdNLZagASx37g2LpJADbs4CyaxMh0LWQi8wJ7?=
 =?us-ascii?Q?JBX7+o9Y6KIWcG1u7QiUbPor4u28rXmtDE3d87lzMT5MOP/BqiZ6KLneKIkV?=
 =?us-ascii?Q?e8ZRI+gEH7CWulI6eGQwXjCjaaCIA04BHU3N5u1O0RfAJq/ZF+jnZwWWXwAi?=
 =?us-ascii?Q?m6UqP/n0ot3vcu2HPcOQ2Gvw0Ah3dpsiWFSingmZqiPpmezxAaIHIcyLxMpY?=
 =?us-ascii?Q?fJw6Xyss7DTZ/Ab/UzI+BLX00q2DtHeS7Pqgtf4G+KupR1VWo/7f4aNjQ56q?=
 =?us-ascii?Q?UCjcRAyD4Fqr0QJ8uJadtIhBCymhYZITOc5yEde15jQ881/XgopYqzuiMX0m?=
 =?us-ascii?Q?y1gQC8UY5/oQtvkI+saFreFxrc9Rh1yL/fvdAYMZdyETaGE45KNp6NhWMWy8?=
 =?us-ascii?Q?qmI7BN4uUCVQwdeQhbYYX8cwGvh7wfiyPQkNOJzrVqe5UOEgEivjs2XBCxvm?=
 =?us-ascii?Q?zwMX9wL4ANE/+PtVXYZcHbF6kdVAw7ThNYcB1qst8J3iy77ATdPX4Ok81F2W?=
 =?us-ascii?Q?Jrz8OSzk9n1azVr0tcafE5/dhndKmXGK8dqnJsZLrc+JIbdE510BQ1GugvAm?=
 =?us-ascii?Q?0ND2LtwjaO9uz4x2os3VXAtsBe1FFbnKI32NsZX1wYGTu4KSk8ZkrhT+VRq7?=
 =?us-ascii?Q?CKspuXlGk7ribxV78xGroXDjLKmGK2x6+sJwN9lTjUMMB6gSTJtQM9EXJvnt?=
 =?us-ascii?Q?P/pCJIIUGkCWfVUf7vAXTzpsJyFW6sbx2xqWWKwUjccr9QDyEgDW5ymbe8bv?=
 =?us-ascii?Q?KrVt9Sg9PHo4Uvw2ms2Y9PIrZiwyIQczWMK/ZksBSqNy1NFkO7t1hAvkjUKE?=
 =?us-ascii?Q?DFvhnDLnL1Jj1O/UUXpJaJ2b+d16i77dM0k6ZWdrP5jT7elDupLWyvci8TlE?=
 =?us-ascii?Q?pfQ5jN2d5dwkwd0tYd/aCOhoIub9OlyF6xpvnVuLkSXxeC83maxKMJZ/fYFv?=
 =?us-ascii?Q?yT/dceucKBlca9uTgf1mRIyqNs8ydoQT2JxaBF5wZ9RHih9rlzaEmvxK/SON?=
 =?us-ascii?Q?ydLgR+Sb7DcWPMM0xEzf2BPfil+AvmJU/5IYmxjsjgshoBfjtX7wyHDJHbrQ?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f958f58-d5c1-4208-2b77-08dacbc82ae6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:20.1221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYQ4IBA5+EcYBX0OS7Vv/UKJCNvr5k4J+COA1XWoMPXSRIkE2kqrd1xHqYBQeX6y8ygjk9b/ZAhGytkj8KqHyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There isn't an intuitive place for these 2 cross-chip notifier functions
according to the function-to-file classification based on names
(dsa_switch_*() goes to switch.c), but I consider these to be part of
the cross-chip notifier handling, therefore part of switch.c. Move them
there to reduce bloat in dsa2.c (the place where all code with no better
place to go goes).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c     | 46 ----------------------------------------------
 net/dsa/dsa_priv.h |  2 --
 net/dsa/switch.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/switch.h   |  4 ++++
 4 files changed, 50 insertions(+), 48 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 7c6b689267d0..7a314c8b3aaa 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -31,52 +31,6 @@ LIST_HEAD(dsa_tree_list);
 /* Track the bridges with forwarding offload enabled */
 static unsigned long dsa_fwd_offloading_bridges;
 
-/**
- * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
- * @dst: collection of struct dsa_switch devices to notify.
- * @e: event, must be of type DSA_NOTIFIER_*
- * @v: event-specific value.
- *
- * Given a struct dsa_switch_tree, this can be used to run a function once for
- * each member DSA switch. The other alternative of traversing the tree is only
- * through its ports list, which does not uniquely list the switches.
- */
-int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
-{
-	struct raw_notifier_head *nh = &dst->nh;
-	int err;
-
-	err = raw_notifier_call_chain(nh, e, v);
-
-	return notifier_to_errno(err);
-}
-
-/**
- * dsa_broadcast - Notify all DSA trees in the system.
- * @e: event, must be of type DSA_NOTIFIER_*
- * @v: event-specific value.
- *
- * Can be used to notify the switching fabric of events such as cross-chip
- * bridging between disjoint trees (such as islands of tagger-compatible
- * switches bridged by an incompatible middle switch).
- *
- * WARNING: this function is not reliable during probe time, because probing
- * between trees is asynchronous and not all DSA trees might have probed.
- */
-int dsa_broadcast(unsigned long e, void *v)
-{
-	struct dsa_switch_tree *dst;
-	int err = 0;
-
-	list_for_each_entry(dst, &dsa_tree_list, list) {
-		err = dsa_tree_notify(dst, e, v);
-		if (err)
-			break;
-	}
-
-	return err;
-}
-
 /**
  * dsa_lag_map() - Map LAG structure to a linear LAG array
  * @dst: Tree in which to record the mapping.
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 4f21228c6f52..8cf8608344f5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -175,8 +175,6 @@ void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 				  const struct net_device *lag_dev);
 struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst);
-int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
-int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 			      const struct dsa_device_ops *tag_ops,
 			      const struct dsa_device_ops *old_tag_ops);
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 6a1c84c5ec8b..b534116dc519 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -1016,6 +1016,52 @@ static int dsa_switch_event(struct notifier_block *nb,
 	return notifier_from_errno(err);
 }
 
+/**
+ * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
+ * @dst: collection of struct dsa_switch devices to notify.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Given a struct dsa_switch_tree, this can be used to run a function once for
+ * each member DSA switch. The other alternative of traversing the tree is only
+ * through its ports list, which does not uniquely list the switches.
+ */
+int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
+{
+	struct raw_notifier_head *nh = &dst->nh;
+	int err;
+
+	err = raw_notifier_call_chain(nh, e, v);
+
+	return notifier_to_errno(err);
+}
+
+/**
+ * dsa_broadcast - Notify all DSA trees in the system.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Can be used to notify the switching fabric of events such as cross-chip
+ * bridging between disjoint trees (such as islands of tagger-compatible
+ * switches bridged by an incompatible middle switch).
+ *
+ * WARNING: this function is not reliable during probe time, because probing
+ * between trees is asynchronous and not all DSA trees might have probed.
+ */
+int dsa_broadcast(unsigned long e, void *v)
+{
+	struct dsa_switch_tree *dst;
+	int err = 0;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		err = dsa_tree_notify(dst, e, v);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 int dsa_switch_register_notifier(struct dsa_switch *ds)
 {
 	ds->nb.notifier_call = dsa_switch_event;
diff --git a/net/dsa/switch.h b/net/dsa/switch.h
index b831b6fb45e9..b2fd496bc56f 100644
--- a/net/dsa/switch.h
+++ b/net/dsa/switch.h
@@ -3,8 +3,12 @@
 #ifndef __DSA_SWITCH_H
 #define __DSA_SWITCH_H
 
+struct dsa_switch_tree;
 struct dsa_switch;
 
+int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
+int dsa_broadcast(unsigned long e, void *v);
+
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
-- 
2.34.1

