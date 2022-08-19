Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038B359A525
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351920AbiHSRpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352104AbiHSRoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:44:38 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A93DD750;
        Fri, 19 Aug 2022 10:06:24 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 9DB30240006;
        Fri, 19 Aug 2022 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1660928783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8DZD3ncRKnZVvWUH0347hs4gx0Oa3fVlo3O2awQSE4Y=;
        b=WO8iuOwq70/8iKGVgiTfxlY4mPQLGPHkhwoqvvmFwDMVD0HSLpxm5vzfLaGo6wqNY9MnRQ
        RFAY6xBxs9ApzmuwlDgJFnV2YDXY8RvS9hanu/9huMSb1C3H8VsGLbvChVNxxY/oSjERsa
        dfp2Q06eU4dTk0BOEIBe/figDp88er3sUcuqs5VW6/O+N5zQRVpOvZOPs+TYQhHECOZDfz
        +mhckgx29fNeWbox512flMAOYjrzOXRDK34RVV2mJ/FS4YllFP+5/MyEj3CUJAxJQBm5SP
        KAo509aUoSeVjRbgT/gEbtQyTouDz5gC6sJKXFd0YIvZvWzZYB9fqvlNByJRiw==
Date:   Fri, 19 Aug 2022 19:06:18 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 09/20] net: mac802154: Introduce a global
 device lock
Message-ID: <20220819190618.4647849f@xps-13>
In-Reply-To: <CAK-6q+hu4YGfU9V5EkRiT+Z8MJhOEeVsVv=vEz5fHPkDL99=TQ@mail.gmail.com>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-10-miquel.raynal@bootlin.com>
        <CAK-6q+hu4YGfU9V5EkRiT+Z8MJhOEeVsVv=vEz5fHPkDL99=TQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

I hope you've had a wonderful summer :-)

aahringo@redhat.com wrote on Sun, 3 Jul 2022 21:12:43 -0400:

> Hi,
>=20
> On Fri, Jul 1, 2022 at 10:36 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > The purpose of this device lock is to prevent the removal of the device
> > while an asynchronous MLME operation happens. The RTNL works well for
> > that but in a later series having the RTNL taken here will be
> > problematic and will cause lockdep to warn us about a circular
> > dependency. We don't really need the RTNL here, just a serialization
> > over this operation.
> >
> > Replace the RTNL calls with this new lock. =20
>=20
> I am unhappy about this solution. Can we not interrupt the ongoing
> operation "scan" here and come to an end at a stop?
>=20
> The RTNL is NOT only to prevent the removal of something... If mostly
> all operations are protected by and I know one which makes trouble
> here... setting page/channel. I know we don't hold the rtnl lock on
> other transmit functionality for phy settings which has other reasons
> why we allow it... but here we offer a mac operation which delivers
> wrong results if somebody does another setting e.g. set page/channel
> while scan is going on and we should prevent this.
>=20
> Dropping the rtnl lock, yes we can do that... I cannot think about all
> the side effects which this change will bring into, one I know is the
> channel setting, mostly everything that is interfering with a scan and
> then ugly things which we don't want... preparing the code for the
> page/channel gives us a direction on how to fix and check the other
> cases if we find them. btw: we should do this on another approach
> anyway because the rtnl lock is not held during a whole operation and
> we don't want that.
>=20
> We should also take care that we hold some references which we held
> during the scan, even if it's protected by stop (just for
> correctness).

I was also a bit unhappy by this solution but the rtnl is a real mess
when playing with background works. At least I was not able at all to
make it fit. I'm gonna try to summarize the situation to argue in favor
of the current solution, but I am really open if you see another way.

A scan is started by the user, through a netlink command. It basically
involves stopping any other activity on the transceiver, setting a
particular filtering mode, and possibly sending beacons through the MLME
Tx API at a regular interval.

A scan command from the user then involves acquiring the rtnl just to
be sure that nothing else is requested in parallel. The rtnl is taken
and released by the netlink core, just for the time of the
configuring/triggering action.

We absolutely do not want to keep the rtnl here, I believe we are
aligned on that. This means we need to protect ourselves against a
number of user actions:
1- dropping the device (without stopping the background job/cleaning
   everything),
2- transmitting packets
3- changing internal parameters such as the page/channel to avoid
   messing with the ongoing scan.

The current implementation does the following:
1- in the ieee802154 layer we call dev_hold/dev_put to prevent device
   removal,
2- in the soft mac layer we stop the queue,
3- in the soft mac layer we refuse any channel change command coming
   from the netlink layer during scans, because this is not a nl
   constraint, but a mac state constraint, so I think it is safe to
   handle that from the soft mac layer rather than at the nl level.

This is how I planned to handle the refcount and channel change issues.

Now, let me try to argue in favor of this commit.

The problem I faced was a circular dependency on the device sending
beacons or beacons requests, ie. sending MLME frames in the background.
For the record, in both cases, I need to put some parameters in one of
the main soft mac structures. I created local->scan_lock and
local->beacon_lock to protect accesses to the scanning and beaconing
structures respectively (we don't want eg. the struct to be freed while
a job is using it).

Let's take the situation of the device sending beacons in the
background.

For starting to send beacons, the user sends a netlink command. In the
kernel first layers, the rtnl is acquired (almost) automatically, then
the callback function in the soft mac does the job. One of the first
operations is to acquire the beacons_lock.

Lockdep detects that during the background operation, the kworker will
first acquire beacons_lock (it encloses the whole operation) and after
acquiring this first lock it will perform an MLME Tx to send the
beacon. But this, unfortunately, acquires the rtnl, which triggers the
following warning:

[ 1445.105706]  Possible unsafe locking scenario:
//               -> background job            -> nl802154_send_beacons()  =
=20
[ 1445.105707]        CPU0                    CPU1
[ 1445.105708]        ----                    ----
[ 1445.105709]   lock(&local->beacon_lock);
[ 1445.105710]                                lock(rtnl_mutex);
[ 1445.105712]                                lock(&local->beacon_lock);
[ 1445.105713]   lock(rtnl_mutex);

Exactly the same happens in the scanning path during active scans:

[   52.518741]  Possible unsafe locking scenario:
//               -> background job            -> nl802154_trigger_scan()
[   52.518742]        CPU0                    CPU1
[   52.518743]        ----                    ----
[   52.518744]   lock(&local->scan_lock);
[   52.518746]                                lock(rtnl_mutex);
[   52.518748]                                lock(&local->scan_lock);
[   52.518750]   lock(rtnl_mutex);

In practice I doubt these situations can really happen because there is
no background job running if the triggering netlink command was not
yet called, but anyway, I feel too weak against locking scenarios
to disobey such a clear lockdep warning :-)

So, from my understanding it was safe not to acquire the rtnl in the
MLME Tx path, as long as the calls were serialized (with another
mutex). You seem not to agree with it, which I completely understand,
but then how do I handle those circular dependencies?

Do you think like me they are false positives?

Thanks,
Miqu=C3=A8l
