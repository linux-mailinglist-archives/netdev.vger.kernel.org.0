Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA711A30D1
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDII1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:27:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40474 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDII1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:27:08 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMSWb-0006Qf-7x; Thu, 09 Apr 2020 08:27:01 +0000
Date:   Thu, 9 Apr 2020 10:26:59 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     David Rheinsberg <david.rheinsberg@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/8] loopfs: implement loopfs
Message-ID: <20200409082659.exequ3evhlv33csr@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-3-christian.brauner@ubuntu.com>
 <CADyDSO54-GuSUJrciSD2jbSShCYDpXCp53cr+D7u0ZQT141uTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADyDSO54-GuSUJrciSD2jbSShCYDpXCp53cr+D7u0ZQT141uTA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 07:39:18AM +0200, David Rheinsberg wrote:
> Hi
> 
> On Wed, Apr 8, 2020 at 5:27 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
> > This implements loopfs, a loop device filesystem. It takes inspiration
> > from the binderfs filesystem I implemented about two years ago and with
> > which we had overally good experiences so far. Parts of it are also
> > based on [3] but it's mostly a new, imho cleaner approach.
> >
> > One of the use-cases for loopfs is to allow to dynamically allocate loop
> > devices in sandboxed workloads without exposing /dev or
> > /dev/loop-control to the workload in question and without having to
> > implement a complex and also racy protocol to send around file
> > descriptors for loop devices. With loopfs each mount is a new instance,
> > i.e. loop devices created in one loopfs instance are independent of any
> > loop devices created in another loopfs instance. This allows
> > sufficiently privileged tools to have their own private stash of loop
> > device instances.
> >
> > In addition, the loopfs filesystem can be mounted by user namespace root
> > and is thus suitable for use in containers. Combined with syscall
> > interception this makes it possible to securely delegate mounting of
> > images on loop devices, i.e. when a users calls mount -o loop <image>
> > <mountpoint> it will be possible to completely setup the loop device
> > (enabled in later patches) and the mount syscall to actually perform the
> > mount will be handled through syscall interception and be performed by a
> > sufficiently privileged process. Syscall interception is already
> > supported through a new seccomp feature we implemented in [1] and
> > extended in [2] and is actively used in production workloads. The
> > additional loopfs work will be used there and in various other workloads
> > too.
> >
> > The number of loop devices available to a loopfs instance can be limited
> > by setting the "max" mount option to a positive integer. This e.g.
> > allows sufficiently privileged processes to dynamically enforce a limit
> > on the number of devices. This limit is dynamic in contrast to the
> > max_loop module option in that a sufficiently privileged process can
> > update it with a simple remount operation.
> >
> > The loopfs filesystem is placed under a new config option and special
> > care has been taken to not introduce any new code when users do not
> > select this config option.
> >
> > Note that in __loop_clr_fd() we now need not just check whether bdev is
> > valid but also whether bdev->bd_disk is valid. This wasn't necessary
> > before because in order to call LOOP_CLR_FD the loop device would need
> > to be open and thus bdev->bd_disk was guaranteed to be allocated. For
> > loopfs loop devices we allow callers to simply unlink them just as we do
> > for binderfs binder devices and we do also need to account for the case
> > where a loopfs superblock is shutdown while backing files might still be
> > associated with some loop devices. In such cases no bd_disk device will
> > be attached to bdev. This is not in itself noteworthy it's more about
> > documenting the "why" of the added bdev->bd_disk check for posterity.
> >
> > [1]: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
> > [2]: fb3c5386b382 ("seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE")
> > [3]: https://lore.kernel.org/lkml/1401227936-15698-1-git-send-email-seth.forshee@canonical.com
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Seth Forshee <seth.forshee@canonical.com>
> > Cc: Tom Gundersen <teg@jklm.no>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Christian Kellner <ckellner@redhat.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Rheinsberg <david.rheinsberg@gmail.com>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > ---
> >  MAINTAINERS                   |   5 +
> >  drivers/block/Kconfig         |   4 +
> >  drivers/block/Makefile        |   1 +
> >  drivers/block/loop.c          | 151 +++++++++---
> >  drivers/block/loop.h          |   8 +-
> >  drivers/block/loopfs/Makefile |   3 +
> >  drivers/block/loopfs/loopfs.c | 429 ++++++++++++++++++++++++++++++++++
> >  drivers/block/loopfs/loopfs.h |  35 +++
> >  include/uapi/linux/magic.h    |   1 +
> >  9 files changed, 600 insertions(+), 37 deletions(-)
> >  create mode 100644 drivers/block/loopfs/Makefile
> >  create mode 100644 drivers/block/loopfs/loopfs.c
> >  create mode 100644 drivers/block/loopfs/loopfs.h
> >
> [...]
> > diff --git a/drivers/block/loopfs/loopfs.c b/drivers/block/loopfs/loopfs.c
> > new file mode 100644
> > index 000000000000..ac46aa337008
> > --- /dev/null
> > +++ b/drivers/block/loopfs/loopfs.c
> > @@ -0,0 +1,429 @@
> [...]
> > +/**
> > + * loopfs_loop_device_create - allocate inode from super block of a loopfs mount
> > + * @lo:                loop device for which we are creating a new device entry
> > + * @ref_inode: inode from wich the super block will be taken
> > + * @device_nr:  device number of the associated disk device
> > + *
> > + * This function creates a new device node for @lo.
> > + * Minor numbers are limited and tracked globally. The
> > + * function will stash a struct loop_device for the specific loop
> > + * device in i_private of the inode.
> > + * It will go on to allocate a new inode from the super block of the
> > + * filesystem mount, stash a struct loop_device in its i_private field
> > + * and attach a dentry to that inode.
> > + *
> > + * Return: 0 on success, negative errno on failure
> > + */
> > +int loopfs_loop_device_create(struct loop_device *lo, struct inode *ref_inode,
> > +                             dev_t device_nr)
> > +{
> > +       char name[DISK_NAME_LEN];
> > +       struct super_block *sb;
> > +       struct loopfs_info *info;
> > +       struct dentry *root, *dentry;
> > +       struct inode *inode;
> > +
> > +       sb = loopfs_i_sb(ref_inode);
> > +       if (!sb)
> > +               return 0;
> > +
> > +       if (MAJOR(device_nr) != LOOP_MAJOR)
> > +               return -EINVAL;
> > +
> > +       info = LOOPFS_SB(sb);
> > +       if ((info->device_count + 1) > info->mount_opts.max)
> > +               return -ENOSPC;
> 
> Can you elaborate what the use-case for this limit is?

Sure.

> 
> With loopfs in place, any process can create its own user_ns, mount
> their private loopfs and create as many loop-devices as they want.
> Hence, this limit does not serve as an effective global
> resource-control. Secondly, anyone with access to `loop-control` can
> now create loop instances until this limit is hit, thus causing anyone
> else to be unable to create more. This effectively prevents you from
> sharing a loopfs between non-trusting parties. I am unsure where that
> limit would actually be used?

Restricting it globally indeed wasn't the intended use-case for it. This
was more so that you can specify an instance limit, bind-mount that
instance into several places and sufficiently locked down users cannot
exceed the instance limit. 
I don't think we'd be getting much out of a global limit per se I think
the initial namespace being able to reserve a bunch of devices
they can always rely on being able create when they need them is more
interesting. This is similat to what devpts implements with the
"reserved" mount option and what I initially proposed for binderfs. For
the latter it was deemed unnecessary by others so I dropped it from
loopfs too.
I also expect most users to pre-create devices in the initial namespace
instance they need (e.g. similar to what binderfs does or what loop
devices currently have). Does that make sense to you?

Thanks!
Christian
