Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15B711F0B5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 08:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfLNHTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 02:19:23 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:29478 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfLNHTW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Dec 2019 02:19:22 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xBE7J7f9002928;
        Sat, 14 Dec 2019 08:19:07 +0100
Date:   Sat, 14 Dec 2019 08:19:07 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: marvell: mvpp2: phylink requires the link interrupt
Message-ID: <20191214071907.GA2925@1wt.eu>
References: <E1ieo41-00023K-2O@rmk-PC.armlinux.org.uk>
 <20191213163403.2a054262@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191213163403.2a054262@cakuba.netronome.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 04:34:03PM -0800, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 22:33:05 +0000, Russell King wrote:
> > phylink requires the MAC to report when its link status changes when
> > operating in inband modes.  Failure to report link status changes
> > means that phylink has no idea when the link events happen, which
> > results in either the network interface's carrier remaining up or
> > remaining permanently down.
> > 
> > For example, with a fiber module, if the interface is brought up and
> > link is initially established, taking the link down at the far end
> > will cut the optical power.  The SFP module's LOS asserts, we
> > deactivate the link, and the network interface reports no carrier.
> > 
> > When the far end is brought back up, the SFP module's LOS deasserts,
> > but the MAC may be slower to establish link.  If this happens (which
> > in my tests is a certainty) then phylink never hears that the MAC
> > has established link with the far end, and the network interface is
> > stuck reporting no carrier.  This means the interface is
> > non-functional.
> > 
> > Avoiding the link interrupt when we have phylink is basically not
> > an option, so remove the !port->phylink from the test.
> > 
> > Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
> > Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Fixes: 4bb043262878 ("net: mvpp2: phylink support") ?
> 
> Seems like you maybe didn't want this backported to stable hence 
> no fixes tag?
> 
> Please advise :)

Speaking for myself, I'd very much like to get it into stable in order
to avoid having to keep this local patch on top of latest stable!

Willy
