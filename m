Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5805A1A5E6E
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 14:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgDLMDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 08:03:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35626 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgDLMDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 08:03:10 -0400
Received: from ip5f5bd698.dynamic.kabel-deutschland.de ([95.91.214.152] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jNbKH-0008Lb-Fq; Sun, 12 Apr 2020 12:03:01 +0000
Date:   Sun, 12 Apr 2020 14:03:00 +0200
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
Message-ID: <20200412120300.vuigwofazxfbxluu@wittgenstein>
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <20200408152151.5780-3-christian.brauner@ubuntu.com>
 <CADyDSO54-GuSUJrciSD2jbSShCYDpXCp53cr+D7u0ZQT141uTA@mail.gmail.com>
 <20200409082659.exequ3evhlv33csr@wittgenstein>
 <CADyDSO54FV7OaVwWremmnNbTkvw6hQ-KTLJdEg3V5rfBi8n3Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADyDSO54FV7OaVwWremmnNbTkvw6hQ-KTLJdEg3V5rfBi8n3Yw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 12:38:54PM +0200, David Rheinsberg wrote:
> Hey
> 
> On Thu, Apr 9, 2020 at 10:27 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > On Thu, Apr 09, 2020 at 07:39:18AM +0200, David Rheinsberg wrote:
> > > With loopfs in place, any process can create its own user_ns, mount
> > > their private loopfs and create as many loop-devices as they want.
> > > Hence, this limit does not serve as an effective global
> > > resource-control. Secondly, anyone with access to `loop-control` can
> > > now create loop instances until this limit is hit, thus causing anyone
> > > else to be unable to create more. This effectively prevents you from
> > > sharing a loopfs between non-trusting parties. I am unsure where that
> > > limit would actually be used?
> >
> > Restricting it globally indeed wasn't the intended use-case for it. This
> > was more so that you can specify an instance limit, bind-mount that
> > instance into several places and sufficiently locked down users cannot
> > exceed the instance limit.
> 
> But then these users can each exhaust the limit individually. As such,
> you cannot share this instance across users that have no
> trust-relationship. Fine with me, but I still don't understand in

Well, you can't really share anything across clients with the same
privilege level if one of them is untrusted.

> which scenario the limit would be useful. Anyone can create a user-ns,
> create a new loopfs mount, and just happily create more loop-devices.
> So what is so special that you want to restrict the devices on a
> _single_ mount instance?

To share that instance across namespaces. You can e.g. create the
mount instance in one mount namespace owned by userns1, create a second
user namespace usern2 with the same mapping which is blocked from
creating additional user namespaces either by seccomp or by
/proc/sys/user/max_user_namespaces or lsms what have you. Because it
doesn't own the mount namespace the loopfs mount it is in it can't
remount it and can't exceed the local limit.

> 
> > I don't think we'd be getting much out of a global limit per se I think
> > the initial namespace being able to reserve a bunch of devices
> > they can always rely on being able create when they need them is more
> > interesting. This is similat to what devpts implements with the
> > "reserved" mount option and what I initially proposed for binderfs. For
> > the latter it was deemed unnecessary by others so I dropped it from
> > loopfs too.
> 
> The `reserve` of devpts has a fixed 2-tier system: A global limit, and
> a init-ns reserve. This does nothing to protect one container from
> another.

What I was getting at is that what matters first and foremost is
protecting init userns.

> 
> Furthermore, how do you intend to limit user-space from creating an
> unbound amount of loop devices? Unless I am mistaken, with your
> proposal *any* process can create a new loopfs with a basically
> unlimited amount of loop-devices, thus easily triggering unbound
> kernel allocations. I think this needs to be accounted. The classic
> way is to put a per-uid limit into `struct user_struct` (done by
> pipes, mlock, epoll, mq, etc.). An alternative is `struct ucount`,
> which allows hierarchical management (inotify uses that, as an
> example).

Yeah, I know. We can certainly do this.

> 
> > I also expect most users to pre-create devices in the initial namespace
> > instance they need (e.g. similar to what binderfs does or what loop
> > devices currently have). Does that make sense to you?
> 
> Our use-case is to get programmatic access to loop-devices, so we can
> build customer images on request (especially to create XFS images,
> since mkfs.xfs cannot write them, IIRC). We would be perfectly happy
> with a kernel-interface that takes a file-descriptor to a regular file
> and returns us a file-descriptor to a newly created block device
> (which is automatically destroyed when the last file-descriptor to it
> is closed). This would be ideal *to us*, since it would do automatic
> cleanup on crashes.
> 
> We don't need any representation of the loop-device in the
> file-system, as long as we can somehow mount it (either by passing the
> bdev-FD to the new mount-api, or by using /proc/self/fd/ as
> mount-source).

We want the ability to have a filesystem representation as it will allow
us to handle a host of legacy workloads cleanly e.g. that users can just
call mount -o loop /bla whenever they have opted into syscall
interception for a particular filesystem. In addition, we can cover your
use case completely was well I think. Both with the old and new mount api.

> 
> With your proposed loop-fs we could achieve something close to it:
> Mount a private loopfs, create a loop-device, and rely on automatic
> cleanup when the mount-namespace is destroyed.

With loopfs you can do this with the old or new mount api and you don't
need to have loopfs mounted for that at all. Here's a sample program
that works right now with the old mount api:

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#include <linux/loop.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <limits.h>
#include <linux/bpf.h>
#include <linux/magic.h>
#include <linux/sched.h>
#include <malloc.h>
#include <poll.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/fsuid.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/param.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <linux/types.h>
#include <sys/un.h>
#include <sys/wait.h>
#include <unistd.h>

int attach_image_to_loop(const char *source, int loop_fd)
{
	int ret, fret = -1;
	struct loop_info64 lo64;
	int fd_img = -1;

	fd_img = open(source, O_RDWR | O_CLOEXEC);
	if (fd_img < 0) {
		fprintf(stderr, "Failed to open %s\n", source);
		goto on_error;
	}

	ret = ioctl(loop_fd, LOOP_SET_FD, fd_img);
	if (ret < 0) {
		fprintf(stderr, "%m - Failed to set loop device to %s\n", source);
		goto on_error;
	}

	memset(&lo64, 0, sizeof(lo64));

	snprintf((char *)lo64.lo_file_name, LO_NAME_SIZE, "%s", source);

	ret = ioctl(loop_fd, LOOP_SET_STATUS64, &lo64);
	if (ret < 0) {
		fprintf(stderr, "Failed to set loop device status for %s\n", source);
		goto on_error;
	}

	fret = 0;

on_error:
	if (fd_img >= 0)
		close(fd_img);

	return fret;
}

int main(int argc, char *argv[])
{
	int n = 1;
	int ret, mntfd, loop_ctl_fd, loopidx, loopfd;
	char path[4096];

	/* Mount loopfs. */
	ret = mount("none", "/mnt", "loop", 0, 0);
	if (ret)
		exit(n++);

	/* Stash file descriptor to mount. */
	mntfd = open("/mnt", O_DIRECTORY);
	if (mntfd < 0)
		exit(n++);

	/* Stash file descriptor to loop-control. */
	loop_ctl_fd = open("/mnt/loop-control", O_RDWR | O_CLOEXEC);
	if (loop_ctl_fd < 0)
		exit(n++);

	/*
	 * Detach mount so none can access it anymore and also we don't need it
	 * anymore.
	 */
	ret = umount2("/mnt", MNT_DETACH);
	if (ret)
		exit(n++);

	/* Get new loop device index. */
	loopidx = ioctl(loop_ctl_fd, LOOP_CTL_GET_FREE);
	if (loopidx < 0)
		exit(n++);

	/* Use openat() to open loop device in private instance. */
	snprintf(path, sizeof(path), "loop%d", loopidx);
	loopfd = openat(mntfd, path, O_RDWR | O_CLOEXEC);
	if (loopfd < 0)
		exit(n++);

	/* Attach image to loop device. */
	ret = attach_image_to_loop("/bla.img", loopfd);
	if (ret)
		exit(n++);

	/* Mount through /proc/self/fd/<nr> */
	snprintf(path, sizeof(path), "/proc/self/fd/%d", loopfd);
	ret = mount(path, "/opt", "btrfs", 0, 0);
	if (ret)
		exit(6);

	/* Repeat as often as you want or close loopfs instance. */

	exit(EXIT_SUCCESS);
}
