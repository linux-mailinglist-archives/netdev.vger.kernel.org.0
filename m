Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163A0220F13
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 16:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgGOOUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 10:20:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36878 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgGOOUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 10:20:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jviGy-005FnE-0h; Wed, 15 Jul 2020 16:20:36 +0200
Date:   Wed, 15 Jul 2020 16:20:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200715142036.GR1078057@lunn.ch>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
 <20200714234652.w2pw3osynbuqw3m4@skbuf>
 <20200715112100.GG1551@shell.armlinux.org.uk>
 <20200715113441.GR1605@shell.armlinux.org.uk>
 <20200715123153.vvvnx6rwgzl5ejuo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715123153.vvvnx6rwgzl5ejuo@skbuf>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The best you came with is that phylink gives you flexibility and
> options, and sure it does, when you add a lot of stuff to it to make it
> do that. But I don't want to know why phylink is an option, I want to
> know why phylib isn't. Phylink is your creation, which as far as I'm
> concerned stems out of the need to support more setups than phylib did,
> and you took the route of working around phylib rather than extending
> it. So, I would have expected an answer from you why phylib is not a
> valid place for this.

phylib assumes it is the last thing. There is nothing after it, just
the copper media. And it assumes the world is copper, and not
hot-pluggable.  For a long time, this was sufficient. The MAC was
directly connected to the PHY via MII, or GMII, RGMII and everything
is static.  It does this job well.

But other the last few years, things have changed. We have
intermediary blocks. An SFP is such an intermediary block, when you
have a copper module. We have SERDES blocks which can need
configuration. We potentially have a backplane, with an SFP at the
other end, with copper PHY plugged into it. And all thus can
dynamically change.

The phylib architecture is not flexiable enough to handle this
chain. phylib is good for copper PHYs, but not much more. phylink is
there to help link together a number of blocks into a complete chain,
and declare the link is up when all blocks in the chain are up. If the
end block happens to be an copper PHY, phylink will use phylib to
control the PHY, because that is what phylib is for. I would not say
phylink works around phylib, it incorporates phylib. 

If you have a simple setup of a MAC directly connected to a copper PHY
in a simple static setup, feel free to use phylib. It is not going
away. But don't push the boundary, or we are likely to reject it.

     Andrew
