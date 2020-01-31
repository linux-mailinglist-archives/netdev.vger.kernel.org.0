Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6725814F53F
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 00:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgAaXhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 18:37:03 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:53028 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgAaXhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 18:37:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ixfqN-0006Qg-2J; Sat, 01 Feb 2020 00:36:59 +0100
Date:   Sat, 1 Feb 2020 00:36:59 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
Message-ID: <20200131233659.GM795@breakpoint.cc>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-4-xiyou.wangcong@gmail.com>
 <20200131220807.GJ795@breakpoint.cc>
 <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Jan 31, 2020 at 2:08 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > The user-specified hashtable size is unbound, this could
> > > easily lead to an OOM or a hung task as we hold the global
> > > mutex while allocating and initializing the new hashtable.
> > >
> > > The max value is derived from the max value when chosen by
> > > the kernel.
> > >
> > > Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
> > > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> > > Cc: Florian Westphal <fw@strlen.de>
> > > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > > ---
> > >  net/netfilter/xt_hashlimit.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> > > index 57a2639bcc22..6327134c5886 100644
> > > --- a/net/netfilter/xt_hashlimit.c
> > > +++ b/net/netfilter/xt_hashlimit.c
> > > @@ -272,6 +272,8 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
> > >  }
> > >  static void htable_gc(struct work_struct *work);
> > >
> > > +#define HASHLIMIT_MAX_SIZE 8192
> > > +
> > >  static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
> > >                        const char *name, u_int8_t family,
> > >                        struct xt_hashlimit_htable **out_hinfo,
> > > @@ -290,7 +292,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
> > >               size = (nr_pages << PAGE_SHIFT) / 16384 /
> > >                      sizeof(struct hlist_head);
> > >               if (nr_pages > 1024 * 1024 * 1024 / PAGE_SIZE)
> > > -                     size = 8192;
> > > +                     size = HASHLIMIT_MAX_SIZE;
> > >               if (size < 16)
> > >                       size = 16;
> > >       }
> > > @@ -848,6 +850,8 @@ static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
> > >
> > >       if (cfg->gc_interval == 0 || cfg->expire == 0)
> > >               return -EINVAL;
> > > +     if (cfg->size > HASHLIMIT_MAX_SIZE)
> > > +             return -ENOMEM;
> >
> > Hmm, won't that break restore of rulesets that have something like
> >
> > --hashlimit-size 10000?
> >
> > AFAIU this limits the module to vmalloc requests of only 64kbyte.
> > I'm not opposed to a limit (or a cap), but 64k seems a bit low to me.
> 
> 8192 is from the current code which handles kernel-chosen size
> (that is cfg->size==0), I personally have no idea what the max
> should be. :)

Me neither :-/

> Please suggest a number.

O would propose a max alloc size (hard limit) of ~8 MByte of vmalloc
space, or maybe 16 at most.

1048576 max upperlimit -> ~8mbyte vmalloc request -> allows to store
up to 2**23 entries.

In order to prevent breaking userspace, perhaps make it so that the
kernel caps cfg.max at twice that value?  Would allow storing up to
16777216 addresses with an average chain depth of 16 (which is quite
large).  We could increase the max limit in case someone presents a use
case.

What do you think?
