Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBEF59C435
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237052AbiHVQcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiHVQcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:32:51 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7016A3B961;
        Mon, 22 Aug 2022 09:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1UuOn20+XY0HqqG0VXzejs2+7IqQXphAhg4cgVYS3dg=; b=nJ2q9nEUFEZ9M34sewvnWrwq20
        v68QufA9N7lafkixp2/44RYzrofmutij2cgiL2VNVoVtwvxBRI/xz0G5BNmYeTwQtD0h6KnFBNW85
        alBh8LgDUT+KqKrEgEAq+ErZCmCtCoALU1AOLA3kE0ZSEYYsiS+af2koiC9upmw0lIZm6ibJtRcwL
        dDbtYXhLcHIgfZ2SsaiE5agcMOtEM+4N9E84mc2JTu10a/iMJiz5jKTlKr3cQTw9FjVsr2xelGLri
        lpyl2RN721DM8RQOEHKCRJajOg23/ZbePGpbl+xxxenbywk3AyGZ/zOGvgmUdu3W5F7pCg0pOU2Ww
        Xmc0SDrg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33882)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQALz-000287-9h; Mon, 22 Aug 2022 17:32:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQALw-0002KS-Li; Mon, 22 Aug 2022 17:32:40 +0100
Date:   Mon, 22 Aug 2022 17:32:40 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
Message-ID: <YwOvqLacWLQNcIk6@shell.armlinux.org.uk>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
 <20220819164519.2c71823e@kernel.org>
 <YwAo42QkTgD0kOqz@shell.armlinux.org.uk>
 <b476d7b1-1221-2275-e445-6a70b3a31fe6@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b476d7b1-1221-2275-e445-6a70b3a31fe6@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 12:00:28PM -0400, Sean Anderson wrote:
> In the last thread I posted this snippet:
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index a74b320f5b27..05894e1c3e59 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -27,6 +27,7 @@
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
>  #include <linux/property.h>
> +#include <linux/rtnetlink.h>
>  #include <linux/sfp.h>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
> @@ -3111,6 +3112,13 @@ static int phy_remove(struct device *dev)
>  {
>         struct phy_device *phydev = to_phy_device(dev);
>  
> +	// I'm pretty sure this races with multiple unbinds...
> +       rtnl_lock();
> +       device_unlock(dev);
> +       dev_close(phydev->attached_dev);
> +       device_lock(dev);
> +       rtnl_unlock();
> +       WARN_ON(phydev->attached_dev);
> +
>         cancel_delayed_work_sync(&phydev->state_queue);
>  
>         mutex_lock(&phydev->lock);
> ---
> 
> Would this be acceptable? Can the locking be fixed?

I can't comment on that.

> > Addressing the PCS part of the patch posting and unrelated to what we
> > do for phylib...
> > 
> > However, I don't see "we'll do this for phylib, so we can do it for
> > PCS as well" as much of a sane argument - we don't have bazillions
> > of network drivers to fix to make this work for PCS. We currently
> > have no removable PCS (they don't appear with a driver so aren't
> > even bound to anything.) So we should add the appropriate handling
> > when we start to do this.
> > 
> > Phylink has the capability to take the link down when something goes
> > away, and if the PCS goes away, that's exactly what should happen,
> > rather than oopsing the kernel.
> 
> Yeah, but we can't just call phylink_stop; we have to call the function
> which will call phylink_stop, which is different for MAC drivers and
> for DSA drivers.

I think that's way too much and breaks the phylink design. phylink_stop
is designed to be called only from ndo_close() - and to be paired with
phylink_start().

When I talk about "taking the link down" what I mean by that is telling
the network device that the *link* *is* *down* and no more. In other
words, having phylink_resolve() know that there should be a PCS but it's
gone, and therefore the link should not come up in its current
configuration.

> I think we'd need something like
> 
> struct phylink_pcs *pcs_get(struct device *dev, const char *id,
> 			    void (*detach)(struct phylink_pcs *, void *),
> 			    void *priv)
> 
> which would also require that pcs_get is called before phylink_start,
> instead of in probe (which is what every existing user does).

That would at least allow the MAC driver to take action when the PCS
gets removed.

> This whole thing has me asking the question: why do we allow unbinding
> in-use devices in the first place?

The driver model was designed that way from the start, because in most
cases when something is unplugged from the system, the "remove" driver
callback is just a notification that the device has already gone.
Failing it makes no sense, because software can't magic the device
back.

Take an example of a USB device. The user unplugs it, it's gone from
the system, but the system briefly still believes the device to be
present for a while. It eventually notices that the device has gone,
and the USB layer unregisters the struct device - which has the effect
of unbinding the device from the driver and eventually cleaning up the
struct device.

This can and does happen with Ethernet PHYs ever since we started
supporting SFPs with Ethernet PHYs. The same thing is true there -
you can pull the module at any moment, it will be gone, and the
system will catch up with its physical disconnection some point later.
It's no good trying to make ->remove say "no, the device is still in
use, I won't let you remove it" because there's nothing software can
do to prevent the going of the device - the device has already
physically gone.

I don't think that's the case with PCS - do we really have any PCS
that can be disconnected from the system while it's running? Maybe
ones in a FPGA and the FPGA can be reprogrammed at runtime (yes,
people have really done this in the past.)

If we don't want to support "hotpluggable" PCS, then there's a
simple solution to this - the driver model has the facility to suppress
the bind/unbind driver files in sysfs, which means userspace can't
unbind the device. If there's also no way to make the struct device go
away in the kernel, then effectively the driver can then only be
unbound if the driver is built as a module.

At that point, we always have the option of insisting that PCS drivers
are never modules - and then we have the situation where a PCS will
never disappear from the system once the driver has picked up on it.

Of course, those PCS that are tightly bound to their MACs can still
come and go along with their MACs, but it's up to the MAC driver to
make that happen safely (unregistering the netdev first, which will
have the effect of calling ndo_close(), taking the network device
down and preventing further access to the netdev - standard netdev
MAC driver stuff.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
