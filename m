Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175F36D3BE0
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 04:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDCCoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 22:44:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbjDCCoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 22:44:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E515883D7
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 19:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680489796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ObOA2IqLb9j+Mujo/CSxkURBSJ0JqojZZVbdbdnq1t0=;
        b=eKj3Lul7SMBY0ZKbGgFhPgomMDkdqpixXJM5Dve6TYY5xkWs39UDyiTfux5vLqq44kBth3
        EXD7XfICY/BxreTEA3SbxAnwt2GNqYrZKYzN5qL9cBHmf61YIW7jWDzw+EAOVOvvwCyLq3
        kxC3Q49TM8xP1T94zv/CCBnpWdsbTU4=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-HArv4dXfNDqzIXLYxZXMkg-1; Sun, 02 Apr 2023 22:43:15 -0400
X-MC-Unique: HArv4dXfNDqzIXLYxZXMkg-1
Received: by mail-oi1-f198.google.com with SMTP id i128-20020acaea86000000b003893eb09687so5358988oih.20
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 19:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680489794; x=1683081794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ObOA2IqLb9j+Mujo/CSxkURBSJ0JqojZZVbdbdnq1t0=;
        b=0iRjJ2tVjMhpa9JJrYfISJyloORIz0hzfzMOj1H3Pb1obufsALmO6Ttkx2zyQ1puFU
         nZrxSNGl7RGt2BJr8q0a9bW5ZW/xO1aAMAY2c/ZoUwn3BPiI2yIxoiX53M0U/bP5VkWo
         AX6teTm8fGzjhoKCcP2l+5fm1n/iqCuWvdKMdHGIVMuDdDBErbK7ZMiSm3DXRC/JDOsv
         0wLOdRaCYsPk8Kl5rUsYN1/P8p1v6+5x3BdNEJf8wkUmL4xVHgVSzVyIcBrEGP3DlJHJ
         97aXwzHVhmednj2QJ/mx1lT0+7yETFW8SaCzMaoDxa5s+dxMMCdNioatEtPBpv+AmDvj
         CMZw==
X-Gm-Message-State: AAQBX9daWAaWDoKczLU8pfvqVMDkiRkbU7MV1tuqfWIyK+WvHaa01q5t
        96eEt8aTa/Qvb2X6l/F0USjYEIzDcJEJZS4oq8NJDxWaGGINyMuyEsMfY+fAjZi5NrPNfhGmrd+
        dEVKobhdXU38ZlNYZUSMrI987UQNqaDNL
X-Received: by 2002:a05:6871:4d03:b0:17d:1287:1b5c with SMTP id ug3-20020a0568714d0300b0017d12871b5cmr12083452oab.9.1680489794350;
        Sun, 02 Apr 2023 19:43:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350YyqOuhzFPNwcu77fb5PUarx9Z0Lg/BpGgyKARpuEIuxBuELKlbk7RcEo3HefxtfOQ5ruQYO+J8BvgF8pkQmKY=
X-Received: by 2002:a05:6871:4d03:b0:17d:1287:1b5c with SMTP id
 ug3-20020a0568714d0300b0017d12871b5cmr12083436oab.9.1680489794112; Sun, 02
 Apr 2023 19:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com> <20230328120412.110114-4-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230328120412.110114-4-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 3 Apr 2023 10:43:03 +0800
Message-ID: <CACGkMEvZ=-G4QVTDnoSa1N0UspW8u_oz-7xosrXV0f1YcytVXw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] virtio_net: introduce virtnet_xdp_handler()
 to seprate the logic of run xdp
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
> At present, we have two similar logic to perform the XDP prog.
>
> Therefore, this PATCH separates the code of executing XDP, which is
> conducive to later maintenance.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 142 +++++++++++++++++++++------------------
>  1 file changed, 75 insertions(+), 67 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index bb426958cdd4..72b9d6ee4024 100644
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

I'd prefer this to be done on top unless it is a must. But I don't see
any advantage of introducing this, it's partial mapping of XDP action
and it needs to be extended when XDP action is extended. (And we've
already had: VIRTIO_XDP_REDIR and VIRTIO_XDP_TX ...)

