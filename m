Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C7D6D9647
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbjDFLuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237641AbjDFLt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:49:29 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E130D521
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 04:45:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldrQd6eOiJ3e1ZZoDI3dV38VmvxuCB8J0fiWsM3yg8gXKmE7c7FlC3oYiGODSjZB9NpRoe5LAV3r3/ccu1qob7gr/wB4RxoZDaDFbYy6pIf63cPAEnT6s3fPBWg1gftBFlq41rm9sAMJT5d82zzD5bbhCTCiQlbiP5U8o47rw5dNuSvTXvEfWBFElF2ysxBVnFiiSj8aLCO2/vgI7woooAUdTJSq8+YHsK0R8sua+TS1kSq9EJGHQYy0PzgqYvZ0cvD9rgZfZSCiSFOFKl6S+QEdgq8AisDf4rgz9+jKycpWGw0xuAltvUOlvQrVXVsWeeIseGrdp7EHI3/8Ky/G5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRTx1rcm6v1TURmFMF2FYQPX+14HwU5IaXC4oCchPDY=;
 b=JA+28w6pPdDQ1Esb4aWHgha0BMl9XpJhpCNMrDaYSrkr5dfL1OHWvOlo0FwnwpptJps1L9RnTe6Qs7Vg7YyQxjTLSwVVeU4PIrtWrwcufuHQYJqAJq+SfJTqpQwYth83OwoeyR7PNbk1sthn2nyU5XNQLVfBGKwDL46xLH7gb6Vi2D9sR367IUj+MhwwNq72SS4aAU/D4/RCTi+1ET1TCIJhS9RQue7Zt1I5T1rbH6kepygkMMJw83oPIpp2Vq+lODWf5Hb7E2zK87nh5QXVD6AsK2LHia+oPOowo9XIr93jd8aiT32Oyr1iUEDVtQWHY8G2dg2EZpORCHH8B3dTLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRTx1rcm6v1TURmFMF2FYQPX+14HwU5IaXC4oCchPDY=;
 b=iyMN8hSCem2DQC4rx/2FFeTYKJH7pR3U/Tjq2loMywhiqNVlAoIYxyv0ya0woYY7JTbZIklgiAX2x8YU10wpVIRjpoy8rTcfN0mBLpqS/r1T0DwHIJoCOXyDMQjLaB43ps3wIvoDgkuBoHNorM1rUF8eoRatIrDcHB7WlSfoWvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by PAXPR04MB8375.eurprd04.prod.outlook.com (2603:10a6:102:1be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Thu, 6 Apr
 2023 11:43:02 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::e555:cc9e:b278:15d9%7]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 11:43:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: replace NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Date:   Thu,  6 Apr 2023 14:42:46 +0300
