Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD9F4CAE6A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiCBTPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244964AbiCBTPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:42 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C57527C7
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:14:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0LMtSMpODab6mVamnFXk/pOJh7M995U0/ggwv17Zmoi0Jagi9mymn3a8PfRxFhQTI3XHGk+thz+23blfDjtbfqVvx3LI/C9t9273XevD8Td0GEhsVGWFWAo6vb8GDAPXNtjFCV0HsOshKXaIg7+/O2cOF48cV4+553oIFDsi9BtBjDOZ8W5cKmdidQTYx4zVavviyhZHqJkXGCMCYA2U/XZCKr/r3ZFEgqlSU4bEMqSwXVfoKll/v5eBw3oRFpOJepNT4uJ3+neTyu4O0nzUWah7VyOgHlNA9wv2Yn1A0IzDV5LfEHQpzfY9a3bwKjG9+Ip52WaHEmrs1OWFXs+KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSoJN4jnmhcBclKRhYOemPz+zsju4op0Smr4663aiVQ=;
 b=MS7O3LgIj5JTifLY4XcavO/YZV0XebbW5iwJ3t9QLQoExBVEMvzRL8tMXZpbFl3UdLDpljTZUa3PJkMFtG56XEZurdZSGHm/6rsMk6wWDyvBvhSJtTBYaZC41R8B1RwMvMWmG1RBqCu6/POWY1gz5PuMEhX6N3xcOsPi0M3QGPQ52p1wc+UgigmaIUGgDYV/i669vq1sqKjx5JREytc4FvHwF+KJQH/p2aqgMNd1brXQPDoF3pe8+hOSW99zaT1dFlFe0xWehZrf5vbrLcg4Ud1IVGBOa4H6o4xdaU9OhEPxU5r375z0wv2+M6UHljE1RwZIwEGzsoV6kpOJ9/PRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSoJN4jnmhcBclKRhYOemPz+zsju4op0Smr4663aiVQ=;
 b=lq7W86VN+4ulUZpZHOdSERx6ylQ+cRibet46ZOBWhs7tL5FVd6hUpyOb4nfgWa6jRJP91yIp800oQV4N/2ty3PzvCOdeWJ+51cvcmKchg3BRF1W5Znh2C5rmbeBVAr5tlkpox54LKMvJmZI2Nh6N/pKJ/zml0id9SjExgED0LoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 02/10] net: dsa: rename the host FDB and MDB methods to contain the "bridge" namespace
