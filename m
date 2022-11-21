Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613CC632470
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiKUN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiKUN4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:23 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237CABEAF8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPiS2eccswwsuvZ6iU0kzTHCv2amJeb6mce+FEpVUC7/n8xtL+M0dYhM4ihc/vHxmyzuj+sC0kgK3nW72n22eXi08/YY5c2lJndpfeqq6uJY/ZVzDyifI6K4DgC4Ddrcygi7b+V7S63j4hQh75UjVvDVB2CRpXhAQbK+mpEL+dfzHed3s+ty5YmCFROQhWmr3DorWFBXV7isYBaithk8rRsbp6VnSMjOXuag2SwTGuPMUk8HSjt+TIQ8yOxnpk4HUzqIFvkatLpCJKRjqCXy6B2tfrHUzOS/u3R8+I6GYnanlRKva8oVRjwtve4j45TC1emwO9Dc/Ko9nspJmQckaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fcte2kGoqsibq+8w4g1b4r03thx0KQBm8aleg/WoW3s=;
 b=mFgT3xiDilEkm0Syuibq3qOLON6SXi5CfSvJm1Ifdvn3FPQrs6xGFb3FiJnNzgukePqu5RmnckNl2xraYI6gk8Mq69SgH7hJbtQiLxJqA+Os9Oea20uCyvbR8wZROW74cUIojjCBI+HVgoxbGT90h35GEo2YaSZqz5pfMGXo8MSSpZCtes6vNewOCQEKUtoK/JZT1jM5+tEL3guefPoBf9FZzuTF7J6fHz2AKuNF+EFw4Ao24SxxNX3DnEicL0CrZ5GjbXy2BRVDGvaiVCYs7QWCs3CrlEWsYdSN7JMSngTxIPwGhGhOAlISBaBL+syP0UODDNGn4lwFCdjO/8hTWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fcte2kGoqsibq+8w4g1b4r03thx0KQBm8aleg/WoW3s=;
 b=FGuyn7JIipckSU4wDuCgjbGBHyUA+LGt3o/6uPezA1Xy0lIzlpkuTBcNtEx/yHEJIgq9yN+5xQ4QxWyVsaLzoW4PcrHmehCekmkp+xYsgxS5blFMjg5x44R2by2xpOaQ8EQtyTpNwlRzvUPAebggLnaSEO2mJVtP2jzTRx58ulg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 07/17] net: dsa: move headers exported by master.c to master.h
