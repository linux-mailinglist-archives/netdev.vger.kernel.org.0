Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD826286A1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238166AbiKNRIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiKNRH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:07:58 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2062.outbound.protection.outlook.com [40.107.20.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B57E2D761
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:07:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1LbzWWcjxBchA0twMi0X5P7inF4Ij/FWsC+ds1bn5QtHmF7OotZJkrBtR6WDwB6820TwnqF3EURBKN+mYAwnd74qEfpAvDUgWqdmOt0oh1k994X/nE/bDeITV92SthYrqQVqWhO8n/E+IdPqY4rb3dx0efeyzoRW7qYvxdt9uIMK235egilsalpwfofOvcsSAos8qKd8piAZVvyPbWYgD1drNL6b12YRkv9w5h4DmGcyBgpmxXA91bEpuqLyZG4JDJOYvEA18+fll7DaTSCwqQLY9v+rJvv1RKIXvVbqYcdymXdqUsj7xiXcy2tjOQHjR6cgrSPfkWCTlRVCuJw7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=owzbNc67cg+BF6fEY1zRDTksHVwdrJ7EJtJXD9nlpYg=;
 b=Cn14JOsZ1UF4gCvoeAWRnxDtYXPdS2bt5YeWVGIJ3ZqYEYDWEBbvhaElGphgEGgMvx4xjhw89lpFmwNhmBe5jJc8PIZJyeJZor/jSEHpCxugenq7Ag9UR7wewa/np6ofL8BEFWEcIzEquEACmmzhcmGs5c/jX/zAZjy1u17kLRkS4fyglYDmnK6AZSJskJiUEtR6T+YuiFTFQiUoD/gccsRnWbnXNLJZ44O+8MCBLt4GmjSAhSwJjHEte592nNbUtJxRueiKSuVJovJPoxhGDJmqAq4kFg4Pdxl1wFBGU9m26iCup5qmhJGxB66fKm0ApWO6yyq3WENBN9hnwMafRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=owzbNc67cg+BF6fEY1zRDTksHVwdrJ7EJtJXD9nlpYg=;
 b=E+gxULdBQdpZDv0p75mpRZVWT6M7N7YZ5Mj/4qx7dTamUvPXNFqtMULFJ5nKOBEORMTC/eVSPXLbeDOWu3ZVEjCiJEou/cKusRLUPvjs55CBPrPttyt2a1js8Iaxdge+hohis6nxlXnF9fuNtQc8WClOvmO3p7DpW3yAy5mJu6g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9280.eurprd04.prod.outlook.com (2603:10a6:102:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 17:07:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 17:07:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2 net-next 2/4] net: dsa: felix: use phylink_generic_validate()
Date:   Mon, 14 Nov 2022 19:07:28 +0200
Message-Id: <20221114170730.2189282-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
References: <20221114170730.2189282-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P191CA0007.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 61492044-c3b0-48ca-e449-08dac662c53a
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UHJWfu6t2dy14qVgGDM7CuDYHRJgiMippexgnnRO5HLyk7oBcr5O9pXx2I5YgcIk68MD8TuvtajkdarxAgSUfycu6HBy09hp4yS9mk4OfYrNjbmntGwGLw5WB13XYx66ds4Tih+B24eGLxnxWt/Swf3CxHhroKjbbP/fziPbPN3EqEY8TxYQ2ZFC/p+F/779VxEReJhUf2L2hDKKGRVnZIg2+Xp4jXlqdyMuCG22CPRwzXodCEFVad8SCQtkFClcOI/O5cRtanIJgJGGyXxFcYttIdEmxaiolzsUldHU4dPeLY7ae3aiZe5LhYMq/IwYfBQvhCS34lcjNt4rSs3l9OT5a3CBsypHrijvnpWuuCVXMaQ1zHszjpgEoqCDrGOBq6dgfkzgDBuDE0k+On8BwohrRXRp9Mm0Y4lRF2Og1Scjh3+ewU8VgM9Bqq/Kuu7SKxfQvI9Uuyy2wTGmV7CrsPi7YgyXOnHzdZVRg+gGEAurMWla5Bt1RzsQuqXe6g1d6KYG3mN5vYZ0v6RjXsBTl/JdnNUw2u/H1mjtnxBLLZSVPeyahJnpdG9nOrEzcLyzAseUHZId0E+W0FN/WrN8Z7vKipnAnIKruVB8FHShFkwqUYdfHbmf1W64Y8JP39oHllJSCEMWe3QMPp/mmnMdQARaaGbBnA44PFe1mDl115RzB1UCH+tUPTgx7uyDzGh812ZUF1g8xqJCuEqzKi9cX82PY0AhOW1Mi3WZna+epNXkhJzFRmIY1vuZrA0Y3QBpO6Py1ao1GbFkbCQpUqO4BESE5lbyA6fZkur1zswupNY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(451199015)(44832011)(36756003)(7416002)(6512007)(5660300002)(26005)(1076003)(6506007)(6666004)(2616005)(86362001)(8936002)(52116002)(478600001)(6486002)(83380400001)(2906002)(186003)(316002)(66946007)(66556008)(41300700001)(66476007)(6916009)(8676002)(4326008)(54906003)(38100700002)(38350700002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DeN/4UWy9BqHX4X4cCEHWphRxxrDGozb/aoJ8TcpxCPeQH/xV2XtqRKhDkpT?=
 =?us-ascii?Q?juQfB/i6Dd6xOTaMaKetuF59E9jT2hnco2S3aJNiwSuOIwRLkK3C4Pj6p4Pc?=
 =?us-ascii?Q?L50Ma6kDSPPPBYPesGN403MTdvxLyu5EktSYnKzl0vmfglbzUwspROvUvdOk?=
 =?us-ascii?Q?gF0S5JEv7VaizIgS0X4pCtfJ5JDgXhxquNZV3gtNtGbZB92y9BcI443gErcr?=
 =?us-ascii?Q?7g8xs9JtZizlBPvVA3Q2FwTPI99CJihOPAaeiwm5erJvMruSS5l+FYxQsvOT?=
 =?us-ascii?Q?PXXqUu/foJ2NMfiDE39VKd3nlbY/cBzpmpKX0969pn25h1/EsqGQW/kaCJ/w?=
 =?us-ascii?Q?t9ZqhruQk+3/C53a/70jbPXBdavAYVfTG36b5u76XHVbHdrYfqn0PNRsXyld?=
 =?us-ascii?Q?0Q/S2NhNoHCvrX+WnIH58ZqrYKOXk1qGG1XJ5dry8cvWIK3Uie8d2huoDuWY?=
 =?us-ascii?Q?iEN+ZtBrXqy/vA42tdKJOBDBpqF84+Bc5aSEH/myhYDVKEHai3cP3CR/LXEy?=
 =?us-ascii?Q?UMXDMqugeca05O6bq9ULPq9B5+f6IEFAxloXAlRGHoDyqTJICZ1dnfoHZgxo?=
 =?us-ascii?Q?b6ZICe+USGZH282ZuQ5IOS1/b1rhbTowKChmXxuqfsU4yAq9Cnfv9xHrufkE?=
 =?us-ascii?Q?vxtcD+ukG3dJrRikIqYvHl1KtAfdiFvc/cZ70oCkOp92F3AHXh58a8Riiryf?=
 =?us-ascii?Q?nA+X8+MdVI18NXHB0OHb3CmyaK020UzVkfDPDlT3YA3WdvfoBhYJXg4mSzW1?=
 =?us-ascii?Q?adWiODeIOItDr0Jnd5HQ0QgI+GJjgMVgSHdgChCYfhbQP+VE4yx1g94O6RYD?=
 =?us-ascii?Q?/fs/uQT/jQ2GBeSRPRUHo9nuSEw/zgExpaRk627FyPJmXZeHkEnBaGdjOrph?=
 =?us-ascii?Q?Z7P6TgVvcJlBwINIbObc2dnJaxS5idOpmrTubX5NXK4QUZf2B4AUWvLkiMEM?=
 =?us-ascii?Q?dcJhszShjmbOMzW9B7MxmsRvV7hdzIPEHitFfMxTzS+c3kkGi0qYcvI/XQkP?=
 =?us-ascii?Q?2lPT+2caGyZb4OSC2oJIhcg7wC0zzB1jtJLrzWZSLKEsW1rZkP3Nm+qmQcOP?=
 =?us-ascii?Q?Gx2uqNzObjQDdXHXCa26CABsYxhl9VmwOL7KAMa7pzkkFZ24M2gKT3mALIy6?=
 =?us-ascii?Q?lf208jkXC5wk273Y2ljCL9QxVzgb/CqdD5sfGXeRdR8tMnJ4j+zBpep7ALjk?=
 =?us-ascii?Q?I01689LDQbE2X6AXwKnCdT4+EMCMFRj2D4fSsUhcYAh6RNZB5Ik1/mdodebN?=
 =?us-ascii?Q?2RwPHASaKb9B7ovuoOzqJs6ng1WSOFP4aSc9beJLrk/EBmE+Pcz2jsDHdhpn?=
 =?us-ascii?Q?HjLlvFE5EpyP7iT58+FyTNpEDFckelopc9XDJX51s/JV1qrbAOR0WzNhpUUh?=
 =?us-ascii?Q?KyNhdv13KBZTp0m4SZ01jjCe8q7Jx58gZQyOKopqJPJ3SqI18w6durNw8iY9?=
 =?us-ascii?Q?kYO08BaHbOEuiFjM/HSNFOVyXSEs+tfWEiZmAOVerI1Ah0oQ1G5D56B4k2/F?=
 =?us-ascii?Q?pRt2/iK4sU9ruBbYHA68CrXABvMQpEFB9gs+aVeGmH0Q3QcrcB2BzOPVGOmG?=
 =?us-ascii?Q?68JyJ+uRIzxcEUw+ZBbZHXfkzA5D+M2AF72yyfpVv+4r0TVcbWZs9EdYEjsI?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61492044-c3b0-48ca-e449-08dac662c53a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 17:07:54.6287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XsRjW6pCySfSQnpA921fNuleul+/3RZ/5dl0eFsgC1OtKrbfITjtjdPk7sIA3X/BBdceFJz+G30X0f/HvMqT8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9280
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop the custom implementation of phylink_validate() in favor of the
generic one, which requires config->mac_capabilities to be set.

This was used up until now because of the possibility of being paired
with Aquantia PHYs with support for rate matching. The phylink framework
gained generic support for these, and knows to advertise all 10/100/1000
lower speed link modes when our SERDES protocol is 2500base-x
(fixed speed).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c           | 16 ++++---------
 drivers/net/dsa/ocelot/felix.h           |  3 ---
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 30 ------------------------
 drivers/net/dsa/ocelot/seville_vsc9953.c | 27 ---------------------
 4 files changed, 4 insertions(+), 72 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index dd3a18cc89dd..44e160f32067 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1048,21 +1048,14 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 	 */
 	config->legacy_pre_march2020 = false;
 
+	config->mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
+				   MAC_10 | MAC_100 | MAC_1000FD |
+				   MAC_2500FD;
+
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
 }
 
-static void felix_phylink_validate(struct dsa_switch *ds, int port,
-				   unsigned long *supported,
-				   struct phylink_link_state *state)
-{
-	struct ocelot *ocelot = ds->priv;
-	struct felix *felix = ocelot_to_felix(ocelot);
-
-	if (felix->info->phylink_validate)
-		felix->info->phylink_validate(ocelot, port, supported, state);
-}
-
 static struct phylink_pcs *felix_phylink_mac_select_pcs(struct dsa_switch *ds,
 							int port,
 							phy_interface_t iface)
@@ -2050,7 +2043,6 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_sset_count			= felix_get_sset_count,
 	.get_ts_info			= felix_get_ts_info,
 	.phylink_get_caps		= felix_phylink_get_caps,
-	.phylink_validate		= felix_phylink_validate,
 	.phylink_mac_select_pcs		= felix_phylink_mac_select_pcs,
 	.phylink_mac_link_down		= felix_phylink_mac_link_down,
 	.phylink_mac_link_up		= felix_phylink_mac_link_up,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index c9c29999c336..42338116eed0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -52,9 +52,6 @@ struct felix_info {
 
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
-	void	(*phylink_validate)(struct ocelot *ocelot, int port,
-				    unsigned long *supported,
-				    struct phylink_link_state *state);
 	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type, void *type_data);
 	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 26a35ae322d1..b0ae8d6156f6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -885,35 +885,6 @@ static int vsc9959_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 1000baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
-	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
-	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 /* Watermark encode
  * Bit 8:   Unit; 0:1, 1:16
  * Bit 7-0: Value to be multiplied with unit
@@ -2588,7 +2559,6 @@ static const struct felix_info felix_info_vsc9959 = {
 	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
-	.phylink_validate	= vsc9959_phylink_validate,
 	.port_modes		= vsc9959_port_modes,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 7af33b2c685d..6500c1697dd6 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -840,32 +840,6 @@ static int vsc9953_reset(struct ocelot *ocelot)
 	return 0;
 }
 
-static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
-				     unsigned long *supported,
-				     struct phylink_link_state *state)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-
-	phylink_set_port_modes(mask);
-	phylink_set(mask, Autoneg);
-	phylink_set(mask, Pause);
-	phylink_set(mask, Asym_Pause);
-	phylink_set(mask, 10baseT_Full);
-	phylink_set(mask, 10baseT_Half);
-	phylink_set(mask, 100baseT_Full);
-	phylink_set(mask, 100baseT_Half);
-	phylink_set(mask, 1000baseT_Full);
-	phylink_set(mask, 1000baseX_Full);
-
-	if (state->interface == PHY_INTERFACE_MODE_INTERNAL) {
-		phylink_set(mask, 2500baseT_Full);
-		phylink_set(mask, 2500baseX_Full);
-	}
-
-	linkmode_and(supported, supported, mask);
-	linkmode_and(state->advertising, state->advertising, mask);
-}
-
 /* Watermark encode
  * Bit 9:   Unit; 0:1, 1:16
  * Bit 8-0: Value to be multiplied with unit
@@ -1007,7 +981,6 @@ static const struct felix_info seville_info_vsc9953 = {
 	.num_tx_queues		= OCELOT_NUM_TC,
 	.mdio_bus_alloc		= vsc9953_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
-	.phylink_validate	= vsc9953_phylink_validate,
 	.port_modes		= vsc9953_port_modes,
 };
 
-- 
2.34.1

