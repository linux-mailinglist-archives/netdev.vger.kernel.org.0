Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142CE63246E
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiKUN4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiKUN4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:24 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80080.outbound.protection.outlook.com [40.107.8.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5401FBF83B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnmdITF5VRYhNZgAI2OGQEDCDoeEYBB1Q0D2V0M0lbY05JiWfXfLGFeVhyFmH0AuGQ4mNQ0ftARKwh8cMUPG6qddunInnB7YANbnWLfGUSscxmywniFjL/VCN2fTA6GNAf6PYRrNqDk3qFIrLelKU3dma8sBhdn5AUlJRUZ4YEkLv28dLnxpSPBrPP6HfSTKhpUEmzJvyxBnqiACecg9tyi+l61faTCa8Pq/uyN2d5RjYj/pp0BxmJHj6VMgP6t4BnzS0BKbnX2JAwEfz2uQak6lmil7eHYFP/uiS4btY/5zoNAuCysMRxEdHJuODA1BMoAF+FcGypCFhlH+zviJ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eQnHtrUn8ThlL8uEX24Of9P3h2wfKeJmbuB4ExBoDtg=;
 b=WJLoUNEtD0nf6yZzVrZKPmKH7+IKUO5BPwjA2rX1DOXFuCUmgQZucUHVyUhNOylDt0n/g1Yx/FQwM/HMLM4fzuWWcG46Psv1lW6UY2yvxAIO2KHVkHQmu2zMCgL0ogbtMZoCOSM17dBvk2i4BGV23eP6zIud6DNMxS3g87aGJlfGBq6VNfOE3js8ihL/RrQzNDb/OkO4CBPHB4fHxqHAKlDLqjZd91lfxEZtRN4vyDykPd/3rLtsJkhmhCbicuffChRWUeL9pD16Q5spxyP1RYeq8wiG7cdJaIWCdt9Rh+B6HTjUOzvFrIZIXWAWNU+G4p7/gNkapVOYzGbfbNKe/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQnHtrUn8ThlL8uEX24Of9P3h2wfKeJmbuB4ExBoDtg=;
 b=E1O9t17Xk4XJ9+BfagnQB97VElz2+Q6znOceQFxQyXXyoxs6+cg74A2K9D/mFIlY1YVXvA8LHKnZaSMd/R3uWEShgpoP8cipWEWyLphIW9xklpk6dU8I0n/G6hEB6bqXQFxry0rJwPfDHVF2+tjypr/nqyvlXvROnCSUIATs3mQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 08/17] net: dsa: move headers exported by slave.c to slave.h
