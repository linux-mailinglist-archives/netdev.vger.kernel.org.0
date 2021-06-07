Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED70639D870
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFGJSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 05:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230246AbhFGJSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 05:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A2AC61002;
        Mon,  7 Jun 2021 09:16:49 +0000 (UTC)
Date:   Mon, 7 Jun 2021 11:16:47 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Changbin Du <changbin.du@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210607091647.pzqyarxbupvnbxyw@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein>
 <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
 <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
 <20210606224322.yxr47tgdqis35dcl@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210606224322.yxr47tgdqis35dcl@mail.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 06:43:41AM +0800, Changbin Du wrote:
> On Fri, Jun 04, 2021 at 11:54:51AM +0200, Christian Brauner wrote:
> > On Thu, Jun 03, 2021 at 03:52:29PM -0700, Cong Wang wrote:
> > > On Wed, Jun 2, 2021 at 2:14 AM Christian Brauner
> > > <christian.brauner@ubuntu.com> wrote:
> > > > But the point is that ns->ops should never be accessed when that
> > > > namespace type is disabled. Or in other words, the bug is that something
> > > > in netns makes use of namespace features when they are disabled. If we
> > > > handle ->ops being NULL we might be tapering over a real bug somewhere.
> > > 
> > > It is merely a protocol between fs/nsfs.c and other namespace users,
> > > so there is certainly no right or wrong here, the only question is which
> > > one is better.
> > > 
> > > >
> > > > Jakub's proposal in the other mail makes sense and falls in line with
> > > > how the rest of the netns getters are implemented. For example
> > > > get_net_ns_fd_fd():
> > > 
> > > It does not make any sense to me. get_net_ns() merely increases
> > > the netns refcount, which is certainly fine for init_net too, no matter
> > > CONFIG_NET_NS is enabled or disabled. Returning EOPNOTSUPP
> > > there is literally saying we do not support increasing init_net refcount,
> > > which is of course false.
> > > 
> > > > struct net *get_net_ns_by_fd(int fd)
> > > > {
> > > >         return ERR_PTR(-EINVAL);
> > > > }
> > > 
> > > There is a huge difference between just increasing netns refcount
> > > and retrieving it by fd, right? I have no idea why you bring this up,
> > > calling them getters is missing their difference.
> > 
> > This argument doesn't hold up. All netns helpers ultimately increase the
> > reference count of the net namespace they find. And if any of them
> > perform operations where they are called in environments wherey they
> > need CONFIG_NET_NS they handle this case at compile time.
> > 
> > (Pluse they are defined in a central place in net/net_namespace.{c,h}.
> > That includes the low-level get_net() function and all the others.
> > get_net_ns() is the only one that's defined out of band. So get_net_ns()
> > currently is arguably also misplaced.)
> > 
> Ihe get_net_ns() was a static helper function and then sb made it exported
> but didn't move it. See commit d8d211a2a0 ('net: Make extern and export get_net_ns()').
> 
> > The problem I have with fixing this in nsfs is that it gives the
> > impression that this is a bug in nsfs whereas it isn't and it
> > potentially helps tapering over other bugs.
> > 
> > get_net_ns() is only called for codepaths that call into nsfs via
> > open_related_ns() and it's the only namespace that does this. But
> > open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
> > set. For example, none of the procfs namespace f_ops will be set for
> > !CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
> > it doesn't account for !CONFIG_NET_NS and it should be fixed.
> I agree with Cong that a pure getter returns a generic error is a bit weird.
> And get_net_ns() is to get the ns_common which always exists indepent of
> CONFIG_NET_NS. For get_net_ns_by_fd(), I think it is a 'findder + getter'.
> 
> So maybe we can rollback to patch V1 to fix all code called into
> open_related_ns()?
> https://lore.kernel.org/netdev/CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com/T/
> 
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
>  			mutex_unlock(&vlan_ioctl_mutex);
>  			break;
>  		case SIOCGSKNS:
> +#ifdef CONFIG_NET_NS
>  			err = -EPERM;
>  			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>  				break;
>  
>  			err = open_related_ns(&net->ns, get_net_ns);
> +#else
> +			err = -ENOTSUPP;
> +#endif

If Jakub is fine with it I don't really care much but then you need to
fix the other places in tun.c as well.
I'm just not sure what's so special about get_net_ns() that it can't
simply get an ifdef !CONFIG_NET_NS section.
But it seems that there's magic semantics deeply hidden in this helper
that btw only exists for open_related_ns() that makes this necessary:

drivers/net/tun.c:              return open_related_ns(&net->ns, get_net_ns);
drivers/net/tun.c:              ret = open_related_ns(&net->ns, get_net_ns);
include/linux/socket.h:extern struct ns_common *get_net_ns(struct ns_common *ns);
net/socket.c: * get_net_ns - increment the refcount of the network namespace
net/socket.c:struct ns_common *get_net_ns(struct ns_common *ns)
net/socket.c:EXPORT_SYMBOL_GPL(get_net_ns);
net/socket.c:                   err = open_related_ns(&net->ns, get_net_ns);
tools/perf/trace/beauty/include/linux/socket.h:extern struct ns_common *get_net_ns(struct ns_common *ns);

> 
> > 
> > Plus your fix leaks references to init netns without fixing get_net_ns()
> > too.
> > You succeed to increase the refcount of init netns in get_net_ns() but
> > then you return in __ns_get_path() because ns->ops aren't set before
> > ns->ops->put() can be called.  But you also _can't_ call it since it's
> > not set because !CONFIG_NET_NS. So everytime you call any of those
> > ioctls you increas the refcount of init net ns without decrementing it
> > on failure. So the fix is buggy as it is too and would suggest you to
> > fixup get_net_ns() too.
> Yes, it is a problem. Can be put a BUG_ON() in nsfs so that such bug (calling
> into nsfs without ops) can be catched early?

Maybe place a WARN_ON() in there.

Christian
