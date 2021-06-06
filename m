Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B7A39D1F7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 00:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhFFWp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 18:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhFFWp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 18:45:58 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABDEC061766;
        Sun,  6 Jun 2021 15:43:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id u18so11677148pfk.11;
        Sun, 06 Jun 2021 15:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eNOF3ocK1bnUV5j829woqGXLqBC6/W8Y2N0Kd8NG6pU=;
        b=Xo4ahIrmK/5Yqr9D9Pqtra0ehH3DD09lw6u2D6Z/wvb0ot9Ja4Q7aceJXGNZUtehCe
         wZdE6epDvJ1xtNPJ/zQ+SO/gSsoMeDzGanbzgrYAhq6Z0fgnCW0W2ZUILOuXYpto0C6a
         bI16PfMH53jZtjbuhbh7dlRLxF44H8L6sf2XwZaS43NEM89sii57Vn0Kq9P/p0gBn2i/
         EDHANfe+f6Xv8k+QKoGqHU6a469R+AXKhxZH7lo1NBikI5PsuQ6tutTA62qQNz6SFA8C
         qXWJS3wXyeiDebcgIZ6zjwZph8NHE0S4vS8UgwnP3j0VWq+uw1Emw8DCJ/U36jmyedsl
         ez5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eNOF3ocK1bnUV5j829woqGXLqBC6/W8Y2N0Kd8NG6pU=;
        b=Uo3oJfs/m8enhKJVDeggTGQXx55FGElNZclCVBazAtgBb1ACw4YQzIgicLbP4lE8FU
         qIuJtyrb9x+DEGzDyzP7XCaAo+MIfbwvV2mDyfg3/Of8JBN5SyvS8CyuU3LQ6Qc+LdE9
         LquiHl8hvMOHXe720+zFeACezOEUV9+BgnWyfPq5v+6RhuRmZeEilsVFjiOmeKCEQRN9
         uRbSVfAzT6SWf3zIBm5q+/LGxw8js0wnDwxY004NmjmkeeEJydR6lW+L99CNIU4SnTV9
         O6hpvv7/zpnI0juLWGLd5PjKIYbAzLh75L+W+CJBK/hoT8QyAIhrN3RlXAqozhFYVsNv
         cyXA==
X-Gm-Message-State: AOAM5315rzO77VQ4T0i/oPizWSFU7CPZeeRW/m6xix/nt6t6ByyE7A/Q
        yunqXlZiEDH01JRh6PgvUNOO7qNuMGI2jg==
X-Google-Smtp-Source: ABdhPJwaddkKb2bZBzrmNU3GQ/oZe3ox6eCtYA7qPpTT6KSyu90ElG4mZIt0tkwai1olP+sLbhAmhA==
X-Received: by 2002:a62:8491:0:b029:2e9:c618:fa32 with SMTP id k139-20020a6284910000b02902e9c618fa32mr14598919pfd.15.1623019430666;
        Sun, 06 Jun 2021 15:43:50 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id x22sm6498245pfn.10.2021.06.06.15.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 15:43:49 -0700 (PDT)
Date:   Mon, 7 Jun 2021 06:43:41 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210606224322.yxr47tgdqis35dcl@mail.google.com>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAM_iQpUEjBDK44=mD5shkmmoDYhmHQaSZtR34rLRkgd9wSWiQQ@mail.gmail.com>
 <20210602091451.kbdul6nhobilwqvi@wittgenstein>
 <CAM_iQpUqgeoY_mA6cazUPCWwMK6yw9SaD6DRg-Ja4r6r_zOmLg@mail.gmail.com>
 <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604095451.nkfgpsibm5nrqt3f@wittgenstein>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 11:54:51AM +0200, Christian Brauner wrote:
