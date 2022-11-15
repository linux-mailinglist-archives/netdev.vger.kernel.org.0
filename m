Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2B628F21
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 02:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiKOBTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 20:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbiKOBTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 20:19:05 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70075.outbound.protection.outlook.com [40.107.7.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016DD13DCC
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:19:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYXkErThum0PIg8qMOdY0xz6EXkv/OM9VB5laMrOPK6izh3IIq/5VzdR6JyikzgidvEpkqBkIPeGpo2C7t0Df/hGCRbAvB+3lsLDb+WS34YBN8MLhBjm84wCzs1YRYbsvP3Uw6eNvWoydJWt0/nZeznCs+Xxisg/2LJwcnBFOqrB7pX8yaCiE6BBT05vCQUHncxgtn8myCMFEbp321FLXGagcmClOmemXI4xyp7FyC2MJmv+gVMmwNIOJET5dxtcHx7qgB2Z8nOIncmiCtVX7Zu688E8TBERMMEO9mj6h2lFjEilVNpz9zbagpJY79DLQB2YkgRJ4kNwfHnEWr0RzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LVl3uiffsw9WSZ8efCamAHaUCGjx+jmhb78KJ4EEAT0=;
 b=kpp2dLm51IkTdmBZkPuajAOa/8V0+/R45xlcbu4v485w1HWkFtP6ajnl8yJuX6msfQLTN1u3olvw/fbDkCpWT0Bp50CXQtHvkp8VioFbDD/kSEuDhDRwsd0zQL6aRjhojY2gJfEBg5fW7S1nnYn1N6EyofAorifV16F3svImRUMiI0pLsEHnfqAvoByrkPzsEhymNgU35U9T/+s1i/sSgIrgeUT7PE9KmyMW9Z9N3y9G6YDMVuo7nGPXnlnlyndCp+xr/GPf5+qqzjzg4L9lSzeMhLW8b28rDn1IucXI+LD6iOwQnVCuYv7a2RaOX6x7aErp2jT8jWtvY14IZAt+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LVl3uiffsw9WSZ8efCamAHaUCGjx+jmhb78KJ4EEAT0=;
 b=LV4b7yMsF86dG7ydYIPUCevubSkp5Y972J3jGfjXGq5OUM9cJOyhdd25XsecaQqI11VQl9YoR1mArhLhZt1tseqZHxkrDzcU+sgVjKlVkZCmwR+6n75xxvdUgrGgX8Iqg8X9bezpM0jiUi7bKY2rG72Vd7GmlZxGZ75i5dja5Lg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Tue, 15 Nov
 2022 01:19:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Tue, 15 Nov 2022
 01:19:00 +0000
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
Subject: [PATCH v2 net-next 3/6] net: dsa: provide a second modalias to tag proto drivers based on their name
Date:   Tue, 15 Nov 2022 03:18:44 +0200
Message-Id: <20221115011847.2843127-4-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e26ac216-e8c5-4682-9793-08dac6a76057
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gl3VmdDQlDgWp9AXjoB7c+XJXfuX+CyMWzhndY6Ar04d+N9yGQovxHCrBaIRwedlDPwMBCCi4+w5nHNwAV3smD/k/WLHHRoZsfB5cvoAMuXWABju58W9q7jrFbLIPo7N28UwQu24mPpxl8tmDMcVeFEm1BQFG7PXBi3UqUZxJPvjFExfWdKgoR4Sl3r6MiJId8cHiCbRVaeiF/Hoo2kVTyj8T2rfoRITRgcObo5vQUnCky2jwBLQYuC7M8CGZM05fmm1/Zytd2AT6QvP342BMhcRpponnSuHDkqnucwgC1IUTS0td6atSg2iRPNiPB9n0ybKK/PNJp7Ks9WZHnojc60z1TVMDwaLhmUyZEzUS5VAvt98peK0ydeFlZO2MytsSt/88288GzIzAQdf3k8CzDDEf5fK+vbVCOXYgXLSTd4beni2m+fqvGTWzPZs329oVcsAnZLvTAp60iT5/fiKSU4SkhzhqCpsR+JFXiqi94u+37tqA/NT0OGih1+vE5n1Bl3AorHP6s79aIwtAx2EyOHXnBD2avJolgZjEA5DOJtepa5ROgO9V+KW/CRnBbUZTJSLRRixsow+o9xNH8fI12o1wKeM+24ci19JZz/uLzluHgyciUr6w0QSejvL1hh2vu5ZAi6P1ey0gXBiZUrI9VyH8unJv7/5891eKw7rc9Xc9ASxQrzoNd1F1nJA7cx7KpL2eQ9MlXNR/H4dJBjUx4+xiUyVmSXk4pB8RBcGuB+DLerCQx30xuKVI6nROA1NP4DTTagRPHfBtc7dIy/uAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(66556008)(86362001)(316002)(6916009)(30864003)(4326008)(7416002)(8936002)(8676002)(36756003)(5660300002)(41300700001)(44832011)(66946007)(66476007)(2616005)(6512007)(38350700002)(54906003)(38100700002)(478600001)(186003)(83380400001)(6486002)(26005)(6506007)(52116002)(6666004)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mJUmC5PEkr0vcxeAidPM28EL2enq1/u+Ht3gZEZOkmkFz3adxVt2k/TFrd1+?=
 =?us-ascii?Q?twUZpQf7IqlXu7Z1FIomLAelSxBElfzeR6+tgS9ShWzFufXjgsO9r8+3xeq7?=
 =?us-ascii?Q?KmHo0zSfm9XrV2Nm0AsVWTqMZd7iMYN6nLywLFP4OeHMadVBTucpIOqS/LfF?=
 =?us-ascii?Q?tMrm5x6A7kcMwsn8SqQ0DS2WxfADXvIX4mxQAxi45EwemHIhX36Pjz03LbNW?=
 =?us-ascii?Q?BKwwU825eK2H6BZDaZgaZ6Pow2s8XNWp+X6KGnjNofIxXsELFOChUpUaGIJS?=
 =?us-ascii?Q?YS1NMnC1KcTTWDQFKD1t62t5vr8XB9lhgqeqpqnvvoT6hm9k766sT8fPiSMW?=
 =?us-ascii?Q?z2C/RnnLvkHCdIinI47hQOqoJjpWzF9Q3Aqg3Pv7yHwmBT4d+bXTxO4sPJmy?=
 =?us-ascii?Q?gdvNp1q9pnppYa7HRNh8u83QOX/q14oOOUCYeLnAY1xkUsA72KXdsYz3omP6?=
 =?us-ascii?Q?QZiBnMVeAkPC4K6b7Qo5BSj4kkLESPb0Pr+4vVId46WG55Rrfa8lbhO0Bq9f?=
 =?us-ascii?Q?wrXWmmxaH/X1H+a6aCUHyYj8pllW54h9sbJ3x9e4KGE3oyaJ6U2vKf8Dli15?=
 =?us-ascii?Q?Oe+UiPdMvJfBzEoHK47fMILmwoSK8++WPldeARZqAnHA5bRLFw3wSU+mN90t?=
 =?us-ascii?Q?6dJMRqb4YvsvCYZO55q0SfiwyytVjImfyc8249tmq0haC8bBSrKYemknpPZJ?=
 =?us-ascii?Q?2ZKp5PDzA1Ld6dOCA6D5fE1KL0vREeCNDREcrwYagkRNhL/Zw2xYDev22W+/?=
 =?us-ascii?Q?goyAnGu1tXrB6dJ+vZstoaDa3zi3qK8uvwLIFCAQOftPP5fo3gpaTcMhFyhe?=
 =?us-ascii?Q?cDJsc6hM43U25c0uqiA/x+7LjrJKNnwVNIlT2BP09449JXi5GRYE2EdZ+W1x?=
 =?us-ascii?Q?xHTN/sb42ZCviVqN1Icc/vnuTI0c9iRM0ztJxSUR6f1TAS+0iu2uFXOyGyR4?=
 =?us-ascii?Q?EeCUQ6MRj5nuYwR+EMD6rJ7CRtUBkQ5FQZHWJc8YtCW03zppDgL0s6bUzfLs?=
 =?us-ascii?Q?3qHN8wbnhBZJjlt68v/AFizQzXwbKTwoiSCoPCUjjv2G1D5EQGMWVmj+iQSb?=
 =?us-ascii?Q?Uo8kC4njFx/EksszLnuyzSLmwjhkEwFfX6To4Oq9TCgs00kCKTsdL8xKV3dX?=
 =?us-ascii?Q?NuLhYZllba0gNZIGXja1qvyLx49UJKp9HHaJAu1a7riWbKbCXw7kLmM2as6h?=
 =?us-ascii?Q?H6P+x3aZ4tTMKNuwsHU/xgWiHmYHBOdhdP6Ccbbf4z8XJKgYs8v1bYFg04HE?=
 =?us-ascii?Q?7ug+o58D90ZZJ3Xm+muOXfSEr53dPw/CBew0jD4wFpiHS8Mzm/hgIH0uVFyo?=
 =?us-ascii?Q?TZcxp8toKGpvepDo3BoEDZDR2mktgeYa4CF4ZN9c0FTpZ1LdpJHvKZSl3WhZ?=
 =?us-ascii?Q?l/PekBUFRenqSFOLm4qNnlpl+mHdmv7TKCOLYI2YwwYo51sq/iIFn4KZZhuT?=
 =?us-ascii?Q?C+qmiIBcWgh7vtW+k+Ok4bn+6Xh63t1aMRvYYW4nElgbagAl3rJVMRZWiAB8?=
 =?us-ascii?Q?OBy6HqE+Tbm5K27P//nViFbYluxsut47rNa5G8D8jSiU/eUFtSPZ0ddp5NxR?=
 =?us-ascii?Q?sQO81segETCIvPLQPT6XgR7qCG28SesX1QpaJxuUQsgCF6D/flj8ux7EaBZ5?=
 =?us-ascii?Q?0A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26ac216-e8c5-4682-9793-08dac6a76057
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 01:19:00.6881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wY4jY/9NlA+omrEM9iqgsIbJDVfE1f9UHqSMWgtDW6RKIH2GQzzaxWseLDtMSWLQbo/8Qkt3UeBUbiCg06zfJg==
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

Currently, tagging protocol drivers have a modalias of
"dsa_tag:id-<number>", where the number is one of DSA_TAG_PROTO_*_VALUE.

This modalias makes it possible for the request_module() call in
dsa_tag_driver_get() to work, given the input it has - an integer
returned by ds->ops->get_tag_protocol().

It is also possible to change tagging protocols at (pseudo-)runtime, via
sysfs or via device tree, and this works via the name string of the
tagging protocol rather than via its id (DSA_TAG_PROTO_*_VALUE).

In the latter case, there is no request_module() call, because there is
no association that the DSA core has between the string name and the ID,
to construct the modalias. The module is simply assumed to have been
inserted. This is actually slightly problematic when the tagging
protocol change should take place at probe time, since it's expected
that the dependency module should get autoloaded.

For this purpose, let's introduce a second modalias, so that the DSA
core can call request_module() by name. There is no reason to make the
modalias by name optional, so just modify the MODULE_ALIAS_DSA_TAG_DRIVER()
macro to take both the ID and the name as arguments, and generate two
modaliases behind the scenes.

Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Michael Walle <michael@walle.cc> # on kontron-sl28 w/ ocelot_8021q
---
v1->v2: macros are now in net/dsa/dsa_priv.h, otherwise the same

 net/dsa/dsa_priv.h         |  6 +++++-
 net/dsa/tag_ar9331.c       |  6 ++++--
 net/dsa/tag_brcm.c         | 16 ++++++++++------
 net/dsa/tag_dsa.c          | 11 +++++++----
 net/dsa/tag_gswip.c        |  6 ++++--
 net/dsa/tag_hellcreek.c    |  6 ++++--
 net/dsa/tag_ksz.c          | 21 +++++++++++++--------
 net/dsa/tag_lan9303.c      |  6 ++++--
 net/dsa/tag_mtk.c          |  6 ++++--
 net/dsa/tag_ocelot.c       | 11 +++++++----
 net/dsa/tag_ocelot_8021q.c |  6 ++++--
 net/dsa/tag_qca.c          |  6 ++++--
 net/dsa/tag_rtl4_a.c       |  6 ++++--
 net/dsa/tag_rtl8_4.c       |  7 +++++--
 net/dsa/tag_rzn1_a5psw.c   |  6 ++++--
 net/dsa/tag_sja1105.c      | 11 +++++++----
 net/dsa/tag_trailer.c      |  6 ++++--
 net/dsa/tag_xrs700x.c      |  6 ++++--
 18 files changed, 98 insertions(+), 51 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9b635dddad3f..b4b8fe4ed9bf 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -17,8 +17,12 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
+/* Create 2 modaliases per tagging protocol, one to auto-load the module
+ * given the ID reported by get_tag_protocol(), and the other by name.
+ */
 #define DSA_TAG_DRIVER_ALIAS "dsa_tag:"
-#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto) \
+#define MODULE_ALIAS_DSA_TAG_DRIVER(__proto, __name) \
+	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS __name); \
 	MODULE_ALIAS(DSA_TAG_DRIVER_ALIAS "id-" \
 		     __stringify(__proto##_VALUE))
 
diff --git a/net/dsa/tag_ar9331.c b/net/dsa/tag_ar9331.c
index 8a02ac44282f..bfa161a4f502 100644
--- a/net/dsa/tag_ar9331.c
+++ b/net/dsa/tag_ar9331.c
@@ -9,6 +9,8 @@
 
 #include "dsa_priv.h"
 
+#define AR9331_NAME			"ar9331"
+
 #define AR9331_HDR_LEN			2
 #define AR9331_HDR_VERSION		1
 
@@ -80,7 +82,7 @@ static struct sk_buff *ar9331_tag_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops ar9331_netdev_ops = {
-	.name	= "ar9331",
+	.name	= AR9331_NAME,
 	.proto	= DSA_TAG_PROTO_AR9331,
 	.xmit	= ar9331_tag_xmit,
 	.rcv	= ar9331_tag_rcv,
@@ -88,5 +90,5 @@ static const struct dsa_device_ops ar9331_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_AR9331);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_AR9331, AR9331_NAME);
 module_dsa_tag_driver(ar9331_netdev_ops);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 16889ea3e0a7..9e7477ed70f1 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -12,6 +12,10 @@
 
 #include "dsa_priv.h"
 
+#define BRCM_NAME		"brcm"
+#define BRCM_LEGACY_NAME	"brcm-legacy"
+#define BRCM_PREPEND_NAME	"brcm-prepend"
+
 /* Legacy Broadcom tag (6 bytes) */
 #define BRCM_LEG_TAG_LEN	6
 
@@ -196,7 +200,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops brcm_netdev_ops = {
-	.name	= "brcm",
+	.name	= BRCM_NAME,
 	.proto	= DSA_TAG_PROTO_BRCM,
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
@@ -204,7 +208,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM, BRCM_NAME);
 #endif
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
@@ -273,7 +277,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops brcm_legacy_netdev_ops = {
-	.name = "brcm-legacy",
+	.name = BRCM_LEGACY_NAME,
 	.proto = DSA_TAG_PROTO_BRCM_LEGACY,
 	.xmit = brcm_leg_tag_xmit,
 	.rcv = brcm_leg_tag_rcv,
@@ -281,7 +285,7 @@ static const struct dsa_device_ops brcm_legacy_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(brcm_legacy_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY, BRCM_LEGACY_NAME);
 #endif /* CONFIG_NET_DSA_TAG_BRCM_LEGACY */
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
@@ -300,7 +304,7 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops brcm_prepend_netdev_ops = {
-	.name	= "brcm-prepend",
+	.name	= BRCM_PREPEND_NAME,
 	.proto	= DSA_TAG_PROTO_BRCM_PREPEND,
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
@@ -308,7 +312,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_PREPEND);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_PREPEND, BRCM_PREPEND_NAME);
 #endif
 
 static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index e4b6e3f2a3db..9fe77f5cc759 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -52,6 +52,9 @@
 
 #include "dsa_priv.h"
 
+#define DSA_NAME	"dsa"
+#define EDSA_NAME	"edsa"
+
 #define DSA_HLEN	4
 
 /**
@@ -339,7 +342,7 @@ static struct sk_buff *dsa_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops dsa_netdev_ops = {
-	.name	  = "dsa",
+	.name	  = DSA_NAME,
 	.proto	  = DSA_TAG_PROTO_DSA,
 	.xmit	  = dsa_xmit,
 	.rcv	  = dsa_rcv,
@@ -347,7 +350,7 @@ static const struct dsa_device_ops dsa_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(dsa_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_DSA);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_DSA, DSA_NAME);
 #endif	/* CONFIG_NET_DSA_TAG_DSA */
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_EDSA)
@@ -381,7 +384,7 @@ static struct sk_buff *edsa_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops edsa_netdev_ops = {
-	.name	  = "edsa",
+	.name	  = EDSA_NAME,
 	.proto	  = DSA_TAG_PROTO_EDSA,
 	.xmit	  = edsa_xmit,
 	.rcv	  = edsa_rcv,
@@ -389,7 +392,7 @@ static const struct dsa_device_ops edsa_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(edsa_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_EDSA);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_EDSA, EDSA_NAME);
 #endif	/* CONFIG_NET_DSA_TAG_EDSA */
 
 static struct dsa_tag_driver *dsa_tag_drivers[] = {
diff --git a/net/dsa/tag_gswip.c b/net/dsa/tag_gswip.c
index df7140984da3..020050dff3e4 100644
--- a/net/dsa/tag_gswip.c
+++ b/net/dsa/tag_gswip.c
@@ -12,6 +12,8 @@
 
 #include "dsa_priv.h"
 
+#define GSWIP_NAME			"gswip"
+
 #define GSWIP_TX_HEADER_LEN		4
 
 /* special tag in TX path header */
@@ -98,7 +100,7 @@ static struct sk_buff *gswip_tag_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops gswip_netdev_ops = {
-	.name = "gswip",
+	.name = GSWIP_NAME,
 	.proto	= DSA_TAG_PROTO_GSWIP,
 	.xmit = gswip_tag_xmit,
 	.rcv = gswip_tag_rcv,
@@ -106,6 +108,6 @@ static const struct dsa_device_ops gswip_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_GSWIP);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_GSWIP, GSWIP_NAME);
 
 module_dsa_tag_driver(gswip_netdev_ops);
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 846588c0070a..03fd5f2877c8 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -13,6 +13,8 @@
 
 #include "dsa_priv.h"
 
