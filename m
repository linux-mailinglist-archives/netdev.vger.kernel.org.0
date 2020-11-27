Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76902C6CEF
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 22:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731701AbgK0VfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 16:35:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53556 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731180AbgK0Vcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 16:32:50 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kilMC-009BPD-JV; Fri, 27 Nov 2020 22:32:44 +0100
Date:   Fri, 27 Nov 2020 22:32:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201127213244.GY2073444@lunn.ch>
References: <20201125193740.36825-3-george.mccollister@gmail.com>
 <20201125174214.0c9dd5a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFSKS=OY_-Agd6JPoFgm3MS5HE6soexHnDHfq8g9WVrCc82_sA@mail.gmail.com>
 <20201126132418.zigx6c2iuc4kmlvy@skbuf>
 <20201126175607.bqmpwbdqbsahtjn2@skbuf>
 <CAFSKS=Ok1FZhKqourHh-ikaia6eNWtXh6VBOhOypsEJAhwu06g@mail.gmail.com>
 <20201126220500.av3clcxbbvogvde5@skbuf>
 <20201127103503.5cda7f24@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201127204714.GX2073444@lunn.ch>
 <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127131346.3d594c8e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > So long as these counters are still in ethtool -S, i guess it does not
> > matter. That i do trust to be accurate, and probably consistent across
> > the counters it returns.
> 
> Not in the NIC designs I'm familiar with.

Many NICs have a way to take a hardware snapshot of all counters. You
can then read them out as fast or slow as you want, since you read the
snapshot, not the live counters. As a result you can compare counters
against each other.

> But anyway - this only matters in some strict testing harness, right?
> Normal users will look at a stats after they noticed issues (so minutes
> / hours later) or at the very best they'll look at a graph, which will
> hardly require <1sec accuracy to when error occurred.

As Vladimir has pointed out, polling once per second over an i2c bus
is expensive. And there is an obvious linear cost with the number of
ports on these switches. And we need to keep latency down so that PTP
is accurate. Do we really want to be polling, for something which is
very unlikely to be used? I think we should probably take another look
at the locking and see if it can be modified to allow block, so we can
avoid this wasteful polling.

	Andrew

