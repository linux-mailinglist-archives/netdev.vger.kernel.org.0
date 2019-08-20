Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2870F96751
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 19:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfHTRTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 13:19:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44882 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfHTRTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 13:19:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB4C93175291;
        Tue, 20 Aug 2019 17:19:05 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 108365C205;
        Tue, 20 Aug 2019 17:19:05 +0000 (UTC)
Date:   Tue, 20 Aug 2019 11:19:04 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
Message-ID: <20190820111904.75515f58@x1.home>
In-Reply-To: <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808170247.1fc2c4c4@x1.home>
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
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Tue, 20 Aug 2019 17:19:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 08:58:02 +0000
Parav Pandit <parav@mellanox.com> wrote:

> + Dave.
> 
> Hi Jiri, Dave, Alex, Kirti, Cornelia,
> 
> Please provide your feedback on it, how shall we proceed?
> 
> Short summary of requirements.
> For a given mdev (mediated device [1]), there is one representor
> netdevice and devlink port in switchdev mode (similar to SR-IOV VF),
> And there is one netdevice for the actual mdev when mdev is probed.
> 
> (a) representor netdev and devlink port should be able derive
> phys_port_name(). So that representor netdev name can be built
> deterministically across reboots.
> 
> (b) for mdev's netdevice, mdev's device should have an attribute.
> This attribute can be used by udev rules/systemd or something else to
> rename netdev name deterministically.
> 
> (c) IFNAMSIZ of 16 bytes is too small to fit whole UUID.
> A simple grep IFNAMSIZ in stack hints hundreds of users of IFNAMSIZ
> in drivers, uapi, netlink, boot config area and more. Changing
> IFNAMSIZ for a mdev bus doesn't really look reasonable option to me.

How many characters do we really have to work with?  Your examples
below prepend various characters, ex. option-1 results in ens2f0_m10 or
enm10.  Do the extra 8 or 3 characters in these count against IFNAMSIZ?

> Hence, I would like to discuss below options.
> 
> Option-1: mdev index
> Introduce an optional mdev index/handle as u32 during mdev create
> time. User passes mdev index/handle as input.
> 
> phys_port_name=mIndex=m%u
> mdev_index will be available in sysfs as mdev attribute for udev to
> name the mdev's netdev.
> 
> example mdev create command:
> UUID=$(uuidgen)
> echo $UUID index=10
> > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create

Nit, IIRC previous discussions of additional parameters used comma
separators, ex. echo $UUID,index=10 >...

> > example netdevs:
> repnetdev=ens2f0_m10	/*ens2f0 is parent PF's netdevice */

Is the parent really relevant in the name?  Tools like mdevctl are
meant to provide persistence, creating the same mdev devices on the
same parent, but that's simply the easiest policy decision.  We can
also imagine that multiple parent devices might support a specified
mdev type and policies factoring in proximity, load-balancing, power
consumption, etc might be weighed such that we really don't want to
promote userspace creating dependencies on the parent association.

> mdev_netdev=enm10
> 
> Pros:
> 1. mdevctl and any other existing tools are unaffected.
> 2. netdev stack, ovs and other switching platforms are unaffected.
> 3. achieves unique phys_port_name for representor netdev
> 4. achieves unique mdev eth netdev name for the mdev using
> udev/systemd extension. 5. Aligns well with mdev and netdev subsystem
> and similar to existing sriov bdf's.

A user provided index seems strange to me.  It's not really an index,
just a user specified instance number.  Presumably you have the user
providing this because if it really were an index, then the value
depends on the creation order and persistence is lost.  Now the user
needs to both avoid uuid collision as well as "index" number
collision.  The uuid namespace is large enough to mostly ignore this,
but this is not.  This seems like a burden.

> Option-2: shorter mdev name
> Extend mdev to have shorter mdev device name in addition to UUID.
> such as 'foo', 'bar'.
> Mdev will continue to have UUID.
> phys_port_name=mdev_name
> 
> Pros:
> 1. All same as option-1, except mdevctl needs upgrade for newer usage.
> It is common practice to upgrade iproute2 package along with the
> kernel. Similar practice to be done with mdevctl.
> 2. Newer users of mdevctl who wants to work with non_UUID names, will
> use newer mdevctl/tools. Cons:
> 1. Dual naming scheme of mdev might affect some of the existing tools.
> It's unclear how/if it actually affects.
> mdevctl [2] is very recently developed and can be enhanced for dual
> naming scheme.

I think we've already nak'ed this one, the device namespace becomes
meaningless if the name becomes just a string where a uuid might be an
example string.  mdevs are named by uuid.
 
> Option-3: mdev uuid alias
> Instead of shorter mdev name or mdev index, have alpha-numeric name
> alias. Alias is an optional mdev sysfs attribute such as 'foo', 'bar'.
> example mdev create command:
> UUID=$(uuidgen)
> echo $UUID alias=foo
> > /sys/class/net/ens2f0/mdev_supported_types/mlx5_core_mdev/create
> > example netdevs:
> examle netdevs:
> repnetdev = ens2f0_mfoo
> mdev_netdev=enmfoo
> 
> Pros:
> 1. All same as option-1.
> 2. Doesn't affect existing mdev naming scheme.
> Cons:
> 1. Index scheme of option-1 is better which can number large number
> of mdevs with fewer characters, simplifying the management tool.

No better than option-1, simply a larger secondary namespace, but still
requires the user to come up with two independent names for the device.

> Option-4: extend IFNAMESZ to be 64 bytes Extended IFNAMESZ from 16 to
> 64 bytes phys_port_name=mdev_UUID_string mdev_netdev_name=enmUUID
> 
> Pros:
> 1. Doesn't require mdev extension
> Cons:
> 1. netdev stack, driver, uapi, user space, boot config wide changes
> 2. Possible user space extensions who assumed name size being 16
> characters 3. Single device type demands namesize change for all
> netdev types

What about an alias based on the uuid?  For example, we use 160-bit
sha1s daily with git (uuids are only 128-bit), but we generally don't
reference git commits with the full 20 character string.  Generally 12
characters is recommended to avoid ambiguity.  Could mdev automatically
create an abbreviated sha1 alias for the device?  If so, how many
characters should we use and what do we do on collision?  The colliding
device could add enough alias characters to disambiguate (we likely
couldn't re-alias the existing device to disambiguate, but I'm not sure
it matters, userspace has sysfs to associate aliases).  Ex.

UUID=$(uuidgen)
ALIAS=$(echo $UUID | sha1sum | colrm 13)

Since there seems to be some prefix overhead, as I ask about above in
how many characters we actually have to work with in IFNAMESZ, maybe we
start with 8 characters (matching your "index" namespace) and expand as
necessary for disambiguation.  If we can eliminate overhead in
IFNAMESZ, let's start with 12.  Thanks,

Alex
