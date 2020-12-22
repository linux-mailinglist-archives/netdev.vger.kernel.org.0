Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703432E0E2B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 19:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgLVSRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 13:17:48 -0500
Received: from smtp4.emailarray.com ([65.39.216.22]:47696 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgLVSRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 13:17:48 -0500
Received: (qmail 33404 invoked by uid 89); 22 Dec 2020 18:17:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 22 Dec 2020 18:17:06 -0000
Date:   Tue, 22 Dec 2020 10:17:04 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 09/12 v2 RFC] skbuff: add zc_flags to ubuf_info for ubuf
 setup
Message-ID: <20201222181704.cnpphtbrf7372szo@bsd-mbp.dhcp.thefacebook.com>
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com>
 <20201222000926.1054993-10-jonathan.lemon@gmail.com>
 <CAF=yD-+W93Gz4QygA=J0zME=sxVwzkKw3Q9BviwzNwkjziXPmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+W93Gz4QygA=J0zME=sxVwzkKw3Q9BviwzNwkjziXPmg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 10:00:37AM -0500, Willem de Bruijn wrote:
> On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > From: Jonathan Lemon <bsd@fb.com>
> >
> > Currently, an ubuf is attached to a new skb, the skb zc_flags
> > is initialized to a fixed value.  Instead of doing this, set
> > the default zc_flags in the ubuf, and have new skb's inherit
> > from this default.
> >
> > This is needed when setting up different zerocopy types.
> >
> > Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> > ---
> >  include/linux/skbuff.h | 3 ++-
> >  net/core/skbuff.c      | 1 +
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index da0c1dddd0da..b90be4b0b2de 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -478,6 +478,7 @@ struct ubuf_info {
> >                 };
> >         };
> >         refcount_t refcnt;
> > +       u8 zc_flags;
> >
> >         struct mmpin {
> >                 struct user_struct *user;
> 
> When allocating ubuf_info for msg_zerocopy, we actually allocate the
> notification skb, to be sure that notifications won't be dropped due
> to memory pressure at notification time. We actually allocate the skb
> and place ubuf_info in skb->cb[].
> 
> The struct is exactly 48 bytes on 64-bit platforms, filling all of cb.
> This new field fills a 4B hole, so it should still be fine.

Yes, I was careful not to increase the size.  I have future changes
for this structure, moving 'struct mmpin' into a union.   Making the
flags 16 bits shouldn't be a problem either.


> Just being very explicit, as this is a fragile bit of code. Come to
> think of it, this probably deserves a BUILD_BUG_ON.

You mean like the one which exists in sock_zerocopy_alloc()?

        BUILD_BUG_ON(sizeof(*uarg) > sizeof(skb->cb));

-- 
Jonathan