> On Thu, Jun 03, 2021 at 03:52:29PM -0700, Cong Wang wrote:
> > On Wed, Jun 2, 2021 at 2:14 AM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > > But the point is that ns->ops should never be accessed when that
> > > namespace type is disabled. Or in other words, the bug is that something
> > > in netns makes use of namespace features when they are disabled. If we
> > > handle ->ops being NULL we might be tapering over a real bug somewhere.
> > 
> > It is merely a protocol between fs/nsfs.c and other namespace users,
> > so there is certainly no right or wrong here, the only question is which
> > one is better.
> > 
> > >
> > > Jakub's proposal in the other mail makes sense and falls in line with
> > > how the rest of the netns getters are implemented. For example
> > > get_net_ns_fd_fd():
> > 
> > It does not make any sense to me. get_net_ns() merely increases
> > the netns refcount, which is certainly fine for init_net too, no matter
> > CONFIG_NET_NS is enabled or disabled. Returning EOPNOTSUPP
> > there is literally saying we do not support increasing init_net refcount,
> > which is of course false.
> > 
> > > struct net *get_net_ns_by_fd(int fd)
> > > {
> > >         return ERR_PTR(-EINVAL);
> > > }
> > 
> > There is a huge difference between just increasing netns refcount
> > and retrieving it by fd, right? I have no idea why you bring this up,
> > calling them getters is missing their difference.
> 
> This argument doesn't hold up. All netns helpers ultimately increase the
> reference count of the net namespace they find. And if any of them
> perform operations where they are called in environments wherey they
> need CONFIG_NET_NS they handle this case at compile time.
> 
> (Pluse they are defined in a central place in net/net_namespace.{c,h}.
> That includes the low-level get_net() function and all the others.
> get_net_ns() is the only one that's defined out of band. So get_net_ns()
> currently is arguably also misplaced.)
> 
Ihe get_net_ns() was a static helper function and then sb made it exported
but didn't move it. See commit d8d211a2a0 ('net: Make extern and export get_net_ns()').

> The problem I have with fixing this in nsfs is that it gives the
> impression that this is a bug in nsfs whereas it isn't and it
> potentially helps tapering over other bugs.
> 
> get_net_ns() is only called for codepaths that call into nsfs via
> open_related_ns() and it's the only namespace that does this. But
> open_related_ns() is only well defined if CONFIG_<NAMESPACE_TYPE> is
> set. For example, none of the procfs namespace f_ops will be set for
> !CONFIG_NET_NS. So clearly the socket specific getter here is buggy as
> it doesn't account for !CONFIG_NET_NS and it should be fixed.
I agree with Cong that a pure getter returns a generic error is a bit weird.
And get_net_ns() is to get the ns_common which always exists indepent of
CONFIG_NET_NS. For get_net_ns_by_fd(), I think it is a 'findder + getter'.

So maybe we can rollback to patch V1 to fix all code called into
open_related_ns()?
https://lore.kernel.org/netdev/CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com/T/

--- a/net/socket.c
+++ b/net/socket.c
@@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			mutex_unlock(&vlan_ioctl_mutex);
 			break;
 		case SIOCGSKNS:
+#ifdef CONFIG_NET_NS
 			err = -EPERM;
 			if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 				break;
 
 			err = open_related_ns(&net->ns, get_net_ns);
+#else
+			err = -ENOTSUPP;
+#endif

> 
> Plus your fix leaks references to init netns without fixing get_net_ns()
> too.
> You succeed to increase the refcount of init netns in get_net_ns() but
> then you return in __ns_get_path() because ns->ops aren't set before
> ns->ops->put() can be called.  But you also _can't_ call it since it's
> not set because !CONFIG_NET_NS. So everytime you call any of those
> ioctls you increas the refcount of init net ns without decrementing it
> on failure. So the fix is buggy as it is too and would suggest you to
> fixup get_net_ns() too.
Yes, it is a problem. Can be put a BUG_ON() in nsfs so that such bug (calling
into nsfs without ops) can be catched early?

> 
> Cc: <stable@vger.kernel.org>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: David Laight <David.Laight@ACULAB.COM>
> Signed-off-by: Changbin Du <changbin.du@gmail.com>
> ---
>  fs/nsfs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 800c1d0eb0d0..6c055eb7757b 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
>  	struct inode *inode;
>  	unsigned long d;
>  
> +	/* In case the namespace is not actually enabled. */
> +	if (!ns->ops)
> +		return -EOPNOTSUPP;
> +
>  	rcu_read_lock();
>  	d = atomic_long_read(&ns->stashed);
>  	if (!d)
> -- 
> 2.30.2
> 
> 

-- 
Cheers,
Changbin Du
