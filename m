Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828585987F8
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344124AbiHRPut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344105AbiHRPtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:49:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66B75725E
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcA+FdkXKGEQnioOjkjnFZoyXLLmd3bH7CJCXK9+GnTMIcL/XkF6w09+Oc6QZEifg397vUqUAlEvaFB2Fp3VtyZXGQQ6Y9XbIO5Adb/A/kTPcsMg3sD2L5r1ab8RZ7w4eLIZaA7Tii46ahBzCzP0P5+B8+4pOWkgQkL0tRECgnF9I/fw36+4RzF+2m1mt+qbQnkp15ViEAAHR1k7v0wFn4Q8YiERugdTCk971WYnSKi0OziaRYSvmsjPyX9KjAI7vCiMLM7Dby4pMJGzltILegWsY2vXyfnji5Gvqdf5T3t/BUUqvbhiAJtaIXO+5ZmmAEFh9L3xBo56Ftfi8cjA9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aF6ctK78JFsvtuiko4tObDUoPZ3RBY84jnvzVRxB/8s=;
 b=RGeW0u65HQcUW0B6SvFOYOtpQmk753QzGB1M3CdCWy53l2OAf2oYKiwKFSxBK2FYNEt+ruVC7WvO6yBt6a23MtzHQtBz15Dggo3h32c7n6BaMatGCIR0/W0Km2gMxAv5Jk9pb72XOzXol/M6AUN2ohSG0uH4dbWJt0XWKXkH4PR3ldV/5fjD4UkLLUtwFCD3/A8dWFImgGwmVK/hoxmb7KiRns77W5dgzZRZ9h1JzmdfI73PwgWDF1OWrtuZUYqQHt9J5EddJ2GNzfgvQY2K+n8SWuYbRUyC2weGlR1C+vAuFv8Hv/26XkfnzF28g0zFo3DNGlJRO7SImkXy6q0x9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aF6ctK78JFsvtuiko4tObDUoPZ3RBY84jnvzVRxB/8s=;
 b=JSbPbieuFgMQvflfqiWdyTqg62gmOnsfdWaGfIRGuyW7kmkWs5c1vQkdmKEb7Bs7Pl3h+xqx+XSTSnxd4qZYuVje4nsCp2SgBHy9hwfvDgOQn5orJOMzXqiZ3xmpU5b3mpJiSubVgKWCYRfpksqGd0YZmpEjhyIdPdPu49oBAnY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5648.eurprd04.prod.outlook.com (2603:10a6:803:e5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 15:49:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:31 +0000
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
Subject: [RFC PATCH net-next 04/10] net: dsa: introduce and use robust form of dsa_port_notify()
Date:   Thu, 18 Aug 2022 18:49:05 +0300
Message-Id: <20220818154911.2973417-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 215a5444-3cd6-4ae6-eb02-08da81313db4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5648:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MME41ucIO0l2LnJnKM2zHMLAmCtMEVd/oNjMSZqPb7mAav9e3sbdrOVAesr1TWdjVpxZyw+o4+HnO4JppEc3q9YJAKWDiUl3e7PjBqg036zDdJMgNA+MPdzPd8r3VUfCvGoNLGPnpeplkfI/zq8bRnnC7wt+zZOjXIcVZwDQmapdjs4trCSOjWaE2ttDhxbXsmWlN7W5K9ayOqynexvfqKYs5daB2d78702tIeiFbqoOP/cWYUiHfFdg1dxM8O2r3mjVY/8D43lWyNCQBtVUnHabi0XFo3f08xmFAnn4VwjimnlDuvDPCmA6UNk6Bdq3PT6cEsSH+m3oOL10ImXhT2mYfMCYB/PUM/ysTvhi2BUJQUpdeH3a4xbi0fOMaqS2BPfEWoNFUZ87R6M3XOjLvgMHXc0NqIkw3J/WeBhQpfuZShQ8lg8ObC87uTMo7d7oGQLMI3KoxJaJXd0j3xTYiM8nzDrhOH1dciRw9rh4e9llFokGF8DmgytESkNkznuD02icjC7lB/CH7ujQ9JVfvV96YxtA1E/8A4pnXmNQxLdesy6A5CkBLQuCS+2Z1ijzmBNiXfXfzCYGsAHhZEQNMYviQZnjmds2lhqWmHHrq8c57ySlJ6WyzzBqNqeQksIg1YVSR/P1jVmqJDEtJ/EIWGZzHRMyyXO0TnBO2UUa0ovUVQg7e+fjOrZRdcb4gD6AM3/6nSULPm6BGg0+cjKividf8gK23SaUfrQ2/WrnZtC3hgM5jrSEcfnoyCsJGBMwdBQuKXLd37k8BBqbD223Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(136003)(366004)(346002)(6486002)(478600001)(38100700002)(38350700002)(83380400001)(6666004)(186003)(2616005)(1076003)(7416002)(5660300002)(44832011)(36756003)(6506007)(52116002)(2906002)(86362001)(41300700001)(6916009)(66476007)(4326008)(66556008)(66946007)(8676002)(316002)(8936002)(54906003)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ACm+fwz2MGWCKGzPjnA2jAV9H6ycAUFIZxqSmer8q8Q2Kd6qH2hdYt2uM1DA?=
 =?us-ascii?Q?QIeHNDJUkyvqtblmBORZp/nNQz9zHZygKpjA+89V+qBVvP++F36qSBRR6hC0?=
 =?us-ascii?Q?tYWidS68uSWb0cXsQGeOG4pzpdSuwvclnlOtsp9XSztp56B1sEMBwrfZn6+c?=
 =?us-ascii?Q?nK3AZ217nGkMPxyegD10x6vlwlR9oPviqmggH1fk5moGVRZ7jS/nTjpkYLCL?=
 =?us-ascii?Q?K6Nn06QQR4wIwWzv2RqSCCMWxrdFgIz7eOtMq2NyK/j9IvhIBo9scgzlm2gL?=
 =?us-ascii?Q?NCjtxu65V2K4opRAL6xY6vzMfp4GHahZobfedBKxBHMDifdupkUcmzz/5ozU?=
 =?us-ascii?Q?C/VlI09c2vJcP99bkfSzgVvSfTi+Ck6HQ941SX1r/IkXChYSsuHi0bADQZKv?=
 =?us-ascii?Q?YdpDwwPoimHJ8cSpgkFjcmyqcGYXlLDjpOV/5RPwgVvHoc2B82likaGPilJa?=
 =?us-ascii?Q?Ac1Wr5wbw5ov78Q00JQJwXzMDun70vqKhqCNJJQJwpFynb2yFdivS8isbL5R?=
 =?us-ascii?Q?rOigLKKbIcdUtb0ZA6A++ObxJ0dzVGfbUNuZvjq7Fp+Q7a3Mq1ZqcPIjv+Fv?=
 =?us-ascii?Q?tkmYgWyrSbvmMkfVR5MAlFk7zLJ0bha/fh+rWgt1M/9DYYkoTiVUyRFEO8LI?=
 =?us-ascii?Q?IyQ+gmVeG2UqiUyq00yHDYCY/qezrPQBEf6D6BwuGH1fYSGBFmW0mRgjK2+s?=
 =?us-ascii?Q?ET/c3+lFR7dpTmtAh2Nd0vFpE0ZBcSDCUznZMrPH60pRd3e8vGgq/QM3Sd/F?=
 =?us-ascii?Q?f6m+3pFn5m0+eDtHYzvdews0QkLXEikbvjC2tsM5bmuGV7YSvg+tDROSBVo4?=
 =?us-ascii?Q?HM8orb9yivuLd0iN+A+EaH6YOv5q/hwbAIoHvcmPao3ZWMFIxl7avFvYz3IQ?=
 =?us-ascii?Q?m4osgWfJqcuhxcaXJdpW0PCPXm1hJZk/mh5BXi00xsS4XtrI78Ewywz2o0Bz?=
 =?us-ascii?Q?4LTrFirTbP3ezWxS1/0buE6R0w3JMj0HUX9HCkheXty1NbN7oww0eVaBY9tU?=
 =?us-ascii?Q?u0tGL1x455X7W1iw7lTe5+E8WTRKizdNZJ84DYlgMpbaagowQUsYss2dQf4x?=
 =?us-ascii?Q?j1ajxyxjROEaU2ILUsVhwSPG/KcrzzA9YF6kLTqf5VmUyLHIZT/RzDiNYXo1?=
 =?us-ascii?Q?DJ88vzEVWKYI3BGnrlgp9XC9ZEPYY3RcIIXUg68NBzuiX78vn3pQvp0kR7Cz?=
 =?us-ascii?Q?DXsIyHHjYbsaqdn7DLaX0CS9YG3SapxNKL2eain09rVdBggxjDt8ZvW1JIIY?=
 =?us-ascii?Q?nRmI8Eu2aX7au7etPqviIFt4y/cSAHuL1meSMIeUg3HrnbySu4qRkaro/nib?=
 =?us-ascii?Q?45aYHR28gP4Ek+T8orn9AwZaLaQq2RD6vvCTnT7Avdb6HH9jyj9ApCfsTdW9?=
 =?us-ascii?Q?Z/rrS6x9t5WpMiD0Xy9prfVScSUDCs/r+xPh8XjTErF3M29FWozu5M1QS0BG?=
 =?us-ascii?Q?b1w9pDPaH1ym6X7mY9LzGYq6cCwPrrA+YdCoH3a9OAwdiv1lseGQ1J60OJox?=
 =?us-ascii?Q?+2f9TNWIvZKQKsBiZk6RtrgWWgjcZIFVtC/lafLXzznS/bNoUSSCKmRoGj24?=
 =?us-ascii?Q?MPWG++sINeEF8tfxyx4kCftAKHdxkGxzYTuzkaRrX57PNmr/FVi5S5a03UhY?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215a5444-3cd6-4ae6-eb02-08da81313db4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:31.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 41h82prkT96GyHdl9MG58R4hSyC8bgeOs2iDTjNuc5N/u77wv4Uavo290HNTg6RYUih7dWH18SAI6/haRJcJtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5648
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce dsa_port_notify_robust(), which uses dsa_tree_notify_robust(),
and convert as many call paths to use it. Some notable exceptions are
DSA_NOTIFIER_LAG_CHANGE, for which it isn't clear how to restore the
state (or why this is allowed to return an error for that matter), and
DSA_NOTIFIER_MTU (which we'll convert separately to the robust form).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/port.c | 51 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 6aa6402d3ed9..2fec3df65643 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -30,6 +30,24 @@ static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
+/**
+ * dsa_port_notify_robust - Notify fabric of changes to port, with rollback
+ * @dp: port on which change occurred
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ * @e_rollback: event, must be of type DSA_NOTIFIER_*
+ * @v_rollback: event-specific value.
+ *
+ * Like dsa_port_notify(), except makes sure that switches are restored to the
+ * previous state in case the notifier call chain fails mid way.
+ */
+static int dsa_port_notify_robust(const struct dsa_port *dp, unsigned long e,
+				  void *v, unsigned long e_rollback,
+				  void *v_rollback)
+{
+	return dsa_tree_notify_robust(dp->ds->dst, e, v, e_rollback, v_rollback);
+}
+
 static void dsa_port_notify_bridge_fdb_flush(const struct dsa_port *dp, u16 vid)
 {
 	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
@@ -641,7 +659,8 @@ int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		goto err_lag_create;
 
 	info.lag = *dp->lag;
-	err = dsa_port_notify(dp, DSA_NOTIFIER_LAG_JOIN, &info);
+	err = dsa_port_notify_robust(dp, DSA_NOTIFIER_LAG_JOIN, &info,
+				     DSA_NOTIFIER_LAG_LEAVE, &info);
 	if (err)
 		goto err_lag_join;
 
@@ -854,12 +873,14 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock);
 	unsigned int ageing_time = jiffies_to_msecs(ageing_jiffies);
-	struct dsa_notifier_ageing_time_info info;
+	struct dsa_notifier_ageing_time_info info, old_info;
 	int err;
 
 	info.ageing_time = ageing_time;
+	old_info.ageing_time = dp->ageing_time;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
+	err = dsa_port_notify_robust(dp, DSA_NOTIFIER_AGEING_TIME, &info,
+				     DSA_NOTIFIER_AGEING_TIME, &old_info);
 	if (err)
 		return err;
 
@@ -971,7 +992,8 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_FDB_ADD, &info,
+				      DSA_NOTIFIER_FDB_DEL, &info);
 }
 
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -1007,7 +1029,8 @@ static int dsa_port_host_fdb_add(struct dsa_port *dp,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info,
+				      DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
 int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
@@ -1107,7 +1130,8 @@ int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info,
+				      DSA_NOTIFIER_LAG_FDB_DEL, &info);
 }
 
 int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -1155,7 +1179,8 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_MDB_ADD, &info,
