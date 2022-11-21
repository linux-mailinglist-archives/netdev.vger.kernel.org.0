Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665A5632481
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbiKUN50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbiKUN4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:38 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2085.outbound.protection.outlook.com [40.107.249.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF43C4943
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flPskHyVAjJuathwyyaEaU7ZJA+Kvnvs9UgP+Rk3lORud19HAIaTMIp7kVWShWBE/xVrqaJuY//091GdMRJvDtX17NHZd5tZCtSqOEoUHCfgHt2IvMtJk21+G2MH+LDcg5gXyBjK7cTQM+ds+OXxfJFbgXdiluxdke9QfOsKBE0d6cvm3GJJcqWSTs1VWmMkHxOC+OLPEYEa8iQc5uTUuqmx2vGdReusfxxlHDUDXy42+gYcFaOoeblmDeo75MCKoaC2yvmWf5MjdgmUfZdXAgK1qr0b5D8pZfn0bjNyh0PUENuEGFr4ujpjJqYVWJE1V5QZXF6a3RekjZpVSvgPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gQehvYWTIHnU01jcIwQmpSSfgvU7Ppf5DXbI5WKMoAg=;
 b=jcvb/I72rX+D7wpXUzH3GCdhMKLBlGO32yKTuF+UDSFfl1UbSTljVbrcKaXIPebQ281tHlFgDbwFqxEkQSe1rOak8OypRhoFTGQoHVb+fUQ9+9h54tYSCr+oOJQBEmTXPRewllDfAzQoeo+vRUO60zKP/xmZ94xkWMRirVpLG3c7CopofEJsgwHvOT34XFJe9Z336gBsWWMsIsz8uvfIKV21r5sUb738VhEbvzrbRbR157bAJE7TqGlPK1Pjpa3GA9LjtSCXe7132JthRzWRMQhrhyVjYUjZauKcD0XV9C8A4a2ceWn7xV+KkZTVUlkltozEIpUy53a1gxSxURNX1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gQehvYWTIHnU01jcIwQmpSSfgvU7Ppf5DXbI5WKMoAg=;
 b=hkcFzm4j2uu9+xYSGFC3eMmmEj7r6+foW0vxf4tnrQvySPiBxDZuH7HbRxQJxM6oM40H77/UfIwLSndujCriSGDwpM2oPJYrNImhIXbwZcBnQU+bko8NUgGnIbr0mf57YrlNsNanl/PWLD/Hj2DyVA0raId0xMwfKajZe5/qn3s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6829.eurprd04.prod.outlook.com (2603:10a6:803:13b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 16/17] net: dsa: move tag_8021q headers to their proper place
Date:   Mon, 21 Nov 2022 15:55:54 +0200
Message-Id: <20221121135555.1227271-17-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 964b746f-c8ed-4785-2030-08dacbc82cca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: svr3aWaGhv/g4hlQl5JrZ0wzzjrYa8ACGrMvoC/kodlHD9IoZg3m6nfb1QcVsfpzfSDTTzbeniS0pUVjguAMbQJNrx3Enw/tJ8pwjzqN9WofEFwVGYgciwi6TAX486Q2BHoCpHiKkvfbw8os2NvAHZg22u09u1W6PgucIixMJTylW/b4Yi5GC8oAOFREcwLIkH0Jq3G7cTddvucl8e2ch7I8BljiVBGvzKcWyC/ukWnWadDUhmknAhL3tcBeD6XP9an7FeWxgRfH5xtmbQvMJPYQ3mDNfXNniNrFT7hoD8ozdzek6G46ybsRACTZn96QagPdLT5ewDnTi0gmSwwLpPMPhe5qc/mgHNH1qcZgMG1o7rwRCDPLwdGr4LlmE0iyqawbn+8jo/k5To+/UFb0YYrxMKH19SF1wEzRyxC7CnJlIjbinMztwUzeo3Kwkw6h2scoKrT1mLTfmN7UyiUd4xPwmg7OA+ao6rkdswucF7xJXH+IzEA3PO26HslvtCTneU8EvxQPfCWyTEBgqgg3cGC0pIu1yoarR85+ZKKOfcdSoDrnXMElN4hsi29JZL5O1c29T0En3OktBbG1mSFTpXpasDqHue9jO3sRNye1fzP3AR+Q3UYvSATpwS8mIQcnJPqCX/CHcS+3NlHh0iS7EmYOJQr3XtVuJODB3UoNmug8J4wIDpSamHS5djuKWguf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(451199015)(6486002)(26005)(2906002)(86362001)(36756003)(6506007)(6666004)(478600001)(83380400001)(38350700002)(6512007)(38100700002)(52116002)(1076003)(2616005)(186003)(44832011)(8936002)(41300700001)(66556008)(4326008)(66476007)(8676002)(5660300002)(66946007)(66899015)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JkmbOx7WjyZvel47ZESXcu6SAbQBRxHntC1oejD1ZpfItPbIsXLjvd0uVhKQ?=
 =?us-ascii?Q?zdyWJ9SSksePpW5Cmjb3khAbae672U6KoXQxqLGd7Hx0MRAE5yoOrzQ+BWR8?=
 =?us-ascii?Q?MLvnzk+w3AZrmCdGNQUBI4r6zUT8TKHUeoDMoE5dEoHaBaG+Ne3TbQrcarnE?=
 =?us-ascii?Q?mEwjCLw8lXiJz1YT9Q3R61Vg/h1o+/G0G18HWxAh0JBvw2cLjLvf+OQ03nX5?=
 =?us-ascii?Q?4zYad3pPWnmoFMZxEYBmjVbwHtSuxPmtLwicnooFEz861IBMdxG3gzoSL6Hd?=
 =?us-ascii?Q?ES9keN/L0cQxxu5lAfaLoOiy4JzVqzttM4OMqFqaZ4GXVi3d9IzWlL1KHPZY?=
 =?us-ascii?Q?XXoXY78KaPZEUc79CZWw9Uh5ukvAsJDtsO7IhW1Yn0Byq/4/PVlXMQj5rGmF?=
 =?us-ascii?Q?lohPNIv/SEPdpaGvKqey0T5FtAqaeAvrbB78sZZIZAV9UBVdEysb6zaMSvU/?=
 =?us-ascii?Q?ji8lkI8v7eqZpmeIOk0TwgwefvZCYG05ygCraQXeLoE6gs8p1T9pHEdRQepy?=
 =?us-ascii?Q?cHq6f0c7bTLn8i5BSj6XYl97LPqWzT+QjWCsLLPaSKq8GOKYG8uQXcQY1ZlZ?=
 =?us-ascii?Q?pInNihxTlJNMUwrycHtX/qgdL1jQkDI6X6WqA55NEmfUeei87iBU5eKci28l?=
 =?us-ascii?Q?ZYGm/tRLkn6d4KL/pS+ePj5menH6RtEC3N44gQfI5MjAHOwx/hPbViJpxXzf?=
 =?us-ascii?Q?QfeLaAKyhQ8cgT1mQk0NqbcshoG3s+akg8AhxZwzzPs/T0VdfLbM/qXT+ekp?=
 =?us-ascii?Q?iFW3IY3f7FlF+IaNR3tMvLvogZTQHQtl3w8uNT4xYmXPpB6cuSRO18alSlF6?=
 =?us-ascii?Q?N9cRYc8yvGrZV+2VPh+WIE/brPuV+3QqyJhvq2qe9HjrFQdscTnlqk8Y3/bJ?=
 =?us-ascii?Q?tPMZixhqWolRitkOuytniZgfidfPdG+oVjKde+3J8ipTCnCYU1elCWC7XsKd?=
 =?us-ascii?Q?EngfhGdBEdpNJmV9zT5ayUqIpc20kS1AKEKANAd8cU/yvhPbAKLCVQq6rkXK?=
 =?us-ascii?Q?TM7yzntoVQNNf7xDh1pJMRA8vL2NAJdfF153clkx8gVFvbO1t6++vBAtyzWE?=
 =?us-ascii?Q?FOFmkA/lF71fvaQqPov1VVCAGFgIrdbsSOMXMhh1bbOeVdgizUlDyRo+l9BI?=
 =?us-ascii?Q?tF3tulfRH1FmLMPtITFvtLZNloVcAOp1m0s71x4vO/auCNMH5Kn72jPzR48g?=
 =?us-ascii?Q?NWspM6+FUZVZp95OejTcUFiBLpXuX3I5P5iQpUxxQb9rKVBMY2F7c963qkMl?=
 =?us-ascii?Q?uMUbJecZBnQtF8l3RqfNh9CrrNChaeOXpLTMvYGBB0HQjOUzqON0MhB8T92G?=
 =?us-ascii?Q?mTbtv6co/IFTPkGErMfmRu9KdqLSbLHZMMwN6Nrkn+PFcmJxAbd9HVp9cCMG?=
 =?us-ascii?Q?hM0K1fh92HsKIe177oKmvu3rOfjD1Ma4sQ3uZkQhFoQaIQFBoD6ROW6n59hQ?=
 =?us-ascii?Q?Zxfv9qXr+XuC7svEFsWMemQ/TuxAjtZ2YzWFMpPeS07UlDX3uqDzqTpBsDnK?=
 =?us-ascii?Q?M9mP58J4mLQZpJaVAIRqgqET9K6L5ERS2iQC6f4zDJmsgBbCygcC1RO3bE8L?=
 =?us-ascii?Q?JH8I3PujcmAefjQx6y96bpviqOYDnhKS+KvMcuPaVXGKyWTL2awYfOoTia6r?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964b746f-c8ed-4785-2030-08dacbc82cca
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:23.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/9W1g93dYysRTy48ARVoJuTvyjD9TjCX/3rdqTgG/S7iacUdi35hz1LUPcz0QuCPA1kdvOPIpOC2CrUgsYG9g==
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

tag_8021q definitions are all over the place. Some are exported to
linux/dsa/8021q.h (visible by DSA core, taggers, switch drivers and
everyone else), and some are in dsa_priv.h.

Move the structures that don't need external visibility into tag_8021q.c,
and the ones which don't need the world or switch drivers to see them
into tag_8021q.h.

We also have the tag_8021q.h inclusion from switch.c, which is basically
the entire reason why tag_8021q.c was built into DSA in commit
8b6e638b4be2 ("net: dsa: build tag_8021q.c as part of DSA core").
I still don't know how to better deal with that, so leave it alone.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h  | 31 +------------------------------
 include/net/dsa.h          |  1 +
 net/dsa/dsa_priv.h         |  8 --------
 net/dsa/port.c             |  1 +
 net/dsa/switch.c           |  1 +
 net/dsa/tag_8021q.c        | 15 +++++++++++++++
 net/dsa/tag_8021q.h        | 27 +++++++++++++++++++++++++++
 net/dsa/tag_ocelot_8021q.c |  1 +
 net/dsa/tag_sja1105.c      |  1 +
 9 files changed, 48 insertions(+), 38 deletions(-)
 create mode 100644 net/dsa/tag_8021q.h

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 3ed117e299ec..f3664ee12170 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -5,28 +5,8 @@
 #ifndef _NET_DSA_8021Q_H
 #define _NET_DSA_8021Q_H
 
-#include <linux/refcount.h>
-#include <linux/types.h>
 #include <net/dsa.h>
-
-struct dsa_switch;
-struct dsa_port;
-struct sk_buff;
-struct net_device;
-
-struct dsa_tag_8021q_vlan {
-	struct list_head list;
-	int port;
-	u16 vid;
-	refcount_t refcount;
-};
-
-struct dsa_8021q_context {
-	struct dsa_switch *ds;
-	struct list_head vlans;
-	/* EtherType of RX VID, used for filtering on master interface */
-	__be16 proto;
-};
+#include <linux/types.h>
 
 int dsa_tag_8021q_register(struct dsa_switch *ds, __be16 proto);
 
@@ -38,15 +18,6 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds, int port,
 void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 				struct dsa_bridge bridge);
 
-struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
-			       u16 tpid, u16 tci);
-
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
-		   int *vbid);
-
-struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
-						   int vbid);
-
 u16 dsa_tag_8021q_bridge_vid(unsigned int bridge_num);
 
 u16 dsa_tag_8021q_standalone_vid(const struct dsa_port *dp);
diff --git a/include/net/dsa.h b/include/net/dsa.h
index d5bfcb63d4c2..96086289aa9b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -22,6 +22,7 @@
 #include <net/devlink.h>
 #include <net/switchdev.h>
 
+struct dsa_8021q_context;
 struct tc_action;
 struct phy_device;
 struct fixed_phy_status;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index aa685d2309e0..265659954ffd 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -13,15 +13,7 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
-struct dsa_notifier_tag_8021q_vlan_info;
-
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
-/* tag_8021q.c */
-int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
-				  struct dsa_notifier_tag_8021q_vlan_info *info);
-int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
-				  struct dsa_notifier_tag_8021q_vlan_info *info);
-
 #endif
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e6d5c05b41b4..67ad1adec2a2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -16,6 +16,7 @@
 #include "port.h"
 #include "slave.h"
 #include "switch.h"
+#include "tag_8021q.h"
 
 /**
  * dsa_port_notify - Notify the switching fabric of changes to a port
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4420af0081af..e53cc0c3c933 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -17,6 +17,7 @@
 #include "port.h"
 #include "slave.h"
 #include "switch.h"
+#include "tag_8021q.h"
 
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index abd994dc76d5..ac2eb933106e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -11,6 +11,7 @@
 #include "port.h"
 #include "switch.h"
 #include "tag.h"
+#include "tag_8021q.h"
 
 /* Binary structure of the fake 12-bit VID field (when the TPID is
  * ETH_P_DSA_8021Q):
@@ -63,6 +64,20 @@
 #define DSA_8021Q_PORT(x)		(((x) << DSA_8021Q_PORT_SHIFT) & \
 						 DSA_8021Q_PORT_MASK)
 
+struct dsa_tag_8021q_vlan {
+	struct list_head list;
+	int port;
+	u16 vid;
+	refcount_t refcount;
+};
+
+struct dsa_8021q_context {
+	struct dsa_switch *ds;
+	struct list_head vlans;
+	/* EtherType of RX VID, used for filtering on master interface */
+	__be16 proto;
+};
+
 u16 dsa_tag_8021q_bridge_vid(unsigned int bridge_num)
 {
 	/* The VBID value of 0 is reserved for precise TX, but it is also
diff --git a/net/dsa/tag_8021q.h b/net/dsa/tag_8021q.h
new file mode 100644
index 000000000000..b75cbaa028ef
--- /dev/null
+++ b/net/dsa/tag_8021q.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_TAG_8021Q_H
+#define __DSA_TAG_8021Q_H
+
+#include <net/dsa.h>
+
+#include "switch.h"
+
+struct sk_buff;
+struct net_device;
+
+struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
+			       u16 tpid, u16 tci);
+
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *vbid);
+
+struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
+						   int vbid);
+
+int dsa_switch_tag_8021q_vlan_add(struct dsa_switch *ds,
+				  struct dsa_notifier_tag_8021q_vlan_info *info);
+int dsa_switch_tag_8021q_vlan_del(struct dsa_switch *ds,
+				  struct dsa_notifier_tag_8021q_vlan_info *info);
+
+#endif
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 7f0c2d71e89b..1f0b8c20eba5 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -12,6 +12,7 @@
 #include <linux/dsa/ocelot.h>
 
 #include "tag.h"
+#include "tag_8021q.h"
 
 #define OCELOT_8021Q_NAME "ocelot-8021q"
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 8f581617e15c..f14f51b41491 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,6 +7,7 @@
 #include <linux/packing.h>
 
 #include "tag.h"
+#include "tag_8021q.h"
 
 #define SJA1105_NAME				"sja1105"
 #define SJA1110_NAME				"sja1110"
-- 
2.34.1

