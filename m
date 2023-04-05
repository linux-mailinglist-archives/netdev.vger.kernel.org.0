Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A600C6D8418
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 18:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjDEQvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 12:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjDEQve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 12:51:34 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2077.outbound.protection.outlook.com [40.107.22.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908F63AAB
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 09:51:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQto+zaEatTFHt80+gSrRTiu09G9vmdjvl5xDsh3pbDRjfO1599gmjrLWr82l+Q1RyP7Y70O5J7DQpfKUP0bKFwJpIflMY64I8lszM/ZYhkIOvWfLCJlUYWcdvCWbRh4Uh0omGOa6MgVMN2Dvfu2nvyG8PEdDL47kzLSrqoqNWniX2QFuVtJc7IyNNGnhGbVFY60Yc1YOWS9bdMYBcYO/y/IdKiEz3Qhj4Qk3R/HqYAwEXat6k+LvbpZpW1DztF2nq3COEchtU59pZW25IsKqv/5k7523dW/+mHTlxuL05Jr8ib/9MEHB1JYIpJ/+a2jIxOVcbHN3ykvaPB8a85NMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hz2PWayMuSdKF2MFmhetCEnnuNM8KUuknHe/XNtPrUs=;
 b=WjssMoSxQtKMAfujeY9jm9AII8TlrlPE3X1I9YeliwfSTZ5oXOgE+pfRJiR+pp1TDbAz2N0xAdCILAzDNwHMxHLNzIGfX2wmqq1dEKFBd2B3LoKZLztB3EktK6pgYRE9uUGpKBXzVzXswC9KPg+narJeODLB/e3UdNNGDcK6HLzPu+cIp4wXjIQUbOnwKj6QYP2dRVD/O8q5mLmKJVGDWN1SjfwioAUWUFXusCoJr2KCiAhAADFaKOaZj4polleAUU0JCFx7ER5iEO6Go+pu2p76XIRO2f/r0cvTrzfpNgbZiE2iVRYChDKJRATO5momSuZwoQIMKwbatFHGn/3Usw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hz2PWayMuSdKF2MFmhetCEnnuNM8KUuknHe/XNtPrUs=;
 b=nbBsQqDJiG2wQugnTcri4OobQPb7hIXjieE26JULAcgpQlygMmhpJLZarIb3mfooHEiWxvlZkahmeQgJ0vk4DCaL6NeiW8w7EiGW/zkxPsVmXs8oqzSuVf1mlCDgASoCpnjyAupWxuBIT8/3a+N35R3xUm55I/G5RhRVj15FNxk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM9PR04MB8472.eurprd04.prod.outlook.com (2603:10a6:20b:417::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 16:51:30 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Wed, 5 Apr 2023
 16:51:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [RFC PATCH net-next] net: dsa: replace NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
Date:   Wed,  5 Apr 2023 19:51:15 +0300
Message-Id: <20230405165115.3744445-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0111.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM9PR04MB8472:EE_
X-MS-Office365-Filtering-Correlation-Id: 3342681e-00b7-4016-5e99-08db35f600e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B324lAd1l4Wbb8gWcItpBjXXIDq35ORcXwQgKTlsE//utuPkCEO0/XBOtQBFFX258MPSmryAbizY7qY/+KZK+6NMOXtryy1h/VnKYKdGNsSAZh6FAHP4Ye6qP3nwQU7cpOvLBDmwPn8R8nLmrEO4mH6zryAaQlHHvU5cGPuG32SNL7IKxjZtbkaWi4sm/UsqdVDIW6HI7evaNVxo+0GS9JoxwpeNdINwqLEi0wGbDYSc21BdyMJJGKNrx5D9c5xBp82/IX/WJCrqOqcPLDDqwMWrb/GBUuyLFLdR7sdDzIj9vhebyKtLAw+AVFqBWEpMjml8BLRd/T2kkB1aLNoHvoPr+2P4oWIDzjcWPqG00HzLPTKPAlAJiYB1udyJBDlNErroUYQvRST2QZqfKs+8PuF0Uuq11Sd3HH31trIfdiCPsTcaeLYcWf+A4+Q1PxKAd0KFAeqcfzB47E2TTtcj5abtF9BrqOElF4+RmJUTHBXVjuNG7gSZ8Oe0t6YbDgrplMZEXWqwlu7Tfi3OOsQaOykFdEOjJhcJh0EnHXf6+98oXF5m0KPzMbjpQJRC8cD/NqGBp26gsg64bbbC1SmW6kbGXaWjghyHF9QasDmIVN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(66476007)(38350700002)(54906003)(478600001)(316002)(8936002)(36756003)(5660300002)(86362001)(30864003)(2906002)(44832011)(4326008)(6916009)(8676002)(66556008)(38100700002)(6666004)(41300700001)(66946007)(6506007)(26005)(6512007)(1076003)(6486002)(2616005)(83380400001)(966005)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6RCE21mDWkFIXQdx0VcN7NXEiV8xBQrCuzwryyEvcy4r7XEie90PrnxgnkcL?=
 =?us-ascii?Q?z+IU7E/+3/8aKD2kYF1dm5lUkPZwuE06WIKwp2VH4dYhhRfUOnxiv3rktseG?=
 =?us-ascii?Q?x697tX+0oMv4J561NlbRLz3Uop7OihN2lMkjj1qUnA2gNk2VDprLv/B5jB4C?=
 =?us-ascii?Q?O+fHU4Rq07ZK1pyKNF2K2jbEqycPBre8ZiNiX1O29Ui9ERmdOFgm4QYWlI4p?=
 =?us-ascii?Q?IXInjajjogz4XwH15kmvL2v5JWZnStVFp9t70p2vb2WLHUrYpBzttR/bblUN?=
 =?us-ascii?Q?oauicZKc+BEc8I9hpKrIzJqHP625h0UAbyu3pMN8hsjEutY1hQVesfZauvNb?=
 =?us-ascii?Q?tKhMINYyk53NEgIua+ltVUPyEJHyFGoxTLJK66Q0M2re+m1ZMs5g9nFcEx2s?=
 =?us-ascii?Q?lBKknqjWVS0aiUKoTF1o5ZhcDS82SUvbvdGlBzZ/ZSAQJ9Hfto9HM9Qa1Wke?=
 =?us-ascii?Q?Pd055cMQEtA0DdkDy/HaROH528c1cIdaYccA3T38TbgJACivEZkpJ9d+gnE7?=
 =?us-ascii?Q?12P1nn/epT5kbTajMyTRQ2Rc6xPHC1RJKmBTQA7DH6lNPdqSG31T17NV/pxk?=
 =?us-ascii?Q?yxcurFa4jgo8E29gOfOVuHBk6Fhh9lTDdhuMygkG8THRGdQdb7esif6AEWvU?=
 =?us-ascii?Q?wn9Lrgu1LoXjocMjFV5VT0elA66ogNm/UnRItZ+ln9Z1GSZhc3yzmR4crCb4?=
 =?us-ascii?Q?MLVhFOC0n/WK9Q67SOK5VVYwxqa95Daxax2pDgwl8f9D2UNBIdgsgs+076F0?=
 =?us-ascii?Q?JBjbHR1x2S0WCKrk8L2BRiqrxfH6YVA+8bZV714ou5l37bjGOf+9+7IfffFJ?=
 =?us-ascii?Q?RYSbbC9Key8fxPev6ghF+Ho5EBehgM2acZ5Bd1xqbRxoy9g7Y45ZOnGbb8fE?=
 =?us-ascii?Q?hASHYC05SsTZBwXsi9DzkKW9JDhbq6/jC//3UDU2gOz7emLa8Kbl4tERwqMV?=
 =?us-ascii?Q?qdUk0vpjlBf/+T3+Jv0l4oF/OJE8EFXM+4buN+HLXgsjXJDJdk5mGp0uAbCT?=
 =?us-ascii?Q?hfcJvFNvM3HMBWlLssbsloj+a1BN95m5zeVsvv9RvsB41YRBLopAiZ5Jwq39?=
 =?us-ascii?Q?9faBslIs6wueyKSc6LgF+nDRt9zl5Z8ZvtmvtzcNU2oufJAS9PZ8wKSBnOyK?=
 =?us-ascii?Q?fw/sQl4ZY2ISvRqlCA0RJLwo5FzwPyU5Ux1m7ysGZG668DBV6MmS9aTBMNAv?=
 =?us-ascii?Q?yjOzeoUy//E5Ku1HZTs/ld8OVX57wvEoeaXYMv8eLpWtzylaBTil7QAhYkIS?=
 =?us-ascii?Q?aECzGTfLDpp3/PwQkj1E26ZfFF+0vsGBC+fVJJIhmTaXKD05+/xxik3YdCis?=
 =?us-ascii?Q?n7ZoAZchMdALBYG1y6sx7YrAy/6pShbvkudsaAAfmUuku4dFqS2lbyFoLSWa?=
 =?us-ascii?Q?ptkYxs/ZWj9itXrc2kPTjMjRJQXgDF9jHdFdDx/u5BMq+M5QIinlQbVAT6lF?=
 =?us-ascii?Q?okvjxzvWBt6NSetuyOYW8B8GW7hyiIKgjICKxCw0fy7NqvTM0ccz3WJYdEDf?=
 =?us-ascii?Q?aK3j0d2UOiyp++KsKlbfMTm+geVp7hyAacEDw+vipE3aW1kenahHdJO9K37k?=
 =?us-ascii?Q?HWRAGy2eIxv0Se5tSUE9j5i00+CtOJI3nJx63pu4YsZB+LL4KM2180yJbrFD?=
 =?us-ascii?Q?1A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3342681e-00b7-4016-5e99-08db35f600e2
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:51:29.8503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mF6JFbNWhQSaiRf6dt9GdmUkD53EnWoGp8SLddYrjc+FKqa73Zg7ixo2LawZFGTiffH3h9JyLBeGfaB5j6CzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8472
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
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

Since the new functionality does not overload the NDO of any DSA master,
there is no point in replicating the function pointers towards
__dsa_master_hwtstamp_validate() once for every CPU port (dev->dsa_ptr).
But rather, it is fine to introduce a singleton struct dsa_stubs,
built-in to the kernel, which contains a single function pointer to
__dsa_master_hwtstamp_validate().

I find this approach rather preferable to what we had originally,
because dev->dsa_ptr->netdev_ops->ndo_do_ioctl() used to require going
through struct dsa_port (dev->dsa_ptr), and so, this was incompatible
with any attempts to add any data encapsulation and hide DSA data
structures from the outside world.

Link: https://lore.kernel.org/netdev/20230403083019.120b72fd@kernel.org/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h |  6 -----
 include/net/dsa_stubs.h   | 49 +++++++++++++++++++++++++++++++++++++++
 net/Makefile              |  2 +-
 net/core/dev.c            |  2 +-
 net/core/dev_ioctl.c      | 12 ++--------
 net/dsa/Makefile          |  6 +++++
 net/dsa/dsa.c             | 27 +++++++++++++++++++++
 net/dsa/master.c          |  2 +-
 net/dsa/master.h          |  2 +-
 net/dsa/slave.c           | 10 --------
 net/dsa/stubs.c           | 13 +++++++++++
 11 files changed, 101 insertions(+), 30 deletions(-)
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
index 000000000000..27a1ad85c038
--- /dev/null
+++ b/include/net/dsa_stubs.h
@@ -0,0 +1,49 @@
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
+extern struct mutex dsa_stubs_lock;
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
+	int err;
+
+	if (!netdev_uses_dsa(dev))
+		return 0;
+
+	mutex_lock(&dsa_stubs_lock);
+
+	if (dsa_stubs)
+		err = dsa_stubs->master_hwtstamp_validate(dev, config, extack);
+
+	mutex_unlock(&dsa_stubs_lock);
+
+	return err;
+}
+
+#else
+
+static inline int dsa_master_hwtstamp_validate(struct net_device *dev,
+					       const struct kernel_hwtstamp_config *config)
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
index e5f156940c67..119d480b3d53 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -17,6 +17,7 @@
 #include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
+#include <net/dsa_stubs.h>
 #include <net/sch_generic.h>
 
 #include "devlink.h"
@@ -1702,6 +1703,28 @@ bool dsa_mdb_present_in_other_db(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL_GPL(dsa_mdb_present_in_other_db);
 
+static const struct dsa_stubs __dsa_stubs = {
+	.master_hwtstamp_validate = __dsa_master_hwtstamp_validate,
+};
+
+static void dsa_register_stubs(void)
+{
+	mutex_lock(&dsa_stubs_lock);
+
+	dsa_stubs = &__dsa_stubs;
+
+	mutex_unlock(&dsa_stubs_lock);
+}
+
+static void dsa_unregister_stubs(void)
+{
+	mutex_lock(&dsa_stubs_lock);
+
+	dsa_stubs = NULL;
+
+	mutex_unlock(&dsa_stubs_lock);
+}
+
 static int __init dsa_init_module(void)
 {
 	int rc;
@@ -1721,6 +1744,8 @@ static int __init dsa_init_module(void)
 	if (rc)
 		goto netlink_register_fail;
 
+	dsa_register_stubs();
+
 	return 0;
 
 netlink_register_fail:
@@ -1735,6 +1760,8 @@ module_init(dsa_init_module);
 
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
index 8abc1658ac47..36bb7533ddd6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -3419,16 +3419,6 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 
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
index 000000000000..0b91f1d06028
--- /dev/null
+++ b/net/dsa/stubs.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Stubs for DSA functionality called by the core network stack.
+ * These are necessary because CONFIG_NET_DSA can be a module, and built-in
+ * code cannot directly call symbols exported by modules.
+ */
+#include <net/dsa_stubs.h>
+
+DEFINE_MUTEX(dsa_stubs_lock);
+EXPORT_SYMBOL_GPL(dsa_stubs_lock);
+
+const struct dsa_stubs *dsa_stubs;
+EXPORT_SYMBOL_GPL(dsa_stubs);
-- 
2.34.1

