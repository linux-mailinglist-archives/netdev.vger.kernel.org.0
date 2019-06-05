Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E121735C67
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 14:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfFEMQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 08:16:38 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56056 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727172AbfFEMQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 08:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Tpt94GYFZ5IJjbsncYGhpWR4ahl73qfW9CEQ+axg3lc=; b=kUwtj6VKmlp3PqsTMoGDPHZd1
        sB3jhlBo3ENxrVAJxf72CCL1qOIHFhgOyXrYf2KKarHNXekeVgy3MiyERbK+FXuqtC540ZClrM9TC
        llPvU5foIMEua4Rv6fFGFgZJ9rVhubMEfEASWl/44eAcDxVNJ8fAKCD2i7AiOkXxcIYRitTrIrRd6
        QH9yq1pRzaMkoWL7am24wP6dPX+AHz6TQxrl7OxAzhKQFYFS8UuWXH8R97MFISNwxDMIo3T09cKNz
        NEm3H53BXm0mpYscDgYf7vH0OE0B7eWgIY2uluSP+/SSyF0RmSbfAZV0j4hJ5rnrYb7b3VCyuG+Np
        CCpmvdEug==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38526)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hYUqH-0007jI-Jo; Wed, 05 Jun 2019 13:16:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hYUqF-0002PS-Gp; Wed, 05 Jun 2019 13:16:31 +0100
Date:   Wed, 5 Jun 2019 13:16:31 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
Message-ID: <20190605121631.47icyavtcrnwddlg@shell.armlinux.org.uk>
References: <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com>
 <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk>
 <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
 <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
 <20190604232433.4v2qqxyihqi2rmjl@shell.armlinux.org.uk>
 <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpDyDLChzrqX19bU81+ss3psVesNftCqN7+7+GFkMe_-A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 05, 2019 at 02:46:13AM +0300, Vladimir Oltean wrote:
> On Wed, 5 Jun 2019 at 02:24, Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> > No - but that has nothing to do with phylib internals, more to do with
> > the higher levels of networking.  ndo_stop() will not be called unless
> > ndo_open() has already been called.  In other words, setting an already
> > down device down via "ip link set dev eth0 down" is a no-op.
> >
> > So, let's a common scenario.  You power up a board.  The PHY comes up
> > and establishes a link.  The boot loader runs, loads the kernel, which
> > then boots.  Your network driver is a module, and hasn't been loaded
> > yet.  The link is still up.
> >
> > The modular network driver gets loaded, and initialises.  Userspace
> > does not bring the network device up, and the network driver does not
> > attach or connect to the PHY (which is actually quite common).  So,
> > the link is still up.
> >
> > The modular PHY driver gets loaded, and binds to the PHY.  The link
> > is still up.
> 
> I would rather say, 'even if the link is not up, Linux brings it up
> (possibly prematurely) via phy_resume'.
> But let's consider the case where the link *was* up. The general idea
> is 'implement your workarounds in whatever other way, that link is
> welcome!'.

I think you've missed some of the nuances about my example scenario.

If your MAC driver expects the MII pins to be silent after it probes,
this will not be the case in the scenario that I've given you.  The
PHY won't be silenced here, even with your proposed changes.

> > Userspace configures the network interface, which causes the PHY
> > device to be attached to the network device, and phy_start() to be
> > called on it - the negotiation advertisement is configured, and
> > negotiation restarted if necessary.

This is where your suggested modifications first take effect.

What I'm stating is that if you write your network driver to require
that the PHY link is down after the network driver is probed but before
ndo_open is called, in the above exact scenario, that will not be the
case and your network driver may malfunction.

Having the kernel rely on a certain boot loader behaviour is very bad.

You also have to consider that the previous context to the kernel
booting may _not_ be the boot loader - for example, if the kernel
supports crash dump kexec, then the previous context to the crash
kernel is the kernel which crashed, which may well have established a
link on the network interface.

So, relying on the state of the hardware from the boot loader is a
recipe for a buggy driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
