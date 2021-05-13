Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6A137F3E3
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 10:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhEMILP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 04:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbhEMILN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 04:11:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4029EC061574;
        Thu, 13 May 2021 01:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/NESzHwym3XtCoGMXOiM5WCowQQPiyusBeHAHRS0vfg=; b=GZkhcKULQSAULYUqQvnlmsI/3
        78MbWC2j0wXnjAYTr4Gc4zVmJ4g3wv5D33kNsl+YVCrxk3bMSD2ORnbEDYf7EJglkHeEMc1pFBtCu
        An1qhk4TeUVAXWfshJdnDpAq4S9ttppEapX1CrmF8yGvTV+SF2pwzcV0YP68DScsGMdpOazXp2SzW
        AyGNf6exDtT9Y6lo5SSdLDa0/+alOtFuhsTTUFoyFgO4GgUIdzaYCkfwHNrcs4fVEtBrAQJJtcbZU
        IzsmTQDWLGgh5SrXn3dni0gkx2PRyhmgW7GSn252RoUBfofJFvjJ1OCjyJ+F75CuFIqRtcdI+uQmH
        Te53m4n/w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43916)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lh6Pv-0005oL-5n; Thu, 13 May 2021 09:09:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lh6Pt-0002qR-B2; Thu, 13 May 2021 09:09:57 +0100
Date:   Thu, 13 May 2021 09:09:57 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, david.daney@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mdio: Fix a double free issue in the .remove
 function
Message-ID: <20210513080957.GS1336@shell.armlinux.org.uk>
References: <f8ad939e6d5df4cb0273ea71a418a3ca1835338d.1620855222.git.christophe.jaillet@wanadoo.fr>
 <20210512214403.GQ1336@shell.armlinux.org.uk>
 <0a044473-f3f7-02fc-eca5-84adf8b5c9f2@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a044473-f3f7-02fc-eca5-84adf8b5c9f2@wanadoo.fr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 08:29:01AM +0200, Christophe JAILLET wrote:
> Le 12/05/2021 à 23:44, Russell King - ARM Linux admin a écrit :
> > On Wed, May 12, 2021 at 11:35:38PM +0200, Christophe JAILLET wrote:
> > > 'bus->mii_bus' have been allocated with 'devm_mdiobus_alloc_size()' in the
> > > probe function. So it must not be freed explicitly or there will be a
> > > double free.
> > > 
> > > Remove the incorrect 'mdiobus_free' in the remove function.
> > 
> > Yes, this looks correct, thanks.
> > 
> > Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
> > 
> > However, there's another issue in this driver that ought to be fixed.
> > 
> > If devm_mdiobus_alloc_size() succeeds, but of_mdiobus_register() fails,
> > we continue on to the next bus (which I think is reasonable.) We don't
> > free the bus.
> > 
> > When we come to the remove method however, we will call
> > mdiobus_unregister() on this existent but not-registered bus. Surely we
> > don't want to do that?
> > 
> 
> Hmmm, I don't agree here.
> 
> 'nexus' is 'kzalloc()'ed.
> So the pointers in 'buses[]' are all NULL by default.
> We set 'nexus->buses[i] = bus' only when all functions that can fail in the
> loop have been called. (the very last 'break' is when the array is full)
> 
> And in the remove function, we have:
> 	struct cavium_mdiobus *bus = nexus->buses[i];
> 	if (!bus)
> 		continue;
> 
> So, this looks safe to me.

It isn't safe. Please look closer.

        device_for_each_child_node(&pdev->dev, fwn) {
                mii_bus = devm_mdiobus_alloc_size(&pdev->dev, sizeof(*bus));
                if (!mii_bus)
                        break;
                bus = mii_bus->priv;
                bus->mii_bus = mii_bus;

                nexus->buses[i] = bus;

This succeeds and sets nexus->buses[i] to a non-NULL value.

                err = of_mdiobus_register(bus->mii_bus, node);
                if (err)
                        dev_err(&pdev->dev, "of_mdiobus_register failed\n");

                dev_info(&pdev->dev, "Added bus at %llx\n", r.start);
                if (i >= ARRAY_SIZE(nexus->buses))
                        break;
        }

If of_mdiobus_register() fails, the bus is not registered, and we just
move on to the next bus, leaving nexus->buses[i] set to a non-NULL
value.

If we now look at the remove code:

        for (i = 0; i < ARRAY_SIZE(nexus->buses); i++) {
                struct cavium_mdiobus *bus = nexus->buses[i];

                if (!bus)
                        continue;

                mdiobus_unregister(bus->mii_bus);

nexus->buses[i] is non-NULL, but the bus is _not_ registered. We end up
calling mdiobus_unregister() on an allocated but _unregistered_ bus.
This is a bug.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
