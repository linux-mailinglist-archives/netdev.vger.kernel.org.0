Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2690352F658
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350074AbiETXpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245165AbiETXpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:45:50 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DBDA45D;
        Fri, 20 May 2022 16:45:48 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24KNjdLe007351
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 19:45:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1653090341; bh=zNkUN2OdaR6T5z6DFiVEPSLXWY0c67eIv0P3bisFFoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=R/EsrVJI0OXzPEVVHh2YKwrEEhYu+vVfME3Z2wpXZDEcXY97u8QsxYgkVQlMGkERc
         jjncRSfIF41ahJylLHnBDcdzK8kioVNM2efI8qqsW+ClBcwWABoipJTt9YoA/2KQT5
         Apg2TOB7lv6TxI8ASku0GY4QrvRXlTtBUYRw+EeMS+0a+qdb4sJ/kDYbQdU4kzNre1
         tPHucqGX2tzU98oreCcPCqh77TDaH8haIXXNf2xPT9D9/7grqJGkx4I4CQnjBxeH2q
         wPDzirIYoueTXJD2f8V/4mM0D9EVD95Z6Xmp7jIkjQdg5QVQDyAhHAVM3KMsvrJ5Sz
         /EdRgOTjFaGZQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 77A6115C3EC0; Fri, 20 May 2022 19:45:39 -0400 (EDT)
Date:   Fri, 20 May 2022 19:45:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org
Subject: Re: RFC: Ioctl v2
Message-ID: <YogoI6Augr1V6AHn@mit.edu>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 12:16:52PM -0400, Kent Overstreet wrote:
> 
> Where the lack of real namespacing bites us more is when ioctls get promoted
> from filesystem or driver on up. Ted had a good example of an ext2 ioctl getting
> promoted to the VFS when it really shouldn't have, because it was exposing ext2
> specific data structures.
> 
> But because this is as simple as changing a #define EXT2_IOC to #define FS_IOC,
> it's really easy to do without adequate review - you don't have to change the
> ioctl number and break userspace, so why would you?
> 
> Introducing real namespacing would mean that promoting an ioctl to the VFS level
> would really have to be a new ioctl, and it'll get people to think more about
> what the new ioctl would be.

It's not clear that making harder not to break userspace is a
*feature*.  If existing programs are using a particular ioctl
namespace, being able to have other file systems adopt it has
historically been considered a *feature* not a *bug*.

At the time, we had working utilities, chattr and lsattr, which were
deployed on all Linux distributions, and newer file systems, such as
xfs, reiserfs, btrfs, etc., decided they wanted to piggy-back on those
existing utilities.  Forcing folks to deploy new utilities just
because it's the best way to force "adequate review" might be swinging
the pendulum too far in the straight-jacket direction.

It's worked the other way, too.  For example, the "shutdown" ioctl was
originally comes from XFS, and ext4 adopted that feature because the
existing interface was perfectly good, and that allows us to to get
the testing from xfstests for free.  The same goes for the extended
attribute, "trim", "freeze" and "thaw" ioctls.  

We've also promoted ioctls from btrfs to the VFS layer, including
FICLONE, GETLABEL, SETLABEL.  Take a look at include/uapi/linux/fs.h.
Ioctl's in 'X' namespace come from XFS.  Ioctl's in the 0x94 interface
come from btrfs.  And of course ioctl's in the 'f' interface come from
ext2/ext3/ext4.  It's actually worked pretty well, and we should
acknowledge that.

In the case of extended attributes, we had perfectly working userspace
tools that would have ***broken*** if we adhered to a doctrinaire,
when you promote an interface, we break the userspace interface Just
Because it's the Good Computer Science Thing To Do.

> ioctls are just private syscalls. Syscalls look like normal function calls, why
> can't ioctls?  Some ioctls do complicated things that require defining structs
> with all the tricky layout rules that we kernel devs have all had beaten into
> our brains - but most probably would not, if we could do normal-looking function
> calls.
> 
> Well, syscalls do require arch specific code to handle calling conventions, and
> we don't want that.....
>
> Userspace won't call this directly. Userspace will call normal looking
> functions, like:
> 
> int bcachefs_ioctl_disk_add(int fd, unsigned flags, char __user *disk_path);
> 
> Which will be a wrapper that casts the function arguments to u64s (or s64s for
> signed integers, so that we don't have surprises when kernel space and user
> space disagree about sizeof(long)) and then does the actual syscall.

So this approach requires that someone has to actually implement the
wrapper library.  Who will that be?  The answer could be, "let libc do
it", but then we need to worry about all the C libraries out there
actually adopting the new ioctl, which takes a long time, and
historically, some C library maintainers have had.... opinionated
points of view about the sort of "value add that should be done at the
C Library level".

There are other examples, such as the AIO and extended attribute
libraries, but they require someone willing to maintain those
libraries for the long term.  In some cases, such as the extended
attribute, that makes total sense --- but that's because that's a
library which is using an ioctl which was promoted from a specific
file system to a generic VFS interface, and so it had a lot of users.

In other cases, the only user of a particular interface might be a
file system specific userspace utility --- the kind of thing which is
shipped in btrfs-progs, e2fsprogs, f2fs-tools, xfsprogs, etc.
Creating a wrapper library for those kinds of ioctls is going to be
overkill.

So I suspect there won't be a lot of standardization here.  It could
be that there will be wrapper function that lives in util-linux, or
e2fsprogs, or xfsprogs, or whatever.  But in that case, we could do
exactly the same thing vis-a-vis creating wrapper function using the
existing ioctl interface.

For example, I have an ext2fs library function
ext2fs_get_device_size2(), which wraps not only the BLKGETSIZE and
BLKGETSIZE64 ioctls, but also the equivalents for Apple Darwin
(DKIOCGETBLOCKCOUNT), FreeBSD/NetBSD (DIOCGDINFO and later
DIOCGMEDIASIZE), and the Window's DeviceIoControl()'s
IOCTL_DISK_GET_DRIVE_GEOMETRY call.  The point is that wrapper
functions are very much orthogonal to the ioctl interface; we're all
going to have wrapper functions, and we'll create them where they are
needed.

If we force developers to have to create and maintain wrapper
libraries for all new ioctl2 interfaces, Just Because It's Proper
Computer Science Design Best Practices, it's going to be painful
enough that I suspect people will just stick to adding new ioctl code
points to the existing ioctl() interface.

So I think we need to be a little careful here.  We made adding System
Calls difficult, because it was Better(tm).  And there would good
reasons for that.  But that has also incentivized people to use the
escape hatches.  Make the "perfect" too painful, and people will find
ways to avoid using it when at all possible.

						- Ted

P.S.  During the LSF/MM hallway track, one maintainer said that the
fsdevel bikeshedding had gotten *so* painful with the process not
having a guaranteed consensus within a reasonal period of time, that
he was planning on adding a file system specific ioctl, and then later
on, if other people were wanted to use it, they would be free to use
the same ioctl code point and interface that he had come up with.
