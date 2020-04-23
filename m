Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F051B60F2
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 18:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgDWQ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 12:29:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46184 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729419AbgDWQ3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 12:29:43 -0400
Received: from ip5f5af183.dynamic.kabel-deutschland.de ([95.90.241.131] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jRejK-0000ME-Gj; Thu, 23 Apr 2020 16:29:38 +0000
Date:   Thu, 23 Apr 2020 18:29:37 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        Steve Barber <smbarber@google.com>,
        Dylan Reid <dgreid@google.com>,
        Filipe Brandenburger <filbranden@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Benjamin Elder <bentheelder@google.com>,
        Akihiro Suda <suda.kyoto@gmail.com>
Subject: Re: [PATCH v2 2/7] loopfs: implement loopfs
Message-ID: <20200423162937.qvald26s7fqpqnjv@wittgenstein>
References: <20200422145437.176057-1-christian.brauner@ubuntu.com>
 <20200422145437.176057-3-christian.brauner@ubuntu.com>
 <20200422215213.GB31944@mail.hallyn.com>
 <20200423112401.ipzmsyicabwajpn2@wittgenstein>
 <20200423161717.GB12201@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200423161717.GB12201@mail.hallyn.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 11:17:17AM -0500, Serge Hallyn wrote:
> On Thu, Apr 23, 2020 at 01:24:01PM +0200, Christian Brauner wrote:
> > On Wed, Apr 22, 2020 at 04:52:13PM -0500, Serge Hallyn wrote:
> > > On Wed, Apr 22, 2020 at 04:54:32PM +0200, Christian Brauner wrote:
> > > > This implements loopfs, a loop device filesystem. It takes inspiration
> > > > from the binderfs filesystem I implemented about two years ago and with
> > > > which we had overall good experiences so far. Parts of it are also
> > > > based on [3] but it's mostly a new, imho cleaner approach.
> > > > 
> > > > Loopfs allows to create private loop devices instances to applications
> > > > for various use-cases. It covers the use-case that was expressed on-list
> > > > and in-person to get programmatic access to private loop devices for
> > > > image building in sandboxes. An illustration for this is provided in
> > > > [4].
> > > > 
> > > > Also loopfs is intended to provide loop devices to privileged and
> > > > unprivileged containers which has been a frequent request from various
> > > > major tools (Chromium, Kubernetes, LXD, Moby/Docker, systemd). I'm
> > > > providing a non-exhaustive list of issues and requests (cf. [5]) around
> > > > this feature mainly to illustrate that I'm not making the use-cases up.
> > > > Currently none of this can be done safely since handing a loop device
> > > > from the host into a container means that the container can see anything
> > > > that the host is doing with that loop device and what other containers
> > > > are doing with that device too. And (bind-)mounting devtmpfs inside of
> > > > containers is not secure at all so also not an option (though sometimes
> > > > done out of despair apparently).
> > > > 
> > > > The workloads people run in containers are supposed to be indiscernible
> > > > from workloads run on the host and the tools inside of the container are
> > > > supposed to not be required to be aware that they are running inside a
> > > > container apart from containerization tools themselves. This is
> > > > especially true when running older distros in containers that did exist
> > > > before containers were as ubiquitous as they are today. With loopfs user
> > > > can call mount -o loop and in a correctly setup container things work
> > > > the same way they would on the host. The filesystem representation
> > > > allows us to do this in a very simple way. At container setup, a
> > > > container manager can mount a private instance of loopfs somehwere, e.g.
> > > > at /dev/loopfs and then bind-mount or symlink /dev/loopfs/loop-control
> > > > to /dev/loop-control, pre allocate and symlink the number of standard
> > > > devices into their standard location and have a service file or rules in
> > > > place that symlink additionally allocated loop devices through losetup
> > > > into place as well.
> > > > With the new syscall interception logic this is also possible for
> > > > unprivileged containers. In these cases when a user calls mount -o loop
> > > > <image> <mountpoint> it will be possible to completely setup the loop
> > > > device in the container. The final mount syscall is handled through
> > > > syscall interception which we already implemented and released in
> > > > earlier kernels (see [1] and [2]) and is actively used in production
> > > > workloads. The mount is often rewritten to a fuse binary to provide safe
> > > > access for unprivileged containers.
> > > > 
> > > > Loopfs also allows the creation of hidden/detached dynamic loop devices
> > > > and associated mounts which also was a often issued request. With the
> > > > old mount api this can be achieved by creating a temporary loopfs and
> > > > stashing a file descriptor to the mount point and the loop-control
> > > > device and immediately unmounting the loopfs instance.  With the new
> > > > mount api a detached mount can be created directly (i.e. a mount not
> > > > visible anywhere in the filesystem). New loop devices can then be
> > > > allocated and configured. They can be mounted through
> > > > /proc/self/<fd>/<nr> with the old mount api or by using the fd directly
> > > > with the new mount api. Combined with a mount namespace this allows for
> > > > fully auto-cleaned up loop devices on program crash. This ties back to
> > > > various use-cases and is illustrated in [4].
> > > > 
> > > > The filesystem representation requires the standard boilerplate
> > > > filesystem code we know from other tiny filesystems. And all of
> > > > the loopfs code is hidden under a config option that defaults to false.
> > > > This specifically means, that none of the code even exists when users do
> > > > not have any use-case for loopfs.
> > > > In addition, the loopfs code does not alter how loop devices behave at
> > > > all, i.e. there are no changes to any existing workloads and I've taken
> > > > care to ifdef all loopfs specific things out.
> > > > 
> > > > Each loopfs mount is a separate instance. As such loop devices created
> > > > in one instance are independent of loop devices created in another
> > > > instance. This specifically entails that loop devices are only visible
> > > > in the loopfs instance they belong to.
> > > > 
> > > > The number of loop devices available in loopfs instances are
> > > > hierarchically limited through /proc/sys/user/max_loop_devices via the
> > > > ucount infrastructure (Thanks to David Rheinsberg for pointing out that
> > > > missing piece.). An administrator could e.g. set
> > > > echo 3 > /proc/sys/user/max_loop_devices at which point any loopfs
> > > > instance mounted by uid x can only create 3 loop devices no matter how
> > > > many loopfs instances they mount. This limit applies hierarchically to
> > > > all user namespaces.
> > > 
> > > Hm, info->device_count is per loopfs mount, though, right?  I don't
> > > see where this gets incremented for all of a user's loopfs mounts
> > > when one adds a loopdev?
> > > 
> > > I'm sure I'm missing something obvious...
> > 
> > Hm, I think you might be mixing up the two limits? device_count
> > corresponds to the "max" mount option and is not involved in enforcing
> > hierarchical limits. The global restriction is enforced through
> > inc_ucount() which tracks by the uid of the mounter of the superblock.
> > If the same user mounts multiple loopfs instances in the same namespace
> > the ucount infra will enforce his quota across all loopfs instances.
> 
> Well I'm trying to understand what the point of the max mount option
> is :)  I can just do N mounts to get N*max mounts to work around it?
> But meanwhile if I have a daemon mounting isos over loopdevs to extract
> some files (bc I never heard of bsdtar :), I risk more spurious failures
> due to hitting max?
> 
> If you think we need it, that's fine - it just has the odor of something
> more trouble than it's worth.

Maybe I'm making too much of this and you're right. My use-case was
sharing the same loopfs superblock with locked down parties. But I guess
that we can handle that case with the ucount infra too. And since I'm
the only one who thinks it might be useful I'll drop it from this
patchset. If we have a need for it we can readd it later. Sound ok?

Christian
