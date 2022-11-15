Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70367628F1F
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiKOBTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiKOBTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:01 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D514013DCC
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:19:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuk0D0IdLUqxzMTlMeXCXKjHyT/nU+qo0X6DBU6ZQOnbDoR2d3ae39/lN3dc6IlGV729Pyr3yKFg//3exTSyfYLuFGlQHRcPJR22ATf44TUJOv5GYRFb6SKpHRpUrwUj/sSC/0pRhITIONeLlIwod8C6g2DACINpskoZk9Rw4yedayyeM7oK5Orkm3BG3sicSBhn8AcqNkPMiQ9opegpOppGdj+JdfMiMpWnSwi42UGAfTb5/x4GOEjKUCNWCZYsLBm5Gu1N/n5b7U+YTitXWYnWhB30Tjrai5IePiKw+jF3JGwDaqVVE108PFlCoF28bJ6GFk/yBLLUflDNjMlIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2Dekc/3v0V8Nyk9hNVzraoLLvZmRD3gbNJsuDM4Ey0=;
 b=nUEXBlkz9r+ml6nePV0fxPmvnJnPM/xd6KzxdvqAyEGBKEaw00IXvl+ykSnOHDjkFzcoWN99FL9hGkKTRorNqlHUhKX3QYW0mTnb7dk+59l2Z4/wYHzLeUPzL2Caxwzy0w3iNuH8NyUNfGnSWeN6i7ZZLdwTmRShq/LM0vEvF2ftXx37N5ei9k2M/x/dCMxoZqxxKweLRDtbUmTb6a4tBihULdirJ9uCId4g5TinYDj02/9lZJjedbRfk39YKYcVG6WxUt6GoGjWKnoPxvUHflROyLptaA2hBdR5DvBiBSviS/oAIAeRWNOGtzlAzQKFSzdm66HgSPpC4rUjsco9TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2Dekc/3v0V8Nyk9hNVzraoLLvZmRD3gbNJsuDM4Ey0=;
 b=X6eglESnP4YCRNDEv6p3NUodLCcRaIlArBJKSDwCXxkIBFsmNa+Nob5GEmc71+VOhJTa5jv/mAdphjAsLPHpooSop96WZf3TEsA+8jIcH9uX943Xn+ouveM9VyKkW+qCFe6QS/tQ7Lw9OiJ5EJZx6I8W6xljiY5SFv5oFeys7y4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:18:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:18:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH v2 net-next 1/6] net: dsa: stop exposing tag proto module helpers to the world
