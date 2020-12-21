Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDDA2E00DA
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgLUTTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:19:22 -0500
Received: from smtp1.emailarray.com ([65.39.216.14]:14363 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgLUTTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:19:22 -0500
Received: (qmail 71921 invoked by uid 89); 21 Dec 2020 19:18:37 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 21 Dec 2020 19:18:37 -0000
Date:   Mon, 21 Dec 2020 11:18:35 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 3/9 v1 RFC] skbuff: replace sock_zerocopy_put() with
 skb_zcopy_put()
Message-ID: <20201221191835.ic3aln6ib5hbftlk@bsd-mbp>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <20201218201633.2735367-4-jonathan.lemon@gmail.com>
 <CA+FuTSeaero7hwvDR=1M6z3SZgf_bm+KjQWVzqeS_a42hQ-91Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeaero7hwvDR=1M6z3SZgf_bm+KjQWVzqeS_a42hQ-91Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 19, 2020 at 01:46:13PM -0500, Willem de Bruijn wrote:
> On Fri, Dec 18, 2020 at 3:20 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > In preparation for further work, the zcopy* routines will
> > become basic building blocks, while the zerocopy* ones will
> > be specific for the existing zerocopy implementation.
> 
> Plural. There already are multiple disjoint zerocopy implementations:
> msg_zerocopy, tpacket and vhost_net.

Yes - I'm having to take all of those into account when adding
zctap as well.


> Which API is each intended to use? After this patch
> tcp_sendmsg_locked() calls both skb_zcopy_put and
> sock_zerocopy_put_abort, so I don't think that that is simplifying the
> situation.

I'm trying to make the skb_zcopy_ routines the top level API, and 
the sock_zerocopy_ routines specific to msg_zerocopy().  Patch 6 adds
the skb_zcopy_put_abort() function, which unfortunately still uses
the uarg->callback for switching.


> This is tricky code. Perhaps best to change only what is needed
> instead of targeting a larger cleanup. It's hard to reason that this
> patch is safe in all three existing cases, for instance.

Exactly.  I'm trying to simplify things here so it's easier to reason
through all the cases.


> > All uargs should have a callback function, (unless nouarg
> > is set), so push all special case logic handling down into
> > the callbacks.  This slightly pessimizes the refcounted cases,
> 
> What does this mean?

The current zerocopy_put() code does:
  1) if uarg, dec refcount, if refcount == 0:
     if callback, run callback, else consume skb.

This is called from the main TCP/UDP send path.  These would be called
for the zctap case as well, so it should be made generic - not specific
to the current zerocopy implementation.  The patch changes this into:

  1) if uarg, run callback.

Then, the msg_zerocopy code does:

  1) save state,
  2) dec refcount, run rest of callback on 0.

Which is the same as before.  The !uarg case is never handled here.
The zctap cases switch to their own callbacks.


The current zerocopy clear code does:
  1) if no_uarg, skip 
  2) if msg_zerocopy, save state, dec refcount, run callback when 0.
  3) otherwise just run callback.
  4) clear flags

I would like to remove the msg_zerocopy specific logic from the function,
so this becomes:

  1) if uarg, run callback.
  2) clear flags



> > but makes the skb_zcopy_*() routines clearer.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >  include/linux/skbuff.h | 19 +++++++++----------
> >  net/core/skbuff.c      | 21 +++++++++------------
> >  net/ipv4/tcp.c         |  2 +-
> >  3 files changed, 19 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index fb6dd6af0f82..df98d61e8c51 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -499,7 +499,6 @@ static inline void sock_zerocopy_get(struct ubuf_info *uarg)
> >         refcount_inc(&uarg->refcnt);
> >  }
> >
> > -void sock_zerocopy_put(struct ubuf_info *uarg);
> >  void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
> 
> The rename of sock_zerocopy_put without rename of
> sock_zerocopy_put_abort makes the API less consistent, I believe. See
> how the calls are close together in tcp_sendmsg_locked.

See patch 6.


> >  void sock_zerocopy_callback(struct ubuf_info *uarg, bool success);
> > @@ -1474,20 +1473,20 @@ static inline void *skb_zcopy_get_nouarg(struct sk_buff *skb)
> >         return (void *)((uintptr_t) skb_shinfo(skb)->destructor_arg & ~0x1UL);
> >  }
> >
> > +static inline void skb_zcopy_put(struct ubuf_info *uarg)
> > +{
> > +       if (uarg)
> > +               uarg->callback(uarg, true);
> > +}
> > +
> 
> Can we just use skb_zcopy_clear?

