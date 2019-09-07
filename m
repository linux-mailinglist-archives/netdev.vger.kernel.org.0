Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEB6AC389
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 02:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405989AbfIGALA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 20:11:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38358 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405671AbfIGALA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 20:11:00 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.1 #3 (Red Hat Linux))
        id 1i6OJc-0007Yl-24; Sat, 07 Sep 2019 00:10:56 +0000
Date:   Sat, 7 Sep 2019 01:10:56 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Yonghong Song <yhs@fb.com>
Cc:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace
 data from current task New bpf helper bpf_get_current_pidns_info.
Message-ID: <20190907001056.GA1131@ZenIV.linux.org.uk>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
 <20190906150952.23066-3-cneirabustos@gmail.com>
 <20190906152435.GW1131@ZenIV.linux.org.uk>
 <20190906154647.GA19707@ZenIV.linux.org.uk>
 <20190906160020.GX1131@ZenIV.linux.org.uk>
 <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 06, 2019 at 11:21:14PM +0000, Yonghong Song wrote:

> -bash-4.4$ readlink /proc/self/ns/pid
> pid:[4026531836]
> -bash-4.4$ stat /proc/self/ns/pid
>    File: ‘/proc/self/ns/pid’ -> ‘pid:[4026531836]’
>    Size: 0               Blocks: 0          IO Block: 1024   symbolic link
> Device: 4h/4d   Inode: 344795989   Links: 1
> Access: (0777/lrwxrwxrwx)  Uid: (128203/     yhs)   Gid: (  100/   users)
> Context: user_u:base_r:base_t
> Access: 2019-09-06 16:06:09.431616380 -0700
> Modify: 2019-09-06 16:06:09.431616380 -0700
> Change: 2019-09-06 16:06:09.431616380 -0700
>   Birth: -
> -bash-4.4$
> 
> Based on a discussion with Eric Biederman back in 2019 Linux
> Plumbers, Eric suggested that to uniquely identify a
> namespace, device id (major/minor) number should also
> be included. Although today's kernel implementation
> has the same device for all namespace pseudo files,
> but from uapi perspective, device id should be included.
> 
> That is the reason why we try to get device id which holds
> pid namespace pseudo file.
> 
> Do you have a better suggestion on how to get
> the device id for 'current' pid namespace? Or from design, we
> really should not care about device id at all?

What the hell is "device id for pid namespace"?  This is the
first time I've heard about that mystery object, so it's
hard to tell where it could be found.

I can tell you what device numbers are involved in the areas
you seem to be looking in.

1) there's whatever device number that gets assigned to
(this) procfs instance.  That, ironically, _is_ per-pidns, but
that of the procfs instance, not that of your process (and
those can be different).  That's what you get in ->st_dev
when doing lstat() of anything in /proc (assuming that
procfs is mounted there, in the first place).  NOTE:
that's lstat(2), not stat(2).  stat(1) uses lstat(2),
unless given -L (in which case it's stat(2) time).  The
difference:

root@kvm1:~# stat /proc/self/ns/pid 
  File: /proc/self/ns/pid -> pid:[4026531836]
  Size: 0               Blocks: 0          IO Block: 1024   symbolic link
Device: 4h/4d   Inode: 17396       Links: 1
Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-09-06 19:43:11.871312319 -0400
Modify: 2019-09-06 19:43:11.871312319 -0400
Change: 2019-09-06 19:43:11.871312319 -0400
 Birth: -
root@kvm1:~# stat -L /proc/self/ns/pid 
  File: /proc/self/ns/pid
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: 3h/3d   Inode: 4026531836  Links: 1
Access: (0444/-r--r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-09-06 19:43:15.955313293 -0400
Modify: 2019-09-06 19:43:15.955313293 -0400
Change: 2019-09-06 19:43:15.955313293 -0400
 Birth: -

The former is lstat, the latter - stat.

2) device number of the filesystem where the symlink target lives.
In this case, it's nsfs and there's only one instance on the entire
system.  _That_ would be obtained by looking at st_dev in stat(2) on
/proc/self/ns/pid (0:3 above).

3) device number *OF* the symlink.  That would be st_rdev in lstat(2).
There's none - it's a symlink, not a character or block device.  It's
always zero and always will be zero.

4) the same for the target; st_rdev in stat(2) results and again,
there's no such beast - it's neither character nor block device.

Your code is looking at (3).  Please, reread any textbook on Unix
in the section that would cover stat(2) and discussion of the
difference between st_dev and st_rdev.

I have no idea what Eric had been talking about - it's hard to
reconstruct by what you said so far.  Making nsfs per-userns,
perhaps?  But that makes no sense whatsoever, not that userns
ever had...  Cheap shots aside, I really can't guess what that's
about.  Sorry.

In any case, pathname resolution is *NOT* for the situations where
you can't block.  Even if it's procfs (and from the same pidns as
the process) mounted there, there is no promise that the target
of /proc/self has already been looked up and not evicted from
memory since then.  And in case of cache miss pathwalk will
have to call ->lookup(), which requires locking the directory
(rw_sem, shared).  You can't do that in such context.

And that doesn't even go into the possibility that process has
something very different mounted on /proc.

Again, I don't know what it is that you want to get to, but
I would strongly recommend finding a way to get to that data
that would not involve going anywhere near pathname resolution.

How would you expect the userland to work with that value,
whatever it might be?  If it's just a 32bit field that will
never be read, you might as well store there the same value
you store now (0, that is) in much cheaper and safer way ;-)
