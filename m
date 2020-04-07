Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE421A057D
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 06:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgDGEEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 00:04:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35972 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbgDGEEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 00:04:15 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLfSs-00ClNx-E5; Tue, 07 Apr 2020 04:03:54 +0000
Date:   Tue, 7 Apr 2020 05:03:54 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Yun Levi <ppbuk5246@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eric Dumazet <edumazet@google.com>,
        Li RongQing <lirongqing@baidu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Berg <johannes.berg@intel.com>,
        David Howells <dhowells@redhat.com>, daniel@iogearbox.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] netns: dangling pointer on netns bind mount point.
Message-ID: <20200407040354.GZ23230@ZenIV.linux.org.uk>
References: <20200407023512.GA25005@ubuntu>
 <20200407030504.GX23230@ZenIV.linux.org.uk>
 <20200407031318.GY23230@ZenIV.linux.org.uk>
 <CAM7-yPQas7hvTVLa4U80t0Em0HgLCk2whLQa4O3uff5J3OYiAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM7-yPQas7hvTVLa4U80t0Em0HgLCk2whLQa4O3uff5J3OYiAA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 12:29:34PM +0900, Yun Levi wrote:

> sock_prot_inuse_add+0x10/0x20
> __sock_release+0x44/0xc0
> sock_close+0x14/0x20
> __fput+0x8c/0x1b8
> ____fput+0xc/0x18
> task_work_run+0xa8/0xd8
> do_exit+0x2e4/0xa50
> do_group_exit+0x34/0xc8
> get_signal+0xd4/0x600
> do_signal+0x174/0x268
> do_notify_resume+0xcc/0x110
> work_pending+0x8/0x10
> Code: b940c821 f940c000 d538d083 8b010800 (b8606861) ---[ end trace
> 0b98c9ccbfd9f6fd ]---
> Date/Time : 02-14-0120 06:35:47 Kernel panic - not syncing: Fatal
> exception in interrupt SMP: stopping secondary CPUs Kernel Offset:
> disabled CPU features: 0x0,21806000 Memory Limit: none
> 
> What I saw is when I try to bind on some mount point to
> /proc/{pid}/ns/net which made by child process, That's doesn't
> increase the netns' refcnt.

Why would it?  Increase of netns refcount should happen when you
follow /proc/*/ns/net and stay for as long as nsfs inode is alive,
not by cloning that mount.  And while we are at it, you don't need
to bind it anywhere in order to call setns() - just open the
sucker and then feed the resulting descriptor to setns(2).  No
mount --bind involved and if child exiting between open() and
setns() would free netns, we would have exact same problem.

> And when the child process's going to exit, it frees the netns But
> Still bind mount point's inode's private data point to netns which was
> freed by child when it exits.

Look: we call ns_get_path(), which calls ns_get_path_cb(), which
calls the callback passed to it (ns_get_path_task(), in this case),
which grabs a reference to ns.  Then we pass that reference to
__ns_get_path().

__ns_get_path() looks for dentry stashed in ns.  If there is one
and it's still alive, we grab a reference to that dentry and drop
the reference to ns - no new inodes had been created, so no new
namespace references have appeared.  Existing inode is pinned
by dentry and dentry is pinned by _dentry_ reference we've got.

If dentry is not there or is already in the middle of being destroyed,
we allocate a new inode, stash our namespace reference into it,
create a dentry referencing that new inode, stash it into namespace
and return that dentry.  Without dropping namespace reference we'd
obtained in ns_get_path_task() - it went into new inode.

If inode or dentry creation fails (out of memory), we drop what
we'd obtained (namespace if inode creation fails, just the inode
if dentry creation fails - namespace reference that went into
inode will be dropped by inode destructor in the latter case) and
return an error.

If somebody else manages to get through the entire thing while
we'd been allocating stuff and we see _their_ dentry already
stashed into namespace, we just drop our dentry (its destructor
will drop inode reference, which will lead to inode destructor,
which will drop namespace reference) and bugger off with -EAGAIN.
The caller (ns_get_path_cb()) will retry the entire thing.

The invariant to be preserved here is "each of those inodes
holds a reference to namespace for as long as the inode exists".
ns_get_path() increments namespace refcount if and only if it
has allocated an nsfs inode.  If it grabs an existing dentry
instead, the namespace refcount remains unchanged.

Anyway, I would really like to see .config and C (or shell)
reproducer.  Ideally - .config that could be run in a KVM.
