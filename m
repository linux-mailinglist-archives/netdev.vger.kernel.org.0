Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7ED170BFB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 23:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgBZW4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 17:56:05 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:38231 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727326AbgBZW4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 17:56:05 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 313E023D1F;
        Wed, 26 Feb 2020 23:56:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582757762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QFnQld1YiH3x+ajkB7e6XYXbnpe2ypKAY7GtqHCjuYs=;
        b=hN7MQL2e09GMIp75aAe4eAFFGjlgIEhP9uFBmi7VsX9/9ofd8T5ehk+2unmrlkVI1QL1zQ
        mBoglyV2GQ9OOvyI1l8MOmKkNgU8q/N6GN4Lrz6sFHSmrxTsWqkTekDBgF8QTGRVP2z45N
        GereDqDozJ4jwn93DqB0K3PyZyXguNU=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 26 Feb 2020 23:56:02 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH 1/2] net: phy: let the driver register its own IRQ
 handler
In-Reply-To: <60985489-a6e9-dc13-68af-765d98116eb8@gmail.com>
References: <20200225230819.7325-1-michael@walle.cc>
 <20200225230819.7325-2-michael@walle.cc>
 <3c7e1064-845e-d193-24ad-965211bf1e9a@gmail.com>
 <18f531a691d0c4905552794bbb1be1e5@walle.cc>
 <60985489-a6e9-dc13-68af-765d98116eb8@gmail.com>
Message-ID: <2e4371354d84231abf3a63deae1a0d04@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 313E023D1F
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.278];
         FREEMAIL_TO(0.00)[gmail.com];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[vger.kernel.org,lunn.ch,gmail.com,armlinux.org.uk,davemloft.net];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-02-26 22:17, schrieb Heiner Kallweit:
> On 26.02.2020 12:12, Michael Walle wrote:
>> Am 2020-02-26 08:27, schrieb Heiner Kallweit:
>>> On 26.02.2020 00:08, Michael Walle wrote:
>>>> There are more and more PHY drivers which has more than just the PHY
>>>> link change interrupts. For example, temperature thresholds or PTP
>>>> interrupts.
>>>> 
>>>> At the moment it is not possible to correctly handle interrupts for 
>>>> PHYs
>>>> which has a clear-on-read interrupt status register. It is also 
>>>> likely
>>>> that the current approach of the phylib isn't working for all PHYs 
>>>> out
>>>> there.
>>>> 
>>>> Therefore, this patch let the PHY driver register its own interrupt
>>>> handler. To notify the phylib about a link change, the interrupt 
>>>> handler
>>>> has to call the new function phy_drv_interrupt().
>>>> 
>>> 
>>> We have phy_driver callback handle_interrupt for custom interrupt
>>> handlers. Any specific reason why you can't use it for your purposes?
>> 
>> Yes, as mentioned above this wont work for PHYs which has a 
>> clear-on-read
>> status register, because you may loose interrupts between 
>> handle_interrupt()
>> and phy_clear_interrupt().
>> 
>> See also
>>  
>> https://lore.kernel.org/netdev/bd47f8e1ebc04fa98856ed8d89b91419@walle.cc/
>> 
>> And esp. Russell reply. I tried using handle_interrupt() but it won't 
>> work
>> unless you make the ack_interrupt a NOOP. but even then it won't work 
>> because
>> the ack_interrupt is also used during setup etc.
>> 
> Right, now I remember .. So far we have only one user of the 
> handle_interrupt
> callback. Following a proposal from the quoted discussion, can you base 
> your
> patch on the following and check?
> Note: Even though you implement handle_interrupt, you still have to 
> implement
> ack_interrupt too.

I guess that should work, I can give that a try. But I'm also preparing 
support
for the BCM54140, a quad PHY. I guess we have the same problem with
did_interrupt(). Eg. to tell if there actually was an interrupt from 
that PHY
you have to read the status register which clears the interrupt. So
handle_interrupt() will left with no actual interrupt pending bits. I've 
had a
look at how the vsc8584 does it as it also uses did_interrupt() together 
with
handle_interrupt() and it looks like it only works because 
handle_interrupt()
doesn't actually read the pending bits again. Also I guess there is a 
chance
of missing interrupts between vsc8584_did_interrupt() and
vsc85xx_ack_interrupt() which both clears interrupts. Although I'm not 
sure
if that matters for the current implementation.

-michael

> 
> 
> ---
>  drivers/net/phy/mscc.c | 3 ++-
>  drivers/net/phy/phy.c  | 4 ++--
>  include/linux/phy.h    | 4 +++-
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc.c b/drivers/net/phy/mscc.c
> index 937ac7da2..20b9d3ef5 100644
> --- a/drivers/net/phy/mscc.c
> +++ b/drivers/net/phy/mscc.c
> @@ -2868,7 +2868,8 @@ static int vsc8584_handle_interrupt(struct
> phy_device *phydev)
>  #endif
> 
>  	phy_mac_interrupt(phydev);
> -	return 0;
> +
> +	return vsc85xx_ack_interrupt(phydev);
>  }
> 
>  static int vsc85xx_config_init(struct phy_device *phydev)
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index d76e038cf..de52f0e82 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -725,10 +725,10 @@ static irqreturn_t phy_interrupt(int irq, void 
> *phy_dat)
>  	} else {
>  		/* reschedule state queue work to run as soon as possible */
>  		phy_trigger_machine(phydev);
> +		if (phy_clear_interrupt(phydev))
> +			goto phy_err;
>  	}
> 
> -	if (phy_clear_interrupt(phydev))
> -		goto phy_err;
>  	return IRQ_HANDLED;
> 
>  phy_err:
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 80f8b2158..9e2895ee4 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -560,7 +560,9 @@ struct phy_driver {
>  	 */
>  	int (*did_interrupt)(struct phy_device *phydev);
> 
> -	/* Override default interrupt handling */
> +	/* Override default interrupt handling. Handler has to ensure
> +	 * that interrupt is ack'ed.
> +	 */
>  	int (*handle_interrupt)(struct phy_device *phydev);
> 
>  	/* Clears up any memory if needed */
