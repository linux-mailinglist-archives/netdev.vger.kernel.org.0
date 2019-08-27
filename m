Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B13179F1D8
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 19:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfH0Rs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 13:48:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42486 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727401AbfH0Rs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 13:48:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5F8BD308FB82;
        Tue, 27 Aug 2019 17:48:56 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B407719D7A;
        Tue, 27 Aug 2019 17:48:55 +0000 (UTC)
Date:   Tue, 27 Aug 2019 11:48:52 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/4] Introduce variable length mdev alias
Message-ID: <20190827114852.499dd8cf@x1.home>
In-Reply-To: <AM0PR05MB4866A24FF3D283F0F3CB3CDAD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <AM0PR05MB4866A24FF3D283F0F3CB3CDAD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 27 Aug 2019 17:48:56 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 13:11:17 +0000
Parav Pandit <parav@mellanox.com> wrote:

> Hi Alex, Cornelia,
> 
> > -----Original Message-----
> > From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On Behalf
> > Of Parav Pandit
> > Sent: Tuesday, August 27, 2019 2:11 AM
> > To: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > kwankhede@nvidia.com; cohuck@redhat.com; davem@davemloft.net
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > netdev@vger.kernel.org; Parav Pandit <parav@mellanox.com>
> > Subject: [PATCH 0/4] Introduce variable length mdev alias
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
> > Patch-3 Exposes mdev alias in a sysfs hirerchy.
> > Patch-4 Extends mtty driver to optionally provide alias generation.
> > This also enables to test UUID based sha1 collision and trigger error handling
> > for duplicate sha1 results.
> > 
> > In future when networking driver wants to use mdev alias, mdev_alias() API will
> > be added to derive devlink port name.
> >   
> Now that majority of above patches looks in shape and I addressed all comments,
> In next v1 post, I was considering to include mdev_alias() and have
> example use in mtty driver.
> 
> This way, subsequent series of mlx5_core who intents to use
> mdev_alias() API makes it easy to review and merge through Dave M,
> netdev tree. Is that ok with you?

What would be the timing for the mlx5_core use case?  Can we coordinate
within the same development cycle?  I wouldn't want someone to come
clean up the sample driver and remove the API ;)  Thanks,

Alex
