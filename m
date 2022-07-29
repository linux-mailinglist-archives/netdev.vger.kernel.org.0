Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23CA5850C9
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236538AbiG2NVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236413AbiG2NVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:21:47 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70072.outbound.protection.outlook.com [40.107.7.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8B76248C
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 06:21:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G7ReJNJLPkRS6Hn6kNPoAllblVCMZW8j0gtOQey0fw+dkxvylc96wk770v4+G64+YzpUMgp83XaL49X76bF3OBQDe0/A1fNa6jh8sKaYHDPav2kXF1LC3QpNtjExWT2tBsa/2pPfnKuwphS0kmml8q47vShf78U6QMwm/qFq6Tt8mLwg/5LsTWyBxkADaw6lluF311uwpLMr7M0dLU390S6s1CECERpng37+fzc0lRiIbxFzl1filk1MXQv4GUE5f5K3vPGP/v7z3hRxF0LmNbd7GsJfZvl//tKrn/3ctnsU/SfYABADFo2w/sXeJpNNiuLAXne6mM8suUD1Ac1fUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eTcXLyFtQITQNGLuAAQ7HJZpOzCX/EqzBHwLozjD0vs=;
 b=TcsWAfDzJohsQb3ix6ajv+dqqoor8nVvTV5pqx2qhJX/h7AtRwveBlxjP1uk67gWq1WdcquyvdWPjnI+08nMu50C/vGdouoq3NJbROdeNipEFaGNqlM6Fe81ADDhVe1F8vU8xniA+robsoete1wH3h42YLmynVP4CDwADtN0SOU5UmdxStR4YUHzLx6o7OUyMhrxascCS47HRyQo/lUURhg4EOIkIu7RmM8/7HLWlKLUTKvI+6cWt4tU557FyidELGQ8KvDO84MPJi4G3s+vX+qRTW5eYV9XJ37HuhdhUE20T4VbJpkxq31W1A35nUYXcsVVkYwrtIIOB3KG21gHXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eTcXLyFtQITQNGLuAAQ7HJZpOzCX/EqzBHwLozjD0vs=;
 b=WelZnqqjLl30ITaN558QbkJSe5bmNlCJvumBXfW5iG5IKQGxPLPO6nZeo/wLzcSzCusR1AyspvEOrSGOhXb7pSaiputr7JCu4SVdgpdBVhsCBxf5jYmdJSD+kJuPXde0LJQswEtcMR1veixar0wZocyX8ozBmBKMK3Vv/5WZjYE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBBPR04MB7497.eurprd04.prod.outlook.com (2603:10a6:10:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 13:21:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 13:21:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>
Subject: [PATCH v2 net-next 3/4] net: dsa: rename dsa_port_link_{,un}register_of
Date:   Fri, 29 Jul 2022 16:21:18 +0300
Message-Id: <20220729132119.1191227-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P251CA0022.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9331de6b-a9d6-47e6-6608-08da716547e8
X-MS-TrafficTypeDiagnostic: DBBPR04MB7497:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+nEq27NyL7iklV4UahK3+qNDu1dPlirG+SoK21LnM8sysL7XSRUIxNFIxRuORifOeFZ+564onHR3jvAXROvAwkCfhHMquLNDs/LFNJETpavo7Dl4g2MN4BeTKRvtkqJSnpTGpzK6R3wJvXOFrLZtQQDNRH0v6dn1cKCn53/Y25j5AFMqoMS0ijnShLjX4hOn/maLBj7lJSydW9UMBUvYR9bAM60P51qI7F4RRUqiB2sPi0dhjlkg9iXEy3iSzF7K7E+3r3LTyfWbufTpRrlL8LETXVYTtwCtqcrcG39LXDCqoiYKQNlDQy76xZIubmNWe/vGLncX90UACPjM9CrVILvLLuqbT9DuHpGz6jJCEXTt1HqLEPwUxbkk6iEOOMiveNRU9r9SZTcu356wcvM8fLhO8kCUascC6YVzuOB3TNnHSKNhIiiPR1yBQY3YKHpViuePmwldoygJjog4+KoxnncGDgfqmHwtq2Xq4w1IL2mpyIqR1+OIlybougDh+5OpZn9V11s1j+PM4LjlcbQjxrvBEnSWzb0m5gdVCaD69pDJsbZqpbp5hlF45st4msfcWFdz7aN00K/v8VwNGGyzUJ4KGjOlLRjGAkzpE6gbzRICbjCjrA75TLvRcMOn5K7x7E6jBaRkJfJB07eIp+C6sVmM10qohfQG14Y4YjA+G17RFj/YqE8VPIo2SRjpcZLYzVrnR7c6PBTPlgMuW4mfiFXdOj5x/xapZJTWsqzhtqEuNgTKD8JBwo+FS8RibWlY+jATRwtzQczzQncpO17qnFPREZJzy+DI5HyDQzTetQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(1076003)(6486002)(2616005)(478600001)(52116002)(6512007)(6506007)(26005)(38350700002)(186003)(38100700002)(41300700001)(83380400001)(7406005)(66476007)(5660300002)(4326008)(66556008)(8936002)(66946007)(7416002)(36756003)(44832011)(6666004)(8676002)(54906003)(6916009)(316002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kppKCdN8JBj49d0dJrfWITPALcP9IzgSv0D7dcZuWWDgLwXpGiq6LwlPoLO1?=
 =?us-ascii?Q?qS05Kibnvd6DXNc3n4FEEnXJld5GcFXzUorJNE1kQ76HpiKFyeqoLJhUBdbL?=
 =?us-ascii?Q?G0n2Sb3pOect1jqN37Vfstr4nTzr1WKn1ujSNCHDEeTyNK8usDRgTQGC1q7+?=
 =?us-ascii?Q?Jj3pHH8z9ZZebgYmqYCdBIVKV00PWehN64lbjWZmzx6JokLrINFhvgELDfbs?=
 =?us-ascii?Q?4Qn1cVvTGn5dLsZ46F25oJgID5IQtTf9hIMwu7ZOQ2Rx258zvPdjvLRQ3WR8?=
 =?us-ascii?Q?498jlgL1uxb5qM0S3MAcDJ+i0XJtiosXyrow70yAH6I0oIB5WEANFRJ5GTqv?=
 =?us-ascii?Q?7nwAd05DT28HNQbkrRx7pEzylZwgbo5axuh3XDYf4Glk8eDDTFXroZPiJQA8?=
 =?us-ascii?Q?V+fipvmY9j3wLJZbDfsDL7WqamwGY8E12j92JrwP34rLr6v3nREdBHeb5x/S?=
 =?us-ascii?Q?EEKBq0+piJjqmG0nQgB1wnkrirL+xlLFWpeWhq5+jCfWdoITG03ytjdft3yL?=
 =?us-ascii?Q?ETzMtYblzuRDZFleJCwuWliDfFOn81Ea7s6wAceTAgytiSXa6mjUqPtFaQ32?=
 =?us-ascii?Q?iJblJzP78WDbBIMRshtYvQbLLi1Cm2VKAJ5ceB/McbsTGJ4Sd7tLy+x+ujIo?=
 =?us-ascii?Q?ujOO4mvPQB3YjpPc+IQO5CvXFU37uH9PDLz+RKZSjNqmGGDknmFr03McbGW9?=
 =?us-ascii?Q?/ehy5h2D4C+655EDGJUjeoGa3J/6xG1YVDTr77r8M3xHMM7qH3465ri8kXjS?=
 =?us-ascii?Q?hhn2PposrWdFEwZQ1FtoYJdBpbq0rk37ttzEe7cdxHDdDMwi/UgEycyku7g5?=
 =?us-ascii?Q?vLvfKM9ux4BCjWJpRNu18biQEWC+oaUTSoMcNYKFR7tM1GvczNzeLh/dY66D?=
 =?us-ascii?Q?GfQFcmDcvtK9y4WUoxR/oKcJKbYgz0zT4E217INFOG5lI7Xv64+1+BG8gOZc?=
 =?us-ascii?Q?gnuI/4UbtFK53vHfukBZqiUz29B75VaxgkcYx5iy/Zflcara8tJnDgWX7B/G?=
 =?us-ascii?Q?ZTG7hNUD84ycsMhFkhauW0XlhNnzJ8eonQQ7KTdBF2v+13K7/RIjIhcbdLp3?=
 =?us-ascii?Q?G52kY8BgQSruYJ1nNl6WeSN8Ajri8M6XhRW7lPjv/8daCO42Eibw08N01PyW?=
 =?us-ascii?Q?LKWtlEf9DNB5ShyIBGubb9cjs3JLsWCxEJ2QBG+8PwYz/xM+tMqjDJPkbGY2?=
 =?us-ascii?Q?c85gPxOKOsi0SCf0ZUnIktBnd4FxxHGjC6K909z8i3jQ+VId58wKvZAw0FxE?=
 =?us-ascii?Q?FFwWmuu86gAHzLIvFoZ9lGSOngOahRbBrqh9RqSlekbXkqBRr/IM7SBMhQgp?=
 =?us-ascii?Q?E0Sfiu7l2P/2L/O59UzXMNt/e3SPY3BQ39r3N4rLsFWiDdbEZ/Dwnm8CnbSW?=
 =?us-ascii?Q?HYVE3IJSG86KoWTXZNhejOTpJlkxr86yQXtfO80o8IvRhYfDSqCFoIHHGJ9p?=
 =?us-ascii?Q?767ZHVtIN2O/gMHj+J9e703Lt6+6MY4ak2jyQ64W8n45pVk/42XvU6W/NwwT?=
 =?us-ascii?Q?jKwfLruXBWyyVzHjuONhhF4CJmMcBNR0nN/weB2i/EbU5PWnGJugIy0rLSSy?=
 =?us-ascii?Q?yP/97ySKcLgcBK9IfO6841lr+AFEvQCy28WlmCXXkuOsd5jNV5Hhc/nWvNdK?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9331de6b-a9d6-47e6-6608-08da716547e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 13:21:43.9801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxOzGghK5elTD5CaSUANpueYEe/r0grfEr2V/MZLWknxljM5soFtkvDRUu9ygvvinISFMU2KDUeWw0QrYRaSPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a subset of functions that applies only to shared (DSA and CPU)
ports, yet this is difficult to comprehend by looking at their code alone.
These are dsa_port_link_register_of(), dsa_port_link_unregister_of(),
and the functions that only these 2 call.

Rename this class of functions to dsa_shared_port_* to make this fact
more evident, even if this goes against the apparent convention that
function names in port.c must start with dsa_port_.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 net/dsa/dsa2.c     | 10 +++++-----
 net/dsa/dsa_priv.h |  4 ++--
 net/dsa/port.c     | 18 +++++++++---------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 12479707bf96..055a6d1d4372 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -470,7 +470,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		if (dp->dn) {
-			err = dsa_port_link_register_of(dp);
+			err = dsa_shared_port_link_register_of(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -488,7 +488,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_DSA:
 		if (dp->dn) {
-			err = dsa_port_link_register_of(dp);
+			err = dsa_shared_port_link_register_of(dp);
 			if (err)
 				break;
 			dsa_port_link_registered = true;
@@ -517,7 +517,7 @@ static int dsa_port_setup(struct dsa_port *dp)
 	if (err && dsa_port_enabled)
 		dsa_port_disable(dp);
 	if (err && dsa_port_link_registered)
-		dsa_port_link_unregister_of(dp);
+		dsa_shared_port_link_unregister_of(dp);
 	if (err) {
 		if (ds->ops->port_teardown)
 			ds->ops->port_teardown(ds, dp->index);
@@ -590,12 +590,12 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
 		if (dp->dn)
-			dsa_port_link_unregister_of(dp);
+			dsa_shared_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
 		if (dp->dn)
-			dsa_port_link_unregister_of(dp);
+			dsa_shared_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..8924366467e0 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -285,8 +285,8 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
-int dsa_port_link_register_of(struct dsa_port *dp);
-void dsa_port_link_unregister_of(struct dsa_port *dp);
+int dsa_shared_port_link_register_of(struct dsa_port *dp);
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp);
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr);
 void dsa_port_hsr_leave(struct dsa_port *dp, struct net_device *hsr);
 int dsa_port_tag_8021q_vlan_add(struct dsa_port *dp, u16 vid, bool broadcast);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 2dd76eb1621c..4b6139bff217 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1552,7 +1552,7 @@ int dsa_port_phylink_create(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
+static int dsa_shared_port_setup_phy_of(struct dsa_port *dp, bool enable)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct phy_device *phydev;
@@ -1590,7 +1590,7 @@ static int dsa_port_setup_phy_of(struct dsa_port *dp, bool enable)
 	return err;
 }
 
-static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
+static int dsa_shared_port_fixed_link_register_of(struct dsa_port *dp)
 {
 	struct device_node *dn = dp->dn;
 	struct dsa_switch *ds = dp->ds;
@@ -1624,7 +1624,7 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	return 0;
 }
 
-static int dsa_port_phylink_register(struct dsa_port *dp)
+static int dsa_shared_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
@@ -1650,7 +1650,7 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	return err;
 }
 
-int dsa_port_link_register_of(struct dsa_port *dp)
+int dsa_shared_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *phy_np;
@@ -1663,7 +1663,7 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 				ds->ops->phylink_mac_link_down(ds, port,
 					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
 			of_node_put(phy_np);
-			return dsa_port_phylink_register(dp);
+			return dsa_shared_port_phylink_register(dp);
 		}
 		of_node_put(phy_np);
 		return 0;
@@ -1673,12 +1673,12 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
 
 	if (of_phy_is_fixed_link(dp->dn))
-		return dsa_port_fixed_link_register_of(dp);
+		return dsa_shared_port_fixed_link_register_of(dp);
 	else
-		return dsa_port_setup_phy_of(dp, true);
+		return dsa_shared_port_setup_phy_of(dp, true);
 }
 
-void dsa_port_link_unregister_of(struct dsa_port *dp)
+void dsa_shared_port_link_unregister_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 
@@ -1694,7 +1694,7 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 	if (of_phy_is_fixed_link(dp->dn))
 		of_phy_deregister_fixed_link(dp->dn);
 	else
-		dsa_port_setup_phy_of(dp, false);
+		dsa_shared_port_setup_phy_of(dp, false);
 }
 
 int dsa_port_hsr_join(struct dsa_port *dp, struct net_device *hsr)
-- 
2.34.1

