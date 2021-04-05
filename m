Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA80354811
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 23:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232259AbhDEVNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 17:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbhDEVM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 17:12:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905C3C061756;
        Mon,  5 Apr 2021 14:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FlPVL2YW6cfbH1aHkcHb+iJRRts6aM1QDTsGgGRCbVw=; b=0Ez7DmPL312HANuE/cltuMCSM
        XYqoy13BFbjcq+g9TH1D+F6h0qwDgNcvrmqdxoNy4qMdwBaxR9vV7dXkuYTfoNNQA/3jFk9SDusSr
        M1U74AOfqWoU2fPmVSxkqhtB1rUrF0w8wbSLc36ILAxSCpCBp27Y85qCQiDhXbigbOHpPefXkEc71
        X1I1THeEzBdz+YHcgb3i+uRbOul9m37JOx8KTSbVMl1THZLA21+xLNpnV4nc5s/C//fr9gUFFf1cZ
        2kxZsG9Hvi2ZW0W5NqQ6/qG98MZLOgqJqMev+uCyaPE79GcSsKZ1kLaAM6gEIl8wbUeIV3EpsalKj
        dHHdERn+w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52130)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lTWWU-0006k4-IG; Mon, 05 Apr 2021 22:12:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lTWWS-0000RI-U4; Mon, 05 Apr 2021 22:12:36 +0100
Date:   Mon, 5 Apr 2021 22:12:36 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Danilo Krummrich <danilokrummrich@dk-develop.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeremy.linton@arm.com
Subject: Re: [PATCH 2/2] net: mdio: support c45 peripherals on c22 busses
Message-ID: <20210405211236.GD1463@shell.armlinux.org.uk>
References: <YGSi+b/r4zlq9rm8@lunn.ch>
 <6f1dfc28368d098ace9564e53ed92041@dk-develop.de>
 <20210331183524.GV1463@shell.armlinux.org.uk>
 <2f0ea3c3076466e197ca2977753b07f3@dk-develop.de>
 <20210401084857.GW1463@shell.armlinux.org.uk>
 <YGZvGfNSBBq/92D+@arch-linux>
 <20210402125858.GB1463@shell.armlinux.org.uk>
 <YGoSS7llrl5K6D+/@arch-linux>
 <YGsRwxwXILC1Tp2S@lunn.ch>
 <YGtdv++nv3H5K43E@arch-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGtdv++nv3H5K43E@arch-linux>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 08:58:07PM +0200, Danilo Krummrich wrote:
> On Mon, Apr 05, 2021 at 03:33:55PM +0200, Andrew Lunn wrote:
> However, this was about something else - Russell wrote:
> > > > We have established that MDIO drivers need to reject accesses for
> > > > reads/writes that they do not support [..]
> The MDIO drivers do this by checking the MII_ADDR_C45 flag if it's a C45 bus
> request. In case they don't support it they return -EOPNOTSUPP. So basically,
> the bus drivers read/write functions (should) encode the capability of doing
> C45 transfers.
> 
> I just noted that this is redundant to the bus' capabilities field of
> struct mii_bus which also encodes the bus' capabilities of doing C22 and/or C45
> transfers.
> 
> Now, instead of encoding this information of the bus' capabilities at both
> places, I'd propose just checking the mii_bus->capabilities field in the
> mdiobus_c45_*() functions. IMHO this would be a little cleaner, than having two
> places where this information is stored. What do you think about that?

It would be good to clean that up, but that's a lot of work given the
number of drivers - not only in terms of making the changes but also
making sure that the changes are as correct as would be sensibly
achievable... then there's the problem of causing regressions by doing
so.

The two ways were introduced at different times to do two different
things: the checking in the read/write methods in each driver was the
first method, which was being added to newer drivers. Then more
recently came the ->capabilities field.

So now we have some drivers that:
- do no checks and don't fill in ->capabilities either (some of which
  are likely C22-only.)
- check in their read/write methods for access types they don't support
  (e.g. drivers/net/ethernet/marvell/mvmdio.c) and don't fill in
  ->capabilities. Note, mvmdio supports both C22-only and C45-only
  interfaces with no C22-and-C45 interfaces.
- do fill in ->capabilities with MDIOBUS_C22_C45 (and hence have no
  checks in their read/write functions).

Sometimes, its best to leave stuff alone... if it ain't broke, don't
make regressions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
