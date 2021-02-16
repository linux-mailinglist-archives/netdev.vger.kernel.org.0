Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B92B31CBA4
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhBPOQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 09:16:26 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:23585 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhBPOQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 09:16:26 -0500
Date:   Tue, 16 Feb 2021 14:15:32 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613484936; bh=jwQMQJwMWvjuZZcVe2rhp855u4r5rgmcy7veIiiilfo=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=iAAK1XqcN5/Z/C7QBWrbabG3FAOsle6D8RUpocNr8GDzPuXnwEsdRsx3ltvbzMUvm
         JmWzP/IuPJhxF5iMwSRdXO/ZvGFeFrno6nlV67B8KrXAZp1uriQKSpiK6XJ9AMV2ag
         VtLL8ajT+mKtlT8H4gQ2wYi0skrLXygb1RfprizR10PrpgswX6qsdnFJfHwQojfa60
         oipM7D+5C/NArok+8HgUb8IXS3X1X807r1qak0Csw9OV5g0o7erFI7WCgKACL6pm0e
         79X3nZftJdc0tMSPJjL12JxLkDYJwzwXJclbLceSVm7Ig7BQZjWekOpydqPeRY+HYH
         V6NXKsm7WrHXQ==
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 bpf-next 6/6] xsk: build skb by page (aka generic zerocopy xmit)
Message-ID: <20210216141507.3263-1-alobakin@pm.me>
In-Reply-To: <CAJ8uoz0-ge=_jC8EbR371DMKxYSP8USni5OqVf0yk1-4Z=vnOg@mail.gmail.com>
References: <20210216113740.62041-1-alobakin@pm.me> <20210216113740.62041-7-alobakin@pm.me> <CAJ8uoz0-ge=_jC8EbR371DMKxYSP8USni5OqVf0yk1-4Z=vnOg@mail.gmail.com>
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
Date: Tue, 16 Feb 2021 15:08:26 +0100

> On Tue, Feb 16, 2021 at 12:44 PM Alexander Lobakin <alobakin@pm.me> wrote=
:
> >
> > From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >
> > This patch is used to construct skb based on page to save memory copy
> > overhead.
> >
> > This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> > network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> > directly construct skb. If this feature is not supported, it is still
> > necessary to copy data to construct skb.
> >
> > ---------------- Performance Testing ------------
> >
> > The test environment is Aliyun ECS server.
> > Test cmd:
> > ```
> > xdpsock -i eth0 -t  -S -s <msg size>
> > ```
> >
> > Test result data:
> >
> > size    64      512     1024    1500
> > copy    1916747 1775988 1600203 1440054
> > page    1974058 1953655 1945463 1904478
> > percent 3.0%    10.0%   21.58%  32.3%
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> > [ alobakin:
> >  - expand subject to make it clearer;
> >  - improve skb->truesize calculation;
> >  - reserve some headroom in skb for drivers;
> >  - tailroom is not needed as skb is non-linear ]
> > Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>=20
> Thank you Alexander!
>=20
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

Thanks!

I have one more generic zerocopy to offer (inspired by this series)
that wouldn't require IFF_TX_SKB_NO_LINEAR, only a capability to xmit
S/G packets that almost every NIC has. I'll publish an RFC once this
and your upcoming changes get merged.

