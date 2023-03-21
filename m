Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386356C39F4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCUTJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCUTJ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:09:56 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2054.outbound.protection.outlook.com [40.107.15.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F73E5FF5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:09:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtzWv5zPdBRLGZspsxTRUtdhE7wKYFTG9jFBbFraEhSWM9uf2rhKiYuWlaXrcEt9jBqPohZgFaxpQmk5pv8yndZn7MqC1xbPqbDXIHMtwmumDn2Q0TVOh6A4InTZzCMpecZtuDwIa6H+L1UWHaVra18YgKvoOA07RReejgYi6lOmTQY330rHNUFsjU5ryNq7QHgMvkTdG4+ogYAsRhjlYzgCZ5CAyf3mkj9FhUtYL1p9zrZj2nTlbsZ2nthbUpJv/5p/sLd89j+fr82vEPBlfDncy8hruUBrkdE7W1lsC+Z/cuWkezw8SiiwigfDBYZI6GuKorGg89oa6mQ/G4XmTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NArNsxQrzAgNBIxidYUKjAbJZL8hVbI3rc9qmA8OpCQ=;
 b=ViloyWQfbLhSfvLzroQu9PyJGh8kBYoVUNRvVZrRBVoI0i3RWo0M7c9P1MEULbhBcoofWkIOGJauwf+mMA/wqQQOs/A+jSAdHVnrtLxocbbEOU71qAU65hOSxLUbLXlNJr2VNw6Qk7tFMGTLrW4jZQJFquwQJNhUgjPOSsOyZ338OgQLjaICWxILYE0dWZo03HgSe+wigxXMmGoQhE0/TCxWnUN20P7OuaNIoAYwPv6+MJ+EYpKjmF0CoDTnxkX/ec+GbaAK5/x/1Ra41CDlBgx/QOD2Qvz6OhKc5ieekCT/jkwLxY6TcScpFsljyNuX5TT61o9vmDdICuJrN9mRyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NArNsxQrzAgNBIxidYUKjAbJZL8hVbI3rc9qmA8OpCQ=;
 b=WVGOW62HodUmtWigTjil4XucuAZRrLOpY3ue01SEC6E5480GTmWN4bdJfxZinRiqnGsMeAdlsRDIeVm9bo+BhPYqXB0blUWYWrMIQVILQrB+J/UucvDySVcd+Jpf4FjLggysrxO/vEYG6etZ9Ti0+iF7UScoRRRvRcLciACZ2Pc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB9PR04MB8348.eurprd04.prod.outlook.com (2603:10a6:10:25c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 19:09:51 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::31d:b51c:db92:cb15]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::31d:b51c:db92:cb15%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 19:09:51 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: [PATCH 1/1] net: stmmac: add support for platform specific reset
Date:   Tue, 21 Mar 2023 14:09:20 -0500
Message-Id: <20230321190921.3113971-1-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0156.namprd03.prod.outlook.com
 (2603:10b6:a03:338::11) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB9PR04MB8348:EE_
X-MS-Office365-Filtering-Correlation-Id: e1a121f0-386b-4d0d-ee6c-08db2a3fd89b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vce9/YT4kChBntn9aHxvAuZMm9cgY0SdPobonqjcUyHCqMBmX5R8DIPkncqdlAfnCnI6FTj5/AfJvhjrPQekr5WzQXKkSS4xe8zAEdpK4sjzxMsYy7r5LxtlaZrgLgxzeobUQ7H//4luiIQY241sAurHWDsYVRYhafaNRs7r4JTh1zYn1AFkAIHIynUAfd74C+uIYby6WBXZ4hQNdC1x6LnJwe8TYqSk7JhW6uRYg6TmR/W9WeeFxJAvxQniUTPEHaewZaox9Y7oFzvGSKmU4Mv/LonfEcMaZ539RCY33KiYLKcGqbT9fqsDETB+7eQKYy6o+rS05P3aPBEZ2yY8s+rxogBzyVuSNzYDKelRvSZxMYM6r3jAH6WTjzWLMn88R4SrjsysnBx6oL7RntTjCOzBifFwoqnBXBUGTQ+vA8+lotfwov4X0XycUjbKJnrBtq5S2NmodjEqGXsdRTDEXdvDpAtyQbfsSisIp5SaFg+ZNhra3csloVBgSJQEu0Omi8UF/AYmHg0zXCnDHQwmUk3AioKFwVGwxcsRXm2k4hp9ppu77wPdSkW15fmbAX09oHJ9TIL4Db+6NWi1bTfnQsNfsWHNrdcOhuHOfNBcspWMCymOqjFAni22Zi1/GVf400NA3SUfsDzS6Ju/ZCEoA8VU+bNMUfWmkbuibkEJPlSZ/pL5u/LxxQW62O4d4AsHXBhGJS/0Ba4kWaToqyWAiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199018)(54906003)(83380400001)(2616005)(6636002)(52116002)(6512007)(6506007)(6486002)(478600001)(7416002)(110136005)(26005)(6666004)(1076003)(55236004)(186003)(5660300002)(316002)(44832011)(38350700002)(38100700002)(86362001)(2906002)(8936002)(66946007)(36756003)(4326008)(66556008)(8676002)(41300700001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SCNLfDgnhjwaszlePoWVxIMdTDjasdky66UHI13YU0Ru0WLJL8RGtriEjaQ6?=
 =?us-ascii?Q?rqz/DCQ9hc4avR2343cEuZY0AGOu7aZbatEbljz8EwevDh9mqSVoau35/Y2Q?=
 =?us-ascii?Q?n9al2EvH4W6pFd+ImDbnSUULEeSBkX0azf2FHpFqwXMcWLMHlY9WYZT0/a7M?=
 =?us-ascii?Q?zNzGrR7nSe8+sa+SY2L3ws/KRw0IgwDXyePVi/tyRVNcQ+japj6Ly5FwRC9z?=
 =?us-ascii?Q?o4AJ3zOVbXsEKIaVw9ZOmFtg+eOvKlDlpq8s5Wr01UKASwJ3VFgJUs1BRzQO?=
 =?us-ascii?Q?QpYdVGtDro4B3BVNwKM6ve7GNjESyfHdf0STBi9lEnmPMUj3OnXrh+ACFaQG?=
 =?us-ascii?Q?mtdFv0NIrAU8Y8/M+owXwIceWIx3Ty3pJyuYmZxZpcBFSbYVeuD2YZBApicL?=
 =?us-ascii?Q?ATHaidrH45fcinkCI31pe8WAUDGazV2jRnZK1L95C2TDiD9sxrYfFm5mnsmp?=
 =?us-ascii?Q?Rac3nqjzkZa0xfDV3lAo2haM1XGwPdJWJTe42xaKU41MzTfFGnkFhUwhKaJz?=
 =?us-ascii?Q?stv6WVinSPtFV1C+px6NiNQ204+6nsR/uPpMrq366EOLDziNVf8xguZusNCp?=
 =?us-ascii?Q?szdJei4yYA/WzKtGiyyqTQhrdvsHtX6OMtETTRkZlrjAySzBs7GclCYaaz4q?=
 =?us-ascii?Q?8esgjg+ZK7DGUILsbeoKniPrCHMN6yiL7PbnnxwNFUblyO9PXSMBUQL1xDpj?=
 =?us-ascii?Q?2V0PQ698jkOoSpSipYBdD3iHMTbYfnQSqQXeREe9ROQinMLlsE/1QGG004Iz?=
 =?us-ascii?Q?MTuszNtpjfIlyVQmSdertNAx64Ch15LR5TazjvKzhN2Ac2KIi2sloi58KMAA?=
 =?us-ascii?Q?ttRaq7N2kB/5rdsO0qSn5Rz85GXyox/HE1bPKOSOF3XY7YEkG5Ws2t18q8OS?=
 =?us-ascii?Q?HcV2NVOLqgfPIMzNrqemf7JCbAxZFtQ2d9or5S4xbmOUCsC8e1IVAvYlY5pf?=
 =?us-ascii?Q?o27I9UuB5mfrQIoVq3l8n98tQI53iZrqxTuYQnOBcoGDC9wTwYUFxvFBunOA?=
 =?us-ascii?Q?97tK7CM1sISoGSP+6M58HqeO0Lw7/sFlyUuQyducUTcia9ZpJFIhqZH4nd7s?=
 =?us-ascii?Q?rHIHVZKNxeUl0/P9n/sHO2VNGLsQDv2/nAFdxHQ31JJDJ4ESMS0XyF/9i+gN?=
 =?us-ascii?Q?IClX871CW8X9fT183HddzY9pI9BJmzgybAK44vbbUcZlVicHbGAKAJTmS8hk?=
 =?us-ascii?Q?DUWg5F+d3goijo6l1jd7/poYpE3QVMc14MIQbso/bD/ui0U+8HZNbgInRgxb?=
 =?us-ascii?Q?JTIF1xgnMIdairT9HwXWzODAOmSVl/CNZec3M7wgnJTwRzCRQMJeM/96ig6B?=
 =?us-ascii?Q?7B08vzfPpfLYfAmPeSlreLs0RA5ILvWzCGR2ZVhi3Grrosf90bqcjmzsbzCV?=
 =?us-ascii?Q?r4VTM1SIZ+RM7SXvIvElrYU1OhsOcdA3koMZ+Gg310NaqFe2STiIBmizPCk4?=
 =?us-ascii?Q?czvL6rduD+5LYeSAjjDyA318YEDrpty57dwVuOOPDRwR67PFfm8asd/jVLt0?=
 =?us-ascii?Q?LNArw5Fcp1DA7FMR4lW9o6uyWxg13C6NiDG+zHfHB4vXRf8LY1DpNvkzRSqC?=
 =?us-ascii?Q?NYKBUvJY6o/lj572ii/2KNfDKltIONQXQMw1odlq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a121f0-386b-4d0d-ee6c-08db2a3fd89b
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 19:09:51.3629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xAQuwBoiQWOjuYw2eQ4Y48hg8uM7/0epXuKOuPYKkE9dG3ACZI48rAblX3E+YJArjf1/uf4ezfxkxV63EOyvog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8348
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/stmicro/stmmac/hwif.h | 10 +++++++++-
 include/linux/stmmac.h                     |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 16a7421715cb..e24ce870690e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -215,7 +215,15 @@ struct stmmac_dma_ops {
 };
 
 #define stmmac_reset(__priv, __args...) \
-	stmmac_do_callback(__priv, dma, reset, __args)
+({ \
+	int __result = -EINVAL; \
+	if ((__priv) && (__priv)->plat && (__priv)->plat->fix_soc_reset) { \
+		__result = (__priv)->plat->fix_soc_reset((__priv)->plat, ##__args); \
+	} else { \
+		__result = stmmac_do_callback(__priv, dma, reset, __args); \
+	} \
+	__result; \
+})
 #define stmmac_dma_init(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, init, __args)
 #define stmmac_init_chan(__priv, __args...) \
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

