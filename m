Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E106B3BEB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 11:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjCJKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 05:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCJKWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 05:22:47 -0500
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0DE107D57;
        Fri, 10 Mar 2023 02:22:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678443709; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=HL+mpXGzO2n7kJaxMGabVrdt2/v6BkB2ZR/vv8rP62hVVUq1cUqFkNYCJYKH+TUiEu2hMRjHQkoT8hWamap6Pb2fcoRMq8pcrr03F1PcvHzg/6QAew9TMfvBBe/0GsrDUveieeVLz2amzjVJnAcOs8iYs9fulZyE4pPSBfn3OEM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678443709; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sHc02Bqeqt1C7WoOr04FIucmx4YqEdZ758jRMdp13wE=; 
        b=Y22bKSpl27BBAE3xiJq4eySja+X1LXUCk84XWQ9xJxU5ZhxDYKDuNQgi30CdR4Qmi81uJt7iPFOsdm8HTOF2bF49rWpb9fJRmsqltD7QwoZLN8mEkdvzpiFuBVMT8nDz1dFOJ4dxw7wr+X8CsWLjqcXTYd+Z7/Im6gDoXsN7Osw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678443709;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=sHc02Bqeqt1C7WoOr04FIucmx4YqEdZ758jRMdp13wE=;
        b=ZEp9c76ztW+EY2sBxsB0ZbRii7UfhZARUXcD5EwDOLnVkq3N0KUICVSvhQI/Yw08
        lKzHSphzlYRg7yrM5TfYhx75SChUBflWi1D60BHpYUSBoXTZLEoFrb8TjHy5XaRcu6E
        Sv8+1P3qBWwcCfW3GU2UFZvQVaBexivs/JDPf/Ps=
Received: from [10.10.10.3] (212.68.60.226 [212.68.60.226]) by mx.zohomail.com
        with SMTPS id 1678443708111445.26386587299385; Fri, 10 Mar 2023 02:21:48 -0800 (PST)
Message-ID: <10f872cc-b502-61ca-aefa-3047a9dfe5cd@arinc9.com>
Date:   Fri, 10 Mar 2023 13:21:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 net 2/2] net: dsa: mt7530: set PLL frequency and trgmii
 only when trgmii is used
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, erkin.bozoglu@xeront.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230310073338.5836-1-arinc.unal@arinc9.com>
 <20230310073338.5836-2-arinc.unal@arinc9.com>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230310073338.5836-2-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.03.2023 10:33, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> As my testing on the MCM MT7530 switch on MT7621 SoC shows, setting the PLL
> frequency does not affect MII modes other than trgmii on port 5 and port 6.
> So the assumption is that the operation here called "setting the PLL
> frequency" actually sets the frequency of the TRGMII TX clock.
> 
> Make it so that it and the rest of the trgmii setup run only when the
> trgmii mode is used.
> 
> Tested rgmii and trgmii modes of port 6 on MCM MT7530 on MT7621AT Unielec
> U7621-06 and standalone MT7530 on MT7623NI Bananapi BPI-R2.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>   drivers/net/dsa/mt7530.c | 62 ++++++++++++++++++++--------------------
>   1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index b1a79460df0e..c2d81b7a429d 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -430,8 +430,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>   	switch (interface) {
>   	case PHY_INTERFACE_MODE_RGMII:
>   		trgint = 0;
> -		/* PLL frequency: 125MHz */
> -		ncpo1 = 0x0c80;
>   		break;
>   	case PHY_INTERFACE_MODE_TRGMII:
>   		trgint = 1;
> @@ -462,38 +460,40 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>   	mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
>   		   P6_INTF_MODE(trgint));
>   
> -	/* Lower Tx Driving for TRGMII path */
> -	for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
> -		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
> -			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
> -
> -	/* Disable MT7530 core and TRGMII Tx clocks */
> -	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
> -		   REG_GSWCK_EN | REG_TRGMIICK_EN);
> -
> -	/* Setup the MT7530 TRGMII Tx Clock */
> -	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
> -	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
> -	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
> -	core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
> -	core_write(priv, CORE_PLL_GROUP4,
> -		   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
> -		   RG_SYSPLL_BIAS_LPF_EN);
> -	core_write(priv, CORE_PLL_GROUP2,
> -		   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
> -		   RG_SYSPLL_POSDIV(1));
> -	core_write(priv, CORE_PLL_GROUP7,
> -		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
> -		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
> -
> -	/* Enable MT7530 core and TRGMII Tx clocks */
> -	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
> -		 REG_GSWCK_EN | REG_TRGMIICK_EN);
> -
> -	if (!trgint)
> +	if (trgint) {
> +		/* Lower Tx Driving for TRGMII path */
> +		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
> +			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
> +				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
> +
> +		/* Disable MT7530 core and TRGMII Tx clocks */
> +		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
> +			   REG_GSWCK_EN | REG_TRGMIICK_EN);
> +
> +		/* Setup the MT7530 TRGMII Tx Clock */
> +		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
> +		core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
> +		core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
> +		core_write(priv, CORE_PLL_GROUP11, RG_LCDDS_SSC_DELTA1(ssc_delta));
> +		core_write(priv, CORE_PLL_GROUP4,
> +			   RG_SYSPLL_DDSFBK_EN | RG_SYSPLL_BIAS_EN |
> +			   RG_SYSPLL_BIAS_LPF_EN);
> +		core_write(priv, CORE_PLL_GROUP2,
> +			   RG_SYSPLL_EN_NORMAL | RG_SYSPLL_VODEN |
> +			   RG_SYSPLL_POSDIV(1));
> +		core_write(priv, CORE_PLL_GROUP7,
> +			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
> +			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
> +
> +		/* Enable MT7530 core and TRGMII Tx clocks */
> +		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
> +			 REG_GSWCK_EN | REG_TRGMIICK_EN);
> +	} else {
>   		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
>   			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
>   				   RD_TAP_MASK, RD_TAP(16));

This code runs if the phy mode is not trgmii. Other than trgmii, only 
the rgmii mode is supported on the hardware so this runs when the rgmii 
mode is used on port 6.

I've tested the rgmii mode on MCM and standalone MT7530 without running 
this code and it works fine. Close to gigabit download/upload speed and 
no packet loss. I don't understand why the TRGMII RX registers are 
modified when the trgmii mode is not used at all.

I don't suppose anyone from MediaTek would clarify, so this presumably 
dead code will remain.

Arınç
