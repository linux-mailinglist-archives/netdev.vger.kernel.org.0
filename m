Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F825A1C94
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiHYWlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiHYWls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:41:48 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96094C4825;
        Thu, 25 Aug 2022 15:41:45 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id DFA7B1BF203;
        Thu, 25 Aug 2022 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661467303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QryJMjwjapItCOjLLInVJbILFRivt0z821vZC16cP38=;
        b=X9x21AFdtTSYQT3G8LVMkedMOQTUT5Nc9pgNBVNHhgz7aSxFlkKTaDA3vnMQe79lIQo1BZ
        uqFrnvgFPrhfbqtFgfkn7w24pH2avZSIpmDmlLrSEUJBNa+1f/hNKL++nAmAuXBgoY/2fC
        hJ7TfWVsuM1Dl5J0eLz5s5H/m9mt7mhpwAt3H73S2Z8aZBGUrEKPgsSjqjxJbvjoYHmApI
        RWfU4nL8673yaNtQ8SJn9f18+VM1kF2OL82NxzB2oCsHK6SE9bb0GylUMUVUrULwgVOC35
        Gy08K0WA6vpXXttkgcFfuS3ixnEeqq5qzCFfNSJuCY3asxV2Kil8UmR8KpLtdw==
Date:   Fri, 26 Aug 2022 00:41:39 +0200
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
Subject: Re: [PATCH wpan-next 19/20] ieee802154: hwsim: Do not check the
 rtnl
Message-ID: <20220826004139.7f04e375@xps-13>
In-Reply-To: <20220819190944.0718c7e1@xps-13>
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
        <20220701143052.1267509-20-miquel.raynal@bootlin.com>
        <CAK-6q+ihSui2ra188kt9W5CT0HPfJgHoOJfsMS_XDLfVvoQJTg@mail.gmail.com>
        <20220819190944.0718c7e1@xps-13>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

miquel.raynal@bootlin.com wrote on Fri, 19 Aug 2022 19:09:44 +0200:

> Hi Alexander,
>=20
> aahringo@redhat.com wrote on Tue, 5 Jul 2022 21:23:21 -0400:
>=20
> > Hi,
> >=20
> > On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.co=
m> wrote: =20
> > >
> > > There is no need to ensure the rtnl is locked when changing a driver's
> > > channel. This cause issues when scanning and this is the only driver
> > > relying on it. Just drop this dependency because it does not seem
> > > legitimate.
> > >   =20
> >=20
> > switching channels relies on changing pib attributes, pib attributes
> > are protected by rtnl. If you experience issues here then it's
> > probably because you do something wrong. All drivers assuming here
> > that rtnl lock is held. =20
>=20
> ---8<---
> > especially this change could end in invalid free. Maybe we can solve
> > this problem in a different way, what exactly is the problem by
> > helding rtnl lock?
> --->8--- =20
>=20
> During a scan we need to change channels. So when the background job
> kicks-in, we first acquire scan_lock, then we check the internal
> parameters of the structure protected by this lock, like the next
> channel to use and the sdata pointer. A channel change must be
> performed, preceded by an rtnl_lock(). This will again trigger a
> possible circular lockdep dependency warning because the triggering path
> acquires the rtnl (as part of the netlink layer) before the scan lock.
>=20
> One possible solution would be to do the following:
> scan_work() {
> 	acquire(scan_lock);
> 	// do some config
> 	release(scan_lock);
> 	rtnl_lock();
> 	perform_channel_change();
> 	rtnl_unlock();
> 	acquire(scan_lock);
> 	// reinit the scan struct ptr and the sdata ptr
> 	// do some more things
> 	release(scan_lock);
> }
>=20
> It looks highly non-elegant IMHO. Otherwise I need to stop verifying in
> the drivers that the rtnl is taken. Any third option here?

I've tried two other solutions.

A/ Enforcing the dependency rtnl -> scan_lock

This means always acquiring the rtnl before scan_lock, and in terms of
code requires to take the rtnl in the scan worker. Of course enclosing
the drv_change_chan() call would mean releasing the scan_lock in the
middle and re-taking it after all, which would defeat the protection of
the scan_req structure which the lock is supposed to enforce. So I went
for acquiring the lock at the top, before acquiring scan_lock, of
course.

This does not work because we need to acquire the rtnl in the worker,
while at the same time there are places like ->slave_close which need
to acquire the worker lock (during flush_workqueue()) and this can only
happen under rtnl. Lockdep then complains about a possible circular
dependency.

B/ Avoiding the rtnl in scan operations and allowing the reverse
dependency, which is scan_lock -> rtnl

I've drafted this solution because I think the scan operation do not
really need the rtnl. This idea got reinforced when I found this
wireless change: a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver").

But unfortunately I get the same issue again, with the ->close()
implementation which needs to acquire the worker lock to flush, this
makes a rtnl -> worker_lock dependency which is incompatible with a
worker_lock -> scan_lock -> rtnl chain (this is is typically what should
happen when changing the channel during a scan).

So I looked at reducing the scope of scan_lock, in order to avoid
taking it for too long and avoid the scan_lock -> rtnl or rtnl ->
scan_lock dependency in the worker, but I think in the end it is a
truly bad idea.

Finally, I decided I could use another workqueue for the mac related
commands which is not the one for the data. We don't care about
flushing it because we _need_ the beacons/scan workers to be stopped,
which is handled in their dedicated helpers. Doing so removes a rtnl ->
worker_lock dependency, which allows to acquire the rtnl from the
worker. I've mostly implemented it, I'll clean all this up and send a
v2 tomorrow.

Thanks,
Miqu=C3=A8l
