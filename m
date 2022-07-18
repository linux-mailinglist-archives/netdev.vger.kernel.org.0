Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5936F578716
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiGRQOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbiGRQOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:14:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326C36313;
        Mon, 18 Jul 2022 09:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nX3RsnGi2cfh0LOSF81ZLNZldnSaN6v4PcSbVisOW24=; b=Yq+Zwwr/nrqv7G2bTjTM/Ek3fB
        +oDapSLdDJJQ6wYDpxLHzEu/nddwCTK/Z3ISy+e1Q/r1enEhtAWTeTFTGeWBRqLw6L2tYMg29cWjT
        FW6Ibt6fmJ+QIzvBJxfgJhspRor80SaJIAcyPx5HDYdPsVH6CCmrF60qXFv7HMEBbzypVi156Esez
        FrKqLB8o5M/fopJxIuzZWe5+Blylr5x7UBaKjMmMVegNqX90BColsrshxF+MHpbQtwOfVJZg3ZN9A
        lHoP8ytZ7hiHZgeREp+mia+xOGEbZePkpYahqHK8gzAY6dwDUVgTgiJxyNNfUeM3GkmwrruaQDfwL
        ZCTPIgfQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33420)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oDTOM-0001oa-Sn; Mon, 18 Jul 2022 17:14:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oDTOM-000267-6x; Mon, 18 Jul 2022 17:14:42 +0100
Date:   Mon, 18 Jul 2022 17:14:42 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
Message-ID: <YtWG8p/EFRk+punM@shell.armlinux.org.uk>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
 <YtMc2qYWKRn2PxRY@lunn.ch>
 <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 16, 2022 at 06:37:22PM -0400, Sean Anderson wrote:
> On 7/16/22 4:17 PM, Andrew Lunn wrote:
> > On Fri, Jul 15, 2022 at 05:59:17PM -0400, Sean Anderson wrote:
> > > If the phy is configured to use pause-based rate adaptation, ensure that
> > > the link is full duplex with pause frame reception enabled. Note that these
> > > settings may be overridden by ethtool.
> > > 
> > > Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> > > ---
> > > 
> > > Changes in v3:
> > > - New
> > > 
> > >   drivers/net/phy/phylink.c | 4 ++++
> > >   1 file changed, 4 insertions(+)
> > > 
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index 7fa21941878e..7f65413aa778 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
> > >   	pl->phy_state.speed = phy_interface_speed(phydev->interface,
> > >   						  phydev->speed);
> > >   	pl->phy_state.duplex = phydev->duplex;
> > > +	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
> > > +		pl->phy_state.duplex = DUPLEX_FULL;
> > > +		rx_pause = true;
> > > +	}
> > 
> > I would not do this. If the requirements for rate adaptation are not
> > fulfilled, you should turn off rate adaptation.
> > 
> > A MAC which knows rate adaptation is going on can help out, by not
> > advertising 10Half, 100Half etc. Autoneg will then fail for modes
> > where rate adaptation does not work.
> 
> OK, so maybe it is better to phylink_warn here. Something along the
> lines of "phy using pause-based rate adaptation, but duplex is %s".
> 
> > The MAC should also be declaring what sort of pause it supports, so
> > disable rate adaptation if it does not have async pause.
> 
> That's what we do in the previous patch.
> 
> The problem is that rx_pause and tx_pause are resolved based on our
> advertisement and the link partner's advertisement. However, the link
> partner may not support pause frames at all. In that case, we will get
> rx_pause and tx_pause as false. However, we still want to enable rx_pause,
> because we know that the phy will be emitting pause frames. And of course
> the user can always force disable pause frames anyway through ethtool.

If you want the MAC to enable rx_pause, that ought to be handled
separately in the mac_link_up() method, IMHO.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
