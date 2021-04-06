Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D909355DB6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbhDFVPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238577AbhDFVPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 17:15:01 -0400
X-Greylist: delayed 311 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Apr 2021 14:14:52 PDT
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [IPv6:2001:67c:2050::465:202])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA88C06174A;
        Tue,  6 Apr 2021 14:14:52 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4FFKsT2wgxzQk12;
        Tue,  6 Apr 2021 23:09:33 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1617743371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7D1tCOVIQyD39zokQidkylCatT0fxYXu0tq4UKcYVWw=;
        b=Yl+l23NIJXPwSSQkns6c1hwZMrbFXKXmJHlbeaDuiUuCvCs1iIm+bZb3UTl4JAWcivONv/
        Cdoess5KlNuftgUmPCMpcGa70gJ3eAoHbYVtaqiAOO3ntKhfZlV8mLCqSUTypbY2OL1S4g
        3N0LwnpQO3gmEj8c/5UFH783mNY8kGv9K9DAtXB8lFflSIe9/0IEktdnmzZ6fVZUTp1yDT
        /7OCpjvzGrHRXjhQTFoab36az3Cwqc2S9aZisDrgYu8IV1iGxWNlWp+pK+utmwYjGKDCIE
        XR5des7wl7jyPutvoYReLetMWGkcRGv+lBTQnQjrhJgleER99oWhloM6e8r1YA==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id bYirQq6_v0k5; Tue,  6 Apr 2021 23:09:29 +0200 (CEST)
Subject: Re: [PATCH RFC net 2/2] net: dsa: lantiq_gswip: Configure all
 remaining GSWIP_MII_CFG bits
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210406203508.476122-1-martin.blumenstingl@googlemail.com>
 <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <c0cfd932-4ed4-63fa-3206-a5f4010486f1@hauke-m.de>
Date:   Tue, 6 Apr 2021 23:09:27 +0200
MIME-Version: 1.0
In-Reply-To: <20210406203508.476122-3-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -4.48 / 15.00 / 15.00
X-Rspamd-Queue-Id: 485D716FF
X-Rspamd-UID: 114376
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/21 10:35 PM, Martin Blumenstingl wrote:
> There are a few more bits in the GSWIP_MII_CFG register for which we
> did rely on the boot-loader (or the hardware defaults) to set them up
> properly.
> 
> For some external RMII PHYs we need to select the GSWIP_MII_CFG_RMII_CLK
> bit and also we should un-set it for non-RMII PHYs.

The GSWIP_MII_CFG_RMII_CLK option is ignored in other modes.

> The GSWIP IP also
> supports in-band auto-negotiation for RGMII PHYs. Set or unset the
> corresponding bit depending on the auto-negotiation mode.
> 
> Clear the xMII isolation bit when set at initialization time if it was
> previously set by the bootloader. Not doing so could lead to no traffic
> (neither RX nor TX) on a port with this bit set.
> 
> While here, also add the GSWIP_MII_CFG_RESET bit. We don't need to
> manage it because this bit is self-clearning when set. We still add it
> here to get a better overview of the GSWIP_MII_CFG register.
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Cc: stable@vger.kernel.org
> Suggested-by: Hauke Mehrtens <hauke@hauke-m.de>
> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>   drivers/net/dsa/lantiq_gswip.c | 22 +++++++++++++++++++---
>   1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 47ea3a8c90a4..f330035ed85b 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -93,8 +93,12 @@
>   
>   /* GSWIP MII Registers */
>   #define GSWIP_MII_CFGp(p)		(0x2 * (p))
> +#define  GSWIP_MII_CFG_RESET		BIT(15)
>   #define  GSWIP_MII_CFG_EN		BIT(14)
> +#define  GSWIP_MII_CFG_ISOLATE		BIT(13)
>   #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
> +#define  GSWIP_MII_CFG_RGMII_IBS	BIT(8)
> +#define  GSWIP_MII_CFG_RMII_CLK		BIT(7)
>   #define  GSWIP_MII_CFG_MODE_MIIP	0x0
>   #define  GSWIP_MII_CFG_MODE_MIIM	0x1
>   #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
> @@ -821,9 +825,11 @@ static int gswip_setup(struct dsa_switch *ds)
>   	/* Configure the MDIO Clock 2.5 MHz */
>   	gswip_mdio_mask(priv, 0xff, 0x09, GSWIP_MDIO_MDC_CFG1);
>   
> -	/* Disable the xMII link */
> +	/* Disable the xMII interface and clear it's isolation bit */
>   	for (i = 0; i < priv->hw_info->max_ports; i++)
> -		gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_EN, 0, i);
> +		gswip_mii_mask_cfg(priv,
> +				   GSWIP_MII_CFG_EN | GSWIP_MII_CFG_ISOLATE,
> +				   0, i);
>   
>   	/* enable special tag insertion on cpu port */
>   	gswip_switch_mask(priv, 0, GSWIP_FDMA_PCTRL_STEN,
> @@ -1597,19 +1603,29 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
>   		break;
>   	case PHY_INTERFACE_MODE_RMII:
>   		miicfg |= GSWIP_MII_CFG_MODE_RMIIM;
> +
> +		/* Configure the RMII clock as output: */
> +		miicfg |= GSWIP_MII_CFG_RMII_CLK;
>   		break;
>   	case PHY_INTERFACE_MODE_RGMII:
>   	case PHY_INTERFACE_MODE_RGMII_ID:
>   	case PHY_INTERFACE_MODE_RGMII_RXID:
>   	case PHY_INTERFACE_MODE_RGMII_TXID:
>   		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
> +
> +		if (phylink_autoneg_inband(mode))
> +			miicfg |= GSWIP_MII_CFG_RGMII_IBS;
>   		break;
>   	default:
>   		dev_err(ds->dev,
>   			"Unsupported interface: %d\n", state->interface);
>   		return;
>   	}
> -	gswip_mii_mask_cfg(priv, GSWIP_MII_CFG_MODE_MASK, miicfg, port);
> +
> +	gswip_mii_mask_cfg(priv,
> +			   GSWIP_MII_CFG_MODE_MASK | GSWIP_MII_CFG_RMII_CLK |
> +			   GSWIP_MII_CFG_RGMII_IBS | GSWIP_MII_CFG_LDCLKDIS,
> +			   miicfg, port);
>   
>   	gswip_port_set_link(priv, port, state->link);
>   	gswip_port_set_speed(priv, port, state->speed, state->interface);
> 

