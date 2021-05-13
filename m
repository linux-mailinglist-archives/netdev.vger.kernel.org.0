Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96F237F7AC
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhEMMRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232106AbhEMMRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 08:17:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09877C061574;
        Thu, 13 May 2021 05:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7k9evHuGH1EH6qhRcAGkUod6NxjxjEPFyoKIy7f4to0=; b=NNxrWdy161hnak7mWNQpC9Eev
        27zCcM95SPL7wXwwaTPw8lOEsGBeCK9+7d6SNHkPEFQavjMkz2A9M1i3606GciSHlrxd4AnU0hKFu
        OJZ7LlLbiio6pDc6zZHmFeAOKFOCcLqXFI6mxQBOTyYeL199clYHbKjWHhumeBRdR4taomFlKaplX
        IM79hNfGp1J1uv9P9k4xpdbQmXLUzwGcxC8eRGObcaiOLfVrRS01v+AMfSXilxMl6Nc/ezo2kqZbF
        Iks5Mj2fWmtnJAmuXnNi9O1g4VQGHF5OsublOeGE+kZ2hEJZgPHsFPlw9iSILV+KQYNfbCrgKx/PC
        4piaPok1w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43930)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lhAGa-00066X-Kv; Thu, 13 May 2021 13:16:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lhAGY-000307-Ty; Thu, 13 May 2021 13:16:34 +0100
Date:   Thu, 13 May 2021 13:16:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Daney <david.daney@cavium.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mdio: thunder: Do not unregister buses that have
 not been registered
Message-ID: <20210513121634.GX1336@shell.armlinux.org.uk>
References: <918382e19fdeb172f3836234d07e706460b7d06b.1620906605.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <918382e19fdeb172f3836234d07e706460b7d06b.1620906605.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 01:51:40PM +0200, Christophe JAILLET wrote:
> In the probe, if 'of_mdiobus_register()' fails, 'nexus->buses[i]' will
> still have a non-NULL value.
> So in the remove function, we will try to unregister a bus that has not
> been registered.
> 
> In order to avoid that NULLify 'nexus->buses[i]'.
> 'oct_mdio_writeq(0,...)' must also be called here.
> 
> Suggested-by: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Fixes: 379d7ac7ca31 ("phy: mdio-thunder: Add driver for Cavium Thunder SoC MDIO buses.")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Calling 'devm_mdiobus_free()' would also be cleaner, IMHO.
> I've not added it because:
>    - it should be fine, even without it
>    - I'm not sure how to use it

devm_mdiobus_free() is a static function not intended to be used by
drivers. There is no devm.*free() function available for this, so
this memory will only ever be freed when either probe fails or the
driver is unbound from its device.

That should be fine, but it would be nice to give that memory back
to the system. Without having a function for drivers to use though,
that's not possible. Such a function should take a struct device
pointer and the struct mii_bus pointer returned by the devm
allocation function.

So, unless Andrew things we really need to free that, what you're
doing below should be fine as far as setting the pointer to NULL.

I think I'd want comments from Cavium on setting the register to
zero - as we don't know how this hardware behaves, and whether that
would have implications we aren't aware of. So, I'm copying in
David Daney (the original driver author) for comment, if his email
address still works!

> ---
>  drivers/net/mdio/mdio-thunder.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
> index 822d2cdd2f35..140c405d4a41 100644
> --- a/drivers/net/mdio/mdio-thunder.c
> +++ b/drivers/net/mdio/mdio-thunder.c
> @@ -97,8 +97,14 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
>  		bus->mii_bus->write = cavium_mdiobus_write;
>  
>  		err = of_mdiobus_register(bus->mii_bus, node);
> -		if (err)
> +		if (err) {
>  			dev_err(&pdev->dev, "of_mdiobus_register failed\n");
> +			/* non-registered buses must not be unregistered in
> +			 * the .remove function
> +			 */
> +			oct_mdio_writeq(0, bus->register_base + SMI_EN);
> +			nexus->buses[i] = NULL;
> +		}
>  
>  		dev_info(&pdev->dev, "Added bus at %llx\n", r.start);
>  		if (i >= ARRAY_SIZE(nexus->buses))
> -- 
> 2.30.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
