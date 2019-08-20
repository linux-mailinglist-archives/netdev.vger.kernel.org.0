Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47359666B
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 18:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbfHTQbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 12:31:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbfHTQbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 12:31:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E68BEC057F2E;
        Tue, 20 Aug 2019 16:31:13 +0000 (UTC)
Received: from gondolin (ovpn-116-201.ams2.redhat.com [10.36.116.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 301329CC9;
        Tue, 20 Aug 2019 16:31:08 +0000 (UTC)
Date:   Tue, 20 Aug 2019 18:31:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190820183106.1680d0d9.cohuck@redhat.com>
In-Reply-To: <AM0PR05MB4866EBB51F7019F2E3D9918CD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814100135.1f60aa42.cohuck@redhat.com>
        <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814150911.296da78c.cohuck@redhat.com>
        <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814085746.26b5f2a3@x1.home>
        <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <m1o90kduow.fsf@dinechin.org>
        <AM0PR05MB4866EBB51F7019F2E3D9918CD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 20 Aug 2019 16:31:14 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 11:25:05 +0000
Parav Pandit <parav@mellanox.com> wrote:

> > -----Original Message-----
> > From: Christophe de Dinechin <christophe.de.dinechin@gmail.com>
> > Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
> > 
> > 
> > Parav Pandit writes:
> >   
> > > + Dave.
> > >
> > > Hi Jiri, Dave, Alex, Kirti, Cornelia,
> > >
> > > Please provide your feedback on it, how shall we proceed?
> > >
> > > Hence, I would like to discuss below options.
> > >
> > > Option-1: mdev index
> > > Introduce an optional mdev index/handle as u32 during mdev create time.
> > > User passes mdev index/handle as input.
> > >
> > > phys_port_name=mIndex=m%u
> > > mdev_index will be available in sysfs as mdev attribute for udev to name the  
> > mdev's netdev.  
> > >
> > > example mdev create command:
> > > UUID=$(uuidgen)
> > > echo $UUID index=10 >
> > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > > example netdevs:
> > > repnetdev=ens2f0_m10	/*ens2f0 is parent PF's netdevice */
> > > mdev_netdev=enm10
> > >
> > > Pros:
> > > 1. mdevctl and any other existing tools are unaffected.
> > > 2. netdev stack, ovs and other switching platforms are unaffected.
> > > 3. achieves unique phys_port_name for representor netdev 4. achieves
> > > unique mdev eth netdev name for the mdev using udev/systemd extension.
> > > 5. Aligns well with mdev and netdev subsystem and similar to existing sriov  
> > bdf's.  
> > >
> > > Option-2: shorter mdev name
> > > Extend mdev to have shorter mdev device name in addition to UUID.
> > > such as 'foo', 'bar'.
> > > Mdev will continue to have UUID.

I fail to understand how 'uses uuid' and 'allow shorter device name'
are supposed to play together?

> > > phys_port_name=mdev_name
> > >
> > > Pros:
> > > 1. All same as option-1, except mdevctl needs upgrade for newer usage.
> > > It is common practice to upgrade iproute2 package along with the kernel.
> > > Similar practice to be done with mdevctl.
> > > 2. Newer users of mdevctl who wants to work with non_UUID names, will use  
> > newer mdevctl/tools.  
> > > Cons:
> > > 1. Dual naming scheme of mdev might affect some of the existing tools.
> > > It's unclear how/if it actually affects.
> > > mdevctl [2] is very recently developed and can be enhanced for dual naming  
> > scheme.  

The main problem is not tools we know about (i.e. mdevctl), but those we
don't know about.

IOW, this (and the IFNAMESIZ change, which seems even worse) are the
options I would not want at all.

> > >
> > > Option-3: mdev uuid alias
> > > Instead of shorter mdev name or mdev index, have alpha-numeric name  
> > alias.  
> > > Alias is an optional mdev sysfs attribute such as 'foo', 'bar'.
> > > example mdev create command:
> > > UUID=$(uuidgen)
> > > echo $UUID alias=foo >
> > > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > > example netdevs:
> > > examle netdevs:
> > > repnetdev = ens2f0_mfoo
> > > mdev_netdev=enmfoo
> > >
> > > Pros:
> > > 1. All same as option-1.
> > > 2. Doesn't affect existing mdev naming scheme.
> > > Cons:
> > > 1. Index scheme of option-1 is better which can number large number of  
> > mdevs with fewer characters, simplifying the management tool.
> > 
> > I believe that Alex pointed out another "Cons" to all three options, which is that
> > it forces user-space to resolve potential race conditions when creating an index
> > or short name or alias.
> >   
> This race condition exists for at least two subsystems that I know of, i.e. netdev and rdma.
> If a device with a given name exists, subsystem returns error.
> When user space gets error code EEXIST, and it can picks up different identifier(s).

If you decouple device creation and setting the alias/index, you make
the issue visible and thus much more manageable.

> 
> > Also, what happens if `index=10` is not provided on the command-line?
> > Does that make the device unusable for your purpose?  
> Yes, it is unusable to an extent.
> Currently we have DEVLINK_PORT_FLAVOUR_PCI_VF in include/uapi/linux/devlink.h
> Similar to it, we need to have DEVLINK_PORT_FLAVOUR_MDEV for mdev eswitch ports.
> This port flavour needs to generate phys_port_name(). This should be user parameter driven.
> Because representor netdevice name is generated based on this parameter.

I'm also unsure how the extra parameter is supposed to work; writing it
to the create attribute does not sound right.

mdevctl supports setting additional parameters on an already created
device (see the examples provided for vfio-ap), so going that route
would actually work out of the box from the tooling side.

What you would need is some kind of synchronization/locking to make
sure that you only link up to the other device after the extra
attribute has been set and that you don't allow to change it as long as
it is associated with the other side. I do not know enough about the
actual devices to suggest something here; if you need userspace
cooperation, maybe uevents would be an option.
