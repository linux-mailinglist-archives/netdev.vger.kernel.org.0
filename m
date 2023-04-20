Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84836E8A5C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbjDTGZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjDTGZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:25:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEDF65BA
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681971842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y123myLqJr95ZMF3nPVNFw1AoKmEW863xATqLva+JBo=;
        b=N8M3I14ovuOMh7qgpyn7uy896t62/QovEvX4iPL/ovmvNCMVwgpJPiL/kgg/T1GAgUfPux
        qMdu+82o/BJLVyJeZMWnYvUuJ1ray2Xn4JpVuqNr8cerUlmBlEo2jSfz59V+odTPeDfqgC
        pu3/XOAw4U3z7C5vP5W+U4msSyC/xxc=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-wCdIVmzNOEOIiV3RamBEFg-1; Thu, 20 Apr 2023 02:24:01 -0400
X-MC-Unique: wCdIVmzNOEOIiV3RamBEFg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1878d25889dso104727fac.15
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681971840; x=1684563840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y123myLqJr95ZMF3nPVNFw1AoKmEW863xATqLva+JBo=;
        b=Ezgo5PL10dAXx8MJFsGAzHBXf35vPc/hOKk+e3/Zq9S9aCh0gYGkk6yqcJvH5vtU0T
         xqZxTfL0zzZf/nq8wij6mYl7CLCVHfpmB3ifxsvWAFN8cu2W0wktmQ58DwqfwsfG70YU
         x4dgzFGJ775xZugkjWFtq5v9+03ZmEEjr4QUPh8ebsmD1rmjUFCC1z7k49VimNM+vRH5
         xsJe8FfR7t5aD9kcmfqfV62bvBq5CioTFC2Y7CUThNEcyx8uV9v+MgHRep8f11ZLKtq4
         WhJtqBIxVSVa7GZWySZYqiH53GH2C6p0gRKUA5Clb1+q0wAlGvWGhG7jqWTe26STu7e8
         CMHg==
X-Gm-Message-State: AAQBX9fF2I568gA+dXwDOXzIGjdRiPE1oS8j+7gWSOhGE1srFys1wkeV
        WJw4Gq5dpksxI9FUX5l05FFJN3lnKKcPMG4f6WUuk9lNgQyMMbDnG1CQrzjSNsJ6vpoWGAMwIDG
        /PLf2dJ+ctMib+3JejFXSJJXbR8elDNla
X-Received: by 2002:a05:6820:1505:b0:53b:1086:7a09 with SMTP id ay5-20020a056820150500b0053b10867a09mr1515358oob.3.1681971840213;
        Wed, 19 Apr 2023 23:24:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350YZ9023xMIhN76cWcQP3LSGCkgsv1nWFysZV9l7/6RCwzCrtO7oQK+jA7mEm1PagXTGLa8eOtU0M6ddF1W+EPU=
X-Received: by 2002:a05:6820:1505:b0:53b:1086:7a09 with SMTP id
 ay5-20020a056820150500b0053b10867a09mr1515349oob.3.1681971839957; Wed, 19 Apr
 2023 23:23:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com> <20230418065327.72281-12-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230418065327.72281-12-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 20 Apr 2023 14:23:48 +0800
Message-ID: <CACGkMEsdwApvHFTWc4biY-AvwQf9sPuonYFU_Zdn2=wa3cHBjg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 11/14] virtio_net: introduce receive_small_xdp()
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
> The purpose of this patch is to simplify the receive_small().
> Separate all the logic of XDP of small into a function.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 165 +++++++++++++++++++++++----------------
>  1 file changed, 99 insertions(+), 66 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index a4bb25f39f12..34220f5f27d1 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -941,6 +941,98 @@ static struct page *xdp_linearize_page(struct receiv=
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
> +       case VIRTNET_XDP_RES_PASS:
> +               /* Recalculate length in case bpf program changed it */
> +               delta =3D orig_data - xdp.data;
> +               len =3D xdp.data_end - xdp.data;
> +               metasize =3D xdp.data - xdp.data_meta;
> +               break;
> +
> +       case VIRTNET_XDP_RES_CONSUMED:
> +               goto xdp_xmit;
> +
> +       case VIRTNET_XDP_RES_DROP:
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
> +
>  static struct sk_buff *receive_small(struct net_device *dev,
>                                      struct virtnet_info *vi,
>                                      struct receive_queue *rq,
> @@ -957,9 +1049,6 @@ static struct sk_buff *receive_small(struct net_devi=
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
> @@ -979,57 +1068,10 @@ static struct sk_buff *receive_small(struct net_de=
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
> -               case VIRTNET_XDP_RES_PASS:
> -                       /* Recalculate length in case bpf program changed=
 it */
> -                       delta =3D orig_data - xdp.data;
> -                       len =3D xdp.data_end - xdp.data;
> -                       metasize =3D xdp.data - xdp.data_meta;
> -                       break;
> -
> -               case VIRTNET_XDP_RES_CONSUMED:
> -                       rcu_read_unlock();
> -                       goto xdp_xmit;
> -
> -               case VIRTNET_XDP_RES_DROP:
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
> @@ -1037,25 +1079,16 @@ static struct sk_buff *receive_small(struct net_d=
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

So we end up with some code duplication between receive_small() and
receive_small_xdp() on building skbs. Is this intended?

For mergeable, we're probably fine since XDP_PASS doesn't need to
get_buf(). But for the path of small, I wonder if it's better to keep
the original code for building skb.

Thanks

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

