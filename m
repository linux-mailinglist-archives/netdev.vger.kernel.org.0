Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD1DB01AA
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfIKQaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:30:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48342 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbfIKQaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 12:30:14 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64779306E171;
        Wed, 11 Sep 2019 16:30:13 +0000 (UTC)
Received: from gondolin (ovpn-116-29.ams2.redhat.com [10.36.116.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DCF460C5E;
        Wed, 11 Sep 2019 16:30:03 +0000 (UTC)
Date:   Wed, 11 Sep 2019 18:29:58 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
Message-ID: <20190911182958.042cd03a.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190911145610.453b32ec@x1.home>
        <AM0PR05MB48668DFF8E816F0D2D3041BFD1B10@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 11 Sep 2019 16:30:13 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Sep 2019 15:30:40 +0000
Parav Pandit <parav@mellanox.com> wrote:

> Hi Alex,
> 
> > -----Original Message-----
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Wednesday, September 11, 2019 8:56 AM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; kwankhede@nvidia.com;
> > cohuck@redhat.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> > kernel@vger.kernel.org; netdev@vger.kernel.org
> > Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
> > 
> > On Mon, 9 Sep 2019 20:42:32 +0000
> > Parav Pandit <parav@mellanox.com> wrote:
> >   
> > > Hi Alex,
> > >  
> > > > -----Original Message-----
> > > > From: Parav Pandit <parav@mellanox.com>
> > > > Sent: Sunday, September 1, 2019 11:25 PM
> > > > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > > > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > > > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > > > Subject: [PATCH v3 0/5] Introduce variable length mdev alias
> > > >
> > > > To have consistent naming for the netdevice of a mdev and to have
> > > > consistent naming of the devlink port [1] of a mdev, which is formed
> > > > using phys_port_name of the devlink port, current UUID is not usable
> > > > because UUID is too long.
> > > >
> > > > UUID in string format is 36-characters long and in binary 128-bit.
> > > > Both formats are not able to fit within 15 characters limit of netdev  
> > name.  
> > > >
> > > > It is desired to have mdev device naming consistent using UUID.
> > > > So that widely used user space framework such as ovs [2] can make
> > > > use of mdev representor in similar way as PCIe SR-IOV VF and PF  
> > representors.  
> > > >
> > > > Hence,
> > > > (a) mdev alias is created which is derived using sha1 from the mdev  
> > name.  
> > > > (b) Vendor driver describes how long an alias should be for the
> > > > child mdev created for a given parent.
> > > > (c) Mdev aliases are unique at system level.
> > > > (d) alias is created optionally whenever parent requested.
> > > > This ensures that non networking mdev parents can function without
> > > > alias creation overhead.
> > > >
> > > > This design is discussed at [3].
> > > >
> > > > An example systemd/udev extension will have,
> > > >
> > > > 1. netdev name created using mdev alias available in sysfs.
> > > >
> > > > mdev UUID=83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > > > mdev 12 character alias=cd5b146a80a5
> > > >
> > > > netdev name of this mdev = enmcd5b146a80a5 Here en = Ethernet link m
> > > > = mediated device
> > > >
> > > > 2. devlink port phys_port_name created using mdev alias.
> > > > devlink phys_port_name=pcd5b146a80a5
> > > >
> > > > This patchset enables mdev core to maintain unique alias for a mdev.
> > > >
> > > > Patch-1 Introduces mdev alias using sha1.
> > > > Patch-2 Ensures that mdev alias is unique in a system.
> > > > Patch-3 Exposes mdev alias in a sysfs hirerchy, update Documentation
> > > > Patch-4 Introduces mdev_alias() API.
> > > > Patch-5 Extends mtty driver to optionally provide alias generation.
> > > > This also enables to test UUID based sha1 collision and trigger
> > > > error handling for duplicate sha1 results.
> > > >
> > > > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > > > [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > > > [3] https://patchwork.kernel.org/cover/11084231/
> > > >
> > > > ---
> > > > Changelog:
> > > > v2->v3:
> > > >  - Addressed comment from Yunsheng Lin
> > > >  - Changed strcmp() ==0 to !strcmp()
> > > >  - Addressed comment from Cornelia Hunk
> > > >  - Merged sysfs Documentation patch with syfs patch
> > > >  - Added more description for alias return value  
> > >
> > > Did you get a chance review this updated series?
> > > I addressed Cornelia's and yours comment.
> > > I do not think allocating alias memory twice, once for comparison and
> > > once for storing is good idea or moving alias generation logic inside
> > > the mdev_list_lock(). So I didn't address that suggestion of Cornelia.  
> > 
> > Sorry, I'm at LPC this week.  I agree, I don't think the double allocation is
> > necessary, I thought the comment was sufficient to clarify null'ing the
> > variable.  It's awkward, but seems correct.

Not hot about it, but no real complaints.

However, please give me some more time, as I'm at LPC as well.

> > 
> > I'm not sure what we do with this patch series though, has the real
> > consumer of this even been proposed?  It feels optimistic to include at this
> > point.  We've used the sample driver as a placeholder in the past for
> > mdev_uuid(), but we arrived at that via a conversion rather than explicitly
> > adding the API.  Please let me know where the consumer patches stand,
> > perhaps it would make more sense for them to go in together rather than
> > risk adding an unused API.  Thanks,
> >   
> Given that consumer patch series is relatively large (around 15+ patches), I was considering to merge this one as pre-series to it.
> Its ok to combine this with consumer patch series.
> But wanted to have it reviewed beforehand, so that churn is less in actual consumer series which is more mlx5_core and devlink/netdev centric.
> So if you can add Review-by, it will be easier to combine with consumer series.
> 
> And if we merge it with consumer series, it will come through Dave Miller's tree instead of your tree.
> Would that work for you?

It would be easier to see what to do here if we could see the consumer
for this. If those patches are fine, we could maybe queue this series
via both trees?
