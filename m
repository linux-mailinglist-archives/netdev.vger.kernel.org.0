Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91A09F015
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 18:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbfH0QYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 12:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726522AbfH0QYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 12:24:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 320803082126;
        Tue, 27 Aug 2019 16:24:36 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2295DC18;
        Tue, 27 Aug 2019 16:24:35 +0000 (UTC)
Date:   Tue, 27 Aug 2019 10:24:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
Message-ID: <20190827102435.7bd30ef3@x1.home>
In-Reply-To: <AM0PR05MB486671BB1CD562D070F0C0F2D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-3-parav@mellanox.com>
        <20190827122928.752e763b.cohuck@redhat.com>
        <AM0PR05MB486621458EC71973378CD5A0D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190827132946.0b92d259.cohuck@redhat.com>
        <20190827092855.29702347@x1.home>
        <AM0PR05MB486671BB1CD562D070F0C0F2D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 27 Aug 2019 16:24:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 16:13:27 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, August 27, 2019 8:59 PM
> > To: Cornelia Huck <cohuck@redhat.com>
> > Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all mdevs
> > 
> > On Tue, 27 Aug 2019 13:29:46 +0200
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Tue, 27 Aug 2019 11:08:59 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >  
> > > > > -----Original Message-----
> > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > Sent: Tuesday, August 27, 2019 3:59 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH 2/4] mdev: Make mdev alias unique among all
> > > > > mdevs
> > > > >
> > > > > On Mon, 26 Aug 2019 15:41:17 -0500 Parav Pandit
> > > > > <parav@mellanox.com> wrote:
> > > > >  
> > > > > > Mdev alias should be unique among all the mdevs, so that when
> > > > > > such alias is used by the mdev users to derive other objects,
> > > > > > there is no collision in a given system.
> > > > > >
> > > > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > > > ---
> > > > > >  drivers/vfio/mdev/mdev_core.c | 5 +++++
> > > > > >  1 file changed, 5 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/vfio/mdev/mdev_core.c
> > > > > > b/drivers/vfio/mdev/mdev_core.c index e825ff38b037..6eb37f0c6369
> > > > > > 100644
> > > > > > --- a/drivers/vfio/mdev/mdev_core.c
> > > > > > +++ b/drivers/vfio/mdev/mdev_core.c
> > > > > > @@ -375,6 +375,11 @@ int mdev_device_create(struct kobject *kobj,  
> > struct  
> > > > > device *dev,  
> > > > > >  			ret = -EEXIST;
> > > > > >  			goto mdev_fail;
> > > > > >  		}
> > > > > > +		if (tmp->alias && strcmp(tmp->alias, alias) == 0) {  
> > > > >
> > > > > Any way we can relay to the caller that the uuid was fine, but
> > > > > that we had a hash collision? Duplicate uuids are much more obvious than  
> > a collision here.  
> > > > >  
> > > > How do you want to relay this rare event?
> > > > Netlink interface has way to return the error message back, but sysfs is  
> > limited due to its error code based interface.  
> > >
> > > I don't know, that's why I asked :)
> > >
> > > The problem is that "uuid already used" and "hash collision" are
> > > indistinguishable. While "use a different uuid" will probably work in
> > > both cases, "increase alias length" might be a good alternative in
> > > some cases.
> > >
> > > But if there is no good way to relay the problem, we can live with it.  
> > 
> > It's a rare event, maybe just dev_dbg(dev, "Hash collision creating alias \"%s\"
> > for mdev device %pUl\n",...
> >   
> Ok.
> dev_dbg_once() to avoid message flood.

I'd suggest a rate-limit rather than a once.  The fact that the kernel
may have experienced a collision at some time in the past does not help
someone debug why they can't create a device now.  The only way we're
going to get a flood is if a user sufficiently privileged to create
mdev devices stumbles onto a collision and continues to repeat the same
operation.  That falls into shoot-yourself-in-the-foot behavior imo.
Thanks,

Alex
