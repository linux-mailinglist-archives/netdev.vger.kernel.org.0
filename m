Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C08E161B2E
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 20:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbgBQTCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 14:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727739AbgBQTCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 14:02:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D92420578;
        Mon, 17 Feb 2020 19:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581966155;
        bh=1Qsc/Dl3ovawM0aItcxIk2cvE0rghJEzx03q/67sRuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sz9uzVCHj+pSlzw8HDzrCr0HBbSVK9ba87T5Crx9c37S4TPz8HYq5KptpbT5vlSYz
         sl16aldgjib4uc2fnQCvrRWPkG5XzNqJkn+ZGHBp2Ohddwvnx4p5ElPuNyX5UR8Gbv
         zjJNeDqS9fpdEBJKKjSckP7bQ3XOzcLP4kLRsu+0=
Date:   Mon, 17 Feb 2020 20:02:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v2 08/10] net-sysfs: add netdev_change_owner()
Message-ID: <20200217190231.GA1533585@kroah.com>
References: <20200217161436.1748598-1-christian.brauner@ubuntu.com>
 <20200217161436.1748598-9-christian.brauner@ubuntu.com>
 <20200217162803.GA1502885@kroah.com>
 <20200217165854.4ywtbxbaenha3iti@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217165854.4ywtbxbaenha3iti@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 05:58:54PM +0100, Christian Brauner wrote:
