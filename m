Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B3639B643
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 11:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhFDJ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 05:56:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhFDJ4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 05:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96D516140C;
        Fri,  4 Jun 2021 09:54:54 +0000 (UTC)
Date:   Fri, 4 Jun 2021 11:54:51 +0200
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
Message-ID: <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein>
 <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 03:52:29PM -0700, Cong Wang wrote:
> On Wed, Jun 2, 2021 at 2:14 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > But the point is that ns->ops should never be accessed when that
> > namespace type is disabled. Or in other words, the bug is that something
> > in netns makes use of namespace features when they are disabled. If we
> > handle ->ops being NULL we might be tapering over a real bug somewhere.
> 
> It is merely a protocol between fs/nsfs.c and other namespace users,
> so there is certainly no right or wrong here, the only question is which
> one is better.
> 
> >
> > Jakub's proposal in the other mail makes sense and falls in line with
> > how the rest of the netns getters are implemented. For example
> > get_net_ns_fd_fd():
> 
> It does not make any sense to me. get_net_ns() merely increases
> the netns refcount, which is certainly fine for init_net too, no matter
> CONFIG_NET_NS is enabled or disabled. Returning EOPNOTSUPP
> there is literally saying we do not support increasing init_net refcount,
> which is of course false.
> 
> > struct net *get_net_ns_by_fd(int fd)
> > {
> >         return ERR_PTR(-EINVAL);
> > }
> 
> There is a huge difference between just increasing netns refcount
> and retrieving it by fd, right? I have no idea why you bring this up,
> calling them getters is missing their difference.

This argument doesn't hold up. All netns helpers ultimately increase the
reference count of the net namespace they find. And if any of them
perform operations where they are called in environments wherey they
need CONFIG_NET_NS they handle this case at compile time.

(Pluse they are defined in a central place in net/net_namespace.{c,h}.
That includes the low-level get_net() function and all the others.
get_net_ns() is the only one that's defined out of band. So get_net_ns()
currently is arguably also misplaced.)

The problem I have with fixing this in nsfs is that it gives the
impression that this is a bug in nsfs whereas it isn't and it
potentially helps tapering over other bugs.

get_net_ns() is only called for codepaths that call into nsfs via
open_related_ns() and it's the only namespace that does this. But
open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
set. For example, none of the procfs namespace f_ops will be set for
!CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
it doesn't account for !CONFIG_NET_NS and it should be fixed.

Plus your fix leaks references to init netns without fixing get_net_ns()
too.
You succeed to increase the refcount of init netns in get_net_ns() but
then you return in __ns_get_path() because ns->ops aren't set before
ns->ops->put() can be called.  But you also _can't_ call it since it's
not set because !CONFIG_NET_NS. So everytime you call any of those
ioctls you increas the refcount of init net ns without decrementing it
on failure. So the fix is buggy as it is too and would suggest you to
fixup get_net_ns() too.

Cc: <stable@vger.kernel.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Changbin Du <changbin.du@gmail.com>
---
 fs/nsfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/nsfs.c b/fs/nsfs.c
index 800c1d0eb0d0..6c055eb7757b 100644
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
 	struct inode *inode;
 	unsigned long d;
 
+	/* In case the namespace is not actually enabled. */
+	if (!ns->ops)
+		return -EOPNOTSUPP;
+
 	rcu_read_lock();
 	d = atomic_long_read(&ns->stashed);
 	if (!d)
-- 
2.30.2


