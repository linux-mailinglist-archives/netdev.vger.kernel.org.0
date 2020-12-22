Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9C22E0329
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 01:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgLVAIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 19:08:22 -0500
Received: from smtp4.emailarray.com ([65.39.216.22]:37535 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVAIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 19:08:22 -0500
Received: (qmail 91121 invoked by uid 89); 22 Dec 2020 00:07:40 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 22 Dec 2020 00:07:40 -0000
Date:   Mon, 21 Dec 2020 16:07:38 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 0/9 v1 RFC] Generic zcopy_* functions
Message-ID: <20201222000738.taiw4jq6kmyuwt65@bsd-mbp.dhcp.thefacebook.com>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
 <20201218211648.rh5ktnkm333sw4hf@bsd-mbp.dhcp.thefacebook.com>
 <CA+FuTSfcxCncqzUsQh22A5Kdha_+wXmE=tqPk4SiJ3+CEui_Vw@mail.gmail.com>
 <20201221195009.kmo32xt4wyz2atkg@bsd-mbp>
 <CAF=yD-+bVFBHPfFB+E1s4Qae5PZGQJaiarAN9hwpP2aTs1f_jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+bVFBHPfFB+E1s4Qae5PZGQJaiarAN9hwpP2aTs1f_jg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 05:52:08PM -0500, Willem de Bruijn wrote:
> > > >   - marking the skb data as inaccessible so skb_condense()
> > > >     and skb_zeroocopy_clone() leave it alone.
> > >
> > > Yep. Skipping content access on the Rx path will be interesting. I
> > > wonder if that should be a separate opaque skb feature, independent
> > > from whether the data is owned by userspace, peripheral memory, the
> > > page cache or anything else.
> >
> > Would that be indicated by a bit on the skb (like pfmemalloc), or
> > a bit in the skb_shared structure, as I'm leaning towards doing here?
> 
> I would guide it in part by avoiding cold cacheline accesses. That
> might be hard if using skb_shinfo. OTOH, you don't have to worry about
> copying the bit during clone operations.
> 
> > > > > If anything, eating up the last 8 bits in skb_shared_info should be last resort.
> > > >
> > > > I would like to add 2 more bits in the future, which is why I
> > > > moved them.  Is there a compelling reason to leave the bits alone?
> > >
> > > Opportunity cost.
> > >
> > > We cannot grow skb_shared_info due to colocation with MTU sized linear
> > > skbuff's in half a page.
> > >
> > > It took me quite some effort to free up a few bytes in commit
> > > 4d276eb6a478 ("net: remove deprecated syststamp timestamp").
> > >
> > > If we are very frugal, we could shadow some bits to have different
> > > meaning in different paths. SKBTX_IN_PROGRESS is transmit only, I
> > > think. But otherwise we'll have to just dedicate the byte to more
> > > flags. Yours are likely not to be the last anyway.
> >
> > The zerocopy/enable flags could be encoded in one of the lower 3 bits
> > in the destructor_arg, (similar to nouarg) but that seems messy.
> 
> Agreed :)
> 
> Let's just expand the flags for now. It may be better to have one
> general purpose 16 bit flags bitmap, rather than reserving 8 bits
> specifically to zerocopy features.

I was considering doing that also, but that would need to rearrange
the flags in skb_shared_info.  Then I realized that there are currently
only TX flags and ZC flags, so went with that.  I have no objections
to doing it either way.

My motivation here is when MSG_ZCTAP is added to tcp_sendmsg_locked(),
it the returned uarg is self-contained for the rest of the function.
-- 
Jonathan
