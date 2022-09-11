Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687155B4B18
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiIKBIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiIKBH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:07:57 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028E04D839;
        Sat, 10 Sep 2022 18:07:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OScum9tYgrT97Svhu0gjnbiZyH93XJ8Dz6bmZligGbOpjw9X86wl9t+hIjxMVbofjd8Yq40c6xa7Fhf9BI61XrS+OsRnqxxp/lYt81+nb4xWL3xBwPNYms8KkIQietkAfJknAF9y3NIqX4P4qOi4flWdAzzSTYlJP7amk0zfSjF3x+S208ZoJnIRt9t1FmRtF+rboYRmLGSBjZA02kJnuRWIWsELn9LUYAbcx1HdmvWkdy7ChQHdPyE0DJFs0xWEi6aLV6dJBmHnCtZ/X0KqHpzQAdVLYzx6X3WLLY+M9umu5PfJaHPCVo4rH1PdEHkknH+jEESI6UmBzh8LYtj93w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O4S4a5Y7NL2/jM4HIHXGl14ja/8efkzgQHOJzQwZAXg=;
 b=RxqEFzQBYG4JxbLLKROakwu2K3/4UMVNxGqiDCIdZjhSKJlpI353GhvTG8UwHycjCCa/H8EfwG4Z5Xlmsg+kZrHrbHR3+nrvNt9FcYUuBABb2pbl2QXt4raX1Y3dXpTfAwYgQ1Ig8XsfbrXNxsg1HFv6/BiTeED/fSU+TupZqaSq4lk4vq1lW6elqEp8K5He+4iViSs3yI8Y7LjXhbtyDvNObtN92QfFyr0aODPxC1tKg5U+OJjF8rvVZvzuQEgaH5872QFi+upPlM+yzOSKLdNKBUU/z4jjS8iXYFUJBjs+NUeT//7dSo0ltwKWqN0DXymJ833CWGeWtws40cbt7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O4S4a5Y7NL2/jM4HIHXGl14ja/8efkzgQHOJzQwZAXg=;
 b=iyV2Q7clJBrQpLM0K10csN0HV362AEwZtNrzeQNBlkV6TLg2K+6A7V9Nz5wAs9WAiFf7xWOLu34QiyFAo1kDcWzXu7qxJB9sOcY5D4zZxVhK+5dzJwlwVvhMcWAI0bj9Eg0j7R2y7gXFpIzvPJeR64ypProEGwI31smS2j7QlbQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:07:52 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:07:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 03/10] net: dsa: allow the DSA master to be seen and changed through rtnetlink