> +
>  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
>  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
>
> @@ -789,6 +798,59 @@ static int virtnet_xdp_xmit(struct net_device *dev,
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
> +               return VIRTNET_XDP_RES_PASS;
> +
> +       case XDP_TX:
> +               stats->xdp_tx++;
> +               xdpf =3D xdp_convert_buff_to_frame(xdp);
> +               if (unlikely(!xdpf))
> +                       return VIRTNET_XDP_RES_DROP;
> +
> +               err =3D virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> +               if (unlikely(!err)) {
> +                       xdp_return_frame_rx_napi(xdpf);
> +               } else if (unlikely(err < 0)) {
> +                       trace_xdp_exception(dev, xdp_prog, act);
> +                       return VIRTNET_XDP_RES_DROP;
> +               }
> +
> +               *xdp_xmit |=3D VIRTIO_XDP_TX;
> +               return VIRTNET_XDP_RES_CONSUMED;
> +
> +       case XDP_REDIRECT:
> +               stats->xdp_redirects++;
> +               err =3D xdp_do_redirect(dev, xdp, xdp_prog);
> +               if (err)
> +                       return VIRTNET_XDP_RES_DROP;
> +
> +               *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> +               return VIRTNET_XDP_RES_CONSUMED;
> +
> +       default:
> +               bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> +               fallthrough;
> +       case XDP_ABORTED:
> +               trace_xdp_exception(dev, xdp_prog, act);
> +               fallthrough;
> +       case XDP_DROP:
> +               return VIRTNET_XDP_RES_DROP;
> +       }
> +}
> +
>  static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
>  {
>         return vi->xdp_enabled ? VIRTIO_XDP_HEADROOM : 0;
> @@ -876,7 +938,6 @@ static struct sk_buff *receive_small(struct net_devic=
e *dev,
>         struct page *page =3D virt_to_head_page(buf);
>         unsigned int delta =3D 0;
>         struct page *xdp_page;
> -       int err;
>         unsigned int metasize =3D 0;
>
>         len -=3D vi->hdr_len;
> @@ -898,7 +959,6 @@ static struct sk_buff *receive_small(struct net_devic=
e *dev,
>         xdp_prog =3D rcu_dereference(rq->xdp_prog);
>         if (xdp_prog) {
>                 struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_off=
set;
> -               struct xdp_frame *xdpf;
>                 struct xdp_buff xdp;
>                 void *orig_data;
>                 u32 act;
> @@ -931,46 +991,22 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
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
> -               case XDP_PASS:
> +               case VIRTNET_XDP_RES_PASS:
>                         /* Recalculate length in case bpf program changed=
 it */
>                         delta =3D orig_data - xdp.data;
>                         len =3D xdp.data_end - xdp.data;
>                         metasize =3D xdp.data - xdp.data_meta;
>                         break;
> -               case XDP_TX:
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
> -               case XDP_REDIRECT:
> -                       stats->xdp_redirects++;
> -                       err =3D xdp_do_redirect(dev, &xdp, xdp_prog);
> -                       if (err)
> -                               goto err_xdp;
> -                       *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> +
> +               case VIRTNET_XDP_RES_CONSUMED:
>                         rcu_read_unlock();
>                         goto xdp_xmit;
> -               default:
> -                       bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, ac=
t);
> -                       fallthrough;
> -               case XDP_ABORTED:
> -                       trace_xdp_exception(vi->dev, xdp_prog, act);
> -                       goto err_xdp;
> -               case XDP_DROP:
> +
> +               case VIRTNET_XDP_RES_DROP:
>                         goto err_xdp;
>                 }
>         }
> @@ -1277,7 +1313,6 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>         if (xdp_prog) {
>                 unsigned int xdp_frags_truesz =3D 0;
>                 struct skb_shared_info *shinfo;
> -               struct xdp_frame *xdpf;
>                 struct page *xdp_page;
>                 struct xdp_buff xdp;
>                 void *data;
> @@ -1294,49 +1329,22 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
>                 if (unlikely(err))
>                         goto err_xdp_frags;
>
> -               act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> -               stats->xdp_packets++;
> +               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
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
> -                       stats->xdp_tx++;
> -                       xdpf =3D xdp_convert_buff_to_frame(&xdp);
> -                       if (unlikely(!xdpf)) {
> -                               netdev_dbg(dev, "convert buff to frame fa=
iled for xdp\n");

Nit: This debug is lost after the conversion.

Thanks

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
> -               case XDP_REDIRECT:
> -                       stats->xdp_redirects++;
> -                       err =3D xdp_do_redirect(dev, &xdp, xdp_prog);
> -                       if (err)
> -                               goto err_xdp_frags;
> -                       *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> +
> +               case VIRTNET_XDP_RES_CONSUMED:
>                         rcu_read_unlock();
>                         goto xdp_xmit;
> -               default:
> -                       bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, ac=
t);
> -                       fallthrough;
> -               case XDP_ABORTED:
> -                       trace_xdp_exception(vi->dev, xdp_prog, act);
> -                       fallthrough;
> -               case XDP_DROP:
> +
> +               case VIRTNET_XDP_RES_DROP:
>                         goto err_xdp_frags;
>                 }
>  err_xdp_frags:
> --
> 2.32.0.3.g01195cf9f
>

