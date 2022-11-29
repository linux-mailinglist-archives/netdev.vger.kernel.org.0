Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B32263C214
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiK2ON6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbiK2ONb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:13:31 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2051.outbound.protection.outlook.com [40.107.14.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A782B5C0FE;
        Tue, 29 Nov 2022 06:12:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIeb8S/cDdkcPW2K/rN4o3KyEJUR721f+mQlbEmvDrtJmGF7mtx16KueiqPG5J1rRAwDdeCZ3Gm5I2Rbrn8skDB8c8hwIbTEOQAWsjFnsLXz3uCabHKgHu1ZZt+wWd9uSgXjBUxwCAvBMdsGygCurTSBx7l67CsocD9Jlgud37rXIQEsqCx1vMYbgP8prIfO8bVFNA1eTWcp1vjNvCh20ddmhcLtDzsaA/CPABm+lwF+4iivAzl1YC144y7BfaGDa85k3ARFWeJY42Yog7GG8mRJlZTCe/5Gg2Y4qx9CUoCsLiF5og7PWCHiPNZUfRPyNrbXcnARN6Ngr1GlNxdYbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kmb7RQ/LWSZJc7y18pps7W1QLlJmq1dDUh8yEoLxUJo=;
 b=FSGEUQUsHk+u5/SNRjDbnXsV4NW5GgcxB0gZRFYf2Kw/VFUb5At22z4nD9L6U4zO7VeYCDfzMv4aKRjgrZCdukve5HNntWgpDWe9x4ST7kH9no1sj9SVI+XvireMqvJMfEzaKt7k5LaTOSaLeQZ0fRuJR0uVgZsGkAxY1DB/Sc+Hqz33jcf5v1ePk+u2IWpbSn38IOylOlitZwoL27T9DpD/X5AitHJ7AXi15SfjitorrQ1FxC4B9YvVcuoUUfDi0l2LRd/INvSEDJcAWn2A6DGMcLthEjmi0I6jsOtCwmj/abtSmVLrzh0tjV7pg0drGaqYzXyFHa0QUqfoKmHDkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kmb7RQ/LWSZJc7y18pps7W1QLlJmq1dDUh8yEoLxUJo=;
 b=BClsoqKAp0FiBbS4S9X/61VX71A+Ih4TJVibdlctIEgTWU/92OGm+GdPHO8yBZfEdS77PXDJUNo876r/1QokbEbxbZnLLNujtcXIjOnq10NuJNk8Sq5NUzCPrVk0U663Mn1HgSqH2jdJecW7S9umwYbm63xaEQ0WYvVDB63CnEI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8724.eurprd04.prod.outlook.com (2603:10a6:20b:42b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Tue, 29 Nov
 2022 14:12:36 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 14:12:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 03/12] net: dpaa2-mac: absorb phylink_start() call into dpaa2_mac_start()
Date:   Tue, 29 Nov 2022 16:12:12 +0200
Message-Id: <20221129141221.872653-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129141221.872653-1-vladimir.oltean@nxp.com>
References: <20221129141221.872653-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: cc866a38-c243-44d2-6336-08dad213c3d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuggWXcZJXEOSErb1ZZzjBuqfC/gGe7YeeiwwG0DfVVEQCCXXdBcgjMyJthGRkzpBMKk6ezHaxJPnqimhJPD1A+ncV1kje+1d61V1ZJZBIs5zTRueJnyj3FRb69GR8LzAmKY7Jnkufwhf6mqwHOFT7PcIQFpVnwwgxjnUbNCFAy9KO9BgrPhXpnZwMc0T2rLqeSKEBZVBV6Sq2djSXybZQXu0/4mXzrGFF0Z0s85PFTza3aPXG6FOgljV3FrD13RncP9DXvj9KYLDjzNu4ZDHpoPaITQmTgUxhC7KMXrVLkQ1+W4WZoB6zJlo6btxYx0hBJoyDMOR8KnDN0lcRRYkDqWELfvmS+FT+w+QGKi4GpAhMF3ODd8A7Ngmk3s+3FvsISu+T0v+NcFOImGhgHTU/BGDUuf8dIz67oYyCC7fc0SN4/gC0LWZI+E7DvoCB0LYNc/CNk42gpoObO5ms8QT6qoizSpejYddujHhbPjh0b5F4AwiVP3ho8NKc9AMouMnvDUQAD9nkuWKbUjBVVNxzfj5fJAmoUCbQpZ45j1WH9YhUCLOD+k9DB4SFtW1SWikvDCFJG8j7AHkCeNlN/1QptJyDvtWiCBa0cdy/j2TaDvDb+zPwGf09zQKneb/wdWWHMxRCEURsSDTwDvxp/6HxCMbpTCG3q7Ep8sXDE9UhZKtgZKUL1z2c/m9EG0S/s8G8VC1mt61nz2gXd28QZUnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(6666004)(6506007)(6486002)(478600001)(66476007)(1076003)(36756003)(186003)(66556008)(2616005)(66946007)(8676002)(4326008)(6512007)(52116002)(5660300002)(26005)(316002)(54906003)(6916009)(86362001)(2906002)(83380400001)(41300700001)(44832011)(38350700002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0FILjFMFlzFRlclFbt3/MDB75yWTheE8IX5WMzdzRUf0oCfDkM4v/TYdrgay?=
 =?us-ascii?Q?BwPSCTQBlJtWc3CY9ecob9O4JlXM+osklEXmd+CDFgbXaujlgI+Ymq0tfE4o?=
 =?us-ascii?Q?DBJj4byM3CKSNL3HPjC9PLIl/5bBC7XTbTyuvimRTTFCO6CF+nFVWKLX315+?=
 =?us-ascii?Q?pvFAAH6wqhVGfIxhjqUtQTUOIv0yzHgGGvzT0rDMXJ5SkRkVWRslpLMtu9yE?=
 =?us-ascii?Q?jqoqq/m1fxPp7BMkHRmtlRgHMYOvHeH0l2PRLRs8oXL62T7AlwDPFK7Ojr4K?=
 =?us-ascii?Q?pfnfmyL6abAfVPsqqTOG60+p5Mm/9yq/4rmQjgJWz2bQtgvuk7meG1HUHxjG?=
 =?us-ascii?Q?5dDPzH56zctE95uU2RWSLFe6Ex1Y0OZxsQJGxO9wggd8ipyyEHZ/yF3AnQSj?=
 =?us-ascii?Q?WWZLIJ0yqVtxXRIf7r2SW4oJSCL1P0XASFBTxvxWfR2ICyvO68jhMiFcH121?=
 =?us-ascii?Q?ExnznxUlg8SNMvamP1F56uMWirYTEguceZR0V43EQ94b+taVkn0SV5A/tqJ1?=
 =?us-ascii?Q?et/itQmf9G3pKFGjelnQzIdTg/hdCQWDyilfjGMh8YkseBEbd4jcelg2goG0?=
 =?us-ascii?Q?/QK/TcBnJIWDhjAQzZEGHJRq+aUDb8elrwYXemfnJXdOxsKsAkUtuQ79dhB7?=
 =?us-ascii?Q?B48cjCmpej8kOnsxVtzPmCFE3ZStZDyAmNNXJjBIJQalRbYTph4fiPXlcLPh?=
 =?us-ascii?Q?3SqwghLSwnX34S7XGltIp1x3q2ImQj1JPpK/7JoLWUETNIgBlBoKJfYD2CFT?=
 =?us-ascii?Q?tPcEfAgXqjqPBzvm0tmD9nvaCG/aRGlBkmciTT/7MGXXFfVdBn2D8P/vPcud?=
 =?us-ascii?Q?DkiF6USNDOaCFwMAPuqnXaX+k61vKKvulIutRSEbe7aBVtkho5FhnKXRc2H2?=
 =?us-ascii?Q?3yCsb834bdBDVTic9s6TjaDfz0t0j/guqv1Njsa65kMkhNvlBGpFdQvpAgOW?=
 =?us-ascii?Q?/H8m5EW9Bz2ypjpEhVczd1h2yIVaPE2FMYfvsPbal6s4UnyUPaiuaJ4ROBt4?=
 =?us-ascii?Q?s0RYq7nE0+ObjBdt01YnpiH/3rCawcqfWfwd+ggjTbJo8Fiw3QpYT45JcMeD?=
 =?us-ascii?Q?ZqxlQ5WRQqtLGyHEGtg4hFLcCaVGVUpG4bFTRX/T9MD4ykcrtyI1OS+pabuS?=
 =?us-ascii?Q?Q2VklyOIQD6ai4bjF1IisZoijk5sDgNo6h+TQzoX28SS2C+G3rEAXAaefm6a?=
 =?us-ascii?Q?vW9X3DfV+oJbitojPxX6RzauhnlX2wBpx114kTydCRNCg3DdVYgecxhCFWDg?=
 =?us-ascii?Q?x8zf4SrKvh86SgGeIp+/C0H7kDu44NC9kc8t0XL/Ik+zkVqQg9FTsoE3zZGm?=
 =?us-ascii?Q?V83H2cP4y90LJw92m1ECCu9gLYKED6mjBGO/DX8tYMggBkKCXrQzFxpjbQAn?=
 =?us-ascii?Q?lrAYG1WSpjKWM3853YByq+2FJfqNlmMNQePvZ2kHANG3A9Mrd/9ZeUuTBEGH?=
 =?us-ascii?Q?t/m1lsUWmo7lHd7sWGo62iewjzaycMQmH9JYLdF4OmGV/3r7ZIHPbbu2no3p?=
 =?us-ascii?Q?bkKnLa6aHzQOctPpEzvYcIXDzWcIVusNpUUFKLY87Kc+idD3wpWUhR4lT9jv?=
 =?us-ascii?Q?XLStmnthk/6yjvdTk3SdFq/AVwcX+B8zkJZEh22c09uzM3crfLcHo6lbo/Un?=
 =?us-ascii?Q?aA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc866a38-c243-44d2-6336-08dad213c3d5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 14:12:35.9662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NObDfl2NP+hYJHk1l/VmJ8q4FZy3GaSOeWMUzOnvRuqZMuYIveoe0e4WmIT+sGrnURqiGu2zkm+Czs7u/kdGbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The phylink handling is intended to be hidden inside the dpaa2_mac
object. Move the phylink_start() call into dpaa2_mac_start(), and
phylink_stop() into dpaa2_mac_stop().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 5 +----
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c    | 8 ++++++++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 5 +----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 515fcd18ed72..8896a3198bd2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2201,10 +2201,8 @@ static int dpaa2_eth_open(struct net_device *net_dev)
 		goto enable_err;
 	}
 
-	if (dpaa2_eth_is_type_phy(priv)) {
+	if (dpaa2_eth_is_type_phy(priv))
 		dpaa2_mac_start(priv->mac);
-		phylink_start(priv->mac->phylink);
-	}
 
 	return 0;
 
@@ -2278,7 +2276,6 @@ static int dpaa2_eth_stop(struct net_device *net_dev)
 	int retries = 10;
 
 	if (dpaa2_eth_is_type_phy(priv)) {
-		phylink_stop(priv->mac->phylink);
 		dpaa2_mac_stop(priv->mac);
 	} else {
 		netif_tx_stop_all_queues(net_dev);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 61d31ffb5d97..c22ce1c871f3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -338,12 +338,20 @@ static void dpaa2_mac_set_supported_interfaces(struct dpaa2_mac *mac)
 
 void dpaa2_mac_start(struct dpaa2_mac *mac)
 {
+	ASSERT_RTNL();
+
 	if (mac->serdes_phy)
 		phy_power_on(mac->serdes_phy);
+
+	phylink_start(mac->phylink);
 }
 
 void dpaa2_mac_stop(struct dpaa2_mac *mac)
 {
+	ASSERT_RTNL();
+
+	phylink_stop(mac->phylink);
+
 	if (mac->serdes_phy)
 		phy_power_off(mac->serdes_phy);
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 14f739e04a3c..42d3290ccd8b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -702,10 +702,8 @@ static int dpaa2_switch_port_open(struct net_device *netdev)
 
 	dpaa2_switch_enable_ctrl_if_napi(ethsw);
 
-	if (dpaa2_switch_port_is_type_phy(port_priv)) {
+	if (dpaa2_switch_port_is_type_phy(port_priv))
 		dpaa2_mac_start(port_priv->mac);
-		phylink_start(port_priv->mac->phylink);
-	}
 
 	return 0;
 }
@@ -717,7 +715,6 @@ static int dpaa2_switch_port_stop(struct net_device *netdev)
 	int err;
 
 	if (dpaa2_switch_port_is_type_phy(port_priv)) {
-		phylink_stop(port_priv->mac->phylink);
 		dpaa2_mac_stop(port_priv->mac);
 	} else {
 		netif_tx_stop_all_queues(netdev);
-- 
2.34.1