Date:   Wed,  2 Mar 2022 21:14:09 +0200
Message-Id: <20220302191417.1288145-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3eacc81c-f631-4d03-4e6a-08d9fc80ee47
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB291109A00450D80164DD2F46E0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 63Q0kkAOXN6z2UH9xSRN051SWRk6zEoDwnEut4yiUmqfY7Nr0XXnZ9hQTS1UcJU0b+uZt8hvrPIsyIzmSaIYOMbRtgBqb3sRs2WC/vIoWnWjcTguajab3ZYBJraRHGxmXPlZWIOWUB3lrKHzQPV9Xa+/HJiz/f3rlx9d6hMtTupfCRWpg8om08yH6es5HYgXe0LA9RKjkA9oHs1ArLdwW5JXWK+KIoxpah8OuQVZLzsIznLUahZshWLRFzWFwuFyA7hlCiS9SvY3h0NujSB1VWWlrR3/LVvNgWQsLSSQVN8NuL7j5wIA22ho5QCVVn26t9Xam9Iw2cu/uxMuDQS23d7OMTTH+2TGPXwpb7negEexZEb423IqtaOUgOtr/UdRMTzLaekk3w43Y2jn3kCedR/x8syIDTHXNbywGxyxp0/RD46IMhetVGTCRD/7jxKrc2Iz3Y/DqxMfAWNzxM2GKU5/h2cfnsppWJYBod1ceMnxE0wQv07aiQC8ouY0X6/YOboGp0QacE6kTlVDEkeEJ2LXgnozMMlZ5+R6p+iHBTfN8MaNBLtMN6OpQZZutlkM9+5po6NZ4S8XgqIZ+Tjjc+e7/Hs0pWFEtLiE+iY2wx4o49m7WWvJOsRo47MQLc2qt484aI4QILzEd7f0H0CcD88OENC9RfVtpbHWeJjtdhNJLppw5PuQxFIH9WINwQ7vX1G3cU0RRddNjfdYxeVoUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uWiXiSUyLjCfQ3gWP5giL3C5sf6+QGhNopSt/2C91p9na1OUhWYjwVxKIi01?=
 =?us-ascii?Q?BKxeTFCD1uaoZcqDBxPUmNHaUeJdh5irTojcnoIuRuB9dMuYo4h5LZVsPcL0?=
 =?us-ascii?Q?Z2pgV/pPjBg/pxQn8nsfJANVgWKabU3yRXzfwgb8ZOtBBle7AKQ0xC66vnpL?=
 =?us-ascii?Q?ZE/HWneONSTZSllZDXmqNv1q4wnt6Pe6dMQHHO7Wg+AMV53C7GFlCpK7Llzx?=
 =?us-ascii?Q?aO9qoPA0Apij3Bh3ro4Yw8sTyriU3XSoeZVCWKmKB+kZgIqwACWl0469GZKT?=
 =?us-ascii?Q?9DeGdPjOMBUNbDoeyQHXfCbbaps4kS7AAkxnYiCEfYi90ycpk9AzKqpkMjHk?=
 =?us-ascii?Q?8sfbJGkLRHmFHKj2W+Izpjxkp0bd4BwD07ToYHqYQNNd8RpWTZVKU3/RmVc7?=
 =?us-ascii?Q?I6w7jkLpmP3rsz2+MF8NzfvzPiQQOTUagfgdC87HQ0UmmnLQZzzUv88l0UMw?=
 =?us-ascii?Q?TVuwGyjGbmM2ftglhoY6Gcknxc8z16NmFjVwUsBInuPjpDnKBK8Ik2+dEXww?=
 =?us-ascii?Q?OiE67KneuUQ7oQpSGyN8a15rxrkW/BZ/9Z5ZjDn1dvfQ5CatpyKk4au4hp/t?=
 =?us-ascii?Q?rXIDSB56UZzeMtBKpQlR9O8+XsBe8WpkASgy/r9mNa0AyCZ013NlvP7Qylz4?=
 =?us-ascii?Q?XAD9ooWgqskqJ00JSWgaTgnD5VeBCxQhAJgMQ8YsEeSejUfFePSpitPPo4c/?=
 =?us-ascii?Q?mD6Aj9xowLLXo+VZrSQrTCb/e+M4lt2OCMpB6CBmTQMiOAfy/hn+zI0uARac?=
 =?us-ascii?Q?l13w5sh/z7mN3MYNTwmoFQM4fyU/WSNCyKJZTG0hXmRU1um/7JNLww2iCRka?=
 =?us-ascii?Q?lSFchW30r8aP3dziydtWYSVZzgdwUTvDCXY9uG6ocBURBhV+dk8FlwY+IghZ?=
 =?us-ascii?Q?QIdAf13BYzKzA1tSLObnyD+X4wWm16rbqFuTey6YdqBi+6Fv3MyhyTTQl907?=
 =?us-ascii?Q?3LUxoORONYETTEycyWUF2sMp/KJ8slv7VOXedt9ZGSmTuo9MkEJuvpW6yJxI?=
 =?us-ascii?Q?YFt53EMS3ojvR+hIDsX/4e7LHgPz3rn6NEWrJ/3nvgVbOPLmmDBfqX0rUhSM?=
 =?us-ascii?Q?T8owZGaiOH3bOHUsc2QMNN395anHo4htqm283YfPgw0wPphbrWGXlS3Ognt7?=
 =?us-ascii?Q?Doc3YLRDs887hRsLhrz2qa7WgmJrXxP4C2HeTrZ1nrRqlaUeWtd/kZg8t7ga?=
 =?us-ascii?Q?5lg7/fOa5Zeuv3708CW4smo+peHG/Km1EumvhWtBL5Ci3S3hRhCKuFXfKbbO?=
 =?us-ascii?Q?Hn70dyw7UuZ1+B14mzHroOcesKu+vuErNVfyX2UqoY68IqprhPdSUiVmiIUs?=
 =?us-ascii?Q?4oILv/EYNS+SfifIv8RIalJGk/eQiBQDueTiIvzAETcw+NBcCJyJi8RJKYVF?=
 =?us-ascii?Q?NlMPtOooMuj3e4DcG0SZcaHAjBU2iTMq4iia9foTLqMM/8jkCohpKCV82ElI?=
 =?us-ascii?Q?pI47seboS3jAFlMOr+LyhuddsLMfewbQsnHn9MhZ94VtuAMskWpt8wvDnODW?=
 =?us-ascii?Q?eLTa+P8qiu4jHmmmjl7R53tcdnW7iwOx69/V+YyjeizgKyZ3KIvXZ2FVFmS9?=
 =?us-ascii?Q?IRiZA3JLIwdUcMRywJhi0AiCc6TFaLQ+qHAMHyqb37oxk03iX9YvNPEjBt7o?=
 =?us-ascii?Q?lzpom7UO53eCfD4r/99/8Eg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eacc81c-f631-4d03-4e6a-08d9fc80ee47
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:53.4862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u99TQBKwHGi3+hlysCjtuBJt5ihY4SEYONeWegH7rA+jombLrK5rJ7tSyVbXhcwzB4Z5KTeCDsEgA9jrIJxRPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We are preparing to add API in port.c that adds FDB and MDB entries that
correspond to the port's standalone database. Rename the existing
methods to make it clear that the FDB and MDB entries offloaded come
from the bridge database.

