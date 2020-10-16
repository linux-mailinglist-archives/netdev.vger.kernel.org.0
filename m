Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68964290D0C
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410481AbgJPVBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 17:01:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392572AbgJPVBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 17:01:02 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTWqN-0023YY-3V; Fri, 16 Oct 2020 23:00:55 +0200
Date:   Fri, 16 Oct 2020 23:00:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] net: phy: Prevent reporting advertised modes when
 autoneg is off
Message-ID: <20201016210055.GK139700@lunn.ch>
References: <20201016180935.GG139700@lunn.ch>
 <CGME20201016193736eucas1p1eb94190e16b194f473ade8c49ca34275@eucas1p1.samsung.com>
 <dleftjzh4m3qtp.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dleftjzh4m3qtp.fsf%l.stelmach@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 09:37:22PM +0200, Lukasz Stelmach wrote:
> It was <2020-10-16 pią 20:09>, when Andrew Lunn wrote:
> > On Thu, Oct 15, 2020 at 10:44:35AM +0200, Łukasz Stelmach wrote:
> >> Do not report advertised link modes (local and remote) when
> >> autonegotiation is turned off. mii_ethtool_get_link_ksettings() exhibits
> >> the same behaviour and this patch aims at unifying the behavior of both
> >> functions.
> >
> > Does ethtool allow you to configure advertised modes with autoneg off?
> > If it can, it would be useful to see what is being configured, before
> > it is actually turned on.
> >
> > ethtool -s eth42 autoneg off advertise 0xf
> >
> > does not give an error on an interface i have.
> 
> Yes, this is a good point. Do you think I should change the if()[1] in 
> mii_ethtool_get_link_ksettings() instead? I really think these two
> function should report the same.

Yes, i would change mii. Ideally we want all drivers to use
phylib/phylink, not mii. So i would modify mii to match
phylib/phylink, not the other way around.

And then there will be drivers which do their own PHY handling, hidden
away in firmware, and not using either of mii or phylib/phylink. You
can expect them to be inconsistent.

    Andrew
