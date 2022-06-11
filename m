Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE205477E8
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 01:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiFKXVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 19:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFKXVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 19:21:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064DE40927
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 16:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OgNSZfp/DOCClZiOWSwf+Uj0eHw2qFY0qZvyFRoqdD8=; b=qRyRRMNgKvG1JmqMeaBDbZj6r3
        HyPbLdd4pxF/X4vQpbDRtSxm5T0tC331UI8u5OU8lYdfn/tzzTUKTeyJJvB4/UL0/k6EiOVxy2KBK
        POsOzzvLuDiMp1cJMLyOUm1rUMgdsbb89xfiZ+4nbMmigNfV03epJfYmrg9833RD7A9M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o0APR-006YeZ-Q1; Sun, 12 Jun 2022 01:20:49 +0200
Date:   Sun, 12 Jun 2022 01:20:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ondrej Spacek <ondrej.spacek@nxp.com>
Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G
 are not advertised
Message-ID: <YqUjUQLOHUo55egO@lunn.ch>
References: <20220610084037.7625-1-claudiu.manoil@nxp.com>
 <YqSt5Rysq110xpA3@lunn.ch>
 <AM9PR04MB8397DF04A87E32E6B7E690E096A99@AM9PR04MB8397.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM9PR04MB8397DF04A87E32E6B7E690E096A99@AM9PR04MB8397.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 06:13:12PM +0000, Claudiu Manoil wrote:
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Saturday, June 11, 2022 6:00 PM
> [...]
> > Subject: Re: [PATCH, net] phy: aquantia: Fix AN when higher speeds than 1G are
> > not advertised
> > 
> > On Fri, Jun 10, 2022 at 11:40:37AM +0300, Claudiu Manoil wrote:
> > > Even when the eth port is resticted to work with speeds not higher than 1G,
> > > and so the eth driver is requesting the phy (via phylink) to advertise up
> > > to 1000BASET support, the aquantia phy device is still advertising for 2.5G
> > > and 5G speeds.
> > > Clear these advertising defaults when requested.
> > 
> > Hi Claudiu
> > 
> > genphy_c45_an_config_aneg(phydev) is called in aqr_config_aneg, which
> > should set/clear MDIO_AN_10GBT_CTRL_ADV5G and
> > MDIO_AN_10GBT_CTRL_ADV2_5G. Does the aQuantia PHY not have these bits?
> > 
> 
> Hi Andrew,
> 
> Apparently it's not enough to clear the 7.20h register (aka MDIO_AN_10GBT_CTRL)
> to stop AQR advertising for higher speeds, otherwise I wouldn't have bothered with
> the patch.

I'm just trying to ensure we are not papering over a crack. I wanted
to eliminate the possibility of a bug in that code which is changing
7.20h. If the datasheet for the aquantia states those bits are not
used, then this patch is fine. If on the other hand the datasheet says
7.20 can be used to change the advertisement, we should investigate
further what is really going on.

	Andrew
