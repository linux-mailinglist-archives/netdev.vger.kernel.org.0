Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71156E8A00
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjDTGAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbjDTGA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:00:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B6E40EC
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681970377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jJO6o8p1uLnP+PL9naZIGS+3vByoAZC3zelc3c6/uys=;
        b=EkZoi4eX+5TLZmp6qpj3rzcgVlgW81nznmLn4JVTikitIoaJ1Mjr8fC96f4DQdQNmbYPay
        DTM7K0pKapodrlereQCefhd2AzE/LWz0MOvYaGE9ttmwLhDi58sAkquI01z0afrM5zG4E5
        d65xkEov3/vgjGFJQNfufZGVaCUuNtk=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-nWOqiIHJO--03-bduU6z_w-1; Thu, 20 Apr 2023 01:59:36 -0400
X-MC-Unique: nWOqiIHJO--03-bduU6z_w-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-38c0db69fdfso513679b6e.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 22:59:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681970375; x=1684562375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJO6o8p1uLnP+PL9naZIGS+3vByoAZC3zelc3c6/uys=;
        b=dcuajejvpbjKkYYqngg1NXG47ufvoS9EhrEgbFaTi/a/Uuw8Wq7eUs2yEBaljWrZyn
         ypP2swDkEWhFt2KRVKFljlf6nAHp3YVe7NiMcCNe15fjCq7sTE3oO0unZ8Q6iVVJGC9u
         dK+jEB1u30ZuGbHV2yL6ilsT2FK1hPwefHfFVRLragv2NG85KmXxG8FZ9VAPEqrIhW/n
         fAW+xgpsUMXjmSomI5MuMu9Cb62NIxnP2P07oQJ2+Xvb6S+yH1Cm9HBAUwKoh24lBtIA
         r2AdmxMZnbjO1bb64WP+u91LvB1abOcPDQXe06oHbmjQiQhAmYrM45hx8BZ4YwHemmtv
         PlhA==
X-Gm-Message-State: AAQBX9dXuJVdfmHaW8WCStDKJxow7tQKB1Q3plqHNFxqRKfOdy+3a7+3
        bEhz9IvO0AURAqDUhjdIGFfrpJjxIEjFjXgS4SsGauprYWi3c9pXYga718IAwSr321uyktn34dt
        rP3M5Xw+x43XT+YdnLePrPHkAV2+uy0tF
X-Received: by 2002:a05:6808:23c1:b0:38c:7a71:d4dc with SMTP id bq1-20020a05680823c100b0038c7a71d4dcmr345681oib.49.1681970375458;
        Wed, 19 Apr 2023 22:59:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350YR+AWrZej1E5DK17EztKPcV+suuUQOfxlBaCRYTnPCGouFTK6jYCC6PKskHyImj2SLu0jP7SlvCxUKixAe6QY=
X-Received: by 2002:a05:6808:23c1:b0:38c:7a71:d4dc with SMTP id
 bq1-20020a05680823c100b0038c7a71d4dcmr345673oib.49.1681970375231; Wed, 19 Apr
 2023 22:59:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-5-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-5-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 13:59:24 +0800
Message-ID: <CACGkMEv4hBD8qxdP9KUiBcFFxjv5dx8nS_NQGrznfd_2VOVBsg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 04/14] virtio_net: introduce
 virtnet_xdp_handler() to seprate the logic of run xdp
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
> At present, we have two similar logic to perform the XDP prog.
>
> Therefore, this PATCH separates the code of executing XDP, which is

Any reason for using upper case for "PATCH" ?


