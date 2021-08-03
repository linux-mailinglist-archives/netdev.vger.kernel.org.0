Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9AF3DF066
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhHCOgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:36:53 -0400
Received: from mail-eopbgr70049.outbound.protection.outlook.com ([40.107.7.49]:54849
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236502AbhHCOgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 10:36:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXvrUYdJH7fh/2nRHDC5S860GYMUUikuimxkCJJtnnjzGkjfCRby5cxwOv/30ZYLiWRq/+YeATqKqHxnPGfSkCJF+iaagHTBjYUSGusjMZ0XhVo4NYOaXJ96V+f7pBYGK75Oag9tIhWPnpegGJr3Tnr9UBj+QvRAa05blycsAdLZnldgeIZMg9sLvIGLU0lfHm6KWY4wqyRQTjOodDmt8zCM/RBqS03ocQ2li1hhny87FNgltRrO13311iv+SB+jWLL3QRXCOuq88LwdG85eantsKd6iok8RzaJSE4U7phe8SrKsE91FbImACu2UQjQ+9i+peaBJSN1Qvly6QMkVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Hlso+TjhoOXEn1JJNL+L6qyVARSaun65Oh1wEAAczk=;
 b=nkZ56ZOPiYB//DW3i7Mq0tNh/l9lIlPDjdqCgEpDXzKr7z7wbORbY3fHy4RgqCoxXnnfKY3FZQ0scbkinsPwHg+aJPpNyt+NXrMVRXTUQqWtnfTVelVo5m3umKsl/bVfUqZZe0apukynpfa085YUUsmTPizMT0x7r71g22VtjYl42niGuGsySPQXmyN1pCFqMxKUsu/zkc9bA8hFUnVo+BWhZ8/oobxAdMwOzI8ilXyo14kyMayWBEzML/ZTUoSlCcwgv3uh/NOehXtvM/gRpqstXET1GBvIyNKR5Y7Qg9wxSV+yq05SQb9Q1+KJ/XHy4zFwIbFbs8NoW+m2C0t3HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Hlso+TjhoOXEn1JJNL+L6qyVARSaun65Oh1wEAAczk=;
 b=g5U4c2lQrPtov5e2rc+e2VTpSbkNe2F8K8/zuxjhg160AWs+0/76FLr1+WyxTVyyr1yMLtwf5OamjQbqH88clECaPnpicDyzGqoaCPqO/Tq16x5tLk/uEMeSeSivG/dbKXeavTJX2if9da5LzVepgu8mRWEtFW2fVdu/22phf5M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Tue, 3 Aug
 2021 14:36:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 14:36:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>
Subject: [PATCH net-next 1/2] net: make switchdev_bridge_port_{,unoffload} loosely coupled with the bridge
Date:   Tue,  3 Aug 2021 17:36:23 +0300
Message-Id: <20210803143624.1135002-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
References: <20210803143624.1135002-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 14:36:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27c3ee0a-8c8a-4d4a-cd41-08d9568c1a1c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2797:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB27971E54CB21489631FEDFFEE0F09@VI1PR0402MB2797.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xacPKInI2zDBXbUYSZOd/v/fV/ZhNqrpJpfIjmLgoQVsdn2YR8GXjGZrAPwQDyrFweTdsTL1xxK9sTi8djoPUw6vbWN07rpwMqkipxVtVKWliMaG2y0vDTwMluuNeQCJpKL077CFddv52Mp+vPrOQKOsPYZJz5pZoF0HbD+ob5uxK595TO9eeQmTWtQ6hqpnNesRZGSVKUwkdi/06FJHQrOMM57HKsi42r1Tu/SLciycNviWr2CiJc3wIJPCEVZpgD62o14Chg69CvlbjfPmTq+u2StMhRRfp6Zin4TKnceG7CYO5z3vduHuVDmFpAuvu4eHIsBc+XzNz+Mfow+HfAPhuXjTAwHzuzjkaomRrEbDsP48XsmM8lgnZAf/CZjXPVURCXp1cNRsPLbf88VtC86dqa9SnAKYubItTXO305KJTcvK3zgu44Yp5NIHqXocHRUVkgBOzCJymJakMyRncz5ANeKcoQeyAP+QxqiaH5clDUufZ3RJpnOPl783P7jCtdXQMghd613C6kzS5C4WroL7vT7tgxU5W5rkyN7HpZ+VlQD8alG15PCLoFX38PALwiFTE4JBYg4dylET6NmdzwAf1ONHWe6elgJLKo+T4F+k6zwMFT37YkEH9fZ2E5R7rXcc6QOxtk0+lv/JkXWiCNpaAlYXNgRxWKxkiQzAxp5vDBUjWxj31JBdO8wB3g1gSZ+pvB3qRBIvhblQ9SOfI7JpUkHHlJuW+ZNZXnViQzFUtC2Z1IhsCTxwqhf1FTjxmvT4D3+wrAjBVL1RN96fVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(52116002)(38350700002)(38100700002)(956004)(54906003)(6512007)(2906002)(44832011)(2616005)(110136005)(26005)(6486002)(7416002)(6506007)(1076003)(8936002)(316002)(186003)(30864003)(86362001)(966005)(66556008)(66476007)(36756003)(478600001)(66946007)(5660300002)(8676002)(4326008)(83380400001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IJ5T59Tp4GYci3VJTimkk6eNMmGBO4tgMh72s+C8PBzEGBNX5RhKNKnc8ip1?=
 =?us-ascii?Q?/Sl0gnxRi9WOZ3cujCZjc6xxak3isDfoueZhbwveV9MXc3+oevLiaGmbW/qK?=
 =?us-ascii?Q?bVtNN91vXJkh7N04kfWO3fvddV13nLYaLXhaZpDp/smY7YFlC+UR3jQaisNm?=
 =?us-ascii?Q?GlSRSCEvojvpbLMz/k13X4+Q+0W//JDKrrtiQbqDXcu4YNTimATjbhYJ/yYN?=
 =?us-ascii?Q?XbMBfvKr4M8eQlCEsEBGre0jXIfE1EMUEvR+L62pbCaPwtnLg0TNd1PXtmk3?=
 =?us-ascii?Q?Au1XbMQCywhZIV3Ks+RegFQf4I5nKFPjeQLMVjd8G0G2dDeX9E9bb4gaOYI9?=
 =?us-ascii?Q?QOB3Q8rWzY1vZMbqBCmUWqq23o5K8BrTTjc3k0To78S4oMQMWFQCVxzX4syM?=
 =?us-ascii?Q?EAMEv08PfUucts4X+wif+AuCWcf3IUgUcximAwSpdyQPTmZDUqSFp/kxsRFp?=
 =?us-ascii?Q?70asSc5m7515BoAWaDqEkjonjg4lsBgRkoPym4J1/AF2lbUbQZIjV5CuWxAK?=
 =?us-ascii?Q?FtJa/IsqkmewDGf4GE4kDC5QFq8XPzeVabQ7ejYc3FR+hwk3pkxIr2KactML?=
 =?us-ascii?Q?Clx8OPZG0ztxb2o0KqHaeKUxmJ3q/NvWMGg5/7Tuleyd/xXkEFRaX8r+WQic?=
 =?us-ascii?Q?F93fzbM9sW8G2037MW4KG7PnVo2ILfrF+f6MTIYzrcSKajDfO9yRQmLG+Nt5?=
 =?us-ascii?Q?YnaXiuHi5THsdzAYrElR1K65yZYy0aqVJ8Rv06cYE4yP4zB9HvBPUkeojqSG?=
 =?us-ascii?Q?GZPf9d8qGEkpMYUzAuyx3wz2QGw3iSzG6KMbZvsrBQAoILLb7FBX9Ua1PrTR?=
 =?us-ascii?Q?hUSgcuJ+3NORoZJnifBB3lsxihJAkkFWjNVQGC4jrogantvjTqLSgmie7TTR?=
 =?us-ascii?Q?bK+u0Go9Ry87ZMSlFhy5NydFnlCFsYQRzTNl8afLN8DtXchMaeZp9Sku/+K2?=
 =?us-ascii?Q?XhiRMon5a9LZFqkDqIoFs5vJYCBviOdAHxuJmDkAD+4tn4sp4YdJEBUUEigb?=
 =?us-ascii?Q?GrppJJ1lq0zl/S7YQEQ+1PNcidHQtOhjYOuXHijZzXMz701fS4J/NFdhMnvo?=
 =?us-ascii?Q?wcToHK0cPA5s2agU7s6rIvXRX5md1D3OxB17sYK892iPMSLvps3xsFDFh2lA?=
 =?us-ascii?Q?6ySvWDIyD73plT/riaXA7kHVnwi5+b0HJCZnJWOg/mJh8W69T+Q3xqXHSMfY?=
 =?us-ascii?Q?y1quDc+izSbIr5gc2Mjoucd+OqSGMBgveN4ZkewbPxLRMvPKZtW5p6xUkzjY?=
 =?us-ascii?Q?+hJBYjeInPybG2ikibfJhtNxp3lDIsY+ns1b8Z771K04vd+F6lMYV3KADMtb?=
 =?us-ascii?Q?5WPwXFAk6NLnROwlqDrHJddI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27c3ee0a-8c8a-4d4a-cd41-08d9568c1a1c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 14:36:38.5050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xlF0YOcmIzn648Xmfj5jXI8awzIFF5qJGr0oxGATYlsdVKmlrn0CWEq+ua17WV5+mAeMlZn5nZy2Z2WhlpJYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of explicit offloading API in switchdev in commit
2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which bridge
ports are offloaded"), we started having Ethernet switch drivers calling
directly into a function exported by net/bridge/br_switchdev.c, which is
a function exported by the bridge driver.

This means that drivers that did not have an explicit dependency on the
bridge before, like cpsw and am65-cpsw, now do - otherwise it is not
possible to call a symbol exported by a driver that can be built as
module unless you are a module too.

There was an attempt to solve the dependency issue in the form of commit
b0e81817629a ("net: build all switchdev drivers as modules when the
bridge is a module"). Grygorii Strashko, however, says about it:

| In my opinion, the problem is a bit bigger here than just fixing the
| build :(
|
| In case, of ^cpsw the switchdev mode is kinda optional and in many
| cases (especially for testing purposes, NFS) the multi-mac mode is
| still preferable mode.
|
| There were no such tight dependency between switchdev drivers and
| bridge core before and switchdev serviced as independent, notification
| based layer between them, so ^cpsw still can be "Y" and bridge can be
| "M". Now for mostly every kernel build configuration the CONFIG_BRIDGE
| will need to be set as "Y", or we will have to update drivers to
| support build with BRIDGE=n and maintain separate builds for
| networking vs non-networking testing.  But is this enough?  Wouldn't
| it cause 'chain reaction' required to add more and more "Y" options
| (like CONFIG_VLAN_8021Q)?
|
| PS. Just to be sure we on the same page - ARM builds will be forced
| (with this patch) to have CONFIG_TI_CPSW_SWITCHDEV=m and so all our
| automation testing will just fail with omap2plus_defconfig.

In the light of this, it would be desirable for some configurations to
avoid dependencies between switchdev drivers and the bridge, and have
the switchdev mode as completely optional within the driver.

Arnd Bergmann also tried to write a patch which better expressed the
build time dependency for Ethernet switch drivers where the switchdev
support is optional, like cpsw/am65-cpsw, and this made the drivers
follow the bridge (compile as module if the bridge is a module) only if
the optional switchdev support in the driver was enabled in the first
place:
https://patchwork.kernel.org/project/netdevbpf/patch/20210802144813.1152762-1-arnd@kernel.org/

but this still did not solve the fact that cpsw and am65-cpsw now must
be built as modules when the bridge is a module - it just expressed
correctly that optional dependency. But the new behavior is an apparent
regression from Grygorii's perspective.

So to support the use case where the Ethernet driver is built-in,
NET_SWITCHDEV (a bool option) is enabled, and the bridge is a module, we
need a framework that can handle the possible absence of the bridge from
the running system, i.e. runtime bloatware as opposed to build-time
bloatware.

Luckily we already have this framework, since switchdev has been using
it extensively. Events from the bridge side are transmitted to the
driver side using notifier chains - this was originally done so that
unrelated drivers could snoop for events emitted by the bridge towards
ports that are implemented by other drivers (think of a switch driver
with LAG offload that listens for switchdev events on a bonding/team
interface that it offloads).

There are also events which are transmitted from the driver side to the
bridge side, which again are modeled using notifiers.
SWITCHDEV_FDB_ADD_TO_BRIDGE is an example of this, and deals with
notifying the bridge that a MAC address has been dynamically learned.
So there is a precedent we can use for modeling the new framework.

The difference compared to SWITCHDEV_FDB_ADD_TO_BRIDGE is that the work
that the bridge needs to do when a port becomes offloaded is blocking in
its nature: replay VLANs, MDBs etc. The calling context is indeed
blocking (we are under rtnl_mutex), but the existing switchdev
notification chain that the bridge is subscribed to is only the atomic
one. So we need to subscribe the bridge to the blocking switchdev
notification chain too.

This patch:
- keeps the driver-side perception of the switchdev_bridge_port_{,un}offload
  unchanged
- moves the implementation of switchdev_bridge_port_{,un}offload from
  the bridge module into the switchdev module.
- makes everybody that is subscribed to the switchdev blocking notifier
  chain "hear" offload & unoffload events
- makes the bridge driver subscribe and handle those events
- moves the bridge driver's handling of those events into 2 new
  functions called br_switchdev_port_{,un}offload. These functions
  contain in fact the core of the logic that was previously in
  switchdev_bridge_port_{,un}offload, just that now we go through an
  extra indirection layer to reach them.

Unlike all the other switchdev notification structures, the structure
used to carry the bridge port information, struct
switchdev_notifier_brport_info, does not contain a "bool handled".
This is because in the current usage pattern, we always know that a
switchdev bridge port offloading event will be handled by the bridge,
because the switchdev_bridge_port_offload() call was initiated by a
NETDEV_CHANGEUPPER event in the first place, where info->upper_dev is a
bridge. So if the bridge wasn't loaded, then the CHANGEUPPER event
couldn't have happened.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  2 +-
 drivers/net/ethernet/ti/cpsw_new.c       |  2 +-
 include/linux/if_bridge.h                | 35 ----------------
 include/net/switchdev.h                  | 46 +++++++++++++++++++++
 net/bridge/br.c                          | 51 +++++++++++++++++++++++-
 net/bridge/br_private.h                  | 30 ++++++++++++++
 net/bridge/br_switchdev.c                | 36 +++++------------
 net/switchdev/switchdev.c                | 48 ++++++++++++++++++++++
 8 files changed, 185 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4f67d1a98c0d..fb5d2ac3f0d2 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -7,7 +7,6 @@
 
 #include <linux/clk.h>
 #include <linux/etherdevice.h>
-#include <linux/if_bridge.h>
 #include <linux/if_vlan.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -28,6 +27,7 @@
 #include <linux/sys_soc.h>
 #include <linux/dma/ti-cppi5.h>
 #include <linux/dma/k3-udma-glue.h>
+#include <net/switchdev.h>
 
 #include "cpsw_ale.h"
 #include "cpsw_sl.h"
diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index b4f55ff4e84f..ae167223e87f 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/irqreturn.h>
 #include <linux/interrupt.h>
-#include <linux/if_bridge.h>
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
@@ -29,6 +28,7 @@
 #include <linux/kmemleak.h>
 #include <linux/sys_soc.h>
 
+#include <net/switchdev.h>
 #include <net/page_pool.h>
 #include <net/pkt_cls.h>
 #include <net/devlink.h>
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 21daed10322e..509e18c7e740 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -190,39 +190,4 @@ static inline clock_t br_get_ageing_time(const struct net_device *br_dev)
 }
 #endif
 
-#if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_NET_SWITCHDEV)
-
-int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev, const void *ctx,
-				  struct notifier_block *atomic_nb,
-				  struct notifier_block *blocking_nb,
-				  bool tx_fwd_offload,
-				  struct netlink_ext_ack *extack);
-void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				     const void *ctx,
-				     struct notifier_block *atomic_nb,
-				     struct notifier_block *blocking_nb);
-
-#else
-
-static inline int
-switchdev_bridge_port_offload(struct net_device *brport_dev,
-			      struct net_device *dev, const void *ctx,
-			      struct notifier_block *atomic_nb,
-			      struct notifier_block *blocking_nb,
-			      bool tx_fwd_offload,
-			      struct netlink_ext_ack *extack)
-{
-	return -EINVAL;
-}
-
-static inline void
-switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				const void *ctx,
-				struct notifier_block *atomic_nb,
-				struct notifier_block *blocking_nb)
-{
-}
-#endif
-
 #endif
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index 66468ff8cc0a..60d806b6a5ae 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -180,6 +180,14 @@ struct switchdev_obj_in_state_mrp {
 
 typedef int switchdev_obj_dump_cb_t(struct switchdev_obj *obj);
 
+struct switchdev_brport {
+	struct net_device *dev;
+	const void *ctx;
+	struct notifier_block *atomic_nb;
+	struct notifier_block *blocking_nb;
+	bool tx_fwd_offload;
+};
+
 enum switchdev_notifier_type {
 	SWITCHDEV_FDB_ADD_TO_BRIDGE = 1,
 	SWITCHDEV_FDB_DEL_TO_BRIDGE,
@@ -197,6 +205,9 @@ enum switchdev_notifier_type {
 	SWITCHDEV_VXLAN_FDB_ADD_TO_DEVICE,
 	SWITCHDEV_VXLAN_FDB_DEL_TO_DEVICE,
 	SWITCHDEV_VXLAN_FDB_OFFLOADED,
+
+	SWITCHDEV_BRPORT_OFFLOADED,
+	SWITCHDEV_BRPORT_UNOFFLOADED,
 };
 
 struct switchdev_notifier_info {
@@ -226,6 +237,11 @@ struct switchdev_notifier_port_attr_info {
 	bool handled;
 };
 
+struct switchdev_notifier_brport_info {
+	struct switchdev_notifier_info info; /* must be first */
+	const struct switchdev_brport brport;
+};
+
 static inline struct net_device *
 switchdev_notifier_info_to_dev(const struct switchdev_notifier_info *info)
 {
@@ -246,6 +262,17 @@ switchdev_fdb_is_dynamically_learned(const struct switchdev_notifier_fdb_info *f
 
 #ifdef CONFIG_NET_SWITCHDEV
 
+int switchdev_bridge_port_offload(struct net_device *brport_dev,
+				  struct net_device *dev, const void *ctx,
+				  struct notifier_block *atomic_nb,
+				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
+				  struct netlink_ext_ack *extack);
+void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				     const void *ctx,
+				     struct notifier_block *atomic_nb,
+				     struct notifier_block *blocking_nb);
+
 void switchdev_deferred_process(void);
 int switchdev_port_attr_set(struct net_device *dev,
 			    const struct switchdev_attr *attr,
@@ -316,6 +343,25 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 				      struct netlink_ext_ack *extack));
 #else
 
+static inline int
+switchdev_bridge_port_offload(struct net_device *brport_dev,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
+			      struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void
+switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				const void *ctx,
+				struct notifier_block *atomic_nb,
+				struct notifier_block *blocking_nb)
+{
+}
+
 static inline void switchdev_deferred_process(void)
 {
 }
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 8fb5dca5f8e0..d3a32c6813e0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -201,6 +201,48 @@ static struct notifier_block br_switchdev_notifier = {
 	.notifier_call = br_switchdev_event,
 };
 
+/* called under rtnl_mutex */
+static int br_switchdev_blocking_event(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
+{
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
+	struct net_device *dev = switchdev_notifier_info_to_dev(ptr);
+	struct switchdev_notifier_brport_info *brport_info;
+	const struct switchdev_brport *b;
+	struct net_bridge_port *p;
+	int err = NOTIFY_DONE;
+
+	p = br_port_get_rtnl(dev);
+	if (!p)
+		goto out;
+
+	switch (event) {
+	case SWITCHDEV_BRPORT_OFFLOADED:
+		brport_info = ptr;
+		b = &brport_info->brport;
+
+		err = br_switchdev_port_offload(p, b->dev, b->ctx,
+						b->atomic_nb, b->blocking_nb,
+						b->tx_fwd_offload, extack);
+		err = notifier_from_errno(err);
+		break;
+	case SWITCHDEV_BRPORT_UNOFFLOADED:
+		brport_info = ptr;
+		b = &brport_info->brport;
+
+		br_switchdev_port_unoffload(p, b->ctx, b->atomic_nb,
+					    b->blocking_nb);
+		break;
+	}
+
+out:
+	return err;
+}
+
+static struct notifier_block br_switchdev_blocking_notifier = {
+	.notifier_call = br_switchdev_blocking_event,
+};
+
 /* br_boolopt_toggle - change user-controlled boolean option
  *
  * @br: bridge device
@@ -355,10 +397,14 @@ static int __init br_init(void)
 	if (err)
 		goto err_out4;
 
-	err = br_netlink_init();
+	err = register_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
 	if (err)
 		goto err_out5;
 
+	err = br_netlink_init();
+	if (err)
+		goto err_out6;
+
 	brioctl_set(br_ioctl_stub);
 
 #if IS_ENABLED(CONFIG_ATM_LANE)
@@ -373,6 +419,8 @@ static int __init br_init(void)
 
 	return 0;
 
+err_out6:
+	unregister_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
 err_out5:
 	unregister_switchdev_notifier(&br_switchdev_notifier);
 err_out4:
@@ -392,6 +440,7 @@ static void __exit br_deinit(void)
 {
 	stp_proto_unregister(&br_stp_proto);
 	br_netlink_fini();
+	unregister_switchdev_blocking_notifier(&br_switchdev_blocking_notifier);
 	unregister_switchdev_notifier(&br_switchdev_notifier);
 	unregister_netdevice_notifier(&br_device_notifier);
 	brioctl_set(NULL);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index c939631428b9..c9bb710cf493 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1880,6 +1880,17 @@ static inline void br_sysfs_delbr(struct net_device *dev) { return; }
 
 /* br_switchdev.c */
 #ifdef CONFIG_NET_SWITCHDEV
+int br_switchdev_port_offload(struct net_bridge_port *p,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
+			      struct netlink_ext_ack *extack);
+
+void br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
+				 struct notifier_block *atomic_nb,
+				 struct notifier_block *blocking_nb);
+
 bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb);
 
 void br_switchdev_frame_set_offload_fwd_mark(struct sk_buff *skb);
@@ -1908,6 +1919,25 @@ static inline void br_switchdev_frame_unmark(struct sk_buff *skb)
 	skb->offload_fwd_mark = 0;
 }
 #else
+static inline int
+br_switchdev_port_offload(struct net_bridge_port *p,
+			  struct net_device *dev, const void *ctx,
+			  struct notifier_block *atomic_nb,
+			  struct notifier_block *blocking_nb,
+			  bool tx_fwd_offload,
+			  struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void
+br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
+			    struct notifier_block *atomic_nb,
+			    struct notifier_block *blocking_nb)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline bool br_switchdev_frame_uses_tx_fwd_offload(struct sk_buff *skb)
 {
 	return false;
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index a3cd79e3e81c..97129f09a5bf 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -315,23 +315,16 @@ static void nbp_switchdev_unsync_objs(struct net_bridge_port *p,
 /* Let the bridge know that this port is offloaded, so that it can assign a
  * switchdev hardware domain to it.
  */
-int switchdev_bridge_port_offload(struct net_device *brport_dev,
-				  struct net_device *dev, const void *ctx,
-				  struct notifier_block *atomic_nb,
-				  struct notifier_block *blocking_nb,
-				  bool tx_fwd_offload,
-				  struct netlink_ext_ack *extack)
+int br_switchdev_port_offload(struct net_bridge_port *p,
+			      struct net_device *dev, const void *ctx,
+			      struct notifier_block *atomic_nb,
+			      struct notifier_block *blocking_nb,
+			      bool tx_fwd_offload,
+			      struct netlink_ext_ack *extack)
 {
 	struct netdev_phys_item_id ppid;
-	struct net_bridge_port *p;
 	int err;
 
-	ASSERT_RTNL();
-
-	p = br_port_get_rtnl(brport_dev);
-	if (!p)
-		return -ENODEV;
-
 	err = dev_get_port_parent_id(dev, &ppid, false);
 	if (err)
 		return err;
@@ -351,23 +344,12 @@ int switchdev_bridge_port_offload(struct net_device *brport_dev,
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
 
-void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
-				     const void *ctx,
-				     struct notifier_block *atomic_nb,
-				     struct notifier_block *blocking_nb)
+void br_switchdev_port_unoffload(struct net_bridge_port *p, const void *ctx,
+				 struct notifier_block *atomic_nb,
+				 struct notifier_block *blocking_nb)
 {
-	struct net_bridge_port *p;
-
-	ASSERT_RTNL();
-
-	p = br_port_get_rtnl(brport_dev);
-	if (!p)
-		return;
-
 	nbp_switchdev_unsync_objs(p, ctx, atomic_nb, blocking_nb);
 
 	nbp_switchdev_del(p);
 }
-EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 0ae3478561f4..0b2c18efc079 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -809,3 +809,51 @@ int switchdev_handle_port_attr_set(struct net_device *dev,
 	return err;
 }
 EXPORT_SYMBOL_GPL(switchdev_handle_port_attr_set);
+
+int switchdev_bridge_port_offload(struct net_device *brport_dev,
+				  struct net_device *dev, const void *ctx,
+				  struct notifier_block *atomic_nb,
+				  struct notifier_block *blocking_nb,
+				  bool tx_fwd_offload,
+				  struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_brport_info brport_info = {
+		.brport = {
+			.dev = dev,
+			.ctx = ctx,
+			.atomic_nb = atomic_nb,
+			.blocking_nb = blocking_nb,
+			.tx_fwd_offload = tx_fwd_offload,
+		},
+	};
+	int err;
+
+	ASSERT_RTNL();
+
+	err = call_switchdev_blocking_notifiers(SWITCHDEV_BRPORT_OFFLOADED,
+						brport_dev, &brport_info.info,
+						extack);
+	return notifier_to_errno(err);
+}
+EXPORT_SYMBOL_GPL(switchdev_bridge_port_offload);
+
+void switchdev_bridge_port_unoffload(struct net_device *brport_dev,
+				     const void *ctx,
+				     struct notifier_block *atomic_nb,
+				     struct notifier_block *blocking_nb)
+{
+	struct switchdev_notifier_brport_info brport_info = {
+		.brport = {
+			.ctx = ctx,
+			.atomic_nb = atomic_nb,
+			.blocking_nb = blocking_nb,
+		},
+	};
+
+	ASSERT_RTNL();
+
+	call_switchdev_blocking_notifiers(SWITCHDEV_BRPORT_UNOFFLOADED,
+					  brport_dev, &brport_info.info,
+					  NULL);
+}
+EXPORT_SYMBOL_GPL(switchdev_bridge_port_unoffload);
-- 
2.25.1