+#define HELLCREEK_NAME		"hellcreek"
+
 #define HELLCREEK_TAG_LEN	1
 
 static struct sk_buff *hellcreek_xmit(struct sk_buff *skb,
@@ -57,7 +59,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops hellcreek_netdev_ops = {
-	.name	  = "hellcreek",
+	.name	  = HELLCREEK_NAME,
 	.proto	  = DSA_TAG_PROTO_HELLCREEK,
 	.xmit	  = hellcreek_xmit,
 	.rcv	  = hellcreek_rcv,
@@ -65,6 +67,6 @@ static const struct dsa_device_ops hellcreek_netdev_ops = {
 };
 
 MODULE_LICENSE("Dual MIT/GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_HELLCREEK);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_HELLCREEK, HELLCREEK_NAME);
 
 module_dsa_tag_driver(hellcreek_netdev_ops);
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index 38fa19c1e2d5..37db5156f9a3 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -9,6 +9,11 @@
 #include <net/dsa.h>
 #include "dsa_priv.h"
 
+#define KSZ8795_NAME "ksz8795"
+#define KSZ9477_NAME "ksz9477"
+#define KSZ9893_NAME "ksz9893"
+#define LAN937X_NAME "lan937x"
+
 /* Typically only one byte is used for tail tag. */
 #define KSZ_EGRESS_TAG_LEN		1
 #define KSZ_INGRESS_TAG_LEN		1
@@ -74,7 +79,7 @@ static struct sk_buff *ksz8795_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops ksz8795_netdev_ops = {
-	.name	= "ksz8795",
+	.name	= KSZ8795_NAME,
 	.proto	= DSA_TAG_PROTO_KSZ8795,
 	.xmit	= ksz8795_xmit,
 	.rcv	= ksz8795_rcv,
@@ -82,7 +87,7 @@ static const struct dsa_device_ops ksz8795_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(ksz8795_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ8795, KSZ8795_NAME);
 
 /*
  * For Ingress (Host -> KSZ9477), 2 bytes are added before FCS.
@@ -147,7 +152,7 @@ static struct sk_buff *ksz9477_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops ksz9477_netdev_ops = {
-	.name	= "ksz9477",
+	.name	= KSZ9477_NAME,
 	.proto	= DSA_TAG_PROTO_KSZ9477,
 	.xmit	= ksz9477_xmit,
 	.rcv	= ksz9477_rcv,
@@ -155,7 +160,7 @@ static const struct dsa_device_ops ksz9477_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(ksz9477_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9477, KSZ9477_NAME);
 
 #define KSZ9893_TAIL_TAG_OVERRIDE	BIT(5)
 #define KSZ9893_TAIL_TAG_LOOKUP		BIT(6)
@@ -183,7 +188,7 @@ static struct sk_buff *ksz9893_xmit(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops ksz9893_netdev_ops = {
-	.name	= "ksz9893",
+	.name	= KSZ9893_NAME,
 	.proto	= DSA_TAG_PROTO_KSZ9893,
 	.xmit	= ksz9893_xmit,
 	.rcv	= ksz9477_rcv,
@@ -191,7 +196,7 @@ static const struct dsa_device_ops ksz9893_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(ksz9893_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893, KSZ9893_NAME);
 
 /* For xmit, 2 bytes are added before FCS.
  * ---------------------------------------------------------------------------
@@ -241,7 +246,7 @@ static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops lan937x_netdev_ops = {
-	.name	= "lan937x",
+	.name	= LAN937X_NAME,
 	.proto	= DSA_TAG_PROTO_LAN937X,
 	.xmit	= lan937x_xmit,
 	.rcv	= ksz9477_rcv,
@@ -249,7 +254,7 @@ static const struct dsa_device_ops lan937x_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(lan937x_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X, LAN937X_NAME);
 
 static struct dsa_tag_driver *dsa_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index 98d7d7120bab..4118292ed218 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -30,6 +30,8 @@
  * Required when no forwarding between the external ports should happen.
  */
 
+#define LAN9303_NAME "lan9303"
+
 #define LAN9303_TAG_LEN 4
 # define LAN9303_TAG_TX_USE_ALR BIT(3)
 # define LAN9303_TAG_TX_STP_OVERRIDE BIT(4)
@@ -110,7 +112,7 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops lan9303_netdev_ops = {
-	.name = "lan9303",
+	.name = LAN9303_NAME,
 	.proto	= DSA_TAG_PROTO_LAN9303,
 	.xmit = lan9303_xmit,
 	.rcv = lan9303_rcv,
@@ -118,6 +120,6 @@ static const struct dsa_device_ops lan9303_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN9303);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN9303, LAN9303_NAME);
 
 module_dsa_tag_driver(lan9303_netdev_ops);
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index 415d8ece242a..ba37495ab5f4 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -10,6 +10,8 @@
 
 #include "dsa_priv.h"
 
+#define MTK_NAME		"mtk"
+
 #define MTK_HDR_LEN		4
 #define MTK_HDR_XMIT_UNTAGGED		0
 #define MTK_HDR_XMIT_TAGGED_TPID_8100	1
@@ -91,7 +93,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops mtk_netdev_ops = {
-	.name		= "mtk",
+	.name		= MTK_NAME,
 	.proto		= DSA_TAG_PROTO_MTK,
 	.xmit		= mtk_tag_xmit,
 	.rcv		= mtk_tag_rcv,
@@ -99,6 +101,6 @@ static const struct dsa_device_ops mtk_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_MTK);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_MTK, MTK_NAME);
 
 module_dsa_tag_driver(mtk_netdev_ops);
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 0d81f172b7a6..8cc31ab47e28 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -4,6 +4,9 @@
 #include <linux/dsa/ocelot.h>
 #include "dsa_priv.h"
 
+#define OCELOT_NAME	"ocelot"
+#define SEVILLE_NAME	"seville"
+
 /* If the port is under a VLAN-aware bridge, remove the VLAN header from the
  * payload and move it into the DSA tag, which will make the switch classify
  * the packet to the bridge VLAN. Otherwise, leave the classified VLAN at zero,
@@ -183,7 +186,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops ocelot_netdev_ops = {
-	.name			= "ocelot",
+	.name			= OCELOT_NAME,
 	.proto			= DSA_TAG_PROTO_OCELOT,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
@@ -192,10 +195,10 @@ static const struct dsa_device_ops ocelot_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(ocelot_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT, OCELOT_NAME);
 
 static const struct dsa_device_ops seville_netdev_ops = {
-	.name			= "seville",
+	.name			= SEVILLE_NAME,
 	.proto			= DSA_TAG_PROTO_SEVILLE,
 	.xmit			= seville_xmit,
 	.rcv			= ocelot_rcv,
@@ -204,7 +207,7 @@ static const struct dsa_device_ops seville_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(seville_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SEVILLE);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SEVILLE, SEVILLE_NAME);
 
 static struct dsa_tag_driver *ocelot_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(ocelot_netdev_ops),
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 37ccf00404ea..d1ec68001487 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -12,6 +12,8 @@
 #include <linux/dsa/ocelot.h>
 #include "dsa_priv.h"
 
+#define OCELOT_8021Q_NAME "ocelot-8021q"
+
 struct ocelot_8021q_tagger_private {
 	struct ocelot_8021q_tagger_data data; /* Must be first */
 	struct kthread_worker *xmit_worker;
@@ -119,7 +121,7 @@ static int ocelot_connect(struct dsa_switch *ds)
 }
 
 static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
-	.name			= "ocelot-8021q",
+	.name			= OCELOT_8021Q_NAME,
 	.proto			= DSA_TAG_PROTO_OCELOT_8021Q,
 	.xmit			= ocelot_xmit,
 	.rcv			= ocelot_rcv,
@@ -130,6 +132,6 @@ static const struct dsa_device_ops ocelot_8021q_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT_8021Q);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_OCELOT_8021Q, OCELOT_8021Q_NAME);
 
 module_dsa_tag_driver(ocelot_8021q_netdev_ops);
diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index 57d2e00f1e5d..73d6e111228d 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -10,6 +10,8 @@
 
 #include "dsa_priv.h"
 
+#define QCA_NAME "qca"
+
 static struct sk_buff *qca_tag_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -107,7 +109,7 @@ static void qca_tag_disconnect(struct dsa_switch *ds)
 }
 
 static const struct dsa_device_ops qca_netdev_ops = {
-	.name	= "qca",
+	.name	= QCA_NAME,
 	.proto	= DSA_TAG_PROTO_QCA,
 	.connect = qca_tag_connect,
 	.disconnect = qca_tag_disconnect,
@@ -118,6 +120,6 @@ static const struct dsa_device_ops qca_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_QCA);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_QCA, QCA_NAME);
 
 module_dsa_tag_driver(qca_netdev_ops);
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 6d928ee3ef7a..18b52d77d200 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -20,6 +20,8 @@
 
 #include "dsa_priv.h"
 
+#define RTL4_A_NAME		"rtl4a"
+
 #define RTL4_A_HDR_LEN		4
 #define RTL4_A_ETHERTYPE	0x8899
 #define RTL4_A_PROTOCOL_SHIFT	12
@@ -112,7 +114,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops rtl4a_netdev_ops = {
-	.name	= "rtl4a",
+	.name	= RTL4_A_NAME,
 	.proto	= DSA_TAG_PROTO_RTL4_A,
 	.xmit	= rtl4a_tag_xmit,
 	.rcv	= rtl4a_tag_rcv,
@@ -121,4 +123,4 @@ static const struct dsa_device_ops rtl4a_netdev_ops = {
 module_dsa_tag_driver(rtl4a_netdev_ops);
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL4_A);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL4_A, RTL4_A_NAME);
diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
index a593ead7ff26..030a8cf0ad48 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -84,6 +84,9 @@
  * 0x04 = RTL8365MB DSA protocol
  */
 
