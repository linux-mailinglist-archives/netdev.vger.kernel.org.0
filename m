Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA20300CF4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 20:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730389AbhAVTxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 14:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbhAVSh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:37:59 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA112C061788;
        Fri, 22 Jan 2021 10:37:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u4so4448365pjn.4;
        Fri, 22 Jan 2021 10:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qaA8gn8W+Qu4RF9KetEmDBu/lptRV9ahKpJnZpI7ZCo=;
        b=Q9HhAWjka/fgAdf6tIezBrvuW0cqacMGrv5pjCFzngBW44GQxtCcNZSPne3ymkCfhg
         YYBo+8Ei8TAYYjJ5Eu0diMLL+MuMDVtQA+Lb6IpKqVcDzM+zoAWjORzSs53tAddbxY2v
         m6GqvrK8kuPKSk6uttoSnbJ7XUr5BYvXs+mDNZWqR0ov5GMYmL9yCbH8WNg43XU8/DkA
         j9RdPlvHhj/EhnQqqTlwDoKourDCNC87oFvQblXxjzZ5zZsHQ5Il3ec9mwQAtteMk3pq
         Uuxe9dHerS5Ii5o55wbA5hmc1BRFS7V4SqI10Vh0b5x+3zqzhLr5459nwZct7Yl98Ynt
         9wgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qaA8gn8W+Qu4RF9KetEmDBu/lptRV9ahKpJnZpI7ZCo=;
        b=LEOzMtiS1DypVUxJS0fDijXKW6aBlyZmjn9rmMjhFAQsy61pkPFR2IXK2lMbCT16Ue
         8KwOZ8ZwvgN7XiP+bSXKtlY8dqYb+5bMH8Uxm+9KL8iWEzSzyGBh10r1EwKahQMjB9Jr
         ArI1VrsAQJGg7fk+9oDyD17v73Gg673CpeIsNWQ6egC6cbZuVg2wLO3bJ31QhHpDI27T
         ehYyeRrwsAvIkv5/xw1Wtjz3UnqxEns4xQnAzPY+E+nFECB0yHvjz5GxXTZ6dzssSRqZ
         Hw5yLWjra3rW5d9IOVi8lGLAK4nPUPPQknMrmbbfiyGS+PTTBvtff1iZEs3jEv6teWTj
         S9Zw==
X-Gm-Message-State: AOAM533P6V/PvQt3qPtPn+RbRKOdfatEkEkEhj3YXjIf0bke79V/2/iy
        ud2tBwxYvoAQD2PQPDoP0NJax0DIrSKJVGs1NwrGeMrMgyG3UQ==
X-Google-Smtp-Source: ABdhPJzBM0YzSfYP6oM7kRIRx6dclFXfHRC0Ic0kFqaNBSS+HPxNtv8ookM9vpCOGsNT+AdZ+FmAMIpQ8Gfu0nU/hJY=
X-Received: by 2002:a17:902:7c04:b029:dc:99f2:eea4 with SMTP id
 x4-20020a1709027c04b02900dc99f2eea4mr5931479pll.43.1611340638255; Fri, 22 Jan
 2021 10:37:18 -0800 (PST)
