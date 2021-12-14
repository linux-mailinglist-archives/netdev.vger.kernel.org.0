Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13DF474B89
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 20:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbhLNTJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 14:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbhLNTJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 14:09:15 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FF7C061574;
        Tue, 14 Dec 2021 11:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HKcArdlqNmLGeqSCDGvu48lUwNGbHVSawdH0aTcC0AU=; b=dMZV5K9SF5HblZef+Gw57T6LAx
        ERILAH8wF0ZrN7y2PQj5y6Md1AsxOnAEm5PPvWZJt75lSDnoTpZr3Wp2T91zrEA7mAfss1mej8XrL
        yxomPzytG3jgZZh3Tr2ewuDxC2BVQFqs2lffwp/wTnAfEwIxIUtd2dAXF+xYD3OYHEveb7vXAmyAK
        BO9giHuzHzNmd9mo/g5fmMvTvQN/161CqoL0zhQIOgAyAtqtvNxKAeJch4iw4XQfjJCTdwNTJz4n1
        yEmLtlp+fCEN3uLvQQXcRJmT7FSw/f5QEs32rIA4mvUJIFmAOmzwGuMbiQMjjfqBJ9yUNAS/GwmPL
        pzvg+t/g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56282)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxDAm-0005Md-2j; Tue, 14 Dec 2021 19:09:12 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxDAk-0003jN-4e; Tue, 14 Dec 2021 19:09:10 +0000
Date:   Tue, 14 Dec 2021 19:09:10 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Philippe Schenker <philippe.schenker@toradex.com>,
        netdev@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <Ybjr1isMQBXfoo0S@shell.armlinux.org.uk>
References: <20211214121638.138784-1-philippe.schenker@toradex.com>
 <20211214121638.138784-4-philippe.schenker@toradex.com>
 <YbjofqEBIjonjIgg@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbjofqEBIjonjIgg@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 07:54:54PM +0100, Andrew Lunn wrote:
> On Tue, Dec 14, 2021 at 01:16:38PM +0100, Philippe Schenker wrote:
> > Reset the eth PHY after resume in case the power was switched off
> > during suspend, this is required by some PHYs if the reset signal
> > is controlled by software.
> > 
> > Signed-off-by: Philippe Schenker <philippe.schenker@toradex.com>
> > 
> > ---
> > 
> >  drivers/net/ethernet/freescale/fec_main.c | 1 +
> 
> Hi Philippe
> 
> What i don't particularly like about this is that the MAC driver is
> doing it. Meaning if this PHY is used with any other MAC, the same
> code needs adding there.
> 
> Is there a way we can put this into phylib? Maybe as part of
> phy_init_hw()? Humm, actually, thinking aloud:
> 
> int phy_init_hw(struct phy_device *phydev)
> {
> 	int ret = 0;
> 
> 	/* Deassert the reset signal */
> 	phy_device_reset(phydev, 0);
> 
> So maybe in the phy driver, add a suspend handler, which asserts the
> reset. This call here will take it out of reset, so applying the reset
> you need?

It seems to be a combination issue - it's the fact that the power is
turned off and the fact that the reset needs to be applied.

If other PHYs such as AR8035 are subjected to this, they appear to
have a requirement that reset is asserted when power is applied and
kept asserted until the clock has stabilised and a certain time has
elapsed.

As I've already highlighted, we do not want to be asserting the reset
signal in phy_init_hw() - doing so would mean that any PHY with a GPIO
reset gets reset whenever the PHY is connected to the MAC - which can
be whenever the interface is brought up. That will introduce a multi-
second delay to bringing up the network.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
