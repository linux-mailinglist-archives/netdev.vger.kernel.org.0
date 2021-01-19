Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DBF2FC420
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbhASWw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:52:26 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:20803 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404542AbhASO3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 09:29:12 -0500
Date:   Tue, 19 Jan 2021 14:28:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611066490; bh=P38fjPaG9QBqq7nL2IRGN42Iu3wjac94WoOry2utDBM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=l4Fa1mHECkAkZZ0CFgdT9ywe7ofoL8nHeM9iskoqqPZ5ExFH9EmeinzW+88MIKxmg
         QaYWlfh4BzZ6rsu/yWFvb10+edslILEVr+ODllqSg5M7IDAymCQ0Vs57yjsOTiv0jQ
         RdnX2Zy0jou5bIuvA0FVhrerWj2PtThf4JXqrfQ+a9/s+4IMTxAw8zfCuqvTGCirlu
         CczPZN7ypX8c2o59Sfl85zFF8LgfaX96tkKOOz9Yj8CPy5G1VVnRxWYpeYj3/6GKg0
         j/Xj320IBrlemkSrNwJgeCT1symzDwFDnBodkVJHmy+FJ3ba0PmozfsPAJJuFWWPgm
         zwPLUZCtiGB0w==
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
Subject: Re: [PATCH bpf-next v2 2/3] virtio-net: support IFF_TX_SKB_NO_LINEAR
Message-ID: <20210119142726.4970-1-alobakin@pm.me>
In-Reply-To: <21d2f709140470eb143e3c6c69e2a5dbd20bf2e7.1611048724.git.xuanzhuo@linux.alibaba.com>
References: <cover.1611048724.git.xuanzhuo@linux.alibaba.com> <21d2f709140470eb143e3c6c69e2a5dbd20bf2e7.1611048724.git.xuanzhuo@linux.alibaba.com>
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
Date: Tue, 19 Jan 2021 17:45:11 +0800

> Virtio net supports the case where the skb linear space is empty, so add
> priv_flags.
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba8e637..80d637f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2972,7 +2972,8 @@ static int virtnet_probe(struct virtio_device *vdev=
)
>  =09=09return -ENOMEM;
> =20
>  =09/* Set up network device as normal. */
> -=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
> +=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
> +=09=09IFF_TX_SKB_NO_LINEAR;

Please align IFF_TX_SKB_NO_LINEAR to IFF_UNICAST_FLT:

=09dev->priv_flags |=3D IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
=09=09=09   IFF_TX_SKB_NO_LINEAR;

>  =09dev->netdev_ops =3D &virtnet_netdev;
>  =09dev->features =3D NETIF_F_HIGHDMA;

Also, the series you sent is showed up incorrectly on lore.kernel.org
and patchwork.kernel.org. Seems like you used different To and Cc for
its parts.
Please use scripts/get_maintainer.pl to the whole series:

scripts/get_maintainer.pl ../patch-build-skb-by-page/*

And use one list of addresses for every message, so they wouldn't
lost.

Al

