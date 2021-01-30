Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17F3030967C
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhA3QDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:03:55 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:50095 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbhA3QCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 11:02:54 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id C6510300371FF;
        Sat, 30 Jan 2021 17:00:51 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id BAAB25BF3; Sat, 30 Jan 2021 17:00:51 +0100 (CET)
Date:   Sat, 30 Jan 2021 17:00:51 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress handling
Message-ID: <20210130160051.GA1959@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
 <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
 <CANn89iK3CC3fapmQpwwbVkGs4-+fmJF+nj0pmBHJ9fy6poWseg@mail.gmail.com>
 <20210124103301.GA1056@wunner.de>
 <20210125113908.6951b6f8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210126085817.GO20820@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126085817.GO20820@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:58:17AM +0300, Dan Carpenter wrote:
> On Mon, Jan 25, 2021 at 11:39:08AM -0800, Jakub Kicinski wrote:
> > On Sun, 24 Jan 2021 11:33:01 +0100 Lukas Wunner wrote:
> > > On Fri, Jan 22, 2021 at 10:40:05AM +0100, Eric Dumazet wrote:
> > > > On Fri, Jan 22, 2021 at 9:55 AM Lukas Wunner <lukas@wunner.de> wrote:  
> > > > > sch_handle_egress() returns either the skb or NULL to signal to its
> > > > > caller __dev_queue_xmit() whether a packet should continue to be
> > > > > processed.
> > > > >
> > > > > The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
> > > > > NULL pointer deref right at its top.
> > > > >
> > > > > But the compiler doesn't know that.  So if sch_handle_egress() signals
> > > > > success by returning the skb, the "if (!skb) goto out;" statement
> > > > > results in a gratuitous NULL pointer check in the Assembler output.
> > > > >
> > > > > Avoid by telling the compiler that __dev_queue_xmit() is never passed a
> > > > > NULL skb.  
> > > [...]
> > > > > we're about to add a netfilter egress hook to __dev_queue_xmit()
> > > > > and without the micro-optimization, it will result in a performance
> > > > > degradation which is indeed measurable:  
> > > [...]
> > > > > --- a/net/core/dev.c
> > > > > +++ b/net/core/dev.c
> > > > > +__attribute__((nonnull(1)))
> > > > >  static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> > > > >  {
> > > > >         struct net_device *dev = skb->dev;  
> > > > 
> > > > It is a bit sad the compilers do not automatically get this knowledge
> > > > from the very first instruction :
> > > > 
> > > >  struct net_device *dev = skb->dev;  
> > > 
> > > The compiler (gcc) is capable of doing that, but the feature was disabled by:
> > > 
> > >     commit a3ca86aea507904148870946d599e07a340b39bf
> > >     Author: Eugene Teo <eteo@redhat.com>
> > >     Date:   Wed Jul 15 14:59:10 2009 +0800
> > >     
> > >     Add '-fno-delete-null-pointer-checks' to gcc CFLAGS
> > > 
> > > If -fno-delete-null-pointer-checks is dropped from the top-level Makefile
> > > then the gratuitous NULL pointer checks disappear from the Assembler output,
> > > obviating the need to litter hot paths with __attribute__((nonnull(1)))
> > > annotations.
> > > 
> > > Taking a closer look at that commit, its rationale appears questionable:
> > > It says that broken code such as ...
> > > 
> > > 	struct agnx_priv *priv = dev->priv;
> > > 
> > > 	if (!dev)
> > > 		return;
> > > 
> > > ... would result in the NULL pointer check being optimized away.
> > > The commit message claims that keeping the NULL pointer check in
> > > "makes it harder to abuse" the broken code.
> > > 
> > > I don't see how that's the case:  If dev is NULL, the NULL pointer
> > > dereference at the function's top causes termination of the task
> > > in kernel/exit.c:do_exit().  So the NULL pointer check is never
> > > reached by the task.  If on the other hand dev is non-NULL,
> > > the task isn't terminated but then the NULL pointer check is
> > > unnecessary as well.
> > > 
> > > So the point of the commit remains elusive to me.  I could submit
> > > an RFC patch which drops -fno-delete-null-pointer-checks and see
> > > if any security folks cry foul.  Thoughts?
> 
> This was a famous tun.c bug back in the day.  In those days we weren't
> careful to disallow remapping NULL to a different pointer.  See
> /proc/sys/vm/mmap_min_addr.  The exploit was to remap NULL to be a valid
> user controlled pointer.  It should have been impossible to exploit
> because the code had a check for NULL, but the compiler optimized it
> away.
> 
> https://lwn.net/Articles/342330/

Thanks Dan, that's valuable information.  I'll add it to the commit message
when respinning the series.

So to summarize, keeping seemingly useless NULL pointer checks in
is a mitigation in case accesses to the zero page don't result in
an exception because an attacker managed to map something to that
page.

I'm assuming for now that selectively dropping those NULL pointer
checks from hotpaths is acceptable if otherwise a measurable
performance degradation occurs.

Maintainers please speak up if you disagree.

Thanks,

Lukas
