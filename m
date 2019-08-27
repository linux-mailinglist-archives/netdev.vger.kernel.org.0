Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA43E9E967
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 15:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729636AbfH0Nbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 09:31:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbfH0Nbn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 09:31:43 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89BAD8B5FF0;
        Tue, 27 Aug 2019 13:31:43 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AC1B5C1B2;
        Tue, 27 Aug 2019 13:31:39 +0000 (UTC)
Date:   Tue, 27 Aug 2019 15:31:37 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/4] Introduce variable length mdev alias
Message-ID: <20190827153137.533e5d59.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866A24FF3D283F0F3CB3CDAD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <AM0PR05MB4866A24FF3D283F0F3CB3CDAD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 27 Aug 2019 13:31:43 +0000 (UTC)
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

I think the discussion of what to do with the attribute if no alias is
available is still unresolved; waiting for maintainer opinion.

> In next v1 post, I was considering to include mdev_alias() and have example use in mtty driver.
> 
> This way, subsequent series of mlx5_core who intents to use mdev_alias() API makes it easy to review and merge through Dave M, netdev tree.
> Is that ok with you?

