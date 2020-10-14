Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BB028EA6B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732292AbgJOBoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgJOBoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:44:39 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6A3C0613BA;
        Wed, 14 Oct 2020 15:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0FxTNdngmHjbzYmOaTXRcwIxitXLFYA0qYly0TUim/4=; b=FIHsdi7514k2rRygFUD+97UX6
        eEwWJzcasY2TOYRv40Fio63lkgI3eF9HsPqPefXqnh1fFbLbUXh+vWUdWWq8iSMBaPcS1LMOMCjp/
        ywQdD7+nbYIQIgyxgL203RbZgketwPBunHG+Esv9qioOENl9D01/CHP8G/DwaEoO9eb+soSqCHhnm
        7gHxdMJMeOtp6ArbcYhjxOtIhNOaNy2g6vVT4h5tKxfZSzItUqNxrSTQYzSeCAlz7Ygph7uCZAnca
        IeUHwCGVw0j6nQETjpW2f3/JrFrRVyf9Y5LoA/M5bIRqHqgdQYpwZ1KjQvxL5eDGEb91fPZggawff
        g6uewS5mQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46050)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kSosv-0007iE-Ne; Wed, 14 Oct 2020 23:04:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kSoss-0007y3-GJ; Wed, 14 Oct 2020 23:04:34 +0100
Date:   Wed, 14 Oct 2020 23:04:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] net: phy: Prevent reporting advertised modes when
 autoneg is off
Message-ID: <20201014220434.GR1551@shell.armlinux.org.uk>
References: <20201014133211.GQ1551@shell.armlinux.org.uk>
 <CGME20201014144018eucas1p101424a57f5bf63eabb3dc24177551dff@eucas1p1.samsung.com>
 <dleftjpn5k7txo.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dleftjpn5k7txo.fsf%l.stelmach@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 04:39:47PM +0200, Lukasz Stelmach wrote:
> It was <2020-10-14 śro 14:32>, when Russell King - ARM Linux admin wrote:
> > In any case, the mii.c code does fill in the advertising mask even
> > when autoneg is disabled, because, rightly or wrongly, the advertising
> > mask contains more than just the link modes, it includes the
> > interface(s) as well. Your change means phylib no longer reports the
> > interface modes which is at odds with the mii.c code.
> 
> I am afraid you are wrong. There is a rather big if()[1], which
> depending on AN beeing enabled fills more or less information. Yes this
> if() looks like it has been yanked from mii_ethtool_gset(). When
> advertising is converted and copied to cmd->link_modes.advertising at
> the end of mii_ethtool_get_link_ksettings() it is 0[2] if autonegotiation
> is disabled.
> 
> [1] https://elixir.bootlin.com/linux/v5.9/source/drivers/net/mii.c#L174
> [2] https://elixir.bootlin.com/linux/v5.9/source/drivers/net/mii.c#L215

I'm very sorry, but I have to disagree.  I'll quote the code here:

        advertising = ADVERTISED_TP | ADVERTISED_MII;

	// This is your big if()
        if (bmcr & BMCR_ANENABLE) {
		advertising |= ADVERTISED_Autoneg;
		...
	} else {
		...
	}

	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.advertising,
	                                        advertising);

So, when AN is disabled, we still end up with TP and MII in the
advertised link modes. I call TP and MII "interface modes" above
to separate them from the "link modes" that describe the speed and
duplex etc.

Note that only lp_advertising is zeroed in the "else" clause of
the above "if" statement - advertising remains as-is with TP and MII
set.

Your patch, on the other hand, merely avoids setting anything in
cmd->link_modes.advertising, which means we do not end up with the
"interface modes".

I hope that this helps you see my point.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
