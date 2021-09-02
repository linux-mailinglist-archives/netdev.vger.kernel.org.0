Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758293FF374
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 20:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347143AbhIBSvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 14:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347038AbhIBSvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 14:51:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ECDC061575;
        Thu,  2 Sep 2021 11:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=drpG5yccg6XGFBuzw4/AMknhlRsz6o7ucAUAvYR+2DQ=; b=CzkObxdSZhPWYwQ6tP3AuUhFN
        gd6wbWSpGQHxLiwVfmACzQZWKgpdNDG0e4IbuRzx4LD+FqPz4jyG3yOx57YrhMpnxzQRtdpclilVe
        IAICQhxqNmlfEgruayLsenFOKt/zecrLM2/BS8Vj0YQQEYV96p7fJQoKje3Xz3e5f/TmSyIcDdmq3
        0FO5fw8pdFGqLZClBaYk4FIrC/gHcNb7o3vV6U3j6AnEewiYGPlU4ZEoHB6kxWr3Ooiwz5mZae1bF
        kdhlgP2s3NtNQdAVlYSoTKHFNPOb9g3qPoVO9zDsZ/GtJLYEdP+Jr9L8cnm6KkyxXoO57135qHP3N
        DIOmhIc8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48106)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLrn0-0001sL-J6; Thu, 02 Sep 2021 19:50:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLrmy-00087b-Es; Thu, 02 Sep 2021 19:50:16 +0100
Date:   Thu, 2 Sep 2021 19:50:16 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210902185016.GL22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901225053.1205571-2-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:50:51AM +0300, Vladimir Oltean wrote:
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 52310df121de..2c22a32f0a1c 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1386,8 +1386,16 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
>  
>  	/* Assume that if there is no driver, that it doesn't
>  	 * exist, and we should use the genphy driver.
> +	 * The exception is during probing, when the PHY driver might have
> +	 * attempted a probe but has requested deferral. Since there might be
> +	 * MAC drivers which also attach to the PHY during probe time, try
> +	 * harder to bind the specific PHY driver, and defer the MAC driver's
> +	 * probing until then.
>  	 */
>  	if (!d->driver) {
> +		if (device_pending_probe(d))
> +			return -EPROBE_DEFER;

Something else that concerns me here.

As noted, many network drivers attempt to attach their PHY when the
device is brought up, and not during their probe function.

Taking a driver at random:

drivers/net/ethernet/renesas/sh_eth.c

sh_eth_phy_init() calls of_phy_connect() or phy_connect(), which
ultimately calls phy_attach_direct() and propagates the error code
via an error pointer.

sh_eth_phy_init() propagates the error code to its caller,
sh_eth_phy_start(). This is called from sh_eth_open(), which
probagates the error code. This is called from .ndo_open... and it's
highly likely -EPROBE_DEFER will end up being returned to userspace
through either netlink or netdev ioctls.

Since EPROBE_DEFER is not an error number that we export to
userspace, this should basically never be exposed to userspace, yet
we have a path that it _could_ be exposed if the above condition
is true.

If device_pending_probe() returns true e.g. during initial boot up
while modules are being loaded - maybe the phy driver doesn't have
all the resources it needs because of some other module that hasn't
finished initialising - then we have a window where this will be
exposed to userspace.

So, do we need to fix all the network drivers to do something if
their .ndo_open method encounters this? If so, what? Sleep a bit
and try again? How many times to retry? Convert the error code into
something else, causing userspace to fail where it worked before? If
so which error code?

I think this needs to be thought through a bit better. In this case,
I feel that throwing -EPROBE_DEFER to solve one problem with one
subsystem can result in new problems elsewhere.

We did have an idea at one point about reserving some flag bits in
phydev->dev_flags for phylib use, but I don't think that happened.
If this is the direction we want to go, I think we need to have a
flag in dev_flags so that callers opt-in to the new behaviour whereas
callers such as from .ndo_open keep the old behaviour - because they
just aren't setup to handle an -EPROBE_DEFER return from these
functions.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
