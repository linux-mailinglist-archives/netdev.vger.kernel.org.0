Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37410632468
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiKUN4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiKUN4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:18 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23F61C906
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9BkskJcOys+1Dttm1I52UZmGpXFwgB8Rqo5EMShBQGcwrLXJ6nAK5fuK+FOECZFedMHihpI5h1wlV+0GqUP9zHjJZiaLUmsP2mmIpP3JsKffjdIr49a8O124qOcBgdP4HtyIpFMt3sClMYBj2Lsrw2Yo0yQarQyKjddILoT+Z4k0Gt5x8DQ7ZdMju7L2onqbfm8ClpsS7V/iCsk7t1vp5Kb1mr9BkQ5C8oB3/284x3ltjoN6DglaWkJmNKt/yS96ziaRBaXk/UBsTYsZ3+81U3Rw8Vfmr9oHKHD7+rAst7z117wSX6MVHPsdTXvuuTnDx4hEVo+flbZ9t1x/m4TrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMrt2M2yYIVIWzYxk5GTfmI7+A30eSZdnwfZFn4cL6I=;
 b=QJA/1EBarXKt6zlyO8FoXO/y1oPuv2CySaLDPZ578jE+zbmDeD+gnD71A9nr7HtOeYe2mScLV77sWZdO4KCN4AA80XtArKWloiC3qBkMOwDDU9uP7dsATW3EqsULeykEe1erU5jYiKXzoDNHqRqW7A7sniQnUiBgVORqoOdRwK7cmi+TOImKKi+UeDW7WSlZMbebDtujJgIKCo9cHIJ38tVjWYUC6EQ9HJtT4KJgeQw+7Txx7WwSBXMMHRB5HPWrUwREtiZenkniapMJbM3MDM5slqylkUYDJ4kUB/V1wSggdUqF3uRrH67J2wlpkLeWjLixUvYaA8+OfgnL8JKtlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMrt2M2yYIVIWzYxk5GTfmI7+A30eSZdnwfZFn4cL6I=;
 b=H/MJCHkq/VgrithkVS7EEEA9ls0RLDHt2ZpKPEJXQzhWsZFxHNs6+gTX/I/RfPC29JEbt/UIa9KU9Cd3HYi1wPnw5tMoM9v8Qem+Ewke3T1lSoD9rPAp60dj9cmA9T8Kcy2Nhon1jWhlWOK2ryQIH9RtOYhCeIIBDGi088GYOA4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 02/17] net: dsa: modularize DSA_TAG_PROTO_NONE
