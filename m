Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC0D161865
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 17:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgBQQ66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 11:58:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50128 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgBQQ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 11:58:57 -0500
Received: from ip5f5bf7ec.dynamic.kabel-deutschland.de ([95.91.247.236] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1j3jjS-0008Eq-RA; Mon, 17 Feb 2020 16:58:54 +0000
Date:   Mon, 17 Feb 2020 17:58:54 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/10] net-sysfs: add netdev_change_owner()
Message-ID: <20200217165854.4ywtbxbaenha3iti@wittgenstein>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
 <20200217161436.1748598-9-christian.brauner@ubuntu.com>
 <20200217162803.GA1502885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200217162803.GA1502885@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 05:28:03PM +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 17, 2020 at 05:14:34PM +0100, Christian Brauner wrote:
> > Add a function to change the owner of a network device when it is moved
> > between network namespaces.
> > 
> > Currently, when moving network devices between network namespaces the
> > ownership of the corresponding sysfs entries is not changed. This leads
> > to problems when tools try to operate on the corresponding sysfs files.
> > This leads to a bug whereby a network device that is created in a
> > network namespaces owned by a user namespace will have its corresponding
> > sysfs entry owned by the root user of the corresponding user namespace.
> > If such a network device has to be moved back to the host network
> > namespace the permissions will still be set to the user namespaces. This
> > means unprivileged users can e.g. trigger uevents for such incorrectly
> > owned devices. They can also modify the settings of the device itself.
> > Both of these things are unwanted.
> > 
> > For example, workloads will create network devices in the host network
> > namespace. Other tools will then proceed to move such devices between
> > network namespaces owner by other user namespaces. While the ownership
> > of the device itself is updated in
> > net/core/net-sysfs.c:dev_change_net_namespace() the corresponding sysfs
> > entry for the device is not:
> > 
> > drwxr-xr-x 5 nobody nobody    0 Jan 25 18:08 .
> > drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_assign_type
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_len
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 address
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 broadcast
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_changes
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_down_count
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_up_count
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_id
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_port
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dormant
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 duplex
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 flags
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 gro_flush_timeout
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifalias
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifindex
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 iflink
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 link_mode
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 mtu
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 name_assign_type
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 netdev_group
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 operstate
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_id
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_name
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_switch_id
> > drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 power
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 proto_down
> > drwxr-xr-x 4 nobody nobody    0 Jan 25 18:09 queues
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 speed
> > drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 statistics
> > lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:08 subsystem -> ../../../../class/net
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 tx_queue_len
> > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 type
> > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:08 uevent
> > 
> > However, if a device is created directly in the network namespace then
> > the device's sysfs permissions will be correctly updated:
> > 
> > drwxr-xr-x 5 root   root      0 Jan 25 18:12 .
> > drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_assign_type
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_len
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 address
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 broadcast
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 carrier
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_changes
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_down_count
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_up_count
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_id
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_port
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 dormant
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 duplex
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 flags
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 gro_flush_timeout
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 ifalias
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 ifindex
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 iflink
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 link_mode
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 mtu
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 name_assign_type
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 netdev_group
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 operstate
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_id
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_name
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_switch_id
> > drwxr-xr-x 2 root   root      0 Jan 25 18:12 power
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 proto_down
> > drwxr-xr-x 4 root   root      0 Jan 25 18:12 queues
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 speed
> > drwxr-xr-x 2 root   root      0 Jan 25 18:12 statistics
> > lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:12 subsystem -> ../../../../class/net
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 tx_queue_len
> > -r--r--r-- 1 root   root   4096 Jan 25 18:12 type
> > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 uevent
> > 
> > Now, when creating a network device in a network namespace owned by a
> > user namespace and moving it to the host the permissions will be set to
> > the id that the user namespace root user has been mapped to on the host
> > leading to all sorts of permission issues:
> > 
> > 458752
> > drwxr-xr-x 5 458752 458752      0 Jan 25 18:12 .
> > drwxr-xr-x 9 root   root        0 Jan 25 18:08 ..
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_assign_type
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_len
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 address
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 broadcast
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_changes
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_down_count
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_up_count
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_id
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_port
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dormant
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 duplex
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 flags
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 gro_flush_timeout
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 ifalias
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 ifindex
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 iflink
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 link_mode
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 mtu
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 name_assign_type
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 netdev_group
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 operstate
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_id
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_name
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_switch_id
> > drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 power
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 proto_down
> > drwxr-xr-x 4 458752 458752      0 Jan 25 18:12 queues
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 speed
> > drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 statistics
> > lrwxrwxrwx 1 root   root        0 Jan 25 18:12 subsystem -> ../../../../class/net
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 tx_queue_len
> > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 type
> > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 uevent
> > 
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> > /* v2 */
> > unchanged
> > ---
> >  net/core/net-sysfs.c | 27 +++++++++++++++++++++++++++
> >  net/core/net-sysfs.h |  2 ++
> >  2 files changed, 29 insertions(+)
> > 
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index 4c826b8bf9b1..4fda021edf6d 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -1767,6 +1767,33 @@ int netdev_register_kobject(struct net_device *ndev)
> >  	return error;
> >  }
> >  
> > +/* Change owner for sysfs entries when moving network devices across network
> > + * namespaces owned by different user namespaces.
> > + */
> > +int netdev_change_owner(struct net_device *ndev, const struct net *net_old,
> > +			const struct net *net_new)
> > +{
> > +	struct device *dev = &ndev->dev;
> > +	kuid_t old_uid, new_uid;
> > +	kgid_t old_gid, new_gid;
> > +	int error;
> > +
> > +	net_ns_get_ownership(net_old, &old_uid, &old_gid);
> > +	net_ns_get_ownership(net_new, &new_uid, &new_gid);
> > +
> > +	/* The network namespace was changed but the owning user namespace is
> > +	 * identical so there's no need to change the owner of sysfs entries.
> > +	 */
> > +	if (uid_eq(old_uid, new_uid) && gid_eq(old_gid, new_gid))
> > +		return 0;
> > +
> > +	error = device_change_owner(dev);
> 
> Ok, maybe I'm slow here, but what actually changed the gid/uid here?
> How did it change?  All you did was look up the old uid/gid and the new
> uid/gid.  But what set the device to the new one?
> 
> All of these functions are just really odd to me, one would think that a
> "change owner" function would have the new owner in the paramter to know
> what to change it to?  Your documentation says "owner must be changed
> before calling this function", but how did that get changed and who
> changed it?
> 
> Why not just pass it as part of the function itself?
> 
> Otherwise it looks really odd, like the above call.  As I can't see how
> anything changes here at all by reading this code.  And that's a huge
> sign of a bad API, when the maintainer of the subsystem can not even
> understand how someone is using it with a single function call :)

