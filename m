Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C4F63247A
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiKUN5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbiKUN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:36 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2085.outbound.protection.outlook.com [40.107.249.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A73EC2865
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8CF2ud5H3qHljL81a1SfevQY7TrA/0GvRtyc1Hdqvx+5zquEQ2qGYbTUfuhgppblsJ2mTkvX5/gQwHpQe9wc8qkF1M/1lhBpHZm2/yP/2SLGTY2baxT7KemNmv3o6SKGrphVJPVraxlwVszqKf7G57eP30cIE+SOVRMxNf2ZZuGA26wKsuLyQJ2PZg531Tzf+cMy5UN4d7fy7g0m/T32inYpYw1ETC8SSK2Klpux2+qzACsex4/RkdavR5Y/o5jQSVRLqP2bLLWneRpee07N7afRZ65DZbCMoMbNEk+E3Nw1Z1nbf3s3gMqEZo8BQLlJq3cY7DZzQdTpAQxXqgOMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejGcl+V9N1zu0UpWmvhIAlp6Kc8k+JutdaWgckO6ub8=;
 b=azte6MdzmPZwdDSCy2th6j+FIZhQPMsI/MI9LAeOYByUJN5TiZwRQiH8pIhazGrEgfq0Ov1g2pSro11pkchghDAq5u8YVjQdY5Ze5MZUFAyA/89kfmIy978MwLsHJsR5pr9C/FkqoZkPc9lMp9niWqpOjp/xfoLnNv4XjhyzzmbCOmWb5QKPCitewfbz/w7ZH1lnAh563xSHu3cLQrEHc59ONZbeVYboU6WnjLL1cdgMTfQ5+KsV6ayEF166QHUqk9iIHLbuTPcDYVCLj+RiXmb9CBe6V8QhmTpqv4IyZP5w2ZO3tNBn9rar7DkOTsEhLTwsGrzP5lpVsb4EOEQalA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ejGcl+V9N1zu0UpWmvhIAlp6Kc8k+JutdaWgckO6ub8=;
 b=h+3e/HNMECzLbprrCK7Gx2z9Nv7c99zjVSPDjm0j1grcmHvZvizsna6Uyu68VK3AJWgFBYtT2wiuYFbj3I7U/aDJt++PxijgCPCQ4KY5eyovbJtMoFsmYZypEaobDQdih5lDME6E9Vz1S92BwEgn6+6etrZ7ZhY9KsJrIfSrglM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6829.eurprd04.prod.outlook.com (2603:10a6:803:13b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 14/17] net: dsa: rename dsa2.c back into dsa.c and create its header
Date:   Mon, 21 Nov 2022 15:55:52 +0200
Message-Id: <20221121135555.1227271-15-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: a699d404-0e57-45f6-676b-08dacbc82c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T+v7Wr4klTqS8HH2p+UVEKUTDJ0E9XASea0Muk+1YoxHslYYmFedWDlFksG+xrs0t0n+Yin6LC38EyYvB1nEPHPby1YaD0gR4H4L8RZnd1UMa05k944u6XLHAy98VcGWep4NCQaFqsWJCXGoAjCEPSfyBNTitemtLtj3Hza1/ZLiR7nhYncgD/g4U3MoPcOAlZuheQWmSDEXMmBlYE5jfF5NbNBlSsaN0lyPoG/Ftu5nYeHRBs2rKdXC8mF+pN0BHFJFgSkIkmbFlORoglhWSElmmCmq1J/TK8V7YfOJITRTnH9OssJJiJ5AZep8YSFkF2cNkoxbVIriS1Z2S2/NT52gW835RqXZcZtm29Qpq6NJ+v2z+pJq4YVPRJ6CsFKKFr0N1F85sr6HbsVxn2PxPs9sUM/dT5YFfUT4+vfWsrUaiRkvP0qSHTb3+RSSvpXmy31f5E/07xbZI+jKTsY7IXzuFuEcCUrVdgSm0SPRenQUP7fHsftTrzK1OQKVlvzz/YuQF/QipsUT+jx8g4DWBZ4SlK4FnTXicqVH9uR6kmiocb4Eh78Ol7/8/04GqtyJwoZ3JolbVLly+3ddsve8wrg9q8lIjQERAzYaOP8/njHMeoaUoUtPEPlnQnOIffACHzl7woJbSHsGc0jPytp5jbJeABi9cFNqsZ1vz+1PgX4JyjZiAqc5CDvF52m4d7RR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(6486002)(26005)(2906002)(86362001)(36756003)(6506007)(6666004)(478600001)(83380400001)(38350700002)(6512007)(38100700002)(52116002)(1076003)(2616005)(186003)(44832011)(8936002)(41300700001)(66556008)(4326008)(66476007)(8676002)(5660300002)(66946007)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cMskbV1oC+YpHtN4gHspYz+rW40Y+Lnq+Eb1ADFvY2geym95RfUNkMSRQ8kA?=
 =?us-ascii?Q?5AurbWISiytjOpUPydP6YVKu/A2TwcKOSdB0T/ZqVAfPQMgZCFradiC1fnIG?=
 =?us-ascii?Q?guTv4SezpLyN33UlmATQM2/LhXZuBIL0AzS3WAqOCl8eAzJHQ2zjGawHwGt+?=
 =?us-ascii?Q?S6cEQm8DmL21lrETotkXeQ5ihpGqIYPkzSmYpAuQxR03aDMebC61kFXunUKX?=
 =?us-ascii?Q?Uv96lGVoH0Ppnq1HoOZ+Wb2WiP7JVv1s64FSsGXfnFmWtH5f1RSrJ8Nk85w1?=
 =?us-ascii?Q?K2kHEvOa3j1aV6+rTCI03oZGakPLhYs6R1XeR4PacjpFwSBzfcc/NOHSw/2+?=
 =?us-ascii?Q?0Y3YaHzS7OAdFahueNHoK0/nC5wSNtz9x3MaMNuGMaDBw9xJdXZgw/VPWpA5?=
 =?us-ascii?Q?NK17Wf9skd1HfQKxic1Q1UR/oCh2HpGlLZ69I0JSj1VlTJJwBCF3QCvQcMJ/?=
 =?us-ascii?Q?UT4PuUbHnxJSBVVWqY0v1CdoXG7HEite8z5z4wIO2UUpNZyMWt855iVmrC5U?=
 =?us-ascii?Q?/+6RHz2TWdO45HQ6U6pIg9P4xt2zRnaGVOYqb+u0qhfGc/fA5zpzz1kH0LaK?=
 =?us-ascii?Q?HNWjpNulk5PfkrExnlnjFmrOjxo3Rnd1Xkk8ApDol1mr7FN+yzo318Gpgzjm?=
 =?us-ascii?Q?lzZ2gAZ4ac2NLh1ddQolevN7y8nKou/IQf+Rw+d3Hqb2WdsjaL8zRCP6bc0K?=
 =?us-ascii?Q?meZw4204RvClVZ+2RovSYaCRd3zCEq4oXtVvtzmwpRx2jpJknIZuymvts/nk?=
 =?us-ascii?Q?ifYj2e6jvRkAlFK99m++nwYZKpzAJuhMyxGHzd+de64licbsz0Dhuqf7w33I?=
 =?us-ascii?Q?a3Ohnq+mFAm9xjpCHf0Mp5RpkP64UVbaaHfXlQQ4DjR1PNlKX+BDmdMUGFLX?=
 =?us-ascii?Q?w32kSBZbjD4K6rqpL6tMTB/el5aAKKqq8wQ2nIufuYFSvEGGRSlL1biOO9uT?=
 =?us-ascii?Q?foewcRU6NmZA6NfzWzvET6NRWMZRYzQmJNaSyIkBbvcH+fOSogBwGJQQ0X79?=
 =?us-ascii?Q?2N8+wOD4Pusm5OrijaD2b/XSE2Q0M20JcxVkwGrKuJ4yO0ktcY1EnekVuLoe?=
 =?us-ascii?Q?cLYAcwe5F0peqlBRkLTVZHfiCmPYjwHojJjJBl1C7KN3AxMDt6B0hUgEHWtB?=
 =?us-ascii?Q?vodky0netdTbhzbrG+i/0f7g9RjuYgapdzdO40Y7lV8BPamvB2+1+MM0ClUs?=
 =?us-ascii?Q?X0wc3IGLm9WFBd19+Wg2K2F+2fWTwMpwMBNr8/19XfA++KABwJBv9qMWsx0Y?=
 =?us-ascii?Q?RbnbJpNnBw0i+el6CTx/N7cPv+yYaeKgMzRInOZJM4eb3QulpUmMcfkboC1a?=
 =?us-ascii?Q?2ftklqMEoEXZNljrQgeRsNaOBmK4ZkG3ocsK++K1uIZTh0CLF5ykMZhWTXYN?=
 =?us-ascii?Q?aoXgSKnniCSiYkaXj5zZWHiOQqEVAkzbXpWCHM56ecLnaNyCX3DKFM46/Qpr?=
 =?us-ascii?Q?DlUvg2Szpw+SqzdocI7MgTBk/73QIrUwkoK0wytFHN9VxIjRt18xBLVbFt+S?=
 =?us-ascii?Q?TteDOXo52LgN85dFlrK4GPwCSwQwIZ5bP/PjMbU5bS6x48mP28H47VxC2QcJ?=
 =?us-ascii?Q?iKe/baUt2aeCwxGyC58XwbMZw9TaGZFkiqYCO7CcfWhdMg83FuR31YeGExGd?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a699d404-0e57-45f6-676b-08dacbc82c0b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:22.0751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4B2au9+Ez70TCPZeSYbir65M1Wl/VWDgGvUSVGDjqIoTcd0fPxrNHwnBp0OaRb5VVLq/ONBzFMEGnYrp6xuQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6829
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous change moved the code into the larger file (dsa2.c) to
minimize the delta. Rename that now to dsa.c, and create dsa.h, where
all related definitions from dsa_priv.h go.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/Makefile          |  2 +-
 net/dsa/{dsa2.c => dsa.c} |  1 +
 net/dsa/dsa.h             | 40 +++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h        | 28 ---------------------------
 net/dsa/master.c          |  2 +-
 net/dsa/port.c            |  2 +-
 net/dsa/slave.c           |  1 +
 net/dsa/switch.c          |  1 +
 8 files changed, 46 insertions(+), 31 deletions(-)
 rename net/dsa/{dsa2.c => dsa.c} (99%)
 create mode 100644 net/dsa/dsa.h

diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index f38d0f4bf76c..cc7e93a562fe 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -3,7 +3,7 @@
 obj-$(CONFIG_NET_DSA) += dsa_core.o
 dsa_core-y += \
 	devlink.o \
-	dsa2.o \
+	dsa.o \
 	master.o \
 	netlink.o \
 	port.o \
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa.c
similarity index 99%
rename from net/dsa/dsa2.c
rename to net/dsa/dsa.c
index 7a75b0767dd1..fee4d28b7304 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa.c
@@ -20,6 +20,7 @@
 #include <net/sch_generic.h>
 
 #include "devlink.h"
+#include "dsa.h"
 #include "dsa_priv.h"
 #include "master.h"
 #include "port.h"
diff --git a/net/dsa/dsa.h b/net/dsa/dsa.h
new file mode 100644
index 000000000000..b7e17ae1094d
--- /dev/null
+++ b/net/dsa/dsa.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_H
+#define __DSA_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+
+struct dsa_db;
+struct dsa_device_ops;
+struct dsa_lag;
+struct dsa_switch_tree;
+struct net_device;
+struct work_struct;
+
+extern struct list_head dsa_tree_list;
+
+bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
+bool dsa_schedule_work(struct work_struct *work);
+void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
+void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
+struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
+				  const struct net_device *lag_dev);
+struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst);
+int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
+			      const struct dsa_device_ops *tag_ops,
+			      const struct dsa_device_ops *old_tag_ops);
+void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
+					struct net_device *master,
+					bool up);
+void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
+				       struct net_device *master,
+				       bool up);
+unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
+void dsa_bridge_num_put(const struct net_device *bridge_dev,
+			unsigned int bridge_num);
+struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
+					const struct net_device *br);
+
+#endif
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3f6f84150592..b7ec6efe8b74 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -43,11 +43,6 @@ struct dsa_standalone_event_work {
 	u16 vid;
 };
 
