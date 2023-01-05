Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8AA865F3FB
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbjAESvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjAESvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:51:42 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DC24F129;
        Thu,  5 Jan 2023 10:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xZoCPWL4G58XUyUrPypVA5l0VufKdxJ9uwEK4mQPjx0=; b=MsQi/fZGIv3l1/HXCxnc14X1Am
        Y4UfYiFAd71fKtWVKaxmErVhwJTjxV7ZG4tRLn6WFckwjPzjnOwspK6ZZuj8lqUzn0ffzeviZY6fA
        aLYTt1SbLXk3vwZkVnQieOk/9FuwK3oEQXT3boJTV7nwJp7y40/fgspxekEDF6Iy8ZysTaOUBUDA4
        a8U7tuqg4cacIn74hPkadity60CUdAu76+GNs4cLLJBGveEORl80ji2h+2noPO8D2iSIm9wBEWoFC
        gT0cwcyB50ewjQD/4nzbU9DKa169AFUPcJ3xqzS6lK/ZA9O2Jl8tt/yOWgTVGhbBHqzSbgQcrg6Hv
        coFef62g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35984)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pDVKy-0007R3-Ci; Thu, 05 Jan 2023 18:51:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pDVKv-0004Co-F8; Thu, 05 Jan 2023 18:51:33 +0000
Date:   Thu, 5 Jan 2023 18:51:33 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <Y7ccNSSnPxTR2AQs@shell.armlinux.org.uk>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <Y7bhctPZoyNnw1ay@shell.armlinux.org.uk>
 <20230105174342.jldjjisgzs6dmcpd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105174342.jldjjisgzs6dmcpd@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 07:43:42PM +0200, Vladimir Oltean wrote:
> On Thu, Jan 05, 2023 at 02:40:50PM +0000, Russell King (Oracle) wrote:
> > > If the PHY firmware uses a combination like this: 10GBASE-R/XFI for
> > > media speeds of 10G, 5G, 2.5G (rate adapted), and SGMII for 1G, 100M
> > > and 10M, a call to your implementation of
> > > aqr107_get_rate_matching(PHY_INTERFACE_MODE_10GBASER) would return
> > > RATE_MATCH_NONE, right? So only ETHTOOL_LINK_MODE_10000baseT_Full_BIT
> > > would be advertised on the media side?
> > 
> > No, beause of the special condition in phylink that if it's a clause 45
> > PHY and we use something like 10GBASE-R, we don't limit to just 10G
> > speed, but try all interface modes - on the assumption that the PHY
> > will switch its host interface.
> > 
> > RATE_MATCH_NONE doesn't state anything about whether the PHY operates
> > in a single interface mode or not - with 10G PHYs (and thus clause 45
> > PHYs) it seems very common from current observations for
> > implementations to do this kind of host-interface switching.
> 
> So you mention commits
> 7642cc28fd37 ("net: phylink: fix PHY validation with rate adaption") and
> df3f57ac9605 ("net: phylink: extend clause 45 PHY validation workaround").
> 
> IIUC, these allow the advertised capabilities to be more than 10G (based
> on supported_interfaces), on the premise that it's possible for the PHY
> to switch SERDES protocol to achieve lower speeds.

I didn't mention any commits, but yes, it's ever since the second commit
you list above, which was necessary to get PHYs which switch their
interface mode to work sanely. It essentially allows everything that
the combination of host and PHY supports, because we couldn't do much
better at the time that commit was written.

> This does partly correct the last part of my question, but I believe
> that the essence of it still remains. We won't make use of PAUSE rate
> adaptation to support the speeds which aren't directly covered by the
> supported_interfaces. Aren't we interpreting the PHY provisioning somewhat
> too conservatively in this case, or do you believe that this is just an
> academic concern?

Do you have a better idea how to come up with a list of link modes that
the PHY should advertise to its link partner and also report as
supported given the combination of:

- PHYs that switch their host interface
- PHYs that may support some kind of rate adaption
- PCS/MACs that may support half-duplex at some speeds
- PCS/MACs that might support pause modes, and might support them only
  with certain interface modes

Layered on top of that is being able to determine which interface a PHY/
PCS/MAC should be using when e.g. a 10G copper PHY is inserted (which
could be inserted into a host which only supports up to 1G.)

I've spent considerable time trying to work out a solution to this, and
even before we had rate adaption, it isn't easy to solve. I've
experimented with several different solutions, and it's from numerous
trials that led to this host_interfaces/mac_capabilities structure -
but that still doesn't let us solve the problems I mention above since
we have no idea what the PHY itself is capable of, or how it's going to
behave, or really which interface modes it might switch between if it's
a clause 45 PHY.

I've experimented with adding phy->supported_interfaces so a phylib
driver can advertise what interfaces it supports. I've also
experimented with phy->possible_interfaces which reports the interface
modes that the PHY _is_ going to switch between having selected its
operating mode. I've not submitted them because even with this, it all
still seems rather inadequate - and there is a huge amount of work to
update all the phylib drivers to provide even that basic information,
let alone have much confidence that it is correct.

You can find these experiments, as normal, in my net-queue branch in
my git tree. These date from before we had rate adaption, so they take
no account of the recent addition of this extra variable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
