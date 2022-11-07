Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0130D61F357
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbiKGMcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:32:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbiKGMcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:32:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C81F3A2
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 04:32:44 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1os1Iw-0008W2-3x; Mon, 07 Nov 2022 13:32:42 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1os1Iv-00041O-2L; Mon, 07 Nov 2022 13:32:41 +0100
Date:   Mon, 7 Nov 2022 13:32:41 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     piergiorgio.beruto@gmail.com
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: Adding IEEE802.3cg Clause 148 PLCA support to Linux
Message-ID: <20221107123241.GA13594@pengutronix.de>
References: <026701d8f13d$ef0c2800$cd247800$@gmail.com>
 <Y2fp9Eqe9icT/7DE@lunn.ch>
 <000001d8f20b$33f0f0e0$9bd2d2a0$@gmail.com>
 <Y2gFj9wZzJO6z2v8@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y2gFj9wZzJO6z2v8@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Piergiorgio,

please CC me for the next rounds of T1* related topics :)


On Sun, Nov 06, 2022 at 08:05:51PM +0100, Andrew Lunn wrote:
> On Sun, Nov 06, 2022 at 07:11:32PM +0100, piergiorgio.beruto@gmail.com wrote:
> > > I suggest you define new ethtool netlink messages. I don't think PHY tunables would make a good interface, since you have > multiple values which need configuring, and you also have some status information.
> 
> Your email client is messing up emails. I follow the netique rules, my
> lines are wrapped at around 75 characters. This is recommended
> practice for all Linux kernel mailing lists. Your mailer has destroyed
> this. Please also wrap your own text at about 75 characters.
> 
> > That sounds fair to me, thanks for your advice.
> > 
> > > So you probably want a message to set the configuration, and another to get the current configuration. For the set, you 
> > > probably want an attribute per configuration value, and allow a subset of attributes to be included in the message. The get 
> > > configuration should by default return all the attributes, but not enforce this, since some vendor will implement it wrong 
> > > and miss something out.
> > 
> > Yes, that sounds about right. If you have any hint on where in the code to start looking at, I'll start from there.
> 
> ethtool --cable-test packs a number of optional attributes into a
> netlink message. It then gets passed to phylib. You could use that as
> an example. The way cable tests results are passed back later is
> pretty unusual, so don't copy that code!
> 
> > > What I don't see in the Open Alliance spec is anything about interrupts. It would be interesting to see if any vendor triggers 
> > > an interrupt when PST changes. A PHY which has this should probably send a linkstate message to userspace reporting the 
> > > state change. For PHYs without interrupts, phylib will poll the read_status method once per second. You probably want to 
> > > check the PST bit during that poll. If EN is true, but PST is false, is the link considered down?
> > 
> 
> > This is actually an interesting point. First of all, yes, vendors do have IRQs for the PST. At least, the products I'm working on do, including the already released NCN26010.
> 
> Each PHY driver is going to need its own code for enabling the
> interrupt, handling etc, since none of this is standardized. This is
> one reason why you provide helpers, but don't force there use.
> 
> > My thinking is that the PST should be taken into account to evaluate the status of the link. On a multi-drop network with no autoneg and no link training the link status would not make much sense anyway, just like the connected status of an UDP socket wouldn't make sense.
> 
> So the read_status() call should evaluate the PST bit, along with
> EN. Again, a helper to do that would be useful.
> 
> The user API is the most important bit of this work. Linux considers
> the uAPI an stable ABI. Once you have defined it, it cannot change in
> ways which break backwards compatibility. So the initial reviews of
> code you present will concentrate on the uAPI. Once that is good,
> reviews will then swap to all the implementation details in phylib and
> the drivers.
> 
>     Andrew

Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