Date:   Mon, 21 Nov 2022 15:55:40 +0200
Message-Id: <20221121135555.1227271-3-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 373e8a42-9f22-4519-bcc7-08dacbc826d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZUDIxX7RUvBCqFjvP3cDxeNJ4IT6Y02/QeBKMN8MwkaiV/YIEfWduw3sFGdGV6S7o9wys+YbJIcv1gNx6jF7I4SJmuDmk3XMu07qh9MT7dITpUgiwglLim2Czh1fZXyey8XkpaiMkRvM+6/9oReGZS8EOtftDgqJeIy/RhdVujxt4SmyeoQK8BDyP81AdBiXp7QXnWvSuZkm+CPjoBtp8cr/BIuZ6WX0jKFI2iXULlOhmWSFOW7Zo99J7jJGvSqoNF8TL8QN/gf1zu7HTL5SIPoThBvAzEdC+rXPvgEBTWLJs02Qih+2QjLQhw3w9y333l4vGro5O90qYtxdag6UVkGhHgROGYUZiWdcRzqxDy0sMxYEKDT+VVr3uob7eHt19wbH6I9oYVwvol3iI58rFyoln4T1vop1TTfLXdYny3J8HlCL/LHpn4VpTBpxkZ3aJeF8PWiQHPhb03zXOENu9vueW/7uW0b3JZcxmHxDsZ5bsnXXD3jh9L+JXmHmJ63xqiqOympzFqaus0xypK1sUxSkqdTfj7CaIVzy4ZvBV1/fPPO3x9Q7OCrXIMvD0voFeVLeIKwZhY9r7W349ACTUp4S7HzSeztRF+hvZQ88icidGpfy86kQmjugbr9BmIrbH/4TkVHgPQQu1pNqgW9pkACU/s8zABxeIMdZI4lxdhS9SLOQPFtLFbnD1U96leYdUiuO2NWmeMaHBJ6lzMYIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N0W70Yj9T8IoRZPWtGAH4V/S0ErezHe9yxYbOEa8PIaEdG092b8HFMcYoEOq?=
 =?us-ascii?Q?zqLztzTyiGr448QFVCypH0YQ8WXgUrAr3BAl8jnf55tU8ZvTwgItQqIM3sgp?=
 =?us-ascii?Q?oYxNid1ldfeuc1FO6HAxbmAAHzt6+0kl2D59p9i5jD4aA5GXqofEoVDtfqsC?=
 =?us-ascii?Q?SI8swikSk7THXyHoY4WrVP34KgrsXjLD1SiCnIm9iZsrjiXMascnBtGY6PO4?=
 =?us-ascii?Q?lbV+DppshhCa2BlFFgiXZGLlknoGiOz2Xpotj5lgUBCmK9xMRm/Gx+xBiY9E?=
 =?us-ascii?Q?vC44JMvmXGp8MvpSnJCEgFY2DtlEPwhPYIKCbE0wZv5TYKMo0VfFWsZvPNU+?=
 =?us-ascii?Q?n0j7F3uFqEEoW8mIorx/MAjeqYwpgMq468MXGf1HSlUVoCMhnszPBIAxyHpH?=
 =?us-ascii?Q?PyaSw7ECTaUExj0sdrqATCdq7pUr5Bja7Hxqdf1cDBcn0FKv0nbga1lA0B8s?=
 =?us-ascii?Q?9Ew/OHC/5EGbel4sJy1TsDI/ECRHnZ+cnXqnzGuiGP2x80bUe+Ph9Nto0Foj?=
 =?us-ascii?Q?kU0KwULjbpmSyYmr9q6PHABeDlwLEQQOoOlE6ImfYtlkB8coJSrGQJ3rgc0c?=
 =?us-ascii?Q?4547JId1fu8vbbqq2fPy1DZAljqLOehk6exA7gRQW/vemUCewbtwa3yHnWrx?=
 =?us-ascii?Q?QRO799dqB1Af3Ph4uRNCWj2XLKCwB8DCIh7G+8um812JlzG+3IzyVs/C+lPO?=
 =?us-ascii?Q?ukfDrytOjDAEXYCG/SkKAfmnyDcWX1LC6PD+is6kGt/1kAJygPT459EmBEpe?=
 =?us-ascii?Q?x6kNyeI1bj0W3N1s1I34Xt41TpZEbp1ysRuycL8og0c8ydL4FPvMFO8v4Zi+?=
 =?us-ascii?Q?FC3EpPccgu1g0vMAWUbtWJF3Pdfh3svJdS9EvbBemfb5yLjLP7yL/RhKmqkf?=
 =?us-ascii?Q?rfRKPLBIVHDyNoTJwbnuezpn7daY2nbML1MHtHQAo/nSzCS5G63dt5FFYrrx?=
 =?us-ascii?Q?Q5gOO0DQhn9Z4EXBlQnvqfx3GXOXrkeXD70REVNW1HYSZHlatROVYHBUTC/h?=
 =?us-ascii?Q?JwVjRVhx/oLAfh1mhO5ouJK8P9ya0Kpyrbx74qhzoHRvUYZDNhG//Gu0Xf8K?=
 =?us-ascii?Q?3Hw0Fv9jalYXxQeth6/9J8Rpd9jZCAjFvvxv9X2h0oz+0/a9OBlgJI1tfqwh?=
 =?us-ascii?Q?4exUYwrCYJP+UW33a7RvT2rdKHYkqfJlCAcbvO0gWmtC/pySRHkyUJGaVqmQ?=
 =?us-ascii?Q?qJYMng/nzkH137GOP0O2NT1iEeUptB0xDhS69yatj2iJRackJe8vaWnqlhd9?=
 =?us-ascii?Q?s6uDlJKjUdy201rvLOgZmZMGwymO8j3Ir1QVxJjUktMCzyo8k/SPT4y3d/Y5?=
 =?us-ascii?Q?/frMX+7+EdLao6B+ywvoKjFFSk24Kj6mBDMlsCMrp/5ReufjGOM61Y1bvPPD?=
 =?us-ascii?Q?je99H4NDYwhJ/j9kXm0sA19kUgWcG66CrbHlB6Ie5RMtI3m8Z8UgvNxk7gVt?=
 =?us-ascii?Q?ERpfNVGKB6dwOs7e6QK1TIBs1Kf+e0xVdaFusC14eleDe9XDbGHArKerSqjB?=
 =?us-ascii?Q?KpiLS4SllfM9E8ppcD1b00qyiesHcoF4F6Yyc1LD0XlvFdE9hH5cpS0QakOM?=
 =?us-ascii?Q?NkjpMtPshpX+FNsyPdfwmBM94yiq+vDba/8Xb8F8F6iIKXlHgJjXjRKrLvEF?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373e8a42-9f22-4519-bcc7-08dacbc826d6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:13.4507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8Q47DTFejtsID+2mpOAsFLjpZg0c+bLQdap3rlUyMOs/M83oNiJsVmDgyntR1N46CzhKI/Fs2/3mE4WvMUopA==
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

