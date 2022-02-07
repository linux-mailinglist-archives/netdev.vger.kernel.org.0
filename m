Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5F774AC580
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 17:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347268AbiBGQZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 11:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387635AbiBGQQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 11:16:28 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2051.outbound.protection.outlook.com [40.107.21.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F176C0401CC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 08:16:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqpaRLVrm0c/epoEFw2EgtAba2mpRmiKIA+xmvPkA7GK6bwbl/wOL2b3s0ojhzCnHbwoyGqAjaOoeQj5qFGLrpizfE70NZQLkqENIxREjvvNSLcgc+jGsLqlsjMLLZXWOG0XjR4c+ocWG+AaIdZiZiFuXVsbawWr8dPAIf3xxTafeC+sw42cZLxDtBKMa71gYP0/kYu3zgb/S20ztuVapToxI0G5ViKCfS2b4ZNTRzYJTUXArxjIzCHPz4fde7bkSHCWoXMUHcH1n2GCVZb0LwCVbt16orDdf1OA5cZRjzExCMmd2Z9rgaNhkad8wK5IjbULbh+iIk6Z8oEh+DV+3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIgrt78+UMU2nDD11Ot7yHlMaDiEtuT8S4dFUqSpzn8=;
 b=eovBYJ8vEPfuXR0EtPt3gke0/chOBzIphH6rHJ027zo3FaRq0C3pNv3E7sp3qMsXA+Sy5HORp9Xnr4TTLeBR/VWwToS+9VZ5Qbb2zRzu+c6hKqGdaFhOlAw+Kwx7LRL6h19rEkHTvXH7ddVEHwjDfStpYuSjYecfs/bwV4l5cACcTDtHQOw0o5EI2+WfspBBgOjre66ThKZMw1Jy4dZlhKBRSmNlWgMcMai1ibNss25bbJyWT3HUdRreWikky3DUq218USwx03Yb0YTejVZbs5Lj7/5vT1dTHesniWrXITcDXbwT2UXPTLoURa9uIoz+HEEFXFm8Dj5YaKrki8Pe/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIgrt78+UMU2nDD11Ot7yHlMaDiEtuT8S4dFUqSpzn8=;
 b=IuoNfpaoVlXY9ONQEgihI+NTphCW3yPe8+lHL6AY4XolElY/o97EeO24cr1ZhO0HvYxXTuBen66VmnFaJuzuHbuGg/h4JerEXM1LnC30HhmO4ePj06B4DGLJgFVC3qJelFjf6Elq4uVk/+0c8rjNtHnLynLYAvSMYb2R2poM28w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3910.eurprd04.prod.outlook.com (2603:10a6:209:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 16:16:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 16:16:24 +0000
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
Subject: [PATCH net 7/7] net: dsa: lantiq_gswip: don't use devres for mdiobus
Date:   Mon,  7 Feb 2022 18:15:53 +0200
Message-Id: <20220207161553.579933-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: aa1010e4-4f2f-442f-245b-08d9ea552fe7
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3910:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3910C3F6F8641A7920EBDF3AE02C9@AM6PR0402MB3910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+tulLF9QFOCUSJc2miU4Rwnsnp0W3QTzh5rbXV12RHNUwBClFXzYIlNovyjvgiDZ8G05NcQ5XruweVyQWAw20vuQzHapvnsp5RRiT/BpL65wwRwCIVI7g/IhATpAen6oWfZouyZWrmRGCm6joerWIuBgrvOipWHHwVCpmWhSyAXNVPlDNE0S/uunPg+6Hc/sAzTihipoCVdLkIpoiDgZl4c+xpXwVWOyez0XTe3A0aQbnxZcpp/58H64LB+pza+gRIFYNuOv3PUnUQyU/saEJSfAJxG+bm3Xet8VxK2HQBrrHkBXe5A+BV8xDdHvrj/Eszlp0mw696uhT2e80TEiDSvlzZjs2SsixToNWrPCBMZP2ovR8bgfGerfOG+YpTYMR4lDouymk41/kTDhFKruqV1HKLPqrt3oc43M7iG/ugxtQproKTAoyPxd13qMik4ekW/muvb3wO3mDHB1FrP1zYfgRO6Sv14ifCiof0+7UTZ2u4Ou7vAdG0NSHJGi7AUiKVVSf7D8ClkiRHadBNXIi4SjfHDS/MucrecVMNssqLneWvP/dCHs+XQYrAwP9kbVwbA17Yi35Q91XzbBvEtrSmdNa02609e7xXu/lVoe11egFA9qwy4XNHgbLaOcdHDtXlQIphOxAgJa0537Rv/FN0LLgkTlgoe5s+VgJER1pe/QSDrETDR8pI1Fmk5hMDAA8V6jvxdV/Zb1GbYqd/6Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(36756003)(186003)(6506007)(316002)(6666004)(54906003)(6512007)(6916009)(38100700002)(2906002)(38350700002)(2616005)(52116002)(1076003)(86362001)(66946007)(44832011)(83380400001)(5660300002)(508600001)(8936002)(7416002)(4326008)(8676002)(66476007)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XmOLD/ztj4bHr7Zeb7GuFNXB9JgvrMmqBXsrSKI4jLt5/qq6knVNDAEafPuM?=
 =?us-ascii?Q?yKEGylh/0rtr+xe98KX708L7l7jYh/NhCq1IMZ2xE3MCK5XkHNgnFQQgZD9M?=
 =?us-ascii?Q?QRd+NgRbY3POj4va9uU6gM1X+PfS9l0MYkeia6aUZLvgGADW0VvRa47DQfge?=
 =?us-ascii?Q?K6bO9oxc6oltch2pWvqTo9rCcATD44eCXdfFRrZADkZriRJ94jLzfe1NoT1U?=
 =?us-ascii?Q?DZguvBp1dvbxi/s1FkVzdsgc/h0dqQvX4n33HjiD9fCmwYwj7qPRkDbLF200?=
 =?us-ascii?Q?EHJnkBmXb8UKDk33HAtuiKLbktG5yK7OIj/adXnVNcSKb+USUqLkV98/k8+I?=
 =?us-ascii?Q?f7EeUyYY5j/tyc+qIIazLD7yiYPpsUph5W3sb2WxN/gQzHuNCTN/lUGbx5/M?=
 =?us-ascii?Q?0cq1f9bs3OmJtlsbPneEtzpSQWe/H0DDq8RIWoVf+8LA0kEFWse7f8sDOnV6?=
 =?us-ascii?Q?L+kkjMKt3Kwz/wxnsvTYURP8zGpZTrIFtwRwNYp5tRfZZQe7sEEdSqUkM3zI?=
 =?us-ascii?Q?izkcQLIcV1KifL4pMXaZTuGNhMrefNveIhh0+llftAw+9OzYoxwYA/E95luW?=
 =?us-ascii?Q?suDciTP5xJ99vCCHkvCLmJQMH/DApWaFJ77vrt8n/3N9NKX3V6mm6Pw2Tip7?=
 =?us-ascii?Q?ZhxVYsuS+hDWMT45fUoStXFFeidmA7Z1na+HhLDR1vnQXJeAaxrxPWgmYa5Y?=
 =?us-ascii?Q?vRlqsqLGJFVdIkTZIMTjUKInINGhErp/o8IT12++rZ5+7GLIa3OwHB0aMW/B?=
 =?us-ascii?Q?bF1vVAG3GowvL4UXTNDnZmwa926kXvEJWd6WgQncuZVnxSF1vJdbpJN8oUGi?=
 =?us-ascii?Q?9pJJssqV/12Cr9ZbY6AvPJhDjjyDJrLm3l1X/dnmnWlhVj6TabpmNeTZWHwv?=
 =?us-ascii?Q?D/Ij9GWtsDq1a2cPOj1fJ5dtZPh68nZmUtKFxnD66UkwT0HLhseMfKS+mikP?=
 =?us-ascii?Q?9u12eD5/2j3T5dMufRtxg+/+jgy/Y0sWGdhxT/8NH1c2RsWkKqBc/1zakkOK?=
 =?us-ascii?Q?SmuZuMdLCzE/PjNwJO4d5EfEOD4FmSXNslN4uOnZeljLEjoA23GKl2XHjzdt?=
 =?us-ascii?Q?KFu7daVXJkqwFJ3Z7XaMfGnldJicaXZ8OVnrQEMwNEdtlDaRkKcNd3dDrBOo?=
 =?us-ascii?Q?T8pEuX3kayH5Nvm1NVE7RizvOuu7+WoYz5WVoraKYp4R4R+p3OMq7B2mm3mP?=
 =?us-ascii?Q?l1JAu23Yd6Uy9gYJWuyzQJyM+Igkq6t51r9oAA9ix+Duky7CKYDF4loEB2Ki?=
 =?us-ascii?Q?1mStY6AM475KU5UYmqqauczHpyRmb+t8siRltkD+vEPQaCH1P3GGEZsvkGQp?=
 =?us-ascii?Q?D3pskhbv/eO+VXZpm/4cL1y9/avYbPnSi0Vdc+YBx+wfDBr3WVqk8VMw9R1c?=
 =?us-ascii?Q?EP55ILFjMY3WYkxJ/CJrqz4OeMnkTJ9X54F8ZHXDCgYz0IqoQ0b24eFLZC9e?=
 =?us-ascii?Q?xpTqPFFH8feL9J70DPikozE5/zO4zhlwy+OVlrt5aRyAgS7cIis6kD91QYD5?=
 =?us-ascii?Q?KBEFBQjYHToREVkXOjtTldHK6Xgk9VMOdSHA3EuogbxX3OHoPZw7WKk9u5RR?=
 =?us-ascii?Q?5RZ67F4fdrOzUhc3bNGmObkIh/S/nWMb+aYi09Ggry8CoKTYfS30oxA0UwgS?=
 =?us-ascii?Q?rqPeAy2MR1UDZFyl+2DasRQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1010e4-4f2f-442f-245b-08d9ea552fe7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 16:16:24.8463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NJYDLvlWRsVc4iDgLkVBqTYSGSDba/g+uxO0G5+Svgq2uVI0LjmyBD/O4qcXPwN2U9YbU5N4lLKqdxzi/Re5yA==
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

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The GSWIP switch is a platform device, so the initial set of constraints
that I thought would cause this (I2C or SPI buses which call ->remove on
->shutdown) do not apply. But there is one more which applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the GSWIP switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The gswip driver has the code structure in place for orderly mdiobus
removal, so just replace devm_mdiobus_alloc() with the non-devres
variant, and add manual free where necessary, to ensure that we don't
let devres free a still-registered bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/lantiq_gswip.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 46ed953e787e..320ee7fe91a8 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -498,8 +498,9 @@ static int gswip_mdio_rd(struct mii_bus *bus, int addr, int reg)
 static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 {
 	struct dsa_switch *ds = priv->ds;
+	int err;
 
-	ds->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
+	ds->slave_mii_bus = mdiobus_alloc();
 	if (!ds->slave_mii_bus)
 		return -ENOMEM;
 
@@ -512,7 +513,11 @@ static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 	ds->slave_mii_bus->parent = priv->dev;
 	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
 
-	return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	err = of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	if (err)
+		mdiobus_free(ds->slave_mii_bus);
+
+	return err;
 }
 
 static int gswip_pce_table_entry_read(struct gswip_priv *priv,
@@ -2145,8 +2150,10 @@ static int gswip_probe(struct platform_device *pdev)
 	gswip_mdio_mask(priv, GSWIP_MDIO_GLOB_ENABLE, 0, GSWIP_MDIO_GLOB);
 	dsa_unregister_switch(priv->ds);
 mdio_bus:
-	if (mdio_np)
+	if (mdio_np) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
+	}
 put_mdio_node:
 	of_node_put(mdio_np);
 	for (i = 0; i < priv->num_gphy_fw; i++)
@@ -2169,6 +2176,7 @@ static int gswip_remove(struct platform_device *pdev)
 
 	if (priv->ds->slave_mii_bus) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
 		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
 	}
 
-- 
2.25.1

