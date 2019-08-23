Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D879B739
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436728AbfHWTny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:43:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55576 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731763AbfHWTnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 15:43:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C87D300157A;
        Fri, 23 Aug 2019 19:43:53 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CC31D5C578;
        Fri, 23 Aug 2019 19:43:51 +0000 (UTC)
Date:   Fri, 23 Aug 2019 13:43:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190823134337.37e4b215@x1.home>
In-Reply-To: <AM0PR05MB486648FF7E6624F34842E425D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190820225722.237a57d2@x1.home>
        <AM0PR05MB4866437FAA63C447CACCD7E5D1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822092903.GA2276@nanopsycho.orion>
        <AM0PR05MB4866A20F831A5D42E6C79EFED1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822095823.GB2276@nanopsycho.orion>
        <AM0PR05MB4866144FD76C302D04DA04B9D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190822121936.GC2276@nanopsycho.orion>
        <AM0PR05MB4866F9650CF73FC671972127D1A50@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823081221.GG2276@nanopsycho.orion>
        <AM0PR05MB4866DED407D6F1C653D5D560D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823082820.605deb07@x1.home>
        <AM0PR05MB4866867150DAABA422F25FF8D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823095229.210e1e84@x1.home>
        <AM0PR05MB4866E33AF7203DE47F713FAAD1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190823111641.7f928917@x1.home>
        <AM0PR05MB486648FF7E6624F34842E425D1A40@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 23 Aug 2019 19:43:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Aug 2019 18:00:30 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, August 23, 2019 10:47 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Jiri Pirko <jiri@resnulli.us>; Jiri Pirko <jiri@mellanox.com>; David S . Miller
> > <davem@davemloft.net>; Kirti Wankhede <kwankhede@nvidia.com>; Cornelia
> > Huck <cohuck@redhat.com>; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > 
> > On Fri, 23 Aug 2019 16:14:04 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > > > Idea is to have mdev alias as optional.
> > > > > Each mdev_parent says whether it wants mdev_core to generate an
> > > > > alias or not. So only networking device drivers would set it to true.
> > > > > For rest, alias won't be generated, and won't be compared either
> > > > > during creation time. User continue to provide only uuid.  
> > > >
> > > > Ok
> > > >  
> > > > > I am tempted to have alias collision detection only within
> > > > > children mdevs of the same parent, but doing so will always
> > > > > mandate to prefix in netdev name. And currently we are left with
> > > > > only 3 characters to prefix it, so that may not be good either.
> > > > > Hence, I think mdev core wide alias is better with 12 characters.  
> > > >
> > > > I suppose it depends on the API, if the vendor driver can ask the
> > > > mdev core for an alias as part of the device creation process, then
> > > > it could manage the netdev namespace for all its devices, choosing
> > > > how many characters to use, and fail the creation if it can't meet a
> > > > uniqueness requirement.  IOW, mdev-core would always provide a full
> > > > sha1 and therefore gets itself out of the uniqueness/collision aspects.
> > > >  
> > > This doesn't work. At mdev core level 20 bytes sha1 are unique, so
> > > mdev core allowed to create a mdev.  
> > 
> > The mdev vendor driver has the opportunity to fail the device creation in
> > mdev_parent_ops.create().
> >   
> That is not helpful for below reasons.
> 1. vendor driver doesn't have visibility in other vendor's alias.
> 2. Even for single vendor, it needs to maintain global list of devices to see collision.
> 3. multiple vendors needs to implement same scheme.
> 
> Mdev core should be the owner. Shifting ownership from one layer to a
> lower layer in vendor driver doesn't solve the problem (if there is
> one, which I think doesn't exist).
> 
> > > And then devlink core chooses
> > > only 6 bytes (12 characters) and there is collision. Things fall
> > > apart. Since mdev provides unique uuid based scheme, it's the mdev
> > > core's ownership to provide unique aliases.  
> > 
> > You're suggesting/contemplating multiple solutions here, 3-char
> > prefix + 12- char sha1 vs <parent netdev> + ?-char sha1.  Also, the
> > 15-char total limit is imposed by an external subsystem, where the
> > vendor driver is the gateway between that subsystem and mdev.  How
> > would mdev integrate with another subsystem that maybe only has
> > 9-chars available?  Would the vendor driver API specify "I need an
> > alias" or would it specify "I need an X-char length alias"?  
> Yes, Vendor driver should say how long the alias it wants.
> However before we implement that, I suggest let such
> vendor/user/driver arrive which needs that. Such variable length
> alias can be added at that time and even with that alias collision
> can be detected by single mdev module.

