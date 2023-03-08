Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228E86AFE42
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCHFVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCHFV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:21:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8929E064
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678252846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wa4+P9X3U2iWquKABTxg91kwsSVZQMAhZf+vdvnCUmk=;
        b=YQCUM6z6FD+oOVoALYvqDVXWLnoiB+ZOvXCpTF3QM29dqAfmgefJ5DXYwk43lO4eyXSDBU
        Qa+0GUbabdJaetaFE1bEbKkiPBeGhYpgabGviyxQZ83y2AiuWXw70rlmPV78J7SIN9TGoa
        epbPmZCUqZqSAE9sPOIZbWJfzWxFVWc=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-7AcDx1auNa-JmGPf2b_x7w-1; Wed, 08 Mar 2023 00:20:44 -0500
X-MC-Unique: 7AcDx1auNa-JmGPf2b_x7w-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-176c16fa9b7so5131779fac.13
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 21:20:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678252844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wa4+P9X3U2iWquKABTxg91kwsSVZQMAhZf+vdvnCUmk=;
        b=u1hH/CwTkIIQoYaubqxvPRBxqGxYkqxG8RnlZlEBufpYXcB35dYNo1Z47s5xvIdPP6
         rkNdUFZlk5PqCpNjwoc0XG86zvoh+Gbg45gRtnUe2mQvDxwO4fWUmFua/hPQy1KB7a3+
         nTIcQ0THa9rguSzQ7YYcPkqBMtkIsiXFBTIChMjz37dYd7CUmJul474A8EyLx8x3Q8HV
         uFBb7aYy95AFdvaxKzMMYJz9LI+EMAruzqQAbQLbRfPr+tieZ1a6pHfXqjEBiEbmu48G
         tG8I53+O0PoXpAW3IJQ0XPWO3Tjjgxuv96+uBL1o48UCXJPQCKd13t+Uv25coZacKxPa
         NAsw==
X-Gm-Message-State: AO0yUKWXhiIfOOtyyloDZbxMAMWvY3fHwZiKkUQbtjjVTWuT5TCmzmql
        DGKpx1oOwqB2xEj+f1b9Rp+cG24f+xsKMksonP0eAvNDFc73aAQCY9ohbcf6SYed+pt39LTD0an
        OpmKWbNq2IPAV9cKtYveXL1je3jkZaesp
X-Received: by 2002:a05:6808:1d5:b0:384:c4a:1b49 with SMTP id x21-20020a05680801d500b003840c4a1b49mr5072635oic.9.1678252844126;
        Tue, 07 Mar 2023 21:20:44 -0800 (PST)
X-Google-Smtp-Source: AK7set/OLYMsO2LNrrSBawUARTPqeRe7hILOydRzI5q0j+Df/L45Q8nqe9tX40F1cAWlz5w5JcJrobFOqZABZHRdRqs=
X-Received: by 2002:a05:6808:1d5:b0:384:c4a:1b49 with SMTP id
 x21-20020a05680801d500b003840c4a1b49mr5072619oic.9.1678252843934; Tue, 07 Mar
 2023 21:20:43 -0800 (PST)
MIME-Version: 1.0
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com> <20230308024935.91686-3-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230308024935.91686-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Mar 2023 13:20:32 +0800
Message-ID: <CACGkMEvePWxKR2=mkYLG5-22HD9WtM8Ew4z4pQtw1p-Ri6miQw@mail.gmail.com>
Subject: Re: [PATCH net, stable v1 2/3] virtio_net: separate the logic of
 checking whether sq is full
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Yichun Zhang <yichun@openresty.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 10:49=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Separate the logic of checking whether sq is full. The subsequent patch
> will reuse this func.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 60 ++++++++++++++++++++++++----------------
>  1 file changed, 36 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8b31a04052f2..46bbddaadb0d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -591,6 +591,41 @@ static bool is_xdp_raw_buffer_queue(struct virtnet_i=
nfo *vi, int q)
>                 return false;
>  }
>
> +static void check_sq_full_and_disable(struct virtnet_info *vi,
> +                                     struct net_device *dev,
> +                                     struct send_queue *sq)
> +{
> +       bool use_napi =3D sq->napi.weight;
> +       int qnum;
> +
> +       qnum =3D sq - vi->sq;
> +
> +       /* If running out of space, stop queue to avoid getting packets t=
hat we
> +        * are then unable to transmit.
> +        * An alternative would be to force queuing layer to requeue the =
skb by
> +        * returning NETDEV_TX_BUSY. However, NETDEV_TX_BUSY should not b=
e
> +        * returned in a normal path of operation: it means that driver i=
s not
> +        * maintaining the TX queue stop/start state properly, and causes
> +        * the stack to do a non-trivial amount of useless work.
> +        * Since most packets only take 1 or 2 ring slots, stopping the q=
ueue
> +        * early means 16 slots are typically wasted.
> +        */
> +       if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> +               netif_stop_subqueue(dev, qnum);
> +               if (use_napi) {
> +                       if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)=
))
> +                               virtqueue_napi_schedule(&sq->napi, sq->vq=
);
> +               } else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))=
) {
> +                       /* More just got used, free them then recheck. */
> +                       free_old_xmit_skbs(sq, false);
> +                       if (sq->vq->num_free >=3D 2+MAX_SKB_FRAGS) {
> +                               netif_start_subqueue(dev, qnum);
> +                               virtqueue_disable_cb(sq->vq);
> +                       }
> +               }
> +       }
> +}
> +
>  static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>                                    struct send_queue *sq,
>                                    struct xdp_frame *xdpf)
> @@ -1989,30 +2024,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb,=
 struct net_device *dev)
>                 nf_reset_ct(skb);
>         }
>
> -       /* If running out of space, stop queue to avoid getting packets t=
hat we
> -        * are then unable to transmit.
> -        * An alternative would be to force queuing layer to requeue the =
skb by
> -        * returning NETDEV_TX_BUSY. However, NETDEV_TX_BUSY should not b=
e
> -        * returned in a normal path of operation: it means that driver i=
s not
> -        * maintaining the TX queue stop/start state properly, and causes
> -        * the stack to do a non-trivial amount of useless work.
> -        * Since most packets only take 1 or 2 ring slots, stopping the q=
ueue
> -        * early means 16 slots are typically wasted.
> -        */
> -       if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
> -               netif_stop_subqueue(dev, qnum);
> -               if (use_napi) {
> -                       if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)=
))
> -                               virtqueue_napi_schedule(&sq->napi, sq->vq=
);
> -               } else if (unlikely(!virtqueue_enable_cb_delayed(sq->vq))=
) {
> -                       /* More just got used, free them then recheck. */
> -                       free_old_xmit_skbs(sq, false);
> -                       if (sq->vq->num_free >=3D 2+MAX_SKB_FRAGS) {
> -                               netif_start_subqueue(dev, qnum);
> -                               virtqueue_disable_cb(sq->vq);
> -                       }
> -               }
> -       }
> +       check_sq_full_and_disable(vi, dev, sq);
>
>         if (kick || netif_xmit_stopped(txq)) {
>                 if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq=
->vq)) {
> --
> 2.32.0.3.g01195cf9f
>

