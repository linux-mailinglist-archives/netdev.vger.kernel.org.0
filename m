Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FFE442E58
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 13:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhKBMme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 08:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbhKBMmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 08:42:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BEAC061714;
        Tue,  2 Nov 2021 05:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Q2t2Yay9P4Tekd7fAPWyB6W35FYZ8UjNPE7qgmxtFgo=; b=mzrMOti1jC7Z7IrbXrFKTxSdjj
        xBdhuoTsRPyszsPNVJYGOM9tVuEUkNjumWw8op58jmC+Klrwy0rGjhCSOHgJPbCkVC+1lzq2mtm4D
        t86k3knymXnDi/mx9OWBtMV3bSEpm+L3YEGn40GGagGNuqVLdhQdFZ1K30/Ok8hczyJxGYVUzo8Vq
        FYQrT+XN+w0HPHiv8oWogVv0zNN+muK+TF7ib5PiIJg3onDrfMcWBQ+RsCcRpXXJ25YBGrlCPoskT
        MtH87Vcwn9uecvpIVZxx1A1hnxQMYmxObQWAsq5wWvqjtKO2zs1QMac4NsDB3hJivGwUOXqkzQNel
        YG6nSHWw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55438)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mht50-0003oe-Oy; Tue, 02 Nov 2021 12:39:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mht4y-0005QI-Rn; Tue, 02 Nov 2021 12:39:52 +0000
Date:   Tue, 2 Nov 2021 12:39:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYExmHYW49jOjfOt@shell.armlinux.org.uk>
References: <20211101182859.24073-1-grygorii.strashko@ti.com>
 <YYBBHsFEwGdPJw3b@lunn.ch>
 <YYBF3IZoSN6/O6AL@shell.armlinux.org.uk>
 <YYCLJnY52MoYfxD8@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYCLJnY52MoYfxD8@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 01:49:42AM +0100, Andrew Lunn wrote:
> > The use of the indirect registers is specific to PHYs, and we already
> > know that various PHYs don't support indirect access, and some emulate
> > access to the EEE registers - both of which are handled at the PHY
> > driver level.
> 
> That is actually an interesting point. Should the ioctl call actually
> use the PHY driver read_mmd and write_mmd? Or should it go direct to
> the bus? realtek uses MII_MMD_DATA for something to do with suspend,
> and hence it uses genphy_write_mmd_unsupported(), or it has its own
> function emulating MMD operations.
> 
> So maybe the ioctl handler actually needs to use __phy_read_mmd() if
> there is a phy at the address, rather than go direct to the bus?
> 
> Or maybe we should just say no, you should do this all from userspace,
> by implementing C45 over C22 in userspace, the ioctl allows that, the
> kernel does not need to be involved.

Yes and no. There's a problem accessing anything that involves some kind
of indirect or paged access with the current API - you can only do one
access under the bus lock at a time, which makes the whole thing
unreliable. We've accepted that unreliability on the grounds that this
interface is for debugging only, so if it does go wrong, you get to keep
all the pieces!

The paged access case is really no different from the indirect C45 case.
They're both exactly the same type of indirect access, just using
different registers.

That said, the MII ioctls are designed to be a bus level thing - you can
address anything on the MII bus with them. Pushing the ioctl up to the
PHY layer means we need to find the right phy device to operate on. What
if we attempt a C45 access at an address that there isn't a phy device?

For example, what would be the effect of trying a C45 indirect access to
a DSA switch?

Personally, my feeling would be that if we want to solve this, we need
to solve this properly - we need to revise the interface so it's
possible to request the kernel to perform a group of MII operations, so
that userspace can safely access any paged/indirect register. With that
solved, there will be no issue with requiring userspace to know what
it's doing with indirect C45 accesses.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