Message-Id: <20230406114246.33150-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0169.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b4::11) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|PAXPR04MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: 07cb40f8-f467-46c0-07d6-08db36941424
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xscCsQQ205dXqatN/AFYdV/RpiX35R2Me8p2h7fUpiZeGcSDdcAFcuEBUZGi6LerLZiMVYyk1tbTa8Ap4/exUQfmKJF/KdAZK2b+AYc470hr2tjQUNYCxxzkWrbBm1WZfyDXvMTkCVO0KsKPa5VXItuHAwBqXZKxXaj+2YwqgAxkDKfOishIbgevdAm+i0PFm2WVCRUpWcBkf/7SNXHQ+xdlwqxzg498PAOIOGjGpWjFqqad0bIsyrRKl7MxkJ7LC4bGjIYpxidr3b8feDRJElyVlH557qok2Y2WKEGuTRqftpIusVADZUSReGWb6GHEPZUHiXcJhtMihRt4FGS28pNZBo06J1aUiiEIyyJwF0LTS3ZfChcnfr2uGUala0I75nqpGIuvtV9exzf8q2dK/Lv3u5h/LicgzGAWx6TWpTld87NhgCaVYaWjIX6vYJfTGAnc5m90jGz/f/e698SZB3E7jlRQ7DsQYOe+h91EpX/vSho/CkEODcHLDRZCITISwGjTlg4V4+7JT9JLR3wG+ehBa5BaxWbBeJOGPD+kWUZxwo5c81vWG71/vJ0JgDeB58lorQwPP+QYpcsvPPWVNKDJCQIIuOsBBB28NS6fGHY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(136003)(346002)(396003)(451199021)(478600001)(6666004)(6486002)(186003)(316002)(54906003)(52116002)(1076003)(6512007)(6506007)(26005)(966005)(44832011)(2906002)(30864003)(41300700001)(66476007)(66556008)(66946007)(8676002)(8936002)(5660300002)(4326008)(6916009)(38350700002)(38100700002)(36756003)(83380400001)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jZdlwr7aBbl1G6ti1tSR4Vjz04O6KttZ56KrqJlUAP2j0Ha/mU7aU8Ocoocl?=
 =?us-ascii?Q?WsVuZhe885v3IwHINLMjRdCwteDa1pJyFIze7/glrPEKSh2DaQYohpxpGcvL?=
 =?us-ascii?Q?PcxDe9xlnx1a6uwkOB3VC84f2PS5TGrNeGwCG9BJPDUZeHbcHAm/C3txRc6/?=
 =?us-ascii?Q?UpyyAIz0Em0FnIfGKT6LbcoYbVfh5vBw0pq9wIeOQ3hIm2gSdvlMNXQG2jS/?=
 =?us-ascii?Q?JDcCtce0+hBT3H5WZA5kYKl5wdY8SdpgMmiVAlAnFa6mnGYDxtOGYERAmzMj?=
 =?us-ascii?Q?In5wXJ1+3J3iDy1dFzzTX4cE7iJzZcV4wyyH+bH4ainMwPojTKdbPNMwRZK0?=
 =?us-ascii?Q?jA3sc04a0OfcFw/8enXluDRG+osBtXzNM+CMADiKuqzFOC4UQwNtOkpBCPXP?=
 =?us-ascii?Q?QmK5qWyKtrPoPsNfF79YvFHRq+ZXWzE3cmhsScJHXydj9SgSV1bW6dg3uayB?=
 =?us-ascii?Q?7CobxhiyIFoAkKg8PNR+BPSLhd3DKInx8asDIRAR3xwYs/gJF8oeaFEJBCSF?=
 =?us-ascii?Q?ePCp6jP9lzZDpbL4y4dDqTPIGEouo725Ra3ZC2DKzGAS69X1mPL8DL4gcaG9?=
 =?us-ascii?Q?esDMxiRLI/k3xl7ABjQLFKydIaJyrXAblt5RZiHmhaczb7WgtUHf/z9QJGc3?=
 =?us-ascii?Q?7IvS20kHJZP1McyBP2gBKLNWLy81/pzOVHG0yW1IhkoFdMqwX9Od+hP2Ov43?=
 =?us-ascii?Q?duKyOxtM3TQp2QKkUbPNVuggDyYyEPtOhaAuihru3Q6PxlNpptzmVxAEgj4J?=
 =?us-ascii?Q?I/jELXLAgvWLcqSsaSwyOtHE31gtzOZN8NaQEEJIedwDvYA48xmNfDKdsYgk?=
 =?us-ascii?Q?0x3ajeLjT4Sof/OOtzTcp+v5RkKazIk7Wbm4PU0PdBr+YRLXI/PPqh6jZDdn?=
 =?us-ascii?Q?p3zzcECFxEo7oYz+gexGCDqi889Z04max96Gxog1I9ktC+3MfdYCU8xn9cHj?=
 =?us-ascii?Q?PrH7TF28eINcZyvBP35vpGagw3IoLpkr5oSs2IKfX/7GSnHhnUZwLYWCgErt?=
 =?us-ascii?Q?a5mbv9+RuDfT1IR6TYPRjIeVxR468htlotOoThE+SUXGDXCL2/fCJYRBy2AL?=
 =?us-ascii?Q?exjJoXte+0vr73cu4/qNCWBxDQFA1pbuMBMTnrAiV7d1SeZwynpjl1lRVAV2?=
 =?us-ascii?Q?KZ0mXJQEcwKi5cm4Q/jzSK5bqKT5w5gAsJFwQmrSnJTv2IuEXsgC2agD54h9?=
 =?us-ascii?Q?WnrJSHFrUikupFrQYnazH9sysyOMfLkDwcZTg0/tAP4NRLhfbrpySroK0sEV?=
 =?us-ascii?Q?ySlo/JgbSqvnpMaX1+eEVGOKLXl0UC8OXuX6LqMtsIQwktvXx4isPAqxq/Dz?=
 =?us-ascii?Q?tPgHtwcCEFdWrs37tWXnjhsGYJtaz5PKnQ4i20MFtx2G9N2s1fJyCviys14Q?=
 =?us-ascii?Q?V9kQ+W6nqWtEkJv6qH4TZ8vZkDhtRc+zmHE37bXoXnqkMLj5X6znLW6uWVaY?=
 =?us-ascii?Q?Nx4fw75ibaHR3WKOdYGfT7bHzmOGIHrOoAVH+oxiPreHj244PVpsZdH8zu/g?=
 =?us-ascii?Q?LxiHnKnSwF7iRtHRGI/ZD8745crpbd8fqIcLm50s3VIFFrQWlRPehlgaCcnC?=
 =?us-ascii?Q?tdl0nk7iTgQGUStrOA2yfy3skJIp+m6NMZyzTtmSMDfFPeN+yKWxkrWlSjgz?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07cb40f8-f467-46c0-07d6-08db36941424
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 11:43:02.6495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XTwHUDhquDJ8u2SfPG06Me0f5sANgPwVQRrQArZAbR+6qm4nzNWAS5tkOrs8Jg5Q201xqNNWZDRX7MIIgnSo6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8375
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There was a sort of rush surrounding commit 88c0a6b503b7 ("net: create a
netdev notifier for DSA to reject PTP on DSA master"), due to a desire
to convert DSA's attempt to deny TX timestamping on a DSA master to
something that doesn't block the kernel-wide API conversion from
ndo_eth_ioctl() to ndo_hwtstamp_set().

What was required was a mechanism that did not depend on ndo_eth_ioctl(),
and what was provided was a mechanism that did not depend on
ndo_eth_ioctl(), while at the same time introducing something that
wasn't absolutely necessary - a new netdev notifier.

There have been objections from Jakub Kicinski that using notifiers in
general when they are not absolutely necessary creates complications to
the control flow and difficulties to maintainers who look at the code.
So there is a desire to not use notifiers.

In addition to that, the notifier chain gets called even if there is no
DSA in the system and no one is interested in applying any restriction.

Take the model of udp_tunnel_nic_ops and introduce a stub mechanism,
through which net/core/dev_ioctl.c can call into DSA even when
CONFIG_NET_DSA=m.

Compared to the code that existed prior to the notifier conversion, aka
what was added in commits:
- 4cfab3566710 ("net: dsa: Add wrappers for overloaded ndo_ops")
- 3369afba1e46 ("net: Call into DSA netdevice_ops wrappers")

this is different because we are not overloading any struct
net_device_ops of the DSA master anymore, but rather, we are exposing a
rather specific functionality which is orthogonal to which API is used
to enable it - ndo_eth_ioctl() or ndo_hwtstamp_set().

Also, what is similar is that both approaches use function pointers to
get from built-in code to DSA.

There is no point in replicating the function pointers towards
__dsa_master_hwtstamp_validate() once for every CPU port (dev->dsa_ptr).
Instead, it is sufficient to introduce a singleton struct dsa_stubs,
built into the kernel, which contains a single function pointer to
__dsa_master_hwtstamp_validate().

I find this approach preferable to what we had originally, because
dev->dsa_ptr->netdev_ops->ndo_do_ioctl() used to require going through
struct dsa_port (dev->dsa_ptr), and so, this was incompatible with any
attempts to add any data encapsulation and hide DSA data structures from
the outside world.

Link: https://lore.kernel.org/netdev/20230403083019.120b72fd@kernel.org/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2:
- reword commit message
- remove unnecessary dsa_stubs_lock
- delete extack variable from dsa_slave_netdevice_event()

 include/linux/netdevice.h |  6 -----
 include/net/dsa_stubs.h   | 48 +++++++++++++++++++++++++++++++++++++++
 net/Makefile              |  2 +-
 net/core/dev.c            |  2 +-
 net/core/dev_ioctl.c      | 12 ++--------
 net/dsa/Makefile          |  6 +++++
 net/dsa/dsa.c             | 19 ++++++++++++++++
 net/dsa/master.c          |  2 +-
 net/dsa/master.h          |  2 +-
 net/dsa/slave.c           | 11 ---------
 net/dsa/stubs.c           | 10 ++++++++
 11 files changed, 89 insertions(+), 31 deletions(-)
 create mode 100644 include/net/dsa_stubs.h
 create mode 100644 net/dsa/stubs.c

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a740be3bb911..1c25b39681b3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2878,7 +2878,6 @@ enum netdev_cmd {
 	NETDEV_OFFLOAD_XSTATS_REPORT_USED,
 	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
 	NETDEV_XDP_FEAT_CHANGE,
-	NETDEV_PRE_CHANGE_HWTSTAMP,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
@@ -2929,11 +2928,6 @@ struct netdev_notifier_pre_changeaddr_info {
 	const unsigned char *dev_addr;
 };
 
-struct netdev_notifier_hwtstamp_info {
-	struct netdev_notifier_info info; /* must be first */
-	struct kernel_hwtstamp_config *config;
-};
-
 enum netdev_offload_xstats_type {
 	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
 };
diff --git a/include/net/dsa_stubs.h b/include/net/dsa_stubs.h
new file mode 100644
index 000000000000..361811750a54
--- /dev/null
+++ b/include/net/dsa_stubs.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * include/net/dsa_stubs.h - Stubs for the Distributed Switch Architecture framework
+ */
+
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/net_tstamp.h>
+#include <net/dsa.h>
+
+#if IS_ENABLED(CONFIG_NET_DSA)
+
+extern const struct dsa_stubs *dsa_stubs;
+
+struct dsa_stubs {
+	int (*master_hwtstamp_validate)(struct net_device *dev,
+					const struct kernel_hwtstamp_config *config,
+					struct netlink_ext_ack *extack);
+};
+
+static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
+					       const struct kernel_hwtstamp_config *config,
+					       struct netlink_ext_ack *extack)
+{
+	if (!netdev_uses_dsa(dev))
+		return 0;
+
+	/* rtnl_lock() is a sufficient guarantee, because as long as
+	 * netdev_uses_dsa() returns true, the dsa_core module is still
+	 * registered, and so, dsa_unregister_stubs() couldn't have run.
+	 * For netdev_uses_dsa() to start returning false, it would imply that
+	 * dsa_master_teardown() has executed, which requires rtnl_lock().
+	 */
+	ASSERT_RTNL();
+
+	return dsa_stubs->master_hwtstamp_validate(dev, config, extack);
+}
+
+#else
+
+static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
+					       const struct kernel_hwtstamp_config *config,
+					       struct netlink_ext_ack *extack)
+{
+	return 0;
+}
+
+#endif
diff --git a/net/Makefile b/net/Makefile
index 0914bea9c335..87592009366f 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -24,7 +24,7 @@ obj-$(CONFIG_PACKET)		+= packet/
 obj-$(CONFIG_NET_KEY)		+= key/
 obj-$(CONFIG_BRIDGE)		+= bridge/
 obj-$(CONFIG_NET_DEVLINK)	+= devlink/
