Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A197339D84F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhFGJKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 05:10:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhFGJKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 05:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5302B61107;
        Mon,  7 Jun 2021 09:08:47 +0000 (UTC)
Date:   Mon, 7 Jun 2021 11:08:44 +0200
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
Message-ID: <20210607090844.mje2xgdkcnqsezlu@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein>
 <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
 <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
 <CAM_iQpUqp1PRKfS6WcsZ16yjF4jjOrkTHX7Zdhrqo0nrE2VH1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAM_iQpUqp1PRKfS6WcsZ16yjF4jjOrkTHX7Zdhrqo0nrE2VH1Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 05:37:40PM -0700, Cong Wang wrote:
> On Fri, Jun 4, 2021 at 2:54 AM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
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
> 
> Let me explain it in this more straight way: what is the protocol here
> for indication of !CONFIG_XXX_NS? Clearly it must be ns->ops==NULL,
> because all namespaces use the following similar pattern:
> 
> #ifdef CONFIG_NET_NS
>         net->ns.ops = &netns_operations;
> #endif
> 
> Now you are arguing the protocol is not this, but it is the getter of
> open_related_ns() returns an error pointer.

I don't understand what this is supposed to tell me.

> 
> >
> > (Pluse they are defined in a central place in net/net_namespace.{c,h}.
> > That includes the low-level get_net() function and all the others.
> > get_net_ns() is the only one that's defined out of band. So get_net_ns()
> > currently is arguably also misplaced.)
> 
> Of course they do, only struct ns_common is generic. What's your
> point? Each ns.ops is defined by each namespace too.

All netns helpers should arguably be located in a central place
including get_net_ns(). There's no need to spread such helpers
everywhere. This is completely orthogonaly to struct ns_common.

> 
> >
> > The problem I have with fixing this in nsfs is that it gives the
> > impression that this is a bug in nsfs whereas it isn't and it
> > potentially helps tapering over other bugs.
> 
> Like I keep saying, this is just a protocol, there is no right or
> wrong here. If the protocol is just ops==NULL, then there is nothing
> wrong use it.
> 
> (BTW, we have a lot of places that use ops==NULL as a protocol,
> they work really well.)
> 
> >
> > get_net_ns() is only called for codepaths that call into nsfs via
> > open_related_ns() and it's the only namespace that does this. But
> 
> I am pretty sure userns does the same:
> 
> 197         case NS_GET_USERNS:
> 198                 return open_related_ns(ns, ns_get_owner);

Maybe I wasn't clear enough, open_related_ns() is the only namespace
that calls into nsfs via open_related_ns() __outside__ of fs/nsfs.c I
thought that was pretty clear.

But also...

#ifdef CONFIG_USER_NS
struct ns_common *ns_get_owner(struct ns_common *ns);
#else
static inline struct ns_common *ns_get_owner(struct ns_common *ns)
{
	return ERR_PTR(-EPERM);
}
#endif

So ns_get_owner() returns -EPERM when !CONFIG_USER_NS so the callback
handles the !CONFIG_USER_NS case. And that's what we were saying
get_net_ns() should do.

> 
> 
> > open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
> > set. For example, none of the procfs namespace f_ops will be set for
> > !CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
> > it doesn't account for !CONFIG_NET_NS and it should be fixed.
> 
> If the protocol is just ops==NULL, then the core part should just check
> ops==NULL. Pure and simple. I have no idea why you do not admit the
> fact that every namespace intentionally leaves ops as NULL when its
> config is disabled.

I'm just going to quote myself:

> > set. For example, none of the procfs namespace f_ops will be set for
> > !CONFIG_NET_NS.

If a given namespace type isn't selected then it will never appear in
/proc/<pid>/ns/* which is why the proc_ns_operations aren't defined in
fs/proc/namespaces.c.

In other words, you can't get a file descriptor for a given namespace
through proc or rather the nsfs part of proc when that namespace type
isn't selected.

The open_related_ns() function is a function that is just there to give
you a namespace fd and it assumes that when it is called that the
namespace type is selected for or that the callback you're passing it
handles that case.

For example, see you're own example about ns_get_owner() above.

> 
> >
> > Plus your fix leaks references to init netns without fixing get_net_ns()
> > too.
> 
> I thought it is 100% clear that this patch is not from me?
> 
> Plus, the PoC patch from me actually suggests to change
> open_related_ns(), not __ns_get_path(). I have no idea why you
> both miss it.

Turning this around, I'm not sure what your resistance to just doing it
like ns_get_owner() is doing it is.

Christian