Date:   Mon, 21 Nov 2022 15:55:46 +0200
Message-Id: <20221121135555.1227271-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e0fe46d9-902e-4e73-7cb2-08dacbc8298c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CT7gPEUpB34CPTfKCPyZR78lU3x9lPQ5fwnNAzfLK7Dte+hQQHD0UhSXcJfosbTd66ZNafLX2yk1SX793HjziVDQY0tIV1T6La/JCp+V4LzCVhpUmHv82Bwt1fR92JqP+GDj48Bqqixuf+3Spb+gUtX4dTvmv45MZ65aRwcgXLdlzNFk0B4ytvcjdUTSlCw+LSbGMBZpjIknZoXqM+ISQkDqbfWrE/lEyjaG80Qd3iTur+IywBvaDM4urCStBPTftxpVk4s8/JGKHQOxtUERdXgPSdChHT0ZgCD77JQB8w6KlYxBXei6hvSncdQQM+k60b87SX+VfSjaC7j4wnoQP03Z+5C3jqnMsu++OPDfojJQbi9uQtGO4EylUWgTsxT3JxA+TreRRHWmnjjXgskEGbc32JIzxi70pQiP8z5Ufri5sKfxJB9r3/VZU6zwBNIm99DJm/z/CDpCbhOlM541Rktg8T6oRzAZNFzW5rVvhDldpBMGW65OMsRQ9/qqa01G+0NCmEwoyYKvXYu9/P7bALtqtdwur7beFownTJgc8XK7+ZdqAyEgsvTj4izyPWqR0QGku8FvLZgerwiUKsPmdRwnlOVmPKCcfFvZfvJBAWRZgCFKj8yyk0B8390sGlNY5GNz6IgmcVNeQCbp553ryikmXRhvU3FqFudy7BNhPTNS3/gBC7mnBaWpeZxGZQ6V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vuSrPJcF5qhcmvePCLxd2vYKRcHjvCQQJVZEVuqmm0iukj+0WMwoQLRA+aa3?=
 =?us-ascii?Q?Z7PrACwmA7HAwCOFz/p/rpQNKX9aRzASDmtfcEKK35WjsUPs7VdKltzOpahm?=
 =?us-ascii?Q?mkpSe/pG9ZNhvUyKBmRkKQ6PYpvsGer5wdqsstrLczPJ1bkUTUutA/4CVLPs?=
 =?us-ascii?Q?/vx/LPrHE9A5s7d13z2eWzOmZtcjICWAMVVOBp+4yYDX5g2LIJEgLT2aZa5Q?=
 =?us-ascii?Q?OE1wPpONQfcBs81nouT4sWVgEw2BUWfAw9izB/kMtIMt4C95LcuQUJV4TEdP?=
 =?us-ascii?Q?Dux1i9InH0qu2ZxPK/5F9z+T9kmNwd5TMrf1EAY59UMOxEWdIcrgeWY67cE3?=
 =?us-ascii?Q?JO8InEMdXFZtFKtSKIkd5IJdZMJoIgyA1+5Z7c9uAOdRv+MrtdT/29oEkUKn?=
 =?us-ascii?Q?puGc+mQRdzY1kyUqS3lcW+0CAAc49ambOqzLL6mocQozkl3s51nzF5l6Qdxx?=
 =?us-ascii?Q?LQVtFWxD6TrkRajfikfLGY9xgHHQkptTRRDJfk8JGNoid63+c6QHmgcCFf9M?=
 =?us-ascii?Q?Otg7GgYAknAbUwCulrrDIaLtbWT58BNEwyNFp3bPTBqZ9S9bv7ET7htdkkbC?=
 =?us-ascii?Q?p1Hk5mn7tV8HnxrbtwZ9ITphUDAlBYW06Hi1JaKRk6UasvRgUrkmk3wqNxCP?=
 =?us-ascii?Q?I+1Irf0kzucKb2YW5eZFppbv2oM944TQJRELsCy/cqdYsKviTBvAqhL0cN0J?=
 =?us-ascii?Q?RDjL811bLA57/e8h6HVweYypJsPgVcdU2asUIcqTz3dBXpBtcueVX4ILRgA5?=
 =?us-ascii?Q?jlEmLvQZlhCeTCl25qkRXq7uWN96rvlJ0CsgeZhbpurrUoGtSG9Smi5cRTyA?=
 =?us-ascii?Q?Jl493JV/PH9re+vnJRBWs73DFD05WGoiMSF3149609zLbXe3DkWS9XZHcCrm?=
 =?us-ascii?Q?fMEUc4zTHvA2MnY949VUM5gQ8dyKRHXvyXtNjfXGwCd0LHcKVUp0BhcCBJeY?=
 =?us-ascii?Q?4rxLgpGs4H/GVSLOn90fL1DCDFW6X5tQH3iJGHgSI83rtL8Jdhe7W35vrHZ1?=
 =?us-ascii?Q?2UhG9FZ12lTB4Nnn/OZJPHR1u+fHlOlet2EFKWsKGTWfpZ8S4eZorxPaoD00?=
 =?us-ascii?Q?h7INuU0AGW43Equ67S9bf8MNjZeOIJBE0/f65VJlp56Mv+WnKBKEGwh/6woq?=
 =?us-ascii?Q?AlJoMoDbDsGDNaywkmyL/5Q1E4zuLEHqn04OA7EGHQsx5z8ZP9Z5kWGiliPP?=
 =?us-ascii?Q?52kY2XYleosHSRfTmsMaXZq6w6FNDKDpHbVhHx5HFR+aUQqQwr0EuhfXZ5S5?=
 =?us-ascii?Q?aed/P1CeRyLiuDS5Xd9mP4Jq70pVFLkniOQIONBxuLPoV4AmxYylK1+/WtIx?=
 =?us-ascii?Q?aagfVRr8BDi6UODvvV/5o2l2AZEvw6DSuLgrNhrr8WzDkWkQHQPDXWgP2qMI?=
 =?us-ascii?Q?VRacwpeAcnyy5zuFe8v90x+DN8NKDZhioMg2nGOV5MgsPxgM/6C4g++GvcRT?=
 =?us-ascii?Q?PSbdKRWzef7C/HBTCJsprfn8T8sY1XRc8nOOhaIiBSDoGC3kyOIG0nCezNv5?=
 =?us-ascii?Q?JTeHEO4mrC1C0C/AEVwBWxNbsbtlcSPWsG+yVdKqXPNgoLYuqutQ/euBqb4d?=
 =?us-ascii?Q?F4YBEugs5zuhjDAfgsaD60GyDsUYCdRJfx9L9GoPakgjZl8dOEpO2FCAgGMf?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fe46d9-902e-4e73-7cb2-08dacbc8298c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:17.9660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ibk5RBbOof2aM4wkis76og8pQ7U+x9PxsiYCglYLvMfVYx4/CuzbBDYJgpuvbDOKauq+hC03i6GHPXoNvMTipA==
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
exported by slave.c to their own header file.