> > ---
> >  net/xdp/xsk.c | 119 ++++++++++++++++++++++++++++++++++++++++----------
> >  1 file changed, 95 insertions(+), 24 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 143979ea4165..ff7bd06e1241 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -445,6 +445,96 @@ static void xsk_destruct_skb(struct sk_buff *skb)
> >         sock_wfree(skb);
> >  }
> >
> > +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> > +                                             struct xdp_desc *desc)
> > +{
> > +       struct xsk_buff_pool *pool =3D xs->pool;
> > +       u32 hr, len, offset, copy, copied;
> > +       struct sk_buff *skb;
> > +       struct page *page;
> > +       void *buffer;
> > +       int err, i;
> > +       u64 addr;
> > +
> > +       hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom=
));
> > +
> > +       skb =3D sock_alloc_send_skb(&xs->sk, hr, 1, &err);
> > +       if (unlikely(!skb))
> > +               return ERR_PTR(err);
> > +
> > +       skb_reserve(skb, hr);
> > +
> > +       addr =3D desc->addr;
> > +       len =3D desc->len;
> > +
> > +       buffer =3D xsk_buff_raw_get_data(pool, addr);
> > +       offset =3D offset_in_page(buffer);
> > +       addr =3D buffer - pool->addrs;
> > +
> > +       for (copied =3D 0, i =3D 0; copied < len; i++) {
> > +               page =3D pool->umem->pgs[addr >> PAGE_SHIFT];
> > +               get_page(page);
> > +
> > +               copy =3D min_t(u32, PAGE_SIZE - offset, len - copied);
> > +               skb_fill_page_desc(skb, i, page, offset, copy);
> > +
> > +               copied +=3D copy;
> > +               addr +=3D copy;
> > +               offset =3D 0;
> > +       }
> > +
> > +       skb->len +=3D len;
> > +       skb->data_len +=3D len;
> > +       skb->truesize +=3D pool->unaligned ? len : pool->chunk_size;
> > +
> > +       refcount_add(skb->truesize, &xs->sk.sk_wmem_alloc);
> > +
> > +       return skb;
> > +}
> > +
> > +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> > +                                    struct xdp_desc *desc)
> > +{
> > +       struct net_device *dev =3D xs->dev;
> > +       struct sk_buff *skb;
> > +
> > +       if (dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
> > +               skb =3D xsk_build_skb_zerocopy(xs, desc);
> > +               if (IS_ERR(skb))
> > +                       return skb;
> > +       } else {
> > +               u32 hr, tr, len;
> > +               void *buffer;
> > +               int err;
> > +
> > +               hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_head=
room));
> > +               tr =3D dev->needed_tailroom;
> > +               len =3D desc->len;
> > +
> > +               skb =3D sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, =
&err);
> > +               if (unlikely(!skb))
> > +                       return ERR_PTR(err);
> > +
> > +               skb_reserve(skb, hr);
> > +               skb_put(skb, len);
> > +
> > +               buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
> > +               err =3D skb_store_bits(skb, 0, buffer, len);
> > +               if (unlikely(err)) {
> > +                       kfree_skb(skb);
> > +                       return ERR_PTR(err);
> > +               }
> > +       }
> > +
> > +       skb->dev =3D dev;
> > +       skb->priority =3D xs->sk.sk_priority;
> > +       skb->mark =3D xs->sk.sk_mark;
> > +       skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc->addr;
> > +       skb->destructor =3D xsk_destruct_skb;
> > +
> > +       return skb;
> > +}
> > +
> >  static int xsk_generic_xmit(struct sock *sk)
> >  {
> >         struct xdp_sock *xs =3D xdp_sk(sk);
> > @@ -454,56 +544,37 @@ static int xsk_generic_xmit(struct sock *sk)
> >         struct sk_buff *skb;
> >         unsigned long flags;
> >         int err =3D 0;
> > -       u32 hr, tr;
> >
> >         mutex_lock(&xs->mutex);
> >
> >         if (xs->queue_id >=3D xs->dev->real_num_tx_queues)
> >                 goto out;
> >
> > -       hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom=
));
> > -       tr =3D xs->dev->needed_tailroom;
> > -
> >         while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> > -               char *buffer;
> > -               u64 addr;
> > -               u32 len;
> > -
> >                 if (max_batch-- =3D=3D 0) {
> >                         err =3D -EAGAIN;
> >                         goto out;
> >                 }
> >
> > -               len =3D desc.len;
> > -               skb =3D sock_alloc_send_skb(sk, hr + len + tr, 1, &err)=
;
> > -               if (unlikely(!skb))
> > +               skb =3D xsk_build_skb(xs, &desc);
> > +               if (IS_ERR(skb)) {
> > +                       err =3D PTR_ERR(skb);
> >                         goto out;
> > +               }
> >
> > -               skb_reserve(skb, hr);
> > -               skb_put(skb, len);
> > -
> > -               addr =3D desc.addr;
> > -               buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> > -               err =3D skb_store_bits(skb, 0, buffer, len);
> >                 /* This is the backpressure mechanism for the Tx path.
> >                  * Reserve space in the completion queue and only proce=
ed
> >                  * if there is space in it. This avoids having to imple=
ment
> >                  * any buffering in the Tx path.
> >                  */
> >                 spin_lock_irqsave(&xs->pool->cq_lock, flags);
> > -               if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> > +               if (xskq_prod_reserve(xs->pool->cq)) {
> >                         spin_unlock_irqrestore(&xs->pool->cq_lock, flag=
s);
> >                         kfree_skb(skb);
> >                         goto out;
> >                 }
> >                 spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> >
> > -               skb->dev =3D xs->dev;
> > -               skb->priority =3D sk->sk_priority;
> > -               skb->mark =3D sk->sk_mark;
> > -               skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc.=
addr;
> > -               skb->destructor =3D xsk_destruct_skb;
> > -
> >                 err =3D __dev_direct_xmit(skb, xs->queue_id);
> >                 if  (err =3D=3D NETDEV_TX_BUSY) {
> >                         /* Tell user-space to retry the send */
> > --
> > 2.30.1

Al

