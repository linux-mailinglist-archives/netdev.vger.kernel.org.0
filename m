Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9024E86FB
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiC0Iis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 04:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiC0Iir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 04:38:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4C2140F4
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 01:37:09 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nYOOW-0008P8-5F; Sun, 27 Mar 2022 10:37:04 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nYOOU-0006Jf-7C; Sun, 27 Mar 2022 10:37:02 +0200
Date:   Sun, 27 Mar 2022 10:37:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220327083702.GC27264@pengutronix.de>
References: <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <20220321100226.GA19177@wunner.de>
 <Yjh5Qz8XX1ltiRUM@lunn.ch>
 <20220326123929.GB31022@wunner.de>
 <Yj8L2Jl0yyHIyW1m@lunn.ch>
 <20220326130430.GD31022@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220326130430.GD31022@wunner.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:24:06 up 106 days, 17:09, 55 users,  load average: 0.03, 0.03,
 0.06
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 02:04:30PM +0100, Lukas Wunner wrote:
> On Sat, Mar 26, 2022 at 01:49:28PM +0100, Andrew Lunn wrote:
> > On Sat, Mar 26, 2022 at 01:39:29PM +0100, Lukas Wunner wrote:
> > > On Mon, Mar 21, 2022 at 02:10:27PM +0100, Andrew Lunn wrote:
> > > > There are two patterns in use at the moment:
> > > > 
> > > > 1) The phy is attached in open() and detached in close(). There is no
> > > >    danger of the netdev disappearing at this time.
> > > > 
> > > > 2) The PHY is attached during probe, and detached during release.
> > > > 
> > > > This second case is what is being used here in the USB code. This is
> > > > also a common pattern for complex devices. In probe, you get all the
> > > > components of a complex devices, stitch them together and then
> > > > register the composite device. During release, you unregister the
> > > > composite device, and then release all the components. Since this is a
> > > > natural model, i think it should work.
> > > 
> > > I've gone through all drivers and noticed that some of them use a variation
> > > of pattern 2 which looks fishy:
> > > 
> > > On probe, they first attach the PHY, then register the netdev.
> > > On remove, they detach the PHY, then unregister the netdev.
> > > 
> > > Is it legal to detach the PHY from a registered (potentially running)
> > > netdev? It looks wrong to me.
> > 
> > I think the network stack guarantee that the close() method is called
> > before unregister completes. It is a common pattern to attach the PHY
> > in open() and detach it in close(). The stack itself should not be
> > using the PHY when it is down, the exception being IOCTL handlers
> > which people often get wrong.
> 
> But the PHY is detached from a *running* netdev *before* that netdev
> is unregistered (and closed).  Is that really legal?

IMO, it reflects, more or less, the reality of devices with SFP modules.
The PHY can be physically removed from running netdev. At same time,
netdev should be registered and visible for the user, even if PHY is not
physically attached.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
