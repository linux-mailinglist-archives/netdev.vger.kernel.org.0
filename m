Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA5EF6E89FD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbjDTGAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjDTGA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9F740EE
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681970380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ndhf9eOC/JOd/pT3ZOdTc+tSLLDWf/wxwZPQj3/gbjo=;
        b=bL+TiD/5PXnWFZOoONYlnvJsZQF2XXRiFYsYXtt3dGJXJID3kkXZLRM8YZz5HIlm7q8t1h
        XPrKuuj2lt72Cru3s0KvItujVaMUArjUWUk0Btc7rFNIO6eZyVSxoeizFuPBcrX8iD0H5k
        kIB6k8B4UJb32x1BYllpTI6FXETd30A=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-BJ5aZBGtNQmh7gJr0KvBpQ-1; Thu, 20 Apr 2023 01:59:38 -0400
X-MC-Unique: BJ5aZBGtNQmh7gJr0KvBpQ-1
Received: by mail-oi1-f198.google.com with SMTP id j10-20020acab90a000000b0038c3c55cd6aso48854oif.3
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681970378; x=1684562378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ndhf9eOC/JOd/pT3ZOdTc+tSLLDWf/wxwZPQj3/gbjo=;
        b=TauWFciTKNCBx5hO0of9JdT1F8YowSJ/SmYKfurbXMIElZfxIZh9O+eqP/o4itqn0J
         yY2Mis7/PTu4wN/WTEQTHv6QxInpZZMr4x+ocgoh+i2dtYkzP7NmhlGivcTNOEF/OKl/
         48DUQNbiFoJCJidO0w/g3stMc5Jki2eRksl0JfDEzTkjRtR5ESHb8/K+qS+xRQth8G50
         DM/Jm51MoliXctaEWSVPt3gwTuUZQ3GkIxBA/mrThV1CGbizDTsEcxH20PnC/PnVhWlE
         Vp62BufO3L9QbVev8U7TQauI6ModYrKHCZGsKIF9JSz6entDwzQ/B+/pHLJN0Ydoppw3
         rlKQ==
X-Gm-Message-State: AAQBX9eLm3OGIx15LJcD/LFYLDZqdU2OTPDdOOrXJu8+10QghhcubqZl
        Z28tB2pfdNvI69Gp+fKBYEkawRM1IFFoekjdbpMLbtNTb86exyOrCA9753QGXoGlByzTU+7lLYC
        TneOK0ugk8/9xxfccO3hJ8iaLZLXNJiQu
X-Received: by 2002:a4a:4f86:0:b0:546:ecb3:f44 with SMTP id c128-20020a4a4f86000000b00546ecb30f44mr226272oob.0.1681970378218;
        Wed, 19 Apr 2023 22:59:38 -0700 (PDT)
X-Google-Smtp-Source: AKy350aje03xj8D7o4+ulKEMF2OYf7kcJ5DU7pwe6+zp6C3tuhYC9OCL7PeHFCOrUww+dg4QXgRfBp8kIJ0o5Dwzt6U=
X-Received: by 2002:a4a:4f86:0:b0:546:ecb3:f44 with SMTP id
 c128-20020a4a4f86000000b00546ecb30f44mr226258oob.0.1681970378017; Wed, 19 Apr
 2023 22:59:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 13:59:26 +0800
Message-ID: <CACGkMEuQ0pUixB1tKd8bthhndnFvdw9NEJn6xpX-JCovmu1dxg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 05/14] virtio_net: introduce xdp res enums
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 2:53=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> virtnet_xdp_handler() is to process all the logic related to XDP. The
> caller only needs to care about how to deal with the buf. So this commit
> introduces new enums:
>
> 1. VIRTNET_XDP_RES_PASS: make skb by the buf
> 2. VIRTNET_XDP_RES_DROP: xdp return drop action or some error, caller
>    should release the buf
> 3. VIRTNET_XDP_RES_CONSUMED: xdp consumed the buf, the caller doesnot to

Typo, should be "does not"

>    do anything
>

I think it's better if you could explain if this can help anything
(e.g simplify the patches on top?).

