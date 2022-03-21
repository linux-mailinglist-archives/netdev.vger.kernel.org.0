Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF0A4E2490
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346494AbiCUKpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346445AbiCUKpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:45:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE747665
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:43:20 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nWFVN-0005c5-H4; Mon, 21 Mar 2022 11:43:17 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nWFVM-0001ad-Q8; Mon, 21 Mar 2022 11:43:16 +0100
Date:   Mon, 21 Mar 2022 11:43:16 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Oliver Neukum <oneukum@suse.com>, Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220321104316.GB23957@pengutronix.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
 <a363a053-ee8b-c7d4-5ba5-57187d1b4651@suse.com>
 <20220321101751.GB19177@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220321101751.GB19177@wunner.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:40:00 up 100 days, 19:25, 81 users,  load average: 0.19, 0.26,
 0.36
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

On Mon, Mar 21, 2022 at 11:17:51AM +0100, Lukas Wunner wrote:
> On Thu, Mar 17, 2022 at 04:53:34PM +0100, Oliver Neukum wrote:
> > On 15.03.22 14:28, Andrew Lunn wrote:
> > >>>> It was linked to unregistered/freed
> > >>>> netdev. This is why my patch changing the order to call phy_disconnect()
> > >>>> first and then unregister_netdev().
> > >>> Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:
> > >>>
> > >>>   usbnet_disconnect()
> > >>>     unregister_netdev()
> > >>>     ax88772_unbind()
> > >>>       phy_disconnect()
> > >>>     free_netdev()
> > >>>
> > >>> Is it illegal to disconnect a PHY from an unregistered, but not yet freed
> > >>> net_device?
> > > There are drivers which unregistering and then calling
> > > phy_disconnect. In general that should be a valid pattern. But more
> > > MAC drivers actually connect the PHY on open and disconnect it on
> > > close. So it is less well used.
> > 
> > this is an interesting discussion, but what practical conclusion
> > do we draw from it? Is it necessary to provide both orders
> > of notifying the subdriver, or isn't it?
> 
> I see two possible solutions:
> 
> (1) The pattern of unregistering a net_device and then detaching the PHY
>     is made legal by setting attached_dev = NULL on unregister and adding
>     NULL pointer checks to phylib.  I'll wait for the phylib maintainers'
>     comments whether they find that acceptable.
> 
> (2) Affected drivers (asix_devices.c, smsc95xx.c, possibly others) are
>     amended with ->ndo_uninit() callbacks, which call phy_disconnect().
>     That's basically your (Oliver's) idea to split usbnet ->unbind,
>     but without actually having to split it.  (Just use the existing
>     ->ndo_uninit.)
> 
> By the way: 2c9d6c2b871d caused breakage in smsc95xx.c which was
> subsequently fixed by a049a30fc27c.  That in turn required another
> fix, 0bf3885324a8.  Some of these code changes will have to be
> rolled back or adjusted after reverting 2c9d6c2b871d.  It's a giant mess.
> It's possible that more drivers saw fixes due to 2c9d6c2b871d,
> I haven't checked that yet.

The smsc95xx.c needed fixes after porting it to PHYlib and MDIO. Since
you can just remove the USB adapter, everything depending and still
running on it will just explode in different colors. The is no way, you
can run stop sequence on physically disconnected device.

> Oliver, why did you want to revert 2c9d6c2b871d, i.e. in which drivers
> have your users reported breakage?  Do you have bugzilla links?
> 
> Thanks,
> 
> Lukas
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
