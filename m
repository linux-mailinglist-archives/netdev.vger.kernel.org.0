Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7E821750A8
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 23:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCAWwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 17:52:21 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42817 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgCAWwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 17:52:20 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5C4F723E4D;
        Sun,  1 Mar 2020 23:52:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1583103137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wlao0vvz3cqkolNr9Rq/ebCGjWK7ucuJ0poIQTfcyY4=;
        b=eZQKNnmPLoQXQrpt0iIpWMm8wZfHACKbjyPAU3u3AEhxa8Th/V4gAkynuHsQtFsR+dN/06
        pI3tzLBy2WOMJokewkSE3BvRUdNpW8bj2MvUCj6qhYhFlrf6k297/wbjbUwWGXXlb1g9Z3
        AABPTVAUNl9eUR1cd1TWoooAwO1TiuM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 01 Mar 2020 23:52:16 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: avoid clearing PHY interrupts twice in irq
 handler
In-Reply-To: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
References: <2f468a46-e966-761c-8466-51601d8f11a3@gmail.com>
Message-ID: <a0b161ebd332c9ea26bb62ccf73d1862@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 5C4F723E4D
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         RCPT_COUNT_FIVE(0.00)[6];
         DKIM_SIGNED(0.00)[];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-03-01 21:36, schrieb Heiner Kallweit:
> On all PHY drivers that implement did_interrupt() reading the interrupt
> status bits clears them. This means we may loose an interrupt that
> is triggered between calling did_interrupt() and phy_clear_interrupt().
> As part of the fix make it a requirement that did_interrupt() clears
> the interrupt.

Looks good. But how would you use did_interrupt() and handle_interrupt()
together? I guess you can't. At least not if handle_interrupt() has
to read the pending bits again. So you'd have to handle custom
interrupts in did_interrupt(). Any idea how to solve that?

[I know, this is only about fixing the lost interrupts.]

-michael

> 
> The Fixes tag refers to the first commit where the patch applies
> cleanly.
> 
> Fixes: 49644e68f472 ("net: phy: add callback for custom interrupt
> handler to struct phy_driver")
> Reported-by: Michael Walle <michael@walle.cc>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/phy.c | 3 ++-
>  include/linux/phy.h   | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index d76e038cf..16e3fb79e 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -727,7 +727,8 @@ static irqreturn_t phy_interrupt(int irq, void 
> *phy_dat)
>  		phy_trigger_machine(phydev);
>  	}
> 
> -	if (phy_clear_interrupt(phydev))
> +	/* did_interrupt() may have cleared the interrupt already */
> +	if (!phydev->drv->did_interrupt && phy_clear_interrupt(phydev))
>  		goto phy_err;
>  	return IRQ_HANDLED;
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 80f8b2158..8b299476b 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -557,6 +557,7 @@ struct phy_driver {
>  	/*
>  	 * Checks if the PHY generated an interrupt.
>  	 * For multi-PHY devices with shared PHY interrupt pin
> +	 * Set interrupt bits have to be cleared.
>  	 */
>  	int (*did_interrupt)(struct phy_device *phydev);
