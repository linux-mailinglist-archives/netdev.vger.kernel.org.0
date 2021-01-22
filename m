Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8E300358
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727512AbhAVMk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:40:29 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:25533 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbhAVMk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:40:26 -0500
Date:   Fri, 22 Jan 2021 12:39:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611319177; bh=MurfsX/xFc6EJaZnP4aHHBq5FK0oyXI/IchGUo+j9ZM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=P5QmSyiHLWiyp62ojlSpBj+PHE1FilejDgySIqAe9ggMhdv1NVhIof4xs/N55knKb
         lYhnbkSzpBVSG7NeKVKCilPmCBlUK9jlPakwiabCSJUR/PM6ZS2gzywSP7DHzKgNjb
         adi6rBSJEghwHIOB5DdIB89uZ648rDUIclfP0wmc/TQMTg1qmJHGUKAt575ne5q5Jg
         5ifBiPmbKYmM+hFb1Pw/GudMxMSHsfTL8zpUD+h+qf9iaG4yXQYGf4ay9gFfsVhcuI
         5xho5xgcUZZYbrg5vdnKdSdOHxxJm+P8rVEYObVh9g400FOY3PL1hcB9NR3UklPPR8
         jYK62pLW0iOhg==
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
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
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
Message-ID: <20210122123909.3603-1-alobakin@pm.me>
In-Reply-To: <CAJ8uoz0ve9iRmz6zkCTaBMMjckFrD0df43-uVreXVf_wM3mZ1A@mail.gmail.com>
References: <cover.1611236588.git.xuanzhuo@linux.alibaba.com> <340f1dfa40416dd966a56e08507daba82d633088.1611236588.git.xuanzhuo@linux.alibaba.com> <dcee4592-9fa9-adbb-55ca-58a962076e7a@gmail.com> <20210122114729.1758-1-alobakin@pm.me> <20210122115519.2183-1-alobakin@pm.me> <CAJ8uoz0ve9iRmz6zkCTaBMMjckFrD0df43-uVreXVf_wM3mZ1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Fri, 22 Jan 2021 13:18:47 +0100

> On Fri, Jan 22, 2021 at 12:57 PM Alexander Lobakin <alobakin@pm.me> wrote=
:
> >
> > From: Alexander Lobakin <alobakin@pm.me>
> > Date: Fri, 22 Jan 2021 11:47:45 +0000
> >
> > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > >
> > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > This patch is used to construct skb based on page to save memory =
copy
> > > > > overhead.
> > > > >
> > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only =
the
> > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use pa=
ge to
> > > > > directly construct skb. If this feature is not supported, it is s=
till
> > > > > necessary to copy data to construct skb.
> > > > >
> > > > > ---------------- Performance Testing ------------
> > > > >
> > > > > The test environment is Aliyun ECS server.
> > > > > Test cmd:
> > > > > ```
> > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > ```
> > > > >
> > > > > Test result data:
> > > > >
> > > > > size    64      512     1024    1500
> > > > > copy    1916747 1775988 1600203 1440054
> > > > > page    1974058 1953655 1945463 1904478
> > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > ---
> > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++=
++++----------
> > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > >
> > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > index 4a83117..38af7f1 100644
> > > > > --- a/net/xdp/xsk.c
> > > > > +++ b/net/xdp/xsk.c
> > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff =
*skb)
> > > > >   sock_wfree(skb);
> > > > >  }
> > > > >
> > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *x=
s,
> > > > > +                                       struct xdp_desc *desc)
> > > > > +{
> > > > > + u32 len, offset, copy, copied;
> > > > > + struct sk_buff *skb;
> > > > > + struct page *page;
> > > > > + void *buffer;
> > > > > + int err, i;
> > > > > + u64 addr;
> > > > > +
> > > > > + skb =3D sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > > > + if (unlikely(!skb))
> > > > > +         return ERR_PTR(err);
> > > > > +
> > > > > + addr =3D desc->addr;
> > > > > + len =3D desc->len;
> > > > > +
> > > > > + buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> > > > > + offset =3D offset_in_page(buffer);
> > > > > + addr =3D buffer - xs->pool->addrs;
> > > > > +
> > > > > + for (copied =3D 0, i =3D 0; copied < len; i++) {
> > > > > +         page =3D xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > +
> > > > > +         get_page(page);
> > > > > +
> > > > > +         copy =3D min_t(u32, PAGE_SIZE - offset, len - copied);
> > > > > +
> > > > > +         skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > +
> > > > > +         copied +=3D copy;
> > > > > +         addr +=3D copy;
> > > > > +         offset =3D 0;
> > > > > + }
> > > > > +
> > > > > + skb->len +=3D len;
> > > > > + skb->data_len +=3D len;
> > > >
> > > > > + skb->truesize +=3D len;
> > > >
> > > > This is not the truesize, unfortunately.
> > > >
> > > > We need to account for the number of pages, not number of bytes.
> > >
> > > The easiest solution is:
> > >
> > >       skb->truesize +=3D PAGE_SIZE * i;
> > >
> > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the loop.
> >
> > Oops, pls ignore this. I forgot that XSK buffers are not
> > "one per page".
> > We need to count the number of pages manually and then do
> >
> >         skb->truesize +=3D PAGE_SIZE * npages;
> >
> > Right.
>=20
> There are two possible packet buffer (chunks) sizes in a umem, 2K and
> 4K on a system with a PAGE_SIZE of 4K. If I remember correctly, and
> please correct me if wrong, truesize is used for memory accounting.
> But in this code, no kernel memory has been allocated (apart from the
> skb). The page is just a part of the umem that has been already
> allocated beforehand and by user-space in this case. So what should
> truesize be in this case? Do we add 0, chunk_size * i, or the
> complicated case of counting exactly how many 4K pages that are used
> when the chunk_size is 2K, as two chunks could occupy the same page,
> or just the upper bound of PAGE_SIZE * i that is likely a good
> approximation in most cases? Just note that there might be other uses
> of truesize that I am unaware of that could impact this choice.

Truesize is "what amount of memory does this skb occupy with all its
fragments, linear space and struct sk_buff itself". The closest it
will be to the actual value, the better.
In this case, I think adding of chunk_size * i would be enough.

(PAGE_SIZE * i can be overwhelming when chunk_size is 2K, especially
for setups with PAGE_SIZE > SZ_4K)

> > > > > +
> > > > > + refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > +
> > > > > + return skb;
> > > > > +}
> > > > > +
> > >
> > > Al
> >
> > Thanks,
> > Al

Al