There is no reason that I can see why the no-op tagging protocol should
be registered manually, so make it a module and make all drivers which
have any sort of reference to DSA_TAG_PROTO_NONE select it.

Note that I don't know if ksz_get_tag_protocol() really needs this,
or if it's just the logic which is poorly written. All switches seem to
have their own tagging protocol, and DSA_TAG_PROTO_NONE is just a
fallback that never gets used.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/Kconfig           |  2 ++
 drivers/net/dsa/b53/Kconfig       |  1 +
 drivers/net/dsa/microchip/Kconfig |  1 +
 net/dsa/Kconfig                   |  6 ++++++
 net/dsa/Makefile                  |  1 +
 net/dsa/dsa.c                     | 21 ---------------------
 net/dsa/dsa_priv.h                |  1 -
 net/dsa/tag_none.c                | 30 ++++++++++++++++++++++++++++++
 8 files changed, 41 insertions(+), 22 deletions(-)
 create mode 100644 net/dsa/tag_none.c

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 07507b4820d7..c26755f662c1 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -18,6 +18,7 @@ config NET_DSA_BCM_SF2
 
 config NET_DSA_LOOP
 	tristate "DSA mock-up Ethernet switch chip support"
+	select NET_DSA_TAG_NONE
 	select FIXED_PHY
 	help
 	  This enables support for a fake mock-up switch chip which
@@ -99,6 +100,7 @@ config NET_DSA_SMSC_LAN9303_MDIO
 
 config NET_DSA_VITESSE_VSC73XX
 	tristate
+	select NET_DSA_TAG_NONE
 	select FIXED_PHY
 	select VITESSE_PHY
 	select GPIOLIB
diff --git a/drivers/net/dsa/b53/Kconfig b/drivers/net/dsa/b53/Kconfig
index 90b525160b71..ebaa4a80d544 100644
--- a/drivers/net/dsa/b53/Kconfig
+++ b/drivers/net/dsa/b53/Kconfig
@@ -2,6 +2,7 @@
 menuconfig B53
 	tristate "Broadcom BCM53xx managed switch support"
 	depends on NET_DSA
+	select NET_DSA_TAG_NONE
 	select NET_DSA_TAG_BRCM
 	select NET_DSA_TAG_BRCM_LEGACY
 	select NET_DSA_TAG_BRCM_PREPEND
diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 06b1efdb5e7d..913f83ef013c 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -3,6 +3,7 @@ menuconfig NET_DSA_MICROCHIP_KSZ_COMMON
 	tristate "Microchip KSZ8795/KSZ9477/LAN937x series switch support"
 	depends on NET_DSA
 	select NET_DSA_TAG_KSZ
+	select NET_DSA_TAG_NONE
 	help
 	  This driver adds support for Microchip KSZ9477 series switch and
 	  KSZ8795/KSZ88x3 switch chips.
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 3eef72ce99a4..8e698bea99a3 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -18,6 +18,12 @@ if NET_DSA
 
 # Drivers must select the appropriate tagging format(s)
 
+config NET_DSA_TAG_NONE
+	tristate "No-op tag driver"
+	help
+	  Say Y or M if you want to enable support for switches which don't tag
+	  frames over the CPU port.
+
 config NET_DSA_TAG_AR9331
 	tristate "Tag driver for Atheros AR9331 SoC with built-in switch"
 	help
