Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017E96E2828
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjDNQPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjDNQPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:15:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616C0188;
        Fri, 14 Apr 2023 09:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=y77Vn1iQ2Yr8r94PJbu25E6c2t/sA9gRbZHB/9bHBWk=; b=sgynuWJ1+GOxbplFPJ2IKiq5oX
        /0JSnWlKYR9E1aamdcGDR2pOlNQXbnqQdu1Z5TcAiXan78/lTWDYRcvX/2vTAk6OIrn9E5UjMFrD8
        TaREFVUstQ4tCbiJYRTBJajZo4WrOzgEmroxCtNOFm1bon6dQdCmFT19UH/RGKTm5TwE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pnM5C-00AIdW-9F; Fri, 14 Apr 2023 18:15:30 +0200
Date:   Fri, 14 Apr 2023 18:15:30 +0200
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
Message-ID: <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
 <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
 <20230414165504.7da4116f@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414165504.7da4116f@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > When i look at the 'phy' driver, i don't see anything a typical PHY
> > driver used for networking would have. A networking PHY driver often
> > has the ability to change between modes, like SGMII, QSGMII, 10GBASER.
> > The equivalent here would be changing between E1, T1 and J1. It has
> > the ability to change the speed, 1G, 2.5G, 10G etc. This could be
> > implied via the mode, E1 is 2.048Mbps, T1 1.544Mbps, and i forget what
> > J1 is. The PEF2256 also seems to support E1/T1/J1. How is its modes
> > configured?
> 
> All of these are set by the MFD driver during its probe().
> The expected setting come from several properties present in the pef2256
> DT node. The binding can be found here:
>   https://lore.kernel.org/all/20230328092645.634375-2-herve.codina@bootlin.com/

I'm surprised to see so much in the binding. I assume you are familiar
with DAHDI. It allows nearly everything to be configured at
runtime. The systems i've used allow you to select the clock
configuration, line build out, user side vs networks side signalling
CRC4 enables or not, etc.

> Further more, the QMC HDLC is not the only PEF2256 consumer.
> The PEF2256 is also used for audio path (ie audio over E1) and so the
> configuration is shared between network and audio. The setting cannot be
> handle by the network part as the PEF2256 must be available and correctly
> configured even if the network part is not present.

But there is no reason why the MFD could not provide a generic PHY to
actually configure the 'PHY'. The HDLC driver can then also use the
generic PHY. It would make your generic PHY less 'pointless'. I'm not
saying it has to be this way, but it is an option.
 
> > In fact, this PHY driver does not seem to do any configuration of any
> > sort on the framer. All it seems to be doing is take notification from
> > one chain and send them out another chain!
> 
> Configuration is done by the parent MFD driver.
> The PHY driver has nothing more to do.
> 
> > 
> > I also wounder if this get_status() call is sufficient. Don't you also
> > want Red, Yellow and Blue alarms? It is not just the carrier is down,
> > but why it is down.
> 
> I don't need them in my use case but if needed can't they be added later?
> Also, from the HDLC device point of view what can be done with these alarms?

https://elixir.bootlin.com/linux/latest/source/Documentation/networking/ethtool-netlink.rst#L472

> Requests link state information. Link up/down flag (as provided by
> ``ETHTOOL_GLINK`` ioctl command) is provided. Optionally, extended
> state might be provided as well. In general, extended state
> describes reasons for why a port is down, or why it operates in some
> non-obvious mode.

The colour of the Alarm gives you an idea which end of the system has
the problem.

> > Overall, i don't see why you want a PHY. What value does it add?
> 
> I need to detect carrier on/off according to the E1 link state.

Why not just use the MFD notifier? What is the value of a PHY driver
translating one notifier into another?

And why is the notifier specific to the PEF2256? What would happen if
i used a analog devices DS2155, DS21Q55, and DS2156, or the IDT
82P2281? Would each have its own notifier? And hence each would need
its own PHY which translates one notifier into another?

There are enough E1/T1/J1 framers we should have a generic API between
the framer and the HDLC device.

    Andrew
