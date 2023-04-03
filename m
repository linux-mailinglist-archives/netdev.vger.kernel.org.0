Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745D76D54B0
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbjDCWXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjDCWX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:23:28 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2049.outbound.protection.outlook.com [40.107.104.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3FC1731
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bHprMoVty4+/FMhxMH/fDeVGdeO1hZItmVVnpRLXQcCGEIqgGlqpn+V8LYaRpnYmPyrPvdhqLlaOG2VpoTbS/WgPxGSLqKPiDVg3dBfa/jfxWXKPqbpLMA22ULbziKwz1zh5WJU18ZIDKecbLhl3pQcHcxLv7azRO/DL/X5YUQOt1IdLERXSQZrfmnkQxUCsO9c6YF/GtiMPvHLqHxnEDnVeDTj6QLoWhJeDMgb7NVkgCh+vIahW+s47nKdxwH06uoSkPQR9+iqRovrjsInFiZTTYTaUA3Mg8GgYLQoAj2VICbDea8t46yMBSs1hJGtXIdZWXK9dcKd8vvIuYFKmLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqoNz7zn6jmX/gu1WLuTdZVbH0egyGTytQBnBlMv13c=;
 b=NaqxvT45WHAVG/mCkHbEYoyh206zxvt0RGXsN5F5R+ruhpWeZpsODo7luAKA0Nr1LAGDN6/upf0gonvQ6pTZ1RQ3ENoxXmXjhcypnWXFZh2NgCxnfb9raxXwzpcTFnJ/+Vt5aw400kDhj8jxN2ZRWgUjjskDAoh5eYaZDr3uSiat3EIHarVlKTnk0RHbCDmHWNIhmCtkMOhWdeink4n+VXlMcoHPXFuJ2mNGiiuRLtnKfdPpLvJxd2FIbJuZvfl4UJbjqbxNY1gWit2ZOj+MZtTmK7/TkIeEJIrKfL28KgQ/Svgv5ze+SuoFWOHSHhvYVXnCOzAtQbz9KCYs07ndAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqoNz7zn6jmX/gu1WLuTdZVbH0egyGTytQBnBlMv13c=;
 b=kn0a+gr58m3gjFPulkKY3xUOSi/8JRljRPhlrR/GJlrTLFnAgPu1jStODY7pZls/BMbSpeQU/3qfQQGoIJOSkeXggms5MIzFbKLsUwMZm7YlukYTCqxz+xMQSAtzaMEDAij/QHSmCW3FUu7SnVoCB/PsBWqlmptepFAbVgcicf0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com (2603:10a6:20b:44b::7)
 by DBBPR04MB7786.eurprd04.prod.outlook.com (2603:10a6:10:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Mon, 3 Apr
 2023 22:23:23 +0000
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::f829:2515:23f4:87b5]) by AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::f829:2515:23f4:87b5%9]) with mapi id 15.20.6254.035; Mon, 3 Apr 2023
 22:23:23 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        imx@lists.linux.dev
