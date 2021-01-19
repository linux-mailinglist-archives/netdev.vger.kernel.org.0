Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4136F2FBABA
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbhASPFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:05:22 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:56469 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389227AbhASOoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 09:44:24 -0500
Date:   Tue, 19 Jan 2021 14:43:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611067412; bh=hJU3t7jpshkUt0/KD2VNuTu6lnWUQ57cTz2pVJlktr8=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=mmLUNun8OGpBm2R1gKPlGEENYpsNtND6YHumIdxf8Pf+X7Yjvv8PWzUXE9pS0Uu88
         3kUJ9m1SK64g8zYQarxsP1j5mUswWl2qH8/RoBcpjaw7gb71I3G0d0FbLIyjanseiZ
         TmA4ky5lrUeLEdP8DBm4BlPZLn4Ul87F8ETSFdtZlEbSM+EyHk0Unj3oRRWcXNpWAR
         mWhztHtIX9KnuLx+VPMVMjt90ro0egINtFD1xV4LK9ovzISPQcgYa+fdahu2niG5Q1
         Ngfskb1u+uVDM2PXxi9Ymh4RHrWTMBgHpkDocgac6NRc5rH53/YFjRklSZpVCRwECy
         q0x2iENCQQfSw==
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, bjorn.topel@intel.com,
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
Subject: Re: [PATCH bpf-next v2 3/3] xsk: build skb by page
Message-ID: <20210119144253.5321-1-alobakin@pm.me>
In-Reply-To: <017fdff4e061a7e0e779b7bc96ed3b45e07aa006.1611048724.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611048724.git.xuanzhuo@linux.alibaba.com> <017fdff4e061a7e0e779b7bc96ed3b45e07aa006.1611048724.git.xuanzhuo@linux.alibaba.com>
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
Date: Tue, 19 Jan 2021 17:45:12 +0800

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
> ---
>  net/xdp/xsk.c | 112 ++++++++++++++++++++++++++++++++++++++++++++++++----=
------
>  1 file changed, 94 insertions(+), 18 deletions(-)
>=20
> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> index 8037b04..8c291f8 100644
> --- a/net/xdp/xsk.c
> +++ b/net/xdp/xsk.c
> @@ -430,6 +430,95 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>  =09sock_wfree(skb);
>  }
> =20
> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
> +=09=09=09=09=09      struct xdp_desc *desc)
> +{
> +=09u32 len, offset, copy, copied;
> +=09struct sk_buff *skb;
> +=09struct page *page;
> +=09char *buffer;
> +=09int err =3D 0, i;
> +=09u64 addr;
> +
> +=09skb =3D sock_alloc_send_skb(&xs->sk, 0, 1, &err);
> +=09if (unlikely(!skb))
> +=09=09return NULL;

You can propagate err from here to the outer function:

=09if (unlikely(!skb))
=09=09return ERR_PTR(err);

> +=09addr =3D desc->addr;
> +=09len =3D desc->len;
> +
> +=09buffer =3D xsk_buff_raw_get_data(xs->pool, addr);
> +=09offset =3D offset_in_page(buffer);
> +=09addr =3D buffer - (char *)xs->pool->addrs;
> +
> +=09for (copied =3D 0, i =3D 0; copied < len; ++i) {

i++ would be less confusing here. You build skb frags from frag 0
anyway.

> +=09=09page =3D xs->pool->umem->pgs[addr >> PAGE_SHIFT];
> +
> +=09=09get_page(page);
> +
> +=09=09copy =3D min((u32)(PAGE_SIZE - offset), len - copied);

It's better to use min_t(u32, ...) instead of manual casting.

> +
> +=09=09skb_fill_page_desc(skb, i, page, offset, copy);
> +
> +=09=09copied +=3D copy;
> +=09=09addr +=3D copy;
> +=09=09offset =3D 0;
> +=09}
> +
> +=09skb->len +=3D len;
> +=09skb->data_len +=3D len;
> +=09skb->truesize +=3D len;
> +
> +=09refcount_add(len, &xs->sk.sk_wmem_alloc);
> +
> +=09return skb;
> +}
> +
> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
> +=09=09=09=09     struct xdp_desc *desc)
> +{
> +=09struct sk_buff *skb =3D NULL;
> +=09int err =3D -ENOMEM;
> +
> +=09if (xs->dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
> +=09=09skb =3D xsk_build_skb_zerocopy(xs, desc);
> +=09=09if (unlikely(!skb))
> +=09=09=09goto err;

1. You should'n use goto err here, as skb =3D=3D NULL, so kfree_skb(skb)
   is redundant.
2. If you would use ERR_PTR() in xsk_build_skb_zerocopy(),
   the condition should look like:

=09=09if (IS_ERR(skb))
=09=09=09return PTR_ERR(skb);

> +=09} else {
> +=09=09char *buffer;
> +=09=09u64 addr;
> +=09=09u32 len;
> +=09=09int err;
> +
> +=09=09len =3D desc->len;
> +=09=09skb =3D sock_alloc_send_skb(&xs->sk, len, 1, &err);
> +=09=09if (unlikely(!skb))
> +=09=09=09goto err;

Same here, if skb =3D=3D NULL, just return without calling kfree_skb().

> +=09=09skb_put(skb, len);
> +=09=09addr =3D desc->addr;
> +=09=09buffer =3D xsk_buff_raw_get_data(xs->pool, desc->addr);
> +=09=09err =3D skb_store_bits(skb, 0, buffer, len);
> +
> +=09=09if (unlikely(err)) {
> +=09=09=09err =3D -EINVAL;

You already have errno in err, no need to override it.

> +=09=09=09goto err;
> +=09=09}
> +=09}
> +
> +=09skb->dev =3D xs->dev;
> +=09skb->priority =3D xs->sk.sk_priority;
> +=09skb->mark =3D xs->sk.sk_mark;
> +=09skb_shinfo(skb)->destructor_arg =3D (void *)(long)desc->addr;
> +=09skb->destructor =3D xsk_destruct_skb;
> +
> +=09return skb;
> +
> +err:
> +=09kfree_skb(skb);
> +=09return ERR_PTR(err);
> +}
> +
>  static int xsk_generic_xmit(struct sock *sk)
>  {
>  =09struct xdp_sock *xs =3D xdp_sk(sk);
> @@ -446,43 +535,30 @@ static int xsk_generic_xmit(struct sock *sk)
>  =09=09goto out;
> =20
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
> -=09=09skb =3D sock_alloc_send_skb(sk, len, 1, &err);
> -=09=09if (unlikely(!skb))
> +=09=09skb =3D xsk_build_skb(xs, &desc);
> +=09=09if (IS_ERR(skb)) {
> +=09=09=09err =3D PTR_ERR(skb);
>  =09=09=09goto out;
> +=09=09}
> =20
> -=09=09skb_put(skb, len);
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

So please recheck the code and then retest it, especially error
paths (you can inject errors manually here to ensure they work).

Thanks,
Al