Date:   Sun, 11 Sep 2022 04:06:59 +0300
Message-Id: <20220911010706.2137967-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a217534-5eae-4d8b-22d5-08da93920cf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKitNet7nqAa5UqEw/0wBRUUWsrtjRyLF68DK5TB37voU89kB3kMyuMQlFX6oY+DYIGKu26zHuJjopmP11sRbo7y24+XXtWy91zLZRjtl+NksYJ9Oc21BrvjaHpdqnJlKDie7szhFLycGuXLu3+i22NeLMAtiQNKZHoKNU9N8BHL6rwdR2IhoqqbK4WZDjDuJvsmQSQrFkx8e7UywXy/geT9uWHip2CIaSEPGdNarO9QZtPhDgId1/92GgO27YLPTaQ/w0AxcToC2qrDduNeVVQTzJOpmFXZH/Zxv9i/lQvPdKthocebMsQfVX9kf0Y0E+mPZMgghuL7+Orn9MmZmUw0qmyVlfHgywXX5VBTrxfonUSUa1ry6txEzFhaZ1/aOf16BcpKKV2r2wh3ghjGPmsQXogVwJjmUqrBW9xP1raq4GXfigP1oqH2ZNRZaFZX1BeMr+fqjYfHc7epMjdoDVWSsDeLQKrbSRl9XVwZMrDLn0vLrSpAvuRYgx6DCTNGR6krEeEy6qqG0NBgpw61pd8Mb0wiDPw5q+LVR0D2nUB0wwQxegCKIuiwRbAEGr28btvXhEtl22EjmToIPVcnqwQ/wC0L6RYv1iGrQI1oaTm890Y8rLZDgT6fcDM+C5dilvELoymEQJ5s0CW8dBQCnK3zQnEodQRBjkPAxLB+2y4E18hjNMg5LnCMbJrFAP2C7TqjkskkUAH41BUBeMD1cItKE8oH4KPAwNi6V7BLae2dJbCBhO23cgCqE7SaGK44dblpLlKgo0Lwm2pgVvqWdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(30864003)(2906002)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(26005)(6512007)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xKha6TlW9Wjos7xzCbGN7eSiA3dzN2l83H7LT1GjojfnQAhb20fNY/eK5rIV?=
 =?us-ascii?Q?ztN3f8xtpjhC3w5e/Qr3hsst6A09ua+VplmXHo1BjYGqJTu2ST+7wIwvpUUM?=
 =?us-ascii?Q?4LONHZWp3ckcoFqOL+qcwIsVXWlZf2m1Ayq2Ta6j8WdJryiIlI7Dd13AZhXJ?=
 =?us-ascii?Q?ERcnWXAVMz9NxanWEEbsOkNmXIG/kmaxUG1h+u5Gp0ML2pafDitHbBwU3CpS?=
 =?us-ascii?Q?IKyQd7BV3bwy8e6OMOA+JcOHElG0YYxGdsX21MKcGfxS14Li7rrRva1bx+El?=
 =?us-ascii?Q?3vOe82Viy8lz0ea0yNpHVWWBqtlIXJ0GACIQqm05TrMDzkwtx+Et5FQVFzES?=
 =?us-ascii?Q?Cy5Q1BPx8w9A/hQIq4kB9x6wCywvuMrbhw3DaBVxDROFsJ0KiDc9koiBOIOP?=
 =?us-ascii?Q?5Q+xKyVY8mkojwF7t7IdhFsVhQttOahm4k7M1Hih8TECBfBHC4n4AQx7zXGB?=
 =?us-ascii?Q?ic+0cerOSD6yzouPWUR5BKslrYfYYcsuhVHRBAre4YDqBPMWbUMGxFa5xWRY?=
 =?us-ascii?Q?sNPWtHY+JmkfjdQhaYrfsMcXvprC0j7Nx8U+vdickkr+jkwJgI9GH+u66koa?=
 =?us-ascii?Q?/OQsUumrH8/M1VFSXfL2ze3rQWAAM1uVUIZAnwd18OAcFZq3a35kecAV88C2?=
 =?us-ascii?Q?L1N9gOAFhC9CsLkXEGjdYs9NgPpIAtfkdiWMVDA3Wy0rKx39q2vM7x4AAqt5?=
 =?us-ascii?Q?KVLo32dyhVO9pQ9pD1urr5x8iRyRoTNY4FFw5OeN9ga7XpRV2nXzZWrve1xs?=
 =?us-ascii?Q?LouMcjbiPVRiIxYUUzGJUTxFHYlvQYDzAk0+NRxXpB5fS+i+wemvLgBxWPWP?=
 =?us-ascii?Q?5TqrzrEdC5CnJ+Xbf+eGLfujv1kHmiy96tKCLr9vFb/RCcRvz04HhLkOgEcp?=
 =?us-ascii?Q?Gev9Hb7B8yRfSxCRKIEmepE03DO0yJffAb9o1NPM6ftpkFaa/RoQCdst80zZ?=
 =?us-ascii?Q?wrYow6XWpUV3INOWTTkla6mf7a5SOISctkZHy2mqVceHuWa1CD2FbDqZ1lb8?=
 =?us-ascii?Q?l55iq3RjaWDCZ954fHboFlMaIv82o/ZxomX7VDZRVsxdLquLDxlvhf+wgGsG?=
 =?us-ascii?Q?Lv+4X+OFOg1VCaif0AUMnpq3bVjDtJrdaGlWxrj17j9/oDrC7OTxglsYchS2?=
 =?us-ascii?Q?LtNitLyc4qqZWfVFFiqbMZO8mGNCcMl9IHE7CPUmNLpj3o3nBlesRn4bVzq4?=
 =?us-ascii?Q?0ud3mtkV/V1EXL+hZjh4xax9DWyVT5mitzaqxPxHNLchPDaGU+JfUNmuQeOw?=
 =?us-ascii?Q?N4jADpOWU+mjZmGNgGnBHKgq6c5NZsPaz4wtPzHcRKFrrNn4kkSz357oHYMH?=
 =?us-ascii?Q?dyJtEus0IXbu9ew+4aVJIpmUVRM78DQAjpJUQm1LOaaui6MB9JXnOJY7RcFa?=
 =?us-ascii?Q?FGLU+v89Hyv6wJxyGzYprIWh2Zrstf3bbuBE910O55/F4pFkPhDjRXszoG8L?=
 =?us-ascii?Q?TLUHsx02APFha07mREdoka9EiPGzQgRhvfx/L8OmkOSkycSBwic7rlh1PUZ9?=
 =?us-ascii?Q?7OFIAgMHwcirGfizTDhuK7huXtXFXFwmwiCKA6M35TmIgygLW1etSiDqw9Dg?=
 =?us-ascii?Q?/1Y/yUrplcHSoARCqUm/AEk/WvdIVQl4/k1PSvEPu4VyXIJPsCnZivRO/58M?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a217534-5eae-4d8b-22d5-08da93920cf7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:07:51.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JETYzkcFki7rGgRMrQieWCzZjz82bTHYr+qV0bdF0OTZMYK3ntpPpAIwjHbHoPEg3ighyMoo+jMb520u5l8qCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some DSA switches have multiple CPU ports, which can be used to improve
