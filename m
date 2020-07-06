Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D86216070
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGFUm1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbgGFUm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:42:26 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C9EC061755;
        Mon,  6 Jul 2020 13:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kjc+i1Ow6AGEI/8UmiAWIVEudBZeCQL7t56EDRRq/Ls=; b=MIkuIgJMIqdETfNCL3n847E40
        Wb0ekcn2OLahMEs0hWJb2A2EnVA2Oy4VJHiKAHlhIAXhHvegQcO8eFORTceME+3UQ/OW+NmVDc2+w
        11+ONZNOhxs7+LRekH/dOdI2tU7qhMFeqZMXhxAgFlWeXDuI4Ktc4tpMvsIIRkCZFXKGQ8ehHBBo4
        5k35Y/0HmpFCREhBPJBfvjXmni6ZSHhcyabewqGqNEYWm4nHi5Ic1RN8OgATan0XchJAORcW0Ik5o
        R7icLtogIFIedgbLbCNwGQagMm8JS+oVGEkdlS2taTT55W/RrfNuO87m/I2lbwV5OEbfR5EOx/qEJ
        TLILAkYXw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36170)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jsXwW-0006OZ-FJ; Mon, 06 Jul 2020 21:42:24 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jsXwW-0006E6-7y; Mon, 06 Jul 2020 21:42:24 +0100
Date:   Mon, 6 Jul 2020 21:42:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Chris Healy <cphealy@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sfp: Unique GPIO interrupt names
Message-ID: <20200706204224.GW1551@shell.armlinux.org.uk>
References: <CAFXsbZp5A7FHoXPA6Rg8XqZPD9NXmSeZZb-RsEGXnktbo04GOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFXsbZp5A7FHoXPA6Rg8XqZPD9NXmSeZZb-RsEGXnktbo04GOw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 12:38:37PM -0700, Chris Healy wrote:
> Dynamically generate a unique GPIO interrupt name, based on the
> device name and the GPIO name.  For example:
> 
> 103:          0   sx1503q  12 Edge      sff2-los
> 104:          0   sx1503q  13 Edge      sff3-los
> 
> The sffX indicates the SFP the loss of signal GPIO is associated with.
> 
> Signed-off-by: Chris Healy <cphealy@gmail.com>

This doesn't work in all cases.

> ---
>  drivers/net/phy/sfp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 73c2969f11a4..9b03c7229320 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -220,6 +220,7 @@ struct sfp {
>      struct phy_device *mod_phy;
>      const struct sff_data *type;
>      u32 max_power_mW;
> +    char sfp_irq_name[32];
> 
>      unsigned int (*get_state)(struct sfp *);
>      void (*set_state)(struct sfp *, unsigned int);
> @@ -2349,12 +2350,15 @@ static int sfp_probe(struct platform_device *pdev)
>              continue;
>          }
> 
> +        snprintf(sfp->sfp_irq_name, sizeof(sfp->sfp_irq_name),
> +             "%s-%s", dev_name(sfp->dev), gpio_of_names[i]);

sfp_irq_name will be overwritten for each GPIO IRQ claimed, which means
all IRQs for a particular cage will end up with the same name.
sfp_irq_name[] therefore needs to be an array of names, one per input.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
