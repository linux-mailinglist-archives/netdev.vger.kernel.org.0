Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089236DAEAB
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 16:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240532AbjDGOPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 10:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240100AbjDGOPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 10:15:15 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2073.outbound.protection.outlook.com [40.107.8.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015D583F8
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 07:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPj+Pn8lmMKWyzhyI9YQvmohIWim7ie3clPhKzdux7QSs93c4pDwjffqLIwnrKjpaHyEY+PLe763zZskdJaXDwdpKPdtdzTlo1d1YQJSgU0K29pKCunXqLRJSZN7a9Yx0VrBHMDyWeWwT/ucDdNlosNtmI4AHr3n2S2ib58jv2YluT2FQfXr0OMY1rvMtKLBcOFQNEwYzmdUNii20aWi0VU73fFQX9m0LPh41RDko1dnkpNMOEUOL1V+yk46OC4ci+GiOyAfXBQ7MD0fuUDc4/p0hJL7cTvFHByapx+VnzMO2VfLPZRMIqUmpoegeFWk8kEYlfWEUdbwgWR2TBFuHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnjROZJtGCDMTEY81tZ5d+QBvjO+bd8idaF3gAwg9kw=;
 b=Ahm+PGevAmWPYzL2vkOk2YUxQi2UJf8+hcHy9sWvxKpivoMa0EKtnS0XPPwAygpY5tkOADloM1pCpcSPJFNoxS6NGwLWGBh/tRI8T750Svm2yUZbwT1UgaxZi8/URZ5onUbskvoh+2TFDF7ZjUJ8uaMsvr4yinmOuawZ0mmtVAzVkjQBVKJ9ro+oRxgpBDHgMgz6JR0QLIzbw6M4NiHELlo8qiZ0K6+bHQoMThQXgERDvEuuysp3PuQwvh+ZTW0ChRknSeuO6oFihugId9NWoRzQtSNQZ0lpxJCFrXfGuNNxJGw6ApR3icbQ0tgZitiS7IkU7TM4mFyZCYlRhLUGbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnjROZJtGCDMTEY81tZ5d+QBvjO+bd8idaF3gAwg9kw=;
 b=Vq+uMsNoVN9UdwyZvZq4PQF5Gsv3bjlzOJYnWEOXacIJwGeo8hhRpRw+O878g5gUyr18bbeua2pNFG5owAkcagFGOgdyNqSmZ9Jjonx67QPJCinxZeXz5EewCaofwd2XzokrI/ORFk9kjp9hHjGvkp45zz3A+83VAoeWb1CN9QY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7405.eurprd04.prod.outlook.com (2603:10a6:800:1a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Fri, 7 Apr
 2023 14:15:03 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6277.033; Fri, 7 Apr 2023
 14:15:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: add trace points for FDB/MDB operations
Date:   Fri,  7 Apr 2023 17:14:50 +0300
Message-Id: <20230407141451.133048-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230407141451.133048-1-vladimir.oltean@nxp.com>
References: <20230407141451.133048-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0134.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::39) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7405:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c0e9eb2-90cc-4583-27ac-08db37727ab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9etsMcAh2HGi9LSXlRhkJVLvLwzVqiGAUuF7ArXBNgHwEnZ2HEvkg1VEgORWIjDUCKKXSXoLrqk6lX/FiCrbHLlgi42ypt5WOOM0fIsxStpaTXL6X8A8CSA83Z1lm4pBoHMPj1MczV9uQW/Lawql/tFTtmt28/gkinOB3pzEnk+exFYPuP8RGvU4b5h7vOjLdhBXNQsfAdFcWIKzpAhB+xWipg+OFEsZ1K1LOsNjLpEPZEI+09T2RuX2e4FFcEIU3ILzTcGkXOfohJDM/ORg7mi4l3AuXWkwzKfnPzEZW8C8dJ4sDqRYfeFPaKDu5yNBc59MI8EdPkiGAhAPzyGBX9mmmad3756KgZWCCuqYB/QtghSPRnPzmE9AlhufHalC35gysNhFxUYDVb7qlOPWU8+dTuxr/nl90Z1KDLWOTuoUxNs0sOjl8KJQzyr4Uk0rEZesiqCtM8ecj4OXJNF2tF5p7dtyKOKmjTQXeuFjyD3f9BgmJremkDRX5y+bQ7TVc0MfqmGAw4hMUzKctDRJpo12ZVhBoNPig9p90AFWJHcj6udV+hAf3eWmqxBMLnlltm4Vp/pwcFlXHCaEivEBMObSlPuZfCH2kXGeMQyEqnX5Q1bc9ni8DEJ4WdbrSZ7y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(451199021)(36756003)(86362001)(41300700001)(52116002)(316002)(8676002)(6916009)(4326008)(54906003)(66556008)(6486002)(66476007)(66946007)(478600001)(44832011)(2906002)(8936002)(30864003)(5660300002)(186003)(38350700002)(38100700002)(6666004)(6512007)(6506007)(1076003)(26005)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5elGdAfOQWufFnYynLpanr6Oi1O3MHXZV3DRT0Zdts9I1rmvDQpr0QYIbSrn?=
 =?us-ascii?Q?oUzm0OEK5Dh76PIGYlnXODUfKTFegeUAH8ZYMyq6bDLTfNnEivxnZMWgRQDk?=
 =?us-ascii?Q?jCT9m0JYxAsGtgecLVBZkh+1qzJqx8aWkGY0cTH+3SpxElzCkinTG43VCg40?=
 =?us-ascii?Q?CTSL7VacsR3eKpbFioU4N6DR6l55gtDdnmgxakhZKB7vti+gLUD6B95AGzyW?=
 =?us-ascii?Q?Aa4YMHcwHdI7G6Lc2p3E0MrS8seXoJVqr2eQcEPPHjHk7PNFKz0sQqGRETVs?=
 =?us-ascii?Q?UKE1InQPZSjrQchuWVjWm+UJlOTx/5/RfpPDkdW4IHh3grmk3vERa3DqDaBd?=
 =?us-ascii?Q?pXTDKGjZuDlCU0z/7zz7gHzype4yoKwYj+HpA5Bdb1viTjCx80HGa/AXhuGn?=
 =?us-ascii?Q?2dWSuK9YTyVHBAl0mXa83ClHMrPrPTer4sm6214sv0ohNhV+O1+z9/7AoXII?=
 =?us-ascii?Q?GxBFa52xNtNdhOv0RkZfvhOPMUMb1hhGyAJQuGyR8SKfYHShchHqSHcOMU61?=
 =?us-ascii?Q?E8/eh6rFGIAwgvEYABTseWQaei3wbY8BQLqheK6cXSIbuSQXEr1xszViwMYV?=
 =?us-ascii?Q?OBIYyLy8N//rg32KOnndYFQCxa892EjvGSrYDCZXZivW0QAe3sipotXE6NjU?=
 =?us-ascii?Q?ncAbin1Oj3jJDvaJ7R6P06TmiEIRxR+P7XAr8dWUb8FIicahTvXImpEtOGt1?=
 =?us-ascii?Q?/xXR9BJU9eqZ61+GjRkdtZcCX3uK7v9CbLQAIz98jPDF3CMVjmgMSiw9mtrz?=
 =?us-ascii?Q?cYfYsg4FFreJRm8wN5wCaHwBnwbe6vnW+pj8u28m3gUIhWuylePJhxc/zCAb?=
 =?us-ascii?Q?Lv9JmDtnRdN3FyJ8W3/LmE6yXbEe8FThx+CzByW4G0LtXXUFOURmJ24FnP/q?=
 =?us-ascii?Q?W+KJXNKRPo5h26tqWJg9+k7AS5blbX+JC0K2+isEIxQC5oScysgnMobqpq7u?=
 =?us-ascii?Q?GkwFzrCHP4QSbMr4GyySeg3bg4Nm1LYSvdO8VQtmSgnEqXbMyllfdQ9CyCwN?=
 =?us-ascii?Q?U7HP3/iFJqzc6ZbIju8o4nWFC3Joq7MSQUymF4uGbPutHqYetQfSALIzWOis?=
 =?us-ascii?Q?VljfdbIaQAedF5ZxoGTH0gp7q7tCDBYM7ku+4/fJIyg/dXGxM9nVIxYkjB4w?=
 =?us-ascii?Q?WKf7qdQUA30nC7Y8Wd4Ti3I+U+09u1WkTybf5JpgcrCledqJYutOhsfOwRZw?=
 =?us-ascii?Q?oMntnVdv/8weBp5+uYmLIHfov2PpU2Njf9xwxAheTzBi46J7GNltvCZywOXh?=
 =?us-ascii?Q?ZFAKxO3wian5qOJ5b6PY0HfNDjGbYrHKfUQO49O64dwOOpbomlo2V8+nGxcg?=
 =?us-ascii?Q?YwktRpqKcvAyRT/SiddoiZjElYY0SDqdV4o1Pds0JGU0Ilg9lpYwCpqqwXbC?=
 =?us-ascii?Q?lHSCInLub/X8rRGTbNPrhSLVtmiHbHKM7l/CHDRKHYrVhLtyDt/FfDQHrE+2?=
 =?us-ascii?Q?q/Gpk5ot7eRshBHBsIgu4bRjaxQzKTmqGv3mAuNoeuFMKlUchPz8NDDT1fX9?=
 =?us-ascii?Q?ymg6JveLQzaHg2G3QOfDI5AwviK2T3JEfiS1URdNbWUKoh6mAL6/qGTZL5eO?=
 =?us-ascii?Q?1YvivQsbKOvRQBjNJBrRhZl/vY4Lb9odiayii1jp6Da2DJ0lvy/cvGNmAPY5?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0e9eb2-90cc-4583-27ac-08db37727ab1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 14:15:03.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74O+cOaD4ko76GlH8VSrIpClKekb8XKYlcjIQw007pQ741WWvNAuTGhd64S4CzISBbmPfaY7/NYRy1UViUARWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7405
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA performs non-trivial housekeeping of unicast and multicast addresses
on shared (CPU and DSA) ports, and puts a bit of pressure on higher
layers, requiring them to behave correctly (remove these addresses
exactly as many times as they were added). Otherwise, either addresses
linger around forever, or DSA returns -ENOENT complaining that entries
that were already deleted must be deleted again.

To aid debugging, introduce some trace points specifically for FDB and
MDB - that's where some of the bugs still are right now.

Some bugs I have seen were also due to race conditions, see:
- 630fd4822af2 ("net: dsa: flush switchdev workqueue on bridge join error path")
- a2614140dc0f ("net: dsa: mv88e6xxx: flush switchdev FDB workqueue before removing VLAN")

so it would be good to not disturb the timing too much, hence the choice
to use trace points vs regular dev_dbg().

I've had these for some time on my computer in a less polished form, and
they've proven useful. What I found most useful was to enable
CONFIG_BOOTTIME_TRACING, add "trace_event=dsa" to the kernel cmdline,
and run "cat /sys/kernel/debug/tracing/trace". This is to debug more
complex environments with network managers started by the init system,
things like that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Makefile |   6 +-
 net/dsa/switch.c |  61 +++++++--
 net/dsa/trace.c  |  39 ++++++
 net/dsa/trace.h  | 329 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 423 insertions(+), 12 deletions(-)
 create mode 100644 net/dsa/trace.c
 create mode 100644 net/dsa/trace.h

diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index cc7e93a562fe..281907e53632 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -10,7 +10,8 @@ dsa_core-y += \
 	slave.o \
 	switch.o \
 	tag.o \
-	tag_8021q.o
+	tag_8021q.o \
+	trace.o
 
 # tagging formats
 obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
@@ -31,3 +32,6 @@ obj-$(CONFIG_NET_DSA_TAG_RZN1_A5PSW) += tag_rzn1_a5psw.o
 obj-$(CONFIG_NET_DSA_TAG_SJA1105) += tag_sja1105.o
 obj-$(CONFIG_NET_DSA_TAG_TRAILER) += tag_trailer.o
 obj-$(CONFIG_NET_DSA_TAG_XRS700X) += tag_xrs700x.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index d5bc4bb7310d..ff1b5d980e37 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -18,6 +18,7 @@
 #include "slave.h"
 #include "switch.h"
 #include "tag_8021q.h"
+#include "trace.h"
 
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
@@ -164,14 +165,20 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
-	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_mdb_add(ds, port, mdb, db);
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))) {
+		err = ds->ops->port_mdb_add(ds, port, mdb, db);
+		trace_dsa_mdb_add_hw(dp, mdb->addr, mdb->vid, &db, err);
+
+		return err;
+	}
 
 	mutex_lock(&dp->addr_lists_lock);
 
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, db);
 	if (a) {
 		refcount_inc(&a->refcount);
+		trace_dsa_mdb_add_bump(dp, mdb->addr, mdb->vid, &db,
+				       &a->refcount);
 		goto out;
 	}
 
