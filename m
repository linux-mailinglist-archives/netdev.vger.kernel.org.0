Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E904E2406
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 11:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346221AbiCUKKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 06:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346217AbiCUKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 06:10:38 -0400
X-Greylist: delayed 404 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Mar 2022 03:09:11 PDT
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FAC12756
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 03:09:11 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 214D43000243F;
        Mon, 21 Mar 2022 11:02:26 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 0E3C42E6C7F; Mon, 21 Mar 2022 11:02:26 +0100 (CET)
Date:   Mon, 21 Mar 2022 11:02:26 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220321100226.GA19177@wunner.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <YjCUgCNHw6BUqJxr@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjCUgCNHw6BUqJxr@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 02:28:32PM +0100, Andrew Lunn wrote:
> > > > It was linked to unregistered/freed netdev. This is why my patch
> > > > changing the order to call phy_disconnect() first and then
> > > > unregister_netdev().
> > > 
> > > Unregistered yes, but freed no.  Here's the order before 2c9d6c2b871d:
> > > 
> > >   usbnet_disconnect()
> > >     unregister_netdev()
> > >     ax88772_unbind()
> > >       phy_disconnect()
> > >     free_netdev()
> > > 
> > > Is it illegal to disconnect a PHY from an unregistered, but not yet freed
> > > net_device?
> 
> There are drivers which unregistering and then calling
> phy_disconnect. In general that should be a valid pattern. But more
> MAC drivers actually connect the PHY on open and disconnect it on
> close. So it is less well used.

It turns out that unregistering a net_device and then calling
phy_disconnect() may indeed crash and is thus not permitted
right now:

Oleksij added the following code comment with commit e532a096be0e
("net: usb: asix: ax88772: add phylib support"):

  /* On unplugged USB, we will get MDIO communication errors and the
   * PHY will be set in to PHY_HALTED state.

So the USB adapter gets unplugged, access to MII registers fails with
-ENODEV, phy_error() is called, phy_state_machine() transitions to
PHY_HALTED and performs the following call:

  phy_state_machine()
    phy_link_down()
      phy_link_change()
        netif_carrier_off()
          linkwatch_fire_event()

Asynchronously, usbnet_disconnect() calls phy_detach() and then
free_netdev().

A bit later, linkwatch_event() runs and tries to access the freed
net_device, leading to the crash that Oleksij posted upthread.

The fact that linkwatch_fire_event() increments the refcount doesn't
help because unregister_netdevice() has already run (it waits for
the refcount to drop to 1).

My suggestion would be to amend unregister_netdevice() to set
dev->phydev->attached_dev = NULL.  It may also be a good idea
to WARN_ON() in free_netdev() if the refcount is not 1.

Andrew, please clarify whether you really think that the
"unregister netdev, then detach phy" order should be supported.
If you do think that it should be supported, we'll have to litter
phylib with NULL pointer checks for attached_dev.  If you don't
want that, we should at least document that it's an illegal pattern.

Even if you decide that we should rather declare this pattern
illegal rather than littering phylib with NULL pointer checks,
I strongly recommend that at least unregister_netdevice() sets
dev->phydev->attached_dev = NULL.  That will cause oopses which
are easier to debug than complex races like the one witnessed
by Oleksij.

Side note:  Since e532a096be0e, ax88772_stop() directly accesses
phydev->state.  I wonder whether that's legal.  I'm under the
impression that the state is internal to phylib.

Another side note:  The commit message of 2c9d6c2b871d is poor.
It should have contained a stack trace and a clear explanation.
It took me days of staring at code to reverse-engineer what
went wrong here.

Thanks,

Lukas
