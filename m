Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495F263247C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiKUN5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231458AbiKUN4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:37 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130075.outbound.protection.outlook.com [40.107.13.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8555EC4C03
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AP/9H49j4EkKhzMVPDuTW7cQ+D2z/BCjljn5RbNWUg42CDdHUv1T3NXOupwbYsbL+iwHWGna0mxLqS9ZR9Obe2YVbat6MrUHaNe7FGLC4bRUwmb+V0i5hDLcQuCbgrgYkDIZxvCSclnzlg3j5vgCffzoC3Dcfcnd4f5AF+jFenlXJrPvKE4tX9BtJKZHH/NlKyjIS43RlY4VGZ595f3aE/kF4OE/qPnw9TcafdPrT+qZG12qJr2waYWA2xgenF/n8EpCzuKMMZSGLE0LB2lmJIqE77PVNsRYIF/Rctil6Rr39SGTKIwgsHPjtGIQnN+l1C/xW5U1IOVLU+thGYQA9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZgB78tnnEx7N+1zrdKRvr/i1Gnr5+z0P8A7HEXFAdgE=;
 b=F3GRBc5qLe77bSk/oSzR4b1LfRumB7P/gvnJLQ3O6GNTGYH5MZJr9Lc2988rjK6V7ceZ2pTHVheDELf6fK9ZI8CHUF5Drw253hKJYWpcuQQPi5e3c9LnLknZ/ZOAUU48wzf0726UpKs2HLZFRiuisudDDpak76NuifqmMNk8auJ9rqsHFDSjmrID7lXGWTWAriaBKAydHPulEo4EbPAnWAS9ytDo4Rwyn6p7ytJj53EzfDTI5MiE5+4K3QuKq/2VohqWkG3lgBeMPgJHvP6fmYayGwBbtZ8RVixl42cqBkGrRUei+3YTB1xBETSOT1KoDnJrrgmpIgjxVpBRRbuq+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZgB78tnnEx7N+1zrdKRvr/i1Gnr5+z0P8A7HEXFAdgE=;
 b=ImNS8EB6RSgTys1j0Jdgxv6+rDVO4l3CzroOEz0+WE1C+pFH+t8BaLMH1IhsHmifNzRW9wgkZ4Hz/XNrVtQ2f8VmD+GI8KM/3TSov1XI2tg+U2K8dn3sGWgLwSXZz4r6ruUk3QgFfvVqP0evJAgwJ9PiU8Xi2pjZqPMEqT0dhGs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8137.eurprd04.prod.outlook.com (2603:10a6:10:244::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 13:56:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 17/17] net: dsa: kill off dsa_priv.h
Date:   Mon, 21 Nov 2022 15:55:55 +0200
Message-Id: <20221121135555.1227271-18-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8137:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d55286-27f9-45f7-7c8e-08dacbc82d29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2gXO28U9l0BwKL4acBLzTTn4j1Gb/TBk0d4sKhq6ubf4FrjHwyk/Vr42On7P8T7sU3r8t4nGqVM6friQCQ3TJx+JgLKpKmWQj39/3jlpnnX2LRMfLXH/uDR4NIi9FujIDm32+UwJhDdoSE17eexwZHh3hnP8L/F/u50uDkbx8h95O69lnONh6EFJm5B3bEw/7Xmm1SNbvDL3UIlVdw9tyvLjgw1Dq5/GvsAm5mFS1O4qElFIwUvue5yceb+ZMGbPE1HRAXVzgysd7tLSqgZoay5fMbGYlC2G76LZikMqfJcdGc4W2pLQeI5pQc3xlciphHi/8egd27kKZGIfWT0Qkw7K6ghOovJybDGkPcd25AKuQ/5rxlTEy5SzTq1s1y5Qr3GHsk9A+xaqMBvzRCMRKd9tkTUEue2HTfEg6cFvXThI+Qy+7hWhPgYsYNFpKDSXFcjL2KCZq79HwJfwg/CNkFO2UsnYhthTuPVWTq4g0xJy5TJpnhCCL05ywN2HX+tGxuQPm8WQhGYoulaKQKB6VLOu/fv/yScFoBHNLQxvojFcn1qnRoLxrc94JVJ4rf+082SHLm721Vf1NT+IuaqUWz0RPI2J/WhsbvxGWOwoui/hmpgYZPjRCIrFE+10uWFhXlTnNsl5COz+Go+6CMhWMOamPIPiXnUcFh6kFyoaKeVdaJRRWugv6tBkC3A8/P2A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199015)(44832011)(1076003)(186003)(2616005)(5660300002)(66476007)(66556008)(4326008)(83380400001)(8676002)(36756003)(66946007)(54906003)(316002)(86362001)(8936002)(6916009)(38100700002)(2906002)(38350700002)(6666004)(6506007)(6512007)(41300700001)(26005)(478600001)(52116002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/0V5bWW+7/C1nCuBxyXRHdxhMB6REZQGa31y0oYscES3xDMkpbmFbR8WsIal?=
 =?us-ascii?Q?tmsgD+M8LIaVwivc1ZJVsbYz3pGGsT8nf2rjjslWcn06oJEe/DNsTCk9wrB7?=
 =?us-ascii?Q?0JNa6znxnk7XhLOq4lqavG5qgmSORdx+DADXD66WnkUMibgunvm4LE8mbQ/f?=
 =?us-ascii?Q?o8I3aFoAe9jBbjh0oYYhCJa8vkE9/hI8T7rXogfE5GsP1/11eHOVWtdnj0Nq?=
 =?us-ascii?Q?K0yeNkLjHheOPgfvsxDAW7h6oUUJJfn7xd4UXHC/CsgKAhDgG5miOuY75xvj?=
 =?us-ascii?Q?jFbC9womtxfmdTQkCpMi2iUK1+jBPCSwwP7Ar9ECaCdlbKepGWmC9y/H5s/a?=
 =?us-ascii?Q?ebMsuKOJ6W2zjNWIzxZ0maXaDGv83AgBxeyZi51PLvK1uB3F2QlF49+zurab?=
 =?us-ascii?Q?pApVB64eZ6QBbXnmWgU/5Zo7fNS8GGWc5ww2o1JPfcaRdT56e5JzjA7TvVy2?=
 =?us-ascii?Q?IgkbPTbBbBQmAMttKbmDA7m06KRXQEs+bUbvD6S1dzDmDUVRNWJoXL1XerUR?=
 =?us-ascii?Q?jlZODRr9dHO5vlYaQSe1QBIh1566rcJoEQ/7Zwme293Cr1M7K/1cOloSr2Zn?=
 =?us-ascii?Q?Bi3tamRPW8bxMC1YbKNeAyO118FaYURnmW6gl+IdkdwUBoth0yUOw37FkVPn?=
 =?us-ascii?Q?ZnrsvlvCFtc87oEE/24/4b8MotCHH2+Rhy+VDFvPJSV0YC1BmHsGTyd2wdOi?=
 =?us-ascii?Q?dkeYFfIZ2lkIvMFJbgE9KBVnxHIpeS1f9kJntAhyarRoC2LZ6K6hJ9XNAQOH?=
 =?us-ascii?Q?y4XaQq+yO+25+XdCBoq6vWz+2cK0vWgYNZQh7Q9Z3DiXB1G81BlYRueIB5mx?=
 =?us-ascii?Q?ErzbgamQ9oJkIqeoaRyYcidAQfWOvsS4WLALYg0KMOzQuiogOn9ZCMjbWXui?=
 =?us-ascii?Q?vNsVae4uP+SHTtKZd6ldPyKv9WZpBAG4XHiBzUtX7MVQnSxLmxccii459HlW?=
 =?us-ascii?Q?etcoG5P5HgXtrhD0yL2Q+rmKBZUUqwD5y2lnqMdfKTtVY0g9X/NPgAD/tpot?=
 =?us-ascii?Q?evCJ4u9B+O53QpdtuFAlZHJ9kVhCF06TCvQ6wbd8VihzEBuzpwtO/0FII5e7?=
 =?us-ascii?Q?+pf2FfvS3QF3X85BcmFs1JLc+2qhqKlt3hAivx51wTVGMcp8EnG1TGuxCTTq?=
 =?us-ascii?Q?N7gq7vagEaZfDyNCmOLzMMSs/0ODwFcMc7WlYEVb6c/xL0uh+nsVogRWCpOy?=
 =?us-ascii?Q?ORT9LWkKJoqAXWhiGkhelkOcHstQlwI8qbX7QeB7+KaV1KEszqDbWyZW7Xvj?=
 =?us-ascii?Q?mh7XD9mCKo+rWD1sdyjoVoKo3OjT+qIRcHqfLgYvtH8V4kyMpvc5LlE0Mq5T?=
 =?us-ascii?Q?lxzHVpwd8+s8NlY92JRxhsqCiElpfI1fXmQ1WV5krbcVTNVnmGLlmz2KVNcw?=
 =?us-ascii?Q?oMrnAAjo1p2iNUQQTLSJF2SWzcXZjrjhWkYgVSvxCeqbUOz8Wq8TyYrRwsGm?=
 =?us-ascii?Q?GN3+tDHnhYCx3TQrg8Nq+OVpfhGSlZ/lfxlnjYr9JBgJ9nxoN6c7xon/cmMM?=
 =?us-ascii?Q?/ZzMERVpRyhBkXomBetg//tPoC45F32PRIG6ihnlLV8P9nfqcimFijEGIUHG?=
 =?us-ascii?Q?F3No12Dgx7pJPDTDpuhGVad8oUP2JcnIWyHWFSWrnTvUDmHJoKPzpqMyFhnO?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d55286-27f9-45f7-7c8e-08dacbc82d29
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:23.9500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fspCInE41uHgGNbk1lzFsjcw/1+HwPMA5uci0mlyS4sDyeXYZdYOpcXIIV9RA/DHVY8VdtGF07vZoeEH7H78mA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last remnants in dsa_priv.h are a netlink-related definition for
which we create a new header, and DSA_MAX_NUM_OFFLOADING_BRIDGES which
is only used from dsa.c, so move it there.

Some inclusions need to be adjusted now that we no longer have headers
included transitively from dsa_priv.h.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c           |  4 +++-
 net/dsa/dsa_priv.h      | 19 -------------------
 net/dsa/netlink.c       |  2 +-
 net/dsa/netlink.h       |  8 ++++++++
 net/dsa/slave.c         |  2 +-
 net/dsa/switch.c        |  2 +-
 net/dsa/tag_8021q.c     |  1 -
 net/dsa/tag_hellcreek.c |  1 -
 8 files changed, 14 insertions(+), 25 deletions(-)
 delete mode 100644 net/dsa/dsa_priv.h
 create mode 100644 net/dsa/netlink.h

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index fee4d28b7304..e5f156940c67 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -21,13 +21,15 @@
 
 #include "devlink.h"
 #include "dsa.h"
-#include "dsa_priv.h"
 #include "master.h"
+#include "netlink.h"
 #include "port.h"
 #include "slave.h"
 #include "switch.h"
 #include "tag.h"
 
+#define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
+
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
deleted file mode 100644
index 265659954ffd..000000000000
--- a/net/dsa/dsa_priv.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-/*
- * net/dsa/dsa_priv.h - Hardware switch handling
- * Copyright (c) 2008-2009 Marvell Semiconductor
- */
-
-#ifndef __DSA_PRIV_H
-#define __DSA_PRIV_H
-
-#include <linux/phy.h>
-#include <linux/netdevice.h>
-#include <net/dsa.h>
-
-#define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
-
-/* netlink.c */
-extern struct rtnl_link_ops dsa_link_ops __read_mostly;
-
-#endif
diff --git a/net/dsa/netlink.c b/net/dsa/netlink.c
index 824b09d904cc..bd4bbaf851de 100644
--- a/net/dsa/netlink.c
+++ b/net/dsa/netlink.c
@@ -4,7 +4,7 @@
 #include <linux/netdevice.h>
 #include <net/rtnetlink.h>
 
-#include "dsa_priv.h"
+#include "netlink.h"
 #include "slave.h"
 
 static const struct nla_policy dsa_policy[IFLA_DSA_MAX + 1] = {
diff --git a/net/dsa/netlink.h b/net/dsa/netlink.h
new file mode 100644
index 000000000000..7eda2fa15722
--- /dev/null
+++ b/net/dsa/netlink.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_NETLINK_H
+#define __DSA_NETLINK_H
+
+extern struct rtnl_link_ops dsa_link_ops __read_mostly;
+
+#endif
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 337cbd80633a..aab79c355224 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -23,9 +23,9 @@
 #include <linux/netpoll.h>
 
 #include "dsa.h"
-#include "dsa_priv.h"
 #include "port.h"
 #include "master.h"
+#include "netlink.h"
 #include "slave.h"
 #include "tag.h"
 
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e53cc0c3c933..d5bc4bb7310d 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -13,7 +13,7 @@
 #include <net/switchdev.h>
 
 #include "dsa.h"
-#include "dsa_priv.h"
+#include "netlink.h"
 #include "port.h"
 #include "slave.h"
 #include "switch.h"
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index ac2eb933106e..b1263917fcb2 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -7,7 +7,6 @@
 #include <linux/if_vlan.h>
 #include <linux/dsa/8021q.h>
 
-#include "dsa_priv.h"
 #include "port.h"
 #include "switch.h"
 #include "tag.h"
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index a047041e7686..71884296fc70 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -11,7 +11,6 @@
 #include <linux/skbuff.h>
 #include <net/dsa.h>
 
-#include "dsa_priv.h"
 #include "tag.h"
 
 #define HELLCREEK_NAME		"hellcreek"
-- 
2.34.1

