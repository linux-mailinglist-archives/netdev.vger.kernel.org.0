Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CC46E499B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 15:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjDQNNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 09:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjDQNNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 09:13:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A847BB87;
        Mon, 17 Apr 2023 06:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FE2aYU852rz8VFM71Zf0NPY5Z8xae5dz5AyrnjR6CRk=; b=aJO/xqw0yuG5O0J+EcNakJf//S
        jzGliHgT+hO5VJysONNxACqWx9cAg62h2SZ5mS/OBrJE0Fer/DZJzEa9IP+R1H82atNsd49uJw+oy
        wsHrQS19ZtsSzuXogSnjNYeaw5qhXNof8ab5dvXe8qF3W1SaXJg9OmAL0YjB+t69jIpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poOeU-00AVCY-SX; Mon, 17 Apr 2023 15:12:14 +0200
Date:   Mon, 17 Apr 2023 15:12:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Herve Codina <herve.codina@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <a2615755-f009-4a21-b464-88ec5e58f32a@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
 <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
 <20230414165504.7da4116f@bootlin.com>
 <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
 <20230417121629.63e97b80@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417121629.63e97b80@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I'm surprised to see so much in the binding. I assume you are familiar
> > with DAHDI. It allows nearly everything to be configured at
> > runtime. The systems i've used allow you to select the clock
> > configuration, line build out, user side vs networks side signalling
> > CRC4 enables or not, etc.
> 
> Well, I am not familiar with DAHDI at all.
> I didn't even know about the DAHDI project.
> The project seems to use specific kernel driver and I would like to avoid
> these external drivers.

DAHDI is kind of the reference. Pretty much any Linux system being
used as a open source PBX runs Asterisk, and has the out of tree DAHDI
code to provide access to E1/T1 hardware and analogue POTS. I doubt it
will ever be merged into mainline, but i think it gives a good idea
what is needed to fully make use of such hardware.

I don't know what you application is. Are you using libpri for
signalling? How are you exposing the B channel to user space so that
libpri can use it?

> > > Further more, the QMC HDLC is not the only PEF2256 consumer.
> > > The PEF2256 is also used for audio path (ie audio over E1) and so the
> > > configuration is shared between network and audio. The setting cannot be
> > > handle by the network part as the PEF2256 must be available and correctly
> > > configured even if the network part is not present.  
> > 
> > But there is no reason why the MFD could not provide a generic PHY to
> > actually configure the 'PHY'. The HDLC driver can then also use the
> > generic PHY. It would make your generic PHY less 'pointless'. I'm not
> > saying it has to be this way, but it is an option.
> 
> If the pef2256 PHY provides a configure function, who is going to call this
> configure(). I mean the one calling the configure will be the configuration
> owner. None of the MFD child can own the configuration as this configuration
> will impact other children. So the MFD (top level node) owns the configuration.

Fine. Nothing unusual there. The netdev owns the configuration for an
Ethernet device. The MAC driver passes a subset down to any generic
PHY being used to implement a SERDES.

You could have the same architecture here. The MFD implements a
standardised netlink API for configuring E1/T1/J1 devices. Part of it
gets passed to the framer, which could be part of a generic PHY. I
assume you also need to configure the HDLC hardware. It needs to know
if it is using the whole E1 channel in unframed mode, or it should do
a fractional link, using a subset of slots, or is just using one slot
for 64Kbps, which would be an ISDN B channel.

> > > > In fact, this PHY driver does not seem to do any configuration of any
> > > > sort on the framer. All it seems to be doing is take notification from
> > > > one chain and send them out another chain!  
> > > 
> > > Configuration is done by the parent MFD driver.
> > > The PHY driver has nothing more to do.
> > >   
> > > > 
> > > > I also wounder if this get_status() call is sufficient. Don't you also
> > > > want Red, Yellow and Blue alarms? It is not just the carrier is down,
> > > > but why it is down.  
> > > 
> > > I don't need them in my use case but if needed can't they be added later?
> > > Also, from the HDLC device point of view what can be done with these alarms?  
> > 
> > https://elixir.bootlin.com/linux/latest/source/Documentation/networking/ethtool-netlink.rst#L472
> 
> Thanks for pointing this interface.
> It is specific to ethtool but I can see the idea.

Don't equate ethtool with Ethernet. Any netdev can implement it, and a
HDLC device is a netdev. So it could well return link down reason.

> But indeed this could be changed.
> If changed, the MFD pef2256 will have to handle the full struct
> phy_status_basic as the translation will not be there anymore.
> Right now, this structure is pretty simple and contains only the link state
> flag. But in the future, this PHY structure can move to something more
> complex and I am not sure that filling this struct is the MFD pef2256
> responsibility. The PHY pef2256 is responsible for the correct structure
> contents not sure that this should be moved to the MFD part.

Framers, like Ethernet PHYs, are reasonably well defined, because
there are clear standards to follow. You could put the datasheets for
the various frames side by side and quickly get an idea of the common
properties. So you could define a structure now. In order to make it
extendable, just avoid 0 having any meaning other than UNKNOWN. If you
look at ethernet, SPEED_UNKNOWN is 0, DUPLEX_UNKNOWN is 0. So if a new
field is added, we know if a driver has not filled it in.

> > And why is the notifier specific to the PEF2256? What would happen if
> > i used a analog devices DS2155, DS21Q55, and DS2156, or the IDT
> > 82P2281? Would each have its own notifier? And hence each would need
> > its own PHY which translates one notifier into another?
> 
> Each of them should have their own notifier if they can notify.

I doubt you will find a framer which cannot report lost of framing. It
is too much a part of the standards. There are signalling actions you
need to do when a link goes does. So all framer drivers will have a
notifier.

> At least they will need their own notifier at they PHY driver level.
> Having or not a translation from something else would depend on each device
> PHY driver implementation.

Have you ever look at Ethernet PHYs? They all export the same API. You
can plug any Linux MAC driver into any Linux Ethernet PHY driver. It
should be the same here. You should be able to plug any HDLC driver
into any Framer. I should be able to take the same SoC you have
implementing the TDM interface, and plug it into the IDT framer i know
of. We want a standardised API between the HDLC device and the framer.

> I would like this first implementation without too much API restriction
> in order to see how it goes.
> The actual proposal imposes nothing on the PHY internal implementation.
> the pef2256 implementation chooses to have two notifiers (one at MFD
> level and one at PHY level) but it was not imposed by the API.

What i would like to see is some indication the API you are proposing
is generic, and could be implemented by multiple frames and HDLC
devices. The interface between the HDLC driver and the framer should
be generic. The HDLC driver has an abstract reference to a framer. The
framer has a reference to a netdev for the HDLC device.

You can keep this API very simple, just have link up/down
notification, since that is all you want at the moment. But the
implementation should give hints how it can be extended.

	Andrew
