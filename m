Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 266D9464A4B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 10:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242051AbhLAJFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 04:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbhLAJFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 04:05:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C21C061574;
        Wed,  1 Dec 2021 01:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4zsv56du9WrDnNkABuKCURrUGUFAX77zWaFiEC1rNsc=; b=lgPsvb1WOVk2xcPXEnNGCe8Ydz
        2aM74xPuH9Mlq8qbhWO5yOtWXd3xT1Qtbjnd12qLzoRzESoW+6LdP08m8CmTnC/A5iC5jy9omZXNV
        Cq9QP1nT2eI5jPgJXhfw2NNQpgtI0Sfq+XQ2j/eoohNiOTf8L2/vPS2kpVkCPlR5R49NIAtZ5GX5a
        9Uq+5sOCHReHkHMF845bt/NYIIN+Nt61uitjtFmg/8Yf/0txdq3hMPvVoDYvwMEDYqtgL/p0Estnm
        XFAQnybA5YHTqtjq5o3vhcOgpQ1O6UA5rB4P5pFbuoDhSulqpEwzFDYtdMpvLVBohW2M/CmTCXD2X
        Y8H+LMTA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56000)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1msLVB-0007ks-2a; Wed, 01 Dec 2021 09:02:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1msLV7-0007ry-1T; Wed, 01 Dec 2021 09:02:05 +0000
Date:   Wed, 1 Dec 2021 09:02:05 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Yinbo Zhu <zhuyinbo@loongson.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 1/2] modpost: file2alias: fixup mdio alias garbled
 code in modules.alias
Message-ID: <Yac6DakLxBxFgfZk@shell.armlinux.org.uk>
References: <1637919957-21635-1-git-send-email-zhuyinbo@loongson.cn>
 <c6d37ae0-9ccb-a527-4f55-e96972813a53@gmail.com>
 <YaYPMOJ/+OXIWcnj@shell.armlinux.org.uk>
 <YabEHd+Z5SPAhAT5@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YabEHd+Z5SPAhAT5@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 01:38:53AM +0100, Andrew Lunn wrote:
> > However, this won't work for PHY devices created _before_ the kernel
> > has mounted the rootfs, whether or not they end up being used. So,
> > every PHY mentioned in DT will be created before the rootfs is mounted,
> > and none of these PHYs will have their modules loaded.
> 
> Hi Russell
> 
> I think what you are saying here is, if the MAC or MDIO bus driver is
> built in, the PHY driver also needs to be built in?
> 
> If the MAC or MDIO bus driver is a module, it means the rootfs has
> already been mounted in order to get these modules. And so the PHY
> driver as a module will also work.

Yes, because the module loading is performed by phy_device_create() when
it calls phy_request_driver_module(), which will happen when either the
MDIO bus is scanned or the DT is parsed for the PHY nodes.

> > I believe this is the root cause of Yinbo Zhu's issue.
> 
> You are speculating that in Yinbo Zhu case, the MAC driver is built
> in, the PHY is a module. The initial request for the firmware fails.

s/firmware/module/ and it could also be the MDIO bus driver that is
built in.

> Yinbo Zhu would like udev to try again later when the modules are
> available.

I think so - it's speculation because it seems quite difficult to find
out detailed information.

> > What we _could_ do is review all device trees and PHY drivers to see
> > whether DT modaliases are ever used for module loading. If they aren't,
> > then we _could_ make the modalias published by the kernel conditional
> > on the type of mdio device - continue with the DT approach for non-PHY
> > devices, and switch to the mdio: scheme for PHY devices. I repeat, this
> > can only happen if no PHY drivers match using the DT scheme, otherwise
> > making this change _will_ cause a regression.
> 
> Take a look at
> drivers/net/mdio/of_mdio.c:whitelist_phys[] and the comment above it.
> 
> So there are some DT blobs out there with compatible strings for
> PHYs. I've no idea if they actually load that way, or the standard PHY
> mechanism is used.

Well, this suggests we have no instances - if none of our modules
contain a DT table to match a PHY-driver, then we should be pretty
safe.

$ grep phy_driver drivers/net -rl | xargs grep 'MODULE_ALIAS\|MODULE_DEVICE.*of'
drivers/net/phy/xilinx_gmii2rgmii.c:MODULE_DEVICE_TABLE(of, xgmiitorgmii_of_match);
drivers/net/mdio/mdio-moxart.c:MODULE_DEVICE_TABLE(of, moxart_mdio_dt_ids);
drivers/net/dsa/mt7530.c:MODULE_DEVICE_TABLE(of, mt7530_of_match);

All three look to be false hits - none are phy drivers themselves, they
just reference "phy_driver". So, I think we can say that we have no
instances of PHY driver being matched using DT in net-next in
drivers/net. Hopefully, there aren't any PHY drivers elsewhere in the
kernel tree.

That is not true universally for all MDIO though - as
xilinx_gmii2rgmii.c clearly shows. That is a MDIO driver which uses DT
the compatible string to do the module load. So, we have proof there
that Yinbo Zhu's change will definitely cause a regression which we
can not allow.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
