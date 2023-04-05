Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0C6D8519
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbjDERna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233282AbjDERn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:43:29 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2091.outbound.protection.outlook.com [40.107.100.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9171249F9;
        Wed,  5 Apr 2023 10:43:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWtwK1kvEcaN8QIRKooIto7dOwtkI2NLfklFU3DAGXQv6bVPNAGPHb0I8eZKFpRYcEN3tPBAzsxuMCtXyXklrE2P+Yg720DmEyXRuS1SGsbfluwtE2pokqMC6BOesTjqHn2h10+yG5Roxo0e0hF0x4rrTB1TFxSUoybkstwjiy6EioRUenKjbW58bFSV+KCroCoTuZ3k2254Bu9ku8/8mWS2VYdJjUhsclWkx0VZD+ucGo59Au3j6fsFul6+0d9Y4LlNsvBh/j0nbK6JOHGd2NnTdGSv/D2FBlHHcDfx9o0sd1cd5/fZaWcbPQXwKYU3ek6Oq6mwfurBd40PsQ+6/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mda5kCrlODENH41x13gEf4hodXm48CTkHm9taW8sZkE=;
 b=G2fxOzN8tGbXI0T6FvR1DVb7qMWdaYZokR2rhobjMK3le/l8SJbOnF6r3YPBSOWGIQV+1ki6mp6rI5bbaCNRSG/qauqE2FJKE9dxvX2tnkG8nZsG4QFZ8vv/xpFXtMoJ4POtRHG24mb3uppKk33Te6jS/FWyVaH/tA1y+yrCXABMGrpmpv20lzlO0FaBY7QP5JV/CPsm4NFYdopqAJUrctibEe1CnUytzuOjXcMo2cYYiRW5J+mUhJNO2hPpX+nTJE4JaOzO0LuL68He6/xln5bNTHqDwcYU1s8bxr1DGXw55F6Hxdz1zJ9UjDuCrlwi1QKP71dBSUaB+I1GVAjbAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mda5kCrlODENH41x13gEf4hodXm48CTkHm9taW8sZkE=;
 b=gyeIxaV2OXp1tZsD+waeZohuSqOueQLsROnl7+u4KXK5LgwOJTBgjBOATjpq7KhUrTd+2xOZjiph4N2BFP4fkFqqs80+N2IhlFhpbupCv+rS+bA1pszEBstUwob9vtu7tj+m8TcVYz81xdnBoqoqo9zk+S8oMs5nvZgn0VPWPU8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4932.namprd13.prod.outlook.com (2603:10b6:a03:36c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 17:43:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 17:43:20 +0000
Date:   Wed, 5 Apr 2023 19:43:15 +0200
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
Subject: Re: [PATCHv2 2/2] net: ethernet: stmmac: dwmac-rk: fix optional phy
 regulator handling
Message-ID: <ZC2zMzaUMY0/VCRR@corigine.com>
References: <20230405161043.46190-1-sebastian.reichel@collabora.com>
 <20230405161043.46190-3-sebastian.reichel@collabora.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405161043.46190-3-sebastian.reichel@collabora.com>
X-ClientProxiedBy: AM0PR10CA0125.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::42) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4932:EE_
X-MS-Office365-Filtering-Correlation-Id: a85f462c-c70f-484a-335a-08db35fd3f22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TTJAKzTX3n3OkllGesvVCfogBKt6Ry9QdX5eWq1KrErCvN1XTxl5FTpsf30sxuFaVy6sQv6z8uA0FB4Wa0b2pwIXqi0ux/ppAM9Ku0cMgA5UzDh9LHDUtjBLvzw0A3yMvhDJKdG0ncS8ok5lUMtCsuIEVP10JFYZOve7/UrsTjOy6UJL8PTH5b6RczQB3D/Cv9B/VcIRfrUc16Q4MVV3smQVkpMQ4TrdvNrlK06NDG2MLMOEf2Bd/OLNHCB/9FqDeMwco17oWrk5LWyFy5BwXHrwhAUJ7ERJtUSUVdH2+gHg+qb03h9bSbGWC0IcyY5PbsnpLJ9L8o/7VfC+bIIS5ioH1Q7i5bzAFnyNhq9sPMCYcMdqVox9TB0Y3PPGgiX7KKdtCbjDlvH6qAUkum0k5+MKFqEPD1dsLrd4b1lR8b9/e7zxOMxKvVVXhjVjS8uKw08F/zlMYTauPZBgYKCQjUSob7uoccO6gaXoHG8T9U+HTuau8erDm0dYYc5WugWPVk1RUD4K61txX1rzV8T0Lb50T4XWc+lo1woz/5FmxIZ24GrHQqeqd/wJw2sxMxvk6BYj0eBtvgHJMsLik5oafK2Jhz2lQdbXAMqrI9lxy6I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(136003)(39840400004)(396003)(451199021)(6486002)(66556008)(54906003)(8676002)(41300700001)(6916009)(66476007)(66946007)(36756003)(478600001)(316002)(86362001)(4326008)(6666004)(6506007)(186003)(38100700002)(6512007)(83380400001)(2616005)(2906002)(7416002)(5660300002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PhOIRjj3TT0cZA22U2yQJAeqCeQzMf5vwCvvx2Ib/cCxbkmaCZABJZ0BSD6v?=
 =?us-ascii?Q?trY6b16bsH6i5cxHKQ76xVnW3HYu8UXqtLl61JhZA4pS/wzwjfydHl/bcGLK?=
 =?us-ascii?Q?n98RVuoC36c46frJBThmcNR7lxYaDF4EHLc/Xakwxbi9ZEe3alYmfUdFBGXl?=
 =?us-ascii?Q?RXpSEnUgYcT3arhhIkq0WU1Nt5EZxPo4JL1PdPGQfCD8CAprU9nVGzcHXamd?=
 =?us-ascii?Q?Py7WLLBHNwjk6YyJmAeuAxIlVFToHuSY2xFTo6n1CypbeglpxO2cKOPNdftX?=
 =?us-ascii?Q?UZBsPHhyNhXRDFx8LmLKirAE4K08vGu8ynMiwfBIALOQuQWFrrOfEQ9/VJV9?=
 =?us-ascii?Q?JM0i4KUtqRoisCzYpIFxHFS9pYXQXwRiPJZkWoBT0cuadRliMqc9SszyCflb?=
 =?us-ascii?Q?ur3Cl/CNHftetZ0A67z2JnggbJQrZ5GUqfV/B8jzOJOeAlEudoCgukhg9SHu?=
 =?us-ascii?Q?pnELA4KyN7Kha6AhqIVLi0UfEoumJnbOZ3kaLuShalTrmazB1Qvz+FATnPGV?=
 =?us-ascii?Q?bKuPdEw64iY0EpuQqK1aJsWyccl2kHatKOhU5VuvFzTNCoDkDJibdDNFA0oA?=
 =?us-ascii?Q?lJrlKcjl1UU98UDh0U5Gof+vH3a5SoLhaZIpqOoPGU164LqcYjl700QlJHGi?=
 =?us-ascii?Q?Vs6ZR3pDp1dh9saO9cWcQ6lUE7yRO7jD0W7ChoOQjzSxe7E3W+XzfRe9z9T2?=
 =?us-ascii?Q?6oQ7zAXa7JVI6eYzSEtZ1pOt35TJyfn5+sB1FMhMAfswcFTanLe7ao18hpEn?=
 =?us-ascii?Q?pf2LmKUannKrLTOduCHkqg186y0IYGx6HWSrZ/aTXWiXnRpXjdggQDwylFp7?=
 =?us-ascii?Q?YsDZaJg2COrZfFxzKLipyROuqXywEiwaB6xnNuT4lixtCFl3CtJ4M+Fa210F?=
 =?us-ascii?Q?QOKjE9d+c3EnDlKZV4J101lg27rLkkp7yhm1IAlbN6I5cHpDp48vRC6NCwJu?=
 =?us-ascii?Q?u1e4lHd4XklffyhXHouF1b6nh8ANRGq6r1wMzH/aWpv5tgB5+llg1aKv+QVG?=
 =?us-ascii?Q?FTqHO8GuSvVlhcTTK0ShbPwkEiL4B3/M7V9W9G9XBIIy80Ju5VSww3Tm3m2e?=
 =?us-ascii?Q?v16EYfpRzXuE/ieLAyBAzW2MCfC9phqUYiwC28Jb0j0payEqeycaPX8CKQLr?=
 =?us-ascii?Q?XdyXjqySWLIXs3o+4sWaN1YBQmT6YJrwimalgICcnPwz67IIg5//pndqzR9t?=
 =?us-ascii?Q?ghb+lCcMWBGcXglAa3FojwiaZZDRK7lMLCsX/qpRxqFsLdTrdFcT8pt4mMsu?=
 =?us-ascii?Q?CVC8iAlD50qaFKxEfbn2grBNGgw5/Eh0VKB4E9jhsWXUZSJp0nYe6GQWH+wv?=
 =?us-ascii?Q?m9NuicR8IB8j71Ux6Vrno37qXiYUsrL6kddURdeJfCghw+svoVOQyeeZpPEn?=
 =?us-ascii?Q?HwpPQk+lqj0LHaraz+oAneBpFGjGL2vRcjEv4M6l4FmqFH1poD3HtceG/OhO?=
 =?us-ascii?Q?TKuDnLnOp9904R28GPHiK5lY1gvvNGMLnzZwvOXZNLYW0ZtmU0frTNAXMcuM?=
 =?us-ascii?Q?bN6p+XOgM8KbV6t3gNSBOS2LDRJWRKcA4B6Y6v6LfXDkn1FNX1vHRpsRQMrD?=
 =?us-ascii?Q?xpifvPRRho+wproaDeVGdwxs99332CpC1JeD8s/HeKRs/txElIfoC7OodvR7?=
 =?us-ascii?Q?8/cF5Fo1uPOtS1Dm9vhqrp5KCGEsCeGoUCPEt54YgHKAeAB8VGWDB9B6CGvi?=
 =?us-ascii?Q?JRLmzQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a85f462c-c70f-484a-335a-08db35fd3f22
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 17:43:20.7396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QnzUp4Qztpco4IxPZQn6YeHyi1uORbnfmLvcDtUQKyN2tGy4gA/5pjK3ms3RDeueK4DwzJtG82AOFkCzOSdW3k3cE3KuvkDRE/6rjq7l6b0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4932
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 06:10:43PM +0200, Sebastian Reichel wrote:
> The usual devm_regulator_get() call already handles "optional"
> regulators by returning a valid dummy and printing a warning
> that the dummy regulator should be described properly. This
> code open coded the same behaviour, but masked any errors that
> are not -EPROBE_DEFER and is quite noisy.
> 
> This change effectively unmasks and propagates regulators errors
> not involving -ENODEV, downgrades the error print to warning level
> if no regulator is specified and captures the probe defer message
> for /sys/kernel/debug/devices_deferred.
> 
> Fixes: 2e12f536635f8 ("net: stmmac: dwmac-rk: Use standard devicetree property for phy regulator")
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> index 6fdad0f10d6f..d9deba110d4b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
> @@ -1656,14 +1656,11 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
>  		}
>  	}
>  
> -	bsp_priv->regulator = devm_regulator_get_optional(dev, "phy");
> +	bsp_priv->regulator = devm_regulator_get(dev, "phy");
>  	if (IS_ERR(bsp_priv->regulator)) {
> -		if (PTR_ERR(bsp_priv->regulator) == -EPROBE_DEFER) {
> -			dev_err(dev, "phy regulator is not available yet, deferred probing\n");
> -			return ERR_PTR(-EPROBE_DEFER);
> -		}
> -		dev_err(dev, "no regulator found\n");
> -		bsp_priv->regulator = NULL;

Does phy_power_on() need to be updated for this change?
F.e. Does the bsp_priv->regulator == NULL still make sense?

> +		ret = PTR_ERR(bsp_priv->regulator);
> +		dev_err_probe(dev, ret, "failed to get phy regulator\n");
> +		return ERR_PTR(ret);
>  	}
>  
>  	ret = of_property_read_string(dev->of_node, "clock_in_out", &strings);
> -- 
> 2.39.2
> 
