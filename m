Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B613AD9B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgANP0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:26:37 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35554 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgANP0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:26:37 -0500
Received: by mail-lf1-f68.google.com with SMTP id 15so10152797lfr.2
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 07:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgGCroEitzw9p32ODqoZdnIHofH0Pn9M8DzK2/Ed3lI=;
        b=r9+Dy3hB/VWuf7M/+Xh0/U+KIkyp4FnX/eTUI3FPcO2bqMqjYWFka0Zc4kUuuuOX2Z
         1FhN9KorNKsx83VH5t9Wm9m9+JJILRTDGZQr/Xq/v0Kj5DzVxgS69VFocEpJ242gHGMi
         lh4IayYsytnCU3YOnuPRGvIotWVh4I2A0QsTeqk4afSYneTuNQsTDvTpvSEuzWgSYo42
         jSk7Tz0QqTKxN5yAJzmSHHWHzW8LyWp6+5SuSt10Maw2h9MZ+LhDdhQPvMFsOfYPIqFN
         XzvcTgf2SjEltIxpAndoFnQHUHm3EuBfEQRVAitG1R3jvnbba3WHOg3/jBKs5GCgArY4
         vZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgGCroEitzw9p32ODqoZdnIHofH0Pn9M8DzK2/Ed3lI=;
        b=K7JUvJH64FIAMyTAn201p2gGECsw7LrpPbn399g3Liv0w76XV95gzNZZq8oNij3Xfg
         7NoCinf8jBP9XZJGra2GvMRTfjKKvg0a/Uw27a3n55Qt8uHBJgoxkKJAKspr0qYfh67u
         xpVy3hhUviTeGEkyvKrs9b9N7TL9t2/fipMEAMBcvQIMnB1ZxzTvXsEiRhPjDs6RrRuy
         I6mRq/uFwBBjcLczonwRf7nwMUllKqREs6QGDEPpeCjd8cImrmWGi/xsjgvm33oZvhDX
         nnbYDOP1ytmMT9YySYntxrBQZGY714SDAqFsU/pGy2zdIRzuJLa873TUjoRGL2yRed0n
         +WEg==
X-Gm-Message-State: APjAAAU6upcNhIKW44LY7MhBAHQitJPtx6rn/PmxOdgZcRd34cWeynie
        KDRr3KEDvOm6i2GpIJ0OpMAOIN9FqcQ0yQQ0gVS2MRkj
X-Google-Smtp-Source: APXvYqzfFrBd5db0Z2y3SBwtZKybZdIQv6UayivHbwi3ir0jKdqF3N7kW9HfzTL6BXWgPr4FxKLBYFOqs/e0/BdEJus=
X-Received: by 2002:a19:850a:: with SMTP id h10mr2022543lfd.89.1579015594765;
 Tue, 14 Jan 2020 07:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20200111163655.4087-1-ap420073@gmail.com> <20200112061937.171f6d88@cakuba>
In-Reply-To: <20200112061937.171f6d88@cakuba>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 15 Jan 2020 00:26:22 +0900
Message-ID: <CAMArcTUx46w35JPhw5hvnKW+g9z9Lqrv7u1DsnKOeWnvFaAsxg@mail.gmail.com>
Subject: Re: [PATCH net 1/5] netdevsim: fix a race condition in netdevsim operations
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 at 23:19, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>

Hi Jakub,
Thank you for your review!

> On Sat, 11 Jan 2020 16:36:55 +0000, Taehee Yoo wrote:
> > netdevsim basic operations are called with sysfs.
> >
> > Create netdevsim device:
> > echo "1 1" > /sys/bus/netdevsim/new_device
> > Delete netdevsim device:
> > echo 1 > /sys/bus/netdevsim/del_device
> > Create netdevsim port:
> > echo 4 > /sys/devices/netdevsim1/new_port
> > Delete netdevsim port:
> > echo 4 > /sys/devices/netdevsim1/del_port
> > Set sriov number:
> > echo 4 > /sys/devices/netdevsim1/sriov_numvfs
> >
> > These operations use the same resource so they should acquire a lock for
> > the whole resource not only for a list.
> >
> > Test commands:
> >     #SHELL1
> >     modprobe netdevsim
> >     while :
> >     do
> >         echo "1 1" > /sys/bus/netdevsim/new_device
> >         echo "1 1" > /sys/bus/netdevsim/del_device
> >     done
> >
> >     #SHELL2
> >     while :
> >     do
> >         echo 1 > /sys/devices/netdevsim1/new_port
> >         echo 1 > /sys/devices/netdevsim1/del_port
> >     done
> >
> > Splat looks like:
> > [  151.623634][ T1165] kasan: CONFIG_KASAN_INLINE enabled
> > [  151.626503][ T1165] kasan: GPF could be caused by NULL-ptr deref or user memory access
>
>
> > In this patch, __init and __exit function also acquire a lock.
> > operations could be called while __init and __exit functions are
> > processing. If so, uninitialized or freed resources could be used.
> > So, __init() and __exit function also need lock.
> >
> > Fixes: 83c9e13aa39a ("netdevsim: add software driver for testing offloads")
>
> I don't think that's the correct Fixes tag, the first version of the
> driver did not use the sysfs interface.
>