-obj-$(CONFIG_NET_DSA)		+= dsa/
+obj-y				+= dsa/
 obj-$(CONFIG_ATALK)		+= appletalk/
 obj-$(CONFIG_X25)		+= x25/
 obj-$(CONFIG_LAPB)		+= lapb/
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ce5985be84b..480600a075ce 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1612,7 +1612,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
 	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
 	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
-	N(XDP_FEAT_CHANGE) N(PRE_CHANGE_HWTSTAMP)
+	N(XDP_FEAT_CHANGE)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 6d772837eb3f..3730945ee294 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -7,7 +7,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/wireless.h>
 #include <linux/if_bridge.h>
-#include <net/dsa.h>
+#include <net/dsa_stubs.h>
 #include <net/wext.h>
 
 #include "dev.h"
@@ -259,9 +259,6 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	struct netdev_notifier_hwtstamp_info info = {
-		.info.dev = dev,
-	};
 	struct kernel_hwtstamp_config kernel_cfg;
 	struct netlink_ext_ack extack = {};
 	struct hwtstamp_config cfg;
@@ -276,12 +273,7 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 	if (err)
 		return err;
 
-	info.info.extack = &extack;
-	info.config = &kernel_cfg;
-
-	err = call_netdevice_notifiers_info(NETDEV_PRE_CHANGE_HWTSTAMP,
-					    &info.info);
-	err = notifier_to_errno(err);
+	err = dsa_master_hwtstamp_validate(dev, &kernel_cfg, &extack);
 	if (err) {
 		if (extack._msg)
 			netdev_err(dev, "%s\n", extack._msg);
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index cc7e93a562fe..3835de286116 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -1,4 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0
+
+# the stubs are built-in whenever DSA is built-in or module
+ifdef CONFIG_NET_DSA
+obj-y := stubs.o
+endif
+
 # the core
 obj-$(CONFIG_NET_DSA) += dsa_core.o
 dsa_core-y += \
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index e5f156940c67..ab1afe67fd18 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -17,6 +17,7 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <net/dsa_stubs.h>
 #include <net/sch_generic.h>
 
 #include "devlink.h"
@@ -1702,6 +1703,20 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 
+static const struct dsa_stubs __dsa_stubs = {
+	.master_hwtstamp_validate = __dsa_master_hwtstamp_validate,
+};
+
+static void dsa_register_stubs(void)
+{
+	dsa_stubs = &__dsa_stubs;
+}
+
+static void dsa_unregister_stubs(void)
+{
+	dsa_stubs = NULL;
+}
+
 static int __init dsa_init_module(void)
 {
 	int rc;
@@ -1721,6 +1736,8 @@ static int __init dsa_init_module(void)
 	if (rc)
 		goto netlink_register_fail;
 
+	dsa_register_stubs();
+
 	return 0;
 
 netlink_register_fail:
@@ -1735,6 +1752,8 @@ module_init(dsa_init_module);
 
 static void __exit dsa_cleanup_module(void)
 {
+	dsa_unregister_stubs();
+
 	rtnl_link_unregister(&dsa_link_ops);
 
 	dsa_slave_unregister_notifier();
diff --git a/net/dsa/master.c b/net/dsa/master.c
index c2cabe6248b1..6be89ab0cc01 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -198,7 +198,7 @@ static void dsa_master_get_strings(struct net_device *dev, uint32_t stringset,
 /* Deny PTP operations on master if there is at least one switch in the tree
  * that is PTP capable.
  */
-int dsa_master_pre_change_hwtstamp(struct net_device *dev,
+int __dsa_master_hwtstamp_validate(struct net_device *dev,
 				   const struct kernel_hwtstamp_config *config,
 				   struct netlink_ext_ack *extack)
 {
diff --git a/net/dsa/master.h b/net/dsa/master.h
index 80842f4e27f7..76e39d3ec909 100644
--- a/net/dsa/master.h
+++ b/net/dsa/master.h
@@ -15,7 +15,7 @@ int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
 			 struct netlink_ext_ack *extack);
 void dsa_master_lag_teardown(struct net_device *lag_dev,
 			     struct dsa_port *cpu_dp);
-int dsa_master_pre_change_hwtstamp(struct net_device *dev,
+int __dsa_master_hwtstamp_validate(struct net_device *dev,
 				   const struct kernel_hwtstamp_config *config,
 				   struct netlink_ext_ack *extack);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8abc1658ac47..165bb2cb8431 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -3289,7 +3289,6 @@ static int dsa_master_changeupper(struct net_device *dev,
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
-	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
@@ -3419,16 +3418,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 
 		return NOTIFY_OK;
 	}
-	case NETDEV_PRE_CHANGE_HWTSTAMP: {
-		struct netdev_notifier_hwtstamp_info *info = ptr;
-		int err;
-
-		if (!netdev_uses_dsa(dev))
-			return NOTIFY_DONE;
-
-		err = dsa_master_pre_change_hwtstamp(dev, info->config, extack);
-		return notifier_from_errno(err);
-	}
 	default:
 		break;
 	}
diff --git a/net/dsa/stubs.c b/net/dsa/stubs.c
new file mode 100644
index 000000000000..2ed8a6c85fbf
--- /dev/null
+++ b/net/dsa/stubs.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Stubs for DSA functionality called by the core network stack.
+ * These are necessary because CONFIG_NET_DSA can be a module, and built-in
+ * code cannot directly call symbols exported by modules.
+ */
+#include <net/dsa_stubs.h>
+
+const struct dsa_stubs *dsa_stubs;
+EXPORT_SYMBOL_GPL(dsa_stubs);
-- 
2.34.1