Date:   Tue, 15 Nov 2022 03:18:42 +0200
Message-Id: <20221115011847.2843127-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
References: <20221115011847.2843127-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7815:EE_
X-MS-Office365-Filtering-Correlation-Id: fcd33b4f-3a84-4fc7-4d2c-08dac6a75ee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ii9rz0JK22H0jFRASuc4F0xF2CDRWERh4MCN53rWxsCwp8FAICbad1O4ddktjJo/fZMUksCK+0shGizDYloSpKXQ+mLy4mOTQjspHCXrhgHGJIvPdKfjFUUlKKTxqWhZFc7YIlyPN2QWpe+0PFX7+0GNK00kuEQQN2MtFjTC5TWrFuDbsazaKIBUsSu79LsVoMPJhrwSwXBcgbmG6MoT4G7yth8iigwZQsUvfvAYFHehqB9pDPROPARm7LdKfmRTsCXYD3DneVzBn9Htu6PMl1taBCpx44hdDkld+p3SFZekiiSdQrbud1wObHiGzN3SIplmupFq0nSnMyRJHkIWl9zb4rfPGsPnhx0Qv511l0a0AJPp9gxNt0HXcji/l6obi1+pIbk7qC7Eeez6fwOcAtcvQitgRnDer8Y18GTNUfwp+RnBj3m+u8NkJ3/kdcsaNbUyZi6TRGg5tATDUI9EoKAUETTOL7vMVeSDVdEla0RVt8xgIHMx7WnF/m9hwsaS2kmCcE3kzdvZPCQjPFJmrKLsNgWujpbQukRWi0Q08V1N94EAWPMbSdYp4CuRoxyw9zacFIBGE6BwrW1tY3rgReumYDQE/Q1teqMlmjoqpVrRtScYrQqZgxQObvxg6TFz7LHUFC5dSeyERjILVz219nhfufPIjPT8/9hXNBTfr6w9pD/xYR4OoWRnPTNUiarH9FAAi/mM6kr8HpAQCEqhoJZcgIRrJx6oEjjFBw7IpiQ6cGmmTgUvauMew2iG5WcOqxS1Te8W+VU4EpcBqX5AJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?plV4mxGuBvYS311HSNAGHGNGU9uyJYaQ7Y6iLSmEU40hTaT1GMYSKI02n+IG?=
 =?us-ascii?Q?aST08NTZYQsf+S0yfnEAsKmsodgOBz2vTWNKX5OPxn9jED0LIT+D+YSMg375?=
 =?us-ascii?Q?A5JvqGOnoUwBKWV2prPu08QGvcHNafVq33Ifr2FyT+MavFnH3JN5LNtGJdbn?=
 =?us-ascii?Q?oGzawf5bn7y423YQv5JN5USwdhkBEyVPCWf9OfZrpzyMVMCZ5o/YyQdDxsZu?=
 =?us-ascii?Q?eehpwxPHLL1c3NQxN3el5vHy4Ykc8UGyIOxYsFyRzTekVRnqkcMLftBHeBmX?=
 =?us-ascii?Q?/h6cBKGPDRPwGbTbOHIyUHVhxZVCTVQTWuSxLy4wREeEGKro5s/el35vq5kb?=
 =?us-ascii?Q?ZWFEpsb8nx9nqCkXvzg7MeRiRhJIH5U8K+9Eah6aFWIvP7Mc6KDuK788RAZr?=
 =?us-ascii?Q?Fzt6mdR24MeMVbzV45KP6SrO8GBSmXzyuPuq210fddCyvUARPEgaBXDBt1Hr?=
 =?us-ascii?Q?AcVSblFpX+lUazoCaJTj4ItBb04+MR3AmOnEfLDMQed9VtChuez8neaLpPA/?=
 =?us-ascii?Q?TMBvT78iCK5bU4VdLh7Ef+ICR9fTRBqHSWnJmOTMVNLJc2+ROm0lLFMv9qpR?=
 =?us-ascii?Q?ST8aXpnBpAntux0fDgQ/KsPb/mzev0BWW3T8KCc4cN/EJggNN3P/LD5w4d+d?=
 =?us-ascii?Q?oHVBOfgzpjO/7M1PeQSmSqv+POctfHQOI9OWXU/7cPAm+eF9aqdYAieQUJZV?=
 =?us-ascii?Q?19bXIzR8AjYRDMmdLBgMjPb34OKnFfG0SIGQURnlPkqApjoDILYipyUFuNeA?=
 =?us-ascii?Q?vqbj0QpzwdpU+riVl75aswWGX4InTjRJnSf5H1a00jr2zF8zLqZwa/wT0xjU?=
 =?us-ascii?Q?7p3TEOixQSLoIloww99zlS9NmNLba/FbwCMYWrn44ML9joSYRp59OL69CbRQ?=
 =?us-ascii?Q?ZNAFaP/anLsM8zeWVMfxs67Md0xoEZDBriLJhU6C78MunWfHdZUTk0/7Q2zl?=
 =?us-ascii?Q?lLSe9U5HxwcOpMQOMcisT9mZOR/UnAq4a8eqGDd0QP5s+gxxodS2EYeho3bq?=
 =?us-ascii?Q?VEWuFsavzqQgWeDhENVuw9jT6mVSZqiKVx9ocx59MZ46I8OzdGleH/jdgVuj?=
 =?us-ascii?Q?aszpE7Ez/9QiBbZfjtW3OTzi/L4kjrBS8b/fa3ZvW4N23Ndre2N4syvEEFOI?=
 =?us-ascii?Q?DKHMt8C9JkSUQFx9CdCZB1J+/5O+IU5yLGsmHmTuxeYUQ/JlioN7oMhDzd9U?=
 =?us-ascii?Q?vZXj/Xg47r5aBo5XRcbDbiLa9SUXpyBQYFLq8y7Mxx+4lk+w9PI5q7An45hW?=
 =?us-ascii?Q?r8UqWE5jyMYM0QQ0zbNV7wnm4h0oVGtB0MenE9UqHpMlFC9lcwsb4vtRKdXE?=
 =?us-ascii?Q?65+eIpd+/VsUT/dYvKitgXg6Tn282Got5fiTAUgifinIJwq0u+30diyp6Tbi?=
 =?us-ascii?Q?NaRjei/PGpD1Ya5+AZWQY7KSdmdghqAlq8IyHYYu5ofX1PByIeealnl+y9sq?=
 =?us-ascii?Q?36aUQfQ0aCh6KPuWRwed0KJNVoypjolhr07yG+O3/iIvbAVss8r65c4qAXGf?=
 =?us-ascii?Q?2FtJPFVKIfss6gpp1jsNZVfhv+R/e7wkwHd44MNb4lEI2FbTpcJobSyi2gn+?=
 =?us-ascii?Q?JtdnUyXg+v5lWkdxNV7aFZuTmcofETfpqXV+p3TIbNsUfyB0Ns0L44HJxlTw?=
 =?us-ascii?Q?sg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd33b4f-3a84-4fc7-4d2c-08dac6a75ee1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:18:58.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9SNmIpXW8HB4qUp6uDNYmrDWNXvNcSCAxUgNMAbclffooXcuWsH16311ZcZgVzm8dZGvYliN4hmRfo0x2baB9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA tagging protocol driver macros are in the public include/net/dsa.h
