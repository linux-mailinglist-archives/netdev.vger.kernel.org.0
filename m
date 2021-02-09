Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166A3314889
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 07:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhBIGQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 01:16:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhBIGP4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 01:15:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF97264EB8;
        Tue,  9 Feb 2021 06:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612851315;
        bh=a7ndhO7sYv1/e3+bqD0RFzvVKWKeRKjNuOSPf7QgqyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fv4UohDKldrz01lbMyNhgCf3pU8u0aPY+GosGBrpYYhMmLvTbzMos8nACFtxJOZ+1
         jHqyH9EgExWph4B+q82Oxx7CYh3MV6hj2CGcN9zwWRTzheSNPY3IKnYS6In5EIS4S8
         I9uFeyU6Je4gga/E5JhAYrlvW7dByMzCEIdDxuSGyTQT04jKhdGg8Ozu7KGAUPIzII
         FxjKXSrCkOfPvoDxuFWUKr+jzmBWLcb5EnTpa4uf48ex5ebCZOXTqHHLC4CrmLaO3N
         4Tymi+b4yxrGAXTrUjYzDHfteDrpbN+U4LHyR6umr8p0yi1DcrxiOQppeHV30TjWzr
         Kcz/jJTA/qdAQ==
Date:   Tue, 9 Feb 2021 08:15:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, arjunroy@google.com, edumazet@google.com,
        soheil@google.com, David Ahern <dsahern@gmail.com>
Subject: Re: [net-next v2] tcp: Explicitly mark reserved field in
 tcp_zerocopy_receive args.
Message-ID: <20210209061511.GI20265@unreal>
References: <20210206203648.609650-1-arjunroy.kdev@gmail.com>
 <20210206152828.6610da2b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210207082654.GC4656@unreal>
 <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208104143.60a6d730@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 10:41:43AM -0800, Jakub Kicinski wrote:
> On Sun, 7 Feb 2021 10:26:54 +0200 Leon Romanovsky wrote:
> > On Sat, Feb 06, 2021 at 03:28:28PM -0800, Jakub Kicinski wrote:
> > > On Sat,  6 Feb 2021 12:36:48 -0800 Arjun Roy wrote:
> > > > From: Arjun Roy <arjunroy@google.com>
> > > >
> > > > Explicitly define reserved field and require it to be 0-valued.
> > >
> > > > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > > > index e1a17c6b473c..c8469c579ed8 100644
> > > > --- a/net/ipv4/tcp.c
> > > > +++ b/net/ipv4/tcp.c
> > > > @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
> > > >  		}
> > > >  		if (copy_from_user(&zc, optval, len))
> > > >  			return -EFAULT;
> > > > +		if (zc.reserved)
> > > > +			return -EINVAL;
> > > >  		lock_sock(sk);
> > > >  		err = tcp_zerocopy_receive(sk, &zc, &tss);
> > > >  		release_sock(sk);
> > >
> > > I was expecting we'd also throw in a check_zeroed_user().
> > > Either we can check if the buffer is zeroed all the way,
> > > or we can't and we shouldn't validate reserved either
> > >
> > > 	check_zeroed_user(optval + offsetof(reserved),
> > > 			  len - offsetof(reserved))
> > > ?
> >
> > There is a check that len is not larger than zs and users can't give
> > large buffer.
> >
> > I would say that is pretty safe to write "if (zc.reserved)".
>
> Which check? There's a check which truncates (writes back to user space
> len = min(len, sizeof(zc)). Application can still pass garbage beyond
> sizeof(zc) and syscall may start failing in the future if sizeof(zc)
> changes.

At least in my tree, we have the length check:
  4155                 if (len > sizeof(zc)) {
  4156                         len = sizeof(zc);
  4157                         if (put_user(len, optlen))
  4158                                 return -EFAULT;
  4159                 }


Ad David wrote below, the "if (zc.reserved)" is enough.

We have following options:
1. Old kernel that have sizeof(sz) upto .reserved and old userspace
-> len <= sizeof(sz) - works correctly.
2. Old kernel that have sizeof(sz) upto .reserved and new userspace that
sends larger struct -> "f (len > sizeof(zc))" will return -EFAULT
3. New kernel that have sizeof(sz) beyond reserved and old userspace
-> any new added field to struct sz should be checked and anyway it is the same as item 1.
4. New kernel and new userspace
-> standard flow.

Thanks
