Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32A74B2D83
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352845AbiBKT2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:28:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352761AbiBKT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:28:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ACD1AF;
        Fri, 11 Feb 2022 11:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=soWypdnW1ec+w+7VziF0ljzkm3YcG0g2Y1CUqz60f/U=; b=E1
        8yINSOMEzpD3OeoOuT7gbIp+Nj5EI5xzErZMOyGakkUG73QJfqS0KoB/yiqUulDi+uInBLWHTfnaz
        EBiLOvBplIYDQZERs3qJ9FknOyB7A2Vj+doI3tnqPwQp+7Ctpcna2cuEQDPdJL+OARRJUnmMRC+r+
        XboAb3r5Kr43iSc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nIbaK-005Vpe-Np; Fri, 11 Feb 2022 20:28:00 +0100
Date:   Fri, 11 Feb 2022 20:28:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: fix reset on probe
Message-ID: <Yga4wD+pkn6B45Iz@lunn.ch>
References: <20220209145454.19749-1-mans@mansr.com>
 <YgPlVGclJOkvLZ1i@lunn.ch>
 <yw1x1r0c5794.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1x1r0c5794.fsf@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 04:34:15PM +0000, Måns Rullgård wrote:
> Andrew Lunn <andrew@lunn.ch> writes:
> 
> > On Wed, Feb 09, 2022 at 02:54:54PM +0000, Mans Rullgard wrote:
> >> The reset input to the LAN9303 chip is active low, and devicetree
> >> gpio handles reflect this.  Therefore, the gpio should be requested
> >> with an initial state of high in order for the reset signal to be
> >> asserted.  Other uses of the gpio already use the correct polarity.
> >> 
> >> Signed-off-by: Mans Rullgard <mans@mansr.com>
> >> ---
> >>  drivers/net/dsa/lan9303-core.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
> >> index aa1142d6a9f5..2de67708bbd2 100644
> >> --- a/drivers/net/dsa/lan9303-core.c
> >> +++ b/drivers/net/dsa/lan9303-core.c
> >> @@ -1301,7 +1301,7 @@ static int lan9303_probe_reset_gpio(struct lan9303 *chip,
> >>  				     struct device_node *np)
> >>  {
> >>  	chip->reset_gpio = devm_gpiod_get_optional(chip->dev, "reset",
> >> -						   GPIOD_OUT_LOW);
> >> +						   GPIOD_OUT_HIGH);
> >>  	if (IS_ERR(chip->reset_gpio))
> >>  		return PTR_ERR(chip->reset_gpio);
> >
> > lan9303_handle_reset() does a sleep and then releases the reset. I
> > don't see anywhere in the driver which asserts the reset first. So is
> > it actually asserted as part of this getting the GPIO? And if so, does
> > not this change actually break the reset?
> 
> The GPIOD_OUT_xxx flags to gpiod_get() request that the pin be
> configured as output and set to high/low initially.  The GPIOD_OUT_LOW
> currently used by the lan9303 driver together with GPIO_ACTIVE_LOW in
> the devicetrees results in the actual voltage being set high.  The
> driver then sleeps for a bit before setting the gpio value to zero,
> again translated to a high output voltage.  That is, the value set after
> the sleep is the same as it was initially.  This is obviously not the
> intent.

Yes, i agree. I'm just wondering how this worked for whoever
implemented this code. I guess it never actually did a reset, or the
bootloader left the reset already in the asserted state, so that the
gpiod_get() actual deasserted the reset?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
