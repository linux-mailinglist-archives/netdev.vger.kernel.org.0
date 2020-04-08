Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084681A24FB
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 17:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgDHPWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 11:22:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39080 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbgDHPWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 11:22:40 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jMCXA-0001BO-NU; Wed, 08 Apr 2020 15:22:32 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/8] loopfs
Date:   Wed,  8 Apr 2020 17:21:43 +0200
Message-Id: <20200408152151.5780-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

After having been pinged about this by various people recently here's loopfs.

This implements loopfs, a loop device filesystem. It takes inspiration
from the binderfs filesystem I implemented about two years ago and with
which we had overall good experiences so far. Parts of it are also
based on [3] but it's mostly a new, imho cleaner and more complete
approach.

To experiment, the patchset can be found in the following locations:
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=loopfs
https://gitlab.com/brauner/linux/-/commits/loopfs
https://github.com/brauner/linux/tree/loopfs

One of the use-cases for loopfs is to allow to dynamically allocate loop
devices in sandboxed workloads without exposing /dev or
/dev/loop-control to the workload in question and without having to
implement a complex and also racy protocol to send around file
descriptors for loop devices. With loopfs each mount is a new instance,
i.e. loop devices created in one loopfs instance are independent of any
loop devices created in another loopfs instance. This allows
sufficiently privileged tools to have their own private stash of loop
device instances. Dmitry has expressed his desire to use this for
syzkaller in a private discussion. And various parties that want to use
it are Cced here too.

In addition, the loopfs filesystem can be mounted by user namespace root
and is thus suitable for use in containers. Combined with syscall
interception this makes it possible to securely delegate mounting of
images on loop devices, i.e. when a user calls mount -o loop <image>
<mountpoint> it will be possible to completely setup the loop device.
The final mount syscall to actually perform the mount will be handled
through syscall interception and be performed by a sufficiently
privileged process. Syscall interception is already supported through a
new seccomp feature we implemented in [1] and extended in [2] and is
actively used in production workloads. The additional loopfs work will
be used there and in various other workloads too. You'll find a short
illustration how this works with syscall interception below in [4].

The number of loop devices available to a loopfs instance can be limited
by setting the "max" mount option to a positive integer. This e.g.
allows sufficiently privileged processes to dynamically enforce a limit
on the number of devices. This limit is dynamic in contrast to the
max_loop module option in that a sufficiently privileged process can
update it with a simple remount operation.

The loopfs filesystem is placed under a new config option and special
care has been taken to not introduce any new code when users do not
select this config option.

Thanks!
Christian

