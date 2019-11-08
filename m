Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A6CF4C42
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfKHNBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:01:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727257AbfKHNBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 08:01:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573218079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpI/ahUOZhhlk3+f5KkOU8l+IXeGkvFmZKFU1Kcz+SU=;
        b=BzmjK4j08efztCA8u/8m8JzlzTcdlhJNIefy70Axm14qrDTZLXVIttKN1ocDRIPgSzwcfC
        MtFpSwS/vPEl1FKfK31OOCTxbl0SbzIYS/gnN6vM6mxjTNqMFIH3x2VdT73RhwxEmH269x
        UoTk/SCGDcc1dGyEdkfeMEhHGRGDdSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-vsxWXVKxMWel8GNfGNrNXw-1; Fri, 08 Nov 2019 08:01:16 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 946F8477;
        Fri,  8 Nov 2019 13:01:14 +0000 (UTC)
Received: from gondolin (dhcp-192-218.str.redhat.com [10.33.192.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1E865D6AE;
        Fri,  8 Nov 2019 13:01:12 +0000 (UTC)
Date:   Fri, 8 Nov 2019 14:01:10 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     alex.williamson@redhat.com, davem@davemloft.net,
        kvm@vger.kernel.org, netdev@vger.kernel.org, saeedm@mellanox.com,
        kwankhede@nvidia.com, leon@kernel.org, jiri@mellanox.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 11/19] vfio/mdev: Improvise mdev life cycle and
 parent removal scheme
Message-ID: <20191108140110.6f24916b.cohuck@redhat.com>
In-Reply-To: <20191107160834.21087-11-parav@mellanox.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-11-parav@mellanox.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: vsxWXVKxMWel8GNfGNrNXw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Nov 2019 10:08:26 -0600
Parav Pandit <parav@mellanox.com> wrote:

I guess that should be s/Improvise/improve/ in $SUBJECT, no?

> mdev creation and removal sequence synchronization with parent device
> removal is improved in [1].
>=20
> However such improvement using semaphore either limiting or leads to
> complex locking scheme when used across multiple subsystem such as mdev
> and devlink.
>=20
> When mdev devices are used with devlink eswitch device, following
> deadlock sequence can be witnessed.
>=20
> mlx5_core 0000:06:00.0: E-Switch: Disable: mode(OFFLOADS), nvfs(4), activ=
e vports(5)
> mlx5_core 0000:06:00.0: MDEV: Unregistering
>=20
> WARNING: possible circular locking dependency detected
> ------------------------------------------------------
> devlink/42094 is trying to acquire lock:
> 00000000eb6fb4c7 (&parent->unreg_sem){++++}, at: mdev_unregister_device+0=
xf1/0x160 [mdev]
> 012but task is already holding lock:
> 00000000efcd208e (devlink_mutex){+.+.}, at: devlink_nl_pre_doit+0x1d/0x17=
0
> 012which lock already depends on the new lock.
> 012the existing dependency chain (in reverse order) is:
> 012-> #1 (devlink_mutex){+.+.}:
>       lock_acquire+0xbd/0x1a0
>       __mutex_lock+0x84/0x8b0
>       devlink_unregister+0x17/0x60
>       mlx5_sf_unload+0x21/0x60 [mlx5_core]
>       mdev_remove+0x1e/0x40 [mdev]
>       device_release_driver_internal+0xdc/0x1a0
>       bus_remove_device+0xef/0x160
>       device_del+0x163/0x360
>       mdev_device_remove_common+0x1e/0xa0 [mdev]
>       mdev_device_remove+0x8d/0xd0 [mdev]
>       remove_store+0x71/0x90 [mdev]
>       kernfs_fop_write+0x113/0x1a0
>       vfs_write+0xad/0x1b0
>       ksys_write+0x5c/0xd0
>       do_syscall_64+0x5a/0x270
>       entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 012-> #0 (&parent->unreg_sem){++++}:
>       check_prev_add+0xb0/0x810
>       __lock_acquire+0xd4b/0x1090
>       lock_acquire+0xbd/0x1a0
>       down_write+0x33/0x70
>       mdev_unregister_device+0xf1/0x160 [mdev]
>       esw_offloads_disable+0xe/0x70 [mlx5_core]
>       mlx5_eswitch_disable+0x149/0x190 [mlx5_core]
>       mlx5_devlink_eswitch_mode_set+0xd0/0x180 [mlx5_core]
>       devlink_nl_cmd_eswitch_set_doit+0x3e/0xb0
>       genl_family_rcv_msg+0x3a2/0x420
>       genl_rcv_msg+0x47/0x90
>       netlink_rcv_skb+0xc9/0x100
>       genl_rcv+0x24/0x40
>       netlink_unicast+0x179/0x220
>       netlink_sendmsg+0x2f6/0x3f0
>       sock_sendmsg+0x30/0x40
>       __sys_sendto+0xdc/0x160
>       __x64_sys_sendto+0x24/0x30
>       do_syscall_64+0x5a/0x270
>       entry_SYSCALL_64_after_hwframe+0x49/0xbe
> Possible unsafe locking scenario:
>       CPU0                    CPU1
>       ----                    ----
>  lock(devlink_mutex);
>                               lock(&parent->unreg_sem);
>                               lock(devlink_mutex);
>  lock(&parent->unreg_sem);
> 012 *** DEADLOCK ***
> 3 locks held by devlink/42094:
> 0: 0000000097a0c4aa (cb_lock){++++}, at: genl_rcv+0x15/0x40
> 1: 00000000baf61ad2 (genl_mutex){+.+.}, at: genl_rcv_msg+0x66/0x90
> 2: 00000000efcd208e (devlink_mutex){+.+.}, at: devlink_nl_pre_doit+0x1d/0=
x170
>=20
> To summarize,
> mdev_remove()
>   read locks -> unreg_sem [ lock-A ]
>   [..]
>   devlink_unregister();
>     mutex lock devlink_mutex [ lock-B ]
>=20
> devlink eswitch->switchdev-legacy mode change.
>  devlink_nl_cmd_eswitch_set_doit()
>    mutex lock devlink_mutex [ lock-B ]
>    mdev_unregister_device()
>    write locks -> unreg_sem [ lock-A]

So, this problem starts to pop up once you hook up that devlink stuff
with the mdev stuff, and previous users of mdev just did not have a
locking scheme similar to devlink?

>=20
> Hence, instead of using semaphore, such synchronization is achieved
> using srcu which is more flexible that eliminates nested locking.
>=20
> SRCU based solution is already proposed before at [2].
>=20
> [1] commit 5715c4dd66a3 ("vfio/mdev: Synchronize device create/remove wit=
h parent removal")
> [2] https://lore.kernel.org/patchwork/patch/1055254/

I don't quite recall the discussion there... is this a rework of a
patch you proposed before? Confused.

>=20
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/vfio/mdev/mdev_core.c    | 56 +++++++++++++++++++++++---------
>  drivers/vfio/mdev/mdev_private.h |  3 +-
>  2 files changed, 43 insertions(+), 16 deletions(-)

(...)

> @@ -207,6 +207,7 @@ int mdev_register_device(struct device *dev, const st=
ruct mdev_parent_ops *ops)
>  =09=09dev_warn(dev, "Failed to create compatibility class link\n");
> =20
>  =09list_add(&parent->next, &parent_list);
> +=09rcu_assign_pointer(parent->self, parent);
>  =09mutex_unlock(&parent_list_lock);
> =20
>  =09dev_info(dev, "MDEV: Registered\n");
> @@ -250,14 +251,29 @@ void mdev_unregister_device(struct device *dev)
>  =09list_del(&parent->next);
>  =09mutex_unlock(&parent_list_lock);
> =20
> -=09down_write(&parent->unreg_sem);
> +=09/*
> +=09 * Publish that this mdev parent is unregistering. So any new
> +=09 * create/remove cannot start on this parent anymore by user.
> +=09 */
> +=09rcu_assign_pointer(parent->self, NULL);
> +
> +=09/*
> +=09 * Wait for any active create() or remove() mdev ops on the parent
> +=09 * to complete.
> +=09 */
> +=09synchronize_srcu(&parent->unreg_srcu);
> +
> +=09/*
> +=09 * At this point it is confirmed that any pending user initiated
> +=09 * create or remove callbacks accessing the parent are completed.
> +=09 * It is safe to remove the parent now.
> +=09 */

So, you're putting an srcu-handled self reference there and use that as
an indication whether the parent is unregistering?

> =20
>  =09class_compat_remove_link(mdev_bus_compat_class, dev, NULL);
> =20
>  =09device_for_each_child(dev, NULL, mdev_device_remove_cb);
> =20
>  =09parent_remove_sysfs_files(parent);
> -=09up_write(&parent->unreg_sem);
> =20
>  =09mdev_put_parent(parent);
> =20