+				      DSA_NOTIFIER_MDB_DEL, &info);
 }
 
 int dsa_port_mdb_del(const struct dsa_port *dp,
@@ -1189,7 +1214,8 @@ static int dsa_port_host_mdb_add(const struct dsa_port *dp,
 	if (!dp->ds->fdb_isolation)
 		info.db.bridge.num = 0;
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info,
+				      DSA_NOTIFIER_HOST_MDB_DEL, &info);
 }
 
 int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
@@ -1274,7 +1300,8 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		.extack = extack,
 	};
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_VLAN_ADD, &info,
+				      DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
 int dsa_port_vlan_del(struct dsa_port *dp,
@@ -1300,7 +1327,8 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	int err;
 
-	err = dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info);
+	err = dsa_port_notify_robust(dp, DSA_NOTIFIER_HOST_VLAN_ADD, &info,
+				     DSA_NOTIFIER_HOST_VLAN_DEL, &info);
 	if (err && err != -EOPNOTSUPP)
 		return err;
 
@@ -1742,7 +1770,8 @@ int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast)
 		return dsa_broadcast_robust(DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info,
 					    DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 
-	return dsa_port_notify(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info);
+	return dsa_port_notify_robust(dp, DSA_NOTIFIER_TAG_8021Q_VLAN_ADD, &info,
+				      DSA_NOTIFIER_TAG_8021Q_VLAN_DEL, &info);
 }
 
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast)
-- 
2.34.1

