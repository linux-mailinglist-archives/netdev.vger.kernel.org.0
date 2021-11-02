Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836FC44346E
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhKBRQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:16:36 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhKBRQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 13:16:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=TmVzMVTE0iCtYUmu/Z950typ+fjZNTMY0APAwpqZYU0=; b=K0lt4lV3mNOCQSick+hrxArjMf
        RwZt0b05ye6pDrp0S1PLQyUNYcg3671TH6LQmWohavmhFUFAB5jP+ui0BYS6C5ptHeRL0qYDJbWvp
        V8hBpIOSRprBZcy2BXTI3hIZYdA6HHwIOMNNbli/Ye/ts459qOUKUzsoaiWatzy7dyYs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhxM9-00CQKg-OY; Tue, 02 Nov 2021 18:13:53 +0100
Date:   Tue, 2 Nov 2021 18:13:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYFx0YJ2KlDhbfQB@lunn.ch>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch>
 <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 12:39:52PM +0000, Russell King (Oracle) wrote:
> On Tue, Nov 02, 2021 at 01:49:42AM +0100, Andrew Lunn wrote:
> > > The use of the indirect registers is specific to PHYs, and we already
> > > know that various PHYs don't support indirect access, and some emulate
> > > access to the EEE registers - both of which are handled at the PHY
> > > driver level.
> > 
> > That is actually an interesting point. Should the ioctl call actually
> > use the PHY driver read_mmd and write_mmd? Or should it go direct to
> > the bus? realtek uses MII_MMD_DATA for something to do with suspend,
> > and hence it uses genphy_write_mmd_unsupported(), or it has its own
> > function emulating MMD operations.
> > 
> > So maybe the ioctl handler actually needs to use __phy_read_mmd() if
> > there is a phy at the address, rather than go direct to the bus?
> > 
> > Or maybe we should just say no, you should do this all from userspace,
> > by implementing C45 over C22 in userspace, the ioctl allows that, the
> > kernel does not need to be involved.
> 
> Yes and no. There's a problem accessing anything that involves some kind
> of indirect or paged access with the current API - you can only do one
> access under the bus lock at a time, which makes the whole thing
> unreliable. We've accepted that unreliability on the grounds that this
> interface is for debugging only, so if it does go wrong, you get to keep
> all the pieces!

Agreed.

> That said, the MII ioctls are designed to be a bus level thing - you can
> address anything on the MII bus with them. Pushing the ioctl up to the
> PHY layer means we need to find the right phy device to operate on. What
> if we attempt a C45 access at an address that there isn't a phy device?

Yes, i think we need to keep with, this API is for MDIO bus access. If
you want to do C45 over C22, you need to do it in user space, since
that builds on top of basic MDIO bus accesses.

> Personally, my feeling would be that if we want to solve this, we need
> to solve this properly - we need to revise the interface so it's
> possible to request the kernel to perform a group of MII operations, so
> that userspace can safely access any paged/indirect register. With that
> solved, there will be no issue with requiring userspace to know what
> it's doing with indirect C45 accesses.

I'm against that. It opens up an API to allow user space drivers,
which i have always pushed back against. The current API is good
enough you can use it for debug, but at the same time it is
sufficiently broken that anybody trying to do user space drivers over
it is asking for trouble. That seems like a good balance to me.

   Andrew
