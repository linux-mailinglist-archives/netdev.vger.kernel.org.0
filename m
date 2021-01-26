Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16F7304440
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389444AbhAZHi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 02:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389330AbhAZHfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 02:35:54 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFF2C061352;
        Mon, 25 Jan 2021 23:34:35 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r38so5072642pgk.13;
        Mon, 25 Jan 2021 23:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K8K+DfoUZWImJdEP+cZPLuNCu4SiIDceVZmhx0OoC0Y=;
        b=hg9nO2K/i9r/UyEZvbNJE1BJCxxUppAd8KbfmapQdR0NkvXaiBUYunTbzrsAQuT3Gw
         zZbPNoxvn7Io05dnniYKAn5La7J+sFPbYRRIef547bQoO1zRs8UjfKDlRPuZCvMrTjvq
         9KCjtUJhPQfwfBmtLOjZVT9V+s0AIH/dOR5r2q2NfryVG1tOefkymQ5JFDnlRPUSj8q8
         Bq8W8z2/dCK4NvJOjKqLrZcZivbnZ2WVRqtbaXKOAtUNkkR/tmDf42tK6uA/AsC8lmdz
         bF6choTJqe/4Mm3mFiUjp9b/oQMSWhPsFeNaQYUQoiG6Y00jvtpEfYD+KEWpNwk2FH4P
         za7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K8K+DfoUZWImJdEP+cZPLuNCu4SiIDceVZmhx0OoC0Y=;
        b=PwX/ZA+EUpgPyeKjA95gauyf9r7s5talquWYgzLdytsYSOc1egwFHBN0rh4Rm2dUGr
         hzihw237rzC7pBoeTZXZd0cOv6wx8U2mb1Y23SiRyxVEOnBffnR0bUXrrcMIBMzM6Uvz
         Hp3FRWmKwiqLfL0Rlqjc47FuALfA6Jg+5pwBewqCZ2QyRyiuZTnHtYPGM4VgFMGL1k7t
         8qdLLPQjIt6hnoVKg5gAFm7zRvmjWC8BF0CC3yItqUdld6Q93V/6+mLuDaq6ngemH0TC
         x2OgcW6cTApZKLmK1BHWaLG8VsY1gufiOcD84EqOnIakMnXhJa9DeaP8HkKZkEl6pBpW
         i8Sw==
X-Gm-Message-State: AOAM530uTwBIxRXe7KMnB6tWVC/OQu8ztkL38+d0xt1fKmZuIKli0DNq
        n2eDFdoXSFMH7Sk2cMpPJuSo/3pAtdzEjoVo3GQ/s6++F1vREw==
X-Google-Smtp-Source: ABdhPJztkUrqzvfAA2lSYND1A/WLy8+ZgLHrZS3GBu49etta47Of3rVWljiyw+/QuMiRLmqXpy1cSxSq/2Dhv+bAj34=
X-Received: by 2002:a63:d917:: with SMTP id r23mr4605204pgg.126.1611646474932;
 Mon, 25 Jan 2021 23:34:34 -0800 (PST)
MIME-Version: 1.0
References: <CAJ8uoz30r_-6CwZcte0R_9+6BVUFcvMEW4FG-tutBtJn2FD_bw@mail.gmail.com>
 <1611587242.9653594-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1611587242.9653594-2-xuanzhuo@linux.alibaba.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 26 Jan 2021 08:34:23 +0100
