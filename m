Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD626E451B
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 12:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjDQKXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 06:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDQKXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 06:23:17 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [IPv6:2001:4b98:dc4:8::240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F288D3A91;
        Mon, 17 Apr 2023 03:22:18 -0700 (PDT)
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 7FB4ACE256;
        Mon, 17 Apr 2023 10:17:54 +0000 (UTC)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6FD9AFF80F;
        Mon, 17 Apr 2023 10:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1681726594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kMksyFjGeVV2iklCwJ5cx3YfiDVM7A12HWZsN5LSlA=;
        b=eXWJEI1DzdLDX23p4dXUCZ4RaIC/UFBt5MrcdTcvrhcsRAOyTExzHAtfW8urPZaJFEB7hJ
        RsyCLtNmlGE3jnuQMOSa55Lk0j12FqIHJmSVpDgghi21phcwXhlvetfPjdo8mJEsuAq5LM
        zoVOAX9aMD+jaKguY4byqxzhJ6dqH8njWVl64fKA1565TdtZmO+Zyvhv6eYhVZ2sTcOfBu
        qEjIjzv6oC8SfSClmfYo4E4A+ik/tjHM7w50hrYn4cJ5qfl/Xlcu+EXXI0TvJvA1jhapoE
        vZuMbUR902z8esz0dmjsQE7hrktvJ6Ez9X1w/SrMqdz6yw51IYkW9GPrie8APw==
Date:   Mon, 17 Apr 2023 12:16:29 +0200
From:   Herve Codina <herve.codina@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
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
Message-ID: <20230417121629.63e97b80@bootlin.com>
In-Reply-To: <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
        <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
        <20230414165504.7da4116f@bootlin.com>
        <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

On Fri, 14 Apr 2023 18:15:30 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > > When i look at the 'phy' driver, i don't see anything a typical PHY
> > > driver used for networking would have. A networking PHY driver often
> > > has the ability to change between modes, like SGMII, QSGMII, 10GBASER.
> > > The equivalent here would be changing between E1, T1 and J1. It has
> > > the ability to change the speed, 1G, 2.5G, 10G etc. This could be
> > > implied via the mode, E1 is 2.048Mbps, T1 1.544Mbps, and i forget what
> > > J1 is. The PEF2256 also seems to support E1/T1/J1. How is its modes
> > > configured?  
> > 
> > All of these are set by the MFD driver during its probe().
> > The expected setting come from several properties present in the pef2256
> > DT node. The binding can be found here:
> >   https://lore.kernel.org/all/20230328092645.634375-2-herve.codina@bootlin.com/  
> 
> I'm surprised to see so much in the binding. I assume you are familiar
> with DAHDI. It allows nearly everything to be configured at
> runtime. The systems i've used allow you to select the clock
> configuration, line build out, user side vs networks side signalling
> CRC4 enables or not, etc.

Well, I am not familiar with DAHDI at all.
I didn't even know about the DAHDI project.
The project seems to use specific kernel driver and I would like to avoid
these external drivers.

> 
> > Further more, the QMC HDLC is not the only PEF2256 consumer.
> > The PEF2256 is also used for audio path (ie audio over E1) and so the
> > configuration is shared between network and audio. The setting cannot be
> > handle by the network part as the PEF2256 must be available and correctly
> > configured even if the network part is not present.  
> 
> But there is no reason why the MFD could not provide a generic PHY to
> actually configure the 'PHY'. The HDLC driver can then also use the
> generic PHY. It would make your generic PHY less 'pointless'. I'm not
> saying it has to be this way, but it is an option.

If the pef2256 PHY provides a configure function, who is going to call this
configure(). I mean the one calling the configure will be the configuration
owner. None of the MFD child can own the configuration as this configuration
will impact other children. So the MFD (top level node) owns the configuration.

>  
> > > In fact, this PHY driver does not seem to do any configuration of any
> > > sort on the framer. All it seems to be doing is take notification from
> > > one chain and send them out another chain!  
> > 
> > Configuration is done by the parent MFD driver.
> > The PHY driver has nothing more to do.
> >   
> > > 
> > > I also wounder if this get_status() call is sufficient. Don't you also
> > > want Red, Yellow and Blue alarms? It is not just the carrier is down,
> > > but why it is down.  
> > 
> > I don't need them in my use case but if needed can't they be added later?
> > Also, from the HDLC device point of view what can be done with these alarms?  
> 
> https://elixir.bootlin.com/linux/latest/source/Documentation/networking/ethtool-netlink.rst#L472

Thanks for pointing this interface.
It is specific to ethtool but I can see the idea.
The 'get_status' I proposed could be extended later to provide more
information related to the colour of the alarm if needed.
ethtool and related interfaces are very well fitted with Ethernet and
related PHYs. I am not sure that ethtool will be usable for the pef2256.

> 
> > Requests link state information. Link up/down flag (as provided by
> > ``ETHTOOL_GLINK`` ioctl command) is provided. Optionally, extended
> > state might be provided as well. In general, extended state
> > describes reasons for why a port is down, or why it operates in some
> > non-obvious mode.  
> 
> The colour of the Alarm gives you an idea which end of the system has
> the problem.
> 
> > > Overall, i don't see why you want a PHY. What value does it add?  
> > 
> > I need to detect carrier on/off according to the E1 link state.  
> 
> Why not just use the MFD notifier? What is the value of a PHY driver
> translating one notifier into another?

I translated to another notifier to keep the core (MFD) pef2256 API
independent.

But indeed this could be changed.
If changed, the MFD pef2256 will have to handle the full struct
phy_status_basic as the translation will not be there anymore.
Right now, this structure is pretty simple and contains only the link state
flag. But in the future, this PHY structure can move to something more
complex and I am not sure that filling this struct is the MFD pef2256
responsibility. The PHY pef2256 is responsible for the correct structure
contents not sure that this should be moved to the MFD part.

> 
> And why is the notifier specific to the PEF2256? What would happen if
> i used a analog devices DS2155, DS21Q55, and DS2156, or the IDT
> 82P2281? Would each have its own notifier? And hence each would need
> its own PHY which translates one notifier into another?

Each of them should have their own notifier if they can notify.
At least they will need their own notifier at they PHY driver level.
Having or not a translation from something else would depend on each device
PHY driver implementation.
Also, maybe some PHY will not be able to provide notifications but only
the get_status(). In this case, the notifier is not needed.
The proposed QMC HDLC driver handles this case switching to polling mode
if the PHY is not able to provide notification.

> 
> There are enough E1/T1/J1 framers we should have a generic API between
> the framer and the HDLC device.
> 

I agree.
I would like this first implementation without too much API restriction
in order to see how it goes.
The actual proposal imposes nothing on the PHY internal implementation.
the pef2256 implementation chooses to have two notifiers (one at MFD
level and one at PHY level) but it was not imposed by the API.

Best regards,
Hervé

