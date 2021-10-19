Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C9F43381B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhJSOPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:15:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46686 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhJSOPA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:15:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dxAB3/KI9gLEOMDEfLD6UlFEaKIHK37cTRFK56RYQ1s=; b=lkgtla6QQliqlIOSh91D1xnw/e
        Q17Um7/THybOKNk6gCcZq8cL/vuavdOLGJ33EL6iiZiCdokXGy0x8oBFIWKNrVydBJ8iKcHRK6NtF
        YkS6LUjxyCQrpYLmLI5/HClHPWWphnnCmRlHJ9I8EmleUit1CcafKR9Rg8sRRtZfsTJY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcpr6-00B5FF-Sl; Tue, 19 Oct 2021 16:12:40 +0200
Date:   Tue, 19 Oct 2021 16:12:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: fec: defer probe if PHY on external MDIO bus is not
 available
Message-ID: <YW7SWKiUy8LfvSkl@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 01:30:43PM +0200, Matthias Schiffer wrote:
> On some SoCs like i.MX6UL it is common to use the same MDIO bus for PHYs
> on both Ethernet controllers. Currently device trees for such setups
> have to make assumptions regarding the probe order of the controllers:
> 
> For example in imx6ul-14x14-evk.dtsi, the MDIO bus of fec2 is used for
> the PHYs of both fec1 and fec2. The reason is that fec2 has a lower
> address than fec1 and is thus loaded first, so the bus is already
> available when fec1 is probed.
> 
> Besides being confusing, this limitation also makes it impossible to use
> the same device tree for variants of the i.MX6UL with one Ethernet
> controller (which have to use the MDIO of fec1, as fec2 does not exist)
> and variants with two controllers (which have to use fec2 because of the
> load order).
> 
> To fix this, defer the probe of the Ethernet controller when the PHY is
> not on our own MDIO bus and not available.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 47a6fc702ac7..dc070dd216e8 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -3820,7 +3820,28 @@ fec_probe(struct platform_device *pdev)
>  		goto failed_stop_mode;
>  
>  	phy_node = of_parse_phandle(np, "phy-handle", 0);
> -	if (!phy_node && of_phy_is_fixed_link(np)) {
> +	if (phy_node) {
> +		struct device_node *mdio_parent =
> +			of_get_next_parent(of_get_parent(phy_node));
> +
> +		ret = 0;
> +
> +		/* Skip PHY availability check for our own MDIO bus to avoid
> +		 * cyclic dependency
> +		 */
> +		if (mdio_parent != np) {
> +			struct phy_device *phy = of_phy_find_device(phy_node);
> +
> +			if (phy)
> +				put_device(&phy->mdio.dev);
> +			else
> +				ret = -EPROBE_DEFER;
> +		}

I've not looked at the details yet, just back from vacation. But this
seems wrong. I would of expected phylib to of returned -EPRODE_DEFER
at some point, when asked for a PHY which does not exist yet. All the
driver should need to do is make sure it returns the
-EPRODE_DEFER.

       Andrew
