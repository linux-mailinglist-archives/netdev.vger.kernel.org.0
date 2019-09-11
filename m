Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8B2AFE26
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfIKN4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:56:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfIKN4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 09:56:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9D0830044CE;
        Wed, 11 Sep 2019 13:56:15 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D27AA608AB;
        Wed, 11 Sep 2019 13:56:11 +0000 (UTC)
Date:   Wed, 11 Sep 2019 14:56:10 +0100
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] Introduce variable length mdev alias
Message-ID: <20190911145610.453b32ec@x1.home>
In-Reply-To: <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190902042436.23294-1-parav@mellanox.com>
        <AM0PR05MB4866F76F807409ED887537D7D1B70@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 11 Sep 2019 13:56:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Sep 2019 20:42:32 +0000
Parav Pandit <parav@mellanox.com> wrote:

> Hi Alex,
> 
> > -----Original Message-----
> > From: Parav Pandit <parav@mellanox.com>
> > Sent: Sunday, September 1, 2019 11:25 PM
> > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > Subject: [PATCH v3 0/5] Introduce variable length mdev alias
> > 
> > To have consistent naming for the netdevice of a mdev and to have consistent
> > naming of the devlink port [1] of a mdev, which is formed using
> > phys_port_name of the devlink port, current UUID is not usable because UUID
> > is too long.
> > 
> > UUID in string format is 36-characters long and in binary 128-bit.
> > Both formats are not able to fit within 15 characters limit of netdev name.
> > 
> > It is desired to have mdev device naming consistent using UUID.
> > So that widely used user space framework such as ovs [2] can make use of
> > mdev representor in similar way as PCIe SR-IOV VF and PF representors.
> > 
> > Hence,
> > (a) mdev alias is created which is derived using sha1 from the mdev name.
> > (b) Vendor driver describes how long an alias should be for the child mdev
> > created for a given parent.
> > (c) Mdev aliases are unique at system level.
> > (d) alias is created optionally whenever parent requested.
> > This ensures that non networking mdev parents can function without alias
> > creation overhead.
> > 
> > This design is discussed at [3].
> > 
> > An example systemd/udev extension will have,
> > 
> > 1. netdev name created using mdev alias available in sysfs.
> > 
> > mdev UUID=83b8f4f2-509f-382f-3c1e-e6bfe0fa1001
> > mdev 12 character alias=cd5b146a80a5
> > 
> > netdev name of this mdev = enmcd5b146a80a5 Here en = Ethernet link m =
> > mediated device
> > 
> > 2. devlink port phys_port_name created using mdev alias.
> > devlink phys_port_name=pcd5b146a80a5
> > 
> > This patchset enables mdev core to maintain unique alias for a mdev.
> > 
> > Patch-1 Introduces mdev alias using sha1.
> > Patch-2 Ensures that mdev alias is unique in a system.
> > Patch-3 Exposes mdev alias in a sysfs hirerchy, update Documentation
> > Patch-4 Introduces mdev_alias() API.
> > Patch-5 Extends mtty driver to optionally provide alias generation.
> > This also enables to test UUID based sha1 collision and trigger error handling
> > for duplicate sha1 results.
> > 
> > [1] http://man7.org/linux/man-pages/man8/devlink-port.8.html
> > [2] https://docs.openstack.org/os-vif/latest/user/plugins/ovs.html
> > [3] https://patchwork.kernel.org/cover/11084231/
> > 
> > ---
> > Changelog:
> > v2->v3:
> >  - Addressed comment from Yunsheng Lin
> >  - Changed strcmp() ==0 to !strcmp()
> >  - Addressed comment from Cornelia Hunk
> >  - Merged sysfs Documentation patch with syfs patch
> >  - Added more description for alias return value  
> 
> Did you get a chance review this updated series?
> I addressed Cornelia's and yours comment.
> I do not think allocating alias memory twice, once for comparison and
> once for storing is good idea or moving alias generation logic inside
> the mdev_list_lock(). So I didn't address that suggestion of
> Cornelia. 

Sorry, I'm at LPC this week.  I agree, I don't think the double
allocation is necessary, I thought the comment was sufficient to
clarify null'ing the variable.  It's awkward, but seems correct.

I'm not sure what we do with this patch series though, has the real
consumer of this even been proposed?  It feels optimistic to include at
this point.  We've used the sample driver as a placeholder in the past
for mdev_uuid(), but we arrived at that via a conversion rather than
explicitly adding the API.  Please let me know where the consumer
patches stand, perhaps it would make more sense for them to go in
together rather than risk adding an unused API.  Thanks,

Alex

> > v1->v2:
> >  - Corrected a typo from 'and' to 'an'
> >  - Addressed comments from Alex Williamson
> >  - Kept mdev_device naturally aligned
> >  - Added error checking for crypt_*() calls
> >  - Moved alias NULL check at beginning
> >  - Added mdev_alias() API
> >  - Updated mtty driver to show example mdev_alias() usage
> >  - Changed return type of generate_alias() from int to char*
> > v0->v1:
> >  - Addressed comments from Alex Williamson, Cornelia Hunk and Mark
> > Bloch
> >  - Moved alias length check outside of the parent lock
> >  - Moved alias and digest allocation from kvzalloc to kzalloc
> >  - &alias[0] changed to alias
> >  - alias_length check is nested under get_alias_length callback
> > check
> >  - Changed comments to start with an empty line
> >  - Added comment where alias memory ownership is handed over to mdev
> > device
> >  - Fixed cleaunup of hash if mdev_bus_register() fails
> >  - Updated documentation for new sysfs alias file
> >  - Improved commit logs to make description more clear
> >  - Fixed inclusiong of alias for NULL check
> >  - Added ratelimited debug print for sha1 hash collision error
> > 
> > Parav Pandit (5):
> >   mdev: Introduce sha1 based mdev alias
> >   mdev: Make mdev alias unique among all mdevs
> >   mdev: Expose mdev alias in sysfs tree
> >   mdev: Introduce an API mdev_alias
> >   mtty: Optionally support mtty alias
> > 
> >  .../driver-api/vfio-mediated-device.rst       |   9 ++
> >  drivers/vfio/mdev/mdev_core.c                 | 142
> > +++++++++++++++++- drivers/vfio/mdev/mdev_private.h
> > |   5 +- drivers/vfio/mdev/mdev_sysfs.c                |  26 +++-
> >  include/linux/mdev.h                          |   5 +
> >  samples/vfio-mdev/mtty.c                      |  13 ++
> >  6 files changed, 190 insertions(+), 10 deletions(-)
> > 
> > --
> > 2.19.2  
> 

