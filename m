Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985102C3DA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfE1KC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:02:57 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35992 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbfE1KC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 06:02:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Q1VHDGzgL0w+olXUMQP8460gADhB+uZ7jGkSvHL7CUw=; b=0thbHizvQwcU2jqoA8h2NxF2i
        nHbpLg5Zv3ytPVXJTcw9yCqxG+XnFjlTFBr8ViP296zm1Ta2IkhnxPhdeknLSX2g/BBH3Aytkm08v
        qaBOoQXqyLAZvLHOzL6ZjBjglz6VQ7DyO7cJx3/MPoZNRIXKzxBy28v3IluRcbzan0075k+QoLVh7
        MQDSxJNCy1KPXOr8A+q4R+k7qS3wdGbQ2ztvopZKIgE5T+sgq2w+7+2tRzW5kiEfSAoBnehxFIlj4
        9PaWJ93awaqgwLYPJcETQUX9hBDRVpGgYoW9uMApVnuN2lfg22fC4cvnEDRlD/uUxrVRe07vOIQm3
        EDIgJPB8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52666)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hVYwV-00051E-TS; Tue, 28 May 2019 11:02:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hVYwT-0003Sy-9N; Tue, 28 May 2019 11:02:49 +0100
Date:   Tue, 28 May 2019 11:02:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/5] net: phylink: support for link gpio
 interrupt
Message-ID: <20190528100249.bpm4gieiatziqwqd@shell.armlinux.org.uk>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
 <E1hVYrD-0005Z1-L0@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYrD-0005Z1-L0@rmk-PC.armlinux.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

I was intending to add a note to this patch indicating that it
depends on "net: phylink: ensure consistent phy interface mode" but
failed to do before sending it out - sorry!  If you'd prefer a patch
that doesn't depend on that, please ask.  The only difference is the
first two lines of context of the first hunk.

Russell.

On Tue, May 28, 2019 at 10:57:23AM +0100, Russell King wrote:
> Add support for using GPIO interrupts with a fixed-link GPIO rather than
> polling the GPIO every second and invoking the phylink resolution.  This
> avoids unnecessary calls to mac_config().
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 219a061572d2..00cd0ed7ff3d 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -56,6 +56,7 @@ struct phylink {
>  	phy_interface_t cur_interface;
>  
>  	struct gpio_desc *link_gpio;
> +	unsigned int link_irq;
>  	struct timer_list link_poll;
>  	void (*get_fixed_state)(struct net_device *dev,
>  				struct phylink_link_state *s);
> @@ -612,7 +613,7 @@ void phylink_destroy(struct phylink *pl)
>  {
>  	if (pl->sfp_bus)
>  		sfp_unregister_upstream(pl->sfp_bus);
> -	if (!IS_ERR_OR_NULL(pl->link_gpio))
> +	if (pl->link_gpio)
>  		gpiod_put(pl->link_gpio);
>  
>  	cancel_work_sync(&pl->resolve);
> @@ -875,6 +876,15 @@ void phylink_mac_change(struct phylink *pl, bool up)
>  }
>  EXPORT_SYMBOL_GPL(phylink_mac_change);
>  
> +static irqreturn_t phylink_link_handler(int irq, void *data)
> +{
> +	struct phylink *pl = data;
> +
> +	phylink_run_resolve(pl);
> +
> +	return IRQ_HANDLED;
> +}
> +
>  /**
>   * phylink_start() - start a phylink instance
>   * @pl: a pointer to a &struct phylink returned from phylink_create()
> @@ -910,7 +920,22 @@ void phylink_start(struct phylink *pl)
>  	clear_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
>  	phylink_run_resolve(pl);
>  
> -	if (pl->link_an_mode == MLO_AN_FIXED && !IS_ERR(pl->link_gpio))
> +	if (pl->link_an_mode == MLO_AN_FIXED && pl->link_gpio) {
> +		int irq = gpiod_to_irq(pl->link_gpio);
> +
> +		if (irq > 0) {
> +			if (!request_irq(irq, phylink_link_handler,
> +					 IRQF_TRIGGER_RISING |
> +					 IRQF_TRIGGER_FALLING,
> +					 "netdev link", pl))
> +				pl->link_irq = irq;
> +			else
> +				irq = 0;
> +		}
> +		if (irq <= 0)
> +			mod_timer(&pl->link_poll, jiffies + HZ);
> +	}
> +	if (pl->link_an_mode == MLO_AN_FIXED && pl->get_fixed_state)
>  		mod_timer(&pl->link_poll, jiffies + HZ);
>  	if (pl->sfp_bus)
>  		sfp_upstream_start(pl->sfp_bus);
> @@ -936,8 +961,11 @@ void phylink_stop(struct phylink *pl)
>  		phy_stop(pl->phydev);
>  	if (pl->sfp_bus)
>  		sfp_upstream_stop(pl->sfp_bus);
> -	if (pl->link_an_mode == MLO_AN_FIXED && !IS_ERR(pl->link_gpio))
> -		del_timer_sync(&pl->link_poll);
> +	del_timer_sync(&pl->link_poll);
> +	if (pl->link_irq) {
> +		free_irq(pl->link_irq, pl);
> +		pl->link_irq = 0;
> +	}
>  
>  	phylink_run_resolve_and_disable(pl, PHYLINK_DISABLE_STOPPED);
>  }
> -- 
> 2.7.4
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