MIME-Version: 1.0
References: <1611329955.4913929-2-xuanzhuo@linux.alibaba.com> <20210122172534.9896-1-alobakin@pm.me>
In-Reply-To: <20210122172534.9896-1-alobakin@pm.me>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 22 Jan 2021 19:37:06 +0100
Message-ID: <CAJ8uoz310du+0qsdGWKtsrK3tBxGFTr=kWkT+GwY1GqN=A2ejQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
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
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 6:26 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Date: Fri, 22 Jan 2021 23:39:15 +0800
>
> > On Fri, 22 Jan 2021 13:55:14 +0100, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > > On Fri, Jan 22, 2021 at 1:39 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > >
> > > > From: Magnus Karlsson <magnus.karlsson@gmail.com>
> > > > Date: Fri, 22 Jan 2021 13:18:47 +0100
> > > >
> > > > > On Fri, Jan 22, 2021 at 12:57 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > > >
> > > > > > From: Alexander Lobakin <alobakin@pm.me>
> > > > > > Date: Fri, 22 Jan 2021 11:47:45 +0000
> > > > > >
> > > > > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > > > > > >
> > > > > > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > > > > > This patch is used to construct skb based on page to save memory copy
> > > > > > > > > overhead.
> > > > > > > > >
> > > > > > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > > > > > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > > > > > > > > directly construct skb. If this feature is not supported, it is still
> > > > > > > > > necessary to copy data to construct skb.
> > > > > > > > >
> > > > > > > > > ---------------- Performance Testing ------------
> > > > > > > > >
> > > > > > > > > The test environment is Aliyun ECS server.
> > > > > > > > > Test cmd:
> > > > > > > > > ```
> > > > > > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > > > > > ```
> > > > > > > > >
> > > > > > > > > Test result data:
> > > > > > > > >
> > > > > > > > > size    64      512     1024    1500
> > > > > > > > > copy    1916747 1775988 1600203 1440054
> > > > > > > > > page    1974058 1953655 1945463 1904478
> > > > > > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > > > > > >
> > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > > > > > ---
> > > > > > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
> > > > > > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > > > > > index 4a83117..38af7f1 100644
> > > > > > > > > --- a/net/xdp/xsk.c
> > > > > > > > > +++ b/net/xdp/xsk.c
> > > > > > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> > > > > > > > >   sock_wfree(skb);
> > > > > > > > >  }
> > > > > > > > >
> > > > > > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > > > > > > > > +                                       struct xdp_desc *desc)
> > > > > > > > > +{
> > > > > > > > > + u32 len, offset, copy, copied;
> > > > > > > > > + struct sk_buff *skb;
> > > > > > > > > + struct page *page;
> > > > > > > > > + void *buffer;
> > > > > > > > > + int err, i;
> > > > > > > > > + u64 addr;
> > > > > > > > > +
> > > > > > > > > + skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > > > > > > > + if (unlikely(!skb))
> > > > > > > > > +         return ERR_PTR(err);
> > > > > > > > > +
> > > > > > > > > + addr = desc->addr;
> > > > > > > > > + len = desc->len;
> > > > > > > > > +
> > > > > > > > > + buffer = xsk_buff_raw_get_data(xs->pool, addr);
> > > > > > > > > + offset = offset_in_page(buffer);
> > > > > > > > > + addr = buffer - xs->pool->addrs;
> > > > > > > > > +
> > > > > > > > > + for (copied = 0, i = 0; copied < len; i++) {
> > > > > > > > > +         page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > > > > > +
> > > > > > > > > +         get_page(page);
> > > > > > > > > +
> > > > > > > > > +         copy = min_t(u32, PAGE_SIZE - offset, len - copied);
> > > > > > > > > +
> > > > > > > > > +         skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > > > > +
> > > > > > > > > +         copied += copy;
> > > > > > > > > +         addr += copy;
> > > > > > > > > +         offset = 0;
> > > > > > > > > + }
> > > > > > > > > +
> > > > > > > > > + skb->len += len;
> > > > > > > > > + skb->data_len += len;
> > > > > > > >
> > > > > > > > > + skb->truesize += len;
> > > > > > > >
> > > > > > > > This is not the truesize, unfortunately.
> > > > > > > >
> > > > > > > > We need to account for the number of pages, not number of bytes.
> > > > > > >
> > > > > > > The easiest solution is:
> > > > > > >
> > > > > > >       skb->truesize += PAGE_SIZE * i;
> > > > > > >
> > > > > > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the loop.
> > > > > >
> > > > > > Oops, pls ignore this. I forgot that XSK buffers are not
> > > > > > "one per page".
> > > > > > We need to count the number of pages manually and then do
> > > > > >
> > > > > >         skb->truesize += PAGE_SIZE * npages;
> > > > > >
> > > > > > Right.
> > > > >
> > > > > There are two possible packet buffer (chunks) sizes in a umem, 2K and
> > > > > 4K on a system with a PAGE_SIZE of 4K. If I remember correctly, and
> > > > > please correct me if wrong, truesize is used for memory accounting.
> > > > > But in this code, no kernel memory has been allocated (apart from the
> > > > > skb). The page is just a part of the umem that has been already
> > > > > allocated beforehand and by user-space in this case. So what should
> > > > > truesize be in this case? Do we add 0, chunk_size * i, or the
> > > > > complicated case of counting exactly how many 4K pages that are used
> > > > > when the chunk_size is 2K, as two chunks could occupy the same page,
> > > > > or just the upper bound of PAGE_SIZE * i that is likely a good
> > > > > approximation in most cases? Just note that there might be other uses
> > > > > of truesize that I am unaware of that could impact this choice.
> > > >
> > > > Truesize is "what amount of memory does this skb occupy with all its
> > > > fragments, linear space and struct sk_buff itself". The closest it
> > > > will be to the actual value, the better.
> > > > In this case, I think adding of chunk_size * i would be enough.
> > >
> > > Sounds like a good approximation to me.
> > >
> > > > (PAGE_SIZE * i can be overwhelming when chunk_size is 2K, especially
> > > > for setups with PAGE_SIZE > SZ_4K)
> > >
> > > You are right. That would be quite horrible on a system with a page size of 64K.
> >
> > Thank you everyone, I learned it.
> >
> > I also think it is appropriate to add a chunk size here, and there is actually
> > only one chunk here, so it's very simple
> >
> >       skb->truesize += xs->pool->chunk_size;
>
> umem chunks can't cross page boundaries. So if you're sure that
> there could be only one chunk, you don't need the loop at all,
> if I'm not missing anything.

In the default mode, this is true. But in the unaligned_chunk mode
that can be set on the umem, the chunk may cross one page boundary, so
we need the loop and the chunk_size * i in the assignment of truesize.
So "i" can be 1 or 2, but nothing else.

> > In addition, I actually borrowed from the tcp code:
> >
> >    tcp_build_frag:
> >    --------------
> >
> >       if (can_coalesce) {
> >               skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
> >       } else {
> >               get_page(page);
> >               skb_fill_page_desc(skb, i, page, offset, copy);
> >       }
> >
> >       if (!(flags & MSG_NO_SHARED_FRAGS))
> >               skb_shinfo(skb)->flags |= SKBFL_SHARED_FRAG;
> >
> >       skb->len += copy;
> >       skb->data_len += copy;
> >       skb->truesize += copy;
> >
> > So, here is one bug?
>
> skb_frag_t is an alias to struct bvec. It doesn't contain info about
> real memory consumption, so there's no other option buf just to add
> "copy" to truesize.
> XSK is different in this term, as it operates with chunks of a known
> size.
>
> > Thanks.
> >
> > >
> > > > > > > > > +
> > > > > > > > > + refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > > > > > +
> > > > > > > > > + return skb;
> > > > > > > > > +}
> > > > > > > > > +
> > > > > > >
> > > > > > > Al
> > > > > >
> > > > > > Thanks,
> > > > > > Al
> > > >
> > > > Al
>