Date:   Mon, 21 Nov 2022 15:55:45 +0200
Message-Id: <20221121135555.1227271-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: d1095c86-d447-4fe0-5bc1-08dacbc82928
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3AoTLYvYP5bLKM2iwNb6QIR5v7+p/gnkhgbkgCTFIwTR9C4U+joyTHMfxgG8nMYXW0ng4yTVpcgRGSFlQaTLFSdlhCOBbAuXYgLvOZ1lGhFbLjRmFMvW2U8qgE9mO1KxD0F0bWf15oXCKFTVkRolbw/OZxuhgniq8krVEBA2W47DWODWWF25ZPtTx1lfeLTn6HJXxyLxXKxSv4qndGrXuTkfuWN5qMD+ddlh9Ro5ZaIVuhrYfhjrrGtXcMOkf6VWHUsvuTjOKQBLSgdC81ZWkqUEbVwvFF0aF0h4h1eXjYHeCAKauE+9Ze8xxdAT2BFZAy091XXvJFhO1gX8pBGe2bgYhlcCV5IS2+DFPHl7XpeK0qvvAXhcIg83oZsYD1PD1czGCBykvhOoxttEvb61CItmrv7xFXNdAXu/d9Ozy4O2vXic1KWgDyP4pG7gdfn4SmsKr4WVlAMgTO/qbAKAy2UJAHqHQWNDL9DZJfP2vf4T1Mu898eSag7tQxnWJpfoSqMXqgceLCWggmHEzYoUgnfzKZfa5hYMgW4zYVcNOtqnLId/X0vWy36pA/b4guq1XxQIMpsGu6kdQS7Ri0oWQSRLf62dZnLEcM/NIDAzBQLrIcNtef5wjh9KDWZEP3A1yS9/BsS8/ZDDXzbyP2KVWIjeLZWREWzMmO+GHGVPd0ib4ZAUzL0Lu1VGJsLOwk/s
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k/SFQqPgZmNH371Pbr4xYAjlf92i6is387+UxqPbSsWqkBaZ9YFqo5tdBnyd?=
 =?us-ascii?Q?f3vQwZQK2vRnPov9ujthiBZaB/IicNiPwLlOfgBFOU8gt6FO9PWw8afYqLdx?=
 =?us-ascii?Q?6i5DWnTN4nl2JG2u1slvS6pNCaniRxr2ADYlsw9LoI5iUooiVxBunDLxyrog?=
 =?us-ascii?Q?hxdVHZ4tFg71Q4Kn1+w8Jjkz1hpfjki9c5X2d4zZUfCQqIzZmUA6DAtgh9QM?=
 =?us-ascii?Q?2LkxGL9O0P5YEQHOpumkY1c3fSCddmPCYZ6HHHeHZ5HomZB3GW6M0SO2DtWi?=
 =?us-ascii?Q?IxH4OnnjBShd9TjF7KM0tH2I++WjwP5Qv1yvZS+b1WIxbBGLnh2fZKvQV5OM?=
 =?us-ascii?Q?C0nkaakB6zFpjLYv+5CV4a6cpWPglk9BQDbWnx9wgu2jY1Ru/983miaFaIOa?=
 =?us-ascii?Q?s2H5Fcdkn1GfNsl2lBRT2UZxr726vGc4z1PkZEpnMA1Bn1ZbDIlZnVSFthSx?=
 =?us-ascii?Q?4UxYH8Sd+EU+Ryb9hvRmS8CshIPsK7Pi5pmb7Hvw5r3GL7JQZxdQw2bZBcbt?=
 =?us-ascii?Q?Z/p69GTvI8p7mYOkkjuMCDfOo5PB0B1CxdvcZH6nH5LvErrl0bjyt+oGhF6A?=
 =?us-ascii?Q?6eY2uKxx2KobbJYlNcOGNKCGkfv6BjVVadF8g8weSmk/x54v73nvEWnvWH+g?=
 =?us-ascii?Q?XUoXPcJd/GtBEMuabFsVbwJjtRAlwcdGWP6eSBU8RRZH/XQMcMBZHhHkv8R6?=
 =?us-ascii?Q?WqMXNNxm97VF4+AuvKCAO0308j0AWQ7lSMOLd2bWn0pOoONQ0mTORGhN3NqP?=
 =?us-ascii?Q?GY4RidUiO7kGn0irYQSrJkEd1lKukjyb5mUb2UU5aU949ta7SLoDJ9CEHRTw?=
 =?us-ascii?Q?d2yFnnZqvuY/IlYlSiY0CBhry4VffLBjcRlZokgFswXSEyez6sp2CoBGPjn5?=
 =?us-ascii?Q?dD1OCw7357m6dADZc+xmHmXEhzw5Rqt5g2wEjvgaoNsyFAFN6MkwQA8HIIoA?=
 =?us-ascii?Q?r3Tgs7UQc++Lw+WdmOJO+YvZ1iI+uGFeOa3fIpB7ebrdys+qyqI+o2SDjopd?=
 =?us-ascii?Q?YcwcSBxVWEV1nKX6nfEBWFukcpKZVwHitrOQrnPhXDcHjj+50PZiPZ9Q9RYt?=
 =?us-ascii?Q?C98PraAG32SD+HYdBFzxBKxbYz/X0uYAaKaFrZmjYrEdPrzz5H1TQywLi3iJ?=
 =?us-ascii?Q?kVobpR1ACiazFY0/itMWXqISjPN+FaFbWi2//4qMpO49BvrlzHFKs8J/lZl+?=
 =?us-ascii?Q?k6wTj+xffNPTqTF+8mOt2jNDbGUVIF8MPyUM3/K9X+MCjYXKtPiqAvhFOSWn?=
 =?us-ascii?Q?Id8iz1CKPvCJE1OHTqYNS6EVelgPpnHLomqiiOpC7N9dKxcMQLnB7bM0MWlu?=
 =?us-ascii?Q?3fUnjpwJ2NK+87R2NOBdN4VR+tNm0JfZnkwRACtzaN4F64ELGx7MGZXEJ8eO?=
 =?us-ascii?Q?q900guBU4UkuT0ZL+3HWpGv2QSnMg5jK2GrptWhpSlvJFksd7DUe37icQfHI?=
 =?us-ascii?Q?rx+yRW7QtzF60XMqfzgHqZ+KvNT+R7T4YBksJoV8I71xTAXDHGS6INr8Wnik?=
 =?us-ascii?Q?0ZprfvljEvkrL34slYrMzj2zYm0D3pEfwRYKlcHmH2HN0vcVF4krv+MGGLhP?=
 =?us-ascii?Q?9odcIgrtO5Fq3q112WhpzNSsJXaxy8eCbGYrr5RhKOEC0c3o+SOU+RhE1o/Y?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1095c86-d447-4fe0-5bc1-08dacbc82928
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:17.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJRNcL7xrYny5JW+6DGI1zBMNbdE7J/0eieEXFUZJSIVcXyGD8df5UERwaFc/cv9u3x1xy9rCzPJshmD0RnB+Q==
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

