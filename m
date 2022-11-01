Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A650E6149F0
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 12:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbiKALvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 07:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiKALvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 07:51:03 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130082.outbound.protection.outlook.com [40.107.13.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B731B1D3
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 04:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U02Dup6lCFNyUv6V1oqLQUCR5LODUEUTZmqQcUIDXrUhs+3wRumUH37H7MtUd7j7IKhbZpcv80nbhd4Q46H9as3gJVIs8nIjUu3ZohwtUQx2kBlxvI4gk5OKBRWfucIKX3BWPHUShgG6/QH4eUcdVaThnIJ2VAnEPvSbcE21Thiy/Py2Wadkx5+Ph1UAmylACKVBc9nkskO1JHjZUI5Hf3HeV71thVdtkm0PlsyRXrUaBPAMlujphxt1vzW3F45uw/qZFN4uSP2pvH2ZREYKQuFlhuMYUmdy2X7FYRcb9I+u7WAS+HxTM7GdO4D337iTgUJFWC9LtJegzHE5uqsQuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+lE1rDiZZ+eB2PqoIYgq6OxDokTPl0ssZh6Gc6fOut4=;
 b=m7iGc9eQRwDAQGApsBHW6cx7905/TayUQy10ED8+Zr1SH746uGqFL7bpWDBLdOinXqEljCWKfiYs7Qab5zxBnKan+e6Ophjrmppm1zHG46FejH//JE4nefehGFLyOKcme66SOo0fzlk/SmD9bgYC5bRb0nsfdNljyEWR6Wm97NM4oV0YWuQYTluXzuk6WitzW1bki75Je10L0kyXexgWSiTAJImkeX9Z0AEGNvKn0Ffy2OwhMNINb+/gWEe41FjY/xSKGtt9D4mT2Vn3VmKAit0xULx98O5Wlh6pSiYsHRRHWom/XYV2MMlua8/3o/IKEOaZqo1pxIKw8bwJh3QRFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+lE1rDiZZ+eB2PqoIYgq6OxDokTPl0ssZh6Gc6fOut4=;
 b=NVTKbLV0tdjSkfmEf2g+6wkwpOVB0LfTRiF4MW813VGPoW6qx951hvoMgqYt9FvKyCSk2YIibrQhM0U1N6kxCmSFJra9oJ/uyeTNitjMhzapWVJCDXtPqS2NAvtOKGqtGQ2Y3lXttMpf2YoKn6VoTyoyKaGH3EWKA5FP9AxecKs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8453.eurprd04.prod.outlook.com (2603:10a6:20b:410::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Tue, 1 Nov
 2022 11:48:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::df5b:6133:6d4c:a336%7]) with mapi id 15.20.5769.018; Tue, 1 Nov 2022
 11:48:27 +0000
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
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/4] net: dsa: felix: use phylink_generic_validate()
Date:   Tue,  1 Nov 2022 13:48:04 +0200
Message-Id: <20221101114806.1186516-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
References: <20221101114806.1186516-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0057.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8453:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a727faa-5b09-4554-4803-08dabbfefd3b
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3kGWcPZuyk95l7Goz8nMg72lz9kl8qk9+YjCqPCiVmc64DVpACo/8OLkSB/phDhzfhNq9VNGIFfmvUD6Slfxb1KmQJpuWwiSnG3BCam0JyNRVCZz26ALYPwE/Ni2Z6jsS+KB/BTBjQtFn81Ccws0TqX2lro3V00UMGrlU6e7K7u5yQe5BhXRiD2vZHNq0nePWGOvEkNS/GIomg9DwV0fnjpKJxv0isOHbCin8ZtvBvpgKEx+MDgjjBzWm3P2rnGhHi5eeeOVTUGhaGP1yNnW1TGtyvCz1LFeUp+xgq+1o8+MglDyAJCs7LYtGRDarnaEKacVHLddG5OpiIEGMLlrf883EthL2QzoFhOX3vA1nKhMkbMjaMHWI/OUFhG0Y/Kfelc0UygVkWHTLApjSMJMrmK0R0XdOFGTIWcqpSTWpfj7ab3fOZU9uaie39WO7V/xTJXFBeVTMkNmE6UffXGE7ZKKAJJRVl1hJKEjlEF3rABIM81z2SX9TvQMtHQGrK2gUAxcUHCmmDJyAY1tdGiZcQ9WX9gnTA+IGfSB8OVx3e8rhLTmTL88VeusycK+btufwjk2OQ4i1Tj2bHbi8lKaYYyBGZHWGnr3Q/2rztse1TzLNWGz1nYkn0O5ieSGKJJRLlplA/Z76T3PboP/M1QskDNLk5Bx2huJIFqYlA+c1ODuXD5IFJwKiH5QTjwdJWuSubizj3gBLSa31GdmRm9UfNAEloH5SSNZ1vC1X56HZpSO05AD+27RM39HxiiZaVSCoHTD0XGpyLjZXSh8qqpzH0umHw6len4UbptmZUYYHOQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199015)(6486002)(41300700001)(26005)(478600001)(44832011)(7416002)(5660300002)(2616005)(2906002)(6512007)(83380400001)(6666004)(36756003)(54906003)(6916009)(8936002)(66946007)(52116002)(8676002)(4326008)(66476007)(66556008)(186003)(1076003)(86362001)(38100700002)(38350700002)(316002)(6506007)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WYC7MZeyAaMslZVzJZ3IOG0SzO+wyfqNWPuywTEh3uDBZLo93qmOkHHu243D?=
 =?us-ascii?Q?br1QHU7vykeu8TsnYJAMBU8ovbtN5hO6tuNQgQ+JRO2TtxhEXy/w+0jnr/49?=
 =?us-ascii?Q?6bnPWCxf52Pi9oWP0aZxbZn/7hS02+gaDxp+tB0b+HGOG/agj9wrT1ITk0Wl?=
 =?us-ascii?Q?F8rWoVD3nMaFsx3U/UzCq6Y33K0LxT2K7mD9ASTD/KPiaJztS4Hd3Cqlywce?=
 =?us-ascii?Q?dplYvQ5x3G2XeoNi4uHUgTwlu+eug8KzFYcIKLi98mmg/Nj8RfNLVsbvw55+?=
 =?us-ascii?Q?hL57Wat8cNYWqMuSVdS4OxzcdKQ1zUhOBTmC0mxRZgIw0TN/evRnLehhDdhw?=
 =?us-ascii?Q?/K6TC7MJEwF0X9ZMPltJW1orLzPirEWr1OA1E32mx3jcoQeReAbq80MW//JW?=
 =?us-ascii?Q?VyyQDj2XtYpQ/BmI4ff1Ai+BW017U1C+GX1zxyy00nFRpBvkVWpuw9nACToX?=
 =?us-ascii?Q?ff22SvSr7n+ixLaMyPwB1BaUFO37o+xSOFMq/ToowGrK6f8YfNLYJ8oOubqI?=
 =?us-ascii?Q?JJCGdrZkuSbK4c1h1ZEXU4oSBZMH6GaXzqnMgWTHegdaYKW3F8EpJei4rhbV?=
 =?us-ascii?Q?Evpoq+7yty/0WPAE4ShDrf92z74g1QpjLwQQ6jFsfsoehjCfPVpsCicama/h?=
 =?us-ascii?Q?vc8pU3YzNzD+1bakiQ81smkY2rrE/CEDKV0xjJuRmbgrQ1j5eILg/2y2JKz/?=
 =?us-ascii?Q?0ZGA+SGUp++Le2a9vVHjQqAvT4XJI0Ij+cCEjNKolKnV0eRcbHu4mcPCi9eS?=
 =?us-ascii?Q?Yjh2hUFK+1h1K+z4T/YcpV5cg9Xf7DjfUCw6k0qtKzdixUNwvGDE1BEpltgo?=
 =?us-ascii?Q?q8JezlTdmseFzfdRUpVorKGXBJx3udNRLiLACAlcwzPtP6JY/L1fIDxtq11g?=
 =?us-ascii?Q?bnjS0yDK33FL1tFAFKtvVESSOmJBnMhnlaT23ykASWGQMuwlgvRurx2Yjj2z?=
 =?us-ascii?Q?BCFjtmfCaQjJqMvBqyndJt9HUWwqduQEqLA5NFona/hwUld1bEgXVSQALqiC?=
 =?us-ascii?Q?17EFH4tKVYjPlysO/fZ47Z8dRlrjgSAb5TLDo1eRxSJFZKMhfYr0GO6IMJsz?=
 =?us-ascii?Q?gzci3aYFdyyRbv/mu7/wY/h4X/QccNKZRstbgk1HL+mG7Y34Ja0md6uBoIeF?=
 =?us-ascii?Q?zkcEtOalVGeKIxUnQrdddi7TdmBfeNqMlOAhMtlhvfVgGb+9XQ5FbSdSZ35h?=
 =?us-ascii?Q?xW/iGyzzXrp/vR3/HLRQFjr64KxsT/Q/kCv6W5mk0CPuMmj+8oYktgYiEA7/?=
 =?us-ascii?Q?9AF+qpw32M8yWZKSUS1XLPHfgxWmp9pcbcD5ChpMJBteKCO9r7zZ+2tD1HbM?=
 =?us-ascii?Q?2HqqGo3XaWAbRiaj4/ybAkUMuymwwGOoUiU/pydbYUo7uWLhs6CUWuuYTr+T?=
 =?us-ascii?Q?qNytLVxIKOVTetQPXBhPF7IklRnNOA37zZpTZyWobCa+JPcBLkSvlwl/JmmI?=
 =?us-ascii?Q?Uui+Tv9A/vZa8bhSuWmcTU8vaknR5In1vmn1agMCN7oD47zEzombDj6WPzeH?=
 =?us-ascii?Q?dK+tb4TTxNSXesMW+94EHBD60nWmZLhgIaqb3XbQFgJKKlWKQQBjRho09rfH?=
 =?us-ascii?Q?1H3O3IILtzV8yNSciHDTBKFjMRctsY6z+uM68+RrD+zN/Fe7wYveVEXjsJVn?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a727faa-5b09-4554-4803-08dabbfefd3b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 11:48:27.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GUFF/2VqAvk1L18GrwPEUeVOAhKpBEhj03zucDXIIHfb7GGJLzrvF9kUANwZvoqFiH31YCWuG2lafyURYQppVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8453
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

