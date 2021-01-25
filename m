Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B65303134
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 02:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbhAZBZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 20:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731664AbhAYTju (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:39:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF172251F;
        Mon, 25 Jan 2021 19:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611603550;
        bh=NM6QezuvkVdnUg4w/1OOnz91QkvhZvtCsXq2cTkF6Co=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k047Z27m7kB/pfGJMY+O3oGHI+rudCwRLXNtfCAz0Iho28S+wsj5a/8Hegkv3pj4B
         VOSvXq2n4Qr/mhI8pirGnFlwhow4JtSP/Y6QrD5on4/zoJmTE89WYOU9of/iRKxz8c
         7nn8Qh2EuT5LkbtazpsNX9yt5feYx1axkiAK4JITyHtHuloNd6O36gdh2wOQCx3r+S
         60hl1+UYEXGku96s/rHP2u47Jrcgf6JlzdHe0sl9Vp1E3bBWoSmZUUzrq2K7er9C1G
         P+wwXjtlq2+EUUwuIUmg5k+S8F9iRquQC3+fHZ9dkQTdi6AVjXxzNB5L2qI2kn4W75
         2IicHmTVTKtQA==
Date:   Mon, 25 Jan 2021 11:39:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress
 handling
Message-ID: <20210125113908.6951b6f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210124103301.GA1056@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
        <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
        <CANn89iK3CC3fapmQpwwbVkGs4-+fmJF+nj0pmBHJ9fy6poWseg@mail.gmail.com>
        <20210124103301.GA1056@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Jan 2021 11:33:01 +0100 Lukas Wunner wrote:
> On Fri, Jan 22, 2021 at 10:40:05AM +0100, Eric Dumazet wrote:
> > On Fri, Jan 22, 2021 at 9:55 AM Lukas Wunner <lukas@wunner.de> wrote:  
> > > sch_handle_egress() returns either the skb or NULL to signal to its
> > > caller __dev_queue_xmit() whether a packet should continue to be
> > > processed.
> > >
> > > The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
> > > NULL pointer deref right at its top.
> > >
> > > But the compiler doesn't know that.  So if sch_handle_egress() signals
> > > success by returning the skb, the "if (!skb) goto out;" statement
> > > results in a gratuitous NULL pointer check in the Assembler output.
> > >
> > > Avoid by telling the compiler that __dev_queue_xmit() is never passed a
> > > NULL skb.  
> [...]
> > > we're about to add a netfilter egress hook to __dev_queue_xmit()
> > > and without the micro-optimization, it will result in a performance
> > > degradation which is indeed measurable:  
> [...]
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > +__attribute__((nonnull(1)))
> > >  static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > >  {
> > >         struct net_device *dev = skb->dev;  
> > 
> > It is a bit sad the compilers do not automatically get this knowledge
> > from the very first instruction :
> > 
> >  struct net_device *dev = skb->dev;  
> 
> The compiler (gcc) is capable of doing that, but the feature was disabled by:
> 
>     commit a3ca86aea507904148870946d599e07a340b39bf
>     Author: Eugene Teo <eteo@redhat.com>
>     Date:   Wed Jul 15 14:59:10 2009 +0800
>     
>     Add '-fno-delete-null-pointer-checks' to gcc CFLAGS
> 
> If -fno-delete-null-pointer-checks is dropped from the top-level Makefile
> then the gratuitous NULL pointer checks disappear from the Assembler output,
> obviating the need to litter hot paths with __attribute__((nonnull(1)))
> annotations.
> 
> Taking a closer look at that commit, its rationale appears questionable:
> It says that broken code such as ...
> 
> 	struct agnx_priv *priv = dev->priv;
> 
> 	if (!dev)
> 		return;
> 
> ... would result in the NULL pointer check being optimized away.
> The commit message claims that keeping the NULL pointer check in
> "makes it harder to abuse" the broken code.
> 
> I don't see how that's the case:  If dev is NULL, the NULL pointer
> dereference at the function's top causes termination of the task
> in kernel/exit.c:do_exit().  So the NULL pointer check is never
> reached by the task.  If on the other hand dev is non-NULL,
> the task isn't terminated but then the NULL pointer check is
> unnecessary as well.
> 
> So the point of the commit remains elusive to me.  I could submit
> an RFC patch which drops -fno-delete-null-pointer-checks and see
> if any security folks cry foul.  Thoughts?

I wonder if modern compilers can't simply warn about this particular
case. Not to mention our static checkers..


Dan, do you think the concern from the above-quoted commit is still
valid? Is this something that smatch flags these days? We're apparently
paying a real performance price in networking for tying compiler's hands
with -fno-delete-null-pointer-checks
