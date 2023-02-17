Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3228069AC95
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 14:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBQNeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 08:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjBQNeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 08:34:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B6D64B1E;
        Fri, 17 Feb 2023 05:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ikbW0Bsi9WZ7KW3vQlLCZJgec8Rw2Xt4ZVVY/IIXRrY=; b=G4Rm8/+RCmv0vrkyz+oSYKXK4v
        TE0WDWIad2OInraypw6dVLes6c09tfjgy8YZDYH04PKGXntpwVsb4kCkriAGmQwDh/I+gYBKoGoQf
        OM8WaIz/seykK270U2Zod1K8ToMRNO5yUeGbK7fyF7U+X01+5Cd1sJdXIe5ha4X7sft3akQih/3fs
        XeJS/IKSuyITu69Umpn8NfqEYMKg3vTG0Wk0GHlNZtWgpCiL0SwQh96Hy+zgPMzm6CqoMDddeLp3F
        nf0X02/JGjDrRyXJ9kdLDxTMknrEys8Y/gsfNMVahSd4+ZZ2CQZvQeD56AJDK9gnnZ1GcjxB7Ncj6
        P200t2YA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39092)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pT0ru-00010s-Ot; Fri, 17 Feb 2023 13:33:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pT0ru-0006qE-4e; Fri, 17 Feb 2023 13:33:42 +0000
Date:   Fri, 17 Feb 2023 13:33:42 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_PEROUT
 for lan8841
Message-ID: <Y++CNk2Pv3aGYzLa@shell.armlinux.org.uk>
References: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
 <Y++BXkdXO8oysQ8M@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y++BXkdXO8oysQ8M@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 01:30:06PM +0000, Russell King (Oracle) wrote:
> On Fri, Feb 17, 2023 at 08:52:13AM +0100, Horatiu Vultur wrote:
> > +static void lan8841_ptp_perout_off(struct kszphy_ptp_priv *ptp_priv, int pin)
> > +{
> > +	struct phy_device *phydev = ptp_priv->phydev;
> > +	u16 tmp;
> > +
> > +	tmp = phy_read_mmd(phydev, 2, LAN8841_GPIO_EN) & LAN8841_PTP_GPIO_MASK;
> > +	tmp &= ~BIT(pin);
> > +	phy_write_mmd(phydev, 2, LAN8841_GPIO_EN, tmp);
> 
> Problem 1: doesn't check the return value of phy_read_mmd(), so a
> spurious error results in an error code written back to the register.
> 
> Issue 2: please use phy_modify_mmd() and definitions for the MMD. It
> probably also makes sense to cache the mask. Thus, this whole thing
> becomes:
> 
> 	u16 mask = ~(LAN8841_PTP_GPIO_MASK | BIT(pin));
> 
> 	phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_EN, mask, 0);
> 	phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_DIR, mask, 0);
> 	phy_modify_mmd(phydev, MDIO_MMD_WIS, LAN8841_GPIO_BUF, mask, 0);
> 
> although I'm not sure why you need to mask off bits 15:11.

Or even use phy_clear_bits_mmd(). There's also phy_set_bits_mmd() which I
think would also be useful elsewhere in this driver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
