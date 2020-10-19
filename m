Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFFD2930FB
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbgJSWMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:12:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35536 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387942AbgJSWMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 18:12:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUdOK-002Yzk-A9; Tue, 20 Oct 2020 00:12:32 +0200
Date:   Tue, 20 Oct 2020 00:12:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: phy: marvell: add special handling of Finisar
 modules with 81E1111
Message-ID: <20201019221232.GB139700@lunn.ch>
References: <20201019204913.467287-1-robert.hancock@calian.com>
 <20201019210852.GW1551@shell.armlinux.org.uk>
 <30161ca241d03c201e801af7089dada5b6481c24.camel@calian.com>
 <20201019214536.GX139700@lunn.ch>
 <1f3243e15a8600dd9876b97410b450029674c50c.camel@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f3243e15a8600dd9876b97410b450029674c50c.camel@calian.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I think in my case those extra modes only supported in SGMII mode, like
> 10 and 100Mbps modes, effectively get filtered out because the MAC
> doesn't support them in the 1000BaseX mode either.

There are different things here. What ethtool reports, and what is
programmed into the advertise register. Clearly, you don't want it
advertising 10 and 100 modes. If somebody connects it to a 10Half link
partner, you need auto-get to fail. You don't want auto-neg to
succeed, and then all the frames get thrown away with bad CRCs,
overruns etc.

> The auto-negotiation is a bit of a weird thing in this case, as there
> are two negotiations occurring, the 1000BaseX between the PCS/PMA PHY
> and the module PHY, and the 1000BaseT between the module PHY and the
> copper link partner. I believe the 88E1111 has some smarts to delay the
> copper negotiation until it gets the advertisement over 1000BaseX, uses
> those to figure out its advertisement, and then uses the copper link
> partner's response to determine the 1000BaseX response.

But as far as i know you can only report duplex and pause over
1000BaseX, not speed, since it is always 1G.

It would be interesting to run ethtool on the link partner to see what
it thinks the SFP is advertising. If it just 1000BaseT/Full?

   Andrew
