Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607B7423353
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 00:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhJEWTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 18:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbhJEWTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 18:19:06 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE442C061749;
        Tue,  5 Oct 2021 15:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XULOvGklXviYvYFGrR5ilqAd9cOfvaXdvUtIeDrOmGo=; b=BM8/PWBxs90DKGRg5uy1+/r4Pg
        WtOvyQ9EA5ssZ+ay8jKwHszq1SucEoKN7DEc3w0Z7W3B7qZKQm+IBXkObUdDssgj+5kvsuvxh8fMz
        HJfmcQSwxtcIGlOy08eGDZkSS3GEU7jq2+XyMjoUoiZ3EkFt5/50Lltx3XPuYtTiWUUCPKkbDlkZ1
        LgVTDPcGqhTJDJ0kUFpV+rNWuoSyUb9SZS+bbBqUGtxNBwRb3XuA4BWb0mu43ppy/043GgPNnhHWd
        tNGu+Lgqmwng6xNIYkNdmITXvyzuKmxsAyXciQ0eoJQ4E0wmdFwOOrTX8XjuJe4NjrpDOY32oPJMm
        LOV2VByQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54966)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mXskK-0000mc-DT; Tue, 05 Oct 2021 23:17:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mXskI-0000NJ-Hw; Tue, 05 Oct 2021 23:17:10 +0100
Date:   Tue, 5 Oct 2021 23:17:10 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC net-next PATCH 16/16] net: sfp: Add quirk to ignore PHYs
Message-ID: <YVzO5vrg7sZkZVKO@shell.armlinux.org.uk>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-17-sean.anderson@seco.com>
 <YVwp9R40r0ZWJzTa@shell.armlinux.org.uk>
 <66fd0680-a56b-a211-5f3e-ac7498f1ff9b@seco.com>
 <YVyjj64t2K7YOiM+@shell.armlinux.org.uk>
 <55f6cec4-2497-45a4-cb1a-3edafa7d80d3@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55f6cec4-2497-45a4-cb1a-3edafa7d80d3@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 04:38:23PM -0400, Sean Anderson wrote:
> There is a level shifter. Between the shifter and the SoC there were
> 1.8k (!) pull-ups, and between the shifter and the SFP there were 10k
> pull-ups. I tried replacing the pull-ups between the SoC and the shifter
> with 10k pull-ups, but noticed no difference. I have also noticed no
> issues accessing the EEPROM, and I have not noticed any difference
> accessing other registers (see below). Additionally, this same error is
> "present" already in xgbe_phy_finisar_phy_quirks(), as noted in the
> commit message.

Hmm, thanks for checking. So it's something "weird" that this module
is doing.

As I say, the 88E1111 has a native I2C mode, it sounds like they're not
using it but have their own, seemingly broken, protocol conversion from
the I2C bus to MDIO. I've opened and traced the I2C connections on this
module - they only go to an EEPROM and the 88E1111, so we know this is
a "genuine" 88E1111 in I2C mode we are talking to.

> First, reading two bytes at a time
> 	$ i2ctransfer -y 2 w1@0x56 2 r2
> 	0x01 0xff
> This behavior is repeatable
> 	$ i2ctransfer -y 2 w1@0x56 2 r2
> 	0x01 0xff
> Now, reading one byte at a time
> 	$ i2ctransfer -y 2 w1@0x56 2 r1
> 	0x01
> A second write/single read gets us the first byte again.
> 	$ i2ctransfer -y 2 w1@0x56 2 r1
> 	0x41

I think you mean you get the other half of the first word. When I try
this with a 88E1111 directly connected to the I2C bus, I get:

root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r2
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r2
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
0x01
root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
0x01

So a completely different behaviour. Continuing...

> And doing it for a third time gets us the first byte again.
> 	$ i2ctransfer -y 2 w1@0x56 2 r1
> 	0x01
> If we start another one-byte read without writing the address, we get
> the second byte
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x41

root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
0x01
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01

Again, different behaviour.

> And continuing this pattern, we get the next byte.
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x0c
> This can be repeated indefinitely
> 	$ i2ctransfer -y 2 r1@0x56
> 	0xc2
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x0c

root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x41
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01

Here we eventually start toggling between the high and low bytes of
the word.

> But stopping in the "middle" of a register fails
> 	$ i2ctransfer -y 2 w1@0x56 2 r1
> 	Error: Sending messages failed: Input/output error

root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2 r1
0x01

No error for me.

> We don't have to immediately read a byte:
> 	$ i2ctransfer -y 2 w1@0x56 2
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x01
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x41

root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01

Again, no toggling between high/low bytes of the word.

> We can read two bytes indefinitely after "priming the pump"
> 	$ i2ctransfer -y 2 w1@0x56 2 r1
> 	0x01
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x41
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x0c 0xc2
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x0c 0x01
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x00 0x00
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x00 0x04
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x20 0x01
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x00 0x00

root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01
root@clearfog21:~# i2ctransfer -y 1 r2@0x56
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 r2@0x56
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 r2@0x56
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 r2@0x56
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 r2@0x56
0x01 0x41
root@clearfog21:~# i2ctransfer -y 1 r2@0x56
0x01 0x41

No auto-increment of the register.

> But more than that "runs out"
> 	$ i2ctransfer -y 2 w1@0x56 2 r1
> 	0x01
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x41
> 	$ i2ctransfer -y 2 r4@0x56
> 	0x0c 0xc2 0x0c 0x01
> 	$ i2ctransfer -y 2 r4@0x56
> 	0x00 0x00 0x00 0x04
> 	$ i2ctransfer -y 2 r4@0x56
> 	0x20 0x01 0xff 0xff
> 	$ i2ctransfer -y 2 r4@0x56
> 	0x01 0xff 0xff 0xff

root@clearfog21:~# i2ctransfer -y 1 w1@0x56 2
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01
root@clearfog21:~# i2ctransfer -y 1 r1@0x56
0x01
root@clearfog21:~# i2ctransfer -y 1 r4@0x56
0x01 0x41 0x0c 0xc2
root@clearfog21:~# i2ctransfer -y 1 r4@0x56
0x01 0x41 0x0c 0xc2
root@clearfog21:~# i2ctransfer -y 1 r4@0x56
0x01 0x41 0x0c 0xc2
root@clearfog21:~# i2ctransfer -y 1 r4@0x56
0x01 0x41 0x0c 0xc2

> However, the above multi-byte reads only works when starting at register
> 2 or greater.
> 	$ i2ctransfer -y 2 w1@0x56 0 r1
> 	0x01
> 	$ i2ctransfer -y 2 r1@0x56
> 	0x40
> 	$ i2ctransfer -y 2 r2@0x56
> 	0x01 0xff
> 
> Based on the above session, I believe that it may be best to treat this
> phy as having an autoincrementing register address which must be read
> one byte at a time, in multiples of two bytes. I think that existing SFP
> phys may compatible with this, but unfortunately I do not have any on
> hand to test with.

Sadly, according to my results above, I think your module is doing
something strange with the 88E1111.

You say that it's Finisar, but I can only find this module in
Fiberstore's website: https://www.fs.com/uk/products/20057.html
Fiberstore commonly use "FS" in the vendor field.

You have me wondering what they've done to this PHY to make it respond
in the way you are seeing.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