probably because that's also where the DSA_TAG_PROTO_*_VALUE macros are
(MODULE_ALIAS_DSA_TAG_DRIVER hinges on those macro definitions).

But there is no reason to expose these helpers to <net/dsa.h>. That
header is shared between switch drivers (drivers/net/dsa/), tagging
protocol drivers (net/dsa/tag_*.c), the DSA core (net/dsa/ sans tag_*.c),
and the rest of the world (DSA master drivers, network stack, etc).
Too much exposure.

On the other hand, net/dsa/dsa_priv.h is included only by the DSA core
and by DSA tagging protocol drivers (or IOW, "friend" modules). Also a
bit too much exposure - I've contemplated creating a new header which is
only included by tagging protocol drivers, but completely separating a
new dsa_tag_proto.h from dsa_priv.h is not immediately trivial - for
example dsa_slave_to_port() is used both from the fast path and from the
control path.

So for now, move these definitions to dsa_priv.h which at least hides
them from the world.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 include/net/dsa.h  | 70 ----------------------------------------------
 net/dsa/dsa_priv.h | 70 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ee369670e20e..0736e8720b5a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -118,10 +118,6 @@ struct dsa_netdevice_ops {
 			     int cmd);
 };
 
-#define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
-#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
-	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
-
 struct dsa_lag {
 	struct net_device *dev;
 	unsigned int id;
@@ -1403,70 +1399,4 @@ static inline bool dsa_slave_dev_check(const struct net_device *dev)
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
 void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
 
-struct dsa_tag_driver {
-	const struct dsa_device_ops *ops;
-	struct list_head list;
-	struct module *owner;
-};
-
-void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
-			      unsigned int count,
-			      struct module *owner);
-void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
-				unsigned int count);
-
-#define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
-static int __init dsa_tag_driver_module_init(void)			\
-{									\
-	dsa_tag_drivers_register(__dsa_tag_drivers_array, __count,	\
-				 THIS_MODULE);				\
-	return 0;							\
-}									\
-module_init(dsa_tag_driver_module_init);				\
-									\
-static void __exit dsa_tag_driver_module_exit(void)			\
-{									\
-	dsa_tag_drivers_unregister(__dsa_tag_drivers_array, __count);	\
-}									\
-module_exit(dsa_tag_driver_module_exit)
-
-/**
- * module_dsa_tag_drivers() - Helper macro for registering DSA tag
- * drivers
- * @__ops_array: Array of tag driver structures
- *
- * Helper macro for DSA tag drivers which do not do anything special
- * in module init/exit. Each module may only use this macro once, and
- * calling it replaces module_init() and module_exit().
- */
-#define module_dsa_tag_drivers(__ops_array)				\
-dsa_tag_driver_module_drivers(__ops_array, ARRAY_SIZE(__ops_array))
-
-#define DSA_TAG_DRIVER_NAME(__ops) dsa_tag_driver ## _ ## __ops
-
-/* Create a static structure we can build a linked list of dsa_tag
- * drivers
- */
-#define DSA_TAG_DRIVER(__ops)						\
-static struct dsa_tag_driver DSA_TAG_DRIVER_NAME(__ops) = {		\
-	.ops = &__ops,							\
-}
-
-/**
- * module_dsa_tag_driver() - Helper macro for registering a single DSA tag
- * driver
- * @__ops: Single tag driver structures
- *
- * Helper macro for DSA tag drivers which do not do anything special
- * in module init/exit. Each module may only use this macro once, and
- * calling it replaces module_init() and module_exit().
- */
-#define module_dsa_tag_driver(__ops)					\
-DSA_TAG_DRIVER(__ops);							\
-									\
-static struct dsa_tag_driver *dsa_tag_driver_array[] =	{		\
-	&DSA_TAG_DRIVER_NAME(__ops)					\
-};									\
-module_dsa_tag_drivers(dsa_tag_driver_array)
 #endif