CPU termination throughput, but DSA, through dsa_tree_setup_cpu_ports(),
sets up only the first one, leading to suboptimal use of hardware.

The desire is to not change the default configuration but to permit the
user to create a dynamic mapping between individual user ports and the
CPU port that they are served by, configurable through rtnetlink. It is
also intended to permit load balancing between CPU ports, and in that
case, the foreseen model is for the DSA master to be a bonding interface
whose lowers are the physical DSA masters.

To that end, we create a struct rtnl_link_ops for DSA user ports with
the "dsa" kind. We expose the IFLA_DSA_MASTER link attribute that
contains the ifindex of the newly desired DSA master.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: remove unused variable in dsa_port_assign_master

 include/net/dsa.h            |   8 +++
 include/uapi/linux/if_link.h |  10 +++
 net/dsa/Makefile             |  10 ++-
 net/dsa/dsa.c                |   9 +++
 net/dsa/dsa2.c               |  14 ++++
 net/dsa/dsa_priv.h           |  10 +++
 net/dsa/netlink.c            |  62 +++++++++++++++++
 net/dsa/port.c               | 130 +++++++++++++++++++++++++++++++++++
 net/dsa/slave.c              | 120 ++++++++++++++++++++++++++++++++
 9 files changed, 372 insertions(+), 1 deletion(-)
 create mode 100644 net/dsa/netlink.c

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 23eac1bda843..3f717c3fcba0 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -559,6 +559,10 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_user((_dp)))
 
