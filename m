Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA11D6DDA95
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjDKMQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjDKMQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:16:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C84740E1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 05:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vnl4kJFfCeqOghbmOGt/6qJL8sQ9dbQ8LvPEALfl7gM=; b=L8mJ1rC78EaH2TNDUu6HAGyzea
        D+A2kencTy64woDXu2ECHGxfq/x/V9ETxB3orIFqHLtiPN+KR9q6PLzQohrR/j8e/Yz3Ctrs+PnFq
        JrobF6j50fLeaPfYsWPJSlgiRthpb9otSkO5FEKqg+WQ6ovyDfDAGGKuhoL+mU1fFtf4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmCv5-009zBk-AW; Tue, 11 Apr 2023 14:16:19 +0200
Date:   Tue, 11 Apr 2023 14:16:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <20d4ac99-f40f-4526-96fe-ec3efeed57b7@lunn.ch>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
 <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
 <20230411111609.jhfcvvxbxbkl47ju@skbuf>
 <20230411113516.ez5cm4262ttec2z7@skbuf>
 <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDVL6we7LN/ApgwG@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 01:00:43PM +0100, Russell King (Oracle) wrote:
> On Tue, Apr 11, 2023 at 02:35:16PM +0300, Vladimir Oltean wrote:
> > On Tue, Apr 11, 2023 at 02:16:09PM +0300, Vladimir Oltean wrote:
> > > I may have missed something.
> > 
> > Maybe I'm wrong, but my blind intuition says that when autoneg is
> > disabled in the integrated PHYs, flow control _is_ by default forced off
> > per port, unless the "Force Flow Control" bit from Port N Control 2
> > registers is set. So that can be used to still support:
> > - ethtool --pause swp0 autoneg off rx on tx on
> > - ethtool --pause swp0 autoneg off rx off tx off
> > - ethtool --pause swp0 autoneg on # asymmetric RX/TX combinations depend upon autoneg
> > 
> > I may be wrong; I don't have the hardware and the ethtool pause autoneg
> > bit is not 100% clear to me.
> 
> Stage 1 (per port, force bit):
> - If zero, the flow control result from aneg is used, and thus depends on
>   what both ends advertise.
> - If one, flow control is force-enabled.
> 
> Stage 2 (global):
> Transmit and receive flow control can be masked off.
> 
> Basically, the best we could do is:
> 
> 	ethtool --pause ... autoneg on

This hardware design does seem messed up. My experience reviewing
ethtool patches for flow control is that most developers also get it
wrong. Plus it is not very well documented. phylink has made that
better since it moves a lot of the code into the core.

I suggest you follow Russells suggestion, only support autoneg on.
Have ethtool set return -EOPNOTSUPP for anything else. And ethtool get
should return that autoneg is on, and the result of the autoneg, which
you should be able to get.

Only implementing a subset of ethtool is fine.  We have drivers
implementing various subsets, mostly when firmware is controlling the
hardware, and there are firmware limitations.

	  Andrew
