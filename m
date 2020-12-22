Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDB52E0DFB
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 18:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgLVRsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 12:48:55 -0500
Received: from smtp5.emailarray.com ([65.39.216.39]:27227 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727815AbgLVRsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 12:48:55 -0500
Received: (qmail 59467 invoked by uid 89); 22 Dec 2020 17:48:13 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 22 Dec 2020 17:48:13 -0000
Date:   Tue, 22 Dec 2020 09:48:11 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 04/12 v2 RFC] skbuff: Push status and refcounts into
 sock_zerocopy_callback
Message-ID: <20201222174811.2mts4ojml6yafeou@bsd-mbp.dhcp.thefacebook.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-5-jonathan.lemon@gmail.com>
 <CAF=yD-K7bWE-U-O2J2Bwwi3E0NrX+horDARRgmBUU8Pqh6pH3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-K7bWE-U-O2J2Bwwi3E0NrX+horDARRgmBUU8Pqh6pH3Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 09:43:39AM -0500, Willem de Bruijn wrote:
> On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > Before this change, the caller of sock_zerocopy_callback would
> > need to save the zerocopy status, decrement and check the refcount,
> > and then call the callback function - the callback was only invoked
> > when the refcount reached zero.
> >
> > Now, the caller just passes the status into the callback function,
> > which saves the status and handles its own refcounts.
> >
> > This makes the behavior of the sock_zerocopy_callback identical
> > to the tpacket and vhost callbacks.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >  include/linux/skbuff.h |  3 ---
> >  net/core/skbuff.c      | 14 +++++++++++---
> >  2 files changed, 11 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index fb6dd6af0f82..c9d7de9d624d 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -1482,9 +1482,6 @@ static inline void skb_zcopy_clear(struct sk_buff *skb, bool zerocopy)
> >         if (uarg) {
> >                 if (skb_zcopy_is_nouarg(skb)) {
> >                         /* no notification callback */
> > -               } else if (uarg->callback == sock_zerocopy_callback) {
> > -                       uarg->zerocopy = uarg->zerocopy && zerocopy;
> > -                       sock_zerocopy_put(uarg);
> >                 } else {
> >                         uarg->callback(uarg, zerocopy);
> >                 }
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index ea32b3414ad6..73699dbdc4a1 100644
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
> > @@ -1241,11 +1241,19 @@ void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> >         consume_skb(skb);
> >         sock_put(sk);
> >  }
> > +
> > +void sock_zerocopy_callback(struct ubuf_info *uarg, bool success)
> > +{
> > +       uarg->zerocopy = uarg->zerocopy & success;
> > +
> > +       if (refcount_dec_and_test(&uarg->refcnt))
> > +               __sock_zerocopy_callback(uarg);
> > +}
> >  EXPORT_SYMBOL_GPL(sock_zerocopy_callback);
> 
> I still think this helper is unnecessary. Just return immediately in
> existing sock_zerocopy_callback if refcount is not zero.

I think the helper makes the logic clearer, and prevents misuse of
the success variable in the main function (use of last value vs the
latched value).  If you really feel that strongly about it, I'll 
fold it into one function.


> >  void sock_zerocopy_put(struct ubuf_info *uarg)
> >  {
> > -       if (uarg && refcount_dec_and_test(&uarg->refcnt))
> > +       if (uarg)
> >                 uarg->callback(uarg, uarg->zerocopy);
> >  }
> >  EXPORT_SYMBOL_GPL(sock_zerocopy_put);
> 
> This does increase the number of indirect function calls. Which are
> not cheap post spectre.
> 
> In the common case for msg_zerocopy we only have two clones, one sent
> out and one on the retransmit queue. So I guess the cost will be
> acceptable.

Yes, this was the source of my original comment about this being 
a slight pessimization - moving the refcount into the function.

I briefly considered adding a flag like 'use_refcnt', so the logic
becomes:

    if (uarg && (!uarg->use_refcnt || refcount_dec_and_test(&uarg->refcnt)))

But thought this might be too much micro-optimization.  But if 
the call overhead is significant, I can put this back in.
-- 
Jonathan
