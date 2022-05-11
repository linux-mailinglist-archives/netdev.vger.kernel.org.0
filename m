Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02DB523047
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbiEKKHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240256AbiEKKHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:07:02 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80047.outbound.protection.outlook.com [40.107.8.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC573A708
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 03:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BoLUCBJrNoCK9NqZ55LlIGNQElDImkiNHiYO/4Fk/973sbpmeFcYH4RkW0hx0iOAHEOItyfaeFjmEgcOSrfDiZ1Qjj7oF4bjxoya83o+rtTOuiKTjN02qGLbjflSZHQzH/AHPS9lNfOdg238W/3xNDQt7e5gROzdNpQs0Xt5E8xDpx9LLmjHAIc/JFE03nEhpAFaZN8UlrKGMDcLCjkcDPTbq4SiZ8N925U3qa9AxRyy8fap/xgiUB7QUbgT6uk0pox04h0cGxFuxb7s2dWGjLCYNGuaAiedghprX6w/ws7dMhR4nkPw3ixO4PkbO/JGDC1pJjVpc4MSDTndrZfp4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBLnLMhVp6psizhKjTj2s2tMMA09ClrvPz464OrINDU=;
 b=VeETQfG86Mt154Xm9KOWsPps2xnDbIC9DSe9qcr/Y6xxKb0gv5Y0Vu6luXKOe9rowzPpRMTUrHtcsE7wKKfr7R2NmkBl65RR1aYChYqUQ2Qr2MX8CJMKYEY7+ToRd8vNZDdWnyjx3x7Xy+9Fc2now/9f1a17qgDKfHmu4WMbuxl7VfkvgWQX15gUhPDJVtyMQM8W2NuMRi5Mae/aA7+OAU7/RG1Vh0JEPcGmldAvKEfUl/k0vQ8/YiRZZ/irNTMeGvnkBEJUDItJI3adtIIYomp4yGBDnOlH+UB4oNPaaxOYoH/GYPBfsMpljQvanXRKNp32TFHQTGY3EG5qQ2FdJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBLnLMhVp6psizhKjTj2s2tMMA09ClrvPz464OrINDU=;
 b=lRCXhQT2AjnZdYP0nLrVrpWansnLGHUIZK7alGc3KwDFhvRHofHvCFwyw0E1SI6xxzZPeJpC3ZhSwt+PiD63unZq9and9Ff19NOPE5o3f5jcWjZG2EErl/lrz+Q5mjU/w9V9AVZienN7pTJp8E8M6TaeslrAB+lYmeiGj0H9tQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4501.eurprd04.prod.outlook.com (2603:10a6:20b:23::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Wed, 11 May
 2022 10:06:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 10:06:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 3/3] net: mscc: ocelot: move ocelot_port_private :: chip_port to ocelot_port :: index
Date:   Wed, 11 May 2022 13:06:37 +0300
Message-Id: <20220511100637.568950-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511100637.568950-1-vladimir.oltean@nxp.com>
References: <20220511100637.568950-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0005.eurprd08.prod.outlook.com
 (2603:10a6:803:104::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db30f861-ac58-4fc6-8e33-08da3335f7ce
X-MS-TrafficTypeDiagnostic: AM6PR04MB4501:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB4501CE7BFF8F79A7F0B67D21E0C89@AM6PR04MB4501.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rquIvfhXlRDRt6hpwXV6L9hTFoJYQTBOPCuElGinTIK+JI46GvxXC+9+DdaM0dvTVrgXXSQIMDLgK90UmSCmKvvvjKC0Dqrjx7him06wqERIdkz14Q+1CwUDpLolfmqTBJXT2jnc62SPvLqMpoukEucNgQdqioGzresmad6cUHDJi454jl2cG2/LvF2o8Vx3qoknXdTCon0lCOVATsvaA6OQbMsPFfy/RkPyJlRTwTVoSCzW7S6hUsU/8xh63G4I3fHAaX/nyc5nwtpDWmG/mXRCyk+T3aODHDhh/VaFW9rsgoEYuSMw4l1nZ/tvsyICilHzz2d7YZ+E/hKWNYwQqIKIgijFNYTa4I+0jfpwGNa54u1YYr/JN+bcbYBZeM9qH634Tz3da5gwXCPq+JIqV6C64b/d9TnD333qfM0kTktuBRqUhe1BaTuvNuCpFRoHXgawXgMKzMn34IWo4PlyUYvU72Aq0gd3ium56wCvyy59W09JGR5htlF9Nb8DPEeisj+q4xMVclsnphMZ4g2DtoWV1dn4fjICUGvfiZoNnOazZNr8XhEW8xWLAmp4A42zcgCLRBKab2J05QTs/O4NYu9xsRX/Iu4bW7r9rPgAb+ZIyD3Ut43+aX94w0ipxj2qjFPJ8W5yxEuLjKRoJkbO6GNBONAgXZxPGcu6Y74x5g5ppdXQO1Hyz3wkoRKo0fc6KPtj8P3WnCbqVlIO+wjEdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38100700002)(1076003)(508600001)(38350700002)(83380400001)(6916009)(54906003)(316002)(186003)(7416002)(36756003)(52116002)(4326008)(6666004)(6506007)(8676002)(6512007)(2906002)(66556008)(66476007)(44832011)(26005)(2616005)(30864003)(66946007)(5660300002)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XAaqXRhobb22arAyniUEd95k+nZdp/Kg7u7nnMUBdZQk1FbcLwBZKDM4oZlH?=
 =?us-ascii?Q?yg6UF3ySeOA1pbgrb6DCgjoTrWBuWPLAqbm7an+N8pGaj33KRtRkT9Gb2eRh?=
 =?us-ascii?Q?dPkI3+CjtLRwsfBKP5MUPkLL+AWMn1E4JFdMF2ItG88zIb0PsLcOpi6qYsDz?=
 =?us-ascii?Q?NLFINUEq9O/ShWXkvKxqVJUTOb31l74ULALRgqV3U5oLD5Ujf5/sHTirdEuE?=
 =?us-ascii?Q?0giRu0yKOQ5Oe9DNpEq4T3oRGQyVexiCiHQeZOQahiuVws/3E2sOQvQmskQw?=
 =?us-ascii?Q?V84hL5LDNp9Mk6U9a/HxHmD9AmXEtW+g8lxmcUPp6vzZQNkWhtDlpUf+6xuz?=
 =?us-ascii?Q?Y88KoEDi/S6MVcR5rWHXDiS1mYQFZbwk2DsGOI+qY268uUDzOthZhaI6E+LC?=
 =?us-ascii?Q?7YcRL2mXqwgTGZK4AlWemK6HjXTtH2ZzGLu9JPEZBC88eBCzZlx4/FGGpdTZ?=
 =?us-ascii?Q?JS0XJpgoKfQmA0o6mxXD1nDRL/vJ5KP+1+7POU6OOrWlmvjaAc6nDlgCi6zf?=
 =?us-ascii?Q?QARaVcPRbcL32edUPnQnUdAlwNuip5P4k0w1mYINTeBZ8gpF/fyrbJkxsiGo?=
 =?us-ascii?Q?+4dIPWxlin3iF1QIE9rrRQgXpJeueTdDpxjN/CkoIp/KzFzQKJ/V1tsRv/fb?=
 =?us-ascii?Q?E0hw+snA2ecsrn8jmJAg1hFnPYI3jLFznNfwFwnx0z1RBVrPIRgTLJBblPv1?=
 =?us-ascii?Q?Z4GcnTwFxGh4S60zBsnPzJtRioZa5FM5ZpRQ4mhZJLB5R8NilyBiEDx3bvrf?=
 =?us-ascii?Q?K6L2PNwUD92s6x6V+GPy4RDNqopWoyE+ZKzOxpJ3LORJe3F2lYQqq3tyS2nJ?=
 =?us-ascii?Q?NcE5WvLwBxfisucFFAiIhYcogep1s7eCp6iPtpFRsuOFTA2YF/IdvZWAn20T?=
 =?us-ascii?Q?srrmzMIDct7IV905rX6t6r9VsEx3SFKR21+zWIduo+Je0LOolBZTmTVnshv7?=
 =?us-ascii?Q?onrb78o2odmaLy24BhQsPo+pzvYDjU/gBCuuWYq7hFBITv5D0hreasQjTZu3?=
 =?us-ascii?Q?1UF7p2lH1N7RUGqdsoFzt61ldYVdyx3UOkLA/qv32zwQKHRecfIn1EGB5Qff?=
 =?us-ascii?Q?Pa6qROhhGyfFXQ8LJJWSN9BWLkV6djP2kRPQeQIDKRA5SCgSXEM0SMb160UI?=
 =?us-ascii?Q?zHC8BVskrUlW92J1v9Lflbd6hCwZaE9VnO4X0aRr2J2G67I70TMcbZ/0qIiA?=
 =?us-ascii?Q?N/jOzGfiOddT5JTE6ULwxayT2jxeHfT61Lvo7TmsdQ4R4Ny4f/bnSQ5DVQhz?=
 =?us-ascii?Q?M4hM06R+66kZp64n77tcvAw0fCyK6Ac05igbtUoFRxM7AD9vtuCm+HI8TX0T?=
 =?us-ascii?Q?Oi/SzfQQl+BBKL9OdEM2I0zfL/jQuWlIFkAiDHkfNtW7IzbN6Q8p6EjzkzDV?=
 =?us-ascii?Q?aAg3UX/fgzJ1lKmf7R7Uywq5xO648U/Uc8z/+YORAyWFOTZ31RyR5DTRxQvf?=
 =?us-ascii?Q?olnMesHEt7bH1XNODSJC6d3Xv7x8dwvWX7J0JkcBAXBcD889FYLny9W3AZDJ?=
 =?us-ascii?Q?F1JQUIaow5rhCJTxASnjHYi5gPVY7sLztdJpZxk5U5SfErt0fheC/InuSACI?=
 =?us-ascii?Q?p1/2Qp9zb6+V2J/JH9E5qtDGob76Rl5a4fTyZVfylw/9k3zS02NfMqYr0ijZ?=
 =?us-ascii?Q?WcHZOhdKHyV9ohr1wqK+xqG/+LuCn7E+n6lvIHPdlZoLAUUylUa9ZrwFFAFO?=
 =?us-ascii?Q?TdEkgazV0wTq6680cELX3DwL5i386p+9/SmnUvSVWwLCmQUjlEbMOQgKG8wG?=
 =?us-ascii?Q?1U2Q/6vpzMlLH6Da9Df9KVFxlzX7Hq0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db30f861-ac58-4fc6-8e33-08da3335f7ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 10:06:51.1857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KV+ji6f8gIFJz8jhTG1ospKUYDuTllLmDZ0tL/Iym6/eULKnm4Nt802go8B6E0C9bzJuaQ1O99nhbzUxqMq29w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4501
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the ocelot switch lib is unaware of the index of a struct
ocelot_port, since that is kept in the encapsulating structures of outer
drivers (struct dsa_port :: index, struct ocelot_port_private :: chip_port).

With the upcoming increase in complexity associated with assigning DSA
tag_8021q CPU ports to certain user ports, it becomes necessary for the
switch lib to be able to retrieve the index of a certain ocelot_port.

Therefore, introduce a new u8 to ocelot_port (same size as the chip_port
used by the ocelot switchdev driver) and rework the existing code to
populate and use it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  1 +
 drivers/net/ethernet/mscc/ocelot.h     |  1 -
 drivers/net/ethernet/mscc/ocelot_net.c | 76 +++++++++++++-------------
 include/soc/mscc/ocelot.h              |  2 +
 4 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index beac90bc642c..d38258a39d07 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1249,6 +1249,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		ocelot_port->phy_mode = port_phy_modes[port];
 		ocelot_port->ocelot = ocelot;
 		ocelot_port->target = target;
+		ocelot_port->index = port;
 		ocelot->ports[port] = ocelot_port;
 	}
 
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index d0fa8ab6cc81..6d65cc87d757 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -48,7 +48,6 @@ struct ocelot_port_private {
 	struct net_device *dev;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
-	u8 chip_port;
 	struct ocelot_port_tc tc;
 };
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 616d8127ef51..be168a372498 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -191,7 +191,7 @@ static struct devlink_port *ocelot_get_devlink_port(struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return &ocelot->devlink_ports[port];
 }