skb_zcopy_clear also clears the flags, so no.

 
> >  /* Release a reference on a zerocopy structure */
> > -static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
> > +static inline void skb_zcopy_clear(struct sk_buff *skb, bool succsss)
> 
> succsss -> success. More importantly, why change the argument name?

It is already named inconsistently:
   struct ubuf_info {
        void (*callback)(struct ubuf_info *, bool zerocopy_success);

   void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
   static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)

I picked one and made them the same.




> 
> >  {
> >         struct ubuf_info *uarg = skb_zcopy(skb);
> >
> >         if (uarg) {
> > -               if (skb_zcopy_is_nouarg(skb)) {
> > -                       /* no notification callback */
> > -               } else if (uarg->callback == sock_zerocopy_callback) {
> > -                       uarg->zerocopy = uarg->zerocopy && zerocopy;
> > -                       sock_zerocopy_put(uarg);
> > -               } else {
> > -                       uarg->callback(uarg, zerocopy);
> > -               }
> > +               if (!skb_zcopy_is_nouarg(skb))
> > +                       uarg->callback(uarg, succsss);
> >
> >                 skb_shinfo(skb)->zc_flags &= ~SKBZC_FRAGMENTS;
> >         }
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 327ee8938f78..984760dd670b 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -1194,7 +1194,7 @@ static bool skb_zerocopy_notify_extend(struct sk_buff *skb, u32 lo, u16 len)
> >         return true;
> >  }
> >
> > -void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > +static void __sock_zerocopy_callback(struct ubuf_info *uarg)
> >  {
> >         struct sk_buff *tail, *skb = skb_from_uarg(uarg);
> >         struct sock_exterr_skb *serr;
> > @@ -1222,7 +1222,7 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> >         serr->ee.ee_origin = SO_EE_ORIGIN_ZEROCOPY;
> >         serr->ee.ee_data = hi;
> >         serr->ee.ee_info = lo;
> > -       if (!success)
> > +       if (!uarg->zerocopy)
> >                 serr->ee.ee_code |= SO_EE_CODE_ZEROCOPY_COPIED;
> >
> >         q = &sk->sk_error_queue;
> > @@ -1241,18 +1241,15 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> >         consume_skb(skb);
> >         sock_put(sk);
> >  }
> > -EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
> >
> > -void sock_zerocopy_put(struct ubuf_info *uarg)
> > +void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> >  {
> > -       if (uarg && refcount_dec_and_test(&uarg->refcnt)) {
> > -               if (uarg->callback)
> > -                       uarg->callback(uarg, uarg->zerocopy);
> > -               else
> > -                       consume_skb(skb_from_uarg(uarg));
> 
> I suppose this can be removed after commit 0a4a060bb204 ("sock: fix
> zerocopy_success regression with msg_zerocopy"). Cleaning that up
> would better be a separate patch that explains why the removal is
> safe.

I'll split the patches out.


> It's also fine to bundle with moving refcount_dec_and_test into
> sock_zerocopy_callback, which indeed follows from it.
> 
> > -       }
> > +       uarg->zerocopy = uarg->zerocopy & success;
> > +
> > +       if (refcount_dec_and_test(&uarg->refcnt))
> > +               __sock_zerocopy_callback(uarg);
> 
> This can be wrapped in existing sock_zerocopy_callback. No need for a
> __sock_zerocopy_callback.

The compiler will inline the helper anyway, since it's a single
callsite.


> 
> If you do want a separate API for existing msg_zerocopy distinct from
> existing skb_zcopy, then maybe rename the functions only used by
> msg_zerocopy to have prefix msg_zerocopy_ instead of sock_zerocopy_

That's a good suggestion, thanks!

 
> >  }
> > -EXPORT_SYMBOL_GPL(sock_zerocopy_put);
> > +EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
> >
> >  void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
> >  {
> > @@ -1263,7 +1260,7 @@ void sock_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref)
> >                 uarg->len--;
> >
> >                 if (have_uref)
> > -                       sock_zerocopy_put(uarg);
> > +                       skb_zcopy_put(uarg);
> >         }
> >  }
> >  EXPORT_SYMBOL_GPL(sock_zerocopy_put_abort);
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index fea9bae370e4..5c38080df13f 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1429,7 +1429,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
> >                 tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
> >         }
> >  out_nopush:
> > -       sock_zerocopy_put(uarg);
> > +       skb_zcopy_put(uarg);
> >         return copied + copied_syn;
> >
> >  do_error:
> > --
> > 2.24.1
> >