+#define RTL8_4_NAME			"rtl8_4"
+#define RTL8_4T_NAME			"rtl8_4t"
+
 #define RTL8_4_TAG_LEN			8
 
 #define RTL8_4_PROTOCOL			GENMASK(15, 8)
@@ -234,7 +237,7 @@ static const struct dsa_device_ops rtl8_4_netdev_ops = {
 
 DSA_TAG_DRIVER(rtl8_4_netdev_ops);
 
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4, RTL8_4_NAME);
 
 /* Tail version */
 static const struct dsa_device_ops rtl8_4t_netdev_ops = {
@@ -247,7 +250,7 @@ static const struct dsa_device_ops rtl8_4t_netdev_ops = {
 
 DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
 
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4T);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4T, RTL8_4T_NAME);
 
 static struct dsa_tag_driver *dsa_tag_drivers[] = {
 	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
diff --git a/net/dsa/tag_rzn1_a5psw.c b/net/dsa/tag_rzn1_a5psw.c
index e2a5ee6ae688..b9135069f9fc 100644
--- a/net/dsa/tag_rzn1_a5psw.c
+++ b/net/dsa/tag_rzn1_a5psw.c
@@ -22,6 +22,8 @@
  * See struct a5psw_tag for layout
  */
 
+#define A5PSW_NAME			"a5psw"
+
 #define ETH_P_DSA_A5PSW			0xE001
 #define A5PSW_TAG_LEN			8
 #define A5PSW_CTRL_DATA_FORCE_FORWARD	BIT(0)
@@ -101,7 +103,7 @@ static struct sk_buff *a5psw_tag_rcv(struct sk_buff *skb,
 }
 
 static const struct dsa_device_ops a5psw_netdev_ops = {
-	.name	= "a5psw",
+	.name	= A5PSW_NAME,
 	.proto	= DSA_TAG_PROTO_RZN1_A5PSW,
 	.xmit	= a5psw_tag_xmit,
 	.rcv	= a5psw_tag_rcv,
@@ -109,5 +111,5 @@ static const struct dsa_device_ops a5psw_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_A5PSW);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_A5PSW, A5PSW_NAME);
 module_dsa_tag_driver(a5psw_netdev_ops);
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 83e4136516b0..3b6e642a90e9 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,6 +7,9 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
+#define SJA1105_NAME				"sja1105"
+#define SJA1110_NAME				"sja1110"
+
 /* Is this a TX or an RX header? */
 #define SJA1110_HEADER_HOST_TO_SWITCH		BIT(15)
 