I checked up the Fixes tag. you're right, this Fixes tag is not correct.
I will fix this.

> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> > --- a/drivers/net/netdevsim/bus.c
> > +++ b/drivers/net/netdevsim/bus.c
> > @@ -16,7 +16,8 @@
> >
> >  static DEFINE_IDA(nsim_bus_dev_ids);
> >  static LIST_HEAD(nsim_bus_dev_list);
> > -static DEFINE_MUTEX(nsim_bus_dev_list_lock);
> > +/* mutex lock for netdevsim operations */
> > +DEFINE_MUTEX(nsim_bus_dev_ops_lock);
> >
> >  static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
> >  {
> > @@ -51,9 +52,14 @@ nsim_bus_dev_numvfs_store(struct device *dev, struct device_attribute *attr,
>
> Could the vf handling use the device lock like PCI does?
>
> But actually, we free VF info from the release function, which IIUC is
> called after all references to the device are gone. So this should be
> fine, no?
>

I have tested this patch without locking in the
nsim_bus_dev_numvfs_store(). It worked well.
The freeing and allocating routines are protected by RTNL.
As you said, the ->release() routine, which frees vconfig is protected by
reference count. So, It's safe.
I will drop this at a v2 patch.

> Perhaps the entire bus dev structure should be freed from release?
>

I tested this like this.

@@ -146,6 +161,8 @@ static void nsim_bus_dev_release(struct device *dev)
        struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);

        nsim_bus_dev_vfs_disable(nsim_bus_dev);
+       ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
+       kfree(nsim_bus_dev);
 }
@@ -300,8 +320,6 @@ nsim_bus_dev_new(unsigned int id, unsigned int port_count)
 static void nsim_bus_dev_del(struct nsim_bus_dev *nsim_bus_dev)
 {
        device_unregister(&nsim_bus_dev->dev);
-       ida_free(&nsim_bus_dev_ids, nsim_bus_dev->dev.id);
-       kfree(nsim_bus_dev);
 }

It works well. but I'm not sure this is needed.

> >       unsigned int num_vfs;
> >       int ret;
> >
> > +     if (!mutex_trylock(&nsim_bus_dev_ops_lock))
> > +             return -EBUSY;
>
> Why the trylocks? Are you trying to catch the races between unregister
> and other ops?
>

The reason is to avoid deadlock.
If we use mutex_lock() instead of mutex_trylock(), the below message
will be printed and actual deadlock also appeared.

