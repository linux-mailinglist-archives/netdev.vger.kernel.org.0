Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046CB398518
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 11:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhFBJSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 05:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229603AbhFBJSU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 05:18:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F55260FE3;
        Wed,  2 Jun 2021 09:16:34 +0000 (UTC)
Date:   Wed, 2 Jun 2021 11:16:32 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210602091632.qijrpc2z6z44wu54@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20210601080654.cl7caplm7rsagl6u@wittgenstein>
 <20210601132602.02e92678@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210601132602.02e92678@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 01:26:02PM -0700, Jakub Kicinski wrote:
> On Tue, 1 Jun 2021 10:06:54 +0200 Christian Brauner wrote:
> > > I'm not sure why we'd pick runtime checks for something that can be
> > > perfectly easily solved at compilation time. Networking should not
> > > be asking for FDs for objects which don't exist.  
> > 
> > Agreed!
> > This should be fixable by sm like:
> > 
> > diff --git a/net/socket.c b/net/socket.c
> > index 27e3e7d53f8e..2484466d96ad 100644
> > --- a/net/socket.c
> > +++ b/net/socket.c
> > @@ -1150,10 +1150,12 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
> >                         break;
> >                 case SIOCGSKNS:
> >                         err = -EPERM;
> > +#ifdef CONFIG_NET_NS
> >                         if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> >                                 break;
> > 
> >                         err = open_related_ns(&net->ns, get_net_ns);
> > +#endif
> >                         break;
> >                 case SIOCGSTAMP_OLD:
> >                 case SIOCGSTAMPNS_OLD:
> 
> Thanks! You weren't CCed on v1, so FWIW I was suggesting
> checking in get_net_ns(), to catch other callers:
> 
> diff --git a/net/socket.c b/net/socket.c
> index 27e3e7d53f8e..3b44f2700e0c 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1081,6 +1081,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
>  
>  struct ns_common *get_net_ns(struct ns_common *ns)
>  {
> +       if (!IS_ENABLED(CONFIG_NET_NS))
> +               return ERR_PTR(-EOPNOTSUPP);
>         return &get_net(container_of(ns, struct net, ns))->ns;
>  }
>  EXPORT_SYMBOL_GPL(get_net_ns);

Yeah, that's better than my hack. :) Maybe this function should simply
move over to net/core/net_namespace.c with the other netns getters, e.g.
get_net_ns_by_fd()?

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

Christian
