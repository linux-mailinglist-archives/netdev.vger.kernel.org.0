Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E543FEDBC
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 14:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344399AbhIBM03 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 08:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344074AbhIBM02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 08:26:28 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22785C061575;
        Thu,  2 Sep 2021 05:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1wOKCrX3COV6DlxfudE8AnDiURX7M6vGBTgHMAhqiY4=; b=rqK6AEvPgoByLYFRodspB7Byw
        7gqMzeAVrrtGevy7S/Pe4kpxFOG541wx2HwjnEnffJUbdF5hpGnPUE5ySMo1DbZcFAzPmnds7zmp+
        Jj1zgwrIxm6M0IrdmtR1pc/NjF4oW1CvyFeGIDapO7P9JKM4zZouHP9S7Vdcxy+PY9MvtgiZ3DXk+
        mFmcyTwXarm08r5htAsGboZCNkAZqOtGAinHX0bvrFOY06FxWdqIlPllA4Igcplk7tTNVpClxl26y
        k6yQu2+qEuQvdgC0jKkB1O+Ngc3fVV9HBJzKmsm7WNRrb0nQBzJeEFDuEVjkJLHCrAEDEs2hy32+E
        4bbcBfltw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:48088)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mLlma-0001P2-4n; Thu, 02 Sep 2021 13:25:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mLlmZ-0007ov-0Y; Thu, 02 Sep 2021 13:25:27 +0100
Date:   Thu, 2 Sep 2021 13:25:26 +0100
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
Subject: Re: [RFC PATCH net-next 2/3] net: dsa: destroy the phylink instance
 on any error in dsa_slave_phy_setup
Message-ID: <20210902122526.GF22278@shell.armlinux.org.uk>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
 <20210901225053.1205571-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901225053.1205571-3-vladimir.oltean@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 02, 2021 at 01:50:52AM +0300, Vladimir Oltean wrote:
> DSA supports connecting to a phy-handle, and has a fallback to a non-OF
> based method of connecting to an internal PHY on the switch's own MDIO
> bus, if no phy-handle and no fixed-link nodes were present.
> 
> The -ENODEV error code from the first attempt (phylink_of_phy_connect)
> is what triggers the second attempt (phylink_connect_phy).
> 
> However, when the first attempt returns a different error code than
> -ENODEV, this results in an unbalance of calls to phylink_create and
> phylink_destroy by the time we exit the function. The phylink instance
> has leaked.
> 
> There are many other error codes that can be returned by
> phylink_of_phy_connect. For example, phylink_validate returns -EINVAL.
> So this is a practical issue too.
> 
> Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> I know, I will send this bug fix to "net" too, this is provided just for
> testing purposes, and for the completeness of the patch set.

Probably should have been the first patch of the set. This looks
absolutely correct to me. Please send for the net tree.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
