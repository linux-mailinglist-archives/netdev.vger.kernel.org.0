Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3729457890D
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 19:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbiGRR6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 13:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiGRR6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 13:58:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31302E9E0;
        Mon, 18 Jul 2022 10:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zpo1xKARAj4YjTqhzcM02aL81PyrB0bMoUtswoGp3Jc=; b=HewTvCxiTT2Zudeh2AGwOJYXIR
        jXKTHKhV5iS7AH/v3s0hp9W5m1uk35aDZdAYunaAQ8IEV5cxzCv1pAnowQbwBjhWDZkPJT11S6S8y
        ORp1hBIFKuhjg66s57MaPVrfE2T2EZKsdluovpnKMYfqrTrxm28cR262QJ3ry7ubtcr1m/1o/lDXq
        /rOCdql/F5JtGFdyq1/fnU/a1wIPscGiSa8N3qWXtNbPrXX+tQFVdVsJ81SsP0Mq3vzL9fv2DWyjr
        k6IC9HorBbFukMYvisYABFmfGom9sv75LSrrf1TlXuMOFAjhDCRfL4CXdhnHl6o6cY0NiRg7V+jp7
        wbSlZDog==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33424)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDV0U-0001wY-7E; Mon, 18 Jul 2022 18:58:10 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDV0S-00029Z-7h; Mon, 18 Jul 2022 18:58:08 +0100
Date:   Mon, 18 Jul 2022 18:58:08 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
Message-ID: <YtWfMGh39sFPtHJ7@shell.armlinux.org.uk>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
 <YtWGZ4ZJ6rmLmlWk@shell.armlinux.org.uk>
 <9a968425-5621-09b9-febe-2086d5492c96@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a968425-5621-09b9-febe-2086d5492c96@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:45:01PM -0400, Sean Anderson wrote:
> 
> 
> On 7/18/22 12:12 PM, Russell King (Oracle) wrote:
> > On Fri, Jul 15, 2022 at 05:59:17PM -0400, Sean Anderson wrote:
> >> If the phy is configured to use pause-based rate adaptation, ensure that
> >> the link is full duplex with pause frame reception enabled. Note that these
> >> settings may be overridden by ethtool.
> >> 
> >> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> >> ---
> >> 
> >> Changes in v3:
> >> - New
> >> 
> >>  drivers/net/phy/phylink.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> >> index 7fa21941878e..7f65413aa778 100644
> >> --- a/drivers/net/phy/phylink.c
> >> +++ b/drivers/net/phy/phylink.c
> >> @@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
> >>  	pl->phy_state.speed = phy_interface_speed(phydev->interface,
> >>  						  phydev->speed);
> >>  	pl->phy_state.duplex = phydev->duplex;
> >> +	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
> >> +		pl->phy_state.duplex = DUPLEX_FULL;
> 
> Just form context, as discussed with Andrew, this should never change
> anything. That is, it could be replaced with
> 
> WARN_ON_ONCE(pl->phy_state.duplex != DUPLEX_FULL);
> 
> Since the phy should never report that it is using rate_adaptation
> unless it is using full duplex.

The "rate adaption" thing tends not to be a result of negotiation with
the link partner, but more a configuration issue. At least that is the
case with 88x3310 PHYs. There is no mention of any kind of restriction
on duplex when operating in rate adaption mode (whether it's the MACSEC
version that can generate pause frames, or the non-MACSEC that can't.)

> >> +		rx_pause = true;
> >> +	}
> > 
> > I really don't like this - as I've pointed out in my previous email, the
> > reporting in the kernel message log for "Link is Up" will be incorrect
> > if you force the phy_state here like this. If the media side link has
> > been negotiated to be half duplex, we should state that in the "Link is
> > Up" message.
> 
> So I guess the question here is whether there are phys which do duplex
> adaptation. There definitely are phys which support a half-duplex
> interface mode and a full duplex link mode (such as discussed in patch 08/47).
> If it's important to get this right, I can do the same treatment for duplex
> as I did for speed.

I guess it's something we don't know.

The sensible thing is not to add a WARN_ON() for the case, but to
restrict the PHY advertisement so the half-duplex case can't happen if
the host link is operating in a mode that requires rate adaption to
gain the other speeds.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