This is just approximate to get the code structure right. There are some
interdependencies with static inline code left in dsa_priv.h, so leave
slave.h included from there for now.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa.c      |  1 +
 net/dsa/dsa2.c     |  1 +
 net/dsa/dsa_priv.h | 59 ++-------------------------------------
 net/dsa/netlink.c  |  1 +
 net/dsa/port.c     |  1 +
 net/dsa/slave.c    |  1 +
 net/dsa/slave.h    | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/switch.c   |  1 +
 8 files changed, 77 insertions(+), 57 deletions(-)
 create mode 100644 net/dsa/slave.h

diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 842a1f2488b2..422f8853d1c4 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -14,6 +14,7 @@
 #include <net/dst_metadata.h>
 
 #include "dsa_priv.h"
+#include "slave.h"
 
 static LIST_HEAD(dsa_tag_drivers_list);
 static DEFINE_MUTEX(dsa_tag_drivers_lock);
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 10cd4ea9afe1..f917e695d38c 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,7 @@
 #include "dsa_priv.h"
 #include "master.h"
 #include "port.h"
+#include "slave.h"
 
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 94e385ec6da5..fcff35b15dd4 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -7,13 +7,11 @@
 #ifndef __DSA_PRIV_H
 #define __DSA_PRIV_H
 
-#include <linux/if_bridge.h>
-#include <linux/if_vlan.h>
 #include <linux/phy.h>
 #include <linux/netdevice.h>
-#include <linux/netpoll.h>
 #include <net/dsa.h>
-#include <net/gro_cells.h>
+
+#include "slave.h"
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
@@ -224,24 +222,6 @@ struct dsa_standalone_event_work {
 	u16 vid;
 };
 
-struct dsa_slave_priv {
-	/* Copy of CPU port xmit for faster access in slave transmit hot path */
-	struct sk_buff *	(*xmit)(struct sk_buff *skb,
-					struct net_device *dev);
-
-	struct gro_cells	gcells;
-
-	/* DSA port data, such as switch, port index, etc. */
-	struct dsa_port		*dp;
-
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	struct netpoll		*netpoll;
-#endif
-
-	/* TC context */
-	struct list_head	mall_tc_list;
-};
-
 /* dsa.c */
 const struct dsa_device_ops *dsa_tag_driver_get_by_id(int tag_protocol);
 const struct dsa_device_ops *dsa_tag_driver_get_by_name(const char *name);
@@ -277,41 +257,6 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 /* netlink.c */
 extern struct rtnl_link_ops dsa_link_ops __read_mostly;
 
-/* slave.c */
-extern struct notifier_block dsa_slave_switchdev_notifier;
-extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
-
-void dsa_slave_mii_bus_init(struct dsa_switch *ds);
-int dsa_slave_create(struct dsa_port *dp);
-void dsa_slave_destroy(struct net_device *slave_dev);
-int dsa_slave_suspend(struct net_device *slave_dev);
-int dsa_slave_resume(struct net_device *slave_dev);
-int dsa_slave_register_notifier(void);
-void dsa_slave_unregister_notifier(void);
-void dsa_slave_sync_ha(struct net_device *dev);
-void dsa_slave_unsync_ha(struct net_device *dev);
-void dsa_slave_setup_tagger(struct net_device *slave);
-int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
-int dsa_slave_change_master(struct net_device *dev, struct net_device *master,
-			    struct netlink_ext_ack *extack);
-int dsa_slave_manage_vlan_filtering(struct net_device *dev,
-				    bool vlan_filtering);
-
-static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
-{
-	struct dsa_slave_priv *p = netdev_priv(dev);
-
-	return p->dp;
-}
-
-static inline struct net_device *
-dsa_slave_to_master(const struct net_device *dev)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-
-	return dsa_port_to_master(dp);
-}
-
 /* If under a bridge with vlan_filtering=0, make sure to send pvid-tagged
  * frames as untagged, since the bridge will not untag them.
  */
