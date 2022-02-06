Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2A4AB138
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 19:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345858AbiBFS2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 13:28:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiBFS2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 13:28:23 -0500
X-Greylist: delayed 1582 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 10:28:21 PST
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160CFC06173B;
        Sun,  6 Feb 2022 10:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=/8tPNhnmKNqwNI2GwJ1u5pVwv907hfEX8rrGwiFxMM8=; b=dl
        XuCEYwo3gFWPQbeuANJDhxAM8CTKgrsz3WhXKSrLbI/5d9Yk3IoTKKc++vKZLa7X2pEZ1ivFIdH4a
        gRCAlhtGhvrgWkKYkdpn1pBI9tcCLi15RfDJ07hBFk/nIxUPNC1godBA++221YH4pFetZN5kXKtZJ
        6Yr0ZoVkg+U2jn8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nGlr3-004Wpn-KU; Sun, 06 Feb 2022 19:01:41 +0100
Date:   Sun, 6 Feb 2022 19:01:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raag Jadav <raagjadav@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <YgANBQjsrmK+T/N+@lunn.ch>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220206171234.GA5778@localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 06, 2022 at 10:42:34PM +0530, Raag Jadav wrote:
> On Sat, Feb 05, 2022 at 03:57:49PM +0100, Andrew Lunn wrote:
> > On Sat, Feb 05, 2022 at 12:14:52PM +0530, Raag Jadav wrote:
> > > Enable MAC SerDes autonegotiation to distinguish between
> > > 1000BASE-X, SGMII and QSGMII MAC.
> > 
> > How does autoneg help you here? It just tells you about duplex, pause
> > etc. It does not indicate 1000BaseX, SGMII etc. The PHY should be
> > using whatever mode it was passed in phydev->interface, which the MAC
> > sets when it calls the connection function. If the PHY dynamically
> > changes its host side mode as a result of what that line side is
> > doing, it should also change phydev->interface. However, as far as i
> > can see, the mscc does not do this.
> >
> 
> Once the PHY auto-negotiates parameters such as speed and duplex mode
> with its link partner over the copper link as per IEEE 802.3 Clause 27,
> the link partner’s capabilities are then transferred by PHY to MAC
> over 1000BASE-X or SGMII link using the auto-negotiation functionality
> defined in IEEE 802.3z Clause 37.

None of this allows you to distinguish between 1000BASE-X, SGMII and
QSGMII, which is what the commit message says.

It does allow you to get duplex, pause, and maybe speed via in band
signalling. But you should also be getting the same information out of
band, via the phylib callback.

There are some MACs which don't seem to work correctly without the in
band signalling, so maybe that is your problem? Please could you give
more background about your problem, what MAC and PHY combination are
you using, what problem you are seeing, etc.

    Andrew

