Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF96CB1E8
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 00:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbjC0WpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 18:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjC0WpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 18:45:12 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B341BD1
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 15:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O3PiLZEodVQXquoPcarG0T/godQmoWlccEm+Zlw/lng=; b=jecUZzVkWpOkAyrWnqO0IlPNi3
        H3imeeaU2eHz9RBuH64uuvxLFxw4AZmrOaiMRU5LT0VQr37186/AgcR/IaAL8AuI+S5MKHLuqZunC
        1O29PYYXL6y01yeQgE/Y+g6A2ONDwHrQMeEIH4JAOkS8wKCAAD2ao+VLnzbFi8MH4Wu0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgvaO-008Zhg-Nk; Tue, 28 Mar 2023 00:45:08 +0200
Date:   Tue, 28 Mar 2023 00:45:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 02/23] net: phylink: Plumb eee_active in mac_link_up
 call
Message-ID: <8335cddd-dc5d-4a50-913a-01b748550225@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-3-andrew@lunn.ch>
 <ZCIQYJVMoG3RUfN3@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCIQYJVMoG3RUfN3@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 10:53:36PM +0100, Russell King (Oracle) wrote:
> Hi Andrew,
> 
> Thinking about this more having read the follow-on patches, I retract
> my r-b tag, because there is an issue that needs solving.
> 
> On Mon, Mar 27, 2023 at 07:01:40PM +0200, Andrew Lunn wrote:
> > @@ -1257,7 +1260,8 @@ static void phylink_link_up(struct phylink *pl,
> >  
> >  	pl->mac_ops->mac_link_up(pl->config, pl->phydev, pl->cur_link_an_mode,
> >  				 pl->cur_interface, speed, duplex,
> > -				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause);
> > +				 !!(link_state.pause & MLO_PAUSE_TX), rx_pause,
> > +				 eee_active);
> 
> In one of your later patches, you have phylib call phy_link_up() when
> the state changes as a result of configuration. That will cause
> phy_link_change(), which will update phylink's stored link state, and
> trigger phylink to re-resolve the link.
> 
> However, phylink guarantees that mac_link_up() will only be called
> if mac_link_down() was previously called. This will *not* cause
> mac_link_up() to be called.

Ah, O.K.

> 
> Moreover, we don't want mac_link_up() to be called because the link
> hasn't gone down and to do so will violate that guarantee that
> phylink makes to MAC drivers.

O.K. I don't think phylib makes the same guarantee.

> So, I don't think this is going to work fully as seems to be intended,
> if I'm understanding things correctly.

You are correct. If the EEE configuration is changed and an auto-neg
is not required, i was not intending to force an autoneg so the link
goes down and up again.

> Maybe we should have a new mac_set_eee() method which we can call
> when the EEE state changes? Would we need to call it with the LPI
> delay parameter and wheneever that changes, or should we rely on
> the MAC to do that?

For the current hardware, the MAC gets all the parameters passed as
part of the ethtool set call. They write the delay parameters to
hardware. And then there is one bit to enable/disable the us of EEE.
So the mac_set_eee() callback should only need to pass a boolean.

>What if the LPI parameter is dependent on the
> speed the MAC is operating? Just brain-storming...

None of the current hardware needs that. And we only need to call
mac_set_eee() when the link is up, so the MAC probably knows the link
speed one way or another.

I will rework this code with a new callback.

  Andrew
