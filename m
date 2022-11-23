Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D32636521
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiKWP7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237496AbiKWP7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:59:36 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1894112C;
        Wed, 23 Nov 2022 07:59:34 -0800 (PST)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 2ANFxL1o067298;
        Wed, 23 Nov 2022 09:59:21 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1669219161;
        bh=jpZuW9oHORo8S/7hQxhhY/cDw10zv0j955exyoygGXM=;
        h=Date:To:CC:References:From:Subject:In-Reply-To;
        b=rbHsk4lu5HCOC7TeS/xhfElLPA9MhGbPKNA6kYTjgySfeKRnp7APsegqliHNzyCNy
         Rmr54liG+IYHFylcifIzJMr4BKlQR0RaetrL0WzV3IaO9NnLIlCLHJxfgUlOcnvRV3
         YQh8q367KW9NeQyZz12FvE+VWZZwHwnSNA34sDgI=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 2ANFxLos016741
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Nov 2022 09:59:21 -0600
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 23
 Nov 2022 09:59:21 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 23 Nov 2022 09:59:21 -0600
Received: from [10.250.233.34] (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 2ANFxFTG035291;
        Wed, 23 Nov 2022 09:59:16 -0600
Message-ID: <c3ded2b8-cf99-36ac-7152-5a23245a2e9c@ti.com>
Date:   Wed, 23 Nov 2022 21:29:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Content-Language: en-US
To:     Nicolas Frayer <nfrayer@baylibre.com>, <nm@ti.com>,
        <ssantosh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peter.ujfalusi@gmail.com>,
        <vkoul@kernel.org>, <dmaengine@vger.kernel.org>,
        <grygorii.strashko@ti.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <khilman@baylibre.com>, <glaroque@baylibre.com>
References: <20221108181144.433087-1-nfrayer@baylibre.com>
 <20221108181144.433087-5-nfrayer@baylibre.com>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH v4 4/4] net: ethernet: ti: davinci_mdio: Deferring probe
 when soc_device_match() returns NULL
In-Reply-To: <20221108181144.433087-5-nfrayer@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On 08/11/22 11:41 pm, Nicolas Frayer wrote:
> When the k3 socinfo driver is built as a module, there is a possibility
> that it will probe after the davinci mdio driver. By deferring the mdio
> probe we allow the k3 socinfo to probe and register the
> soc_device_attribute structure needed by the mdio driver.
> 
> Signed-off-by: Nicolas Frayer <nfrayer@baylibre.com>
> ---
>  drivers/net/ethernet/ti/davinci_mdio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/davinci_mdio.c b/drivers/net/ethernet/ti/davinci_mdio.c
> index 946b9753ccfb..095198b6b7be 100644
> --- a/drivers/net/ethernet/ti/davinci_mdio.c
> +++ b/drivers/net/ethernet/ti/davinci_mdio.c
> @@ -533,6 +533,10 @@ static int davinci_mdio_probe(struct platform_device *pdev)
>  		const struct soc_device_attribute *soc_match_data;
>  
>  		soc_match_data = soc_device_match(k3_mdio_socinfo);
> +
> +		if (!soc_match_data)
> +			return -EPROBE_DEFER;

I dont think this is right way to detect if socinfo driver is probed.
Per documentation of soc_device_match() , function will return NULL if
it does not match any of the entries in k3_mdio_socinfo (ie if we are
running on any platforms other that ones in the list)

Note that this driver is used on TI's 32 bit SoCs too that dont even
have a k3-socinfo driver equivalent. In such case, this code will end up
probe deferring indefinitely.

> +
>  		if (soc_match_data && soc_match_data->data) {
>  			const struct k3_mdio_soc_data *socdata =
>  						soc_match_data->data;
