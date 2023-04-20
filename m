Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509EE6E8A0B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbjDTGCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjDTGCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:02:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AAB40DB
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681970505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lrr9mch7KfxogTYrVf9KA/GmagliQT/y0/Zyp+kIu6o=;
        b=Qmhm/gx06vIFGGKLDVC84RntsdKD/o28bB34ddwtwqJRiMhzhWvqnsmR7SWZRO+c1liNqZ
        bO6sdt7LWCNgKK/Lg8tI39jKPqqRkdo67iBRj5mqxQbHeaHsw7QCrfFM4RAhnQ899SWBdh
        Phrc21/8LPKpmgp0ZLjXINRuLMS/AuE=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-SdW9jfJPMyenk_syyt8V1w-1; Thu, 20 Apr 2023 02:01:44 -0400
X-MC-Unique: SdW9jfJPMyenk_syyt8V1w-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-54574069287so145122eaf.2
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681970503; x=1684562503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lrr9mch7KfxogTYrVf9KA/GmagliQT/y0/Zyp+kIu6o=;
        b=YFyOlbMSOcKenPfgytg6rngOuix/w4Wcvjqu5WSqxvGQpYJ0E1+AWwwXesEQFC9M4y
         nGR5zFpmVjTESRQmEy6F1ffMVv+Y8nphIdfrP2Lf/4gXjLcYzk/GpkAJAaPhqb4POgzE
         85bh5uBkwB+NgyfplyUto1S9dgTTqiZIFsjY70WZ9dQ38oScDB4oi3qW4rDtRiODwmX5
         mwMbPsnZpxcD69ugeiu2cugHwAwZsn6VxgnSTOOkX5zes5yIPXD12Ax0hHsUw9l4opvC
         8hD2yhijXsbRNemdAn91OVXKKUbrVZLHbbBfBfwx8j7+nnT5TdC+YWTWv6OjKDXZieIB
         yjHA==
X-Gm-Message-State: AAQBX9fyw/XrzjloKVU2GcL7qjTLFv2GkJrvHh5Q5N2SGctGoE9z/WWx
        ri10Z7GQrBfN14ABP8dzgIOsa843uQf1z7qD/h/ucQZpqSDZhTPj75GsiIC+XdpzKvEE1lf/Hih
        qJk7lTvLEAUeu5lImVVIIiwjKAFAbGf1f
X-Received: by 2002:a05:6870:7026:b0:188:53:a7bd with SMTP id u38-20020a056870702600b001880053a7bdmr338725oae.49.1681970503651;
        Wed, 19 Apr 2023 23:01:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350b6PZiipmQV9mNOyk6NSBCGwsiqG0tLD6/ZyhFxrrAWSm5AcpzGZJoe5CwDu+zEr1lo6tCWD9x6Vk14+gXDt3c=
X-Received: by 2002:a05:6870:7026:b0:188:53:a7bd with SMTP id
 u38-20020a056870702600b001880053a7bdmr338714oae.49.1681970503429; Wed, 19 Apr
 2023 23:01:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-10-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-10-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 14:01:32 +0800
