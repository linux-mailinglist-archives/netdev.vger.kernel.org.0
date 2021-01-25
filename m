Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29D3033F0
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbhAZFJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:09:38 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:38594 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbhAYN2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:28:01 -0500
Date:   Mon, 25 Jan 2021 13:25:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611581149; bh=tdGcVh9gs/Ps1kaCgb3Io6wNV3WCHqwcSbRKjKiNX4c=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=jz5MsAYDpiMp5M1RxMFnbBNVzOyW9jSsztIixvbUlfNQcmd2HOSBXz2trdV+YYEp1
         76TRSQqTJ5GLShJU7GlrcA/wbutjDffgd3OBkMtOOuJc/sSBj2OC58V3PKLwTz93+h
         zipXtl+jksdW+ZbpreipviK4oiV68XkZ/Dyh8tfPeMWEbokWDD+Ngcti8jcUCwJRS9
         HBSLDdS7ALSsiXLMpFwfHFmDA29uSsis+Xhnz/j7rG5SzHQihtQX1BzVj71bx09t2k
         xxitF8gPqWpw1syJJE3M0RnuprHWbs5Vd86lYRoznlAWLHuRiZzn7MHhLxa0gB1p+C
         J8ju3Jd0nPLog==
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn@kernel.org,
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH bpf-next v3 3/3] xsk: build skb by page
Message-ID: <20210125132502.3165-1-alobakin@pm.me>
In-Reply-To: <1611544243.8363645-1-xuanzhuo@linux.alibaba.com>
References: <1611544243.8363645-1-xuanzhuo@linux.alibaba.com>
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

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Mon, 25 Jan 2021 11:10:43 +0800

> On Fri, 22 Jan 2021 16:24:17 +0000, Alexander Lobakin <alobakin@pm.me> wr=
ote:
> > From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Date: Fri, 22 Jan 2021 23:36:29 +0800
> >
> > > On Fri, 22 Jan 2021 12:08:00 +0000, Alexander Lobakin <alobakin@pm.me=
> wrote:
> > > > From: Alexander Lobakin <alobakin@pm.me>
> > > > Date: Fri, 22 Jan 2021 11:55:35 +0000
> > > >
> > > > > From: Alexander Lobakin <alobakin@pm.me>
> > > > > Date: Fri, 22 Jan 2021 11:47:45 +0000
> > > > >
> > > > > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > > > > Date: Thu, 21 Jan 2021 16:41:33 +0100
> > > > > >
> > > > > > > On 1/21/21 2:47 PM, Xuan Zhuo wrote:
> > > > > > > > This patch is used to construct skb based on page to save m=
emory copy
> > > > > > > > overhead.
> > > > > > > >
> > > > > > > > This function is implemented based on IFF_TX_SKB_NO_LINEAR.=
 Only the
> > > > > > > > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will =
use page to
> > > > > > > > directly construct skb. If this feature is not supported, i=
t is still
> > > > > > > > necessary to copy data to construct skb.
> > > > > > > >
> > > > > > > > ---------------- Performance Testing ------------
> > > > > > > >
> > > > > > > > The test environment is Aliyun ECS server.
> > > > > > > > Test cmd:
> > > > > > > > ```
> > > > > > > > xdpsock -i eth0 -t  -S -s <msg size>
> > > > > > > > ```
> > > > > > > >
> > > > > > > > Test result data:
> > > > > > > >
> > > > > > > > size    64      512     1024    1500
> > > > > > > > copy    1916747 1775988 1600203 1440054
> > > > > > > > page    1974058 1953655 1945463 1904478
> > > > > > > > percent 3.0%    10.0%   21.58%  32.3%
> > > > > > > >
> > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > > > > > > > ---
> > > > > > > >  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++=
++++++++++----------
> > > > > > > >  1 file changed, 86 insertions(+), 18 deletions(-)
> > > > > > > >
> > > > > > > > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > > > > > > > index 4a83117..38af7f1 100644
> > > > > > > > --- a/net/xdp/xsk.c
> > > > > > > > +++ b/net/xdp/xsk.c
> > > > > > > > @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk=
_buff *skb)
> > > > > > > >  =09sock_wfree(skb);
> > > > > > > >  }
> > > > > > > >
> > > > > > > > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_s=
ock *xs,
> > > > > > > > +=09=09=09=09=09      struct xdp_desc *desc)
> > > > > > > > +{
> > > > > > > > +=09u32 len, offset, copy, copied;
> > > > > > > > +=09struct sk_buff *skb;
> > > > > > > > +=09struct page *page;
> > > > > > > > +=09void *buffer;
> > > > > > > > +=09int err, i;
> > > > > > > > +=09u64 addr;
> > > > > > > > +
> > > > > > > > +=09skb =3D sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> > > >
> > > > Also,
> > > > maybe we should allocate it with NET_SKB_PAD so NIC drivers could
> > > > use some reserved space?
> > > >
> > > > =09=09skb =3D sock_alloc_send_skb(&xs->sk, NET_SKB_PAD, 1, &err);
> > > > =09=09...
> > > > =09=09skb_reserve(skb, NET_SKB_PAD);
> > > >
> > > > Eric, what do you think?
> > >
> > > I think you are right. Some space should be added to continuous equip=
ment. This
> > > space should also be added in the copy mode below. Is LL_RESERVED_SPA=
CE more
> > > appropriate?
> >
> > No. If you look at __netdev_alloc_skb() and __napi_alloc_skb(), they
> > reserve NET_SKB_PAD at the beginning of linear area. Documentation of
> > __build_skb() also says that driver should reserve NET_SKB_PAD before
> > the actual frame, so it is a standartized hardware-independent
> > headroom.
>=20
> I understand that these scenarios are in the case of receiving packets, a=
nd the
> increased space is used by the protocol stack, especially RPS. I don't kn=
ow if
> this also applies to the sending scenario?
>=20
> > Leaving that space in skb->head will allow developers to implement
> > IFF_TX_SKB_NO_LINEAR in a wider variety of drivers, especially when
> > a driver has to prepend some sort of data before the actual frame.
> > Since it's usually of a size of one cacheline, shouldn't be a big
> > deal.
> >
>=20
> I agree with this. Some network cards require some space. For example,
> virtio-net needs to add a virtio_net_hdr_mrg_rxbuf before skb->data, so m=
y
> original understanding is used here. When we send the skb to the
> driver, the driver may need a memory space. So I refer to the
> implementation of __ip_append_data, I feel that adding
> LL_RESERVED_SPACE is a suitable solution.
>=20
> I feel that I may still not understand the use scene you mentioned. Can y=
ou
> elaborate on what you understand this space will be used for?

LL_RESERVED_SPACE() consists of L2 header size (Ethernet for the most
cases) and dev->needed_headroom. That is not a value to count on, as:
 - L2 header is already here in XSK buffer;
 - not all drivers set dev->needed_headroom;
 - it's aligned by 16, not L1_CACHE_SIZE.

As this path is XSK generic path, i.e. when driver-side XSK is not
present or not requested, it can be applied to every driver. Many
of them call skb_cow_head() + skb_push() on their xmit path:
 - nearly all virtual drivers (to insert their specific headers);
 - nearly all switch drivers (to insert switch CPU port tags);
 - some enterprise NIC drivers (ChelsIO for LSO, Netronome
   for TLS etc.).

skb_cow_head() + skb_push() relies on a required NET_SKB_PAD headroom.
In case where there is no enough space (and you allocate an skb with
no headroom at all), skb will be COWed, which is a huge overhead and
will cause slowdowns.
So, adding NET_SKB_PAD would save from almost all, if not all, such
reallocations.

> Thanks.
>=20
> >
> > [ I also had an idea of allocating an skb with a headroom of
> > NET_SKB_PAD + 256 bytes, so nearly all drivers could just call
> > pskb_pull_tail() to support such type of skbuffs without much
> > effort, but I think that it's better to teach drivers to support
> > xmitting of really headless ones. If virtio_net can do it, why
> > shouldn't the others ]
> >
> > > > > > > > +=09if (unlikely(!skb))
> > > > > > > > +=09=09return ERR_PTR(err);
> > > > > > > > +
> > > > > > > > +=09addr =3D desc->addr;
> > > > > > > > +=09len =3D desc->len;
> > > > > > > > +
> > > > > > > > +=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> > > > > > > > +=09offset =3D offset_in_page(buffer);
> > > > > > > > +=09addr =3D buffer - xs->pool->addrs;
> > > > > > > > +
> > > > > > > > +=09for (copied =3D 0, i =3D 0; copied < len; i++) {
> > > > > > > > +=09=09page =3D xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> > > > > > > > +
> > > > > > > > +=09=09get_page(page);
> > > > > > > > +
> > > > > > > > +=09=09copy =3D min_t(u32, PAGE_SIZE - offset, len - copied=
);
> > > > > > > > +
> > > > > > > > +=09=09skb_fill_page_desc(skb, i, page, offset, copy);
> > > > > > > > +
> > > > > > > > +=09=09copied +=3D copy;
> > > > > > > > +=09=09addr +=3D copy;
> > > > > > > > +=09=09offset =3D 0;
> > > > > > > > +=09}
> > > > > > > > +
> > > > > > > > +=09skb->len +=3D len;
> > > > > > > > +=09skb->data_len +=3D len;
> > > > > > >
> > > > > > > > +=09skb->truesize +=3D len;
> > > > > > >
> > > > > > > This is not the truesize, unfortunately.
> > > > > > >
> > > > > > > We need to account for the number of pages, not number of byt=
es.
> > > > > >
> > > > > > The easiest solution is:
> > > > > >
> > > > > > =09skb->truesize +=3D PAGE_SIZE * i;
> > > > > >
> > > > > > i would be equal to skb_shinfo(skb)->nr_frags after exiting the=
 loop.
> > > > >
> > > > > Oops, pls ignore this. I forgot that XSK buffers are not
> > > > > "one per page".
> > > > > We need to count the number of pages manually and then do
> > > > >
> > > > > =09skb->truesize +=3D PAGE_SIZE * npages;
> > > > >
> > > > > Right.
> > > > >
> > > > > > > > +
> > > > > > > > +=09refcount_add(len, &xs->sk.sk_wmem_alloc);
> > > > > > > > +
> > > > > > > > +=09return skb;
> > > > > > > > +}
> > > > > > > > +
> > > > > >
> > > > > > Al
> > > > >
> > > > > Thanks,
> > > > > Al
> > > >
> > > > Al

Thanks,
Al