Thanks


> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0fa64c314ea7..4dfdc211d355 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -301,6 +301,15 @@ struct padded_vnet_hdr {
>         char padding[12];
>  };
>
> +enum {
> +       /* xdp pass */
> +       VIRTNET_XDP_RES_PASS,
> +       /* drop packet. the caller needs to release the page. */
> +       VIRTNET_XDP_RES_DROP,
> +       /* packet is consumed by xdp. the caller needs to do nothing. */
> +       VIRTNET_XDP_RES_CONSUMED,
> +};
> +
>  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
>  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
>
> @@ -803,14 +812,14 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
>
>         switch (act) {
>         case XDP_PASS:
> -               return act;
> +               return VIRTNET_XDP_RES_PASS;
>
>         case XDP_TX:
>                 stats->xdp_tx++;
>                 xdpf =3D xdp_convert_buff_to_frame(xdp);
>                 if (unlikely(!xdpf)) {
>                         netdev_dbg(dev, "convert buff to frame failed for=
 xdp\n");
> -                       return XDP_DROP;
> +                       return VIRTNET_XDP_RES_DROP;
>                 }
>
>                 err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> @@ -818,19 +827,20 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp=
_prog, struct xdp_buff *xdp,
>                         xdp_return_frame_rx_napi(xdpf);
>                 } else if (unlikely(err < 0)) {
>                         trace_xdp_exception(dev, xdp_prog, act);
> -                       return XDP_DROP;
> +                       return VIRTNET_XDP_RES_DROP;
>                 }
> +
>                 *xdp_xmit |=3D VIRTIO_XDP_TX;
> -               return act;
> +               return VIRTNET_XDP_RES_CONSUMED;
>
>         case XDP_REDIRECT:
>                 stats->xdp_redirects++;
>                 err =3D xdp_do_redirect(dev, xdp, xdp_prog);
>                 if (err)
> -                       return XDP_DROP;
> +                       return VIRTNET_XDP_RES_DROP;
>
>                 *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> -               return act;
> +               return VIRTNET_XDP_RES_CONSUMED;
>
>         default:
>                 bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> @@ -839,7 +849,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_p=
rog, struct xdp_buff *xdp,
>                 trace_xdp_exception(dev, xdp_prog, act);
>                 fallthrough;
>         case XDP_DROP:
> -               return XDP_DROP;
> +               return VIRTNET_XDP_RES_DROP;
>         }
>  }
>
> @@ -987,17 +997,18 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
>
>                 switch (act) {
> -               case XDP_PASS:
> +               case VIRTNET_XDP_RES_PASS:
>                         /* Recalculate length in case bpf program changed=
 it */
>                         delta =3D orig_data - xdp.data;
>                         len =3D xdp.data_end - xdp.data;
>                         metasize =3D xdp.data - xdp.data_meta;
>                         break;
> -               case XDP_TX:
> -               case XDP_REDIRECT:
> +
> +               case VIRTNET_XDP_RES_CONSUMED:
>                         rcu_read_unlock();
>                         goto xdp_xmit;
> -               default:
> +
> +               case VIRTNET_XDP_RES_DROP:
>                         goto err_xdp;
>                 }
>         }
> @@ -1324,18 +1335,19 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>                 act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
>
>                 switch (act) {
> -               case XDP_PASS:
> +               case VIRTNET_XDP_RES_PASS:
>                         head_skb =3D build_skb_from_xdp_buff(dev, vi, &xd=
p, xdp_frags_truesz);
>                         if (unlikely(!head_skb))
>                                 goto err_xdp_frags;
>
>                         rcu_read_unlock();
>                         return head_skb;
> -               case XDP_TX:
> -               case XDP_REDIRECT:
> +
> +               case VIRTNET_XDP_RES_CONSUMED:
>                         rcu_read_unlock();
>                         goto xdp_xmit;
> -               default:
> +
> +               case VIRTNET_XDP_RES_DROP:
>                         break;
>                 }
>  err_xdp_frags:
> --
> 2.32.0.3.g01195cf9f
>

