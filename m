Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523396AFE43
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCHFV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjCHFVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:21:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF611A0B1D
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678252863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+mi5gjnaOx380nBD5pAWR2mHshCrXnFR/oJxmDZn5Y=;
        b=Q1FajQGgcE/N4hLYjuJfK/VsFxGfK721at157Cb5FnIZxuzM9JaUlJc/+ERfk5Ki3SCJHZ
        J0cRyx9KreuToPy5p7iGpJk7rUPVJE+ATryalLYhNwOV7W4CGqT5o18We1S415ztJ70rWg
        hwIwKT99YKIKphKtoO2rGWuwcbN4Qw0=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-VSgoXgkLOP-db3QWSGpHsA-1; Wed, 08 Mar 2023 00:21:01 -0500
X-MC-Unique: VSgoXgkLOP-db3QWSGpHsA-1
Received: by mail-oo1-f69.google.com with SMTP id y140-20020a4a4592000000b0052540059057so4748616ooa.6
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 21:21:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678252861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+mi5gjnaOx380nBD5pAWR2mHshCrXnFR/oJxmDZn5Y=;
        b=rABQCvu89JNden9hBj7vIgyHS72VxRYJcNY+TW+qbjsDPzKTv4Eol1WtQFZoK5Kizl
         DC4SEdKt1m2gdNB2zhz4NYeS/iwz5xHzXbkZV+tWjcPxUxm96p88jNLcUQWKL3FYvlc2
         kR+bRWZ/bkBj/qXW4zz0AtfN2ZQqk53GWwg90PsJpfiscUiZFylLpsAeDH+uV2xmE83H
         y0NRB96tPK8Rd2/Q5+QBjUVPYw5vQgotTM6o3maLpADm0ZL/1AWLT11W/rYsqTgMoGJ/
         LidaaFb2e2l280GGqQ7LxVt6G4TuK2FgXkZWEIX9oU3HKT1/6tuxXtrUsThjVNF8sbvD
         6rCw==
X-Gm-Message-State: AO0yUKXSMuN7wQSBNtFKvoROEqjzCzJp1zx4FyVESPhn0/XKtlqvfW7H
        QcVjCqHOh19q5ok7oqYtlDim3kAzvLWLE24gjRI8EYk2aSyItdtTYtG6i63V5Y2eVpZBcg8krCt
        Zh0dScsPJQrAcTmBef4nqNWW/ZZR9WIut
X-Received: by 2002:a9d:5a90:0:b0:688:cf52:6e18 with SMTP id w16-20020a9d5a90000000b00688cf526e18mr5498251oth.4.1678252861169;
        Tue, 07 Mar 2023 21:21:01 -0800 (PST)
X-Google-Smtp-Source: AK7set8+m4PTMmjIE+rf6dEvf0HBVhV7J24buqH/dteNerinfhfp5VGK8zWTLp7xrUsFRbU+ugPmNGh8B3pZ5QN97uo=
X-Received: by 2002:a9d:5a90:0:b0:688:cf52:6e18 with SMTP id
 w16-20020a9d5a90000000b00688cf526e18mr5498248oth.4.1678252860960; Tue, 07 Mar
 2023 21:21:00 -0800 (PST)
MIME-Version: 1.0
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com> <20230308024935.91686-4-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230308024935.91686-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 8 Mar 2023 13:20:50 +0800
Message-ID: <CACGkMEv9u5mnO8y5-q6etLecODfwfbr=-MoA5VVNc4CyvnUiuQ@mail.gmail.com>
Subject: Re: [PATCH net, stable v1 3/3] virtio_net: add checking sq is full
 inside xdp xmit
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
> If the queue of xdp xmit is not an independent queue, then when the xdp
> xmit used all the desc, the xmit from the __dev_queue_xmit() may encounte=
r
> the following error.
>
> net ens4: Unexpected TXQ (0) queue failure: -28
>
> This patch adds a check whether sq is full in xdp xmit.
>
> Fixes: 56434a01b12e ("virtio_net: add XDP_TX support")
> Reported-by: Yichun Zhang <yichun@openresty.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

> ---
>  drivers/net/virtio_net.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 46bbddaadb0d..1a309cfb4976 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -767,6 +767,9 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>         }
>         ret =3D nxmit;
>
> +       if (!is_xdp_raw_buffer_queue(vi, sq - vi->sq))
> +               check_sq_full_and_disable(vi, dev, sq);
> +
>         if (flags & XDP_XMIT_FLUSH) {
>                 if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq=
->vq))
>                         kicks =3D 1;
> --
> 2.32.0.3.g01195cf9f
>