@@ -182,6 +189,7 @@ static int dsa_port_do_mdb_add(struct dsa_port *dp,
 	}
 
 	err = ds->ops->port_mdb_add(ds, port, mdb, db);
+	trace_dsa_mdb_add_hw(dp, mdb->addr, mdb->vid, &db, err);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -209,21 +217,30 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
-	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_mdb_del(ds, port, mdb, db);
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))) {
+		err = ds->ops->port_mdb_del(ds, port, mdb, db);
+		trace_dsa_mdb_del_hw(dp, mdb->addr, mdb->vid, &db, err);
+
+		return err;
+	}
 
 	mutex_lock(&dp->addr_lists_lock);
 
 	a = dsa_mac_addr_find(&dp->mdbs, mdb->addr, mdb->vid, db);
 	if (!a) {
+		trace_dsa_mdb_del_not_found(dp, mdb->addr, mdb->vid, &db);
 		err = -ENOENT;
 		goto out;
 	}
 
-	if (!refcount_dec_and_test(&a->refcount))
+	if (!refcount_dec_and_test(&a->refcount)) {
+		trace_dsa_mdb_del_drop(dp, mdb->addr, mdb->vid, &db,
+				       &a->refcount);
 		goto out;
+	}
 
 	err = ds->ops->port_mdb_del(ds, port, mdb, db);
