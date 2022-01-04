Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7699F4843F9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 15:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbiADO5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 09:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232974AbiADO5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 09:57:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD89C061761;
        Tue,  4 Jan 2022 06:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9iomVx+1dyKtO7ifnBatBp+MkPLAfaNf9PXQTH5ZKCY=; b=nxjXLUm7MZFDMTTOTD6d+X1Hwr
        trz/TxODNHcJNtM+lPi8f+nH7vupO5XHq6g06NoQthBjMkmnhSZDjORFDLEEJfHgMCS9cSXtQNgAP
        I/ZNHdgtcQezgNn020+ZkaXETw1jI1wlBeZCMfPZ0rmcDXZOKYThW1xlcpv5OkB/r8jiDOe//eq7y
        nlQz6HgpIVC4abrDJHNggJGLPcMNKpfC8y+RXAyGPdOi967G4V1xZ1WznRviu5jkGhaUiIAguwwr/
        PYT0+BSbQwSIlyxg6iBng71FK621/j/ckdgqy0Re1gV5XsV/3JLU0Err+Un+fHn+GccVAkPnq17Eu
        x4TPzH2A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56566)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1n4lFm-00077c-IE; Tue, 04 Jan 2022 14:57:34 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1n4lFl-0007KF-4Y; Tue, 04 Jan 2022 14:57:33 +0000
Date:   Tue, 4 Jan 2022 14:57:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        linus.walleij@linaro.org, ulli.kroll@googlemail.com,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: net: phy: marvell: network working with generic PHY and not with
 marvell PHY
Message-ID: <YdRgXbpK6CFB/eCU@shell.armlinux.org.uk>
References: <YdQoOSXS98+Af1wO@Red>
 <YdQsJnfqjaFrtC0m@shell.armlinux.org.uk>
 <YdQwexJVfrdzEfZK@Red>
 <YdQydK4GhI0P5RYL@shell.armlinux.org.uk>
 <YdQ5i+//UITSbxS/@shell.armlinux.org.uk>
 <YdRVovG9mgEWffkn@Red>
 <YdRZQl6U0y19P/0+@shell.armlinux.org.uk>
 <YdRdu3jFPnGd1DsH@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdRdu3jFPnGd1DsH@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 03:46:19PM +0100, Andrew Lunn wrote:
> > @@ -1227,16 +1227,18 @@ static int m88e1118_config_init(struct phy_device *phydev)
> >  {
> >  	int err;
> >  
> > -	/* Change address */
> > -	err = marvell_set_page(phydev, MII_MARVELL_MSCR_PAGE);
> > -	if (err < 0)
> > -		return err;
> > -
> >  	/* Enable 1000 Mbit */
> > -	err = phy_write(phydev, 0x15, 0x1070);
> > +	err = phy_write_paged(phydev, MII_MARVELL_MSCR_PAGE,
> > +			      MII_88E1121_PHY_MSCR_REG, 0x1070);
> 
> Ah, yes, keeping this makes it more backwards compatible.
> 
> It would be nice to replace the 0x1070 with #defines.
> 
> We already have:
> 
> #define MII_88E1121_PHY_MSCR_RX_DELAY	BIT(5)
> #define MII_88E1121_PHY_MSCR_TX_DELAY	BIT(4)
> #define MII_88E1121_PHY_MSCR_DELAY_MASK	(BIT(5) | BIT(4))
> 
> Bits 6 is the MSB of the default MAC speed.
> Bit 13 is the LSB of the default MAC speed. These two should default to 10b = 1000Mbps
> Bit 12 is reserved, and should be written 1.

Hmm, seems odd that these speed bits match BMCR, and I'm not sure why
the default MAC speed would have any bearing on whether gigabit mode
is enabled. If they default to 10b, then the write should have no effect
unless boot firmware has changed them.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
