Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A5844F115
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 04:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbhKMDqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 22:46:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235645AbhKMDqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 22:46:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F4C860F14;
        Sat, 13 Nov 2021 03:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636774987;
        bh=nXHbc968YifWE8fXr2jDpqgB5F2ixW3MpA1fE8gsZ7U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iImbqWSdhzAU4vwoOR/hiz7P8/zXCz9bGz1ueJ3BTNxDwSEVPrILCtl31hIBMrHV1
         v9W6CmNfCYlMuVUQhYGZz72CWhujzECtLUSWR0BJEm8Y8vtUOsT03Z2X1lELXZgDXL
         5hEu7pRXtrlR63iC375IAgJjyGlpOMaZwfredJSjsWxmBs4TO7xhLMZL8hBPj8mnYt
         iYODeNgDjOp9GTUBvEzWd9yxUh5bgAzIG1J2+lFcXp8TicKCceq0EKk/xK1439BeFF
         XvkMsHouncyYW/xipAlP0vcrRrMlvmqAGC9WYMoka+FFH0LEaNlGBLBgTjn80jpxmt
         PYa3Y+WNGVa7w==
Date:   Fri, 12 Nov 2021 19:43:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arjun Roy <arjunroy@google.com>
Cc:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, soheil@google.com
Subject: Re: [net v2] tcp: Fix uninitialized access in skb frags array for
 Rx 0cp.
Message-ID: <20211112194306.70195848@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOFY-A0zLEQ_cbVFS_Rd16EiOP7R-gEkHTsZ6gNEmUCbeLK1OQ@mail.gmail.com>
References: <20211111235215.2605384-1-arjunroy.kdev@gmail.com>
        <CAOFY-A0zLEQ_cbVFS_Rd16EiOP7R-gEkHTsZ6gNEmUCbeLK1OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 18:32:23 -0800 Arjun Roy wrote:
> On Thu, Nov 11, 2021 at 3:52 PM Arjun Roy <arjunroy.kdev@gmail.com> wrote:
> >
> > From: Arjun Roy <arjunroy@google.com>
> >
> > TCP Receive zerocopy iterates through the SKB queue via
> > tcp_recv_skb(), acquiring a pointer to an SKB and an offset within
> > that SKB to read from. From there, it iterates the SKB frags array to
> > determine which offset to start remapping pages from.
> >
> > However, this is built on the assumption that the offset read so far
> > within the SKB is smaller than the SKB length. If this assumption is
> > violated, we can attempt to read an invalid frags array element, which
> > would cause a fault.
> >
> > tcp_recv_skb() can cause such an SKB to be returned when the TCP FIN
> > flag is set. Therefore, we must guard against this occurrence inside
> > skb_advance_frag().
> >
> > One way that we can reproduce this error follows:
> > 1) In a receiver program, call getsockopt(TCP_ZEROCOPY_RECEIVE) with:
> > char some_array[32 * 1024];
> > struct tcp_zerocopy_receive zc = {
> >   .copybuf_address  = (__u64) &some_array[0],
> >   .copybuf_len = 32 * 1024,
> > };
> >
> > 2) In a sender program, after a TCP handshake, send the following
> > sequence of packets:
> >   i) Seq = [X, X+4000]
> >   ii) Seq = [X+4000, X+5000]
> >   iii) Seq = [X+4000, X+5000], Flags = FIN | URG, urgptr=1000
> >
> > (This can happen without URG, if we have a signal pending, but URG is
> > a convenient way to reproduce the behaviour).
> >
> > In this case, the following event sequence will occur on the receiver:
> >
> > tcp_zerocopy_receive():  
> > -> receive_fallback_to_copy() // copybuf_len >= inq
> > -> tcp_recvmsg_locked() // reads 5000 bytes, then breaks due to URG
> > -> tcp_recv_skb() // yields skb with skb->len == offset
> > -> tcp_zerocopy_set_hint_for_skb()
> > -> skb_advance_to_frag() // will returns a frags ptr. >= nr_frags
> > -> find_next_mappable_frag() // will dereference this bad frags ptr.  
> >
> > With this patch, skb_advance_to_frag() will no longer return an
> > invalid frags pointer, and will return NULL instead, fixing the issue.
> >
> > Signed-off-by: Arjun Roy <arjunroy@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")
> >
> > ---
> >  net/ipv4/tcp.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> > index bc7f419184aa..ef896847f190 100644
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@ -1741,6 +1741,9 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
> >  {
> >         skb_frag_t *frag;
> >
> > +       if (unlikely(offset_skb >= skb->len))
> > +               return NULL;
> > +
> >         offset_skb -= skb_headlen(skb);
> >         if ((int)offset_skb < 0 || skb_has_frag_list(skb))
> >                 return NULL;
> > --
> > 2.34.0.rc1.387.gb447b232ab-goog
> >  
> 
> Interestingly, netdevbpf list claims a netdev/build_32bit failure here:
> https://patchwork.kernel.org/project/netdevbpf/patch/20211111235215.2605384-1-arjunroy.kdev@gmail.com/
> 
> But the v1 patch seemed to be fine (that one had a wrong "Fixes" tag,
> it's the only thing that changed in v2). Also, "make ARCH=i386" is
> working fine for me, and the significant amount of error output
> (https://patchwork.hopto.org/static/nipa/578999/12615889/build_32bit/)
> does not actually have any errors inside net/ipv4/tcp.c . I assume,
> then, this must be a tooling false positive, and I do not have to send
> a v3 (which would have no changes)?

Yes, see:

https://lore.kernel.org/all/20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