Since the function names lengthen in dsa_slave_switchdev_event_work(),
we place "addr" and "vid" in temporary variables, to shorten those.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 16 ++++++++--------
 net/dsa/port.c     | 16 ++++++++--------
 net/dsa/slave.c    | 30 ++++++++++++------------------
 3 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 07c0ad52395a..2e05c863d4b4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -223,10 +223,10 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
-int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid);
-int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid);
+int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid);
+int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid);
 int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			 u16 vid);
 int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -236,10 +236,10 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_host_mdb_add(const struct dsa_port *dp,
-			  const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_host_mdb_del(const struct dsa_port *dp,
-			  const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 			      struct switchdev_brport_flags flags,
 			      struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index d9da425a17fb..4fb282ae049c 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -835,8 +835,8 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
 }
 
-int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid)
+int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
@@ -867,8 +867,8 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
 }
 
-int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			  u16 vid)
+int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+				 u16 vid)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
@@ -982,8 +982,8 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
 }
 
-int dsa_port_host_mdb_add(const struct dsa_port *dp,
-			  const struct switchdev_obj_port_mdb *mdb)
+int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
 		.sw_index = dp->ds->index,
@@ -1007,8 +1007,8 @@ int dsa_port_host_mdb_add(const struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
 }
 
-int dsa_port_host_mdb_del(const struct dsa_port *dp,
-			  const struct switchdev_obj_port_mdb *mdb)
+int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
 		.sw_index = dp->ds->index,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 52d1316368c9..f0d8f2f5d923 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -397,7 +397,7 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		err = dsa_port_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_port_bridge_host_mdb_add(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (dsa_port_offloads_bridge_port(dp, obj->orig_dev))
@@ -478,7 +478,7 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		err = dsa_port_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		err = dsa_port_bridge_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (dsa_port_offloads_bridge_port(dp, obj->orig_dev))
@@ -2356,7 +2356,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 {
 	struct dsa_switchdev_event_work *switchdev_work =
 		container_of(work, struct dsa_switchdev_event_work, work);
+	const unsigned char *addr = switchdev_work->addr;
 	struct net_device *dev = switchdev_work->dev;
+	u16 vid = switchdev_work->vid;
 	struct dsa_switch *ds;
 	struct dsa_port *dp;
 	int err;
@@ -2367,19 +2369,15 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+			err = dsa_port_bridge_host_fdb_add(dp, addr, vid);
 		else if (dp->lag)
-			err = dsa_port_lag_fdb_add(dp, switchdev_work->addr,
-						   switchdev_work->vid);
+			err = dsa_port_lag_fdb_add(dp, addr, vid);
 		else
-			err = dsa_port_fdb_add(dp, switchdev_work->addr,
-					       switchdev_work->vid);
+			err = dsa_port_fdb_add(dp, addr, vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to add %pM vid %d to fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
+				dp->index, addr, vid, err);
 			break;
 		}
 		dsa_fdb_offload_notify(switchdev_work);
@@ -2387,19 +2385,15 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
-						    switchdev_work->vid);
+			err = dsa_port_bridge_host_fdb_del(dp, addr, vid);
 		else if (dp->lag)
-			err = dsa_port_lag_fdb_del(dp, switchdev_work->addr,
-						   switchdev_work->vid);
+			err = dsa_port_lag_fdb_del(dp, addr, vid);
 		else
-			err = dsa_port_fdb_del(dp, switchdev_work->addr,
-					       switchdev_work->vid);
+			err = dsa_port_fdb_del(dp, addr, vid);
 		if (err) {
 			dev_err(ds->dev,
 				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, switchdev_work->addr,
-				switchdev_work->vid, err);
+				dp->index, addr, vid, err);
 		}
 
 		break;
-- 
2.25.1