diff --git a/net/dsa/netlink.c b/net/dsa/netlink.c
index ecf9ed1de185..824b09d904cc 100644
--- a/net/dsa/netlink.c
+++ b/net/dsa/netlink.c
@@ -5,6 +5,7 @@
 #include <net/rtnetlink.h>
 
 #include "dsa_priv.h"
+#include "slave.h"
 
 static const struct nla_policy dsa_policy[IFLA_DSA_MAX + 1] = {
 	[IFLA_DSA_MASTER]	= { .type = NLA_U32 },
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 0708fe8d4736..56728242f079 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -14,6 +14,7 @@
 
 #include "dsa_priv.h"
 #include "port.h"
+#include "slave.h"
 
 /**
  * dsa_port_notify - Notify the switching fabric of changes to a port
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 523f9ebeb45b..2cf83892072f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -25,6 +25,7 @@
 #include "dsa_priv.h"
 #include "port.h"
 #include "master.h"
+#include "slave.h"
 
 static void dsa_slave_standalone_event_work(struct work_struct *work)
 {
diff --git a/net/dsa/slave.h b/net/dsa/slave.h
new file mode 100644
index 000000000000..d0abe609e00d
--- /dev/null
+++ b/net/dsa/slave.h
@@ -0,0 +1,69 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef __DSA_SLAVE_H
+#define __DSA_SLAVE_H
+
+#include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
+#include <linux/list.h>
+#include <linux/netpoll.h>
+#include <linux/types.h>
+#include <net/dsa.h>
+#include <net/gro_cells.h>
+
+struct net_device;
+struct netlink_ext_ack;
+
+extern struct notifier_block dsa_slave_switchdev_notifier;
+extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
+
+struct dsa_slave_priv {
+	/* Copy of CPU port xmit for faster access in slave transmit hot path */
+	struct sk_buff *	(*xmit)(struct sk_buff *skb,
+					struct net_device *dev);
+
+	struct gro_cells	gcells;
+
+	/* DSA port data, such as switch, port index, etc. */
+	struct dsa_port		*dp;
+
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	struct netpoll		*netpoll;
+#endif
+
+	/* TC context */
+	struct list_head	mall_tc_list;
+};
+
+void dsa_slave_mii_bus_init(struct dsa_switch *ds);
+int dsa_slave_create(struct dsa_port *dp);
+void dsa_slave_destroy(struct net_device *slave_dev);
+int dsa_slave_suspend(struct net_device *slave_dev);
+int dsa_slave_resume(struct net_device *slave_dev);
+int dsa_slave_register_notifier(void);
+void dsa_slave_unregister_notifier(void);
+void dsa_slave_sync_ha(struct net_device *dev);
+void dsa_slave_unsync_ha(struct net_device *dev);
+void dsa_slave_setup_tagger(struct net_device *slave);
+int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
+int dsa_slave_change_master(struct net_device *dev, struct net_device *master,
+			    struct netlink_ext_ack *extack);
+int dsa_slave_manage_vlan_filtering(struct net_device *dev,
+				    bool vlan_filtering);
+
+static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+
+	return p->dp;
+}
+
+static inline struct net_device *
+dsa_slave_to_master(const struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	return dsa_port_to_master(dp);
+}
+
+#endif
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 5ece5c5c2acf..d0d5a1c7e6f6 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -14,6 +14,7 @@
 
 #include "dsa_priv.h"
 #include "port.h"
+#include "slave.h"
 
 static unsigned int dsa_switch_fastest_ageing_time(struct dsa_switch *ds,
 						   unsigned int ageing_time)
-- 
2.34.1