So we've been briefly discussing this in the first iteration of this
series where I also explained why I in the first iteration I didn't add
explicit uid_t and gid_t parameters. I sugggested adding uid_t/gid_t
parameters in that thread but from your response in
https://lore.kernel.org/lkml/20200212160402.GA1799124@kroah.com/:

> > So ownership only changes if the kobject's uid/gid have been changed.
> > So when to stick with the networking example, when a network device is
> > moved into a new network namespace, the uid/gid of the kobject will be
> > changed to the root user of the owning user namespace of that network
> > namespace. So when the move of the network device has completed and
> > kobject_get_ownership() is called it will now return a different
> > uid/gid.
> 
> Ok, then this needs to say "change the uid/gid of the kobject to..." in
> order to explain what it is now being set to.  Otherwise this is really
> confusing if you only read the kerneldoc, right?

From this answer I took it that you did prefer not adding uid/gid
parameters. If that has changed or I misunderstood you then I can change
all these functions.

For clarity, for network namespaces: when the move of a network device
has completed dev_change_net_namespace() is called which changes the
ownership of the kobject associated with the net device. Now
kobject_get_ownership() will return the updated uids/gids. In any case,
asking explicitly: do you want to have those sysfs and device functions
take explicit uid and gid parameters? That sounds nicer to me as well. I
just didn't want to expose it because we alreay had this dynamic way of
setting ownership via kobject_get_ownership(). 

Thanks!
Christian
