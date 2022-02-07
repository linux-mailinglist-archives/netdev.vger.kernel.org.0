Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09474AC583
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357466AbiBGQZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387634AbiBGQQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:27 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FE4C0401D1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=loTsXo1KEV+INfG0ehDeKmGe2j7hGjP41GChgJCDgHWKHPz17JGMYf2n1kbTlQxl8h1wkI2L64b/z84ki4art5w6kl2GhPFXcJ7PBI5ehjZfGljdGBGVO5vXim0SY7qAJ7xKF68a/TDS3efWH/VATc3p5v+URfm9wq583PujQF4+n1CQzW2bbM25BCXPHu3vp+7jge6cG8IwcBppSTGlF7CBkZXGXW58oU7x+/PlpnkD3gXhi31NpQvIVqR980a2MhkeFP3YR4NRbbZi9dwkn+dou+PkwX9o218/lKWsjsfNm2MphL312CiqdpFkONYGejXH3rm1GVslw1w1Ig44Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkK62+lt8QVnsVBUpuyL+4k9oLnDOh8L21h96ZROOaw=;
 b=hd/FVLijdSMbyK5PC+L5K0O69thC0INEgX0DhI0T//JEzdvW4TtBHmuf7LG+pVpJczdVrPhvqoJuorrmycoS10T3eppxRenzXPUO3yI38sxuE0fq2LT2V0hiqgZOwQIFsmXEAkoMG4ZIzh7mTPLLnqw/5YOE3CDwUdYQojU78+FV7phtUXkOXJmmSnLEW6+BJb8q8ajkoP4q8v3m3RzSyZ3mBy0Zm4F+102HVhbA8uDJJmR4F046Tu/FOwDIZiIlAP7ZHs3yjJGZMXs58CWJKazOqXQpXmuikGAFqR7YYtrWsRl5FjaewdOWfUnI8Y7wU7HqTA+5DhQ3tZMHjsRxNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkK62+lt8QVnsVBUpuyL+4k9oLnDOh8L21h96ZROOaw=;
 b=Z7Q4kn1kkJjdOSKLCSaCdibnOOgDKittCooCHRXXigCmcwiH3FI/JNpYjCCk8xSpvTtVhzvjqktA4UjhFoEY/38w02W18DMLFuD6OpQylXvCUJS/jkn1sWkT25pSaRcziXUJqSqaqggzbzp0GwVxptUlX9bHI+1jF75o7xzhdbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3910.eurprd04.prod.outlook.com (2603:10a6:209:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
Subject: [PATCH net 6/7] net: dsa: mt7530: fix kernel bug in mdiobus_free() when unbinding
Date:   Mon,  7 Feb 2022 18:15:52 +0200
Message-Id: <20220207161553.579933-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207161553.579933-1-vladimir.oltean@nxp.com>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0066.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7054240d-8d9e-4f05-92a8-08d9ea552f2f
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3910:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB39102DA1F3D069B98CFE6943E02C9@AM6PR0402MB3910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjfPVIaBxxOEwgT8qVpJbdEx35MNT/FAugZMni76gHa5sDk8OGjBX+gXhIbhOpGQsHrGCLxvSwV4AcopeVTgqfEVqOgZQtJcfOAo/EvwAM+drBJd/h5/kTbouTINAkXXG4HsyGKnUPj3xv4WOjDAhaHzqtDQdVbmmvY+OiaCtX++HwQqX1gW5JOEheYCluV+wME0uUZfFk61ZZqCM62gUPqo/tXIAOvptTsP4uQkx1XdaU+dRvNFHNaa4SC7Qu4I8CEKWKX6jfSfq79+WRk2k9KGLLOcfsoe43xAX9fhIcTGpjCQhC8Nnum4Sb9pK93Q3YC8mBmwE/Q0qd4l8C9DYhr+X4FX+raJz/DWM+/7riPrW6+5IcYoFX34dLK4NjI9GZjaa8foxAFR1+egxAUerUB+lkDSjhYwhCUwQqIqhXmd/l15gyp+ZIeyQdRO7kG/PiWH3BSFYUo5y13B0uS0GExmAR0ZcwHAIrIZkfkpRBIcDXuAeKQMsGwRrpXqsN0a8T0FoSpNp4O/8/MpFR0GCxT12ekfInNzMzrgqIAQlYxfjN24cpRsa2vMU6fgkFG4LvL6GBuZcXRHm4ukoJWuTFuX79dY+KcPuuAlQxp8NAqfhsDpPJDfecFNJRXaPJQpRUL9MIqooFphyih35st4NdDwyBgrjiLEuSHvTQKgxSLdFm1w1zSpRtMroqmtbOYIUXxARn75L5qyFg2a6dNsWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(186003)(6506007)(316002)(6666004)(54906003)(6512007)(6916009)(38100700002)(2906002)(38350700002)(2616005)(52116002)(1076003)(86362001)(66946007)(44832011)(83380400001)(5660300002)(508600001)(8936002)(7416002)(4326008)(8676002)(66476007)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5g7Tea1zAfw57wf+qhdn5+F/GvpzX0E9jieccgzlj5bVA16XtrJFpHvMZzTF?=
 =?us-ascii?Q?igaRRkE7SYQa1UlE1P8pZMfoaFKIKD1OjAjtnoW33AmVXevnEP6KuYFFNqZM?=
 =?us-ascii?Q?SWOuzN+f9kvyxvEbPxoS8r1lQqXGRnaO3TMJeii78NHGhq0ujwUUKh+Jaep6?=
 =?us-ascii?Q?NyYZn4JYqcsNYZ8CwmpfCNJh3CQ0/Yn6p+WJUTkQn/wxbZ1cLhlY5IwM3pHs?=
 =?us-ascii?Q?wI3X+MO1u5ffc2jdBF9MEP4ZgVeQrLNA0vyEjsDKwjht0CtRu7xDwiciFU7f?=
 =?us-ascii?Q?3xCRz71adUr3pNWIT7J4HUyVEtsEIsJnsVr19M8UXKVrakvjlU6vg2R+y5A9?=
 =?us-ascii?Q?NzERgzpRY/crVtOUtOyKhT0mQWFUjqS4EqltJrqLDEYJ59BMQigmwMH7bhjQ?=
 =?us-ascii?Q?EV4KybhOTb4u9Ez8/tcNE59N9jsSiUZS6HO/rqSc1mllY4B9ZMryshuqs+2j?=
 =?us-ascii?Q?9K8fd1w8Pf+6Xlp5ZTY7+6A81JHqNnFYSyuQhBQX2QzWzkxr4UBDKjn+Jn0W?=
 =?us-ascii?Q?1fSvxPzqxqauTb7U6472l1ZtN+zBJ4cE1Q9aCnH2HUgs7uGpMZAhs+hmzQCI?=
 =?us-ascii?Q?9LJGyAebpEsDoLpjJ584eRWe401w7aZeEzhVkTSDdD9k79tPRAs7e3eb3Rzu?=
 =?us-ascii?Q?ohN6xuCiGKubmJNr3nlJsfFZjT1m0in7BIUG5GXW8AqrUR8xTDxIE9PY5DDx?=
 =?us-ascii?Q?/bgu5NcDSEzfkf/9vjCjTbTAJ8T5/l0+U9eN+ZopcjK+OjMOoGQHGfkwBDyT?=
 =?us-ascii?Q?8LxOwY/EqgSPCvtBy1FstUDZjpNHDL3A5UmdQ68Hu/5m5Skeo1W5dDMnfthI?=
 =?us-ascii?Q?NGoDGO439epRIIXftJejAxnmy70vaMle01ad6EycDjCv1fuNmePHI1bglp+A?=
 =?us-ascii?Q?pNCtKhSOIUoCKb4UcuhiJ0incFNgxRLgPlK9FXr3iUoDTwebTDNdv4UcPDWg?=
 =?us-ascii?Q?xESLEMW+xFO4u578pjKr++fELD4v8Xvr4778sT3l6x3AAByUasS9R8vBgkse?=
 =?us-ascii?Q?p4NEXahpGrVnlDUO1gdGONorO/HH8e522ueQU4vrDEQ18nLutJ7tofPBlH0W?=
 =?us-ascii?Q?8qC1jyC7cAJ/7vhPqpaIWI8TLzSni64dl7Ha2w514oBrZzp7AQunV2FbbjH6?=
 =?us-ascii?Q?2/rEU3aSiW1HIDM+3zk1ja/F6u0zU+h/sGKlX9FTOBmT2EQKyaEra4lon+ZX?=
 =?us-ascii?Q?53T4XW2Q+hWSvQvlxCukEY0tMBzYXen8Opo0msChH1q6JUrbC6OrJrU36r4y?=
 =?us-ascii?Q?ZP0m8bk2OnjdNfk/XlJMkhEtOhFsa1tAaseMyhF2IHMM4n4Yu9xqlkzZTcmU?=
 =?us-ascii?Q?vUQXZ72t5a53II/pyALNyTM5DyUhTjp4vm2bvTXwBSPtW4kbF7Qva6B/dpFc?=
 =?us-ascii?Q?Q9DVs8QadAR9itz0xomimCPvyah6AJmFF72MYUbH/OKXuZskn+J+8GFrJo3W?=
 =?us-ascii?Q?1SKYznmC1NG5IX8nJWYvcYQ+pw5ZKEvo7tErRoJBIWDHTmfLLegYQ4yrEPcT?=
 =?us-ascii?Q?591ejqe/63R8nwapb0R78GxGleonQtXilTlXUWsBC+lpU3LNUGaXBnPjtyZt?=
 =?us-ascii?Q?+KQXc0OFo+riuFbFAGT6sgHQkIgnfRZOi3Elk5lexP2TkxgoOxi0ihjsT0Jh?=
 =?us-ascii?Q?+wlbmaJ6VGGR8mMQgxrY9QI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7054240d-8d9e-4f05-92a8-08d9ea552f2f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:23.7058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G60ZDBmfIcTBkQ/qFtqgNEali02X6ci6PIDmjeWN39kGYZnRnoLEDnvNJvYp2ZahOHhZ78RZ1nXfi1ggTG5XbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3910
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nobody in this driver calls mdiobus_unregister(), which is necessary if
mdiobus_register() completes successfully. So if the devres callbacks
that free the mdiobus get invoked (this is the case when unbinding the
driver), mdiobus_free() will BUG if the mdiobus is still registered,
which it is.

My speculation is that this is due to the fact that prior to commit
ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
from June 2020, _devm_mdiobus_free() used to call mdiobus_unregister().
But at the time that the mt7530 support was introduced in May 2021, the
API was already changed. It's therefore likely that the blamed patch was
developed on an older tree, and incorrectly adapted to net-next. This
makes the Fixes: tag correct.

Fix the problem by using the devres variant of mdiobus_register.

Fixes: ba751e28d442 ("net: dsa: mt7530: add interrupt support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index bc77a26c825a..f74f25f479ed 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2074,7 +2074,7 @@ mt7530_setup_mdio(struct mt7530_priv *priv)
 	if (priv->irq)
 		mt7530_setup_mdio_irq(priv);
 
-	ret = mdiobus_register(bus);
+	ret = devm_mdiobus_register(dev, bus);
 	if (ret) {
 		dev_err(dev, "failed to register MDIO bus: %d\n", ret);
 		if (priv->irq)
-- 
2.25.1