-/* dsa.c */
-bool dsa_db_equal(const struct dsa_db *a, const struct dsa_db *b);
-
-bool dsa_schedule_work(struct work_struct *work);
-
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
@@ -65,33 +60,10 @@ static inline bool dsa_switch_supports_mc_filtering(struct dsa_switch *ds)
 	       !ds->needs_standalone_vlan_filtering;
 }
 
-/* dsa2.c */
-void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
-void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
-struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
-				  const struct net_device *lag_dev);
-struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst);
-int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
-			      const struct dsa_device_ops *tag_ops,
-			      const struct dsa_device_ops *old_tag_ops);
-void dsa_tree_master_admin_state_change(struct dsa_switch_tree *dst,
-					struct net_device *master,
-					bool up);
-void dsa_tree_master_oper_state_change(struct dsa_switch_tree *dst,
-				       struct net_device *master,
-				       bool up);
-unsigned int dsa_bridge_num_get(const struct net_device *bridge_dev, int max);
-void dsa_bridge_num_put(const struct net_device *bridge_dev,
-			unsigned int bridge_num);
-struct dsa_bridge *dsa_tree_bridge_find(struct dsa_switch_tree *dst,
-					const struct net_device *br);
-
 /* tag_8021q.c */
 int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info);
 int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
 				  struct dsa_notifier_tag_8021q_vlan_info *info);
 
-extern struct list_head dsa_tree_list;
-
 #endif
diff --git a/net/dsa/master.c b/net/dsa/master.c
index e38b349ca7f8..26d90140d271 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -11,7 +11,7 @@
 #include <linux/netlink.h>
 #include <net/dsa.h>
 
-#include "dsa_priv.h"
+#include "dsa.h"
 #include "master.h"
 #include "port.h"
 #include "tag.h"
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bf2c98215021..e6d5c05b41b4 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -12,7 +12,7 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 
-#include "dsa_priv.h"
+#include "dsa.h"
 #include "port.h"
 #include "slave.h"
 #include "switch.h"
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a928aaf68804..d4c436930a04 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -22,6 +22,7 @@
 #include <net/dcbnl.h>
 #include <linux/netpoll.h>
 
+#include "dsa.h"
 #include "dsa_priv.h"
 #include "port.h"
 #include "master.h"
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index b534116dc519..4420af0081af 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -12,6 +12,7 @@
 #include <linux/if_vlan.h>
 #include <net/switchdev.h>
 
+#include "dsa.h"
 #include "dsa_priv.h"
 #include "port.h"
 #include "slave.h"
-- 
2.34.1