+#define dsa_tree_for_each_user_port_continue_reverse(_dp, _dst) \
+	list_for_each_entry_continue_reverse((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_user((_dp)))
+
 #define dsa_tree_for_each_cpu_port(_dp, _dst) \
 	list_for_each_entry((_dp), &(_dst)->ports, list) \
 		if (dsa_port_is_cpu((_dp)))
@@ -830,6 +834,10 @@ struct dsa_switch_ops {
 	int	(*connect_tag_protocol)(struct dsa_switch *ds,
 					enum dsa_tag_protocol proto);
 
+	int	(*port_change_master)(struct dsa_switch *ds, int port,
+				      struct net_device *master,
+				      struct netlink_ext_ack *extack);
+
 	/* Optional switch-wide initialization and destruction methods */
 	int	(*setup)(struct dsa_switch *ds);
 	void	(*teardown)(struct dsa_switch *ds);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index e36d9d2c65a7..f032414990bc 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1374,4 +1374,14 @@ enum {
 
 #define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
 
+/* DSA section */
+
+enum {
+	IFLA_DSA_UNSPEC,
+	IFLA_DSA_MASTER,
+	__IFLA_DSA_MAX,
+};
+
+#define IFLA_DSA_MAX	(__IFLA_DSA_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index af28c24ead18..bf57ef3bce2a 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -1,7 +1,15 @@
 # SPDX-License-Identifier: GPL-2.0
 # the core
 obj-$(CONFIG_NET_DSA) += dsa_core.o
-dsa_core-y += dsa.o dsa2.o master.o port.o slave.o switch.o tag_8021q.o
+dsa_core-y += \
+	dsa.o \
+	dsa2.o \
+	master.o \
+	netlink.o \
+	port.o \
+	slave.o \
+	switch.o \
+	tag_8021q.o
 
 # tagging formats
 obj-$(CONFIG_NET_DSA_TAG_AR9331) += tag_ar9331.o
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index be7b320cda76..64b14f655b23 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -536,8 +536,16 @@ static int __init dsa_init_module(void)
 	dsa_tag_driver_register(&DSA_TAG_DRIVER_NAME(none_ops),
 				THIS_MODULE);
 
+	rc = rtnl_link_register(&dsa_link_ops);
+	if (rc)
+		goto netlink_register_fail;
+
 	return 0;
 
+netlink_register_fail:
+	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
+	dsa_slave_unregister_notifier();
+	dev_remove_pack(&dsa_pack_type);
 register_notifier_fail:
 	destroy_workqueue(dsa_owq);
 
@@ -547,6 +555,7 @@ module_init(dsa_init_module);
 
 static void __exit dsa_cleanup_module(void)
 {
+	rtnl_link_unregister(&dsa_link_ops);
 	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
 
 	dsa_slave_unregister_notifier();
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index db34240bd0c5..44207d848722 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -387,6 +387,20 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 	return NULL;
 }
 
+struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst)
+{
+	struct device_node *ethernet;
+	struct net_device *master;
+	struct dsa_port *cpu_dp;
+
+	cpu_dp = dsa_tree_find_first_cpu(dst);
+	ethernet = of_parse_phandle(cpu_dp->dn, "ethernet", 0);
+	master = of_find_net_device_by_node(ethernet);
+	of_node_put(ethernet);
+
+	return master;
+}
+
 /* Assign the default CPU port (the first one in the tree) to all ports of the
  * fabric which don't already have one as part of their own switch.
  */
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index c48c5c8ba790..d252a04ed725 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -200,6 +200,9 @@ static inline struct net_device *dsa_master_find_slave(struct net_device *dev,
 	return NULL;
 }
 
+/* netlink.c */
+extern struct rtnl_link_ops dsa_link_ops __read_mostly;
+
 /* port.c */
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops);
@@ -292,6 +295,8 @@ void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid, bool broadcast);
 void dsa_port_set_host_flood(struct dsa_port *dp, bool uc, bool mc);
+int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
+			   struct netlink_ext_ack *extack);
 
 /* slave.c */
 extern const struct dsa_device_ops notag_netdev_ops;
