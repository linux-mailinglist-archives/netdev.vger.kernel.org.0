Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B6B31CEBD
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 18:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbhBPRLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 12:11:55 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:37590 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhBPRLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 12:11:51 -0500
Date:   Tue, 16 Feb 2021 17:10:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1613495462; bh=yBLiWMYKtAXu6Q0cJ8YPjPlctXPo/3Ryh70U06uVX/g=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=NgzNkOl5lSqV+fUnKiY55S4Mtjc4ijoQFm6lRBqndPgb7oSQHRRtfI9ihdsJc36Bb
         xQjBS+q9hmGd3EtPMaE+xpxbeHuoMkYbo/BNaZknED06QGV2zBSGcIixEma/eKYtR8
         XlcuAu0J8axazr3RaZ43zgchnrcH6PkKXlQi8vI7O7Uektoj4KiE958HPDQ9CMoHnA
         H4CyagoLFV26k6EMUn44tQrtPMZOX8ta8PG9fvd1Pzb/kTRfWFY0w9T0iUYxMvuQ8O
         Z3aoTmtqH07qTpIZ5O6GLgop85rVpKaz5EEAco/GkCALmmgffuc++Lgd5LUsjf3fCF
         YftQHagpzuqRQ==
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
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
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v5 bpf-next 6/6] xsk: build skb by page (aka generic zerocopy xmit)
Message-ID: <20210216171042.372483-1-alobakin@pm.me>
In-Reply-To: <20210216143333.5861-7-alobakin@pm.me>
References: <20210216143333.5861-1-alobakin@pm.me> <20210216143333.5861-7-alobakin@pm.me>
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

From: Alexander Lobakin <alobakin@pm.me>
Date: Tue, 16 Feb 2021 14:35:02 +0000

> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>=20
> This patch is used to construct skb based on page to save memory copy
> overhead.
>=20
> This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
> network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
> directly construct skb. If this feature is not supported, it is still
> necessary to copy data to construct skb.
>=20
> ---------------- Performance Testing ------------
>=20
> The test environment is Aliyun ECS server.
> Test cmd:
> ```
> xdpsock -i eth0 -t  -S -s <msg size>
> ```
>=20
> Test result data:
>=20
> size    64      512     1024    1500
> copy    1916747 1775988 1600203 1440054
> page    1974058 1953655 1945463 1904478
> percent 3.0%    10.0%   21.58%  32.3%
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> [ alobakin:
>  - expand subject to make it clearer;
>  - improve skb->truesize calculation;
>  - reserve some headroom in skb for drivers;
>  - tailroom is not needed as skb is non-linear ]
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  net/xdp/xsk.c | 119 ++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 95 insertions(+), 24 deletions(-)
>=20
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 143979ea4165..ff7bd06e1241 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -445,6 +445,96 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>  =09sock_wfree(skb);
>  }
> =20
> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> +=09=09=09=09=09      struct xdp_desc *desc)
> +{
> +=09struct xsk_buff_pool *pool =3D xs->pool;
> +=09u32 hr, len, offset, copy, copied;
> +=09struct sk_buff *skb;
> +=09struct page *page;
> +=09void *buffer;
> +=09int err, i;
> +=09u64 addr;
> +
> +=09hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
> +
> +=09skb =3D sock_alloc_send_skb(&xs->sk, hr, 1, &err);
> +=09if (unlikely(!skb))
> +=09=09return ERR_PTR(err);
> +
> +=09skb_reserve(skb, hr);
> +
> +=09addr =3D desc->addr;
> +=09len =3D desc->len;
> +
> +=09buffer =3D xsk_buff_raw_get_data(pool, addr);
> +=09offset =3D offset_in_page(buffer);
> +=09addr =3D buffer - pool->addrs;
> +
> +=09for (copied =3D 0, i =3D 0; copied < len; i++) {
> +=09=09page =3D pool->umem->pgs[addr >> PAGE_SHIFT];
> +=09=09get_page(page);
> +
> +=09=09copy =3D min_t(u32, PAGE_SIZE - offset, len - copied);
> +=09=09skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +=09=09copied +=3D copy;
> +=09=09addr +=3D copy;
> +=09=09offset =3D 0;
> +=09}
> +
> +=09skb->len +=3D len;
> +=09skb->data_len +=3D len;
> +=09skb->truesize +=3D pool->unaligned ? len : pool->chunk_size;
> +
> +=09refcount_add(skb->truesize, &xs->sk.sk_wmem_alloc);

Meh, there's a refcount leak here I accidentally introduced in v4.
Sorry for that, I'll upload v6 in just a moment.

> +=09return skb;
> +}
> +
> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> +=09=09=09=09     struct xdp_desc *desc)
> +{
> +=09struct net_device *dev =3D xs->dev;
> +=09struct sk_buff *skb;
> +
> +=09if (dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
> +=09=09skb =3D xsk_build_skb_zerocopy(xs, desc);
> +=09=09if (IS_ERR(skb))
> +=09=09=09return skb;
> +=09} else {
> +=09=09u32 hr, tr, len;
> +=09=09void *buffer;
> +=09=09int err;
> +
> +=09=09hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(dev->needed_headroom));
> +=09=09tr =3D dev->needed_tailroom;
> +=09=09len =3D desc->len;
> +
> +=09=09skb =3D sock_alloc_send_skb(&xs->sk, hr + len + tr, 1, &err);
> +=09=09if (unlikely(!skb))
> +=09=09=09return ERR_PTR(err);
> +
> +=09=09skb_reserve(skb, hr);
> +=09=09skb_put(skb, len);
> +
> +=09=09buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
> +=09=09err =3D skb_store_bits(skb, 0, buffer, len);
> +=09=09if (unlikely(err)) {
> +=09=09=09kfree_skb(skb);
> +=09=09=09return ERR_PTR(err);
> +=09=09}
> +=09}
> +
> +=09skb->dev =3D dev;
> +=09skb->priority =3D xs->sk.sk_priority;
> +=09skb->mark =3D xs->sk.sk_mark;
> +=09skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc->addr;
> +=09skb->destructor =3D xsk_destruct_skb;
> +
> +=09return skb;
> +}
> +
>  static int xsk_generic_xmit(struct sock *sk)
>  {
>  =09struct xdp_sock *xs =3D xdp_sk(sk);
> @@ -454,56 +544,37 @@ static int xsk_generic_xmit(struct sock *sk)
>  =09struct sk_buff *skb;
>  =09unsigned long flags;
>  =09int err =3D 0;
> -=09u32 hr, tr;
> =20
>  =09mutex_lock(&xs->mutex);
> =20
>  =09if (xs->queue_id >=3D xs->dev->real_num_tx_queues)
>  =09=09goto out;
> =20
> -=09hr =3D max(NET_SKB_PAD, L1_CACHE_ALIGN(xs->dev->needed_headroom));
> -=09tr =3D xs->dev->needed_tailroom;
> -
>  =09while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
> -=09=09char *buffer;
> -=09=09u64 addr;
> -=09=09u32 len;
> -
>  =09=09if (max_batch-- =3D=3D 0) {
>  =09=09=09err =3D -EAGAIN;
>  =09=09=09goto out;
>  =09=09}
> =20
> -=09=09len =3D desc.len;
> -=09=09skb =3D sock_alloc_send_skb(sk, hr + len + tr, 1, &err);
> -=09=09if (unlikely(!skb))
> +=09=09skb =3D xsk_build_skb(xs, &desc);
> +=09=09if (IS_ERR(skb)) {
> +=09=09=09err =3D PTR_ERR(skb);
>  =09=09=09goto out;
> +=09=09}
> =20
> -=09=09skb_reserve(skb, hr);
> -=09=09skb_put(skb, len);
> -
> -=09=09addr =3D desc.addr;
> -=09=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> -=09=09err =3D skb_store_bits(skb, 0, buffer, len);
>  =09=09/* This is the backpressure mechanism for the Tx path.
>  =09=09 * Reserve space in the completion queue and only proceed
>  =09=09 * if there is space in it. This avoids having to implement
>  =09=09 * any buffering in the Tx path.
>  =09=09 */
>  =09=09spin_lock_irqsave(&xs->pool->cq_lock, flags);
> -=09=09if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
> +=09=09if (xskq_prod_reserve(xs->pool->cq)) {
>  =09=09=09spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>  =09=09=09kfree_skb(skb);
>  =09=09=09goto out;
>  =09=09}
>  =09=09spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
> =20
> -=09=09skb->dev =3D xs->dev;
> -=09=09skb->priority =3D sk->sk_priority;
> -=09=09skb->mark =3D sk->sk_mark;
> -=09=09skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc.addr;
> -=09=09skb->destructor =3D xsk_destruct_skb;
> -
>  =09=09err =3D __dev_direct_xmit(skb, xs->queue_id);
>  =09=09if  (err =3D=3D NETDEV_TX_BUSY) {
>  =09=09=09/* Tell user-space to retry the send */
> --=20
> 2.30.1

Al

