Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49FF6B31
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfKJT7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:59:24 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:49746 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfKJT7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 14:59:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Mb7lmV5VdSEDbn5z+UQpRt5xKUnsnVF/CHxotntgtGI=; b=HQXQITqRfDezPcgC7O4eUUA0X
        SOmV32KApxZfXYGgvnd6SmhxiSKa9XqPavAdA4OpyjPrJp5WkOtw0vVlKL8YcVHLCSwhsxIBBd8wR
        ang1a7vCI7yBp/vGfV/1gv7N4XI+pAsqlwQZBwC5WOIDaV0sU9CkUC07hvyLUl2PolYpPheFB/3NC
        mDkXpF0v2yHSPaODu3AijA22uABe6I/LejxId7fGbAobtY6S7lB86dqEvd1j3PPYyMF7T59uGtWGP
        cF/Ei20EVa8xwGGQEtcuTgmTvqy+735wgqL/CloIp/6Oi5sF7wVXNhP2uZxIyI4eA7RdIAquYFpmz
        6NEI8wiVw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37894)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iTtMk-0000uT-5W; Sun, 10 Nov 2019 19:59:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iTtMj-0008Ce-0G; Sun, 10 Nov 2019 19:59:17 +0000
Date:   Sun, 10 Nov 2019 19:59:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/17] net: sfp: eliminate mdelay() from PHY
 probe
Message-ID: <20191110195916.GF25745@shell.armlinux.org.uk>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrn-0005B1-HR@rmk-PC.armlinux.org.uk>
 <20191110193719.GW25889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191110193719.GW25889@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 08:37:19PM +0100, Andrew Lunn wrote:
> On Sun, Nov 10, 2019 at 02:06:59PM +0000, Russell King wrote:
> > Rather than using mdelay() to wait before probing the PHY (which holds
> > several locks, including the rtnl lock), add an extra wait state to
> > the state machine to introduce the 50ms delay without holding any
> > locks.
> 
> Hi Russell
> 
> Is this 50ms part of the standard? Or did you find that empirically?

From what I'm aware, there is no standard for copper SFPs.

It's something that I found works with the Source Photonics module I
have, and after feedback via Jon Nettleton from folk using the SolidRun
platforms.

Hence, it's something I'm preserving in the kernel at the moment, as
we know it works for most people so far.  We can increase it within
reason if necessary (see my reply to your 00/17 reply.)

From what I can tell, accessing the PHY on I2C address 0x56 just
happens to work for many of the modules because most SFPs use the
Marvell 88E1111 - but there are modules out there (Mikrotik S-RJ01)
that have an Atheros AR8033 PHY which is inaccessible from the host
(and hence the results of the negotiation can't be fully known.)

However, I have a 10M/100M/1G/10G copper SFP+ which uses a Broadcom
Clause 45 PHY which is also accessible (via a slightly different I2C
protocol from the Clause 22 variety) via address 0x56, and there are
other copper SFP+ modules that I've found online that use the same
protocol - but with a delay between the I2C write and I2C read to
read a Clause 45 register.  So, 0x56 *appears* to be some kind of
informally agreed I2C address for SFP PHYs.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
