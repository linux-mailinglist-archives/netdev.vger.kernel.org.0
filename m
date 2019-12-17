Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26253123AEC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfLQXep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:34:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35618 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbfLQXep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:34:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=OWRvkLldopufA1A7D3zUMCr/VA92tMCUQEEVY3rdwyI=; b=u9TtMELyOey5YSSG6hg8GTWJH
        CuLbM9Y/I2ZyoXVgl5w3fHzU7A/iH1P+682HNkupjxbB1qNz+CP/gSd0XKoaopGL6wK8bBUlKxref
        beY+JS4JTihDZSWlyFszXQeRp79Lfhn+IOn0MjNdfs/hMM4a/Nw6lU+nMPraYHLwhEPMGLQJRFNeD
        PSjgiidD9e/Gvt9uVW6p0si0CT2wRr7c8BolfTqEKi4CetsUiHOb8M6Z8uPRF5x7BFN+K+VgoeHr4
        JmmKvOrm6jaPPmelUl+8VwcjoTSuEaAbWoP4uFk8JgoOpLz0z9+XBraN9tcKmIq9PULxT0YCHrHnE
        N2fpwvpWA==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:42738)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihMMQ-0000Re-DI; Tue, 17 Dec 2019 23:34:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihMMP-0003mX-0r; Tue, 17 Dec 2019 23:34:37 +0000
Date:   Tue, 17 Dec 2019 23:34:36 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
Message-ID: <20191217233436.GS25745@shell.armlinux.org.uk>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 10:41:34PM +0100, Heiner Kallweit wrote:
> On 17.12.2019 13:53, Russell King wrote:
> > phy_error() is called from phy_interrupt() or phy_state_machine(), and
> > uses WARN_ON() to print a backtrace. The backtrace is not useful when
> > reporting a PHY error.
> > 
> > However, a system may contain multiple ethernet PHYs, and phy_error()
> > gives no clue which one caused the problem.
> > 
> > Replace WARN_ON() with a call to phydev_err() so that we can see which
> > PHY had an error, and also inform the user that we are halting the PHY.
> > 
> > Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> > There is another related problem in this area. If an error is detected
> > while the PHY is running, phy_error() moves to PHY_HALTED state. If we
> > try to take the network device down, then:
> > 
> > void phy_stop(struct phy_device *phydev)
> > {
> >         if (!phy_is_started(phydev)) {
> >                 WARN(1, "called from state %s\n",
> >                      phy_state_to_str(phydev->state));
> >                 return;
> >         }
> > 
> > triggers, and we never do any of the phy_stop() cleanup. I'm not sure
> > what the best way to solve this is - introducing a PHY_ERROR state may
> > be a solution, but I think we want some phy_is_started() sites to
> > return true for it and others to return false.
> > 
> > Heiner - you introduced the above warning, could you look at improving
> > this case so we don't print a warning and taint the kernel when taking
> > a network device down after phy_error() please?
> > 
> I think we need both types of information:
> - the affected PHY device
> - the stack trace to see where the issue was triggered

Can you please explain why the stack trace is useful.  For the paths
that are reachable, all it tells you is whether it was reached via
the interrupt or the workqueue.

If it's via the interrupt, the rest of the backtrace beyond that is
irrelevant.  If it's the workqueue, the backtrace doesn't go back
very far, and doesn't tell you what operation triggered it.

If it's important to see where or why phy_error() was called, there
are much better ways of doing that, notably passing a string into
phy_error() to describe the actual error itself.  That would convey
way more useful information than the backtrace does.

I have been faced with these backtraces, and they have not been at
all useful for diagnosing the problem.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
