Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4920541AF86
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 14:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240778AbhI1M75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 08:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240488AbhI1M74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 08:59:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FA7C061575;
        Tue, 28 Sep 2021 05:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N91Odkvn6fGi6xkeczAp95Q6eOe4d6nyFJxmcuNT9Ig=; b=Ek8ZreanEHbnzqIY36x1bbqZsM
        E1LP/Pj+RE45yAn5x7d1H13lGv6dCOmTM6+rQOkQrmzx0xgcExMiVK/DYjHizqXMJqPkasszb4Rs6
        5PQNJ2QaLu1OZgkhbcNHduLGdw6fa8EvqZ7iPI5YO/w+tP8R9R3zmMLHTNxPMHKw/UWGBtpQCGdN6
        MqgV/K+oBLjd/Dhtxq2ne0NpoVgIklPRIBG0V4m9VUPvypkYuuAcKZogEsV5QfkLK1Cp2o5ypXq72
        BqbC0bFln0qM37pU8P9FhlabVOjn1q9e2p2Ii3sBMa7yJ1APri6FJXHRRCisTjwCkcFPOpvmvzDbf
        UAd7NdPQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54828)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mVCgP-00018T-Fl; Tue, 28 Sep 2021 13:58:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mVCgK-0001la-LZ; Tue, 28 Sep 2021 13:58:00 +0100
Date:   Tue, 28 Sep 2021 13:58:00 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dongliang Mu <mudongliangabcd@gmail.com>
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <YVMRWNDZDUOvQjHL@shell.armlinux.org.uk>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
 <20210928085549.GA6559@kili>
 <20210928092657.GI2048@kadam>
 <6f90fa0f-6d3b-0ca7-e894-eb971b3b69fa@gmail.com>
 <20210928103908.GJ2048@kadam>
 <63b18426-c39e-d898-08fb-8bfd05b7be9e@gmail.com>
 <20210928105943.GL2083@kadam>
 <283d01f0-d5eb-914e-1bd2-baae0420073c@gmail.com>
 <f587da4b-09dd-4c32-4ee4-5ec8b9ad792f@gmail.com>
 <20210928113055.GN2083@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928113055.GN2083@kadam>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 02:30:55PM +0300, Dan Carpenter wrote:
> On Tue, Sep 28, 2021 at 02:09:06PM +0300, Pavel Skripkin wrote:
> > On 9/28/21 14:06, Pavel Skripkin wrote:
> > > > It's not actually the same.  The state has to be set before the
> > > > device_register() or there is still a leak.
> > > > 
> > > Ah, I see... I forgot to handle possible device_register() error. Will
> > > send v2 soon, thank you
> > > 
> > > 
> > > 
> > Wait... Yanfei's patch is already applied to net tree and if I understand
> > correctly, calling put_device() 2 times will cause UAF or smth else.
> > 
> 
> Yes.  It causes a UAF.
> 
> Huh...  You're right that the log should say "failed to register".  But
> I don't think that's the correct syzbot link for your patch either
> because I don't think anyone calls mdiobus_free() if
> __devm_mdiobus_register() fails.  I have looked at these callers.  It
> would be a bug as well.
> 
> Anyway, your patch is required and the __devm_mdiobus_register()
> function has leaks as well.  And perhaps there are more bugs we have not
> discovered.

This thread seems to be getting out of hand.

Going back to the start of the thread, the commit message contains a
stack trace, and in that stack trace is ax88772_init_mdio(), which
is in drivers/net/usb/asix_devices.c. This function does:

        priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
	...
	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);

If devm_mdiobus_register() and we unwind the devm resources, then we
will call the registered free method for devm_mdiobus_alloc(), which
is devm_mdiobus_free(). This will call mdiobus_free().

Firstly, the driver is correct in what it is doing - using the devm_*
functions it doesn't get a choice about how the cleanup happens.

The problem appears to be:

- bus->state is MDIOBUS_ALLOCATED
- we call into __mdiobus_register()
- device_register() succeeds
- devm_gpiod_get_optional() returns an error code
- device_del(&bus->dev) undoes _part_ of the device_register()
- we do not update bus->state to MDIOBUS_UNREGISTERED

We *must* to the last step, because we haven't finished undoing the
effects of registering the bus device with the driver model by causing
the device to be properly released by the driver model - that being
that dev->p has been allocated and its name has been allocated and set.

device_del() does _not_ undo those allocations. Only the very last
put_device() does.

mdiobus_free() decides whether it can simply free the device or whether
it needs to use put_device() depending on bus->state - if bus->state
is MDIOBUS_ALLOCATED, that means the bus has _never_ been registered
with the driver model, and it is safe to kfree() it. If it is
MDIOBUS_UNREGISTERED, then that means the device has been registered
and needs put_device() to be called on it.

So, I would suggest a simple fix is to set bus->state to
MDIOBUS_UNREGISTERED immediately _after_ the successful
device_register() call with a comment that it is updated later in
the function - or to set bus->state to MDIOBUS_UNREGISTERED immediately
before the call to device_del() in __mdiobus_register().

A better fix would be to sort out the mess here and make
__mdiobus_register() respect the "get resources and setup first before
you register anything" rule.

In other words, initialise the mutexes and get the reset GPIO _before_
registering the bus with the driver model. That will cut down on the
uevent noise to userspace if the gpio defers and also simplify some of
the problem here - we then end up with one path where we call
device_del() in MDIOBUS_UNREGISTERED, rather than two.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
