Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2558757DCBA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbiGVIpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234860AbiGVIpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:45:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2332F820F8;
        Fri, 22 Jul 2022 01:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iNYJiyysx60oEnrX2De1alRaWHvDmswVZ8hE6v/Ro3o=; b=xDJWFSM4ZFovqGy2DUtYWJe3J1
        YTEWjm3oJ2+QXeSR0ZuQRSQ86npRBowjBiqOT4hvP1hXs9GII4xXEsfoBunlmHxvQssujNV7WwELZ
        HvDKisDSqS9sZ+wPiBXO/Dx2bc9dPGO4YngkouBb2tzPODh3z+fGR9bVdZSJyBx6kVbqo5o5zrlVl
        VFhHxWDZjohBrNe2cZ1W70dU6P85duFdlGepX+MTsefFhHadub0zc5WGGbwtluiQkbK8aY9xghVrz
        7L6jJma3XDigmxv3BiabiXiEDL79jHelPbgNnfr7idgxMnxy6+hIgWaLSGGbtuqf7t31GtvhIjYDI
        EYp2M4gg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33502)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oEoHo-0006fT-Mv; Fri, 22 Jul 2022 09:45:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oEoHm-0005h9-Er; Fri, 22 Jul 2022 09:45:26 +0100
Date:   Fri, 22 Jul 2022 09:45:26 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 07/11] net: phylink: Adjust link settings based on
 rate adaptation
Message-ID: <YtpjpowrI3VEyGs2@shell.armlinux.org.uk>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-8-sean.anderson@seco.com>
 <YtelzB1uO0zACa42@shell.armlinux.org.uk>
 <YthKSYje5e+swg08@shell.armlinux.org.uk>
 <84f4f37e-044c-0fd8-7ba4-cba54200d9fe@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84f4f37e-044c-0fd8-7ba4-cba54200d9fe@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:48:05PM -0400, Sean Anderson wrote:
> On 7/20/22 2:32 PM, Russell King (Oracle) wrote:
> > On Wed, Jul 20, 2022 at 07:50:52AM +0100, Russell King (Oracle) wrote:
> >> We can do that by storing the PHY rate adaption state, and processing
> >> that in phylink_link_up().
> > 
> > Something like this? I haven't included the IPG (open loop) stuff in
> > this - I think when we come to implement that, we need a new mac
> > method to call to set the IPG just before calling mac_link_up().
> > Something like:
> > 
> >  void mac_set_ipg(struct phylink_config *config, int packet_speed,
> > 		  int interface_speed);
> > 
> > Note that we also have PCS that do rate adaption too, and I think
> > fitting those in with the code below may be easier than storing the
> > media and phy interface speed/duplex separately.
> 
> This is another area where the MAC has to know a lot about the PCS.
> We don't keep track of the PCS interface mode, so the MAC has to know
> how to connect to the PCS. That could already include some rate
> adaptation, but I suspect it is all done like GMII (where the clock
> speed changes).

In many cases, we don't even know what the interface used to connect the
PCS to the MAC actually is (we'd have to use something like _INTERNAL).
Particularly when the PCS and MAC are integrated on the same die,
manufacturers tend not to tell people how the two blocks are connected.

Even if we assume did use GMII internally for everything (and I mean
everything), then decoding the GMII interface mode to mean SPEED_1000
won't work for anything over 1G speeds - so we can't do that. The
more I think about it, the less meaning the interface mode between
the PCS and MAC is for our purposes - unless we positively know for
every device what that mode is, and can reliably translate that into
the speed of that connection to derive the correct "speed" for the
MAC.

The point of bringing this up was just to bear it in mind, and I
think when we add support for this, then...

> >  static void phylink_link_up(struct phylink *pl,
> >  			    struct phylink_link_state link_state)
> >  {
> >  	struct net_device *ndev = pl->netdev;
> > +	int speed, duplex;
> > +	bool rx_pause;
> > +
> > +	speed = link_state.speed;
> > +	duplex = link_state.duplex;
> > +	rx_pause = !!(link_state.pause & MLO_PAUSE_RX);
> > +
> > +	switch (state->rate_adaption) {
> > +	case RATE_ADAPT_PAUSE:
> > +		/* The PHY is doing rate adaption from the media rate (in
> > +		 * the link_state) to the interface speed, and will send
> > +		 * pause frames to the MAC to limit its transmission speed.
> > +		 */
> > +		speed = phylink_interface_max_speed(link_state.interface);
> > +		duplex = DUPLEX_FULL;
> > +		rx_pause = true;
> > +		break;
> > +
> > +	case RATE_ADAPT_CRS:
> > +		/* The PHY is doing rate adaption from the media rate (in
> > +		 * the link_state) to the interface speed, and will cause
> > +		 * collisions to the MAC to limit its transmission speed.
> > +		 */
> > +		speed = phylink_interface_max_speed(link_state.interface);
> > +		duplex = DUPLEX_HALF;
> > +		break;
> > +	}
> >  
> >  	pl->cur_interface = link_state.interface;
> >  
> >  	if (pl->pcs && pl->pcs->ops->pcs_link_up)
> >  		pl->pcs->ops->pcs_link_up(pl->pcs, pl->cur_link_an_mode,
> > -					 pl->cur_interface,
> > -					 link_state.speed, link_state.duplex);
> > +					 pl->cur_interface, speed, duplex);
> >  

... we would want to update the speed, duplex and rx_pause parameters
here for the MAC.

> >  	pl->mac_ops->mac_link_up(pl->config, pl->phydev,
> >  				 pl->cur_link_an_mode, pl->cur_interface,
> > -				 link_state.speed, link_state.duplex,
> > +				 speed, duplex,
> >  				 !!(link_state.pause & MLO_PAUSE_TX),
> > -				 !!(link_state.pause & MLO_PAUSE_RX));
> > +				 rx_pause);

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
