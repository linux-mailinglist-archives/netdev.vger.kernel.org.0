Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6E8235184
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 11:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHAJiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 05:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgHAJiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 05:38:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A659CC06174A
        for <netdev@vger.kernel.org>; Sat,  1 Aug 2020 02:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1fj6jt/8cgzCFcntbjeo5qy4JcIFX4knM02EOdlnTx4=; b=zoOkTlZtQv/25voOj6ZDyAvIE
        J7WLNz0XwwWuTvIBxH53ieEIzFZfRawVbnGl3D0FxGt7t1lhI/8WTFec3skXJc92HcMnt5qnTN/rg
        DcYtmyvnYgnC0Hvc9TEFbvH+sl/ewunuwnJJ2LwYYRe/1oh00p4NJPnB5Nhbx1st/ZqGAihRSnvya
        0ROC+J3reXVxodkAk2n9eulYTFlXJLsSId1KFOI6C9VAMEtjF3qEFyNcCrebLdkOi4SF6qgCIO5ez
        2wLyR8wxm5duZj9uQANHTAXzJ5tFylkoWCxkv1SL4lD8SWvRruEQk5KyPU9nz6KpTNGa9kJEzvgeq
        fNxWw7QPw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46874)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k1nxv-0008Kj-4Y; Sat, 01 Aug 2020 10:38:07 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k1nxt-0000Ha-Rx; Sat, 01 Aug 2020 10:38:05 +0100
Date:   Sat, 1 Aug 2020 10:38:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Vikas Singh <vikas.singh@puresoftware.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        "Calvin Johnson (OSS)" <calvin.johnson@oss.nxp.com>,
        Kuldip Dwivedi <kuldip.dwivedi@puresoftware.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Vikas Singh <vikas.singh@nxp.com>
Subject: Re: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of
 ACPI probe
Message-ID: <20200801093805.GG1551@shell.armlinux.org.uk>
References: <1595938298-13190-1-git-send-email-vikas.singh@puresoftware.com>
 <20200731165455.GD1748118@lunn.ch>
 <CADvVLtUAd0X7c39BX791CuyWBcmfBsp7Xvw9Jyp05w45agJY9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvVLtUAd0X7c39BX791CuyWBcmfBsp7Xvw9Jyp05w45agJY9g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 10:23:38AM +0530, Vikas Singh wrote:
> Hi Andrew,
> 
> As i have already mentioned that this patch is based on
> https://www.spinics.net/lists/netdev/msg662173.html,
> <https://www.spinics.net/lists/netdev/msg662173.html>
> 
> When MDIO bus gets registered itself along with devices on it , the
> function mdiobus_register() inside of_mdiobus_register(), brings
> up all the PHYs on the mdio bus and attach them to the bus with the help
> of_mdiobus_link_mdiodev() inside mdiobus_scan() .
> Additionally it has been discussed with the maintainers that the
> mdiobus_register() function should be capable of handling both ACPI & DTB
> stuff
> without any change to existing implementation.
> Now of_mdiobus_link_mdiodev() inside mdiobus_scan() see if the auto-probed
> phy has a corresponding child in the bus node, and set the "of_node"
> pointer in DT case.
> But lacks to set the "fwnode" pointer in ACPI case which is resulting in
> mdiobus_register() failure as an end result theoretically.
> 
> Now this patch set (changes) will attempt to fill this gap and generalise
> the mdiobus_register() implementation for both ACPI & DT with no duplicacy
> or redundancy.

Please do not top-post.

What Andrew is asking is why _should_ a DT specific function (which
starts with of_, meaning "open firmware") have anything to do with
ACPI.  The function you refer to (of_mdiobus_link_mdiodev()) is only
built when CONFIG_OF_MDIO is enabled, which is again, a DT specific
thing.

So, why should a DT specific function care about ACPI?

We're not asking about the fine details, we're asking about the high
level idea that DT functions should know about ACPI.

The assignment in of_mdiobus_link_mdiodev() to dev->fwnode is not
itself about ACPI, it's about enabling drivers that wish to access
DT properties through the fwnode property APIs can do so.

IMHO, the right way to go about this is to implement it as a non-DT
function.  Given that it is a static function, Andrew may find it
acceptable if you also renamed of_mdiobus_link_mdiodev() as
mdiobus_link_mdiodev() and moved it out of the #ifdef.

+               bus->dev.fwnode = bus->parent->fwnode;

That should be done elsewhere, not here.  of_mdiobus_register() already
ensures that this is appropriately set, and if it isn't, maybe there's
a bug elsewhere.

Lastly, note that you don't need two loops, one for ACPI and one for
DT (it's a shame there isn't a device_for_each_available_child_node()):

	int addr;

	if (dev->fwnode && !bus->dev.fwnode)
		return;

	device_for_each_child_node(&bus->dev, fwnode) {
		if (!fwnode_device_is_available(fwnode))
			continue;

		if (is_of_node(fwnode))
			addr = of_mdio_parse_addr(dev, to_of_node(fwnode));
		else if (fwnode_property_read_u32(fwnode, "reg", &addr))
			continue;

		if (addr == mdiodev->addr) {
			dev->of_node = to_of_node(fwnode);
			dev->fwnode = fwnode;
			return;
		}
	}

which, I think, will behave identically to the existing implementation
when called in a DT setup, but should also add what you want.

So, maybe with the above, moving it out from under the ifdef, and
renaming it _may_ be acceptable.  This is just a suggestion.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
