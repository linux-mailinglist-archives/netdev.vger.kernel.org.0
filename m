Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4632A61E570
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 20:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiKFTF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 14:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiKFTFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 14:05:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652A6A473
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 11:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YO6lRtrreV6zsW7H+VJmc50+F118z0QUpjKWLiFh1LU=; b=Z//moUSDmqHd62p/h8bla9NOPP
        SzCFZIB5930fn/e52OikFm3mvjB1EHTBUHUqGq1s81Gn5Twt1htlspxgKzxZy32iE089ZdRlmobSo
        tFEe99ey8/te3xA0f1jLquLG3tTE2wFiqVIQZEWdRABV9OZco3sSDgX0uYyMZ5M/jKsY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1orkxr-001dwF-GJ; Sun, 06 Nov 2022 20:05:51 +0100
Date:   Sun, 6 Nov 2022 20:05:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     piergiorgio.beruto@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: Adding IEEE802.3cg Clause 148 PLCA support to Linux
Message-ID: <Y2gFj9wZzJO6z2v8@lunn.ch>
References: <026701d8f13d$ef0c2800$cd247800$@gmail.com>
 <Y2fp9Eqe9icT/7DE@lunn.ch>
 <000001d8f20b$33f0f0e0$9bd2d2a0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001d8f20b$33f0f0e0$9bd2d2a0$@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 06, 2022 at 07:11:32PM +0100, piergiorgio.beruto@gmail.com wrote:
> > I suggest you define new ethtool netlink messages. I don't think PHY tunables would make a good interface, since you have > multiple values which need configuring, and you also have some status information.

Your email client is messing up emails. I follow the netique rules, my
lines are wrapped at around 75 characters. This is recommended
practice for all Linux kernel mailing lists. Your mailer has destroyed
this. Please also wrap your own text at about 75 characters.

> That sounds fair to me, thanks for your advice.
> 
> > So you probably want a message to set the configuration, and another to get the current configuration. For the set, you 
> > probably want an attribute per configuration value, and allow a subset of attributes to be included in the message. The get 
> > configuration should by default return all the attributes, but not enforce this, since some vendor will implement it wrong 
> > and miss something out.
> 
> Yes, that sounds about right. If you have any hint on where in the code to start looking at, I'll start from there.

ethtool --cable-test packs a number of optional attributes into a
netlink message. It then gets passed to phylib. You could use that as
an example. The way cable tests results are passed back later is
pretty unusual, so don't copy that code!

> > What I don't see in the Open Alliance spec is anything about interrupts. It would be interesting to see if any vendor triggers 
> > an interrupt when PST changes. A PHY which has this should probably send a linkstate message to userspace reporting the 
> > state change. For PHYs without interrupts, phylib will poll the read_status method once per second. You probably want to 
> > check the PST bit during that poll. If EN is true, but PST is false, is the link considered down?
> 

> This is actually an interesting point. First of all, yes, vendors do have IRQs for the PST. At least, the products I'm working on do, including the already released NCN26010.

Each PHY driver is going to need its own code for enabling the
interrupt, handling etc, since none of this is standardized. This is
one reason why you provide helpers, but don't force there use.

> My thinking is that the PST should be taken into account to evaluate the status of the link. On a multi-drop network with no autoneg and no link training the link status would not make much sense anyway, just like the connected status of an UDP socket wouldn't make sense.

So the read_status() call should evaluate the PST bit, along with
EN. Again, a helper to do that would be useful.

The user API is the most important bit of this work. Linux considers
the uAPI an stable ABI. Once you have defined it, it cannot change in
ways which break backwards compatibility. So the initial reviews of
code you present will concentrate on the uAPI. Once that is good,
reviews will then swap to all the implementation details in phylib and
the drivers.

    Andrew
