Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD42F2E013C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 20:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgLUTux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 14:50:53 -0500
Received: from smtp6.emailarray.com ([65.39.216.46]:34879 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUTux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 14:50:53 -0500
Received: (qmail 57725 invoked by uid 89); 21 Dec 2020 19:50:11 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 21 Dec 2020 19:50:11 -0000
Date:   Mon, 21 Dec 2020 11:50:09 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH 0/9 v1 RFC] Generic zcopy_* functions
Message-ID: <20201221195009.kmo32xt4wyz2atkg@bsd-mbp>
References: <20201218201633.2735367-1-jonathan.lemon@gmail.com>
 <CA+FuTSeM0pqj=LywVUUpNyekRDmpES1y8ksSi5PJ==rw2-=cug@mail.gmail.com>
 <20201218211648.rh5ktnkm333sw4hf@bsd-mbp.dhcp.thefacebook.com>
 <CA+FuTSfcxCncqzUsQh22A5Kdha_+wXmE=tqPk4SiJ3+CEui_Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSfcxCncqzUsQh22A5Kdha_+wXmE=tqPk4SiJ3+CEui_Vw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 19, 2020 at 02:00:55PM -0500, Willem de Bruijn wrote:
> On Fri, Dec 18, 2020 at 4:27 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Fri, Dec 18, 2020 at 03:49:44PM -0500, Willem de Bruijn wrote:
> > > On Fri, Dec 18, 2020 at 3:23 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > > >
> > > > From: Jonathan Lemon <bsd@fb.com>
> > > >
> > > > This is set of cleanup patches for zerocopy which are intended
> > > > to allow a introduction of a different zerocopy implementation.
> > >
> > > Can you describe in more detail what exactly is lacking in the current
> > > zerocopy interface for this this different implementation? Or point to
> > > a github tree with the feature patches attached, perhaps.
> >
> > I'll get the zctap features up into a github tree.
> >
> > Essentially, I need different behavior from ubuf_info:
> >   - no refcounts on RX packets (static ubuf)
> 
> That is already the case for vhost and tpacket zerocopy use cases.
> 
> >   - access to the skb on RX skb free (for page handling)
> 
> To refers only to patch 9, moving the callback earlier in
> skb_release_data, right?

Yes.


> >   - no page pinning on TX/tx completion
> 
> That is not part of the skb zerocopy infrastructure?

That's specific to msg_zerocopy.  zctap uses the same network stack
paths, but pins the pages during setup, not during each each system call.


> >   - marking the skb data as inaccessible so skb_condense()
> >     and skb_zeroocopy_clone() leave it alone.
> 
> Yep. Skipping content access on the Rx path will be interesting. I
> wonder if that should be a separate opaque skb feature, independent
> from whether the data is owned by userspace, peripheral memory, the
> page cache or anything else.

Would that be indicated by a bit on the skb (like pfmemalloc), or 
a bit in the skb_shared structure, as I'm leaning towards doing here?


> > > I think it's good to split into multiple smaller patchsets, starting
> > > with core stack support. But find it hard to understand which of these
> > > changes are truly needed to support a new use case.
> >
> > Agree - kind of hard to see why this is done without a use case.
> > These patches are purely restructuring, and don't introduce any
> > new features.
> >
> >
> > > If anything, eating up the last 8 bits in skb_shared_info should be last resort.
> >
> > I would like to add 2 more bits in the future, which is why I
> > moved them.  Is there a compelling reason to leave the bits alone?
> 
> Opportunity cost.
> 
> We cannot grow skb_shared_info due to colocation with MTU sized linear
> skbuff's in half a page.
> 
> It took me quite some effort to free up a few bytes in commit
> 4d276eb6a478 ("net: remove deprecated syststamp timestamp").
> 
> If we are very frugal, we could shadow some bits to have different
> meaning in different paths. SKBTX_IN_PROGRESS is transmit only, I
> think. But otherwise we'll have to just dedicate the byte to more
> flags. Yours are likely not to be the last anyway.

The zerocopy/enable flags could be encoded in one of the lower 3 bits
in the destructor_arg, (similar to nouarg) but that seems messy.
-- 
Jonathan
