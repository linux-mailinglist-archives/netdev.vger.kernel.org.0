Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2D64A338
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiLLOZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232016AbiLLOZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:25:18 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499C11A21;
        Mon, 12 Dec 2022 06:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=51T3cM0EFwbuKvphhMpq/225LyqI0jErFjDfuwBTyZg=; b=K5ryJ4SeFb8nf3RwRQx4hDjU4i
        wsH4MHOGYBpfyNLVfz26VRXuv5WNM+bEAFAZCWEbzGhgLwtomr24hAMR/wI3LsouxmQP7b29PeV9k
        ciom3+pReSXJVNyaqQ6jWNt3DAqCpwqI7rxm/BcY9fCio4C7ARC1DdhtnLXtiszQqf1E7ptVj11vp
        p/h+HS6Kpjd15aYkpEBOvo6HqOuAS4yHEV/qkdsLgUMOrpB+ISEtb+g+ybG/0+soafWvRQvlt7sGQ
        /777paRjT4iJWa+pUZQhdV8QKYuNhLAl5p+oDgg3BCV20xxdtuPd06horZlqvWeDHKsX6KeN4Yrhx
        H6Sp622A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35680)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1p4jjp-0005iV-Qa; Mon, 12 Dec 2022 14:25:01 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1p4jjn-0005Za-Hl; Mon, 12 Dec 2022 14:24:59 +0000
Date:   Mon, 12 Dec 2022 14:24:59 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Claudiu.Beznea@microchip.com
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, hkallweit1@gmail.com, Sergiu.Moga@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Message-ID: <Y5c5uzpee1jrwWgz@shell.armlinux.org.uk>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
 <20221212112845.73290-2-claudiu.beznea@microchip.com>
 <Y5cizXwsEnJ3fX0y@shell.armlinux.org.uk>
 <b2f0994c-432f-9ac8-485e-ac9388619674@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2f0994c-432f-9ac8-485e-ac9388619674@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 01:26:54PM +0000, Claudiu.Beznea@microchip.com wrote:
> On 12.12.2022 14:47, Russell King (Oracle) wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Mon, Dec 12, 2022 at 01:28:44PM +0200, Claudiu Beznea wrote:
> >> There are scenarios where PHY power is cut off on system suspend.
> >> There are also MAC drivers which handles themselves the PHY on
> >> suspend/resume path. For such drivers the
> >> struct phy_device::mac_managed_phy is set to true and thus the
> >> mdio_bus_phy_suspend()/mdio_bus_phy_resume() wouldn't do the
> >> proper PHY suspend/resume. For such scenarios call phy_init_hw()
> >> from phylink_resume().
> >>
> >> Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
> >> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> >> ---
> >>
> >> Hi, Russel,
> >>
> >> I let phy_init_hw() to execute for all devices. I can restrict it only
> >> for PHYs that has struct phy_device::mac_managed_phy = true.
> >>
> >> Please let me know what you think.
> > 
> > I think it would be better to only do this in the path where we call
> > phy_start() - if we do it in the WoL path (where the PHY remains
> > running), then there is no phy_start() call, so phy_init_hw() could
> > result in the PHY not working after a suspend/resume event.
> 
> This will not work all the time for MACB usage on AT91 devices.
> 
> As explained here [1] the scenario where:
> - MACB is configured to handle WoL
> - the system goes to a suspend mode (named backup and self-refresh (BSR) in
>   our case) with power cut off on PHY and limited wake-up source (few pins
>   and RTC alarms)
> 
> is still valid. In this case MAC IP and MAC PHY are not powered. And in
> those cases phylink_resume() will not hit phy_start().

If the MAC is handling WoL, how does the MAC receive the packet to
wake up if the PHY has lost power?

If the PHY loses power, the MAC won't be able to receive the magic
packet, and so WoL will be non-functional, and therefore will be
completely pointless to support in such a configuration.

What am I missing?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
