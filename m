Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0FD1A2760
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730367AbgDHQmO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Apr 2020 12:42:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43232 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729029AbgDHQmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 12:42:13 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <stgraber@ubuntu.com>)
        id 1jMDlx-0001U5-UX
        for netdev@vger.kernel.org; Wed, 08 Apr 2020 16:41:54 +0000
Received: by mail-ed1-f47.google.com with SMTP id bd14so9420005edb.10
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 09:41:53 -0700 (PDT)
X-Gm-Message-State: AGi0PuaQZ5zo1JvMTd8ew+LmPQFjLUJN5bGDc4oy+WEr/LoYWwfCHkHE
        JAWq2Kzk0GYc8KlRhCkbKyF5x5X0NVXiFdSSP8UpQg==
X-Google-Smtp-Source: APiQypLzUyLptlfj4UREBf2l5xN02F+xA0MQtCV/4zxKUkblPb/olSzPaY17gwOo3IIMcNmLwikMsI/ASDg0+VXPjE8=
X-Received: by 2002:a2e:97c2:: with SMTP id m2mr5450395ljj.228.1586364113069;
 Wed, 08 Apr 2020 09:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200408152151.5780-1-christian.brauner@ubuntu.com> <CAG48ez0KWgLMOp1d3X1AcRNc4-eF1YiCw=PgWiGjtM6PqQqawg@mail.gmail.com>
In-Reply-To: <CAG48ez0KWgLMOp1d3X1AcRNc4-eF1YiCw=PgWiGjtM6PqQqawg@mail.gmail.com>
From:   =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Date:   Wed, 8 Apr 2020 12:41:41 -0400
X-Gmail-Original-Message-ID: <CA+enf=uhTi1yWtOe+iuv2FvdZzo69pwsP-NNU2775jN01aDcVQ@mail.gmail.com>
Message-ID: <CA+enf=uhTi1yWtOe+iuv2FvdZzo69pwsP-NNU2775jN01aDcVQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] loopfs
To:     Jann Horn <jannh@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Linux API <linux-api@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        Dmitry Vyukov <dvyukov@google.com>, linux-doc@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 12:24 PM Jann Horn <jannh@google.com> wrote:
>
> On Wed, Apr 8, 2020 at 5:23 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > One of the use-cases for loopfs is to allow to dynamically allocate loop
> > devices in sandboxed workloads without exposing /dev or
> > /dev/loop-control to the workload in question and without having to
> > implement a complex and also racy protocol to send around file
> > descriptors for loop devices. With loopfs each mount is a new instance,
> > i.e. loop devices created in one loopfs instance are independent of any
> > loop devices created in another loopfs instance. This allows
> > sufficiently privileged tools to have their own private stash of loop
> > device instances. Dmitry has expressed his desire to use this for
> > syzkaller in a private discussion. And various parties that want to use
> > it are Cced here too.
> >
> > In addition, the loopfs filesystem can be mounted by user namespace root
> > and is thus suitable for use in containers. Combined with syscall
> > interception this makes it possible to securely delegate mounting of
> > images on loop devices, i.e. when a user calls mount -o loop <image>
> > <mountpoint> it will be possible to completely setup the loop device.
> > The final mount syscall to actually perform the mount will be handled
> > through syscall interception and be performed by a sufficiently
> > privileged process. Syscall interception is already supported through a
> > new seccomp feature we implemented in [1] and extended in [2] and is
> > actively used in production workloads. The additional loopfs work will
> > be used there and in various other workloads too. You'll find a short
> > illustration how this works with syscall interception below in [4].
>
> Would that privileged process then allow you to mount your filesystem
> images with things like ext4? As far as I know, the filesystem
> maintainers don't generally consider "untrusted filesystem image" to
> be a strongly enforced security boundary; and worse, if an attacker
> has access to a loop device from which something like ext4 is mounted,
> things like "struct ext4_dir_entry_2" will effectively be in shared
> memory, and an attacker can trivially bypass e.g.
> ext4_check_dir_entry(). At the moment, that's not a huge problem (for
> anything other than kernel lockdown) because only root normally has
> access to loop devices.
>
> Ubuntu carries an out-of-tree patch that afaik blocks the shared
> memory thing: <https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/eoan/commit?id=4bc428fdf5500b7366313f166b7c9c50ee43f2c4>
>
> But even with that patch, I'm not super excited about exposing
> filesystem image parsing attack surface to containers unless you run
> the filesystem in a sandboxed environment (at which point you don't
> need a loop device anymore either).

So in general we certainly agree that you should never expose someone
that you wouldn't trust with root on the host to syscall interception
mounting of real kernel filesystems.

But that's not all that our syscall interception logic can do. We have
support for rewriting a normal filesystem mount attempt to instead use
an available FUSE implementation. As far as the user is concerned,
they ran "mount /dev/sdaX /mnt" and got that ext4 filesystem mounted
on /mnt as requested, except that the container manager intercepted
the mount attempt and instead spawned fuse2fs for that mount. This
requires absolutely no change to the software the user is running.

loopfs, with that interception mode, will let us also handle all cases
where a loop would be used, similarly without needing any change to
the software being run. If a piece of software calls the command
"mount -o loop blah.img /mnt", the "mount" command will setup a loop
device as it normally would (doing so through loopfs) and then will
call the "mount" syscall, which will get intercepted and redirected to
a FUSE implementation if so configured, resulting in the expected
filesystem being mounted for the user.

LXD with syscall interception offers both straight up privileged
mounting using the kernel fs or using a FUSE based implementation.
This is configurable on a per-filesystem and per-container basis.

I hope that clarifies what we're doing here :)

Stéphane
