Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721096D5198
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjDCTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbjDCTvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:51:49 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2120.outbound.protection.outlook.com [40.107.237.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF9630FC
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:51:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZRuiSL2f6Fej2DmZAieeX9awMPuExr7nmDDiTVq4pPF9U+ODpRPnVF1crEJBt/O2Yu6kJ1Qb+/O0Wn69KGshDHzGsZJLE5huCq1KBjGAwzO9+dvm2g+cSCA7fJnw2Lpvk6JrQiDuOSX4g/eIgi24VDHZoz9CMxdmzb0EZJxzGABu/+/uA2dKhDor1Vr9ke14gGo+TMFCEwE95/OElJG/lOJryI5sKOFztBiSUqriMoRduve/wguMJYeksoSeXz/VKpqpGouvKHyLgWcMSgscUNevWa1d5+Kv5YWWsFq/BcwV+g2f+SswylU+EZlPImB9uHnrSa4ju0Kqn/RobvbYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpgLzJK4cnQXaGeYevChFgqCyJbTelxMpRzCH5fO43Y=;
 b=Fsfv9KA5FyO4cwlv7AcTxNvSXwxQ2UHORspVeKBGevfWAiUUVYDFG3xrlpStqETS2QKZqEwr+mSm1/2IdeWMOeFTEFfOs5PczshNWNDF0VkefuQZwCxKHuu9lHxrvc/zD5teZiuhRnQNwIFxRjuYnzHsfJpnhAT91V/F9iXVPNJX3lvFZG3ZqtB/7Y26zdkILA1MJ3ljNaVqeKT+XQpCjiCxpuYzCxxRg7kQaG3Sl2S+maZDsnkitZKCkqrWM9DjySKXR4MGhid44J8CxmpTWRfmNFFDha+6cEVZzPKmwpRf9N+a7MbNgaULqqXqk/LB08Co4fNGSreigeGLOHJ2gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CpgLzJK4cnQXaGeYevChFgqCyJbTelxMpRzCH5fO43Y=;
 b=uf0bq/NQ3RRibKtQFAR1BdvjwjD9VAP/zy4lXiiVMR/fzfn4IcLRHx+MwQ52ltw3yrrf4B0OxJCwlw/vJD+fM8389lz3Uno95iO3dUPOS6AQBGP+ONQBwOeW7oLDL3057huJqd6nzOBTlXjdEFy89VKTtJocoSRG3nT4sAFuQTo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4882.namprd13.prod.outlook.com (2603:10b6:a03:36e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 19:51:42 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Mon, 3 Apr 2023
 19:51:42 +0000
Date:   Mon, 3 Apr 2023 21:51:32 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, imx@lists.linux.dev
Subject: Re: [PATCH v5 2/2] net: stmmac: dwmac-imx: use platform specific
 reset for imx93 SoCs
Message-ID: <ZCsuRDDAmIj571wl@corigine.com>
References: <20230403152408.238530-1-shenwei.wang@nxp.com>
 <20230403152408.238530-2-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403152408.238530-2-shenwei.wang@nxp.com>
X-ClientProxiedBy: AM3PR05CA0092.eurprd05.prod.outlook.com
 (2603:10a6:207:1::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: 30b33b0f-e38c-489e-759e-08db347cd8bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZP2NqlvcqkVLOnq+NlJrIVlm1mN02m3ZGTOgCxHWAbIIYXxds5OfmQCz8A3MENuwo5odyfZRZxKQfdV4dr04epKPMQ/7j55CVhyGNEvy4bahzEIqRCYvj3FLEyGUU6GLXMoOYsGHJjPZZdEpNlZ6T3/3A9meL7MMoeWJOvAIWmg0XXt4XRHUPdKX18KV6Bt5Q7elauxuSOmWqaVbjPVAXIYsragSDDQ2mkV7X26pF8TEjg3I+p5IHXegbQUt4g/vKKwJkk77Zcg4IW05MnDa+c0QBTZIS0uqE8qR/cVvkuJhZeD0F56vIVFEtCuCx6N019aGSTU3jklDRUa5cK8Pll/AA01ZbBR702v4BFk+LakvwikcRagF1MuLegOQ7ArwoeTAn4NbNH2gbpllGmI+aebqvhkO+vHm07MPn9seWdVOIh08EnAFOKvdQ7fezq71nbzviRIO3J5xDpFqloC/rChrBQWRQe7qBnoQCPDnx+3y7OobxMCzN6QQ4lxfm+9W4Cd0lvmGcSXkgCHaoKAPuPKwsbeSF0/2FlnuR5zRgjeIERJp52zLoDpWrtGuvAxF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(366004)(136003)(346002)(396003)(376002)(39840400004)(451199021)(2906002)(44832011)(38100700002)(7416002)(5660300002)(66476007)(66556008)(66946007)(8936002)(41300700001)(4326008)(6916009)(8676002)(36756003)(54906003)(316002)(2616005)(86362001)(478600001)(186003)(6512007)(6506007)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e8LcjUio4h6+Cf7c+493q4iaKOfANqypcrEaVEx4qABOsoR3QcU3y5XWdG7g?=
 =?us-ascii?Q?eaqQgHrRHwSTRWysdPAvIRdG8VMoZJ9kOvUHIL/nbC57DH4A7gD10iJGpPPI?=
 =?us-ascii?Q?rr9oDifQqGf9+DxPscpWWQnrq7QWdt8bfytLVz8D51YcLFcSpMt+m8M5aFP0?=
 =?us-ascii?Q?y6tdMh/FSZSNqsiCRzAkq2N410Bepapo7xxSzKptZ4H4G6vQz1bjH4S9tc4G?=
 =?us-ascii?Q?o3vz0loLodDXkdCOaiBOJadbj1QgRz9RJt5a1Nn9MgQTlDmi+GH6b4HMBC6+?=
 =?us-ascii?Q?EoSqp1ZK3VLzya1cwv8qWDwKKXptXxCLtz/W79bbe2ZbEhWgET2eZdyzqnSE?=
 =?us-ascii?Q?1ZE8dmEXWfT3GRAWTlgTdz9jrxO86WA10WdiF2pCrO7jWnpL4QUc3/7VI0B/?=
 =?us-ascii?Q?n8JeIbKdK1fzvwZ/FAvKyC0mUiSuAy7D0SOAZ9na51I/3MQBlqSB5YBrE6Q4?=
 =?us-ascii?Q?DkUzKoweXAsY8aeGAteZN+noEMPSmBwbgFtxkzwfCg94VmI6zwYLV3C3PEkR?=
 =?us-ascii?Q?i9FpZztRK/3hhn9D2Qfex3wvorCTH5RJTp6uIXmo0nRNHvfKmSXCCRY/y4bG?=
 =?us-ascii?Q?+LBIXs9/fnm6RqhiyeWS6Veida2akYaF3nG1kdWG8JGUZFLzTva6RnOxXV92?=
 =?us-ascii?Q?zNisSCS8GzvZNIINo2yPjOobhtjqobd0YK7Nm11Dre4nnKA5oSnMvUHU1N65?=
 =?us-ascii?Q?o6gFtQQnF9n3siPS9yzUOm4g8x81diGi568iNRbYWkm2UrSNsAWcgv93X+/9?=
 =?us-ascii?Q?+YzRXEbyuj54YpP1kYrNk6jf3oedWKoIEAK/MhQyQR4l0QyF2pSCPvzl8TGg?=
 =?us-ascii?Q?v4+6jrrog3BBH1tcqTSdKaj4ieM4/7RbTt2d+AaqAh44Tv+xpahbiSuISqtR?=
 =?us-ascii?Q?RBrVTUMcFGlKcnRCHlMhZfXZWazsB2ivsfNvUDpp9l5WoU0vyzktmjsDytX2?=
 =?us-ascii?Q?TjsnqqjSeRPYW/Ysyf2+iWvHRoVibr7z7kHVZzcbLmndn3BNutb3jkh9TJCG?=
 =?us-ascii?Q?d1AfiSDcR7QQIVNUq2B30c01N8k20+eb4l4WG3/Wx0R1LErMrUCIdsKHZcAP?=
 =?us-ascii?Q?xfAK0t5ixWjI87Gl3dr4rdjgpiXmBDLe90Ys6GOdmg5l0xDn/qLrnVAzZA4b?=
 =?us-ascii?Q?oLpJZVjyQev1rV5ppBFDs8xdwqYGmHipm03+zylqKoYFsT0+o+2LFr7Bglv/?=
 =?us-ascii?Q?YXipBz81xr84Oaf/GPOUU30TDn9OIElNrtptJ6REbMyfiEXgl+mm3CpnHL91?=
 =?us-ascii?Q?7koyfGUXdvL4GI45OIV55Dr1m/9ohet/udqhT0eqzZUMpJ5tBiJ1t5y9RGkV?=
 =?us-ascii?Q?mBr/A3XrUO3YmBCvYS9JSVV8lFpbztguFpSnDnINz9OJqB9qP1p7cFcBRfvj?=
 =?us-ascii?Q?itAwhNDuRPtUguC/9zgjRLuW8ncgJUywOSoRTENYuRvfejr4sSqrOPEV1aGB?=
 =?us-ascii?Q?Yc+3Qsm96ARUUEz/tXz7PDQwPFw4sdfhSEVGzzhh5bC9dPn/jQTWKh9jxHe9?=
 =?us-ascii?Q?Qf9JxSREt023lfE5MDSS9Hz944iErUvQuPmXd1FjDR9KJne4dklhsXNbVgfy?=
 =?us-ascii?Q?MpVzt5ZEX5kpzVJ9jvCb5Wv5pFCMcJf18iTYvOXIeMYSqieBEKG85vWJdAnC?=
 =?us-ascii?Q?zF+ab9Kkyq2f54802PZCdgsPkJf/u0eRw64qQLKvNPQAbAiTsZPWD4sPwUHR?=
 =?us-ascii?Q?YX5L2g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30b33b0f-e38c-489e-759e-08db347cd8bd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 19:51:42.2489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCtcoEry7/WcKDJ7Z/32nxiCivuWf4S6UBv91LV/rI6xRJXM6hNNy2V+VWxf/N5+ZykPkwHIickkN8ifSQ4UgNVvYfvHESIml2aHbWvHWAY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4882
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 10:24:08AM -0500, Shenwei Wang wrote:
> The patch addresses an issue with the reset logic on the i.MX93 SoC, which
> requires configuration of the correct interface speed under RMII mode to
> complete the reset. The patch implements a fix_soc_reset function and uses
> it specifically for the i.MX93 SoCs.
> 
> Reviewed-by: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 27 +++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
> index 2a2be65d65a0..465de3392e4e 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
> @@ -37,10 +37,15 @@
>  #define MX93_GPR_ENET_QOS_INTF_SEL_RGMII	(0x1 << 1)
>  #define MX93_GPR_ENET_QOS_CLK_GEN_EN		(0x1 << 0)
>  
> +#define DMA_BUS_MODE			0x00001000
> +#define DMA_BUS_MODE_SFT_RESET		(0x1 << 0)
> +#define RMII_RESET_SPEED		(0x3 << 14)
> +
>  struct imx_dwmac_ops {
>  	u32 addr_width;
>  	bool mac_rgmii_txclk_auto_adj;
>  
> +	int (*fix_soc_reset)(void *priv, void __iomem *ioaddr);
>  	int (*set_intf_mode)(struct plat_stmmacenet_data *plat_dat);
>  };
>  
> @@ -207,6 +212,25 @@ static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
>  		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
>  }
>  
> +static int imx_dwmac_mx93_reset(void *priv, void __iomem *ioaddr)
> +{
> +	u32 value = readl(ioaddr + DMA_BUS_MODE);
> +	struct plat_stmmacenet_data *plat_dat = priv;
> +

nit: reverse xmas tree - longest line to shortest - for local variable
     declarations.

...