Subject: [PATCH v6 1/2] net: stmmac: add support for platform specific reset
Date:   Mon,  3 Apr 2023 17:23:01 -0500
Message-Id: <20230403222302.328262-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::16) To AS8PR04MB9176.eurprd04.prod.outlook.com
 (2603:10a6:20b:44b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9176:EE_|DBBPR04MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: 45e9e7cc-b669-4e69-3c47-08db3492097f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zGRHnRO+uC3xl8ZBNmcZbr1qHRQFYUmPmqdUDVY14IlhFXJMR8qFACJ3lEDzamYLLqh5wZGYFp6U+uye14a290Ci+WHfiF9v2LgaURb6TPYlq7Os76+FoSpmsX+/0ZMfQZjzE1mka3TvJfboW7F0dTsI1USPtEmdiIN/UirYfBLNy6hGZJm0fYw1ZKJijoOo7ZyRjtgGn/tdprNvjfat3TR9ZPJpMXE7r4IOQhTsRZ/sP7wCj0SbUTO7zfrcMUiBSi+nn/4Ln4uyLdlgv5gEZKWBU7q+IxAGmZVBH1HtdT09JUCFNvZHlNlMnokYnIybFkvUuQEumvc+TBmdQ+O3oH5A3zgh3lJ6NtJdOhYJdru2pmj5tk3UEqilo608TjRzUOCVTtjAk0wV+aZTPnuH19HOOvUpfwgupXO+pqdYRvhn6tIpVCVn5wVE9TdtnsJTURo4v1c8g/SFAVtU5wraPpMygC6uBfhok1+I8OE+9p4OhMrGf3IhxDcxe9YTaFII6cqVqSpV43s9/5lU0P8WzWW0SEr1D3tb7dldx8KiYnlIXorjllHd3JWDOQxpnicNqG3lnWfArwwP6iHnfAvK3bIjmmvTcxhgMywHFTznejoQufZ2pHUwHle4TC47lz9S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9176.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199021)(36756003)(38350700002)(38100700002)(86362001)(2906002)(52116002)(6486002)(6506007)(26005)(6512007)(1076003)(55236004)(6666004)(66946007)(66476007)(8676002)(4326008)(66556008)(41300700001)(44832011)(54906003)(478600001)(7416002)(316002)(8936002)(5660300002)(110136005)(83380400001)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+iArYfs6gvSuQof0u591V1LR8s3odUTWM1YofD1IihQ6gpEKb6TyOlhUBXd?=
 =?us-ascii?Q?oZLm1B/Tm15LlSGh/XE7b70hcojuFEtEK+4DgzXLEAES4Rik+rC3gM+KxsXH?=
 =?us-ascii?Q?0NLTx6BUTMymmy/1W5C4T69RBaJOzRXegwhoQ9yuHHqC2+ZFd/sqBkq29VNh?=
 =?us-ascii?Q?8K/6o79UqiHyNW7YjJxlFPrlo9jUHGhE3ZFOZmqQEViP3cgP7bFQXMfAYmxU?=
 =?us-ascii?Q?P43AlTRINtHuzLbOREgS9FldhIgCHQdKgZncf1Mfiw1/tBq9G9LdZHvhyiqB?=
 =?us-ascii?Q?cQM3Be+A1YW3GtQB+Srh2/Nb1bj7CAY5/qYHZmyixnifJe2uhPWq9FTXqzGz?=
 =?us-ascii?Q?rrVB4uIb7a03yLIpA+PIOkz+cv+AqPXfwiFr64kk90Rb1fITDlhLtnZHkxd+?=
 =?us-ascii?Q?4nt1HuI42aF7A2Ni73fsRNFZYSeElGy8I2LIkZQiz0BADPav4VI9jqK6eGAP?=
 =?us-ascii?Q?tZvmflfySmzFsBIB7dQi64x2go52rxmzw/VzpQ7Pv2H5E8Ca508Vz3D+PM26?=
 =?us-ascii?Q?1EVGaEiDSmvAtbJEyLbgseBA5jBrO+ClCAg9zPWGJ8WDtkHUg3fchDUWRtXt?=
 =?us-ascii?Q?D90bzyDB3bXeA/lU3+Y/PWI90ZOT5pZBtL3wuHYOn1fbBdw+0ysIM112vV6e?=
 =?us-ascii?Q?Qli8EdkCdTedJ//haHioISREZbN/lEF9CatNuM7v/iD+TsnVKHY3mEkvP8k1?=
 =?us-ascii?Q?ICHqG/N/0PB5ncQnjnx5yjT0bj7GZaWZF3GMemVLvtng58LCs0nWFfszFQLM?=
 =?us-ascii?Q?9sys5QoMqpojl3nl2kg1WrtLQJgKm9ux0u8cN4xlN9MLJX5MRHj8SJEtKHN/?=
 =?us-ascii?Q?0alpeX5bQ57ww0N5M6+5Dm2bgnIRpqF36X5M7rrGwxbls5Y1cnWXALR4HQC0?=
 =?us-ascii?Q?Rkt5P8Rvm4Cb+IZPi/DeNPxAY96DG862ToD3LLGTJQBtka6R10qfZ2gOvvvA?=
 =?us-ascii?Q?4pILA3kLYelipUa7lBLb3Bfh3nIf/CoK4y4LJ5k33LdU2Wlbq5sJ49+RuEWe?=
 =?us-ascii?Q?bWgl2iNDRtt/bmd/Js0V4we6RsRCvhCZ+5Fbm52tg6jyxX27D0xYwzJSoM++?=
 =?us-ascii?Q?vaszICb/s/PQZoDeoEgM7A8DRtYVBXl+Bpc4BAZ/EGB6Mgav+0RGx+TH0j5B?=
 =?us-ascii?Q?D0sx2hO0+lJF2xsYGyRDTtyvCFjsgGQ/wMKf7pYdJhUWFTh53a/cX1XXe35+?=
 =?us-ascii?Q?cvYCw5k4FjQYn4ePNGAXAdC9OqvC1Ic6AW+vs01KwL0N9fa6Ym3GCbXHGgH7?=
 =?us-ascii?Q?Hqjwpsd9ywvgDZYmBD/YqXcMtDafjipo8jrekfBw42FOIef5QOGIBEof+cyr?=
 =?us-ascii?Q?NVGyw2UprV/hla5u+eYkZysOUn6qWM5XILNgY9B1l658UrIcGjq21mFftjPs?=
 =?us-ascii?Q?sYm3AOboQ6DU4KBsCOZ1aOIqp9qz5Et1xpDs2a9EQ3P1W0qNlrEs/xT5hYfI?=
 =?us-ascii?Q?Pr9Qu/LJ/oqNSA6PHfKgLIoQ2XwEDL7TR6vNTPGJarqoNPKe/rJqD0XIFgeT?=
 =?us-ascii?Q?aaHFoliWHWxIQOLohX4JRu3SdB07JcSICfBAklKbLlnGP5bl76QURHQbBhW7?=
 =?us-ascii?Q?zwg+qLdUzaR+JCtkFbaFrdZ59aZYLD3oYsBupcNA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e9e7cc-b669-4e69-3c47-08db3492097f
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9176.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 22:23:23.5270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4VEBcLov12mHMPOo/HVIGOENYHF/Ag5uruZlL9l2buEXuQ2+aOQje5Mwwg3mIAbOErm3rNLE5OnwlCniD71cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7786
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for platform-specific reset logic in the
stmmac driver. Some SoCs require a different reset mechanism than
the standard dwmac IP reset. To support these platforms, a new function
pointer 'fix_soc_reset' is added to the plat_stmmacenet_data structure.
The stmmac_reset in hwif.h is modified to call the 'fix_soc_reset'
function if it exists. This enables the driver to use the platform-specific
reset logic when necessary.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 v6:
  - add an extra condition check for priv per simon's review.
  - reorder the local variable declarations in imx_dwmac_mx93_reset
 v5:
  - add the missing __iomem tag in the stmmac_reset definition.

 drivers/net/ethernet/stmicro/stmmac/hwif.c | 13 +++++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h |  3 +--
 include/linux/stmmac.h                     |  1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index bb7114f970f8..b8ba8f2d8041 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -87,6 +87,19 @@ static int stmmac_dwxlgmac_quirks(struct stmmac_priv *priv)
 	return 0;
 }

