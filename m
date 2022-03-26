Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483724E80E5
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 13:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbiCZMp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 08:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232983AbiCZMp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 08:45:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75556132EA8
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 05:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1CkqPfsjBEnM85oh53sq9z2R1hW4bEhP9/BkPnwjZaM=; b=3fSoCMHQlASg9lziV/k2KPJ+VC
        f1nxzfSg/6C8hM+U5jwKUrHOceAGhEO+HojVINxcOyTrYTKjp9XWOerXq0811Mg9S6y8P67dSajyc
        R05hCDUhMIsOrMf6R+m8e6mQ08Y4wbZygkUpiCJmxE64ExEu6BaxQ7h+Il0hb8FztwMA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nY5m8-00Clx8-L2; Sat, 26 Mar 2022 13:44:12 +0100
Date:   Sat, 26 Mar 2022 13:44:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: ordering of call to unbind() in usbnet_disconnect
Message-ID: <Yj8KnE5BeEK1SXDP@lunn.ch>
References: <62b944a1-0df2-6e81-397c-6bf9dea266ef@suse.com>
 <20220310113820.GG15680@pengutronix.de>
 <20220314184234.GA556@wunner.de>
 <Yi+UHF37rb0URSwb@lunn.ch>
 <20220315054403.GA14588@pengutronix.de>
 <20220315083234.GA27883@wunner.de>
 <20220315113841.GA22337@pengutronix.de>
 <20220326122552.GA31022@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326122552.GA31022@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 26, 2022 at 01:25:52PM +0100, Lukas Wunner wrote:
> On Tue, Mar 15, 2022 at 12:38:41PM +0100, Oleksij Rempel wrote:
> > On Tue, Mar 15, 2022 at 09:32:34AM +0100, Lukas Wunner wrote:
> > > > > > > On Thu, Mar 10, 2022 at 12:25:08PM +0100, Oliver Neukum wrote:
> > > > > > > > I got bug reports that 2c9d6c2b871d ("usbnet: run unbind() before
> > > > > > > > unregister_netdev()") is causing regressions.
> > > 
> > > Is it illegal to disconnect a PHY from an unregistered, but not yet freed
> > > net_device?
> > > 
> > > Oleksij, the commit message of 2c9d6c2b871d says that disconnecting the
> > > PHY "fails" in that situation.  Please elaborate what the failure looked
> > > like.  Did you get a stacktrace?
> 
> Oleksij, I cannot reproduce your stacktrace (included in full length below).
> I've tested with kernel 5.13 (since the stacktrace was with 5.13-rc3)
> with all your (and other people's) asix patches applied on top,
> except for 2c9d6c2b871d.  Tried unplugging an AX88772A multiple times,
> never got a stacktrace.
> 
> I've also walked down the code paths from usbnet_disconnect() and cannot
> see how the stacktrace could occur.
> 
> Normally an unregistering netdev is removed from the linkwatch event list
> (lweventlist) via this call stack:
> 
>           usbnet_disconnect()
>             unregister_netdev()
>               rtnl_unlock()
>                 netdev_run_todo()
>                   netdev_wait_allrefs()
>                     linkwatch_forget_dev()
>                       linkwatch_do_dev()
> 
> For the stacktrace to occur, the netdev would have to be subsequently
> re-added to the linkwatch event list via linkwatch_fire_event().

Hi Lukas

What you might be missing is a call to phy_error()
 
> That is called, among other places, from netif_carrier_off().  However,
> netif_carrier_off() is already called *before* linkwatch_forget_dev()
> when unregister_netdev() stops the netdev before unregistering it:
> 
>           usbnet_disconnect()
>             unregister_netdev()
>               unregister_netdevice()
>                 unregister_netdevice_queue(dev, NULL)
>                   unregister_netdevice_many()
>                     dev_close_many()
>                       __dev_close_many()
>                         usbnet_stop()
>                           ax88772_stop()
>                             phy_stop() # state = PHY_HALTED
>                               phy_state_machine()

I'm guessing somewhere around here:

If it calls into the PHY driver, and the PHY calls for an MDIO bus
transaction, and that returns an error, -ENODEV or -EIO for example,
because the USB device has gone away, and that results in a call to
phy_error().

void phy_error(struct phy_device *phydev)
{
        WARN_ON(1);

        mutex_lock(&phydev->lock);
        phydev->state = PHY_HALTED;
        mutex_unlock(&phydev->lock);

        phy_trigger_machine(phydev);
}

That will trigger the PHY state machine to run again, asynchronously.

The end of phy_stop() says:

        /* Cannot call flush_scheduled_work() here as desired because
         * of rtnl_lock(), but PHY_HALTED shall guarantee irq handler
         * will not reenable interrupts.
         */

so it looks like the state machine will run again, and potentially use
netdev.

If the MDIO bus driver is no longer returning ENODEV, than we should
avoid this.

      Andrew
