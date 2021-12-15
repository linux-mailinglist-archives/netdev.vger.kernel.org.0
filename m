Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18ECC475057
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhLOBMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhLOBMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 20:12:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B94DC061574;
        Tue, 14 Dec 2021 17:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I9E4+ZKe69WmCybnXNkkbnAbPC5UKQx+gK5B9WYgX94=; b=UsLn/WYA2UFvlVuXcC+erSOcOK
        DwVaQYkU0dISQYsJIqI0wy2b+nZzWmsOI1e0CZ2lVA7IjdjNG+UD7Kwv6ryH41/w0a/rmtaBaDek+
        Qi8BCsOKOKjJSAAe5AtnC2EZ4Q3HkERYwSyIvKiRld95UuYHMjb4lcGKKCRQugR6i7MIW1eEuui50
        59ZxZNKoDZCKUhDVt2jLuf8JXU/AKGfSxiOaj4BOGiyXuMpK7w04EO+OAIQ2BKoJ6wzq+oAhQSm7a
        rjx6LYTMvU55EAZ/iXF1otpuLMwRWUa2/gMRJ1S/cpIIrvUE5WS57wA7cwTMF+6Hh80cv5e+5KGxW
        c6Qi1rpQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56296)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mxIpu-0005ed-Hz; Wed, 15 Dec 2021 01:12:02 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mxIps-00040X-Ig; Wed, 15 Dec 2021 01:12:00 +0000
Date:   Wed, 15 Dec 2021 01:12:00 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phylink: Pass state to pcs_config
Message-ID: <YblA4E/InIAa0U1U@shell.armlinux.org.uk>
References: <20211214233450.1488736-1-sean.anderson@seco.com>
 <YbkshnqgXP7Gd188@shell.armlinux.org.uk>
 <de1f7214-58c8-cdc6-1d29-08c979ce68f1@seco.com>
 <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ybk7iuxdin69MjTo@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 12:49:14AM +0000, Russell King (Oracle) wrote:
> On Tue, Dec 14, 2021 at 07:16:53PM -0500, Sean Anderson wrote:
> > Ok, so let me clarify my understanding. Perhaps this can be eliminated
> > through a different approach.
> > 
> > When I read the datasheet for mvneta (which hopefully has the same
> > logic here, since I could not find a datasheet for an mvpp2 device), I
> > noticed that the Pause_Adv bit said
> > 
> > > It is valid only if flow control mode is defined by Auto-Negotiation
> > > (as defined by the <AnFcEn> bit).
> > 
> > Which I interpreted to mean that if AnFcEn was clear, then no flow
> > control was advertised. But perhaps it instead means that the logic is
> > something like
> > 
> > if (AnFcEn)
> > 	Config_Reg.PAUSE = Pause_Adv;
> > else
> > 	Config_Reg.PAUSE = SetFcEn;
> > 
> > which would mean that we can just clear AnFcEn in link_up if the
> > autonegotiated pause settings are different from the configured pause
> > settings.
> 
> Having actually played with this hardware quite a bit and observed what
> it sends, what it implements for advertising is:
> 
> 	Config_Reg.PAUSE = Pause_Adv;
> 
> Config_Reg gets sent over the 1000BASE-X link to the link partner, and
> we receive Remote_Reg from the link partner.
> 
> Then, the hardware implements:
> 
> 	if (AnFcEn)
> 		MAC_PAUSE = Config_Reg.PAUSE & Remote_Reg.PAUSE;
> 	else
> 		MAC_PAUSE = SetFcEn;
> 
> In otherwords, AnFcEn controls whether the result of autonegotiation
> or the value of SetFcEn controls whether the MAC enables symmetric
> pause mode.

I should also note that in the Port Status register,

	TxFcEn = RxFcEn = MAC_PAUSE;

So, the status register bits follow SetFcEn when AnFcEn is disabled.

However, these bits are the only way to report the result of the
negotiation, which is why we use them to report back whether flow
control was enabled in mvneta_pcs_get_state(). These bits will be
ignored by phylink when ethtool -A has disabled pause negotiation,
and in that situation there is no way as I said to be able to read
the negotiation result.

permit_pause_to_mac exists precisely because of the limitions of this
hardware, and having it costs virtually nothing to other network
drivers... except a parameter that others ignore.

If we don't have permit_pause_to_mac in pcs_config() then we need to
have it passed to the link_up() methods instead. There is no other
option (other than breaking mvneta and mvpp2) here than to make the
state of ethtool -A ... autoneg on|off known to the hardware.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