Message-ID: <CAJ8uoz3hoegNYwjaW9zzFJ7dQJRSFTG3b0e23KpF=6ym7DcmJw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 4:22 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Mon, 25 Jan 2021 14:16:16 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > On Mon, Jan 25, 2021 at 1:43 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Mon, 25 Jan 2021 08:44:38 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > On Mon, Jan 25, 2021 at 3:27 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > > > >
> > > > > On Fri, 22 Jan 2021 19:37:06 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > > > On Fri, Jan 22, 2021 at 6:26 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > > > >
> > > > > > > From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > Date: Fri, 22 Jan 2021 23:39:15 +0800
> > > > > > >
> > > > > > > > On Fri, 22 Jan 2021 13:55:14 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > > > > > > > On Fri, Jan 22, 2021 at 1:39 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > > > > > > >
> > > > > > > > > > From: Magnus Karlsson <magnus.karlsson@gmail.com>
> > > > > > > > > > Date: Fri, 22 Jan 2021 13:18:47 +0100
> > > > > > > > > >
> > > > > > > > > > > On Fri, Jan 22, 2021 at 12:57 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > From: Alexander Lobakin <alobakin@pm.me>
> > > > > > > > > > > > Date: Fri, 22 Jan 2021 11:47:45 +0000
> > > > > > > > > > > >
> > > > > > > > > > > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > > > > > > > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > > > > > > > > > > > >
> > > > > > > > > > > > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > > > > > > > > > > > This patch is used to construct skb based on page to save memory copy
> > > > > > > > > > > > > > > overhead.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > > > > > > > > > > > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > > > > > > > > > > > > > > directly construct skb. If this feature is not supported, it is still
> > > > > > > > > > > > > > > necessary to copy data to construct skb.
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > ---------------- Performance Testing ------------
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > The test environment is Aliyun ECS server.
> > > > > > > > > > > > > > > Test cmd:
> > > > > > > > > > > > > > > ```
> > > > > > > > > > > > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > > > > > > > > > > > ```
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Test result data:
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > size    64      512     1024    1500
> > > > > > > > > > > > > > > copy    1916747 1775988 1600203 1440054
> > > > > > > > > > > > > > > page    1974058 1953655 1945463 1904478
> > > > > > > > > > > > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > > > > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > > > > > > > > > > > ---
> > > > > > > > > > > > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> > > > > > > > > > > > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > > > > > > > > > > > index 4a83117..38af7f1 100644
> > > > > > > > > > > > > > > --- a/net/xdp/xsk.c
> > > > > > > > > > > > > > > +++ b/net/xdp/xsk.c
> > > > > > > > > > > > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> > > > > > > > > > > > > > >   sock_wfree(skb);
> > > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > > > > > > > > > > > > > > +                                       struct xdp_desc *desc)
> > > > > > > > > > > > > > > +{
> > > > > > > > > > > > > > > + u32 len, offset, copy, copied;
> > > > > > > > > > > > > > > + struct sk_buff *skb;
> > > > > > > > > > > > > > > + struct page *page;
> > > > > > > > > > > > > > > + void *buffer;
> > > > > > > > > > > > > > > + int err, i;
> > > > > > > > > > > > > > > + u64 addr;
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > > > > > > > > > > > > > + if (unlikely(!skb))
> > > > > > > > > > > > > > > +         return ERR_PTR(err);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + addr = desc->addr;
> > > > > > > > > > > > > > > + len = desc->len;
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > > > > > > > > > > > > > > + offset = offset_in_page(buffer);
> > > > > > > > > > > > > > > + addr = buffer - xs->pool->addrs;
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + for (copied = 0, i = 0; copied < len; i++) {
> > > > > > > > > > > > > > > +         page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > +         get_page(page);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > +         copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > +         skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > +         copied += copy;
> > > > > > > > > > > > > > > +         addr += copy;
> > > > > > > > > > > > > > > +         offset = 0;
> > > > > > > > > > > > > > > + }
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + skb->len += len;
> > > > > > > > > > > > > > > + skb->data_len += len;
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > > + skb->truesize += len;
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > This is not the truesize, unfortunately.
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > We need to account for the number of pages, not number of bytes.
> > > > > > > > > > > > >
> > > > > > > > > > > > > The easiest solution is:
> > > > > > > > > > > > >
> > > > > > > > > > > > >       skb->truesize += PAGE_SIZE * i;
> > > > > > > > > > > > >
> > > > > > > > > > > > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the loop.
> > > > > > > > > > > >
> > > > > > > > > > > > Oops, pls ignore this. I forgot that XSK buffers are not
> > > > > > > > > > > > "one per page".
> > > > > > > > > > > > We need to count the number of pages manually and then do
> > > > > > > > > > > >
> > > > > > > > > > > >         skb->truesize += PAGE_SIZE * npages;
> > > > > > > > > > > >
> > > > > > > > > > > > Right.
> > > > > > > > > > >
> > > > > > > > > > > There are two possible packet buffer (chunks) sizes in a umem, 2K and
> > > > > > > > > > > 4K on a system with a PAGE_SIZE of 4K. If I remember correctly, and
> > > > > > > > > > > please correct me if wrong, truesize is used for memory accounting.
> > > > > > > > > > > But in this code, no kernel memory has been allocated (apart from the
> > > > > > > > > > > skb). The page is just a part of the umem that has been already
> > > > > > > > > > > allocated beforehand and by user-space in this case. So what should
> > > > > > > > > > > truesize be in this case? Do we add 0, chunk_size * i, or the
> > > > > > > > > > > complicated case of counting exactly how many 4K pages that are used
> > > > > > > > > > > when the chunk_size is 2K, as two chunks could occupy the same page,
> > > > > > > > > > > or just the upper bound of PAGE_SIZE * i that is likely a good
> > > > > > > > > > > approximation in most cases? Just note that there might be other uses
> > > > > > > > > > > of truesize that I am unaware of that could impact this choice.
> > > > > > > > > >
> > > > > > > > > > Truesize is "what amount of memory does this skb occupy with all its
> > > > > > > > > > fragments, linear space and struct sk_buff itself". The closest it
> > > > > > > > > > will be to the actual value, the better.
> > > > > > > > > > In this case, I think adding of chunk_size * i would be enough.
> > > > > > > > >
> > > > > > > > > Sounds like a good approximation to me.
> > > > > > > > >
> > > > > > > > > > (PAGE_SIZE * i can be overwhelming when chunk_size is 2K, especially
> > > > > > > > > > for setups with PAGE_SIZE > SZ_4K)
> > > > > > > > >
> > > > > > > > > You are right. That would be quite horrible on a system with a page size of 64K.
> > > > > > > >
> > > > > > > > Thank you everyone, I learned it.
> > > > > > > >
> > > > > > > > I also think it is appropriate to add a chunk size here, and there is actually
> > > > > > > > only one chunk here, so it's very simple
> > > > > > > >
> > > > > > > >       skb->truesize += xs->pool->chunk_size;
> > > > > > >
> > > > > > > umem chunks can't cross page boundaries. So if you're sure that
> > > > > > > there could be only one chunk, you don't need the loop at all,
> > > > > > > if I'm not missing anything.
> > > > > >
> > > > > > In the default mode, this is true. But in the unaligned_chunk mode
> > > > > > that can be set on the umem, the chunk may cross one page boundary, so
> > > > > > we need the loop and the chunk_size * i in the assignment of truesize.
> > > > > > So "i" can be 1 or 2, but nothing else.
> > > > >
> > > > > According to my understanding, in the unaligned mode, a desc will also refer to
> > > > > a chunk, although the chunk here may occupy multiple pages. And here is just a
> > > > > desc constructed into a skb, skb takes the largest amount from umem is a
> > > > > chunk, so what is the situation of i = 2 here? Did I miss something?
> > > >
> > > > A desc refers to a single packet, not a single chunk. One packet can
> > > > occupy either one or two chunks in the unaligned mode and when this
> > > > happens to be two, these two chunks might be on different pages. In
> > > > this case, you will go through the loop twice and produce two
> > > > fragments.
> > > >
> > > > In the aligned mode, every packet starts at the beginning of each
> > > > chunk (if there is no headroom) and can only occupy a single chunk
> > > > since no packet can be larger than the chunk size. In the unaligned
> > > > mode, the packet can start anywhere within the chunk and might even
> > > > continue into the next chunk, but never more than that since the max
> > > > packet size is still the chunk size. Why unaligned mode? This provides
> > > > the user-space with complete freedom on how to optimize the placement
> > > > of the packets in the umem and this might lead to better overall
> > > > performance. Note that if we just look at the kernel part, unaligned
> > > > mode is slower than aligned, but that might not be true on the overall
> > > > level.
> > >
> > > Thank you very much, very detailed explanation.
> > >
> > > I have a question: You said that in the case of unaligned mode, the packet
> > > pointed by desc may use two consecutive chunks at the same time. How do we
> > > ensure that we can apply for two consecutive chunks?
> >
> > I am not sure I understand "apply for", sorry. But in unaligned mode,
> > we reject any desc that spans two chunks that are not physically
> > consecutive in memory. So users of unaligned mode usually use huge
> > pages to make sure that this happens rarely and that these "breaks"
> > are well known to the entity in user-space that places the packets in
> > the umem (i.e., do not create packets that cross huge page boundaries
> > would suffice).
> >
> > > Back to this patch, is it okay to deal with it this way?
> > >
> > >         buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > >
> > >         .....
> > >
> > >         if (pool->unaligned) {
> > >                 u64 l;
> > >
> > >                 l = (buffer - xs->pool->addrs) % xs->pool->chunk_size;
> > >                 if (xs->pool->chunk_size - l < desc->len)
> > >                         skb->truesize += xs->pool->chunk_size * 2;
> > >                 else
> > >                         skb->truesize += xs->pool->chunk_size;
> > >         } else {
> > >                 skb->truesize += xs->pool->chunk_size;
> > >         }
> >
> > Why would not skb->truesize += xs->pool->chunk_size * i; work in both
> > cases? The copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> > statement together with the loop itself should take care of the case
> > when the packet spans two pages as PAGE_SIZE - offset < len it will
> > loop again and copy the rest. In that case, i == 2 when you exit the
> > loop.
>
> Sorry, I feel that my understanding of the unaligned mode has not been very
> deep. So there may be some problems in understanding.
>
> Assuming that the page is 4k, the chunk size is 2k, and a packet is placed at
> the 1k position, it may occupy two chunk, as long as it is larger than 1k, but
> it only uses one page. like this:
>
>      0         2k        4k
>      |        page       |
>      |   chunk |  chunk  |
>            | packet |
>
> In my code, I want to find several pages occupied by desc and insert these pages
> into skb, so i = 1.

Got it, thanks! I actually think this approximation for truesize would
be the best one and we do not have to care about packets striding
chunk or page borders for the truesize calculation:

skb->truesize += pool->unaligned ? desc->len : pool->chunk_size;

For the aligned case, truesize is always one chunk as there can only
be one packet per chunk. For the unaligned case, truesize is just the
length of the packet since you can put many of these into the same
chunk or page. If you have a 2K chunk and a packet length of 256
bytes, you can put 8 packets into one single chunk. So adding
chunk_size for every single packet in the unaligned case would yield a
very bad approximation. We argued in the same way when we chose to use
chunk_size instead of PAGE_SIZE for the aligned case. The strength of
the unaligned case is that you can put many packets in a single chunk
(when packet size is low enough), so users tend to do this. If you do
not do this, then the aligned mode should be used as it will provide
better performance.

> Thanks.
>
> >
> > But it would be great if you could test that your code can deal with
> > this. How about extending the xsk selftests with a case for unaligned
> > mode? Should be quite straightforward. Just make sure you put the
> > packets next to each other so that some of them will cross page
> > boundaries.
> >
> > > Thanks.
> > >
> > > >
> > > > > Thanks.
> > > > >
> > > > > >
> > > > > > > > In addition, I actually borrowed from the tcp code:
> > > > > > > >
> > > > > > > >    tcp_build_frag:
> > > > > > > >    --------------
> > > > > > > >
> > > > > > > >       if (can_coalesce) {
> > > > > > > >               skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
> > > > > > > >       } else {
> > > > > > > >               get_page(page);
> > > > > > > >               skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > > >       }
> > > > > > > >
> > > > > > > >       if (!(flags & MSG_NO_SHARED_FRAGS))
> > > > > > > >               skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
> > > > > > > >
> > > > > > > >       skb->len += copy;
> > > > > > > >       skb->data_len += copy;
> > > > > > > >       skb->truesize += copy;
> > > > > > > >
> > > > > > > > So, here is one bug?
> > > > > > >
> > > > > > > skb_frag_t is an alias to struct bvec. It doesn't contain info about
> > > > > > > real memory consumption, so there's no other option buf just to add
> > > > > > > "copy" to truesize.
> > > > > > > XSK is different in this term, as it operates with chunks of a known
> > > > > > > size.
> > > > > > >
> > > > > > > > Thanks.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > > > > + return skb;
> > > > > > > > > > > > > > > +}
> > > > > > > > > > > > > > > +
> > > > > > > > > > > > >
> > > > > > > > > > > > > Al
> > > > > > > > > > > >
> > > > > > > > > > > > Thanks,
> > > > > > > > > > > > Al
> > > > > > > > > >
> > > > > > > > > > Al
> > > > > > >