diff --git a/net/dsa/Makefile b/net/dsa/Makefile
index bf57ef3bce2a..14e05ab64135 100644
--- a/net/dsa/Makefile
+++ b/net/dsa/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_NET_DSA_TAG_HELLCREEK) += tag_hellcreek.o
 obj-$(CONFIG_NET_DSA_TAG_KSZ) += tag_ksz.o
 obj-$(CONFIG_NET_DSA_TAG_LAN9303) += tag_lan9303.o
 obj-$(CONFIG_NET_DSA_TAG_MTK) += tag_mtk.o
+obj-$(CONFIG_NET_DSA_TAG_NONE) += tag_none.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT) += tag_ocelot.o
 obj-$(CONFIG_NET_DSA_TAG_OCELOT_8021Q) += tag_ocelot_8021q.o
 obj-$(CONFIG_NET_DSA_TAG_QCA) += tag_qca.o
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 07158c7560b5..e609d64a2216 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -18,22 +18,6 @@
 static LIST_HEAD(dsa_tag_drivers_list);
 static DEFINE_MUTEX(dsa_tag_drivers_lock);
 
-static struct sk_buff *dsa_slave_notag_xmit(struct sk_buff *skb,
-					    struct net_device *dev)
-{
-	/* Just return the original SKB */
-	return skb;
-}
-
-static const struct dsa_device_ops none_ops = {
-	.name	= "none",
-	.proto	= DSA_TAG_PROTO_NONE,
-	.xmit	= dsa_slave_notag_xmit,
-	.rcv	= NULL,
-};
-
-DSA_TAG_DRIVER(none_ops);
-
 static void dsa_tag_driver_register(struct dsa_tag_driver *dsa_tag_driver,
 				    struct module *owner)
 {
@@ -551,9 +535,6 @@ static int __init dsa_init_module(void)
 
 	dev_add_pack(&dsa_pack_type);
 
-	dsa_tag_driver_register(&DSA_TAG_DRIVER_NAME(none_ops),
-				THIS_MODULE);
-
 	rc = rtnl_link_register(&dsa_link_ops);
 	if (rc)
 		goto netlink_register_fail;
@@ -561,7 +542,6 @@ static int __init dsa_init_module(void)
 	return 0;
 
 netlink_register_fail:
-	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
 	dsa_slave_unregister_notifier();
 	dev_remove_pack(&dsa_pack_type);
 register_notifier_fail:
@@ -574,7 +554,6 @@ module_init(dsa_init_module);
 static void __exit dsa_cleanup_module(void)
 {
 	rtnl_link_unregister(&dsa_link_ops);
-	dsa_tag_driver_unregister(&DSA_TAG_DRIVER_NAME(none_ops));
 
 	dsa_slave_unregister_notifier();
 	dev_remove_pack(&dsa_pack_type);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b60987e8d931..c4ea5fda8f14 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -384,7 +384,6 @@ int dsa_port_change_master(struct dsa_port *dp, struct net_device *master,
 			   struct netlink_ext_ack *extack);
 
 /* slave.c */
-extern const struct dsa_device_ops notag_netdev_ops;
 extern struct notifier_block dsa_slave_switchdev_notifier;
 extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
 
diff --git a/net/dsa/tag_none.c b/net/dsa/tag_none.c
new file mode 100644
index 000000000000..34a13c50d245
--- /dev/null
+++ b/net/dsa/tag_none.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/dsa/tag_none.c - Traffic handling for switches with no tag
+ * Copyright (c) 2008-2009 Marvell Semiconductor
+ * Copyright (c) 2013 Florian Fainelli <florian@openwrt.org>
+ *
+ * WARNING: do not use this for new switches. In case of no hardware
+ * tagging support, look at tag_8021q.c instead.
+ */
+
+#include "dsa_priv.h"
+
+#define NONE_NAME	"none"
+
+static struct sk_buff *dsa_slave_notag_xmit(struct sk_buff *skb,
+					    struct net_device *dev)
+{
+	/* Just return the original SKB */
+	return skb;
+}
+
+static const struct dsa_device_ops none_ops = {
+	.name	= NONE_NAME,
+	.proto	= DSA_TAG_PROTO_NONE,
+	.xmit	= dsa_slave_notag_xmit,
+};
+
+module_dsa_tag_driver(none_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_NONE, NONE_NAME);
+MODULE_LICENSE("GPL");
-- 
2.34.1

