Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370176E1BD5
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDNFlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjDNFle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162BE2D55
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681450847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36R8yA5JwrX0XhwM8RvPweATRjX3s/5NTOfHCOBnG08=;
        b=A99CjgY6KZ81xDou8SF6ub5X8pEpGlhkSgXY8Rx20C/ji+KIDY4elj3XYVUDwEJuzHUHKo
        pDs8zdx1qHdRE43Y2vzgc1eqiIFpcK7n2v6EGyo6V2GXFlgF2oPAQg+97A8HUD8HxSEESN
        kGEKsarWf+EFrccFpvttOrDHLY8i9K0=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-sqQiwrpNPMmHdZmh8sPL5g-1; Fri, 14 Apr 2023 01:40:44 -0400
X-MC-Unique: sqQiwrpNPMmHdZmh8sPL5g-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1843667dbbbso8737278fac.20
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 22:40:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681450844; x=1684042844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=36R8yA5JwrX0XhwM8RvPweATRjX3s/5NTOfHCOBnG08=;
        b=X0WgtmhFswJQ2uil5mRlWbil5EKo0qltRwSACQOI3B4E8nJrW/rOgzcRtWTvqMul07
         P5O6ZreoMZPgNfUaEshYDPHY9BeNOhiTo12tQfKfdGX1sZJ+gm6hgQ1VhJsJ0xbk1/3P
         e2+Tq561FV0rCZHu6Jan0pg1D5b4wUScXNNmbqpFWAKGXvQCD+zXzF3NIwTFXkIJNykT
         qDqmH9MtnzC/MHV610GWD+3UnPjA8yivMaxfdsqGTKCqJ56W1JP+McTJmLKl/GHx6YwI
         XlQ5hKSnt+/1lwNC4mdiveSDzVcTCm4DNzUKrz4B38x+YdCx7QVzAyoWHtGEX9z3v1BK
         BnQw==
X-Gm-Message-State: AAQBX9fXtn16zRLrbkGOcy5CEXmsYqIXSlSG27P39ErItLOwfZjkMyA8
        u/PcMgKI/VkdLgxTnNpYzT0nn1DRy0jAbpE1zLIvxokaAEaoNkmVTVolz53C/TfMyHSLpkc2njN
        +aQaIlqS4cjIxM1xgbq1eTNTcfAYmG6gN
X-Received: by 2002:a05:6870:5627:b0:17d:1287:1b5c with SMTP id m39-20020a056870562700b0017d12871b5cmr2524965oao.9.1681450843888;
        Thu, 13 Apr 2023 22:40:43 -0700 (PDT)
X-Google-Smtp-Source: AKy350YUPuw9qHFJb/CWKg4l7nwBYVM6AmHM+j+mUdqLLHmDT2abxvGjtVUB/vr6+CVJxJ2HGXu46UgbDiYuS5Oy9R4=
X-Received: by 2002:a05:6870:5627:b0:17d:1287:1b5c with SMTP id
 m39-20020a056870562700b0017d12871b5cmr2524956oao.9.1681450843735; Thu, 13 Apr
 2023 22:40:43 -0700 (PDT)
MIME-Version: 1.0
References: <20230413121937.46135-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230413121937.46135-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 14 Apr 2023 13:40:32 +0800
Message-ID: <CACGkMEsE8TosCxyf4GwmsBzo1Ot9FiLtsWt16oz0f0J99DGYCg@mail.gmail.com>
Subject: Re: [PATCH net] virtio_net: bugfix overflow inside xdp_linearize_page()
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
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 8:19=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> Here we copy the data from the original buf to the new page. But we
> not check that it may be overflow.
>
> As long as the size received(including vnethdr) is greater than 3840
> (PAGE_SIZE -VIRTIO_XDP_HEADROOM). Then the memcpy will overflow.
>
> And this is completely possible, as long as the MTU is large, such
> as 4096. In our test environment, this will cause crash. Since crash is
> caused by the written memory, it is meaningless, so I do not include it.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Missing fixes tag?

Other than this,

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2396c28c0122..ea1bd4bb326d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -814,8 +814,13 @@ static struct page *xdp_linearize_page(struct receiv=
e_queue *rq,
>                                        int page_off,
>                                        unsigned int *len)
>  {
> -       struct page *page =3D alloc_page(GFP_ATOMIC);
> +       int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +       struct page *page;
> +
> +       if (page_off + *len + tailroom > PAGE_SIZE)
> +               return NULL;
>
> +       page =3D alloc_page(GFP_ATOMIC);
>         if (!page)
>                 return NULL;
>
> @@ -823,7 +828,6 @@ static struct page *xdp_linearize_page(struct receive=
_queue *rq,
>         page_off +=3D *len;
>
>         while (--*num_buf) {
> -               int tailroom =3D SKB_DATA_ALIGN(sizeof(struct skb_shared_=
info));
>                 unsigned int buflen;
>                 void *buf;
>                 int off;
> --
> 2.32.0.3.g01195cf9f
>