> On Mon, Feb 17, 2020 at 05:28:03PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Feb 17, 2020 at 05:14:34PM +0100, Christian Brauner wrote:
> > > Add a function to change the owner of a network device when it is moved
> > > between network namespaces.
> > > 
> > > Currently, when moving network devices between network namespaces the
> > > ownership of the corresponding sysfs entries is not changed. This leads
> > > to problems when tools try to operate on the corresponding sysfs files.
> > > This leads to a bug whereby a network device that is created in a
> > > network namespaces owned by a user namespace will have its corresponding
> > > sysfs entry owned by the root user of the corresponding user namespace.
> > > If such a network device has to be moved back to the host network
> > > namespace the permissions will still be set to the user namespaces. This
> > > means unprivileged users can e.g. trigger uevents for such incorrectly
> > > owned devices. They can also modify the settings of the device itself.
> > > Both of these things are unwanted.
> > > 
> > > For example, workloads will create network devices in the host network
> > > namespace. Other tools will then proceed to move such devices between
> > > network namespaces owner by other user namespaces. While the ownership
> > > of the device itself is updated in
> > > net/core/net-sysfs.c:dev_change_net_namespace() the corresponding sysfs
> > > entry for the device is not:
> > > 
> > > drwxr-xr-x 5 nobody nobody    0 Jan 25 18:08 .
> > > drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_assign_type
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 addr_len
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 address
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 broadcast
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_changes
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_down_count
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 carrier_up_count
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_id
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dev_port
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 dormant
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 duplex
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 flags
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 gro_flush_timeout
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifalias
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 ifindex
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 iflink
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 link_mode
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 mtu
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 name_assign_type
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 netdev_group
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 operstate
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_id
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_port_name
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 phys_switch_id
> > > drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 power
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 proto_down
> > > drwxr-xr-x 4 nobody nobody    0 Jan 25 18:09 queues
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 speed
> > > drwxr-xr-x 2 nobody nobody    0 Jan 25 18:09 statistics
> > > lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:08 subsystem -> ../../../../class/net
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:09 tx_queue_len
> > > -r--r--r-- 1 nobody nobody 4096 Jan 25 18:09 type
> > > -rw-r--r-- 1 nobody nobody 4096 Jan 25 18:08 uevent
> > > 
> > > However, if a device is created directly in the network namespace then
> > > the device's sysfs permissions will be correctly updated:
> > > 
> > > drwxr-xr-x 5 root   root      0 Jan 25 18:12 .
> > > drwxr-xr-x 9 nobody nobody    0 Jan 25 18:08 ..
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_assign_type
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 addr_len
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 address
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 broadcast
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 carrier
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_changes
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_down_count
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 carrier_up_count
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_id
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 dev_port
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 dormant
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 duplex
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 flags
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 gro_flush_timeout
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 ifalias
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 ifindex
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 iflink
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 link_mode
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 mtu
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 name_assign_type
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 netdev_group
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 operstate
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_id
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_port_name
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 phys_switch_id
> > > drwxr-xr-x 2 root   root      0 Jan 25 18:12 power
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 proto_down
> > > drwxr-xr-x 4 root   root      0 Jan 25 18:12 queues
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 speed
> > > drwxr-xr-x 2 root   root      0 Jan 25 18:12 statistics
> > > lrwxrwxrwx 1 nobody nobody    0 Jan 25 18:12 subsystem -> ../../../../class/net
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 tx_queue_len
> > > -r--r--r-- 1 root   root   4096 Jan 25 18:12 type
> > > -rw-r--r-- 1 root   root   4096 Jan 25 18:12 uevent
> > > 
> > > Now, when creating a network device in a network namespace owned by a
> > > user namespace and moving it to the host the permissions will be set to
> > > the id that the user namespace root user has been mapped to on the host
> > > leading to all sorts of permission issues:
> > > 
> > > 458752
> > > drwxr-xr-x 5 458752 458752      0 Jan 25 18:12 .
> > > drwxr-xr-x 9 root   root        0 Jan 25 18:08 ..
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_assign_type
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 addr_len
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 address
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 broadcast
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_changes
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_down_count
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 carrier_up_count
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_id
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dev_port
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 dormant
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 duplex
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 flags
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 gro_flush_timeout
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 ifalias
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 ifindex
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 iflink
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 link_mode
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 mtu
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 name_assign_type
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 netdev_group
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 operstate
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_id
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_port_name
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 phys_switch_id
> > > drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 power
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 proto_down
> > > drwxr-xr-x 4 458752 458752      0 Jan 25 18:12 queues
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 speed
> > > drwxr-xr-x 2 458752 458752      0 Jan 25 18:12 statistics
> > > lrwxrwxrwx 1 root   root        0 Jan 25 18:12 subsystem -> ../../../../class/net
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 tx_queue_len
> > > -r--r--r-- 1 458752 458752   4096 Jan 25 18:12 type
> > > -rw-r--r-- 1 458752 458752   4096 Jan 25 18:12 uevent
> > > 
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > ---
> > > /* v2 */
> > > unchanged
> > > ---
> > >  net/core/net-sysfs.c | 27 +++++++++++++++++++++++++++
> > >  net/core/net-sysfs.h |  2 ++
> > >  2 files changed, 29 insertions(+)
> > > 
> > > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > > index 4c826b8bf9b1..4fda021edf6d 100644
> > > --- a/net/core/net-sysfs.c
> > > +++ b/net/core/net-sysfs.c
> > > @@ -1767,6 +1767,33 @@ int netdev_register_kobject(struct net_device *ndev)
> > >  	return error;
> > >  }
> > >  
> > > +/* Change owner for sysfs entries when moving network devices across network
> > > + * namespaces owned by different user namespaces.
> > > + */
> > > +int netdev_change_owner(struct net_device *ndev, const struct net *net_old,
> > > +			const struct net *net_new)
> > > +{
> > > +	struct device *dev = &ndev->dev;
> > > +	kuid_t old_uid, new_uid;
> > > +	kgid_t old_gid, new_gid;
> > > +	int error;
> > > +
> > > +	net_ns_get_ownership(net_old, &old_uid, &old_gid);
> > > +	net_ns_get_ownership(net_new, &new_uid, &new_gid);
> > > +
> > > +	/* The network namespace was changed but the owning user namespace is
> > > +	 * identical so there's no need to change the owner of sysfs entries.
> > > +	 */
> > > +	if (uid_eq(old_uid, new_uid) && gid_eq(old_gid, new_gid))
> > > +		return 0;
> > > +
> > > +	error = device_change_owner(dev);
> > 
> > Ok, maybe I'm slow here, but what actually changed the gid/uid here?
> > How did it change?  All you did was look up the old uid/gid and the new
> > uid/gid.  But what set the device to the new one?
> > 
> > All of these functions are just really odd to me, one would think that a
> > "change owner" function would have the new owner in the paramter to know
> > what to change it to?  Your documentation says "owner must be changed
> > before calling this function", but how did that get changed and who
> > changed it?
> > 
> > Why not just pass it as part of the function itself?
> > 
> > Otherwise it looks really odd, like the above call.  As I can't see how
> > anything changes here at all by reading this code.  And that's a huge
> > sign of a bad API, when the maintainer of the subsystem can not even
> > understand how someone is using it with a single function call :)
> 
> So we've been briefly discussing this in the first iteration of this
> series where I also explained why I in the first iteration I didn't add
> explicit uid_t and gid_t parameters. I sugggested adding uid_t/gid_t
> parameters in that thread but from your response in
> https://lore.kernel.org/lkml/20200212160402.GA1799124@kroah.com/:
> 
> > > So ownership only changes if the kobject's uid/gid have been changed.
> > > So when to stick with the networking example, when a network device is
> > > moved into a new network namespace, the uid/gid of the kobject will be
> > > changed to the root user of the owning user namespace of that network
> > > namespace. So when the move of the network device has completed and
> > > kobject_get_ownership() is called it will now return a different
> > > uid/gid.
> > 
> > Ok, then this needs to say "change the uid/gid of the kobject to..." in
> > order to explain what it is now being set to.  Otherwise this is really
> > confusing if you only read the kerneldoc, right?
> 
> From this answer I took it that you did prefer not adding uid/gid
> parameters. If that has changed or I misunderstood you then I can change
> all these functions.

Sorry for the confusion.  Yes, the documentation is better now, but the
function parameters are still just as bad.  I think you need to add
uid/gid to the parameters to make it obvious what is happening for when
you just read the code, without seeing the function comments as no one
is going to dig them up somewhere else in another file.

> For clarity, for network namespaces: when the move of a network device
> has completed dev_change_net_namespace() is called which changes the
> ownership of the kobject associated with the net device. Now
> kobject_get_ownership() will return the updated uids/gids. In any case,
> asking explicitly: do you want to have those sysfs and device functions
> take explicit uid and gid parameters?

Yes please.

> That sounds nicer to me as well. I just didn't want to expose it
> because we alreay had this dynamic way of setting ownership via
> kobject_get_ownership(). 

I think that's totally not intutive :)

thanks,

greg k-h
