Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 034846D25BF
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjCaQgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbjCaQfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:35:37 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE02D22923;
        Fri, 31 Mar 2023 09:32:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSzZh53HkmvG7K7OgJ//T4VMselaKGH3eFhP164I5gW9DDQ6KDdVPVGtUPbUcFz2XuFFnfyLfkLtXZNihXCsyLeomZ+QwWD77DA0ixnt1aVJl4bcBGKwf/KZt/uQZNQVtNCgUAJB//R0vSfGUcx9djRURczDy8NepBeJQM8z81YheThCRYRxpHoL3tpJSxxZUTQgT5kUI9nBpfHQ0MgjREVU5mJp9g/iOnGsC5gK645vCMrxQ36PLGagkIiw7LUc3en6RibrRVmj1W11AVdmXH6bfcxfoV2iCiIIkZfJFdifmgLddNz2MhjXfREJzyWJdod5Qn1eWOCTuQ35GHcwLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uR6d0AOWvtLiSX9/sXhFUbQrY/UmzvZ18zgbWJkzZqs=;
 b=FDalpYYtq7cNFX7dLIcLdAgv9Rf1AIzyPtz2TrU0IhW9tE+tW8s1LdU6Emm5UOf8FjEjp3WafmUt7WAt83NwA3QjFKVA6a9Y+8gcF6TNEM+r8d2ip5Z7gQLL1t16gZwQajxUzbaQFyov9uJFuAbdOZIn6X8D44DSbLjYIugN5PLcnlpT4+YZKm0AQqzSDfyz3mAuQ8NMGBeAPJoLVOYf2lE95G+ke6XDoGJxDLXD0pa0zx0PloZFYlolwDwEQl3Oq8RPmx71LaLq6ky8vVVcpG7G3nBc88E4wlzoX0I2z8lx7kzL/AdlRZ+RJ/s0YJNNJ6DCOshPlz24lxlltaf/nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR6d0AOWvtLiSX9/sXhFUbQrY/UmzvZ18zgbWJkzZqs=;
 b=Pxm3Gk+Bd8lcMxxyzrrl43jcruT28snIA02gfDPNXjk/mMxP2zLnIk+xfsiD4/TzXcP/5Y15CLAWhhRi/C5Jd38w1oM/fq5vrV1mb4jv77CmzFaqYJ57hFmHwVg1Q6Olrj/+malx5OdXPpzjXprLtFjubvjVSTycUe0DL4laajE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by VE1PR04MB7213.eurprd04.prod.outlook.com (2603:10a6:800:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 16:32:09 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 16:32:09 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: [PATCH v2 1/2] net: stmmac: add support for platform specific reset
Date:   Fri, 31 Mar 2023 11:31:42 -0500
Message-Id: <20230331163143.52506-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::15) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|VE1PR04MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: c1f7d365-bcfe-402b-a490-08db32057896
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jva/LY7BrcwxKaTnPvRNCJpTv2pNnIB8BTS2T+nkB3Z3hWY6wHTEe9p3APgabXjQqMc3+M7oLfWX2/zWxqdqddPGrDxtii/c58AGUOgonrgUyI6xKbe8qqzvsC8Fp2qHNXnyR/5KS0/gMX5y/QRso8B/0oHn6tlTG/hkNEgRCFSHQHYcfLQpP8EooZUpAlIT3tuQWLCgpw3zRzBALnisOrN3l2H82fb314Wl60oo2Qq2ye7ywF+FmCGv1nXzeRCL7tEhIswlO0mAhtsuoEVNKtngMlOQ3QS96HVZYxBFSPul+eUcNMOO5QvM6YOd3atEuZkl71HapzsecP8A529lrvZf8mGFy2lkvem1PjhEZkIYwY3t+DmekclLgqQL7zbmZQc5SocE5gOJlUl+j3f7XWaMRV1EHktFKuUtnqQoRommSJMhqGnonNuSTX/yXa6bZ+jxh6ADlus066ut32U2fJMjy/m9cy01rNE7IHA9z/qn3SON5l3QZlBR7ICVbHBvShchUVqZKRqjQUgBDb9Kdhvb1r6W0cHL5yas1cYYNIiHDSgylXtw9FKlAM04CrSiLvX2RtBuiXaU2Op/WwTsV/vSmGGJT1WTX6l1Z1A8ZqXjwqY4bfLKEJvqJHdcmZ9e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(7416002)(44832011)(1076003)(2616005)(83380400001)(6666004)(86362001)(55236004)(6506007)(26005)(6512007)(38100700002)(38350700002)(186003)(8936002)(5660300002)(478600001)(41300700001)(66946007)(54906003)(6486002)(36756003)(8676002)(66476007)(110136005)(4326008)(52116002)(66556008)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifm6RgLClBmtlAcHad7CbBnhKTtRe60nA8Yhg8RdGmgT4MZsrXSIjn5oTdbF?=
 =?us-ascii?Q?EZ4IGwj4r3gGo5r3Uia3U3WeQNLYWTsJKpTXldCEzFgsAlSsQrObbDYMckya?=
 =?us-ascii?Q?YPXQ4rM50D4ksO+m0OtU1St3aZbpQdmE2T2oM3oi0myMMDpzmlxYEQaZFhhj?=
 =?us-ascii?Q?23H5Z/ELqan4zowmXL0WXGSbzFvqhejIWli+AzqTJl8BOZdyqW4BuNrQvb7O?=
 =?us-ascii?Q?AyGeMfw/7Q3mkbHGF/0F9i4PltC3mpiTEDB8sZ3qvWyVUnm0mOHgI32Q/47j?=
 =?us-ascii?Q?p60WOtO6n2pkA1s0hS7HYMsYXFqskQLMCOJlQuLtmvgN08FSrU1uoo6UgcdN?=
 =?us-ascii?Q?7VIZZ6MavL1TzD1gSK8UTLMZqp7KliP3XdQV/B+dWcgdCxtwVjyNc5WsUk5N?=
 =?us-ascii?Q?G1/44d0SY3wrsQRlMlAJwh6+QAGDhAAJDiLjM7oKuvf2puTZMrxq+Vt3NStI?=
 =?us-ascii?Q?Di4upT3os9ACtW/csYhcpU6QGsmCIr3Xlv/6p8xr6ZmbOJt/x5oEDvLUHKNP?=
 =?us-ascii?Q?y66S5WACkYW/Afns/Zw72+ziGJf44jvD55MiK77Adm8i07j1vI/CcL4tfii/?=
 =?us-ascii?Q?6w37xmvANw28bU8fftKxNWbUeTc0kNjhkQnZU7x4l5qx0woGThf1vf0u+Eiv?=
 =?us-ascii?Q?qV1odZYJsOZQVGV5awDB5diTxCkUcYLTov/nYCl1m/aGecDkhCIvzmHS0hdW?=
 =?us-ascii?Q?f612UbGcDQHYi3vPo6AvLpOcU8Zh4SxU0vDuXEdQi+P95c/1Jm/0eI4fPeL1?=
 =?us-ascii?Q?YXicw5ZJDVi+Ozdxea0iFM4QR2QtLP5FRimg3RyWkDDvPiL7UDawLxdJfS7l?=
 =?us-ascii?Q?quI6FvNTVlRkHfthMWSBsGsVlywwYcGXn9W/LrTNOaiAXo52dwamJiZZZg9J?=
 =?us-ascii?Q?Ue2c6fXuv7vEaOvaudVX/GbndfN8fXtR6uZC+MhyWW5Ux/3kTBXmT+S4ds0s?=
 =?us-ascii?Q?+pZad/6jOtlfhV4F29fbK73RiqwnnugWMr/PsmF3vIaVgx4cOcJafha0VN5S?=
 =?us-ascii?Q?aqPaJiNOwASAf393Fuxa3OnDjUzOKQOjJrgVg/PH8TPdGsBRWp6hH4oohMJE?=
 =?us-ascii?Q?dV5pib0HRWyvBBbdffkdS+Wwfq9fZ9ElpFVcXmG1rMm1A7iOoq3EWT7RaiC8?=
 =?us-ascii?Q?hd1BEhzfmmIc7TaaCxZHDyTyD1snEKsVris5L32lqIMhfCnSPfKeIuSWsLkA?=
 =?us-ascii?Q?+zQrTRD/arbt/Y7TpnIB/QItzD9dsxCpHyLsxIJtojywxI4am07cgbD7BULC?=
 =?us-ascii?Q?UGPzNauWh7zz7m8odUCt7GA+whpvUERqX5Us/c49FTr6wb9J/9oGYl6KVBNt?=
 =?us-ascii?Q?BbopHT+XtVQ3oJy8YYseVT2JkZ4cC2w7sfpcFhKt1LO7qzoIFVcYZI2ToDv2?=
 =?us-ascii?Q?cjt2iVCQcn2UyigW2bjXPTlCISnEONJZ+ibmIB/mjtHkjDUuaYKACuB0yw0x?=
 =?us-ascii?Q?pXe3i4WBNYa5PGnxH5As1eqCE8ZsjStj9sHTs1p9iwMmXNw6fXD2pd2XcSPR?=
 =?us-ascii?Q?AwCNnrKAujFbpXSkXyynDEX37CCK5PyIzMieaYZ0dqD24m4o2oJEi3cMVxN4?=
 =?us-ascii?Q?x6KCySTTgo+nVWu2apv/hHtUjy044mhFtQDiyOek?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1f7d365-bcfe-402b-a490-08db32057896
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 16:32:09.2489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I4AePp57Bi0oJ3K+dYz390t9gYnVPZlHUeqizDaawzaTXg53f/xhg8xN55z/FVFYW11e2elx4lgO4rZbKyZVxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7213
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
The stmmac_reset macro in hwif.h is modified to call the 'fix_soc_reset'
function if it exists. This enables the driver to use the platform-specific
reset logic when necessary.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/hwif.c | 10 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h |  3 +--
 include/linux/stmmac.h                     |  1 +
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index bb7114f970f8..0eefa697ffe8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -87,6 +87,16 @@ static int stmmac_dwxlgmac_quirks(struct stmmac_priv *priv)
 	return 0;
 }
 
+int stmmac_reset(struct stmmac_priv *priv, void __iomem *ioaddr)
+{
+	struct plat_stmmacenet_data *plat = priv ? priv->plat : NULL;
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
index 16a7421715cb..47a68f506c10 100644
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
 
+int stmmac_reset(struct stmmac_priv *priv, void *ioaddr);
 int stmmac_hwif_init(struct stmmac_priv *priv);
 
 #endif /* __STMMAC_HWIF_H__ */
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index a152678b82b7..9044477fad61 100644
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

