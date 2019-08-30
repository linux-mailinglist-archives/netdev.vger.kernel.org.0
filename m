Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E1A36E7
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfH3Mjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 08:39:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfH3Mjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 08:39:35 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 364933083363;
        Fri, 30 Aug 2019 12:39:34 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A4B25D772;
        Fri, 30 Aug 2019 12:39:29 +0000 (UTC)
Date:   Fri, 30 Aug 2019 14:39:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
Message-ID: <20190830143927.163d13a7.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190829111904.16042-1-parav@mellanox.com>
        <20190829111904.16042-2-parav@mellanox.com>
        <20190830111720.04aa54e9.cohuck@redhat.com>
        <AM0PR05MB48660877881F7A2D757A9C82D1BD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 30 Aug 2019 12:39:34 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Aug 2019 12:33:22 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Cornelia Huck <cohuck@redhat.com>
> > Sent: Friday, August 30, 2019 2:47 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH v2 1/6] mdev: Introduce sha1 based mdev alias
> > 
> > On Thu, 29 Aug 2019 06:18:59 -0500
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > Some vendor drivers want an identifier for an mdev device that is
> > > shorter than the UUID, due to length restrictions in the consumers of
> > > that identifier.
> > >
> > > Add a callback that allows a vendor driver to request an alias of a
> > > specified length to be generated for an mdev device. If generated,
> > > that alias is checked for collisions.
> > >
> > > It is an optional attribute.
> > > mdev alias is generated using sha1 from the mdev name.
> > >
> > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > >
> > > ---
> > > Changelog:
> > > v1->v2:
> > >  - Kept mdev_device naturally aligned
> > >  - Added error checking for crypt_*() calls
> > >  - Corrected a typo from 'and' to 'an'
> > >  - Changed return type of generate_alias() from int to char*
> > > v0->v1:
> > >  - Moved alias length check outside of the parent lock
> > >  - Moved alias and digest allocation from kvzalloc to kzalloc
> > >  - &alias[0] changed to alias
> > >  - alias_length check is nested under get_alias_length callback check
> > >  - Changed comments to start with an empty line
> > >  - Fixed cleaunup of hash if mdev_bus_register() fails
> > >  - Added comment where alias memory ownership is handed over to mdev
> > > device
> > >  - Updated commit log to indicate motivation for this feature
> > > ---
> > >  drivers/vfio/mdev/mdev_core.c    | 123  
> > ++++++++++++++++++++++++++++++-  
> > >  drivers/vfio/mdev/mdev_private.h |   5 +-
> > >  drivers/vfio/mdev/mdev_sysfs.c   |  13 ++--
> > >  include/linux/mdev.h             |   4 +
> > >  4 files changed, 135 insertions(+), 10 deletions(-)

> > ...and detached from the local variable here. Who is freeing it? The comment
> > states that it is done by the mdev, but I don't see it?
> >   
> mdev_device_free() frees it.

Ah yes, I overlooked the kfree().

> once its assigned to mdev, mdev is the owner of it.
> 
> > This detour via the local variable looks weird to me. Can you either create the
> > alias directly in the mdev (would need to happen later in the function, but I'm
> > not sure why you generate the alias before checking for duplicates anyway), or
> > do an explicit copy?  
> Alias duplicate check is done after generating it, because duplicate alias are not allowed.
> The probability of collision is rare.
> So it is speculatively generated without hold the lock, because there is no need to hold the lock.
> It is compared along with guid while mutex lock is held in single loop.
> And if it is duplicate, there is no need to allocate mdev.
> 
> It will be sub optimal to run through the mdev list 2nd time after mdev creation and after generating alias for duplicate check.

Ok, but what about copying it? I find this "set local variable to NULL
after ownership is transferred" pattern a bit unintuitive. Copying it
to the mdev (and then unconditionally freeing it) looks more obvious to
me.
