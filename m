Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039E72A6B21
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 17:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbgKDQzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 11:55:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729430AbgKDQzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 11:55:17 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaM3x-005FOf-Di; Wed, 04 Nov 2020 17:55:09 +0100
Date:   Wed, 4 Nov 2020 17:55:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] lan743x: correctly handle chips with internal PHY
Message-ID: <20201104165509.GB1249360@lunn.ch>
References: <20201104160847.30049-1-TheSven73@gmail.com>
 <20201104162734.GA1249360@lunn.ch>
 <CAGngYiUtMN0nOV+wZC-4ycwOAvU=BqhdP7Z3PUPh2GX8Fvo3jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGngYiUtMN0nOV+wZC-4ycwOAvU=BqhdP7Z3PUPh2GX8Fvo3jg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 11:39:47AM -0500, Sven Van Asbroeck wrote:
> Hi Andrew, many thanks for looking at this patch !
> 
> On Wed, Nov 4, 2020 at 11:27 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Note that as a side-effect, the devicetree phy mode now no longer
> > > has a default, and always needs to be specified explicitly (via
> > > 'phy-connection-type').
> >
> > That sounds like it could break systems. Why do you do this?
> 
> Because the standard mdio library function (of_phy_get_and_connect())
> does not appear to support a default value. The original driver
> code duplicated that library function's code, with a slight
> tweak - the default value.
> 
> The default value was introduced quite recently, in the commit which
> this patch fixes:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/ethernet/microchip/lan743x_main.c?h=v5.9.3&id=6f197fb63850b26ef8f70f1bfe5900e377910a5a

If you look at that patch, you see:

-       ret = phy_connect_direct(netdev, phydev,
-                                lan743x_phy_link_status_change,
-                                PHY_INTERFACE_MODE_GMII);
-       if (ret)
-               goto return_error;


That was added as part of the first commit for the lan743x
driver. Changing that now seems dangerous.

This is a fix you want backporting to stable. Such fixes should be
minimal, and obviously correct. So i suggest you keep with the open
coded version of of_phy_get_and_connect(), and make sure it keeps with
the default as PHY_INTERFACE_MODE_GMII. That can be committed to net
as a fix.

You can then consider a refactoring patch for net-next, and see about
modifying of_phy_get_and_connect() to do what you need.

	  Andrew