+	trace_dsa_mdb_del_hw(dp, mdb->addr, mdb->vid, &db, err);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
@@ -247,14 +264,19 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
-	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_add(ds, port, addr, vid, db);
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))) {
+		err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
+		trace_dsa_fdb_add_hw(dp, addr, vid, &db, err);
+
+		return err;
+	}
 
 	mutex_lock(&dp->addr_lists_lock);
 
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid, db);
 	if (a) {
 		refcount_inc(&a->refcount);
+		trace_dsa_fdb_add_bump(dp, addr, vid, &db, &a->refcount);
 		goto out;
 	}
 
@@ -265,6 +287,7 @@ static int dsa_port_do_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 	}
 
 	err = ds->ops->port_fdb_add(ds, port, addr, vid, db);
+	trace_dsa_fdb_add_hw(dp, addr, vid, &db, err);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -291,21 +314,29 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	int err = 0;
 
 	/* No need to bother with refcounting for user ports */
-	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp)))
-		return ds->ops->port_fdb_del(ds, port, addr, vid, db);
+	if (!(dsa_port_is_cpu(dp) || dsa_port_is_dsa(dp))) {
+		err = ds->ops->port_fdb_del(ds, port, addr, vid, db);
+		trace_dsa_fdb_del_hw(dp, addr, vid, &db, err);
+
+		return err;
+	}
 
 	mutex_lock(&dp->addr_lists_lock);
 
 	a = dsa_mac_addr_find(&dp->fdbs, addr, vid, db);
 	if (!a) {
+		trace_dsa_fdb_del_not_found(dp, addr, vid, &db);
 		err = -ENOENT;
 		goto out;
 	}
 
