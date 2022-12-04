Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511BC641E89
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 19:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLDSB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 13:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiLDSBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 13:01:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A831E6;
        Sun,  4 Dec 2022 10:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hxaIyiMKkKRAft5XVZyqxqDaRSGY1h1I1Orv3yrm3ZM=; b=PMPRw/D3ghY75mSPCatMu9WvHV
        oo7r8yQxvM9Ku1DuQCoY/kKat9UXhMwh8rgI3XeTXIAZSdGK6LWjnPotDLjzMfbY/+66zdJLDZi3U
        ngfYMvrUgn608+o45FQ97yxByBnWopxwPXzbyvO3APDPiHQ+C+Wy1/gfElB/+Rf2N7wo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1tI6-004KnR-I9; Sun, 04 Dec 2022 19:00:38 +0100
Date:   Sun, 4 Dec 2022 19:00:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH net-next 3/4] drivers/net/phy: Add driver for the onsemi
 NCN26000 10BASE-T1S PHY
Message-ID: <Y4zgRthpe3ZtBC0x@lunn.ch>
References: <cover.1670119328.git.piergiorgio.beruto@gmail.com>
 <834be48779804c338f00f03002f31658d942546b.1670119328.git.piergiorgio.beruto@gmail.com>
 <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4zQNHEkWQG+C/Oj@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Sun, Dec 04, 2022 at 03:31:33AM +0100, Piergiorgio Beruto wrote:
> > +static irqreturn_t ncn26000_handle_interrupt(struct phy_device *phydev)
> > +{
> > +	const struct ncn26000_priv *const priv = phydev->priv;
> > +	u16 events;
> > +	int ret;
> > +
> > +	// read and aknowledge the IRQ status register
> > +	ret = phy_read(phydev, NCN26000_REG_IRQ_STATUS);
> > +
> > +	if (unlikely(ret < 0))
> > +		return IRQ_NONE;
> > +
> > +	events = (u16)ret & priv->enabled_irqs;
> > +	if (events == 0)
> > +		return IRQ_NONE;
> > +
> > +	if (events & NCN26000_IRQ_LINKST_BIT) {
> > +		ret = phy_read(phydev, MII_BMSR);
> > +
> > +		if (unlikely(ret < 0)) {
> > +			phydev_err(phydev,
> > +				   "error reading the status register (%d)\n",
> > +				   ret);
> > +
> > +			return IRQ_NONE;
> > +		}
> > +
> > +		phydev->link = ((u16)ret & BMSR_ANEGCOMPLETE) ? 1 : 0;

Hi Piergiorgio

Interrupt handling in PHY don't follow the usual model. Historically,
PHYs were always polled once per second. The read_status() function
gets called to report the current status of the PHY. Interrupt are
just used to indicate that poll should happen now. All the handler
needs to do is clear the interrupt line so it can be safely reenabled
and not cause an interrupt storm, and call phy_trigger_machine() to
trigger the poll.

	Andrew
