Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189836EDD7B
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbjDYH7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbjDYH7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:59:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F1E5245
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682409497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOwuC+AUdncvOx6FLcofMgBS2clPkrtfiATkgyugNiQ=;
        b=YwGajPGXS+p0Qjeep1eWg5A1eb8Xj0qFpX37MoFU0bgxWCYpz3A9UjZkigq1qOdKieMXtS
        WAT/vqLcfeTV9Wip9n+aDslIPRC3My1v99yD1kT2yNkvy/XcLz1ahUI9iDmOhADDYu2wRX
        2HYsl7XPZQ+VE4vXEjI+GFrJUqb3HWw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-jKeI8Rx1PnKSFdyD__o18A-1; Tue, 25 Apr 2023 03:58:16 -0400
X-MC-Unique: jKeI8Rx1PnKSFdyD__o18A-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2a9f9b317cfso19617551fa.2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682409495; x=1685001495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOwuC+AUdncvOx6FLcofMgBS2clPkrtfiATkgyugNiQ=;
        b=SbBzJc9xbUnfivT2H8eIHHz+v69hceVkKC14JcO7Z+QT54G+6qzL7nKZ7DuACpef0v
         DRVCv6kIZ30bKkzpPjp3U9k43SUIy5v3GVCiqDK+hoyqxfcIxm1eOxwnyIeidzCa+8T2
         wBXoBnsBCuvvJWth1Nxo4GMmOg+gl/lbudla7ICHzMuMjB9eb+mx6ssOsMl9N+xoqNuS
         l0DV1IkEyOD11U1aMc8fjkhuEjnP9hv0lNTp/HzaTgEC/MvBP2+jHnUZzSphNEclRLeT
         Oy4VloOzjmqQrKHbI8w9XTvcuTyAn+caUVC+c0CQHK+mAmrSBwedk8fa2UgkwdszYVTg
         oJgg==
X-Gm-Message-State: AAQBX9eUH5JeufyVznU478VD2nfgt6detA9o2aR2ruCX57apiRLa7KyI
        TlkuQBolcokOeNEiqip4DGxk7mp901yKiplB5WDI++7gxocOBMrA3Cm4wD9bfClGY6hDEIVwd1B
        jik5jfitlHlFtepscQa521uz66+V05TFH
X-Received: by 2002:a2e:8691:0:b0:2a7:77ae:2787 with SMTP id l17-20020a2e8691000000b002a777ae2787mr3175452lji.20.1682409494871;
        Tue, 25 Apr 2023 00:58:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350asIEvkLutPiUcBuPPv3rtDR14B4V+OUvhw6Rg88xQGPg/KPRq5tBzA3aTCrPei0rGtyQcObXTr5e0QEhN26Ac=
X-Received: by 2002:a2e:8691:0:b0:2a7:77ae:2787 with SMTP id
 l17-20020a2e8691000000b002a777ae2787mr3175440lji.20.1682409494498; Tue, 25
 Apr 2023 00:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com> <20230423105736.56918-11-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230423105736.56918-11-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 25 Apr 2023 15:58:03 +0800
Message-ID: <CACGkMEtv0zO=sjac3NMf78ut7o_Gb8-cnD=9zAEDBTqpCxTZAw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 10/15] virtio_net: introduce receive_small_xdp()
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
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 23, 2023 at 6:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> The purpose of this patch is to simplify the receive_small().
> Separate all the logic of XDP of small into a function.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 165 ++++++++++++++++++++++++---------------
>  1 file changed, 100 insertions(+), 65 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index de5a579e8603..9b5fd2e0d27f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -931,6 +931,99 @@ static struct page *xdp_linearize_page(struct receiv=
e_queue *rq,
>         return NULL;
>  }
>
> +static struct sk_buff *receive_small_xdp(struct net_device *dev,
> +                                        struct virtnet_info *vi,
> +                                        struct receive_queue *rq,
> +                                        struct bpf_prog *xdp_prog,
> +                                        void *buf,
> +                                        unsigned int xdp_headroom,
> +                                        unsigned int len,
> +                                        unsigned int *xdp_xmit,
> +                                        struct virtnet_rq_stats *stats)
> +{
> +       unsigned int header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> +       unsigned int headroom =3D vi->hdr_len + header_offset;
> +       struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_offset;
> +       struct page *page =3D virt_to_head_page(buf);
> +       struct page *xdp_page;
> +       unsigned int buflen;
> +       struct xdp_buff xdp;
> +       struct sk_buff *skb;
> +       unsigned int delta =3D 0;
> +       unsigned int metasize =3D 0;
> +       void *orig_data;
> +       u32 act;
> +
> +       if (unlikely(hdr->hdr.gso_type))
> +               goto err_xdp;
> +
> +       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> +               SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +
> +       if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
> +               int offset =3D buf - page_address(page) + header_offset;
> +               unsigned int tlen =3D len + vi->hdr_len;
> +               int num_buf =3D 1;
> +
> +               xdp_headroom =3D virtnet_get_headroom(vi);
> +               header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> +               headroom =3D vi->hdr_len + header_offset;
> +               buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> +                       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +               xdp_page =3D xdp_linearize_page(rq, &num_buf, page,
> +                                             offset, header_offset,
> +                                             &tlen);
> +               if (!xdp_page)
> +                       goto err_xdp;
> +
> +               buf =3D page_address(xdp_page);
> +               put_page(page);
> +               page =3D xdp_page;
> +       }
> +
> +       xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> +       xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
> +                        xdp_headroom, len, true);
> +       orig_data =3D xdp.data;
> +
> +       act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats)=
;
> +
> +       switch (act) {
> +       case XDP_PASS:
> +               /* Recalculate length in case bpf program changed it */
> +               delta =3D orig_data - xdp.data;
> +               len =3D xdp.data_end - xdp.data;
> +               metasize =3D xdp.data - xdp.data_meta;
> +               break;
> +
> +       case XDP_TX:
> +       case XDP_REDIRECT:
> +               goto xdp_xmit;
> +
> +       default:
> +               goto err_xdp;
> +       }
> +
> +       skb =3D build_skb(buf, buflen);
> +       if (!skb)
> +               goto err;
> +
> +       skb_reserve(skb, headroom - delta);
> +       skb_put(skb, len);
> +       if (metasize)
> +               skb_metadata_set(skb, metasize);
> +
> +       return skb;
> +
> +err_xdp:
> +       stats->xdp_drops++;
> +err:
> +       stats->drops++;
> +       put_page(page);
> +xdp_xmit:
> +       return NULL;
> +}

