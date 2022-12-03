Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE40364191B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 21:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiLCUsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 15:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCUsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 15:48:01 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C457564E3;
        Sat,  3 Dec 2022 12:48:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nrIUiqu0rhHfNsiWFPaaq3UEuLRQT2XtfSlEcQWCe80=; b=AofCRjqnSYXZ8feR+kEmJkOUC2
        MZqTyRCe/KBWz+8IvZVZ6dP9aoc32d9xigxVoFXBUvYAM5W/tqxdMQ/Wg7ysLy9nBa63WByVgYLZn
        BtjSVsFqoOMwaBUNqIAEf14fT/gtqQn9eua1PyIk//lpbk6Hc0JuppW6HfrnwQMPNGLk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p1ZQE-004HrO-Th; Sat, 03 Dec 2022 21:47:42 +0100
Date:   Sat, 3 Dec 2022 21:47:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank <Frank.Sae@motor-comm.com>, Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: Add driver for Motorcomm yt8531
 gigabit ethernet phy
Message-ID: <Y4u17vz20EemzxEB@lunn.ch>
References: <20221202073648.3182-1-Frank.Sae@motor-comm.com>
 <Y4n9T+KGj/hX3C0e@lunn.ch>
 <Y4n+2Ehvp6SInxUw@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4n+2Ehvp6SInxUw@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 01:34:16PM +0000, Russell King (Oracle) wrote:
> On Fri, Dec 02, 2022 at 02:27:43PM +0100, Andrew Lunn wrote:
> > > +static bool mdio_is_locked(struct phy_device *phydev)
> > > +{
> > > +	return mutex_is_locked(&phydev->mdio.bus->mdio_lock);
> > > +}
> > > +
> > > +#define ASSERT_MDIO(phydev) \
> > > +	WARN_ONCE(!mdio_is_locked(phydev), \
> > > +		  "MDIO: assertion failed at %s (%d)\n", __FILE__,  __LINE__)
> > > +
> > 
> > Hi Frank
> > 
> > You are not the only one who gets locking wrong. This could be used in
> > other drivers. Please add it to include/linux/phy.h,
> 
> That placement doesn't make much sense.
> 
> As I already said, we have lockdep checks in drivers/net/phy/mdio_bus.c,
> and if we want to increase their effectiveness, then that's the place
> that it should be done.

I was following the ASSERT_RTNL model, but that is used in quite deep
and complex call stacks, and it is useful to scatter the macro in lots
of places. PHY drivers are however very shallow, so yes, putting them
in mdio_bus.c makes a lot of sense.

> I don't see any point in using __FILE__ and __LINE__ in the above
> macro either. Firstly, WARN_ONCE() already includes the file and line,
> and secondly, the backtrace is more useful than the file and line where
> the assertion occurs especially if it's placed in mdio_bus.c

And PHY driver functions are simpler, there is a lot less inlining
going on, so the function name is probably all you need to know to
find where you messed up the locking. So i agree, they can be removed.

     Andrew
