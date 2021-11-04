Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 432E9445323
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhKDMiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 08:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKDMiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 08:38:05 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BD6C061714;
        Thu,  4 Nov 2021 05:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gTvExCAIQniJoHis0zPNIcgjI2X81k00ve1hFKX54uM=; b=2DgZrVNVn0KO/S5YqvnoQeU5qI
        5NIJjAH3MmpmUkdV/waNALRuh3hiaylM/dYIWF3aC1NHZCBXIBgqPtkBSWkvFpQ1nj/ckiXEP1j8C
        S8dV6b3z2p+Q2arlftQHDTU6kdrhkvCwGr3Vv9nRv18lbojdO4df5z1J//gpKN/+bENpRAsKvVAU4
        tt0Cah64EhMVhcba/nAp58tifAvp/UH1MTj8jCQsg07Dt8fnbFIic8Q447ewVdFIjaKR9c6sqRHvU
        ZwPEZvPWhziA7GTirM5H5ciPCxj6xf3hkBXXTErDfz1/Ph8wLLIMDgtPAC76YV/aIsUdO49keAIdp
        pWYKqVeg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55478)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mibxg-0005x4-6e; Thu, 04 Nov 2021 12:35:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mibxd-0007KM-7M; Thu, 04 Nov 2021 12:35:17 +0000
Date:   Thu, 4 Nov 2021 12:35:17 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [RFC PATCH] net: phy/mdio: enable mmd indirect access through
 phy_mii_ioctl()
Message-ID: <YYPThd7aX+TBWslz@shell.armlinux.org.uk>
References: <bc9df441-49bf-5c8a-891c-cc3f0db00aba@ti.com>
 <YYF4ZQHqc1jJsE/+@shell.armlinux.org.uk>
 <e18f17bd-9e77-d3ef-cc1e-30adccb7cdd5@ti.com>
 <828e2d69-be15-fe69-48d8-9cfc29c4e76e@ti.com>
 <YYGxvomL/0tiPzvV@lunn.ch>
 <8d24c421-064c-9fee-577a-cbbf089cdf33@ti.com>
 <YYHXcyCOPiUkk8Tz@lunn.ch>
 <01a0ebf9-5d3f-e886-4072-acb9bf418b12@ti.com>
 <YYLk0dEKX2Jlq0Se@lunn.ch>
 <87pmrgjhk4.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmrgjhk4.fsf@waldekranz.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 04, 2021 at 12:17:47PM +0100, Tobias Waldekranz wrote:
> On Wed, Nov 03, 2021 at 20:36, Andrew Lunn <andrew@lunn.ch> wrote:
> > On Wed, Nov 03, 2021 at 08:42:07PM +0200, Grygorii Strashko wrote:
> >> 
> >> 
> >> On 03/11/2021 02:27, Andrew Lunn wrote:
> >> > > > What i find interesting is that you and the other resent requester are
> >> > > > using the same user space tool. If you implement C45 over C22 in that
> >> > > > tool, you get your solution, and it will work for older kernels as
> >> > > > well. Also, given the diverse implementations of this IOTCL, it
> >> > > > probably works for more drivers than just those using phy_mii_ioctl().
> >> > > 
> >> > > Do you mean change uapi, like
> >> > >   add mdio_phy_id_is_c45_over_c22() and
> >> > >   flag #define MDIO_PHY_ID_C45_OVER_C22 0x4000?
> >> > 
> >> > No, i mean user space implements C45 over C22. Make phytool write
> >> > MII_MMD_CTRL and MII_MMD_DATA to perform a C45 over C22.
> >> 
> >> Now I give up - as mentioned there is now way to sync User space vs Kernel
> >> MMD transactions and so no way to get trusted results.
> 
> Except that there is a way: https://github.com/wkz/mdio-tools

I'm guessing that this hasn't had much in the way of review, as it has
a nice exploitable bug - you really want "pc" to be unsigned in
mdio_nl_eval(), otherwise one can write a branch instruction that makes
"pc" negative.

Also it looks like one can easily exploit this to trigger any of your
BUG_ON()/BUG() statements, thereby crashing while holding the MDIO bus
lock causing a denial of service attack.

I also see nothing that protects against any user on a system being
able to use this interface, so the exploits above can be triggered by
any user. Moreover, this lack of protection means any user on the
system can use this interface to write to a PHY.

Given that some PHYs today contain firmware, this gives anyone access
to reprogram the PHY firmware, possibly introducing malicious firmware.

I hope no one is using this module in a production environment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
