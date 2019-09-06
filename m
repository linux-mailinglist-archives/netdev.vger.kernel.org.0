Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5F5AC110
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 21:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389846AbfIFT5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 15:57:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbfIFT5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 15:57:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SG6oij7h9GgLEKoDOjmDVQiWQWa23NrZemLffdZLI3M=; b=QrdF/hfAwib0aXzbCEe2e+d0La
        ulYwqxBpKyyC0HNo2MSCcEgh8a++p0IeajFjn82D/Q4ZNf6Qr1o+cpsZvFUT+CbFJYl6GI25GPIdi
        v9DLtM8JSJr8OJTnDyeyqsgNK9KOupNKzHDOpZmuneSACiSQIri/wLOHzZiPy3BnT7uI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6KMZ-0001FP-RS; Fri, 06 Sep 2019 21:57:43 +0200
Date:   Fri, 6 Sep 2019 21:57:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] enetc: Fix if_mode extraction
Message-ID: <20190906195743.GD2339@lunn.ch>
References: <1567779344-30965-1-git-send-email-claudiu.manoil@nxp.com>
 <1567779344-30965-2-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567779344-30965-2-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 05:15:40PM +0300, Claudiu Manoil wrote:
> Fix handling of error return code. Before this fix,
> the error code was handled as unsigned type.
> Also, on this path if if_mode not found then just handle
> it as fixed link (i.e mac2mac connection).
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> ---
>  drivers/net/ethernet/freescale/enetc/enetc_pf.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 7d6513ff8507..3a556646a2fb 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -751,6 +751,7 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
>  	struct enetc_pf *pf = enetc_si_priv(priv->si);
>  	struct device_node *np = priv->dev->of_node;
>  	struct device_node *mdio_np;
> +	int phy_mode;
>  	int err;
>  
>  	if (!np) {
> @@ -784,17 +785,11 @@ static int enetc_of_get_phy(struct enetc_ndev_priv *priv)
>  		}
>  	}
>  
> -	priv->if_mode = of_get_phy_mode(np);
> -	if (priv->if_mode < 0) {
> -		dev_err(priv->dev, "missing phy type\n");
> -		of_node_put(priv->phy_node);
> -		if (of_phy_is_fixed_link(np))
> -			of_phy_deregister_fixed_link(np);
> -		else
> -			enetc_mdio_remove(pf);
> -
> -		return -EINVAL;
> -	}

Hi Claudiu

It is not clear to me why it is no longer necessary to deregister the
fixed link, or remove the mdio bus?

> +	phy_mode = of_get_phy_mode(np);
> +	if (phy_mode < 0)
> +		priv->if_mode = PHY_INTERFACE_MODE_NA; /* fixed link */
> +	else
> +		priv->if_mode = phy_mode;

Thanks
	Andrew