+int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr)
+{
+	struct plat_stmmacenet_data *plat = priv ? priv->plat : NULL;
+
+	if (!priv)
+		return -EINVAL;
+
+	if (plat && plat->fix_soc_reset)
+		return plat->fix_soc_reset(plat, ioaddr);
+
+	return stmmac_do_callback(priv, dma, reset, ioaddr);
+}
+
 static const struct stmmac_hwif_entry {
 	bool gmac;
 	bool gmac4;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 16a7421715cb..1cc286b000b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -214,8 +214,6 @@ struct stmmac_dma_ops {
 	int (*enable_tbs)(void __iomem *ioaddr, bool en, u32 chan);
 };

-#define stmmac_reset(__priv, __args...) \
-	stmmac_do_callback(__priv, dma, reset, __args)
 #define stmmac_dma_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init, __args)
 #define stmmac_init_chan(__priv, __args...) \
@@ -640,6 +638,7 @@ extern const struct stmmac_mmc_ops dwxgmac_mmc_ops;
 #define GMAC_VERSION		0x00000020	/* GMAC CORE Version */
 #define GMAC4_VERSION		0x00000110	/* GMAC4+ CORE Version */

+int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr);
 int stmmac_hwif_init(struct stmmac_priv *priv);

 #endif /* __STMMAC_HWIF_H__ */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a2414c187483..dafa001e9e7a 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -223,6 +223,7 @@ struct plat_stmmacenet_data {
 	struct stmmac_rxq_cfg rx_queues_cfg[MTL_MAX_RX_QUEUES];
 	struct stmmac_txq_cfg tx_queues_cfg[MTL_MAX_TX_QUEUES];
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
+	int (*fix_soc_reset)(void *priv, void __iomem *ioaddr);
 	int (*serdes_powerup)(struct net_device *ndev, void *priv);
 	void (*serdes_powerdown)(struct net_device *ndev, void *priv);
 	void (*speed_mode_2500)(struct net_device *ndev, void *priv);
--
2.34.1