If we agree that different alias lengths are possible, then I would
request that minimally an mdev sample driver be modified to request an
alias with a length that can be adjusted without recompiling in order
to exercise the collision path.

If mdev-core is guaranteeing uniqueness, does this indicate that each
alias length constitutes a separate namespace?  ie. strictly a
strcmp(), not a strncmp() to the shorter alias.

> > Does it make sense that mdev-core would fail creation of a device
> > if there's a collision in the 12-char address space between
> > different subsystems?  For example, does enm0123456789ab really
> > collide with xyz0123456789ab?   
> I think so, because at mdev level its 12-char alias matters.
> Choosing the prefix not adding prefix is really a user space choice.
> 
> >  So if
> > mdev were to provided a 40-char sha1, is it possible that the
> > vendor driver could consume this in its create callback, truncate
> > it to the number of chars required by the vendor driver's
> > subsystem, and determine whether a collision exists?  
> We shouldn't shift the problem from mdev to multiple vendor drivers
> to detect collision.
> 
> I still think that user providing alias is better because it knows
> the use-case system in use, and eliminates these collision issue.

How is a user provided alias immune from collisions?  The burden is on
the user to provide both a unique uuid and a unique alias.  That makes
it trivial to create a collision.

> > > > > I do not understand how an extra character reduces collision,
> > > > > if that's what you meant.  
> > > >
> > > > If the default were for example 3-chars, we might already have
> > > > device 'abc'.  A collision would expose one more char of the new
> > > > device, so we might add device with alias 'abcd'.  I mentioned
> > > > previously that this leaves an issue for userspace that we can't
> > > > change the alias of device abc, so without additional
> > > > information, userspace can only determine via elimination the
> > > > mapping of alias to device, but userspace has more information
> > > > available to it in the form of sysfs links.  
> > > > > Module options are almost not encouraged anymore with other
> > > > > subsystems/drivers.  
> > > >
> > > > We don't live in a world of absolutes.  I agree that the
> > > > defaults should work in the vast majority of cases.  Requiring
> > > > a user to twiddle module options to make things work is
> > > > undesirable, verging on a bug.  A module option to enable some
> > > > specific feature, unsafe condition, or test that is outside of
> > > > the typical use case is reasonable, imo.  
> > > > > For testing collision rate, a sample user space script and
> > > > > sample mtty is easy and get us collision count too. We
> > > > > shouldn't put that using module option in production kernel.
> > > > > I practically have the code ready to play with; Changing 12
> > > > > to smaller value is easy with module reload.
> > > > >
> > > > > #define MDEV_ALIAS_LEN 12  
> > > >
> > > > If it can't be tested with a shipping binary, it probably won't
> > > > be tested.  Thanks,  
> > > It is not the role of mdev core to expose collision
> > > efficiency/deficiency of the sha1. It can be tested outside before
> > > mdev choose to use it.  
> > 
> > The testing I'm considering is the user and kernel response to a
> > collision. 
> > > I am saying we should test with 12 characters with 10,000 or more
> > > devices and see how collision occurs. Even if collision occurs,
> > > mdev returns EEXIST status indicating user to pick a different
> > > UUID for those rare conditions.  
> > 
> > The only way we're going to see collision with a 12-char sha1 is if
> > we burn the CPU cycles to find uuids that collide in that space.
> > 10,000 devices is not remotely enough to generate a collision in
> > that address space.  That puts a prerequisite in place that in
> > order to test collision, someone needs to know certain magic
> > inputs.  OTOH, if we could use a shorter abbreviation, collisions
> > are trivial to test experimentally.  Thanks, 
> Yes, and therefore a sane user who wants to create more mdevs,
> wouldn't intentionally stress it to see failures.

I don't understand this logic.  I'm simply asking that we have a way to
test the collision behavior without changing the binary.  The path
we're driving towards seems to be making this easier and easier.  If
the vendor can request an alias of a specific length, then a sample
driver with a module option to set the desired alias length to 1-char
makes it trivially easy to induce a collision.  It doesn't even need to
be exposed in a real driver.  Besides, when do we ever get to design
interfaces that only worry about sane users???  Thanks,

Alex
