Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74F150CD33
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 21:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbiDWTi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbiDWTi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 15:38:56 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E205E162
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 12:35:56 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 9F4C9280253C4;
        Sat, 23 Apr 2022 21:35:54 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 9047FAEC9E; Sat, 23 Apr 2022 21:35:54 +0200 (CEST)
Date:   Sat, 23 Apr 2022 21:35:54 +0200
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
Message-ID: <20220423193554.GA14389@wunner.de>
References: <18b3541e5372bc9b9fc733d422f4e698c089077c.1650177997.git.lukas@wunner.de>
 <9325d344e8a6b1a4720022697792a84e545fef62.camel@redhat.com>
 <20220423160723.GA20330@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220423160723.GA20330@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 06:07:23PM +0200, Lukas Wunner wrote:
> On Thu, Apr 21, 2022 at 10:02:43AM +0200, Paolo Abeni wrote:
> > On Sun, 2022-04-17 at 09:04 +0200, Lukas Wunner wrote:
> > > --- a/net/core/link_watch.c
> > > +++ b/net/core/link_watch.c
> > > @@ -107,7 +107,8 @@ static void linkwatch_add_event(struct net_device *dev)
> > >  	unsigned long flags;
> > >  
> > >  	spin_lock_irqsave(&lweventlist_lock, flags);
> > > -	if (list_empty(&dev->link_watch_list)) {
> > > +	if (list_empty(&dev->link_watch_list) &&
> > > +	    dev->reg_state < NETREG_UNREGISTERED) {
> > >  		list_add_tail(&dev->link_watch_list, &lweventlist);
> > >  		dev_hold_track(dev, &dev->linkwatch_dev_tracker, GFP_ATOMIC);
> > >  	
> > 
> > What about testing dev->reg_state in linkwatch_fire_event() before
> > setting the __LINK_STATE_LINKWATCH_PENDING bit, so that we don't leave
> > the device in an unexpected state?

About __LINK_STATE_LINKWATCH_PENDING being set even though the netdev
is not on link_watch_list:

After this patch (which removes one user of __LINK_STATE_LINKWATCH_PENDING)
the only purpose of the flag is a small speed-up of linkwatch_fire_event():
If the netdev is already on link_watch_list, the function skips acquiring
lweventlist_lock.

I don't think this is a hotpath, so the small speed-up is probably not worth
it and the flag could be removed completely in a follow-up patch.

There is a single other (somewhat oddball) user of the flag in
bond_should_notify_peers() in drivers/net/bonding/bond_main.c.
It would be possible to replace it with "!list_empty(&dev->link_watch_list)".
I don't think acquiring lweventlist_lock is necessary for that because
test_bit() is unordered (per Documentation/atomic_bitops.txt) and the
check is racy anyway.

Thanks,

Lukas