-	if (!refcount_dec_and_test(&a->refcount))
+	if (!refcount_dec_and_test(&a->refcount)) {
+		trace_dsa_fdb_del_drop(dp, addr, vid, &db, &a->refcount);
 		goto out;
+	}
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid, db);
+	trace_dsa_fdb_del_hw(dp, addr, vid, &db, err);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
@@ -332,6 +363,8 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 	a = dsa_mac_addr_find(&lag->fdbs, addr, vid, db);
 	if (a) {
 		refcount_inc(&a->refcount);
+		trace_dsa_lag_fdb_add_bump(lag->dev, addr, vid, &db,
+					   &a->refcount);
 		goto out;
 	}
 
@@ -342,6 +375,7 @@ static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
 	}
 
 	err = ds->ops->lag_fdb_add(ds, *lag, addr, vid, db);
+	trace_dsa_lag_fdb_add_hw(lag->dev, addr, vid, &db, err);
 	if (err) {
 		kfree(a);
 		goto out;
@@ -370,14 +404,19 @@ static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag *lag,
 
 	a = dsa_mac_addr_find(&lag->fdbs, addr, vid, db);
 	if (!a) {
+		trace_dsa_lag_fdb_del_not_found(lag->dev, addr, vid, &db);
 		err = -ENOENT;
 		goto out;
 	}
 
-	if (!refcount_dec_and_test(&a->refcount))
+	if (!refcount_dec_and_test(&a->refcount)) {
+		trace_dsa_lag_fdb_del_drop(lag->dev, addr, vid, &db,
+					   &a->refcount);
 		goto out;
+	}
 
 	err = ds->ops->lag_fdb_del(ds, *lag, addr, vid, db);
+	trace_dsa_lag_fdb_del_hw(lag->dev, addr, vid, &db, err);
 	if (err) {
 		refcount_set(&a->refcount, 1);
 		goto out;
diff --git a/net/dsa/trace.c b/net/dsa/trace.c
new file mode 100644
index 000000000000..1b107165d331
--- /dev/null
+++ b/net/dsa/trace.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* Copyright 2022-2023 NXP
+ */
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+void dsa_db_print(const struct dsa_db *db, char buf[DSA_DB_BUFSIZ])
+{
+	switch (db->type) {
+	case DSA_DB_PORT:
+		sprintf(buf, "port %s", db->dp->name);
+		break;
+	case DSA_DB_LAG:
+		sprintf(buf, "lag %s id %d", db->lag.dev->name, db->lag.id);
+		break;
+	case DSA_DB_BRIDGE:
+		sprintf(buf, "bridge %s num %d", db->bridge.dev->name,
+			db->bridge.num);
+		break;
+	default:
+		sprintf(buf, "unknown");
+		break;
+	}
+}
+
+const char *dsa_port_kind(const struct dsa_port *dp)
+{
+	switch (dp->type) {
+	case DSA_PORT_TYPE_USER:
+		return "user";
+	case DSA_PORT_TYPE_CPU:
+		return "cpu";
+	case DSA_PORT_TYPE_DSA:
+		return "dsa";
+	default:
+		return "unused";
+	}
+}
diff --git a/net/dsa/trace.h b/net/dsa/trace.h
new file mode 100644
index 000000000000..42c8bbc7d472
--- /dev/null
+++ b/net/dsa/trace.h
@@ -0,0 +1,329 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright 2022-2023 NXP
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM	dsa
+
+#if !defined(_NET_DSA_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _NET_DSA_TRACE_H
+
+#include <net/dsa.h>
+#include <linux/etherdevice.h>
+#include <linux/refcount.h>
+#include <linux/tracepoint.h>
+
+/* Enough to fit "bridge %s num %d" where num has 3 digits */
+#define DSA_DB_BUFSIZ	(IFNAMSIZ + 16)
+
+void dsa_db_print(const struct dsa_db *db, char buf[DSA_DB_BUFSIZ]);
+const char *dsa_port_kind(const struct dsa_port *dp);
+
+DECLARE_EVENT_CLASS(dsa_port_addr_op_hw,
+
+	TP_PROTO(const struct dsa_port *dp, const unsigned char *addr, u16 vid,
+		 const struct dsa_db *db, int err),
+
+	TP_ARGS(dp, addr, vid, db, err),
+
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dp->ds->dev))
+		__string(kind, dsa_port_kind(dp))
+		__field(int, port)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dp->ds->dev));
+		__assign_str(kind, dsa_port_kind(dp));
+		__entry->port = dp->index;
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+		__entry->err = err;
+	),
+
+	TP_printk("%s %s port %d addr %pM vid %u db \"%s\" err %d",
+		  __get_str(dev), __get_str(kind), __entry->port, __entry->addr,
+		  __entry->vid, __entry->db_buf, __entry->err)
+);
+
+/* Add unicast/multicast address to hardware, either on user ports
+ * (where no refcounting is kept), or on shared ports when the entry
+ * is first seen and its refcount is 1.
+ */
+DEFINE_EVENT(dsa_port_addr_op_hw, dsa_fdb_add_hw,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db, int err),
+	     TP_ARGS(dp, addr, vid, db, err));
+
+DEFINE_EVENT(dsa_port_addr_op_hw, dsa_mdb_add_hw,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db, int err),
+	     TP_ARGS(dp, addr, vid, db, err));
+
+/* Delete unicast/multicast address from hardware, either on user ports or
+ * when the refcount on shared ports reaches 0
+ */
+DEFINE_EVENT(dsa_port_addr_op_hw, dsa_fdb_del_hw,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db, int err),
+	     TP_ARGS(dp, addr, vid, db, err));
+
+DEFINE_EVENT(dsa_port_addr_op_hw, dsa_mdb_del_hw,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db, int err),
+	     TP_ARGS(dp, addr, vid, db, err));
+
+DECLARE_EVENT_CLASS(dsa_port_addr_op_refcount,
+
+	TP_PROTO(const struct dsa_port *dp, const unsigned char *addr, u16 vid,
+		 const struct dsa_db *db, const refcount_t *refcount),
+
+	TP_ARGS(dp, addr, vid, db, refcount),
+
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dp->ds->dev))
+		__string(kind, dsa_port_kind(dp))
+		__field(int, port)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+		__field(unsigned int, refcount)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dp->ds->dev));
+		__assign_str(kind, dsa_port_kind(dp));
+		__entry->port = dp->index;
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+		__entry->refcount = refcount_read(refcount);
+	),
+
+	TP_printk("%s %s port %d addr %pM vid %u db \"%s\" refcount %u",
+		  __get_str(dev), __get_str(kind), __entry->port, __entry->addr,
+		  __entry->vid, __entry->db_buf, __entry->refcount)
+);
+
+/* Bump the refcount of an existing unicast/multicast address on shared ports */
+DEFINE_EVENT(dsa_port_addr_op_refcount, dsa_fdb_add_bump,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db,
+		      const refcount_t *refcount),
+	     TP_ARGS(dp, addr, vid, db, refcount));
+
+DEFINE_EVENT(dsa_port_addr_op_refcount, dsa_mdb_add_bump,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db,
+		      const refcount_t *refcount),
+	     TP_ARGS(dp, addr, vid, db, refcount));
+
+/* Drop the refcount of a multicast address that we still keep on
+ * shared ports
+ */
+DEFINE_EVENT(dsa_port_addr_op_refcount, dsa_fdb_del_drop,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db,
+		      const refcount_t *refcount),
+	     TP_ARGS(dp, addr, vid, db, refcount));
+
+DEFINE_EVENT(dsa_port_addr_op_refcount, dsa_mdb_del_drop,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db,
+		      const refcount_t *refcount),
+	     TP_ARGS(dp, addr, vid, db, refcount));
+
+DECLARE_EVENT_CLASS(dsa_port_addr_del_not_found,
+
+	TP_PROTO(const struct dsa_port *dp, const unsigned char *addr, u16 vid,
+		 const struct dsa_db *db),
+
+	TP_ARGS(dp, addr, vid, db),
+
+	TP_STRUCT__entry(
+		__string(dev, dev_name(dp->ds->dev))
+		__string(kind, dsa_port_kind(dp))
+		__field(int, port)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev_name(dp->ds->dev));
+		__assign_str(kind, dsa_port_kind(dp));
+		__entry->port = dp->index;
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+	),
+
+	TP_printk("%s %s port %d addr %pM vid %u db \"%s\"",
+		  __get_str(dev), __get_str(kind), __entry->port,
+		  __entry->addr, __entry->vid, __entry->db_buf)
+);
+
+/* Attempt to delete a unicast/multicast address on shared ports for which
+ * the delete operation was called more times than the addition
+ */
+DEFINE_EVENT(dsa_port_addr_del_not_found, dsa_fdb_del_not_found,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db),
+	     TP_ARGS(dp, addr, vid, db));
+
+DEFINE_EVENT(dsa_port_addr_del_not_found, dsa_mdb_del_not_found,
+	     TP_PROTO(const struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid, const struct dsa_db *db),
+	     TP_ARGS(dp, addr, vid, db));
+
+TRACE_EVENT(dsa_lag_fdb_add_hw,
+
+	TP_PROTO(const struct net_device *lag_dev, const unsigned char *addr,
+		 u16 vid, const struct dsa_db *db, int err),
+
+	TP_ARGS(lag_dev, addr, vid, db, err),
+
+	TP_STRUCT__entry(
+		__string(dev, lag_dev->name)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, lag_dev->name);
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+		__entry->err = err;
+	),
+
+	TP_printk("%s addr %pM vid %u db \"%s\" err %d",
+		  __get_str(dev), __entry->addr, __entry->vid,
+		  __entry->db_buf, __entry->err)
+);
+
+TRACE_EVENT(dsa_lag_fdb_add_bump,
+
+	TP_PROTO(const struct net_device *lag_dev, const unsigned char *addr,
+		 u16 vid, const struct dsa_db *db, const refcount_t *refcount),
+
+	TP_ARGS(lag_dev, addr, vid, db, refcount),
+
+	TP_STRUCT__entry(
+		__string(dev, lag_dev->name)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+		__field(unsigned int, refcount)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, lag_dev->name);
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+		__entry->refcount = refcount_read(refcount);
+	),
+
+	TP_printk("%s addr %pM vid %u db \"%s\" refcount %u",
+		  __get_str(dev), __entry->addr, __entry->vid,
+		  __entry->db_buf, __entry->refcount)
+);
+
+TRACE_EVENT(dsa_lag_fdb_del_hw,
+
+	TP_PROTO(const struct net_device *lag_dev, const unsigned char *addr,
+		 u16 vid, const struct dsa_db *db, int err),
+
+	TP_ARGS(lag_dev, addr, vid, db, err),
+
+	TP_STRUCT__entry(
+		__string(dev, lag_dev->name)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+		__field(int, err)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, lag_dev->name);
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+		__entry->err = err;
+	),
+
+	TP_printk("%s addr %pM vid %u db \"%s\" err %d",
+		  __get_str(dev), __entry->addr, __entry->vid,
+		  __entry->db_buf, __entry->err)
+);
+
+TRACE_EVENT(dsa_lag_fdb_del_drop,
+
+	TP_PROTO(const struct net_device *lag_dev, const unsigned char *addr,
+		 u16 vid, const struct dsa_db *db, const refcount_t *refcount),
+
+	TP_ARGS(lag_dev, addr, vid, db, refcount),
+
+	TP_STRUCT__entry(
+		__string(dev, lag_dev->name)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+		__field(unsigned int, refcount)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, lag_dev->name);
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+		__entry->refcount = refcount_read(refcount);
+	),
+
+	TP_printk("%s addr %pM vid %u db \"%s\" refcount %u",
+		  __get_str(dev), __entry->addr, __entry->vid,
+		  __entry->db_buf, __entry->refcount)
+);
+
+TRACE_EVENT(dsa_lag_fdb_del_not_found,
+
+	TP_PROTO(const struct net_device *lag_dev, const unsigned char *addr,
+		 u16 vid, const struct dsa_db *db),
+
+	TP_ARGS(lag_dev, addr, vid, db),
+
+	TP_STRUCT__entry(
+		__string(dev, lag_dev->name)
+		__array(unsigned char, addr, ETH_ALEN)
+		__field(u16, vid)
+		__array(char, db_buf, DSA_DB_BUFSIZ)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, lag_dev->name);
+		ether_addr_copy(__entry->addr, addr);
+		__entry->vid = vid;
+		dsa_db_print(db, __entry->db_buf);
+	),
+
+	TP_printk("%s addr %pM vid %u db \"%s\"",
+		  __get_str(dev), __entry->addr, __entry->vid, __entry->db_buf)
+);
+
+#endif /* _NET_DSA_TRACE_H */
+
+/* We don't want to use include/trace/events */
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE	trace
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.34.1

