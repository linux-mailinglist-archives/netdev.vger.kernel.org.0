Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64DF66D31AE
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 16:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDAO7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 10:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDAO7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 10:59:16 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2133.outbound.protection.outlook.com [40.107.102.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF33F1CB8F;
        Sat,  1 Apr 2023 07:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxLjUICgS40O11S2BBvliFaMc4DT0se+nbJkqpNaaQaX2SRjTSipWMAh3Q+RA7M7B5agUe8v9XwaTupgLJogORiKqZN8RwrMsBVA6/lZUcVD5cUb7T6KBJnoUZhNVp3AJs3HLrOHNxyFfTHguGVI0/HzkIkN1Dz3A5gkJk6yIDa6HkFYzopZzYy+ibYDRFS1lj7TMo1TmyHkx9b9BgnbC6L3YX3k7c38yfHYvY0Zj1DuTCuFp2cFk1Q89qVxM1NQ+ygGvOo2UlOvHRyRnIubW828kHMTh9KQR83iQgKprczwWbHNe77eU/oy7klSVI2rE2XF3rWR3dgsU0YEOqWiag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voBk59DTHJVOnSlfKGn32iKhY8VuqJNvnc3DwS/EnX4=;
 b=lNU1VrTzQFYS/G0TOGouIDSFgCyowIyKLOWnCOLQGIkPX6mLFgdTZg0O+58txEvQ/y6UnoOJjuzR3kuJKzSnVdH+gFXCv0HSykf5UWsHksJKqrmh2FI+2rqS9u5xbeCyM/rO0C8c/pv9KRsD/kXkwyD/oBIKj0gwj+hBcOTN4PEDoiBshxh6z2IvJngxJY0jvS+gJkXcdVoio68uV01w0Zm8/zuhT0PwphAHVot/jOWxcurtkGrMyUoehX9EEdCFMeBjxS5TjB0D7hOy+cE85X9CT9rbwTijirYgJ2iFXbSkcmGBfXr/qmL1UVA0eYPh6IGWzccfcC2QBg+p3igXCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voBk59DTHJVOnSlfKGn32iKhY8VuqJNvnc3DwS/EnX4=;
 b=woWSpUeGfgvEVUloLdnju5WcOLu3+ZmbdTl0D8CSJHG6fiXrhIeDD8H87jBuqAcw4T+EHs7uBYZun30EoHkrDLnSG08n6dnRAVPBeG4TI6DGZv5/cNwOT9H8B7k2DvGhPK2AOisqRYecChsyG9gFJA2pPD86jVSo0mrZtref870=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN4PR13MB5294.namprd13.prod.outlook.com (2603:10b6:806:205::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Sat, 1 Apr
 2023 14:59:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.021; Sat, 1 Apr 2023
 14:59:11 +0000
Date:   Sat, 1 Apr 2023 16:58:59 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v3 09/12] net: stmmac: dwmac4: Allow platforms
 to specify some DMA/MTL offsets
Message-ID: <ZChGswjgAOkT0jvY@corigine.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
 <20230331214549.756660-10-ahalaney@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230331214549.756660-10-ahalaney@redhat.com>
X-ClientProxiedBy: AM4PR0902CA0014.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::24) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN4PR13MB5294:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d64d151-1bcb-41e7-1aed-08db32c1a684
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e+SEF7H6AVfzYKttuy3SKmW8Te1FtnrC+Ru7O1oHJ/ElbWz1bUHYXIrzY1dQxiyAl009ksGaZe0t8cPXYCnNNlOUjmxoXuE+nSonNvDpc7qEEepfdSFzLcvoK5HFjvnnWfyqSRzXiOM+lQY8YEcg4ehuIvUFjqCD+jgeuGla55jWb7mBnMIo2Bo1fL2BLYsNtAO103EFoXlK8TGib9vZx9Cl9pME2KU+AS5ly0bkGxZsJP+Vh9d+wZGL95Em5OcEplbWlYM+zopcGgNTelLEOIFAmg3/da6emlYz9kJ20g18e7agP4zLBh0STCxHLw7VwbuNAsiPSVj5JZ6FnAbCep0UJvLJDj3i6xfKhUOcwNBGA/fz8xxcNbn773afTMET+oMCQg7HUDDvLQ0aPIEGJYZHjeu5KUE1pOdjXVVY//Dfu6sl0N6a6rAHQaJa4avX736TUtmg6gqacctGU5BiZah4kVjE8CVyRh+rDkEPwgdUZsLdTAh4/Gf56lLDpkgbEwQ8elNAxuHolqtsPmmqebSLZDknwztCJ3y3L2iNCvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39840400004)(346002)(376002)(136003)(451199021)(66899021)(186003)(6512007)(6666004)(8936002)(86362001)(7416002)(6506007)(66556008)(5660300002)(7406005)(44832011)(478600001)(66476007)(41300700001)(316002)(36756003)(66946007)(83380400001)(2616005)(6486002)(2906002)(38100700002)(966005)(4326008)(8676002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1u4fHk4HtSM7kgAuB4AqCJDficjPcJAxed8iHrbnxL7Tg8TTFQ9mieoX8Gd/?=
 =?us-ascii?Q?9WyAMbF5Z1rLFn4LJEz0jUVO/6rtsyCyAc/+16R4gKGdNS6HbHB944f+EECg?=
 =?us-ascii?Q?XC0zsaPwGwJZb0/odY3LZvfnlV51tgvTrLfdq/L+AuZbUKfsQNgeac6PJ3TP?=
 =?us-ascii?Q?Z9YIWmaUvCBnTET+yTp16aZA7ihhlleebX2dbBRXGqNs8V9sbvSP5Z/bULjL?=
 =?us-ascii?Q?Ib4rS04iR80Pdcf0fKwPQSOa0T+Ryjtg6RzJYcAlyZu4cpcsrB9IJPrUnIKB?=
 =?us-ascii?Q?W7rISLa7tqMtohNkf+RKqMXS6+8HUhiXY9yOWZFg3Eun2Jz3Sqm7ioNYhuxQ?=
 =?us-ascii?Q?2vNZPjeWQLfaH5RXCrzq7UpKdnDzdjYR4VnoYwAYYpF5Ll9mU7OGydCnIxIX?=
 =?us-ascii?Q?PoYutYaP7RBeCNiReBpJKn/f2sNccJugU+aaYjXbUFt80tSBD3GH/PcqhaTr?=
 =?us-ascii?Q?eXlfMye6N0wHnleCnITAN4QsGgXdWp+x4S2UNZl2NzVxAZL1uHP06UOetE7/?=
 =?us-ascii?Q?BYOq+9/oezvqVtVhjMmKqio2nwn++5UBDIOfTzwbP6lf3nCW35oICMbH/Lur?=
 =?us-ascii?Q?MkpnEnVh4qlmmnzwZ/0kUo+JswuwlHfsOF4A4ffk8gCyRQTPy1/TbBppAj5C?=
 =?us-ascii?Q?Wyf/wYMUhU0x6MTRGTZOoOZ6kjArGB94NYsviPMjmEqo0bA6HZG16icshVA2?=
 =?us-ascii?Q?kMRbZhqZRIaSL46y1RYYUEjJ0M6mGkUR1e3F3dMtSTTAUM4hNJDF/IOYyqNh?=
 =?us-ascii?Q?/ukhA6irBlJi02asJdalIy6HC8OjZ0au2+1jBuCfuAAtjs9XGXmFn2UBvzxR?=
 =?us-ascii?Q?y5UadCimjcrqw/1929XurUYhRZ6kfHgdcaSJ1NSpGMOK7FcuHDrHuCOzqACd?=
 =?us-ascii?Q?NXgx8UOvnTel4WkPNPF/1g0uMGLBcz1mQR4xT4YzJ59lOk7vhe9e0+9Q/cjh?=
 =?us-ascii?Q?PjZyKesKsDp3zwIilY+IzsRE7VW6C/sdX6epUCryVB93AOeVzL0/Vriak207?=
 =?us-ascii?Q?9t5Rjr7eiPFnOO11fBGcKj4ORbzgLnOoEERVWvoCh9Glc2G85eYGAbBai66L?=
 =?us-ascii?Q?xwEuKeTsTXamTv4ST/3qqgjtaduTjFb6TaeBxO1KLsYt8Dh23dRgoe5OFPYs?=
 =?us-ascii?Q?qr9P8Sg1cSLnsSvN+KMbCNkjBaB40keWfkzK/XTCULAd5ClS9IuA7xsRXN0I?=
 =?us-ascii?Q?D+vjmaibAH3rPOrmFgXEvDDod+t4bKo/Y19a5W8AzOzBiMj+YxFnvsY+VPUZ?=
 =?us-ascii?Q?INJA2Ei9x5GKTUPLXr9G5XQgDG1/u4im29k1SncFatn6UF7DSKE8Z+WxSFWj?=
 =?us-ascii?Q?Lsm/7I0P8G6nL2MvqNUR2rkwUPYmyAXfIlSrdTOVZmh5XWAiA1MH/DsIHlpj?=
 =?us-ascii?Q?eKockzr5L1ZUpV3tUyABn44e9h2+4c36wwPJMngK6nlZsl6KUnv7SQGtXI2z?=
 =?us-ascii?Q?iecf0ctBT/spw0mKlkLFp8aJtJozfLIWbHVyagB0vwS4wbpMn2ETzr8vEV2u?=
 =?us-ascii?Q?fL7VVyxRV1MFHdJJ5PnfaBCgG2Ds96mA5OFhPozfk2gEP/I/hPJmv2sC1eGA?=
 =?us-ascii?Q?66thbD+gVQWlqEdIBMtLi4PWOCh066S/dOhWjSLcbvm4ysmg/wc/1GnKHkYt?=
 =?us-ascii?Q?ehLLmZy6yJrbs8AiayHBfTgYHEpB1Fo4KzAU/QPYTTe78SGzg9BWIATpSyNs?=
 =?us-ascii?Q?y/Mtjg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d64d151-1bcb-41e7-1aed-08db32c1a684
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 14:59:11.1074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvdBOGxMlg6hN0mn9B1R9F3uOqlyre+jxJ05/ufRxzBwRMS7Lhj0iqiqdNfiaN/UX8u/NBU8cZ/bc0fBvBLQ7N/D+fK3GgPM6fmZ8YW82as=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5294
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 04:45:46PM -0500, Andrew Halaney wrote:
> Some platforms have dwmac4 implementations that have a different
> address space layout than the default, resulting in the need to define
> their own DMA/MTL offsets.
> 
> Extend the functions to allow a platform driver to indicate what its
> addresses are, overriding the defaults.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
> 
> This patch (and the prior patch) are replacements for
> https://lore.kernel.org/netdev/20230320204153.21736840@kernel.org/
> as was requested. Hopefully I was understanding the intent correctly :)
> 
> I'm pretty sure further refinement will be requested for this one, but
> it is the best I could come up with myself! Specifically some of the
> naming, dealing with spacing in some older spots of dwmac4,
> where the addresses should live in the structure hierarchy, etc are
> things I would not be surprised to have to rework if this is still
> preferred over the wrapper approach.
> 
> Changes since v2:
>     * New, replacing old wrapper approach
> 
>  drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  91 ++++++++--
>  .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  36 ++--
>  .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 157 ++++++++++--------
>  .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  51 +++---
>  .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  |  67 +++++---
>  include/linux/stmmac.h                        |  19 +++
>  6 files changed, 279 insertions(+), 142 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> index ccd49346d3b3..a0c0ee1dc13f 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
> @@ -336,14 +336,23 @@ enum power_event {
>  
>  #define MTL_CHAN_BASE_ADDR		0x00000d00
>  #define MTL_CHAN_BASE_OFFSET		0x40
> -#define MTL_CHANX_BASE_ADDR(x)		(MTL_CHAN_BASE_ADDR + \
> -					(x * MTL_CHAN_BASE_OFFSET))
> -
> -#define MTL_CHAN_TX_OP_MODE(x)		MTL_CHANX_BASE_ADDR(x)
> -#define MTL_CHAN_TX_DEBUG(x)		(MTL_CHANX_BASE_ADDR(x) + 0x8)
> -#define MTL_CHAN_INT_CTRL(x)		(MTL_CHANX_BASE_ADDR(x) + 0x2c)
> -#define MTL_CHAN_RX_OP_MODE(x)		(MTL_CHANX_BASE_ADDR(x) + 0x30)
> -#define MTL_CHAN_RX_DEBUG(x)		(MTL_CHANX_BASE_ADDR(x) + 0x38)
> +#define MTL_CHANX_BASE_ADDR(addrs, x)  \
> +({ \
> +	const struct dwmac4_addrs *__addrs = addrs; \
> +	const u32 __x = x; \
> +	u32 __addr; \
> +	if (__addrs) \
> +		__addr = __addrs->mtl_chan + (__x * __addrs->mtl_chan_offset); \
> +	else \
> +		__addr = MTL_CHAN_BASE_ADDR + (__x * MTL_CHAN_BASE_OFFSET); \
> +	__addr; \
> +})

Could this and similar macros added by this patch be functions?
From my pov a benefit would be slightly more type safety.
And as a bonus there wouldn't be any need to handle aliasing of input.