@@ -305,8 +310,12 @@ int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
+void dsa_slave_sync_ha(struct net_device *dev);
+void dsa_slave_unsync_ha(struct net_device *dev);
 void dsa_slave_setup_tagger(struct net_device *slave);
 int dsa_slave_change_mtu(struct net_device *dev, int new_mtu);
+int dsa_slave_change_master(struct net_device *dev, struct net_device *master,
+			    struct netlink_ext_ack *extack);
 int dsa_slave_manage_vlan_filtering(struct net_device *dev,
 				    bool vlan_filtering);
 
@@ -542,6 +551,7 @@ void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 struct dsa_lag *dsa_tree_lag_find(struct dsa_switch_tree *dst,
 				  const struct net_device *lag_dev);
+struct net_device *dsa_tree_find_first_master(struct dsa_switch_tree *dst);
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
 int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
diff --git a/net/dsa/netlink.c b/net/dsa/netlink.c
new file mode 100644
index 000000000000..0f43bbb94769
--- /dev/null
+++ b/net/dsa/netlink.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright 2022 NXP
+ */
+#include <linux/netdevice.h>
+#include <net/rtnetlink.h>
+
+#include "dsa_priv.h"
+
+static const struct nla_policy dsa_policy[IFLA_DSA_MAX + 1] = {
+	[IFLA_DSA_MASTER]	= { .type = NLA_U32 },
+};
+
+static int dsa_changelink(struct net_device *dev, struct nlattr *tb[],
+			  struct nlattr *data[],
+			  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!data)
+		return 0;
+
+	if (data[IFLA_DSA_MASTER]) {
+		u32 ifindex = nla_get_u32(data[IFLA_DSA_MASTER]);
+		struct net_device *master;
+
+		master = __dev_get_by_index(dev_net(dev), ifindex);
+		if (!master)
+			return -EINVAL;
+
+		err = dsa_slave_change_master(dev, master, extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static size_t dsa_get_size(const struct net_device *dev)
+{
+	return nla_total_size(sizeof(u32)) +	/* IFLA_DSA_MASTER  */
+	       0;
+}
+
+static int dsa_fill_info(struct sk_buff *skb, const struct net_device *dev)
+{
+	struct net_device *master = dsa_slave_to_master(dev);
+
+	if (nla_put_u32(skb, IFLA_DSA_MASTER, master->ifindex))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+struct rtnl_link_ops dsa_link_ops __read_mostly = {
+	.kind			= "dsa",
+	.priv_size		= sizeof(struct dsa_port),
+	.maxtype		= IFLA_DSA_MAX,
+	.policy			= dsa_policy,
+	.changelink		= dsa_changelink,
+	.get_size		= dsa_get_size,
+	.fill_info		= dsa_fill_info,
+};
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4183e60db4f9..e557b42de9f2 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/if_bridge.h>
+#include <linux/netdevice.h>
 #include <linux/notifier.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
@@ -1374,6 +1375,135 @@ int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 	return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
 }
 
+static int dsa_port_assign_master(struct dsa_port *dp,
+				  struct net_device *master,
+				  struct netlink_ext_ack *extack,
+				  bool fail_on_err)
+{
+	struct dsa_switch *ds = dp->ds;
+	int port = dp->index, err;
+
+	err = ds->ops->port_change_master(ds, port, master, extack);
+	if (err && !fail_on_err)
+		dev_err(ds->dev, "port %d failed to assign master %s: %pe\n",
+			port, master->name, ERR_PTR(err));
+
+	if (err && fail_on_err)
+		return err;
+
+	dp->cpu_dp = master->dsa_ptr;
+
+	return 0;
+}
+
+/* Change the dp->cpu_dp affinity for a user port. Note that both cross-chip
+ * notifiers and drivers have implicit assumptions about user-to-CPU-port
+ * mappings, so we unfortunately cannot delay the deletion of the objects
+ * (switchdev, standalone addresses, standalone VLANs) on the old CPU port
+ * until the new CPU port has been set up. So we need to completely tear down
+ * the old CPU port before changing it, and restore it on errors during the
+ * bringup of the new one.
+ */
+int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
+			   struct netlink_ext_ack *extack)
+{
+	struct net_device *bridge_dev = dsa_port_bridge_dev_get(dp);
+	struct net_device *old_master = dsa_port_to_master(dp);
+	struct net_device *dev = dp->slave;
+	struct dsa_switch *ds = dp->ds;
+	bool vlan_filtering;
+	int err, tmp;
+
+	/* Bridges may hold host FDB, MDB and VLAN objects. These need to be
+	 * migrated, so dynamically unoffload and later reoffload the bridge
+	 * port.
+	 */
+	if (bridge_dev) {
+		dsa_port_pre_bridge_leave(dp, bridge_dev);
+		dsa_port_bridge_leave(dp, bridge_dev);
+	}
+
+	/* The port might still be VLAN filtering even if it's no longer
+	 * under a bridge, either due to ds->vlan_filtering_is_global or
+	 * ds->needs_standalone_vlan_filtering. In turn this means VLANs
+	 * on the CPU port.
+	 */
+	vlan_filtering = dsa_port_is_vlan_filtering(dp);
+	if (vlan_filtering) {
+		err = dsa_slave_manage_vlan_filtering(dev, false);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to remove standalone VLANs");
+			goto rewind_old_bridge;
+		}
+	}
+
+	/* Standalone addresses, and addresses of upper interfaces like
+	 * VLAN, LAG, HSR need to be migrated.
+	 */
+	dsa_slave_unsync_ha(dev);
+
+	err = dsa_port_assign_master(dp, master, extack, true);
+	if (err)
+		goto rewind_old_addrs;
+
+	dsa_slave_sync_ha(dev);
+
+	if (vlan_filtering) {
+		err = dsa_slave_manage_vlan_filtering(dev, true);
+		if (err) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to restore standalone VLANs");
+			goto rewind_new_addrs;
+		}
+	}
+
+	if (bridge_dev) {
+		err = dsa_port_bridge_join(dp, bridge_dev, extack);
+		if (err && err == -EOPNOTSUPP) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Failed to reoffload bridge");
+			goto rewind_new_vlan;
+		}
+	}
+
+	return 0;
+
+rewind_new_vlan:
+	if (vlan_filtering)
+		dsa_slave_manage_vlan_filtering(dev, false);
+
+rewind_new_addrs:
+	dsa_slave_unsync_ha(dev);
+
+	dsa_port_assign_master(dp, old_master, NULL, false);
+
+/* Restore the objects on the old CPU port */
+rewind_old_addrs:
+	dsa_slave_sync_ha(dev);
+
+	if (vlan_filtering) {
+		tmp = dsa_slave_manage_vlan_filtering(dev, true);
+		if (tmp) {
+			dev_err(ds->dev,
+				"port %d failed to restore standalone VLANs: %pe\n",
+				dp->index, ERR_PTR(tmp));
+		}
+	}
+
+rewind_old_bridge:
+	if (bridge_dev) {
+		tmp = dsa_port_bridge_join(dp, bridge_dev, extack);
+		if (tmp) {
+			dev_err(ds->dev,
+				"port %d failed to rejoin bridge %s: %pe\n",
+				dp->index, bridge_dev->name, ERR_PTR(tmp));
+		}
+	}
+
+	return err;
+}
+
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
 			       const struct dsa_device_ops *tag_ops)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 55094b94a5ae..00df6cf07866 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -164,6 +164,48 @@ static int dsa_slave_unsync_mc(struct net_device *dev,
 	return dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
 }
 
