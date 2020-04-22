Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88661B47E6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgDVOzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:55:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49607 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgDVOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 10:55:12 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein.fritz.box)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jRGmI-0006CM-RD; Wed, 22 Apr 2020 14:55:06 +0000
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
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: [PATCH v2 0/7] loopfs
Date:   Wed, 22 Apr 2020 16:54:30 +0200
Message-Id: <20200422145437.176057-1-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

This is v2 of loopfs.

I've added a few more people to the Cc that want to make use of this and
I've added the missing ucount part that David pointed out and expanded a
little more on how this is used so this is used.

This implements loopfs, a loop device filesystem. It takes inspiration
from the binderfs filesystem I implemented about two years ago and with
which we had overall good experiences so far. Parts of it are also
based on [3] but it's mostly a new, imho cleaner approach.

Loopfs allows to create private loop devices instances to applications
for various use-cases. It covers the use-case that was expressed on-list
and in-person to get programmatic access to private loop devices for
image building in sandboxes. An illustration for this is provided in
[4].

Also loopfs is intended to provide loop devices to privileged and
unprivileged containers which has been a frequent request from various
major tools (Chromium, Kubernetes, LXD, Moby/Docker, systemd). I'm
providing a non-exhaustive list of issues and requests (cf. [5]) around
this feature mainly to illustrate that I'm not making the use-cases up.
Currently none of this can be done safely since handing a loop device
from the host into a container means that the container can see anything
that the host is doing with that loop device and what other containers
are doing with that device too. And (bind-)mounting devtmpfs inside of
containers is not secure at all so also not an option (though sometimes
done out of despair apparently).

The workloads people run in containers are supposed to be indiscernible
from workloads run on the host and the tools inside of the container are
supposed to not be required to be aware that they are running inside a
container apart from containerization tools themselves. This is
especially true when running older distros in containers that did exist
before containers were as ubiquitous as they are today. With loopfs user
can call mount -o loop and in a correctly setup container things work
the same way they would on the host. The filesystem representation
allows us to do this in a very simple way. At container setup, a
container manager can mount a private instance of loopfs somehwere, e.g.
at /dev/loopfs and then bind-mount or symlink /dev/loopfs/loop-control
to /dev/loop-control, pre allocate and symlink the number of standard
devices into their standard location and have a service file or rules in
place that symlink additionally allocated loop devices through losetup
into place as well.
With the new syscall interception logic this is also possible for
unprivileged containers. In these cases when a user calls mount -o loop
<image> <mountpoint> it will be possible to completely setup the loop
device in the container. The final mount syscall is handled through
syscall interception which we already implemented and released in
earlier kernels (see [1] and [2]) and is actively used in production
workloads. The mount is often rewritten to a fuse binary to provide safe
access for unprivileged containers.

Loopfs also allows the creation of hidden/detached dynamic loop devices
and associated mounts which also was a often issued request. With the
old mount api this can be achieved by creating a temporary loopfs and
stashing a file descriptor to the mount point and the loop-control
device and immediately unmounting the loopfs instance.  With the new
mount api a detached mount can be created directly (i.e. a mount not
visible anywhere in the filesystem). New loop devices can then be
allocated and configured. They can be mounted through
/proc/self/<fd>/<nr> with the old mount api or by using the fd directly
with the new mount api. Combined with a mount namespace this allows for
fully auto-cleaned up loop devices on program crash. This ties back to
various use-cases and is illustrated in [4].

The filesystem representation requires the standard boilerplate
filesystem code we know from other tiny filesystems. And all of
the loopfs code is hidden under a config option that defaults to false.
This specifically means, that none of the code even exists when users do
not have any use-case for loopfs.
In addition, the loopfs code does not alter how loop devices behave at
all, i.e. there are no changes to any existing workloads and I've taken
care to ifdef all loopfs specific things out.

Each loopfs mount is a separate instance. As such loop devices created
in one instance are independent of loop devices created in another
instance. This specifically entails that loop devices are only visible
in the loopfs instance they belong to.