@@ -201,7 +201,7 @@ int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       bool ingress)
 {
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	if (!ingress)
 		return -EOPNOTSUPP;
@@ -226,7 +226,7 @@ static int ocelot_setup_tc_cls_matchall_police(struct ocelot_port_private *priv,
 	struct flow_action_entry *action = &f->rule->action.entries[0];
 	struct ocelot *ocelot = priv->port.ocelot;
 	struct ocelot_policer pol = { 0 };
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int err;
 
 	if (!ingress) {
@@ -288,8 +288,8 @@ static int ocelot_setup_tc_cls_matchall_mirred(struct ocelot_port_private *priv,
 
 	other_priv = netdev_priv(a->dev);
 
-	err = ocelot_port_mirror_add(ocelot, priv->chip_port,
-				     other_priv->chip_port, ingress, extack);
+	err = ocelot_port_mirror_add(ocelot, priv->port.index,
+				     other_priv->port.index, ingress, extack);
 	if (err)
 		return err;
 
@@ -306,7 +306,7 @@ static int ocelot_del_tc_cls_matchall_police(struct ocelot_port_private *priv,
 					     struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int err;
 
 	err = ocelot_port_policer_del(ocelot, port);
@@ -327,7 +327,7 @@ static int ocelot_del_tc_cls_matchall_mirred(struct ocelot_port_private *priv,
 					     struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	ocelot_port_mirror_del(ocelot, port, ingress);
 
@@ -497,7 +497,7 @@ static int ocelot_vlan_vid_add(struct net_device *dev, u16 vid, bool pvid,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int ret;
 
 	ret = ocelot_vlan_add(ocelot, port, vid, pvid, untagged);
@@ -515,7 +515,7 @@ static int ocelot_vlan_vid_del(struct net_device *dev, u16 vid)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int ret;
 
 	/* 8021q removes VID 0 on module unload for all interfaces
@@ -558,7 +558,7 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	u32 rew_op = 0;
 
 	if (!static_branch_unlikely(&ocelot_fdma_enabled) &&
@@ -724,7 +724,7 @@ static void ocelot_get_stats64(struct net_device *dev,
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	/* Configure the port to read the stats from */
 	ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port),
@@ -767,7 +767,7 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_fdb_add(ocelot, port, addr, vid, ocelot_port->bridge);
 }
@@ -780,7 +780,7 @@ static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_fdb_del(ocelot, port, addr, vid, ocelot_port->bridge);
 }
@@ -798,7 +798,7 @@ static int ocelot_port_fdb_dump(struct sk_buff *skb,
 		.cb = cb,
 		.idx = *idx,
 	};
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int ret;
 
 	ret = ocelot_fdb_dump(ocelot, port, ocelot_port_fdb_do_dump, &dump);
@@ -840,7 +840,7 @@ static int ocelot_set_features(struct net_device *dev,
 	netdev_features_t changed = dev->features ^ features;
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
 	    priv->tc.offload_cnt) {
@@ -859,7 +859,7 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	/* If the attached PHY device isn't capable of timestamping operations,
 	 * use our own (when possible).
@@ -882,7 +882,7 @@ static int ocelot_change_mtu(struct net_device *dev, int new_mtu)
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 
-	ocelot_port_set_maxlen(ocelot, priv->chip_port, new_mtu);
+	ocelot_port_set_maxlen(ocelot, priv->port.index, new_mtu);
 	WRITE_ONCE(dev->mtu, new_mtu);
 
 	return 0;
@@ -935,7 +935,7 @@ int ocelot_netdev_to_port(struct net_device *dev)
 
 	priv = netdev_priv(dev);
 
-	return priv->chip_port;
+	return priv->port.index;
 }
 
 static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
@@ -943,7 +943,7 @@ static void ocelot_port_get_strings(struct net_device *netdev, u32 sset,
 {
 	struct ocelot_port_private *priv = netdev_priv(netdev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	ocelot_get_strings(ocelot, port, sset, data);
 }
@@ -954,7 +954,7 @@ static void ocelot_port_get_ethtool_stats(struct net_device *dev,
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	ocelot_get_ethtool_stats(ocelot, port, data);
 }
@@ -963,7 +963,7 @@ static int ocelot_port_get_sset_count(struct net_device *dev, int sset)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_get_sset_count(ocelot, port, sset);
 }
@@ -973,7 +973,7 @@ static int ocelot_port_get_ts_info(struct net_device *dev,
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	if (!ocelot->ptp)
 		return ethtool_op_get_ts_info(dev, info);
@@ -1025,7 +1025,7 @@ static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int err = 0;
 
 	if (ctx && ctx != priv)
@@ -1066,7 +1066,7 @@ static int ocelot_vlan_vid_prepare(struct net_device *dev, u16 vid, bool pvid,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_vlan_prepare(ocelot, port, vid, pvid, untagged, extack);
 }
@@ -1092,7 +1092,7 @@ static int ocelot_port_obj_add_mdb(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_port_mdb_add(ocelot, port, mdb, ocelot_port->bridge);
 }
@@ -1103,7 +1103,7 @@ static int ocelot_port_obj_del_mdb(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_port_mdb_del(ocelot, port, mdb, ocelot_port->bridge);
 }
@@ -1114,7 +1114,7 @@ static int ocelot_port_obj_mrp_add(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_mrp_add(ocelot, port, mrp);
 }
@@ -1125,7 +1125,7 @@ static int ocelot_port_obj_mrp_del(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_mrp_del(ocelot, port, mrp);
 }
@@ -1137,7 +1137,7 @@ ocelot_port_obj_mrp_add_ring_role(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_mrp_add_ring_role(ocelot, port, mrp);
 }
@@ -1149,7 +1149,7 @@ ocelot_port_obj_mrp_del_ring_role(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	return ocelot_mrp_del_ring_role(ocelot, port, mrp);
 }
@@ -1314,7 +1314,7 @@ static int ocelot_netdevice_bridge_join(struct net_device *dev,
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int bridge_num, err;
 
 	bridge_num = ocelot_bridge_num_get(ocelot, bridge);
@@ -1366,7 +1366,7 @@ static int ocelot_netdevice_bridge_leave(struct net_device *dev,
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	int bridge_num = ocelot_port->bridge_num;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int err;
 
 	err = ocelot_switchdev_unsync(ocelot, port);
@@ -1388,7 +1388,7 @@ static int ocelot_netdevice_lag_join(struct net_device *dev,
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct net_device *bridge_dev;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 	int err;
 
 	err = ocelot_port_lag_join(ocelot, port, bond, info);
@@ -1431,7 +1431,7 @@ static int ocelot_netdevice_lag_leave(struct net_device *dev,
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
 	struct net_device *bridge_dev;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	ocelot_port_lag_leave(ocelot, port, bond);
 
@@ -1545,7 +1545,7 @@ ocelot_netdevice_changelowerstate(struct net_device *dev,
 	bool is_active = info->link_up && info->tx_enabled;
 	struct ocelot_port *ocelot_port = &priv->port;
 	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	if (!ocelot_port->bond)
 		return NOTIFY_DONE;
@@ -1693,7 +1693,7 @@ static void vsc7514_phylink_mac_link_down(struct phylink_config *config,
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct ocelot_port_private *priv = netdev_priv(ndev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	ocelot_phylink_mac_link_down(ocelot, port, link_an_mode, interface,
 				     OCELOT_MAC_QUIRKS);
@@ -1709,7 +1709,7 @@ static void vsc7514_phylink_mac_link_up(struct phylink_config *config,
 	struct net_device *ndev = to_net_dev(config->dev);
 	struct ocelot_port_private *priv = netdev_priv(ndev);
 	struct ocelot *ocelot = priv->port.ocelot;
-	int port = priv->chip_port;
+	int port = priv->port.index;
 
 	ocelot_phylink_mac_link_up(ocelot, port, phydev, link_an_mode,
 				   interface, speed, duplex,
@@ -1823,9 +1823,9 @@ int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 	SET_NETDEV_DEV(dev, ocelot->dev);
 	priv = netdev_priv(dev);
 	priv->dev = dev;
-	priv->chip_port = port;
 	ocelot_port = &priv->port;
 	ocelot_port->ocelot = ocelot;
+	ocelot_port->index = port;
 	ocelot_port->target = target;
 	ocelot->ports[port] = ocelot_port;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 904c15ca145e..3b8c5a54fb00 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -675,6 +675,8 @@ struct ocelot_port {
 	u8				ptp_cmd;
 	u8				ts_id;
 
+	u8				index;
+
 	u8				stp_state;
 	bool				vlan_aware;
 	bool				is_dsa_8021q_cpu;
-- 
2.25.1