Minimize the use of the bloated dsa_priv.h by moving the prototypes
exported by master.c to their own header file.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c     |  1 +
 net/dsa/dsa_priv.h |  9 ---------
 net/dsa/master.c   |  6 ++++++
 net/dsa/master.h   | 19 +++++++++++++++++++
 net/dsa/slave.c    |  1 +
 5 files changed, 27 insertions(+), 9 deletions(-)
 create mode 100644 net/dsa/master.h

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 5a9cf74a0166..10cd4ea9afe1 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -19,6 +19,7 @@
 
 #include "devlink.h"
 #include "dsa_priv.h"
+#include "master.h"
 #include "port.h"
 
 static DEFINE_MUTEX(dsa2_mutex);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 81ddc52feb94..94e385ec6da5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -259,15 +259,6 @@ static inline int dsa_tag_protocol_overhead(const struct dsa_device_ops *ops)
 	return ops->needed_headroom + ops->needed_tailroom;
 }
 
-/* master.c */
-int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
-void dsa_master_teardown(struct net_device *dev);
-int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
-			 struct netdev_lag_upper_info *uinfo,
-			 struct netlink_ext_ack *extack);
-void dsa_master_lag_teardown(struct net_device *lag_dev,
-			     struct dsa_port *cpu_dp);
-
 static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 						       int device, int port)
 {
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 0d3ef591b3b4..6105821834a2 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -6,7 +6,13 @@
  *	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
  */
 
+#include <linux/ethtool.h>
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
+#include <net/dsa.h>
+
 #include "dsa_priv.h"
+#include "master.h"
 #include "port.h"
 
 static int dsa_master_get_regs_len(struct net_device *dev)
diff --git a/net/dsa/master.h b/net/dsa/master.h
new file mode 100644
index 000000000000..3fc0e610b5b5
--- /dev/null
+++ b/net/dsa/master.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_MASTER_H
+#define __DSA_MASTER_H
+
+struct dsa_port;
+struct net_device;
+struct netdev_lag_upper_info;
+struct netlink_ext_ack;
+
+int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp);
+void dsa_master_teardown(struct net_device *dev);
+int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
+			 struct netdev_lag_upper_info *uinfo,
+			 struct netlink_ext_ack *extack);
+void dsa_master_lag_teardown(struct net_device *lag_dev,
+			     struct dsa_port *cpu_dp);
+
+#endif
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index b782a1788f5a..523f9ebeb45b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -24,6 +24,7 @@
 
 #include "dsa_priv.h"
 #include "port.h"
+#include "master.h"
 
 static void dsa_slave_standalone_event_work(struct work_struct *work)
 {
-- 
2.34.1

