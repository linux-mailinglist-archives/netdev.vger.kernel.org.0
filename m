Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332B648785C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 14:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbiAGNl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 08:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238856AbiAGNl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 08:41:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2860C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 05:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xuYHRMLGtmymVFu0gr+lqhnJwVI4As9VHFJ8t6DEISk=; b=grguA+xWQ5ZcfLs4SuWkUMm7bU
        KYWo9OVlS3HXv9eEF9h1nnmZXD0zRgzfsVys4M5xRKo7CnOgvF54TVibIj0PnXbHyWspNQUp1ue0a
        6WVH/8vV2/hScSlOrfk800+0mJx9O6zOlEuIJRuJaBtzfuLMUPIv6j14UH7iZUwFmmSS+NAOkhSSO
        skBIZvWrvpg1P0H/QZdUlTYjmp8gMkdYIFt0QYfTzWS+rgJcFOPb2DwtDrqxYA2jV+ska7HgO6dzh
        X9NpUqp9/1uxqgl3Hwhf8gRKGkcvYcZgtCFWTopJn4pLj1RC7HvktiTh/qXmVAcYKZnPjAvJ7ou7O
        SbdxMcjA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56614)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n5pUg-0001TH-8Q; Fri, 07 Jan 2022 13:41:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n5pUe-0001yJ-Hy; Fri, 07 Jan 2022 13:41:20 +0000
Date:   Fri, 7 Jan 2022 13:41:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH CFT net-next] net: enetc: use .mac_select_pcs() interface
Message-ID: <YdhDAHxFaUhiQFbd@shell.armlinux.org.uk>
References: <E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1mxq4r-00GWrp-Ay@rmk-PC.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 12:41:41PM +0000, Russell King (Oracle) wrote:
> Convert the PCS selection to use mac_select_pcs, which allows the PCS
> to perform any validation it needs.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Hi,

Can anyone test this please? Claudiu?

Russell.

> ---
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index fe6a544f37f0..1f5bc8fe0a3c 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -930,18 +930,21 @@ static void enetc_mdiobus_destroy(struct enetc_pf *pf)
>  	enetc_imdio_remove(pf);
>  }
>  
> +static struct phylink_pcs *
> +enetc_pl_mac_select_pcs(struct phylink_config *config, phy_interface_t iface)
> +{
> +	struct enetc_pf *pf = phylink_to_enetc_pf(config);
> +
> +	return pf->pcs ? &pf->pcs->pcs : NULL;
> +}
> +
>  static void enetc_pl_mac_config(struct phylink_config *config,
>  				unsigned int mode,
>  				const struct phylink_link_state *state)
>  {
>  	struct enetc_pf *pf = phylink_to_enetc_pf(config);
> -	struct enetc_ndev_priv *priv;
>  
>  	enetc_mac_config(&pf->si->hw, state->interface);
> -
> -	priv = netdev_priv(pf->si->ndev);
> -	if (pf->pcs)
> -		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
>  }
>  
>  static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
> @@ -1058,6 +1061,7 @@ static void enetc_pl_mac_link_down(struct phylink_config *config,
>  
>  static const struct phylink_mac_ops enetc_mac_phylink_ops = {
>  	.validate = phylink_generic_validate,
> +	.mac_select_pcs = enetc_pl_mac_select_pcs,
>  	.mac_config = enetc_pl_mac_config,
>  	.mac_link_up = enetc_pl_mac_link_up,
>  	.mac_link_down = enetc_pl_mac_link_down,
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
