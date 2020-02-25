Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2E3716C1C5
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730293AbgBYNKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:10:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:32807 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727983AbgBYNKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:10:08 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j6ZyO-0007LA-AG; Tue, 25 Feb 2020 13:10:04 +0000
Date:   Tue, 25 Feb 2020 14:10:03 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 0/9] net: fix sysfs permssions when device changes
 network
Message-ID: <20200225131003.3bhtzydbzve3v3ad@wittgenstein>
References: <20200225124948.80682-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200225124948.80682-1-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 01:49:39PM +0100, Christian Brauner wrote:
> Hey everyone,
> 
> /* v5 */
> This is v5 with a small fixup requested by Rafael.
> 
> /* v4 */
> This is v4 with more documentation and other fixes that Greg requested.
> 
> /* v3 */
> This is v3 with explicit uid and gid parameters added to functions that
> change sysfs object ownership as Greg requested.
> 
> (I've tagged this with net-next since it's triggered by a bug for
>  network device files but it also touches driver core aspects so it's
>  not clear-cut. I can of course split this series into separate
>  patchsets.) 
> We have been struggling with a bug surrounding the ownership of network
> device sysfs files when moving network devices between network
> namespaces owned by different user namespaces reported by multiple
> users.
> 
> Currently, when moving network devices between network namespaces the
> ownership of the corresponding sysfs entries is not changed. This leads
> to problems when tools try to operate on the corresponding sysfs files.
> 
> I also causes a bug when creating a network device in a network
> namespaces owned by a user namespace and moving that network device back
> to the host network namespaces. Because when a network device is created
> in a network namespaces it will be owned by the root user of the user
> namespace and all its associated sysfs files will also be owned by the
> root user of the corresponding user namespace.
> If such a network device has to be moved back to the host network
> namespace the permissions will still be set to the root user of the
> owning user namespaces of the originating network namespace. This means
> unprivileged users can e.g. re-trigger uevents for such incorrectly
> owned devices on the host or in other network namespaces. They can also
> modify the settings of the device itself through sysfs when they
> wouldn't be able to do the same through netlink. Both of these things
> are unwanted.
> 
> For example, quite a few workloads will create network devices in the
> host network namespace. Other tools will then proceed to move such
> devices between network namespaces owner by other user namespaces. While
> the ownership of the device itself is updated in
> net/core/net-sysfs.c:dev_change_net_namespace() the corresponding sysfs
> entry for the device is not. Below you'll find that moving a network
> device (here a veth device) from a network namespace into another
> network namespaces owned by a different user namespace with a different
> id mapping. As you can see the permissions are wrong even though it is
> owned by the userns root user after it has been moved and can be
> interacted with through netlink: 
> 
> drwxr-xr-x 5 nobody nobody    0 Jan 25 18:08 .
> drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_assign_type
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_len
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 address
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 broadcast
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_changes
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_down_count
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_up_count
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_id
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_port
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dormant
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 duplex
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 flags
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 gro_flush_timeout
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifalias
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifindex
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 iflink
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 link_mode
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 mtu
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 name_assign_type
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 netdev_group
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 operstate
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_id
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_name
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_switch_id
> drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 power
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 proto_down
> drwxr-xr-x 4 nobody nobody    0 Jan 25 18:09 queues
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 speed
> drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 statistics
> lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:08 subsystem -> ../../../../class/net
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 tx_queue_len
> -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 type
> -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:08 uevent
> 
> Constrast this with creating a device of the same type in the network
> namespace directly. In this case the device's sysfs permissions will be
> correctly updated.
> (Please also note, that in a lot of workloads this strategy of creating
>  the network device directly in the network device to workaround this
>  issue can not be used. Either because the network device is dedicated
>  after it has been created or because it used by a process that is
>  heavily sandboxed and couldn't create network devices itself.):
> 
> drwxr-xr-x 5 root   root      0 Jan 25 18:12 .
> drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_assign_type
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_len
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 address
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 broadcast
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 carrier
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_changes
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_down_count
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_up_count
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_id
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_port
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 dormant
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 duplex
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 flags
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 gro_flush_timeout
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 ifalias
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 ifindex
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 iflink
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 link_mode
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 mtu
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 name_assign_type
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 netdev_group
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 operstate
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_id
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_name
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_switch_id
> drwxr-xr-x 2 root   root      0 Jan 25 18:12 power
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 proto_down
> drwxr-xr-x 4 root   root      0 Jan 25 18:12 queues
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 speed
> drwxr-xr-x 2 root   root      0 Jan 25 18:12 statistics
> lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:12 subsystem -> ../../../../class/net
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 tx_queue_len
> -r--r--r-- 1 root   root   4096 Jan 25 18:12 type
> -rw-r--r-- 1 root   root   4096 Jan 25 18:12 uevent
> 
> Now, when creating a network device in a network namespace owned by a
> user namespace and moving it to the host the permissions will be set to
> the id that the user namespace root user has been mapped to on the host
> leading to all sorts of permission issues mentioned above:
> 
> 458752
> drwxr-xr-x 5 458752 458752      0 Jan 25 18:12 .
> drwxr-xr-x 9 root   root        0 Jan 25 18:08 ..
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_assign_type
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_len
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 address
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 broadcast
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_changes
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_down_count
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_up_count
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_id
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_port
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dormant
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 duplex
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 flags
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 gro_flush_timeout
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 ifalias
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 ifindex
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 iflink
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 link_mode
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 mtu
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 name_assign_type
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 netdev_group
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 operstate
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_id
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_name
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_switch_id
> drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 power
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 proto_down
> drwxr-xr-x 4 458752 458752      0 Jan 25 18:12 queues
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 speed
> drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 statistics
> lrwxrwxrwx 1 root   root        0 Jan 25 18:12 subsystem -> ../../../../class/net
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 tx_queue_len
> -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 type
> -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 uevent
> 
> Fix this by changing the basic sysfs files associated with network
> devices when moving them between network namespaces. To this end we add
> some infrastructure to sysfs.
> 
> The patchset takes care to only do this when the owning user namespaces
> changes and the kids differ. So there's only a performance overhead,
> when the owning user namespace of the network namespace is different
> __and__ the kid mappings for the root user are different for the two
> user namespaces:
> Assume we have a netdev eth0 which we create in netns1 owned by userns1.
> userns1 has an id mapping of 0 100000 100000. Now we move eth0 into
> netns2 which is owned by userns2 which also defines an id mapping of 0
> 100000 100000. In this case sysfs doesn't need updating. The patch will
> handle this case and not do any needless work. Now assume eth0 is moved
> into netns3 which is owned by userns3 which defines an id mapping of 0
> 123456 65536. In this case the root user in each namespace corresponds
> to different kid and sysfs needs updating.
> 
> Thanks!
> Christian
> 
> Christian Brauner (9):
>   sysfs: add sysfs_file_change_owner_by_name()

I just realized that the commit message here somehow slipped through
the cracks and still references the old name of the function.

>   sysfs: add sysfs_link_change_owner()
>   sysfs: add sysfs_group{s}_change_owner()
>   sysfs: add sysfs_change_owner()
>   device: add device_change_owner()
>   drivers/base/power: add dpm_sysfs_change_owner()

Also gives me a reason to make the dpm helper inline.

Sorry, will resend in a bit.

Christian