> conducive to later maintenance.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>  drivers/net/virtio_net.c | 118 +++++++++++++++++++--------------------
>  1 file changed, 58 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 50dc64d80d3b..0fa64c314ea7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -789,6 +789,60 @@ static int virtnet_xdp_xmit(struct net_device *dev,
>         return ret;
>  }
>
> +static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buf=
f *xdp,
> +                              struct net_device *dev,
> +                              unsigned int *xdp_xmit,
> +                              struct virtnet_rq_stats *stats)
> +{
> +       struct xdp_frame *xdpf;
> +       int err;
> +       u32 act;
> +
> +       act =3D bpf_prog_run_xdp(xdp_prog, xdp);
> +       stats->xdp_packets++;
> +
> +       switch (act) {
> +       case XDP_PASS:
> +               return act;
> +
> +       case XDP_TX:
> +               stats->xdp_tx++;
> +               xdpf =3D xdp_convert_buff_to_frame(xdp);
> +               if (unlikely(!xdpf)) {
> +                       netdev_dbg(dev, "convert buff to frame failed for=
 xdp\n");
> +                       return XDP_DROP;
> +               }
> +
> +               err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> +               if (unlikely(!err)) {
> +                       xdp_return_frame_rx_napi(xdpf);
> +               } else if (unlikely(err < 0)) {
> +                       trace_xdp_exception(dev, xdp_prog, act);
> +                       return XDP_DROP;
> +               }
> +               *xdp_xmit |=3D VIRTIO_XDP_TX;
> +               return act;
> +
> +       case XDP_REDIRECT:
> +               stats->xdp_redirects++;
> +               err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> +               if (err)
> +                       return XDP_DROP;
> +
> +               *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> +               return act;
> +
> +       default:
> +               bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> +               fallthrough;
> +       case XDP_ABORTED:
> +               trace_xdp_exception(dev, xdp_prog, act);
> +               fallthrough;
> +       case XDP_DROP:
> +               return XDP_DROP;
> +       }
> +}
> +
>  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>  {
>         return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
> @@ -876,7 +930,6 @@ static struct sk_buff *receive_small(struct net_devic=
e *dev,
>         struct page *page =3D virt_to_head_page(buf);
>         unsigned int delta =3D 0;
>         struct page *xdp_page;
> -       int err;
>         unsigned int metasize =3D 0;
>
>         len -=3D vi->hdr_len;
> @@ -898,7 +951,6 @@ static struct sk_buff *receive_small(struct net_devic=
e *dev,
>         xdp_prog =3D rcu_dereference(rq->xdp_prog);
>         if (xdp_prog) {
>                 struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_off=
set;
> -               struct xdp_frame *xdpf;
>                 struct xdp_buff xdp;
>                 void *orig_data;
>                 u32 act;
> @@ -931,8 +983,8 @@ static struct sk_buff *receive_small(struct net_devic=
e *dev,
>                 xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len=
,
>                                  xdp_headroom, len, true);
>                 orig_data =3D xdp.data;
> -               act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> -               stats->xdp_packets++;
> +
> +               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
>
>                 switch (act) {
>                 case XDP_PASS:
> @@ -942,35 +994,10 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>                         metasize =3D xdp.data - xdp.data_meta;
>                         break;
>                 case XDP_TX:
> -                       stats->xdp_tx++;
> -                       xdpf =3D xdp_convert_buff_to_frame(&xdp);
> -                       if (unlikely(!xdpf))
> -                               goto err_xdp;
> -                       err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> -                       if (unlikely(!err)) {
> -                               xdp_return_frame_rx_napi(xdpf);
> -                       } else if (unlikely(err < 0)) {
> -                               trace_xdp_exception(vi->dev, xdp_prog, ac=
t);
> -                               goto err_xdp;
> -                       }
> -                       *xdp_xmit |=3D VIRTIO_XDP_TX;
> -                       rcu_read_unlock();
> -                       goto xdp_xmit;
>                 case XDP_REDIRECT:
> -                       stats->xdp_redirects++;
> -                       err =3D xdp_do_redirect(dev, &xdp, xdp_prog);
> -                       if (err)
> -                               goto err_xdp;
> -                       *xdp_xmit |=3D VIRTIO_XDP_REDIR;
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 default:
> -                       bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, ac=
t);
> -                       fallthrough;
> -               case XDP_ABORTED:
> -                       trace_xdp_exception(vi->dev, xdp_prog, act);
> -                       goto err_xdp;
> -               case XDP_DROP:
>                         goto err_xdp;
>                 }
>         }
> @@ -1278,7 +1305,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         if (xdp_prog) {
>                 unsigned int xdp_frags_truesz =3D 0;
>                 struct skb_shared_info *shinfo;
> -               struct xdp_frame *xdpf;
>                 struct page *xdp_page;
>                 struct xdp_buff xdp;
>                 void *data;
> @@ -1295,8 +1321,7 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>                 if (unlikely(err))
>                         goto err_xdp_frags;
>
> -               act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> -               stats->xdp_packets++;
> +               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
>
>                 switch (act) {
>                 case XDP_PASS:
> @@ -1307,38 +1332,11 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>                         rcu_read_unlock();
>                         return head_skb;
>                 case XDP_TX:
> -                       stats->xdp_tx++;
> -                       xdpf =3D xdp_convert_buff_to_frame(&xdp);
> -                       if (unlikely(!xdpf)) {
> -                               netdev_dbg(dev, "convert buff to frame fa=
iled for xdp\n");
> -                               goto err_xdp_frags;
> -                       }
> -                       err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> -                       if (unlikely(!err)) {
> -                               xdp_return_frame_rx_napi(xdpf);
> -                       } else if (unlikely(err < 0)) {
> -                               trace_xdp_exception(vi->dev, xdp_prog, ac=
t);
> -                               goto err_xdp_frags;
> -                       }
> -                       *xdp_xmit |=3D VIRTIO_XDP_TX;
> -                       rcu_read_unlock();
> -                       goto xdp_xmit;
>                 case XDP_REDIRECT:
> -                       stats->xdp_redirects++;
> -                       err =3D xdp_do_redirect(dev, &xdp, xdp_prog);
> -                       if (err)
> -                               goto err_xdp_frags;
> -                       *xdp_xmit |=3D VIRTIO_XDP_REDIR;
>                         rcu_read_unlock();
>                         goto xdp_xmit;
>                 default:
> -                       bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, ac=
t);
> -                       fallthrough;
> -               case XDP_ABORTED:
> -                       trace_xdp_exception(vi->dev, xdp_prog, act);
> -                       fallthrough;
> -               case XDP_DROP:
> -                       goto err_xdp_frags;
> +                       break;
>                 }
>  err_xdp_frags:
>                 if (xdp_buff_has_frags(&xdp)) {
> --
> 2.32.0.3.g01195cf9f
>

