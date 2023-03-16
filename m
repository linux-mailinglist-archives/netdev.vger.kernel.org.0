Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A2A6BD4D9
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjCPQOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCPQNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:13:39 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2043.outbound.protection.outlook.com [40.107.105.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3785D5156;
        Thu, 16 Mar 2023 09:13:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=llu8J2tz7pTgkluYq7yPD2v8wf89byVUAUMtsGC8G0eqLJjevOFZaOGEuj2rG7KpD0MByhQVTsyoPMBGLflLkYK0vg6k/QgzwCWfXden7J6OHTcit6+R7r5+IHKGvkZwS0oYz68MlBPvolr3yiD7olC5ejG6u1SnTek6DGzY3ZBQ2ahGsYhMoQEL8uzGw+VyApnYbOx/vT9z1YyLxW2YnnSAiy8c53m3HQg0Bb47QpoccBHxeP1vNJaUqddJC0Jd3r81pwEsClvKswGY50WTyERppulpK6lQi081PEiZzhbeUhd4dnbaQdVjVpjWzMkGW1xoeqWfCxRv/VFUnwh+AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xt5bhDjpXQPCZ2eBjXwCkM9QdeQ8yMdKtr9qsQqOA9M=;
 b=i7SaBDZHltP4SuELnmzGxi8VVvevSYMsvv+LCD31j8Mwva+qRAothacRGXJeD0Cco5A5E6oNHJzxGkUu3kuV5E2EPM9BJIsH8CtRcukl+w/7YniIWkT++RWPPYID5vVChCQAasiH6SVkYvP+CQsw2fBbl3f3AN53NikSAZUt1y+rqd941tNoJMaRBfny1LF7AvDXJAkXOS3Y5uCgmqO5nKuxASqLv+s/RuZgBnRZSy3iLD3fodohaKmYhB7mHKHAS/0F6DV8h0qkXw8ZqGrVwWS+A/6rZQZaoOk9fXvPYlK6Xvz3VV1gXfrcvyTRBPZyRYf3MCklOze7RWjNjtDxZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt5bhDjpXQPCZ2eBjXwCkM9QdeQ8yMdKtr9qsQqOA9M=;
 b=NUD+X1MB9iDveT2DrYDxxqunmy/yqOIIoEmzbpgWJM+CiqNARvqIbBvDjXDUTplp95T8yAyFTTmHIZ76IenXYTZKafHzNGtnfFNDJalAyNHoePcTf8rwpOFzLcPN8g+hK6gIv2ZwEWS9uUq4DK/1nTONHc94ZeOLi4exaYaM/p0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB7861.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.30; Thu, 16 Mar
 2023 16:13:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:13:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-kernel@vger.kernel.org
Subject: [RFC/RFT PATCH net-next 4/4] net: dsa: microchip: remove unused dev->dev_ops->phylink_mac_config()
Date:   Thu, 16 Mar 2023 18:12:50 +0200
Message-Id: <20230316161250.3286055-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB7861:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f49b10f-d3bb-443b-ce61-08db263957bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvnbyk8wy6U0gqIOw34yMF1p0iWLBe6C91B02yDtNeS5cKGzRJ2Filodpd6FQYDT2dh62kh6AprquA/nT6P+ghbWzWmqvfw7pytz87AmPTbJS0oxmylEPIOzvdTtVpI7UbmcdnzFGknefr2ZUUXwMYXFRzE/D1CoSlsOi2GFCP4U8uqBkrPGwx+r7vRU3LxJwvCWKh7BSY+/mE+kJWgoLhcDE8Nh4egq+pLXs66NjRwSD/Zde3AwL9eKTC+mxgVGbxNfCZM1pj6yByE3EgQ8IvwJMCBKCNDXRbTKBoT6FGwK4N1MVdJww63tRqcgRiOSKn1Ih1VngBVFyCI1Qr1tRZ6dUdtY56ykA/Wp7P7QcHEkS3GAGfjlx66rifzSCSSnaQXDp6m4aP2D4HI1zTz68Khn4bsDQATJOBrl3vbFZlfS2GPQnYNCURzpsE9IR2v/9+KmJJ2OJhzD385CDhQSn5/R6+27f6ZUPE1fnnGAHc0qNqFKBjqXyCoa1ZwEzVOgxw67GpJadYoAT/nLDItUEv3IHGgU2TxNdcXxYq9xZdfVlmcT12HmGnmwOS17MN7tY/p7zMCx6SCUpffK5Eo037CwqbRyv5yhvIgE+39VyVhY86DMlECPo3nmvGJCTarDhVzhY0lLigk0h0QxBAKQ/j7aOwnOSehb+3AfYnIkK9SwuEUMK6jxRHOi+iP0zZ90dx3Pi0IU0tmh2dBQ6sxJRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199018)(36756003)(86362001)(38350700002)(38100700002)(2906002)(5660300002)(41300700001)(8936002)(44832011)(7416002)(4326008)(6512007)(66476007)(1076003)(6506007)(26005)(186003)(2616005)(6666004)(83380400001)(316002)(54906003)(6916009)(8676002)(66946007)(6486002)(52116002)(478600001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ATR4oZk6fD+6PhcFkF8ux6UJtn1n94tgPxFV9NFmzJk/UIDHwMi4VzBhzMNQ?=
 =?us-ascii?Q?f0iaS4Xe0vmIthvsouvxWpem75q/z00U9ASafFQAwmA8yf6sKBFZ+5LzZ/Vx?=
 =?us-ascii?Q?2Ot2KKWb54nhUyDm0luuKJanRAXjTMxIAKs0uhhOM2ECjy60E/VpUmAUOK2T?=
 =?us-ascii?Q?p133cheLyT7b6LdGncQPok5DuDt4p3QWr/rHP3CIgQrZWoY5ZliZiPKZPLVR?=
 =?us-ascii?Q?XpO1u8WZQqhDCuROx037/mBRz3EAoYHA4sOfoBeRfUOS0DoEPqW/9m/vd+ua?=
 =?us-ascii?Q?ftzTwychwF1kFnx2SdcK+A1biTrGLlctZdjZu2ZhdlRCm+bglnuExFooiEqO?=
 =?us-ascii?Q?1ruYTCLoj0J+szRZ3smA1pfuKw7b8QGj3W6bZnWUbLxT5p/9RKfw1UGj40N/?=
 =?us-ascii?Q?Qgg9u48t2QxQO74SrWGqnyGsvVj7/Fezs6xHQ50HKaQqwIvss6VWmaR7lIkv?=
 =?us-ascii?Q?QCGDdEstVvOlUNM6hU36MbAfcfVLj5GQqtKjKQpTKCioV8CkudTomRLiCPVu?=
 =?us-ascii?Q?ExrFVULfbk1uRJT9UD8coWGskmn9sisz6l50DxdV/c3kgI9ymnR1kmuQlIqh?=
 =?us-ascii?Q?VlF/T1VfmVOZByvO41t76gK8fK3Mb0xD5fvWyFUbQ6clktWplDpuCBm4c1ee?=
 =?us-ascii?Q?FQ4VJCeQVsS/rOjaOF+w314jt0Ob/O4lhdYmnldBHdAG5vgDzp0Vko//3cBz?=
 =?us-ascii?Q?y+A2M0q/vJj1lduDVVf3GfYn1F93cWIavebUvat5Zl7FT31PXbAzXM7hvp05?=
 =?us-ascii?Q?wkk4rtkeSvrlJKoslB3NQDt6XkbdBKChIc2GlHxld7WuUUCyNMC+af17Vh8r?=
 =?us-ascii?Q?sxF7pdMViw198sYWgc6rkG7oXsCXwYZJ6zP/9NMph/dDZrKyvAaTYld/JYwC?=
 =?us-ascii?Q?9uIP1CsXqdIqKnD/6Kd4j4Rt64Zmzma2+SyqGpEqlrzPrjTxx1aUCLVZPrHk?=
 =?us-ascii?Q?TqGdctNjEyadeE08HmNgD+FdKiAam1dsPhb0mgYOUhvVM6GpyeXiKhfw6Eo3?=
 =?us-ascii?Q?e8FeDW9hiGfS5As37pSF345trVMCJ9vlfMnSGuTIHAcd0KCJtJ5/PPZgnp/E?=
 =?us-ascii?Q?dmFYXDLdvpz6NJ98ZIUjebTKxzDs3ExVWAE20lj5lm6Z1bFnvjfjxRbS8Z5s?=
 =?us-ascii?Q?4vrkRvTuzcYO0aExwcPpt7cz1KrfrTr75/rd/NnOO69Q3AnhCIVrpvZGYW8p?=
 =?us-ascii?Q?oQXMWTYobpG7+umMykVEv6lXHOcmiCZbQbyY1sBwBIqC1CPjBlIcVyskroVI?=
 =?us-ascii?Q?WKVGeXacKndf5jZK4EcohJz+uC7TkfnsCCnUd5mjed/9ZK34M8HM6VlvkZ1k?=
 =?us-ascii?Q?XOJz28guFxEnnjpu+eT3dnrETddzJpjvocAsNOvadcwZGPJ6YOyRSvM787Y1?=
 =?us-ascii?Q?1Sy5IB+C/Z99FbRkbui2mGzXEq2MraNcekO+ItbGQ8zzNjj63YuwugzHSdCs?=
 =?us-ascii?Q?e6AXc6d2g4FOAGBmC5Ix1TVkGUymqJacEMnkpzpYCHj852u008bp3Z4hSbsV?=
 =?us-ascii?Q?Js5qbLThr3F/LMW01BdCQz56SOGjKyJZIO9QLeX5K/EF3r1yxlR17Yr+1aBU?=
 =?us-ascii?Q?U4g/2P+7EHQu2v+2oNwkmJfYH0Waji7PFQ9ZERGNareBW0tAHjgm1cHRbwgl?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f49b10f-d3bb-443b-ce61-08db263957bc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:13:13.5039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4QhIrUYIBErMVLtGK4r1PzZ6ENYy+mrWZGyExfR4/ziOZhnhshX7ju29zcXe6DCAeiJCbtqVmEH3VEUqeunpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7861
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The history is that Arun first added a phylink_mac_config()
implementation for lan937x_dev_ops in commit a0cb1aa43825 ("net: dsa:
microchip: lan937x: add phylink_mac_config support"), then in commit
f3d890f5f90e ("net: dsa: microchip: add support for phylink mac
config"), that implementation became common for all switches, but the
dev_ops->phylink_mac_config() function pointer remained there, even
though there is no switch-specific handling anymore.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 3 ---
 drivers/net/dsa/microchip/ksz_common.h | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9bc26c5da254..421e1212b210 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2894,9 +2894,6 @@ static void ksz_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	ksz_set_xmii(dev, port, state->interface);
 
-	if (dev->dev_ops->phylink_mac_config)
-		dev->dev_ops->phylink_mac_config(dev, port, mode, state);
-
 	if (dev->dev_ops->setup_rgmii_delay)
 		dev->dev_ops->setup_rgmii_delay(dev, port);
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 760e5f21faa1..618154f3c894 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -378,9 +378,6 @@ struct ksz_dev_ops {
 	int (*change_mtu)(struct ksz_device *dev, int port, int mtu);
 	void (*freeze_mib)(struct ksz_device *dev, int port, bool freeze);
 	void (*port_init_cnt)(struct ksz_device *dev, int port);
-	void (*phylink_mac_config)(struct ksz_device *dev, int port,
-				   unsigned int mode,
-				   const struct phylink_link_state *state);
 	void (*setup_rgmii_delay)(struct ksz_device *dev, int port);
 	int (*tc_cbs_set_cinc)(struct ksz_device *dev, int port, u32 val);
 	void (*config_cpu_port)(struct dsa_switch *ds);
-- 
2.34.1

