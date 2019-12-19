Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A581267AC
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfLSRGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:06:55 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36886 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbfLSRGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:06:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ef/yc5SmTLtSP7GVwMDJ7uUTSWroBFV76EhzbVc15AM=; b=sE1Imm/oZvRKQaKZfXEkQviVY
        szSXJauUYRMlSxeSix+dwyzg/5nIfI5jqsWSAnppzCcak5r+JOghcTAENj4vdsKtCvYgq7barDAPv
        TVqihdzU6dTb7LXEwU7ZgsSQZRc8UwtfDFJdeCMwgoK9TS2gwRUR9IZZNHUGphW7EYNeTgdotuIfw
        zEx5hBEnaM0tQvjA10UAKB2zrPIpYN/Wkyee8hdUhjhT4RSNrH+wfwdoEbKF39XlvIoDvbED5Z1Jz
        ojp6aQX7mL/GI9hyZyVUY1H8knIMbmnFdD/XWQM6hZ6s1M9HxYsiDzS8VcFr44NxHJw8mwZQS5Y3H
        a2wupuL7A==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43500)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ihzG7-0003kl-RH; Thu, 19 Dec 2019 17:06:43 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ihzG5-0005WC-Gb; Thu, 19 Dec 2019 17:06:41 +0000
Date:   Thu, 19 Dec 2019 17:06:41 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phy: make phy_error() report which PHY has
 failed
Message-ID: <20191219170641.GB25745@shell.armlinux.org.uk>
References: <E1ihCLZ-0001Vo-Nw@rmk-PC.armlinux.org.uk>
 <c96f14cd-7139-ebc7-9562-2f92d8b044fc@gmail.com>
 <20191217233436.GS25745@shell.armlinux.org.uk>
 <61f23d43-1c4d-a11e-a798-c938a896ddb3@gmail.com>
 <20191218220908.GX25745@shell.armlinux.org.uk>
 <8f7411c7-f420-4a31-38ef-6a2af6c56675@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f7411c7-f420-4a31-38ef-6a2af6c56675@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 08:10:21AM +0100, Heiner Kallweit wrote:
> On 18.12.2019 23:09, Russell King - ARM Linux admin wrote:
> > On Wed, Dec 18, 2019 at 09:54:32PM +0100, Heiner Kallweit wrote:
> >> On 18.12.2019 00:34, Russell King - ARM Linux admin wrote:
> >>> On Tue, Dec 17, 2019 at 10:41:34PM +0100, Heiner Kallweit wrote:
> >>>> On 17.12.2019 13:53, Russell King wrote:
> >>>>> phy_error() is called from phy_interrupt() or phy_state_machine(), and
> >>>>> uses WARN_ON() to print a backtrace. The backtrace is not useful when
> >>>>> reporting a PHY error.
> >>>>>
> >>>>> However, a system may contain multiple ethernet PHYs, and phy_error()
> >>>>> gives no clue which one caused the problem.
> >>>>>
> >>>>> Replace WARN_ON() with a call to phydev_err() so that we can see which
> >>>>> PHY had an error, and also inform the user that we are halting the PHY.
> >>>>>
> >>>>> Fixes: fa7b28c11bbf ("net: phy: print stack trace in phy_error")
> >>>>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >>>>> ---
> >>>>> There is another related problem in this area. If an error is detected
> >>>>> while the PHY is running, phy_error() moves to PHY_HALTED state. If we
> >>>>> try to take the network device down, then:
> >>>>>
> >>>>> void phy_stop(struct phy_device *phydev)
> >>>>> {
> >>>>>         if (!phy_is_started(phydev)) {
> >>>>>                 WARN(1, "called from state %s\n",
> >>>>>                      phy_state_to_str(phydev->state));
> >>>>>                 return;
> >>>>>         }
> >>>>>
> >>>>> triggers, and we never do any of the phy_stop() cleanup. I'm not sure
> >>>>> what the best way to solve this is - introducing a PHY_ERROR state may
> >>>>> be a solution, but I think we want some phy_is_started() sites to
> >>>>> return true for it and others to return false.
> >>>>>
> >>>>> Heiner - you introduced the above warning, could you look at improving
> >>>>> this case so we don't print a warning and taint the kernel when taking
> >>>>> a network device down after phy_error() please?
> >>>>>
> >>>> I think we need both types of information:
> >>>> - the affected PHY device
> >>>> - the stack trace to see where the issue was triggered
> >>>
> >>> Can you please explain why the stack trace is useful.  For the paths
> >>> that are reachable, all it tells you is whether it was reached via
> >>> the interrupt or the workqueue.
> >>>
> >>> If it's via the interrupt, the rest of the backtrace beyond that is
> >>> irrelevant.  If it's the workqueue, the backtrace doesn't go back
> >>> very far, and doesn't tell you what operation triggered it.
> >>>
> >>> If it's important to see where or why phy_error() was called, there
> >>> are much better ways of doing that, notably passing a string into
> >>> phy_error() to describe the actual error itself.  That would convey
> >>> way more useful information than the backtrace does.
> >>>
> >>> I have been faced with these backtraces, and they have not been at
> >>> all useful for diagnosing the problem.
> >>>
> >> "The problem" comes in two flavors:
> >> 1. The problem that caused the PHY error
> >> 2. The problem caused by the PHY error (if we decide to not
> >>    always switch to HALTED state)
> >>
> >> We can't do much for case 1, maybe we could add an errno argument
> >> to phy_error(). To facilitate analyzing case 2 we'd need to change
> >> code pieces like the following.
> >>
> >> case a:
> >> err = f1();
> >> case b:
> >> err = f2();
> >>
> >> if (err)
> >> 	phy_error()
> >>
> >> For my understanding: What caused the PHY error in your case(s)?
> >> Which info would have been useful for analyzing the error?
> > 
> > Errors reading/writing from the PHY.
> > 
> > The problem with a backtrace from phy_error() is it doesn't tell you
> > where the error actually occurred, it only tells you where the error
> > is reported - which is one of two different paths at the moment.
> > That can be achieved with much more elegance and simplicity by
> > passing a string into phy_error() to describe the call site if that's
> > even relevant.
> > 
> > I would say, however, that knowing where the error occurred would be
> > far better information.
> > 
> AFAICS PHY errors are typically forwarded MDIO access errors.
> PHY driver callback implementations could add own error sources,
> but from what I've seen they don't. Instead of the backtrace in
> phy_error() we could add a WARN_ONCE() to __mdiobus_read/write.
> Then the printed call chain should be more useful.
> If somebody wants to analyze in more detail, he can switch on
> MDIO access tracing.

I'm still not clear why you're so keen to trigger a kernel warning
on one of these events.

Errors may _legitimately_ occur when trying to read/write a PHY. For
example, it would be completely mad for the kernel to WARN and taint
itself just because you've unplugged a SFP module just at the time
that phylib is trying to poll the PHY on-board, and that caused an
failure to read/write the PHY. You just need the right timing to
trigger this.

When a SFP module is unplugged the three contacts that comprise the
I2C bus (used for communicating with a PHY that may be there) and
the pin that identifies that the module is present all break at about
the same point in time (give or take some minor tolerances) so there
is no way to definitively say "yes, the PHY is still present, we can
talk to it" by testing something.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
