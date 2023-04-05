Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E23B6D8512
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbjDERm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDERm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:42:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2098.outbound.protection.outlook.com [40.107.244.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F5865A0;
        Wed,  5 Apr 2023 10:42:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4wc/x33skhbKjv6T+EG3RAZPTI9fGNW5ntZ2nCxZzzfpktCDTLnOGdNkqPJwwsDOpfnMB9fGIY6zE55As4BUX+s+lawXTI8XTuzS+B2rERcJWgQ1H58FCwdPzdanUup5K/SkN3sgsb3Dyu2hz5xXZR9eZsvAdovwRt+xQWM9mD0k0aFCp6jbe0YgTOugkDWBgFmH8wvgzMOAUznkCkGQIAL7byDRJF4pIxoV43UJIhtAN3FMfteTNAIAtyOrp6eQaT5acSe3fMkrari434KYLFxxDK4oyl3uoiEtigM2cAA9wKFUDhOEF+/BhimkTdmblOZ4WVyEqwAlTumUlJ8Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8C+WsZ0OJPFbnAmgXP/u09sQT5S1dOu+xMtHyXWVkLg=;
 b=ffq0yBVAUt3STxjwxKPG3Ms7aeFdLXuYNjW7613Musq15juXP9rmjxpLMhGld7h7Px8cuMc3vlFuZVHOGp3HXWNBgC3LQtrzj2WrOVbDiBUkWzR2f+vG+4yAtAWP1ez2S4JQdJv/WAEt5M/1RiskBbARwl7//KPRjEX92eyRn+9sviaWbIibTv24TK1X83qDUOAYy3t6w0CyxzT4jJ347TdMlJMVRrETuIa3rb2fVNHZOw95zzt4kukJ/+ks5meeFe3SBP0auFTsI4Ki5/wetupirINYgA8PmOb/cqdr+YEX7xHEug8BZAK5oyA0oFUGOyiLYBIBiIbtPyyT3UkOcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8C+WsZ0OJPFbnAmgXP/u09sQT5S1dOu+xMtHyXWVkLg=;
 b=dHKKKnhmJJRkfliMSgzYJDO4RWMOKlcS9BkLJDgxzRm1shCAkk38q3ZNI0Zbpb3HWYm1XC2KtoDNe3L+iAL+5vIvpCs+VY+kvzYbRDVvAoBq1y7rAOq2U/JEzaM3uRe0/j7+++yCPBePlaF9CPqhPIbU0LwIDcTt8mOxcMWm/60=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5122.namprd13.prod.outlook.com (2603:10b6:208:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 17:42:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 17:42:15 +0000
Date:   Wed, 5 Apr 2023 19:42:05 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com
Subject: Re: [PATCHv2 1/2] net: ethernet: stmmac: dwmac-rk: rework optional
 clock handling
Message-ID: <ZC2y7TWGbh9ZSuhs@corigine.com>
References: <20230405161043.46190-1-sebastian.reichel@collabora.com>
 <20230405161043.46190-2-sebastian.reichel@collabora.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405161043.46190-2-sebastian.reichel@collabora.com>
X-ClientProxiedBy: AM0PR01CA0158.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5122:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d5314b2-f60a-4343-9852-08db35fd17d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zh25DWtUpUSdx6EsKPT7CN85gJX74pN8uGoNFLnIEnB+3fekBVMxDumFA8FB9lnCBpr3w0YFTSnywZvGSscnjGSsa0MFlbP7KagaoymJEY0TDUIS2taFGTGPu4V4jTFSN86fukoQOLnCdrKR2UxQRfcCNgtuiI5XSlYpStY7i8WFNJSqk+WGk6wjqfeZ+Uh1zLeZftsl6UFBkY4MOj92v2HI2NQmmIEpapvLUBQmo1xjRVi2eCbSIXstGEdbObBSlKolLvRrt9DbYWqJxZt3n0itYklOdR+o7O8shBw+UIXODMkMtRAuS2hlMKvsfFZsQo8iBRRT4b7Y3poczFKUclFZTYRFDkEs46xcPrfYzDFBprGDbKwcUgCioMvBpocE3rKySATZY9nOZdsEEvhzGxO49wGTZhkYlcHEMVQQZoX1ugjxhZ4tSqGbsia5iyt57dNm2VdOOy+cbz+LYX5XfoXpu3BeC8FW1MLr5muugnoLn3Uv4wYnC6CdeJFpkSFi6qLysF8wDDD5iINExBWAqHWqqykkpA7/r74k2MSaPxSi9ayHZzen4z+RAoGuSSaA6BqgBK4C1MhR7GbwyUV8Gd73iR6Oz4plQi3mfjB/ap8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39830400003)(366004)(346002)(136003)(396003)(451199021)(6486002)(66556008)(54906003)(8676002)(41300700001)(6916009)(66476007)(66946007)(36756003)(478600001)(316002)(86362001)(4326008)(6666004)(6506007)(186003)(38100700002)(6512007)(83380400001)(2616005)(2906002)(7416002)(5660300002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KGiL4OhDBLwIA/aZPVIv6VYgEH1AUCNJWrbncCCnQFZegaUQr47wiecObxR3?=
 =?us-ascii?Q?aKzySzcXJp1qlqw0wnVl9rWSEdFNvVtq3xiRj5L0nLwvgG/uXsRTRYRZZUl/?=
 =?us-ascii?Q?+kEIl+aPh3/oSN1RDfNrbfRpz/6k20galabSf5Jn340Ybf8zGg5ARH3VVsC6?=
 =?us-ascii?Q?JpljS2sTAEyKK3vli1BDlStRZLConkXE7kkWKQKhmlfa8cv6KC6VTHDfwbYj?=
 =?us-ascii?Q?Ywvie+cbvfx1rme8WQbQmSjyhp4lbEQg+dALB+o5Yq0Yule7S5FXN+YBbTJ/?=
 =?us-ascii?Q?ePbmLSSqehTg+Fofg6bg1pzbNdGk1w1uV/s16ZZJLKeKK8qIs7lc3mecaO87?=
 =?us-ascii?Q?o0psM4cwUkKnbtcJxs6rPZvk2oj5U9mcWsis3TvWBdViws2mchxynKC76U2F?=
 =?us-ascii?Q?At2mUdJsSsJJ5WugE8e4s2xOA4wr13Jifo7gMCXTrVS94fMeNN8sNl7Os5ob?=
 =?us-ascii?Q?OD18wg0e8qFocE20cOasRm+i6ZvfjNyNW5fL1vbS18uB8Xd636WIJuM13nQo?=
 =?us-ascii?Q?4DpicJhACgp1Pg+MaPzEWPcVJhj9ngIz+XxwxFDUAB80xC0td28dWr5OByb6?=
 =?us-ascii?Q?H/DG1yPcgmZJrXRxVmd5CtQaOO4YEhPMlUemwUvxHbd8gRy7h/RROKY/LAe7?=
 =?us-ascii?Q?jMYOfoefV67DaAvzMu8qsObuNgImnnOkH3G2bOMPW21MItVCdAJ3rbmk2rne?=
 =?us-ascii?Q?1K7cWIhqQR/qSWM5hzfrveMOmdQUpQRQcfPV0pEWypGLtmY4HjicApgXxc71?=
 =?us-ascii?Q?jZSzMaPvTfXBFtgiXlGgAUckdvUn2/Q7t5aNFXlkbD13g8387L++dthxYact?=
 =?us-ascii?Q?JkU3RNRtsc86D5iQGlwHRTtyk2Ay5rpb++PDRhkJGmIDcFY8avsY1ZkNwhAV?=
 =?us-ascii?Q?7Es9Ix1OQ+ZD0CVEYi56dlwVpt5dZwfUgJnKTNqyy/oPld6QByAN1RQ4XkFq?=
 =?us-ascii?Q?LAFLeudc/BByYp027usYPOy35+ObLzGlYzJs7PlSXHse/kvyB833p4+3NtCF?=
 =?us-ascii?Q?W3LFvrGVOJaPtbvZObSgameeycW+5+pPYScFYbcU8qkK71J7H+7h0IIDkstS?=
 =?us-ascii?Q?fzRJ3drHM0FiOl7tsbCZyE+LIXjf+3U5J30zBFTcLcZhJUuGANHxpqZebo7N?=
 =?us-ascii?Q?7XH160R1uqAJu5wNSR1JJo+nZTlU++anpwZYd8O4iUyydkK2v8EpbyioXq9I?=
 =?us-ascii?Q?uBxSwJmQiVZjStNONOsstZ590U6mYAvMVNP0IB7hCDBXwSR3JOwVPKJAHOky?=
 =?us-ascii?Q?zHByLnnF7ti5ZZzlgCHyXtS7q+o9oxZJsbA98H36C1NbWbAqMpQa0xDFDahn?=
 =?us-ascii?Q?X5Sw/DjiIL4kKPMXt2LrP0zmHk8oSPFdu14R7/XrFVr+iCY86KtVDoEJq6Ek?=
 =?us-ascii?Q?KpOGHyFA3DsAKJlkq00Uc6Ysc5B7aytRl4806Cvtn3xNR4EqALVfUlcgW2pK?=
 =?us-ascii?Q?iuIlQDh1RbGlQVP6mPonm9d2gTK4mggPuDz+fm3ZZSkj/59CPvAMKnv5B5tl?=
 =?us-ascii?Q?g0lginXnPuA4047B7WRPr7YfxLXRHEGBS0A/uSCy1zuJa0g+GoN2Ts+xloa5?=
 =?us-ascii?Q?knk4BOSM2ULlBgwIxORiwC6mzxh+kraEaCYYNKBKuxf1m3ophUpPOXQoW8gA?=
 =?us-ascii?Q?eFt+VO08krlNsxJRc6Y5EV6kyWzWcpn0Jmg8O55D5hlhYztQYqMaZbqcJEkD?=
 =?us-ascii?Q?7a/XnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5314b2-f60a-4343-9852-08db35fd17d6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:42:14.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YHu3RnrtI1h0AQH4VulEsrn7XW6Tl17t54Mp/kf+tz1iC6RkV39IP8tQO1zMWt4K00j0pDrlCKQBv3GyER3tZIgu8smhIf9CCQSZ41reKok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5122
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:10:42PM +0200, Sebastian Reichel wrote:
> The clock requesting code is quite repetitive. Fix this by requesting
> the clocks in a loop. Also use devm_clk_get_optional instead of
> devm_clk_get, since the old code effectively handles them as optional
> clocks. This removes error messages about missing clocks for platforms
> not using them and correct -EPROBE_DEFER handling.
> 
> The new code also tries to get "clk_mac_ref" and "clk_mac_refout" when
> the PHY is not configured as PHY_INTERFACE_MODE_RMII to keep the code
> simple. This is possible since we use devm_clk_get_optional() for the
> clock lookup anyways.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: 7ad269ea1a2b7 ("GMAC: add driver for Rockchip RK3288 SoCs integrated GMAC")
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> +	for (i=0; i < ARRAY_SIZE(clocks); i++) {

nit: spaces around '='. i.e. 'i = 0;'

> +		*clocks[i].ptr = devm_clk_get_optional(dev, clocks[i].name);
> +		if (IS_ERR(*clocks[i].ptr))
> +			return dev_err_probe(dev, PTR_ERR(*clocks[i].ptr),
> +					     "cannot get clock %s\n",
> +					     clocks[i].name);
>  	}

...
