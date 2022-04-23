Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F028450CC2E
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 18:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbiDWQKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 12:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiDWQKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 12:10:24 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6112C12C691;
        Sat, 23 Apr 2022 09:07:25 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 5CBC21035DE76;
        Sat, 23 Apr 2022 18:07:23 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 2D62B15C9; Sat, 23 Apr 2022 18:07:23 +0200 (CEST)
Date:   Sat, 23 Apr 2022 18:07:23 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jacky Chou <jackychou@asix.com.tw>, Willy Tarreau <w@1wt.eu>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] net: linkwatch: ignore events for unregistered netdevs
Message-ID: <20220423160723.GA20330@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 10:02:43AM +0200, Paolo Abeni wrote:
> On Sun, 2022-04-17 at 09:04 +0200, Lukas Wunner wrote:
> > --- a/net/core/link_watch.c
> > +++ b/net/core/link_watch.c
> > @@ -107,7 +107,8 @@ static void linkwatch_add_event(struct net_device *dev)
> >  	unsigned long flags;
> >  
> >  	spin_lock_irqsave(&lweventlist_lock, flags);
> > -	if (list_empty(&dev->link_watch_list)) {
> > +	if (list_empty(&dev->link_watch_list) &&
> > +	    dev->reg_state < NETREG_UNREGISTERED) {
> >  		list_add_tail(&dev->link_watch_list, &lweventlist);
> >  		dev_hold_track(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
> >  	
> 
> What about testing dev->reg_state in linkwatch_fire_event() before
> setting the __LINK_STATE_LINKWATCH_PENDING bit, so that we don't leave
> the device in an unexpected state?

That would be racy because linkwatch_fire_event() may see a reg_state of
REGISTERED or UNREGISTERING and then add the device to link_watch_list,
even though reg_state may be changed to UNREGISTERED in-between.

That race is avoided by performing the reg_state check under
lweventlist_lock:

Scenario 1:

CPU 1:                                  CPU 2:
                                        linkwatch_add_event(dev);
dev->reg_state = NETREG_UNREGISTERED;
linkwatch_forget_dev(dev);

In this scenario, CPU 2 sees the old value of dev->reg_state and
adds the device to link_watch_list, but CPU 1 will subsequently
delete it from the list.

Scenario 2:

CPU 1:                                  CPU 2:
dev->reg_state = NETREG_UNREGISTERED;
linkwatch_forget_dev(dev);
                                        linkwatch_add_event(dev);

In this scenario, CPU 2 refrains from adding the device to
link_watch_list.  It is guaranteed to see the new reg_state
due to the memory barriers implied by lweventlist_lock,
which is taken both by linkwatch_forget_dev() and
linkwatch_add_event().

Note that an unregistered netdev has been stopped, so the portion
of linkwatch_do_dev() which is constrained to the netdev being IFF_UP
is skipped.  The only portion that's executed is rfc2863_policy(),
which updates the operstate.

I believe that operstate changes are irrelevant and unnecessary after
the netdev has been unregistered.

Same for the fact that __LINK_STATE_LINKWATCH_PENDING may be set even
though the netdev is not on link_watch_list.  That should be irrelevant
for an unregistered netdev.


> Other than that, it looks good to me, but potentially quite risky.

To mitigate risk I suggest letting the patch bake in linux-next
for a couple of weeks.

However I would then have to respin it because the declaration of
linkwatch_run_queue() was moved from include/linux/netdevice.h to
net/core/dev.h by Jakub's net-next commit 6264f58ca0e5 ("net:
extract a few internals from netdevice.h").

Let me know if you want me to respin the patch based on net-next.


> Looking at the original report it looks like the issue could be
> resolved with a more usb-specific change: e.g. it looks like
> usbnet_defer_kevent() is not acquiring a dev reference as it should.
> 
> Have you considered that path?

First of all, the diffstat of the patch shows this is an opportunity
to reduce LoC as well as simplify and speed up device teardown.

Second, the approach you're proposing won't work if a driver calls
netif_carrier_on/off() after unregister_netdev().

It seems prudent to prevent such a misbehavior in *any* driver,
not just usbnet.  usbnet may not be the only one doing it wrong.
Jann pointed out that there are more syzbot reports related
to a UAF in linkwatch:

https://lore.kernel.org/netdev/?q=__linkwatch_run_queue+syzbot

Third, I think an API which schedules work, invisibly to the driver,
is dangerous and misguided.  If it is illegal to call
netif_carrier_on/off() for an unregistered but not yet freed netdev,
catch that in core networking code and don't expect drivers to respect
a rule which isn't even documented.

Thanks,

Lukas