+void dsa_slave_sync_ha(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
+
+	netif_addr_lock_bh(dev);
+
+	netdev_for_each_synced_mc_addr(ha, dev)
+		dsa_slave_sync_mc(dev, ha->addr);
+
+	netdev_for_each_synced_uc_addr(ha, dev)
+		dsa_slave_sync_uc(dev, ha->addr);
+
+	netif_addr_unlock_bh(dev);
+
+	if (dsa_switch_supports_uc_filtering(ds) ||
+	    dsa_switch_supports_mc_filtering(ds))
+		dsa_flush_workqueue();
+}
+
+void dsa_slave_unsync_ha(struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct netdev_hw_addr *ha;
+
+	netif_addr_lock_bh(dev);
+
+	netdev_for_each_synced_uc_addr(ha, dev)
+		dsa_slave_unsync_uc(dev, ha->addr);
+
+	netdev_for_each_synced_mc_addr(ha, dev)
+		dsa_slave_unsync_mc(dev, ha->addr);
+
+	netif_addr_unlock_bh(dev);
+
+	if (dsa_switch_supports_uc_filtering(ds) ||
+	    dsa_switch_supports_mc_filtering(ds))
+		dsa_flush_workqueue();
+}
+
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -2346,6 +2388,7 @@ int dsa_slave_create(struct dsa_port *port)
 	if (slave_dev == NULL)
 		return -ENOMEM;
 