Message-ID: <CACGkMEt0Z4LzfZp6PGV-6-a-+jLed=1fbhxmdaqxrU7C4qEYEA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 09/14] virtio_net: introduce receive_mergeable_xdp()
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> The purpose of this patch is to simplify the receive_mergeable().
> Separate all the logic of XDP into a function.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 100 ++++++++++++++++++++++++---------------
>  1 file changed, 61 insertions(+), 39 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 266c1670beda..42e9927e316b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1319,6 +1319,63 @@ static void *mergeable_xdp_prepare(struct virtnet_=
info *vi,
>         return page_address(*page) + VIRTIO_XDP_HEADROOM;
>  }
>
> +static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
> +                                            struct virtnet_info *vi,
> +                                            struct receive_queue *rq,
> +                                            struct bpf_prog *xdp_prog,
> +                                            void *buf,
> +                                            void *ctx,
> +                                            unsigned int len,
> +                                            unsigned int *xdp_xmit,
> +                                            struct virtnet_rq_stats *sta=
ts)
> +{
> +       struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf;
> +       int num_buf =3D virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> +       struct page *page =3D virt_to_head_page(buf);
> +       int offset =3D buf - page_address(page);
> +       unsigned int xdp_frags_truesz =3D 0;
> +       struct sk_buff *head_skb;
> +       unsigned int frame_sz;
> +       struct xdp_buff xdp;
> +       void *data;
> +       u32 act;
> +       int err;
> +
> +       data =3D mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, =
&num_buf, &page,
> +                                    offset, &len, hdr);
> +       if (unlikely(!data))
> +               goto err_xdp;
> +
> +       err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, =
frame_sz,
> +                                        &num_buf, &xdp_frags_truesz, sta=
ts);
> +       if (unlikely(err))
> +               goto err_xdp;
> +
> +       act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats)=
;
> +
> +       switch (act) {
> +       case VIRTNET_XDP_RES_PASS:
> +               head_skb =3D build_skb_from_xdp_buff(dev, vi, &xdp, xdp_f=
rags_truesz);
> +               if (unlikely(!head_skb))
> +                       goto err_xdp;
> +               return head_skb;
> +
> +       case VIRTNET_XDP_RES_CONSUMED:
> +               return NULL;
> +
> +       case VIRTNET_XDP_RES_DROP:
> +               break;
> +       }
> +
> +err_xdp:
> +       put_page(page);
> +       mergeable_buf_free(rq, num_buf, dev, stats);
> +
> +       stats->xdp_drops++;
> +       stats->drops++;
> +       return NULL;
> +}
> +
>  static struct sk_buff *receive_mergeable(struct net_device *dev,
>                                          struct virtnet_info *vi,
>                                          struct receive_queue *rq,
> @@ -1338,8 +1395,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
>         unsigned int tailroom =3D headroom ? sizeof(struct skb_shared_inf=
o) : 0;
>         unsigned int room =3D SKB_DATA_ALIGN(headroom + tailroom);
> -       unsigned int frame_sz;
> -       int err;
>
>         head_skb =3D NULL;
>         stats->bytes +=3D len - vi->hdr_len;
> @@ -1359,39 +1414,10 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>         rcu_read_lock();
>         xdp_prog =3D rcu_dereference(rq->xdp_prog);
>         if (xdp_prog) {
> -               unsigned int xdp_frags_truesz =3D 0;
> -               struct xdp_buff xdp;
> -               void *data;
> -               u32 act;
> -
> -               data =3D mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &fr=
ame_sz,
> -                                            &num_buf, &page, offset, &le=
n, hdr);
> -               if (unlikely(!data))
> -                       goto err_xdp;
> -
> -               err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, dat=
a, len, frame_sz,
> -                                                &num_buf, &xdp_frags_tru=
esz, stats);
> -               if (unlikely(err))
> -                       goto err_xdp;
> -
> -               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
> -
> -               switch (act) {
> -               case VIRTNET_XDP_RES_PASS:
> -                       head_skb =3D build_skb_from_xdp_buff(dev, vi, &xd=
p, xdp_frags_truesz);
> -                       if (unlikely(!head_skb))
> -                               goto err_xdp;
> -
> -                       rcu_read_unlock();
> -                       return head_skb;
> -
> -               case VIRTNET_XDP_RES_CONSUMED:
> -                       rcu_read_unlock();
> -                       goto xdp_xmit;
> -
> -               case VIRTNET_XDP_RES_DROP:
> -                       goto err_xdp;
> -               }
> +               head_skb =3D receive_mergeable_xdp(dev, vi, rq, xdp_prog,=
 buf, ctx,
> +                                                len, xdp_xmit, stats);
> +               rcu_read_unlock();
> +               return head_skb;
>         }
>         rcu_read_unlock();
>
> @@ -1461,9 +1487,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         ewma_pkt_len_add(&rq->mrg_avg_pkt_len, head_skb->len);
>         return head_skb;
>
> -err_xdp:
> -       rcu_read_unlock();
> -       stats->xdp_drops++;
>  err_skb:
>         put_page(page);
>         mergeable_buf_free(rq, num_buf, dev, stats);
> @@ -1471,7 +1494,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>  err_buf:
>         stats->drops++;
>         dev_kfree_skb(head_skb);
> -xdp_xmit:
>         return NULL;
>  }
>
> --
> 2.32.0.3.g01195cf9f
>

