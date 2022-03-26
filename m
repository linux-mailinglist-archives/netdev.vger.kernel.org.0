Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AAD4E80F9
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 14:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiCZND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 09:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231591AbiCZND0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 09:03:26 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E959B1DF84F
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 06:01:49 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 925D1100D587D;
        Sat, 26 Mar 2022 14:01:48 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 666F82D2CC9; Sat, 26 Mar 2022 14:01:48 +0100 (CET)
Date:   Sat, 26 Mar 2022 14:01:48 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <20220326130148.GC31022@wunner.de>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <20220326122552.GA31022@wunner.de>
 <Yj8KnE5BeEK1SXDP@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yj8KnE5BeEK1SXDP@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 01:44:12PM +0100, Andrew Lunn wrote:
> On Sat, Mar 26, 2022 at 01:25:52PM +0100, Lukas Wunner wrote:
> > Oleksij, I cannot reproduce your stacktrace (included in full length below).
> > I've tested with kernel 5.13 (since the stacktrace was with 5.13-rc3)
> > with all your (and other people's) asix patches applied on top,
> > except for 2c9d6c2b871d.  Tried unplugging an AX88772A multiple times,
> > never got a stacktrace.
> > 
> > I've also walked down the code paths from usbnet_disconnect() and cannot
> > see how the stacktrace could occur.
> > 
> > Normally an unregistering netdev is removed from the linkwatch event list
> > (lweventlist) via this call stack:
> > 
> >           usbnet_disconnect()
> >             unregister_netdev()
> >               rtnl_unlock()
> >                 netdev_run_todo()
> >                   netdev_wait_allrefs()
> >                     linkwatch_forget_dev()
> >                       linkwatch_do_dev()
> > 
> > For the stacktrace to occur, the netdev would have to be subsequently
> > re-added to the linkwatch event list via linkwatch_fire_event().
> 
> What you might be missing is a call to phy_error()

But phy_error() has a WARN_ON(1) right at its top.  So it produces
a stacktrace itself.  That stacktrace is nowhere to be seen in the
dmesg output Oleksij posted.  Hence it can't be caused by phy_error().

Also, recall that unregister_netdev() stops the netdev before
unregistering it.  That in turn causes an invocation of phy_stop()
via ax88772_stop().  phy_stop() already puts the PHY into PHY_HALTED
state and resets phydev->link = 0.  So a subsequent phy_error() cannot
result in a call to phy_link_down() (which would indeed trigger a
dangerous linkwatch_fire_event()).


> > That is called, among other places, from netif_carrier_off().  However,
> > netif_carrier_off() is already called *before* linkwatch_forget_dev()
> > when unregister_netdev() stops the netdev before unregistering it:
> > 
> >           usbnet_disconnect()
> >             unregister_netdev()
> >               unregister_netdevice()
> >                 unregister_netdevice_queue(dev, NULL)
> >                   unregister_netdevice_many()
> >                     dev_close_many()
> >                       __dev_close_many()
> >                         usbnet_stop()
> >                           ax88772_stop()
> >                             phy_stop() # state = PHY_HALTED
> >                               phy_state_machine()
> 
> I'm guessing somewhere around here:
> 
> If it calls into the PHY driver, and the PHY calls for an MDIO bus
> transaction, and that returns an error, -ENODEV or -EIO for example,
> because the USB device has gone away, and that results in a call to
> phy_error().

Oleksij amended phy_state_machine() to bail out if err == -ENODEV
with commit 06edf1a940be ("net: phy: do not print dump stack if device
was removed").  The commit skips the phy_error() on -ENODEV, which
makes a lot of sense.

Thanks,

Lukas