@@ -786,7 +789,7 @@ static int sja1105_connect(struct dsa_switch *ds)
 }
 
 static const struct dsa_device_ops sja1105_netdev_ops = {
-	.name = "sja1105",
+	.name = SJA1105_NAME,
 	.proto = DSA_TAG_PROTO_SJA1105,
 	.xmit = sja1105_xmit,
 	.rcv = sja1105_rcv,
@@ -798,10 +801,10 @@ static const struct dsa_device_ops sja1105_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(sja1105_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1105);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1105, SJA1105_NAME);
 
 static const struct dsa_device_ops sja1110_netdev_ops = {
-	.name = "sja1110",
+	.name = SJA1110_NAME,
 	.proto = DSA_TAG_PROTO_SJA1110,
 	.xmit = sja1110_xmit,
 	.rcv = sja1110_rcv,
@@ -813,7 +816,7 @@ static const struct dsa_device_ops sja1110_netdev_ops = {
 };
 
 DSA_TAG_DRIVER(sja1110_netdev_ops);
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1110);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_SJA1110, SJA1110_NAME);
 
 static struct dsa_tag_driver *sja1105_tag_driver_array[] = {
 	&DSA_TAG_DRIVER_NAME(sja1105_netdev_ops),
diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 5749ba85c2b8..8754dfe680f6 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -10,6 +10,8 @@
 
 #include "dsa_priv.h"
 
+#define TRAILER_NAME "trailer"
+
 static struct sk_buff *trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
@@ -50,7 +52,7 @@ static struct sk_buff *trailer_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops trailer_netdev_ops = {
-	.name	= "trailer",
+	.name	= TRAILER_NAME,
 	.proto	= DSA_TAG_PROTO_TRAILER,
 	.xmit	= trailer_xmit,
 	.rcv	= trailer_rcv,
@@ -58,6 +60,6 @@ static const struct dsa_device_ops trailer_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_TRAILER);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_TRAILER, TRAILER_NAME);
 
 module_dsa_tag_driver(trailer_netdev_ops);
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index ff442b8af636..dc935dd90f98 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -9,6 +9,8 @@
 
 #include "dsa_priv.h"
 
+#define XRS700X_NAME "xrs700x"
+
 static struct sk_buff *xrs700x_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_port *partner, *dp = dsa_slave_to_port(dev);
@@ -51,7 +53,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev)
 }
 
 static const struct dsa_device_ops xrs700x_netdev_ops = {
-	.name	= "xrs700x",
+	.name	= XRS700X_NAME,
 	.proto	= DSA_TAG_PROTO_XRS700X,
 	.xmit	= xrs700x_xmit,
 	.rcv	= xrs700x_rcv,
@@ -59,6 +61,6 @@ static const struct dsa_device_ops xrs700x_netdev_ops = {
 };
 
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_XRS700X);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_XRS700X, XRS700X_NAME);
 
 module_dsa_tag_driver(xrs700x_netdev_ops);
-- 
2.34.1