[  426.879562][  T805] WARNING: possible circular locking dependency detected
[  426.880477][  T805] 5.5.0-rc5+ #280 Not tainted
[  426.881080][  T805] ------------------------------------------------------
[  426.882035][  T805] bash/805 is trying to acquire lock:
[  426.882826][  T805] ffffffffc03b7830 (nsim_bus_dev_ops_lock){+.+.},
at: del_port_store+0x68/0xe0 [netdevsim]
[  426.884159][  T805]
[  426.884159][  T805] but task is already holding lock:
[  426.885061][  T805] ffff88805edb54b0 (kn->count#170){++++}, at:
kernfs_fop_write+0x1f2/0x410
[  426.886130][  T805]
[  426.886130][  T805] which lock already depends on the new lock.
[  426.886130][  T805]
[  426.887492][  T805]
[  426.887492][  T805] the existing dependency chain (in reverse order) is:
[  426.888606][  T805]
[  426.888606][  T805] -> #1 (kn->count#170){++++}:
[  426.889749][  T805]        __kernfs_remove+0x612/0x7f0
[  426.890392][  T805]        kernfs_remove_by_name_ns+0x40/0x80
[  426.891342][  T805]        remove_files.isra.1+0x6c/0x170
[  426.892359][  T805]        sysfs_remove_group+0x9b/0x170
[  426.893414][  T805]        sysfs_remove_groups+0x4f/0x90
[  426.894405][  T805]        device_remove_attrs+0xc9/0x130
[  426.895198][  T805]        device_del+0x413/0xc10
[  426.895798][  T805]        device_unregister+0x16/0xa0
[  426.896457][  T805]        del_device_store+0x288/0x3c0 [netdevsim]
[  426.897250][  T805]        kernfs_fop_write+0x276/0x410
[  426.897915][  T805]        vfs_write+0x197/0x4a0
[  426.898506][  T805]        ksys_write+0x141/0x1d0
[  426.899111][  T805]        do_syscall_64+0x99/0x4f0
[  426.899738][  T805]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  426.900557][  T805]
[  426.900557][  T805] -> #0 (nsim_bus_dev_ops_lock){+.+.}:
[  426.901425][  T805]        __lock_acquire+0x2d8d/0x3de0
[  426.902023][  T805]        lock_acquire+0x164/0x3b0
[  426.902586][  T805]        __mutex_lock+0x14d/0x14b0
[  426.903166][  T805]        del_port_store+0x68/0xe0 [netdevsim]
[  426.903840][  T805]        kernfs_fop_write+0x276/0x410
[  426.904430][  T805]        vfs_write+0x197/0x4a0
[  426.904952][  T805]        ksys_write+0x141/0x1d0
[  426.905481][  T805]        do_syscall_64+0x99/0x4f0
[  426.906032][  T805]        entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  426.906745][  T805]
[  426.906745][  T805] other info that might help us debug this:
[  426.906745][  T805]
[  426.907883][  T805]  Possible unsafe locking scenario:
[  426.907883][  T805]
[  426.908715][  T805]        CPU0                    CPU1
[  426.909312][  T805]        ----                    ----
[  426.909902][  T805]   lock(kn->count#170);
[  426.910372][  T805]
lock(nsim_bus_dev_ops_lock);
[  426.911277][  T805]                                lock(kn->count#170);
[  426.912032][  T805]   lock(nsim_bus_dev_ops_lock);
[  426.912581][  T805]
[  426.912581][  T805]  *** DEADLOCK ***
[  426.912581][  T805]
[  426.913495][  T805] 3 locks held by bash/805:
[  426.913998][  T805]  #0: ffff88806547c478 (sb_writers#5){.+.+}, at:
vfs_write+0x3bb/0x4a0
[  426.914944][  T805]  #1: ffff88805ff55c90 (&of->mutex){+.+.}, at:
kernfs_fop_write+0x1cf/0x410
[  426.915928][  T805]  #2: ffff88805edb54b0 (kn->count#170){++++},
at: kernfs_fop_write+0x1f2/0x410
[  426.916957][  T805]
[  426.916957][  T805] stack backtrace:
[  426.917614][  T805] CPU: 1 PID: 805 Comm: bash Not tainted 5.5.0-rc5+ #280
[  426.918398][  T805] Hardware name: innotek GmbH
VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  426.919408][  T805] Call Trace:
[  426.919804][  T805]  dump_stack+0x96/0xdb
[  426.920263][  T805]  check_noncircular+0x371/0x450
[  426.920813][  T805]  ? print_circular_bug.isra.36+0x310/0x310
[  426.921475][  T805]  ? lock_acquire+0x164/0x3b0
[  426.921993][  T805]  ? hlock_class+0x130/0x130
[  426.922502][  T805]  ? __lock_acquire+0x2d8d/0x3de0
[  426.923158][  T805]  __lock_acquire+0x2d8d/0x3de0
[  426.923692][  T805]  ? register_lock_class+0x14d0/0x14d0
[  426.924282][  T805]  lock_acquire+0x164/0x3b0
[  426.924784][  T805]  ? del_port_store+0x68/0xe0 [netdevsim]
[  426.925415][  T805]  __mutex_lock+0x14d/0x14b0
[  426.925925][  T805]  ? del_port_store+0x68/0xe0 [netdevsim]
[  426.926551][  T805]  ? __lock_acquire+0xdfe/0x3de0
[  426.927108][  T805]  ? del_port_store+0x68/0xe0 [netdevsim]
[  426.927740][  T805]  ? mutex_lock_io_nested+0x1380/0x1380
[  426.928349][  T805]  ? register_lock_class+0x14d0/0x14d0
[  426.928947][  T805]  ? check_chain_key+0x236/0x5d0
[  426.929490][  T805]  ? kernfs_fop_write+0x1cf/0x410
[  426.930042][  T805]  ? lock_acquire+0x164/0x3b0
[  426.930558][  T805]  ? kernfs_fop_write+0x1f2/0x410
[  426.931123][  T805]  ? del_port_store+0x68/0xe0 [netdevsim]
[  426.931761][  T805]  del_port_store+0x68/0xe0 [netdevsim]
[  426.932389][  T805]  ? nsim_bus_dev_release+0x100/0x100 [netdevsim]
[  426.933097][  T805]  ? sysfs_file_ops+0x112/0x160
[  426.933630][  T805]  ? sysfs_kf_write+0x3b/0x180
[  426.934152][  T805]  ? sysfs_file_ops+0x160/0x160
[  426.934683][  T805]  kernfs_fop_write+0x276/0x410
[  426.935226][  T805]  ? __sb_start_write+0x215/0x2e0
[  426.935780][  T805]  vfs_write+0x197/0x4a0

Locking ordering of {new/del}_device() and {new/del}_port is different.
So, a deadlock could occur.

Thank you,
Taehee Yoo
