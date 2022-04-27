Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BAE511DC6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239535AbiD0POJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 11:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239216AbiD0POI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 11:14:08 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6BF2D71D4;
        Wed, 27 Apr 2022 08:10:57 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 97676300002AC;
        Wed, 27 Apr 2022 17:10:53 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8659A4D197; Wed, 27 Apr 2022 17:10:53 +0200 (CEST)
Date:   Wed, 27 Apr 2022 17:10:53 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net] usbnet: smsc95xx: Fix deadlock on runtime resume
Message-ID: <20220427151053.GA10204@wunner.de>
References: <6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de>
 <YmlMaE53+EhRz5it@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmlMaE53+EhRz5it@rowland.harvard.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 10:00:08AM -0400, Alan Stern wrote:
> On Wed, Apr 27, 2022 at 08:41:49AM +0200, Lukas Wunner wrote:
> > Commit 05b35e7eb9a1 ("smsc95xx: add phylib support") amended
> > smsc95xx_resume() to call phy_init_hw().  That function waits for the
> > device to runtime resume even though it is placed in the runtime resume
> > path, causing a deadlock.
> > 
> > The problem is that phy_init_hw() calls down to smsc95xx_mdiobus_read(),
> > which never uses the _nopm variant of usbnet_read_cmd().  Amend it to
> > autosense that it's called from the runtime resume/suspend path and use
> > the _nopm variant if so.
[...]
> > --- a/drivers/net/usb/smsc95xx.c
> > +++ b/drivers/net/usb/smsc95xx.c
> > @@ -285,11 +285,21 @@ static void smsc95xx_mdio_write_nopm(struct usbnet *dev, int idx, int regval)
> >  	__smsc95xx_mdio_write(dev, pdata->phydev->mdio.addr, idx, regval, 1);
> >  }
> >  
> > +static bool smsc95xx_in_pm(struct usbnet *dev)
> > +{
> > +#ifdef CONFIG_PM
> > +	return dev->udev->dev.power.runtime_status == RPM_RESUMING ||
> > +	       dev->udev->dev.power.runtime_status == RPM_SUSPENDING;
> > +#else
> > +	return false;
> > +#endif
> > +}
> 
> This does not do what you want.  You want to know if this function is 
> being called in the resume pathway, but all it really tells you is 
> whether the function is being called while a resume is in progress (and 
> it doesn't even do that very precisely because the code does not use the 
> runtime-pm spinlock).  The resume could be running in a different 
> thread, in which case you most definitely _would_ want to want for it to 
> complete.

I'm aware of that.  I've explored various approaches and none solved
the problem perfectly.  This one seems good enough for all practical
purposes.

One approach I've considered is to use current_work() to determine if
we're called from dev->power.work.  But that only works if the runtime
resume/suspend is asynchronous (RPM_ASYNC is set).  In this case, the
runtime resume is synchronous and called from a different work item
(hub_event).  So the approach is not feasible.

Another approach is to assign a dev_pm_domain to the usb_device, whose
->runtime_resume hook first calls usb_runtime_resume() (so that the
usb_device and usb_interface has status RPM_ACTIVE), *then* calls
phy_init_hw().  Problem is, this only works for runtime resume
and we need a solution for runtime suspend as well.  (The device already
has status RPM_SUSPENDING when the dev_pm_domain's ->runtime_suspend hook
is invoked.)  So not a feasible approach either.

Fudging the runtime_status in the ->runtime_suspend and ->runtime_resume
hooks via pm_runtime_set_active() / _set_suspended() is rejected by the
runtime PM core.

I've even considered walking up the callstack via _RET_IP_ to determine
if one of the callers is smsc95xx_resume() / _suspend().  But I'm not
sure that's reliable and portable across all arches.

And I don't want to clutter phylib with _nopm variants either.

So the approach I've chosen here, while not perfect, does its job,
is simple and uses very little code.  If you've got a better idea,
please let me know.

Thanks,

Lukas
