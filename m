Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4540566B38C
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 20:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjAOTCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 14:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjAOTCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 14:02:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB44C660;
        Sun, 15 Jan 2023 11:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jiXK4/tyzu5ucnG4gM956kmF7blt+3J2BcXkN7H2TAw=; b=zksDgh6dbSYaTYHySQFZFWBJXT
        XWvFyBoi7k2f2LvfHJ1aYBWgGK0mSEFQtrcG8fz5BYMSXBdHiGTJm6kd1IsQ/PdseyEIvlOTIKxf4
        zuZKv9E6g+kiJP9qTMVpoN+W1K/8FxhF5iSAvxYeGtPdO8J4pleKhnOfVgMB1YKAwkus=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pH8H6-0029ED-BP; Sun, 15 Jan 2023 20:02:36 +0100
Date:   Sun, 15 Jan 2023 20:02:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pierluigi Passaro <pierluigi.passaro@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Message-ID: <Y8RNzIuiNdAi0dnV@lunn.ch>
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
 <CAJ=UCjX0YzVgedO1hDu_NsFAGhxe8HouUmHmbO6AXZqT=OUYLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ=UCjX0YzVgedO1hDu_NsFAGhxe8HouUmHmbO6AXZqT=OUYLg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This behaviour is generally not visible, but easily reproducible with all NXP
> platforms with dual fec (iMX28, iMX6UL, iMX7, iMX8QM, iMX8QXP)
> where the MDIO bus is owned by the 1st interface but shared with the 2nd.
> When the 1st interface is probed, this causes the probe of the MDIO bus
> when the 2nd interface is not yet set up.

This sounds like a different issue.

We need to split the problem up into two.

1) Does probing the MDIO bus find both PHYs?

2) Do the MACs get linked to the PHYs.

If the reset is asserted at the point the MDIO bus is probed, you
probably don't find the PHY because it does not respond to register
reads. Your patch probably ensures it is out of reset so it is
enumerated.

For fec1, if the PHY is found during probe, connecting to the PHY will
work without issues. However, fec2 can potentially have ordering
issues. Has the MDIO bus finished being probed by the time fec2 looks
for it? If it is not there you want to return -EPROBE_DEFERED so that
the driver code will try again later.

There have been patches to do with ordering recently, but they have
been more to do with suspend/resume. So please make sure you are
testing net-next, if ordering is your real problem. You also appear to
be missing a lot of stable patches, so please bring you kernel up to
date on the 5.15 branch, you are way out of date.

     Andrew