-
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6e65c7ffd6f3..a7f1c2ca1089 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -17,6 +17,76 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
+#define DSA_TAG_DRIVER_ALIAS "dsa_tag-"
+#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto)				\
+	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __stringify(__proto##_VALUE))
+
+struct dsa_tag_driver {
+	const struct dsa_device_ops *ops;
+	struct list_head list;
+	struct module *owner;
+};
+
+void dsa_tag_drivers_register(struct dsa_tag_driver *dsa_tag_driver_array[],
+			      unsigned int count,
+			      struct module *owner);
+void dsa_tag_drivers_unregister(struct dsa_tag_driver *dsa_tag_driver_array[],
+				unsigned int count);
+
+#define dsa_tag_driver_module_drivers(__dsa_tag_drivers_array, __count)	\
+static int __init dsa_tag_driver_module_init(void)			\
+{									\
+	dsa_tag_drivers_register(__dsa_tag_drivers_array, __count,	\
+				 THIS_MODULE);				\
+	return 0;							\
+}									\
+module_init(dsa_tag_driver_module_init);				\
+									\
+static void __exit dsa_tag_driver_module_exit(void)			\
+{									\
+	dsa_tag_drivers_unregister(__dsa_tag_drivers_array, __count);	\
+}									\
+module_exit(dsa_tag_driver_module_exit)
+
+/**
+ * module_dsa_tag_drivers() - Helper macro for registering DSA tag
+ * drivers
+ * @__ops_array: Array of tag driver structures
+ *
+ * Helper macro for DSA tag drivers which do not do anything special
+ * in module init/exit. Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit().
+ */
+#define module_dsa_tag_drivers(__ops_array)				\
+dsa_tag_driver_module_drivers(__ops_array, ARRAY_SIZE(__ops_array))
+
+#define DSA_TAG_DRIVER_NAME(__ops) dsa_tag_driver ## _ ## __ops
+
+/* Create a static structure we can build a linked list of dsa_tag
+ * drivers
+ */
+#define DSA_TAG_DRIVER(__ops)						\
+static struct dsa_tag_driver DSA_TAG_DRIVER_NAME(__ops) = {		\
+	.ops = &__ops,							\
+}
+
+/**
+ * module_dsa_tag_driver() - Helper macro for registering a single DSA tag
+ * driver
+ * @__ops: Single tag driver structures
+ *
+ * Helper macro for DSA tag drivers which do not do anything special
+ * in module init/exit. Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit().
+ */
+#define module_dsa_tag_driver(__ops)					\
+DSA_TAG_DRIVER(__ops);							\
+									\
+static struct dsa_tag_driver *dsa_tag_driver_array[] =	{		\
+	&DSA_TAG_DRIVER_NAME(__ops)					\
+};									\
+module_dsa_tag_drivers(dsa_tag_driver_array)
+
 enum {
 	DSA_NOTIFIER_AGEING_TIME,
 	DSA_NOTIFIER_BRIDGE_JOIN,
-- 
2.34.1