It looks like some of the comments of the above version is not addressed?

"
So we end up with some code duplication between receive_small() and
receive_small_xdp() on building skbs. Is this intended?
"

Thanks

> +
>  static struct sk_buff *receive_small(struct net_device *dev,
>                                      struct virtnet_info *vi,
>                                      struct receive_queue *rq,
> @@ -947,9 +1040,6 @@ static struct sk_buff *receive_small(struct net_devi=
ce *dev,
>         unsigned int buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom=
) +
>                               SKB_DATA_ALIGN(sizeof(struct skb_shared_inf=
o));
>         struct page *page =3D virt_to_head_page(buf);
> -       unsigned int delta =3D 0;
> -       struct page *xdp_page;
> -       unsigned int metasize =3D 0;
>
>         len -=3D vi->hdr_len;
>         stats->bytes +=3D len;
> @@ -969,56 +1059,10 @@ static struct sk_buff *receive_small(struct net_de=
vice *dev,
>         rcu_read_lock();
>         xdp_prog =3D rcu_dereference(rq->xdp_prog);
>         if (xdp_prog) {
> -               struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_off=
set;
> -               struct xdp_buff xdp;
> -               void *orig_data;
> -               u32 act;
> -
> -               if (unlikely(hdr->hdr.gso_type))
> -                       goto err_xdp;
> -
> -               if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
> -                       int offset =3D buf - page_address(page) + header_=
offset;
> -                       unsigned int tlen =3D len + vi->hdr_len;
> -                       int num_buf =3D 1;
> -
> -                       xdp_headroom =3D virtnet_get_headroom(vi);
> -                       header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> -                       headroom =3D vi->hdr_len + header_offset;
> -                       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headr=
oom) +
> -                                SKB_DATA_ALIGN(sizeof(struct skb_shared_=
info));
> -                       xdp_page =3D xdp_linearize_page(rq, &num_buf, pag=
e,
> -                                                     offset, header_offs=
et,
> -                                                     &tlen);
> -                       if (!xdp_page)
> -                               goto err_xdp;
> -
> -                       buf =3D page_address(xdp_page);
> -                       put_page(page);
> -                       page =3D xdp_page;
> -               }
> -
> -               xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> -               xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len=
,
> -                                xdp_headroom, len, true);
> -               orig_data =3D xdp.data;
> -
> -               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit=
, stats);
> -
> -               switch (act) {
> -               case XDP_PASS:
> -                       /* Recalculate length in case bpf program changed=
 it */
> -                       delta =3D orig_data - xdp.data;
> -                       len =3D xdp.data_end - xdp.data;
> -                       metasize =3D xdp.data - xdp.data_meta;
> -                       break;
> -               case XDP_TX:
> -               case XDP_REDIRECT:
> -                       rcu_read_unlock();
> -                       goto xdp_xmit;
> -               default:
> -                       goto err_xdp;
> -               }
> +               skb =3D receive_small_xdp(dev, vi, rq, xdp_prog, buf, xdp=
_headroom,
> +                                       len, xdp_xmit, stats);
> +               rcu_read_unlock();
> +               return skb;
>         }
>         rcu_read_unlock();
>
> @@ -1026,25 +1070,16 @@ static struct sk_buff *receive_small(struct net_d=
evice *dev,
>         skb =3D build_skb(buf, buflen);
>         if (!skb)
>                 goto err;
> -       skb_reserve(skb, headroom - delta);
> +       skb_reserve(skb, headroom);
>         skb_put(skb, len);
> -       if (!xdp_prog) {
> -               buf +=3D header_offset;
> -               memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> -       } /* keep zeroed vnet hdr since XDP is loaded */
> -
> -       if (metasize)
> -               skb_metadata_set(skb, metasize);
>
> +       buf +=3D header_offset;
> +       memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
>         return skb;
>
> -err_xdp:
> -       rcu_read_unlock();
> -       stats->xdp_drops++;
>  err:
>         stats->drops++;
>         put_page(page);
> -xdp_xmit:
>         return NULL;
>  }
>
> --
> 2.32.0.3.g01195cf9f
>

