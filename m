Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2A6D3BE7
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 04:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDCCrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 22:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjDCCrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 22:47:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04F283D7
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 19:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680490013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXT/6aJaAFqn+Kdcq/fX5XU9hNNDC+uvyYrVFSSigv8=;
        b=JUf8nfQ8gTXDiGtYiK8bZLQkN1DtZfiVAwJ9FGNH+3XFk/BZHvX9TER0OzX2gHaE8yH7d3
        hbk1tc02TDpOkXC2g1VUF3dzqYxaWIbJ3Qg1RQXoW/aA7Bb+9EjCgSxOVy+0JjiEu66Oym
        R+HOMNnHag0YxdyAOkgyPYnrUDSx4Qk=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-q3TDgWkhNXCX2iPtKvghug-1; Sun, 02 Apr 2023 22:46:51 -0400
X-MC-Unique: q3TDgWkhNXCX2iPtKvghug-1
Received: by mail-oi1-f198.google.com with SMTP id bd37-20020a056808222500b003894ce81c46so4978035oib.1
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 19:46:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680490011; x=1683082011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cXT/6aJaAFqn+Kdcq/fX5XU9hNNDC+uvyYrVFSSigv8=;
        b=G670TXhsxmubhRuDCx29uY3h+PfE4sGEqQd/FPyEA9tODlVC0mkz6o+6wfz/Cw1d/a
         b4r5Xoo2Kf2ba/1sTKRSIws+BKkwK0xcut84tc53HZApJcPZ/ERRDZopRMasUexT4sNZ
         Se3CyG5IIgZPXNylB+lLzEnOwtyvqU+QMqU/Ilv20C4l7MHi3fpbqjyB1VvNluLMjbjX
         EEEDLRkzV41R2sDabiKkedJjQ7LKHTlyUVLCfhk4h1crHO2tr3hPWD9WQu6Er2tmDEIw
         9er2wOT6b7mjDF1TXrXfhR/9ovqqEVtZ34lClzl31Kqx6EKi1E1YCUPHnnYl173mE3GM
         3ziw==
X-Gm-Message-State: AO0yUKUIczPYsTzQ1UhLW5ed9WAj7IqGaPKb7mOkUJTmarNhCgVD/uKR
        lRw9kg10a8y60tGJCt68iqaLUA7aIIU20gxDyXy5KZue7073DMN895fxKg1GwNeJIrad6jF7KUf
        8ee38o+NBT02XbnfJz/FBidlt7IZegKO7
X-Received: by 2002:a4a:a28a:0:b0:525:2b3b:7453 with SMTP id h10-20020a4aa28a000000b005252b3b7453mr10890508ool.0.1680490010932;
        Sun, 02 Apr 2023 19:46:50 -0700 (PDT)
X-Google-Smtp-Source: AK7set9dweL2R/ZOkTjHu4vsan6RXJ8ez4+ot09bhRJuDhHtHDmXSGAsQ+yY1sL/XLcZP8/opt6udhmUV8gRh09VAYo=
X-Received: by 2002:a4a:a28a:0:b0:525:2b3b:7453 with SMTP id
 h10-20020a4aa28a000000b005252b3b7453mr10890503ool.0.1680490010690; Sun, 02
 Apr 2023 19:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com> <20230328120412.110114-6-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230328120412.110114-6-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 3 Apr 2023 10:46:39 +0800
Message-ID: <CACGkMEurBLHds7Am=pBm9vTWvWczVfQoOJ_wCJWVBxuyHXzsfA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/8] virtio_net: separate the logic of freeing
 the rest mergeable buf
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
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 8:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> This patch introduce a new function that frees the rest mergeable buf.
> The subsequent patch will reuse this function.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 09aed60e2f51..a3f2bcb3db27 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1076,6 +1076,28 @@ static struct sk_buff *receive_big(struct net_devi=
ce *dev,
>         return NULL;
>  }
>
> +static void mergeable_buf_free(struct receive_queue *rq, int num_buf,
> +                              struct net_device *dev,
> +                              struct virtnet_rq_stats *stats)
> +{
> +       struct page *page;
> +       void *buf;
> +       int len;
> +
> +       while (num_buf-- > 1) {
> +               buf =3D virtqueue_get_buf(rq->vq, &len);
> +               if (unlikely(!buf)) {
> +                       pr_debug("%s: rx error: %d buffers missing\n",
> +                                dev->name, num_buf);
> +                       dev->stats.rx_length_errors++;
> +                       break;
> +               }
> +               stats->bytes +=3D len;
> +               page =3D virt_to_head_page(buf);
> +               put_page(page);
> +       }
> +}
> +
>  /* Why not use xdp_build_skb_from_frame() ?
>   * XDP core assumes that xdp frags are PAGE_SIZE in length, while in
>   * virtio-net there are 2 points that do not match its requirements:
> @@ -1436,18 +1458,8 @@ static struct sk_buff *receive_mergeable(struct ne=
t_device *dev,
>         stats->xdp_drops++;
>  err_skb:
>         put_page(page);
> -       while (num_buf-- > 1) {
> -               buf =3D virtqueue_get_buf(rq->vq, &len);
> -               if (unlikely(!buf)) {
> -                       pr_debug("%s: rx error: %d buffers missing\n",
> -                                dev->name, num_buf);
> -                       dev->stats.rx_length_errors++;
> -                       break;
> -               }
> -               stats->bytes +=3D len;
> -               page =3D virt_to_head_page(buf);
> -               put_page(page);
> -       }
> +       mergeable_buf_free(rq, num_buf, dev, stats);
> +
>  err_buf:
>         stats->drops++;
>         dev_kfree_skb(head_skb);
> --
> 2.32.0.3.g01195cf9f
>