[1]: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
[2]: fb3c5386b382 ("seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE")
[3]: https://lore.kernel.org/lkml/1401227936-15698-1-git-send-email-seth.forshee@canonical.com
[4]:
     root@f1:~# cat /proc/self/uid_map
              0     100000 1000000000
     root@f1:~# cat /proc/self/gid_map
              0     100000 1000000000
     root@f1:~# mkdir /dev/loopfs
     root@f1:~# mount -t loop loop /dev/loopfs/
     root@f1:~# ln -sf /dev/loopfs/loop-control /dev/loop-control
     root@f1:~# losetup -f
     /dev/loop9
     root@f1:~# ln -sf /dev/loopfs/loop9 /dev/loop9
     root@f1:~# ls -al /sys/class/block/loop9
     lrwxrwxrwx 1 root root 0 Apr  8 14:53 /sys/class/block/loop9 -> ../../devices/virtual/block/loop9
     root@f1:~# ls -al /sys/class/block/loop9/
     total 0
     drwxr-xr-x  9 root   root       0 Apr  8 14:53 .
     drwxr-xr-x 13 nobody nogroup    0 Apr  8 14:53 ..
     -r--r--r--  1 root   root    4096 Apr  8 14:53 alignment_offset
     lrwxrwxrwx  1 nobody nogroup    0 Apr  8 14:53 bdi -> ../../bdi/7:9
     -r--r--r--  1 root   root    4096 Apr  8 14:53 capability
     -r--r--r--  1 root   root    4096 Apr  8 14:53 dev
     -r--r--r--  1 root   root    4096 Apr  8 14:53 discard_alignment
     -r--r--r--  1 root   root    4096 Apr  8 14:53 events
     -r--r--r--  1 root   root    4096 Apr  8 14:53 events_async
     -rw-r--r--  1 root   root    4096 Apr  8 14:53 events_poll_msecs
     -r--r--r--  1 root   root    4096 Apr  8 14:53 ext_range
     -r--r--r--  1 root   root    4096 Apr  8 14:53 hidden
     drwxr-xr-x  2 nobody nogroup    0 Apr  8 14:53 holders
     -r--r--r--  1 root   root    4096 Apr  8 14:53 inflight
     drwxr-xr-x  2 nobody nogroup    0 Apr  8 14:53 integrity
     drwxr-xr-x  3 nobody nogroup    0 Apr  8 14:53 mq
     drwxr-xr-x  2 root   root       0 Apr  8 14:53 power
     drwxr-xr-x  3 nobody nogroup    0 Apr  8 14:53 queue
     -r--r--r--  1 root   root    4096 Apr  8 14:53 range
     -r--r--r--  1 root   root    4096 Apr  8 14:53 removable
     -r--r--r--  1 root   root    4096 Apr  8 14:53 ro
     -r--r--r--  1 root   root    4096 Apr  8 14:53 size
     drwxr-xr-x  2 nobody nogroup    0 Apr  8 14:53 slaves
     -r--r--r--  1 root   root    4096 Apr  8 14:53 stat
     lrwxrwxrwx  1 nobody nogroup    0 Apr  8 14:53 subsystem -> ../../../../class/block
     drwxr-xr-x  2 root   root       0 Apr  8 14:53 trace
     -rw-r--r--  1 root   root    4096 Apr  8 14:53 uevent
     root@f1:~#  
     root@f1:~# stat --file-system /bla.img
       File: "/bla.img"
         ID: 4396dc4f5f3ffe1b Namelen: 255     Type: btrfs
     Block size: 4096       Fundamental block size: 4096
     Blocks: Total: 11230468   Free: 10851929   Available: 10738585
     Inodes: Total: 0          Free: 0
     root@f1:~# mount -o loop /bla.img /opt
     root@f1:~# findmnt | grep opt
     └─/opt                                /dev/loop9                            btrfs       rw,relatime,ssd,space_cache,subvolid=5,subvol=/

Christian Brauner (8):
  kobject_uevent: remove unneeded netlink_ns check
  loopfs: implement loopfs
  loop: use ns_capable for some loop operations
  kernfs: handle multiple namespace tags
  kernfs: let objects opt-in to propagating from the initial namespace
  genhd: add minimal namespace infrastructure
  loopfs: start attaching correct namespace during loop_add()
  loopfs: only show devices in their correct instance

 Documentation/filesystems/sysfs-tagging.txt |   1 -
 MAINTAINERS                                 |   5 +
 block/genhd.c                               |  79 ++++
 drivers/base/devtmpfs.c                     |   4 +-
 drivers/block/Kconfig                       |   4 +
 drivers/block/Makefile                      |   1 +
 drivers/block/loop.c                        | 186 +++++++--
 drivers/block/loop.h                        |   8 +-
 drivers/block/loopfs/Makefile               |   3 +
 drivers/block/loopfs/loopfs.c               | 429 ++++++++++++++++++++
 drivers/block/loopfs/loopfs.h               |  35 ++
 fs/kernfs/dir.c                             |  38 +-
 fs/kernfs/kernfs-internal.h                 |  26 +-
 fs/kernfs/mount.c                           |  11 +-
 fs/sysfs/mount.c                            |  14 +-
 include/linux/device.h                      |   3 +
 include/linux/genhd.h                       |   3 +
 include/linux/kernfs.h                      |  44 +-
 include/linux/kobject_ns.h                  |   7 +-
 include/linux/sysfs.h                       |   8 +-
 include/uapi/linux/magic.h                  |   1 +
 lib/kobject.c                               |  17 +-
 lib/kobject_uevent.c                        |   2 +-
 net/core/net-sysfs.c                        |   6 -
 24 files changed, 834 insertions(+), 101 deletions(-)
 create mode 100644 drivers/block/loopfs/Makefile
 create mode 100644 drivers/block/loopfs/loopfs.c
 create mode 100644 drivers/block/loopfs/loopfs.h


base-commit: 7111951b8d4973bda27ff663f2cf18b663d15b48
-- 
2.26.0