The number of loop devices available in loopfs instances are
hierarchically limited through /proc/sys/user/max_loop_devices via the
ucount infrastructure (Thanks to David Rheinsberg for pointing out that
missing piece.). An administrator could e.g. set
echo 3 > /proc/sys/user/max_loop_devices at which point any loopfs
instance mounted by uid x can only create 3 loop devices no matter how
many loopfs instances they mount. This limit applies hierarchically to
all user namespaces.

In addition, loopfs has a "max" mount option which allows to set a limit
on the number of loop devices for a given loopfs instance. This is
mainly to cover use-cases where a single loopfs mount is shared as a
bind-mount between multiple parties that are prevented from creating
other loopfs mounts and is equivalent to the semantics of the binderfs
and devpts "max" mount option.

Thanks!
Christian

[1]: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
[2]: fb3c5386b382 ("seccomp: add SECCOMP_USER_NOTIF_FLAG_CONTINUE")
[3]: https://lore.kernel.org/lkml/1401227936-15698-1-git-send-email-seth.forshee@canonical.com
[4]: https://gist.github.com/brauner/dcaf15e6977cc1bfadfb3965f126c02f
[5]: https://github.com/kubernetes-sigs/kind/issues/1333
     https://github.com/kubernetes-sigs/kind/issues/1248
     https://lists.freedesktop.org/archives/systemd-devel/2017-August/039453.html
     https://chromium.googlesource.com/chromiumos/docs/+/master/containers_and_vms.md#loop-mount
     https://gitlab.com/gitlab-com/support-forum/issues/3732
     https://github.com/moby/moby/issues/27886
     https://twitter.com/_AkihiroSuda_/status/1249664478267854848
     https://serverfault.com/questions/701384/loop-device-in-a-linux-container
     https://discuss.linuxcontainers.org/t/providing-access-to-loop-and-other-devices-in-containers/1352
     https://discuss.concourse-ci.org/t/exposing-dev-loop-devices-in-privileged-mode/813

Christian Brauner (7):
  kobject_uevent: remove unneeded netlink_ns check
  loopfs: implement loopfs
  loop: use ns_capable for some loop operations
  kernfs: handle multiple namespace tags
  loop: preserve sysfs backwards compatibility
  loopfs: start attaching correct namespace during loop_add()
  loopfs: only show devices in their correct instance

 Documentation/filesystems/sysfs-tagging.txt |   1 -
 MAINTAINERS                                 |   5 +
 block/genhd.c                               |  79 ++++
 drivers/base/devtmpfs.c                     |   4 +-
 drivers/block/Kconfig                       |   4 +
 drivers/block/Makefile                      |   1 +
 drivers/block/loop.c                        | 226 +++++++--
 drivers/block/loop.h                        |  12 +-
 drivers/block/loopfs/Makefile               |   3 +
 drivers/block/loopfs/loopfs.c               | 494 ++++++++++++++++++++
 drivers/block/loopfs/loopfs.h               |  36 ++
 fs/kernfs/dir.c                             |  38 +-
 fs/kernfs/kernfs-internal.h                 |  33 +-
 fs/kernfs/mount.c                           |  11 +-
 fs/sysfs/mount.c                            |  14 +-
 include/linux/device.h                      |   3 +
 include/linux/genhd.h                       |   3 +
 include/linux/kernfs.h                      |  44 +-
 include/linux/kobject_ns.h                  |   7 +-
 include/linux/sysfs.h                       |   8 +-
 include/linux/user_namespace.h              |   3 +
 include/uapi/linux/magic.h                  |   1 +
 kernel/ucount.c                             |   3 +
 lib/kobject.c                               |  17 +-
 lib/kobject_uevent.c                        |   2 +-
 net/core/net-sysfs.c                        |   6 -
 26 files changed, 953 insertions(+), 105 deletions(-)
 create mode 100644 drivers/block/loopfs/Makefile
 create mode 100644 drivers/block/loopfs/loopfs.c
 create mode 100644 drivers/block/loopfs/loopfs.h


base-commit: ae83d0b416db002fe95601e7f97f64b59514d936
-- 
2.26.1

