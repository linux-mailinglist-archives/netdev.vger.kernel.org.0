Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA851A1385
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 20:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgDGS0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 14:26:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46958 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGS0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 14:26:43 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLsvJ-00DKY3-Bm; Tue, 07 Apr 2020 18:26:09 +0000
Date:   Tue, 7 Apr 2020 19:26:09 +0100
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
Message-ID: <20200407182609.GA23230@ZenIV.linux.org.uk>
References: <20200407023512.GA25005@ubuntu>
 <20200407030504.GX23230@ZenIV.linux.org.uk>
 <20200407031318.GY23230@ZenIV.linux.org.uk>
 <CAM7-yPQas7hvTVLa4U80t0Em0HgLCk2whLQa4O3uff5J3OYiAA@mail.gmail.com>
 <20200407040354.GZ23230@ZenIV.linux.org.uk>
 <CAM7-yPRaQsNgZKjru40nM1N_u8HVLVKmJCAzu20DcPL=jzKjWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM7-yPRaQsNgZKjru40nM1N_u8HVLVKmJCAzu20DcPL=jzKjWQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 09:53:29PM +0900, Yun Levi wrote:
> BTW, It's my question.
> 
> >Look: we call ns_get_path(), which calls ns_get_path_cb(), which
> >calls the callback passed to it (ns_get_path_task(), in this case),
> >which grabs a reference to ns.  Then we pass that reference to
> >__ns_get_path().
> >
> >__ns_get_path() looks for dentry stashed in ns.  If there is one
> >and it's still alive, we grab a reference to that dentry and drop
> >the reference to ns - no new inodes had been created, so no new
> >namespace references have appeared.  Existing inode is pinned
> >by dentry and dentry is pinned by _dentry_ reference we've got.
> 
> actually ns_get_path is called in unshare(2).

Yes, it does.  Via perf_event_namespaces(), which does
        perf_fill_ns_link_info(&ns_link_info[NET_NS_INDEX],
                               task, &netns_operations);
and there we have
        error = ns_get_path(&ns_path, task, ns_ops);
        if (!error) {
                ns_inode = ns_path.dentry->d_inode;
                ns_link_info->dev = new_encode_dev(ns_inode->i_sb->s_dev);
                ns_link_info->ino = ns_inode->i_ino;
                path_put(&ns_path);
        }
See that path_put()?  Dentry reference is dropped by it.

> and it makes new dentry and
> inode in __ns_get_path finally (Cuz it create new network namespace)
>
> In that case, when I mount with --bind option to this proc/self/ns/net, it
> only increase dentry refcount on do_loopback->clone_mnt finally (not call
> netns_operation->get)
> That means it's not increase previous created network namespace reference
> count but only increase reference count of _dentry_
>
> In that situation, If I exit the child process it definitely frees the
> net_namespace previous created at the same time it decrease net_namespace's
> refcnt in exit_task_namespace().
> It means it's possible that bind mount point can hold the dentry with inode
> having net_namespace's dangling pointer in another process.
> In above situation, parent who know that binded mount point calls setns(2)
> then it sets the net_namespace which is refered by the inode of the dentry
> increased by do_loopback.
> That makes set the net_namespace which was freed already.

How?  Netns reference in inode contributes to netns refcount.  And it's held
for as long as the _inode_ has positive refcount - we only drop it from
the inode destructor, *NOT* every time we drop a reference to inode.
In the similar fashion, the inode reference in dentry contributes to inode
refcount.  And again, that inode reference won't be dropped until the _last_
reference to dentry gets dropped.

Incrementing refcount of dentry is enough to pin the inode and thus the
netns the inode refers to.  It's a very common pattern with refcounting;
a useful way of thinking about it is to consider the refcount of e.g.
inode as sum of several components, one of them being "number of struct
dentry instances with ->d_inode pointing to our inode".  And look at e.g.
__ns_get_path() like this:
        rcu_read_lock();
        d = atomic_long_read(&ns->stashed);
        if (!d)
                goto slow;
        dentry = (struct dentry *)d;
        if (!lockref_get_not_dead(&dentry->d_lockref))
                goto slow;
other_count(dentry) got incremented by 1.
        rcu_read_unlock();
        ns->ops->put(ns);
other_count(ns) decremented by 1.
got_it:
        path->mnt = mntget(mnt);
        path->dentry = dentry;
path added to paths(dentry), other_count(dentry) decremented by 1 (getting
it back to the original value).
        return 0;
slow:   
        rcu_read_unlock();
        inode = new_inode_pseudo(mnt->mnt_sb);
        if (!inode) {
                ns->ops->put(ns);
subtract 1 from other_count(ns)
                return -ENOMEM;
        }
dentries(inode) = empty
other_count(inode) = 1
	....
	inode->i_private = ns;
add inode to inodes(ns), subtract 1 from other_count(ns); the total
is unchanged.
        dentry = d_alloc_anon(mnt->mnt_sb);
        if (!dentry) {
                iput(inode);
subtract 1 from other_count(inode).  Since now all components of
inode refcount are zero, inode gets destroyed.  Destructor calls
nsfs_evict_inode(), which removes the inode from inodes(ns).
The total effect: inode is destroyed, inodes(ns) is back to what
it used to be and other_count(ns) is left decremented by 1 compared
to what we used to have.  IOW, the balance is the same as if inode
allocation would've failed.
                return -ENOMEM;
        }
other_count(dentry) = 1
        d_instantiate(dentry, inode);
add dentry to dentries(inode), subtract 1 from other_count(inode).
The total is unchanged.  Now other_count(inode) is 0 and dentries(inode)
is {dentry}.
        d = atomic_long_cmpxchg(&ns->stashed, 0, (unsigned long)dentry);
        if (d) {
somebody else has gotten there first
                d_delete(dentry);       /* make sure ->d_prune() does nothing */
                dput(dentry);
subtract 1 from other_count(dentry) (which will drive it to 0).  Since
no other references exist, dentry gets destroyed.  Destructor will
remove dentry from dentries(inode) and since other_count(inode) is already
zero, trigger destruction of inode.  That, in turn, will remove inode
from inodes(ns).  Total effect: dentry is destroyed, inode is destroyed,
inodes(ns) is back to what it used to be, other_count(ns) is left decremented
by 1 compared to what we used to have.
                cpu_relax();
                return -EAGAIN;
        }
        goto got_it;
got_it:
        path->mnt = mntget(mnt);
        path->dentry = dentry;
add path to paths(dentry), subtract 1 from other_count(dentry).  At that
point other_count(dentry) is back to 0, ditto for other_count(inode) and
other_count(ns) is left decremented by 1 compared to what it used to be.
inode is added to inodes(ns), dentry - to dentries(inode) and path - to
paths(dentry).
        return 0;
and we are done.

In all cases the total effect is the same as far as "other" counts go:
other_count(ns) is down by 1 and that's the only change in other_count()
of *ANY* objects.  Of course we do not keep track of the sets explicitly;
it would cost too much and we only interested in the sum of their sizes
anyway.  What we actually store is the sum, so operations like "transfer
the reference from one component to another" are not immediately obvious
to be refcounting ones - the sum is unchanged.  Conceptually, though,
they are refcounting operations.
	Up to d_instantiate() we are holding a reference to inode;
after that we are *not* - it has been transferred to dentry.  That's
why on subsequent failure exits we do not call iput() - the inode
reference is not ours to discard anymore.
	In the same way, up to inode->i_private = ns; we are holding
a reference to ns.  After that we are not - it's been transferred to
inode.  From that point on it's not ours to discard; it will be
dropped when inode gets destroyed, whenever that happens.
