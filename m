Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38B43522CC
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 00:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbhDAWeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 18:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234512AbhDAWeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 18:34:03 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F97C0613E6
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 15:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VR0sBKDYY/m8iysmz2ROoY+QTgByWjbRlP5JMg7eF0w=; b=cky3M7uj/HtFiKtkc2ra2OWNr
        OKsnugXl6fuQRkVfoRyFLVPzS0Ornj83Aep86sA5C2u5q4qeXWpI0aUucmklHwaSKNS7FEfFXG2Pt
        YIpGfMQShhxiKvW7Sqmn2mLfLoIx7MUY80Iju+GUG8Mmnrbtx0IutjbG3HOAf3h66L0xNnwKWpFfh
        +GbspFDSKyqw5f/Pk/V6k7e1uyR1WUd6YWeei/Mfq0R/AcZ4lZVyR7HiCooQb5CNwpJhWyILnUtOz
        Bz0Byx8RVfNIzIWzumrA1WK5lS65+ueQ2IMX/xX+/2mzoVN88dNa/ftmRp5GpTopfof+KEEwyHtJK
        STZhLbV8Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:52018)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lS5sy-0003wf-9g; Thu, 01 Apr 2021 23:33:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lS5sx-0005FC-I3; Thu, 01 Apr 2021 23:33:55 +0100
Date:   Thu, 1 Apr 2021 23:33:55 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: net: phylink: phylink_helper_basex_speed issues with 1000base-x
Message-ID: <20210401223355.GA1463@shell.armlinux.org.uk>
References: <CAFSKS=O+BCZeLD92ZT5SvkWCgCLsQ2rN9gPmVY_35PCVBqyZuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=O+BCZeLD92ZT5SvkWCgCLsQ2rN9gPmVY_35PCVBqyZuA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I hadn't responded earlier because I wanted to think about it more,
but then forgot about this email.

On Thu, Mar 25, 2021 at 11:36:26AM -0500, George McCollister wrote:
> When I set port 9 on an mv88e6390, a cpu facing port to use 1000base-x
> (it also supports 2500base-x) in device-tree I find that
> phylink_helper_basex_speed() changes interface to
> PHY_INTERFACE_MODE_2500BASEX.

If both 2500base-X and 1000base-X are reported as being advertised,
then yes, it will. This is to support SFPs that can operate in either
mode. The key thing here is that both speeds are being advertised
and we're in either 2500base-X or 1000base-X mode.

This gives userspace a way to switch between those two supported modes
on the SFP.

> The Ethernet adapter connecting to this
> switch port doesn't support 2500BASEX so it never establishes a link.

You mean the remote side only supports 1000base-X?

> If I hack up the code to force PHY_INTERFACE_MODE_1000BASEX it works
> fine.
> 
> state->an_enabled is true when phylink_helper_basex_speed() is called
> even when configured with fixed-link. This causes it to change the
> interface to PHY_INTERFACE_MODE_2500BASEX if 2500BaseX_Full is in
> state->advertising which it always is on the first call because
> phylink_create calls bitmap_fill(pl->supported,
> __ETHTOOL_LINK_MODE_MASK_NBITS) beforehand. Should state->an_enabled
> be true with MLO_AN_FIXED?

Historically, it has been (by the original fixed-phy implementation)
and I don't wish to change that as that would be a user-visible
change. Turning off state->an_enabled will make the interface depend
on state->speed instead.

> I've also noticed that phylink_validate (which ends up calling
> phylink_helper_basex_speed) is called before phylink_parse_mode in
> phylink_create. If phylink_helper_basex_speed changes the interface
> mode this influences whether phylink_parse_mode (for MLO_AN_INBAND)
> sets 1000baseX_Full or 2500baseX_Full in pl->supported (which is then
> copied to pl->advertising). phylink_helper_basex_speed is then called
> again (via phylink_validate) which uses advertising to decide how to
> set interface. This seems like circular logic.

I'm wondering if we should postpone the initial call to
phylink_validate() to just before the "pl->cur_link_an_mode =
pl->cfg_link_an_mode;" in there, and only if we're still in MLO_AN_PHY
mode - it will already have been called via the other methods. Would
that help to solve the problem?

> To make matters even more confusing I see that
> mv88e6xxx_serdes_dcs_get_state uses state->interface to decide whether
> to set state->speed to SPEED_1000 or SPEED_2500.

There is no real report from the hardware to indicate the speed -
2500base-X looks like 1000base-X except for the different interface
mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