+	slave_dev->rtnl_link_ops = &dsa_link_ops;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 #if IS_ENABLED(CONFIG_DCB)
 	slave_dev->dcbnl_ops = &dsa_slave_dcbnl_ops;
@@ -2462,6 +2505,83 @@ void dsa_slave_destroy(struct net_device *slave_dev)
 	free_netdev(slave_dev);
 }
 
+int dsa_slave_change_master(struct net_device *dev, struct net_device *master,
+			    struct netlink_ext_ack *extack)
+{
+	struct net_device *old_master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	struct net_device *upper;
+	struct list_head *iter;
+	int err;
+
+	if (master == old_master)
+		return 0;
+
+	if (!ds->ops->port_change_master) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Driver does not support changing DSA master");
+		return -EOPNOTSUPP;
+	}
+
+	if (!netdev_uses_dsa(master)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Interface not eligible as DSA master");
+		return -EOPNOTSUPP;
+	}
+
+	netdev_for_each_upper_dev_rcu(master, upper, iter) {
+		if (dsa_slave_dev_check(upper))
+			continue;
+		if (netif_is_bridge_master(upper))
+			continue;
+		NL_SET_ERR_MSG_MOD(extack, "Cannot join master with unknown uppers");
+		return -EOPNOTSUPP;
+	}
+
+	/* Since we allow live-changing the DSA master, plus we auto-open the
+	 * DSA master when the user port opens => we need to ensure that the
+	 * new DSA master is open too.
+	 */
+	if (dev->flags & IFF_UP) {
+		err = dev_open(master, extack);
+		if (err)
+			return err;
+	}
+
+	netdev_upper_dev_unlink(old_master, dev);
+
+	err = netdev_upper_dev_link(master, dev, extack);
+	if (err)
+		goto out_revert_old_master_unlink;
+
+	err = dsa_port_change_master(dp, master, extack);
+	if (err)
+		goto out_revert_master_link;
+
+	/* Update the MTU of the new CPU port through cross-chip notifiers */
+	err = dsa_slave_change_mtu(dev, dev->mtu);
+	if (err && err != -EOPNOTSUPP) {
+		netdev_warn(dev,
+			    "nonfatal error updating MTU with new master: %pe\n",
+			    ERR_PTR(err));
+	}
+
+	/* If the port doesn't have its own MAC address and relies on the DSA
+	 * master's one, inherit it again from the new DSA master.
+	 */
+	if (is_zero_ether_addr(dp->mac))
+		eth_hw_addr_inherit(dev, master);
+
+	return 0;
+
+out_revert_master_link:
+	netdev_upper_dev_unlink(master, dev);
+out_revert_old_master_unlink:
+	netdev_upper_dev_link(old_master, dev, NULL);
+	return err;
+}
+
 bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
-- 
2.34.1

