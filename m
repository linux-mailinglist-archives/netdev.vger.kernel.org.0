Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2A7165268
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgBSWVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 17:21:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54400 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgBSWVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 17:21:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rEr0lTeockNjXTKUWfbUWgXlvTp8sYO0SIkMHrOrdkg=; b=gOKjOtmHkZpQtji5vmITgJJr+Q
        XME8ujB28RAKKcCUp8d/PqiaCwRBeZu8WwU8XwSoZN000bRzl6mzPcg1urCBT/Cn5ka0knmDeic/Q
        CmyXkVVOy5Oqtqhow979QTRvnhMx4RcsWjQRXu+E73jvawnXxZpHXI1qEAvxsOeHnUWU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j4XiJ-0002iE-Vt; Wed, 19 Feb 2020 23:21:03 +0100
Date:   Wed, 19 Feb 2020 23:21:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/2] net: phy: unregister MDIO bus in
 _devm_mdiobus_free if needed
Message-ID: <20200219222103.GZ31084@lunn.ch>
References: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
 <913abdae-0617-b411-7eaa-599588f95e32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <913abdae-0617-b411-7eaa-599588f95e32@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 09:34:57PM +0100, Heiner Kallweit wrote:
> If using managed MDIO bus handling (devm_mdiobus_alloc et al) we still
> have to manually unregister the MDIO bus. For drivers that don't depend
> on unregistering the MDIO bus at a specific, earlier point in time we
> can make driver author's life easier by automagically unregistering
> the MDIO bus. This extension is transparent to existing drivers.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/mdio_bus.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 9bb9f37f2..6af51cbdb 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -170,7 +170,12 @@ EXPORT_SYMBOL(mdiobus_alloc_size);
>  
>  static void _devm_mdiobus_free(struct device *dev, void *res)
>  {
> -	mdiobus_free(*(struct mii_bus **)res);
> +	struct mii_bus *bus = *(struct mii_bus **)res;
> +
> +	if (bus->state == MDIOBUS_REGISTERED)
> +		mdiobus_unregister(bus);
> +
> +	mdiobus_free(bus);
>  }

Hi Heiner

The API is rather asymmetric. The alloc is not just setting up a free,
but also an unregister. Are there other examples of this in the
kernel?

Maybe a devm_of_mdiobus_register() would be better? It is then clear
that the unregister happens because of this call, and the free because
of the devm_mdiobus_alloc().

   Andrew
