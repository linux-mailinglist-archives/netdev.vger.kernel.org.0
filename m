Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9239850E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 11:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhFBJQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 05:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhFBJQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 05:16:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE94610A8;
        Wed,  2 Jun 2021 09:14:54 +0000 (UTC)
Date:   Wed, 2 Jun 2021 11:14:51 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210602091451.kbdul6nhobilwqvi@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 12:51:51PM -0700, Cong Wang wrote:
> On Mon, May 31, 2021 at 10:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Mon, 31 May 2021 23:34:10 +0800 Changbin Du wrote:
> > > We should not create inode for disabled namespace. A disabled namespace
> > > sets its ns->ops to NULL. Kernel could panic if we try to create a inode
> > > for such namespace.
> > >
> > > Here is an example oops in socket ioctl cmd SIOCGSKNS when NET_NS is
> > > disabled. Kernel panicked wherever nsfs trys to access ns->ops since the
> > > proc_ns_operations is not implemented in this case.
> > >
> > > [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> > > [7.670268] pgd = 32b54000
> > > [7.670544] [00000010] *pgd=00000000
> > > [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> > > [7.672315] Modules linked in:
> > > [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> > > [7.673309] Hardware name: Generic DT based system
> > > [7.673642] PC is at nsfs_evict+0x24/0x30
> > > [7.674486] LR is at clear_inode+0x20/0x9c
> > >
> > > So let's reject such request for disabled namespace.
> > >
> > > Signed-off-by: Changbin Du <changbin.du@gmail.com>
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: David Laight <David.Laight@ACULAB.COM>
> > > ---
> > >  fs/nsfs.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/nsfs.c b/fs/nsfs.c
> > > index 800c1d0eb0d0..6c055eb7757b 100644
> > > --- a/fs/nsfs.c
> > > +++ b/fs/nsfs.c
> > > @@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
> > >       struct inode *inode;
> > >       unsigned long d;
> > >
> > > +     /* In case the namespace is not actually enabled. */
> > > +     if (!ns->ops)
> > > +             return -EOPNOTSUPP;
> > > +
> > >       rcu_read_lock();
> > >       d = atomic_long_read(&ns->stashed);
> > >       if (!d)
> >
> > I'm not sure why we'd pick runtime checks for something that can be
> > perfectly easily solved at compilation time. Networking should not
> > be asking for FDs for objects which don't exist.
> 
> Four reasons:
> 
> 1) ioctl() is not a hot path, so performance is not a problem here.

Hm, I think a compile time check is better than a runtime check
independent of performance benefits.

> 
> 2) There are 3 different places (tun has two more) that need the same
> fix.


> 
> 3) init_net always exits, except it does not have an ops when
> CONFIG_NET_NS is disabled:

Which is true for every namespace.

> 
> static __net_init int net_ns_net_init(struct net *net)
> {
> #ifdef CONFIG_NET_NS
>         net->ns.ops = &netns_operations;
> #endif
>         return ns_alloc_inum(&net->ns);
> }
> 
> 4) *I think* other namespaces need this fix too, for instance
> init_ipc_ns:

None of them should have paths to trigger ->ops.

> 
> struct ipc_namespace init_ipc_ns = {
>         .ns.count = REFCOUNT_INIT(1),
>         .user_ns = &init_user_ns,
>         .ns.inum = PROC_IPC_INIT_INO,
> #ifdef CONFIG_IPC_NS
>         .ns.ops = &ipcns_operations,
> #endif
> };
> 
> whose ns->ops is NULL too if disabled.

But the point is that ns->ops should never be accessed when that
namespace type is disabled. Or in other words, the bug is that something
in netns makes use of namespace features when they are disabled. If we
handle ->ops being NULL we might be tapering over a real bug somewhere.

Jakub's proposal in the other mail makes sense and falls in line with
how the rest of the netns getters are implemented. For example
get_net_ns_fd_fd():

#ifdef CONFIG_NET_NS

[...]

struct net *get_net_ns_by_fd(int fd)
{
	struct file *file;
	struct ns_common *ns;
	struct net *net;

	file = proc_ns_fget(fd);
	if (IS_ERR(file))
		return ERR_CAST(file);

	ns = get_proc_ns(file_inode(file));
	if (ns->ops == &netns_operations)
		net = get_net(container_of(ns, struct net, ns));
	else
		net = ERR_PTR(-EINVAL);

	fput(file);
	return net;
}

#else
struct net *get_net_ns_by_fd(int fd)
{
	return ERR_PTR(-EINVAL);
}
#endif
EXPORT_SYMBOL_GPL(get_net_ns_by_fd);

(It seems that "get_net_ns()" could also be moved into the same file as
get_net_ns_by_fd() btw.)

Christian
