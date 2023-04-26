Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47D6EECB1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 05:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbjDZDUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239184AbjDZDUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 23:20:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AB1194
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 20:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682479164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yItUP1MtVzVQEaBwOeYrzaiJnDgp0qX3Vr2foO6YONc=;
        b=QNEBepnnSi+hOfUBeCL/E5iZkiDysEqxsPPjNhGqkCbE+yVWt29OmGJBW5qsK5/y9+ikms
        hRvtYJZMpYSghFMSr7efPu43CwFU82P7S0zc2sLrREtUyV079VmWUAe+nITj/w/j12nMWr
        tposdx9RU1zm/bXOIwcqERSJ0uvfU2o=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-Qwr4WP33Pk2Gkcnv1mCbEQ-1; Tue, 25 Apr 2023 23:19:22 -0400
X-MC-Unique: Qwr4WP33Pk2Gkcnv1mCbEQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2a7a43cde30so24167751fa.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 20:19:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682479161; x=1685071161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yItUP1MtVzVQEaBwOeYrzaiJnDgp0qX3Vr2foO6YONc=;
        b=IHfXjJBnMz6AtguulteKEAaN+fiS/9Xhk5t328TlXCe4ZEGp070rKe/a5dqY2XI4C/
         Zz3lJk6gPXPuBjTGBxPvi+7eyGo6pIu3dx8gbNwQif7h0f/YhbmTiexAgOiXr1KUMGQc
         QJ4JDorp/SKVBSILHK4B2RTPn9V+jidH1UeUBH+Gph5Mmh4BacINfCo3LBlvHahcSRgd
         UHgkHsGmR8BKsAmSUBRoYnZXRA7M7q6m5Gb5dS7z//mL4HouHjM95BQMAEUHeioQLUHf
         XIXTR2YNS25piL1rDZOFPMmqueQXDJ9foJClWeB4acagI/0Z0nL3eIu+EEIJEIhks59a
         Jjag==
X-Gm-Message-State: AAQBX9dCtbA9/zSjC8XieHtd51ZsE4s7YrmiiVNIyjYUp8OTfT3cykiW
        Ky+I8SFT3YI5+4F9GheL6OivDqdOEzv4AN71jGAFjcxo6uravPs7w6WzkBbqOlpCCJJmHUb/d4S
        75KWYZIS5KByk83C8JxwtMZStr/Fjm8WX7px633cpczw0bzTa
X-Received: by 2002:a2e:90d5:0:b0:2a8:b168:981f with SMTP id o21-20020a2e90d5000000b002a8b168981fmr3740776ljg.46.1682479160886;
        Tue, 25 Apr 2023 20:19:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350athi9tBt0ROMK84w66VZbKG9AFjI1YmzAQ6LaoPUb2fes0xwE+axm1auwAQvjNIY8aKWVX2w7srUW5LQWTQyg=
X-Received: by 2002:a2e:90d5:0:b0:2a8:b168:981f with SMTP id
 o21-20020a2e90d5000000b002a8b168981fmr3740766ljg.46.1682479160486; Tue, 25
 Apr 2023 20:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
 <20230423105736.56918-11-xuanzhuo@linux.alibaba.com> <CACGkMEtv0zO=sjac3NMf78ut7o_Gb8-cnD=9zAEDBTqpCxTZAw@mail.gmail.com>
 <1682409605.658174-1-xuanzhuo@linux.alibaba.com> <1682410175.9141502-3-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1682410175.9141502-3-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 26 Apr 2023 11:19:09 +0800
Message-ID: <CACGkMEtMmcXzqsmkk9tLW57ft0a9mjEZVQSC7rzHwhkUBusZEQ@mail.gmail.com>
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

On Tue, Apr 25, 2023 at 4:10=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
>
> On Tue, 25 Apr 2023 16:00:05 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com=
> wrote:
> > On Tue, 25 Apr 2023 15:58:03 +0800, Jason Wang <jasowang@redhat.com> wr=
ote:
> > > On Sun, Apr 23, 2023 at 6:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.ali=
baba.com> wrote:
> > > >
> > > > The purpose of this patch is to simplify the receive_small().
> > > > Separate all the logic of XDP of small into a function.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 165 ++++++++++++++++++++++++-----------=
----
> > > >  1 file changed, 100 insertions(+), 65 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index de5a579e8603..9b5fd2e0d27f 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -931,6 +931,99 @@ static struct page *xdp_linearize_page(struct =
receive_queue *rq,
> > > >         return NULL;
> > > >  }
> > > >
> > > > +static struct sk_buff *receive_small_xdp(struct net_device *dev,
> > > > +                                        struct virtnet_info *vi,
> > > > +                                        struct receive_queue *rq,
> > > > +                                        struct bpf_prog *xdp_prog,
> > > > +                                        void *buf,
> > > > +                                        unsigned int xdp_headroom,
> > > > +                                        unsigned int len,
> > > > +                                        unsigned int *xdp_xmit,
> > > > +                                        struct virtnet_rq_stats *s=
tats)
> > > > +{
> > > > +       unsigned int header_offset =3D VIRTNET_RX_PAD + xdp_headroo=
m;
> > > > +       unsigned int headroom =3D vi->hdr_len + header_offset;
> > > > +       struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_offse=
t;
> > > > +       struct page *page =3D virt_to_head_page(buf);
> > > > +       struct page *xdp_page;
> > > > +       unsigned int buflen;
> > > > +       struct xdp_buff xdp;
> > > > +       struct sk_buff *skb;
> > > > +       unsigned int delta =3D 0;
> > > > +       unsigned int metasize =3D 0;
> > > > +       void *orig_data;
> > > > +       u32 act;
> > > > +
> > > > +       if (unlikely(hdr->hdr.gso_type))
> > > > +               goto err_xdp;
> > > > +
> > > > +       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> > > > +               SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > > +
> > > > +       if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
> > > > +               int offset =3D buf - page_address(page) + header_of=
fset;
> > > > +               unsigned int tlen =3D len + vi->hdr_len;
> > > > +               int num_buf =3D 1;
> > > > +
> > > > +               xdp_headroom =3D virtnet_get_headroom(vi);
> > > > +               header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> > > > +               headroom =3D vi->hdr_len + header_offset;
> > > > +               buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroo=
m) +
> > > > +                       SKB_DATA_ALIGN(sizeof(struct skb_shared_inf=
o));
> > > > +               xdp_page =3D xdp_linearize_page(rq, &num_buf, page,
> > > > +                                             offset, header_offset=
,
> > > > +                                             &tlen);
> > > > +               if (!xdp_page)
> > > > +                       goto err_xdp;
> > > > +
> > > > +               buf =3D page_address(xdp_page);
> > > > +               put_page(page);
> > > > +               page =3D xdp_page;
> > > > +       }
> > > > +
> > > > +       xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> > > > +       xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
> > > > +                        xdp_headroom, len, true);
> > > > +       orig_data =3D xdp.data;
> > > > +
> > > > +       act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, =
stats);
> > > > +
> > > > +       switch (act) {
> > > > +       case XDP_PASS:
> > > > +               /* Recalculate length in case bpf program changed i=
t */
> > > > +               delta =3D orig_data - xdp.data;
> > > > +               len =3D xdp.data_end - xdp.data;
> > > > +               metasize =3D xdp.data - xdp.data_meta;
> > > > +               break;
> > > > +
> > > > +       case XDP_TX:
> > > > +       case XDP_REDIRECT:
> > > > +               goto xdp_xmit;
> > > > +
> > > > +       default:
> > > > +               goto err_xdp;
> > > > +       }
> > > > +
> > > > +       skb =3D build_skb(buf, buflen);
> > > > +       if (!skb)
> > > > +               goto err;
> > > > +
> > > > +       skb_reserve(skb, headroom - delta);
> > > > +       skb_put(skb, len);
> > > > +       if (metasize)
> > > > +               skb_metadata_set(skb, metasize);
> > > > +
> > > > +       return skb;
> > > > +
> > > > +err_xdp:
> > > > +       stats->xdp_drops++;
> > > > +err:
> > > > +       stats->drops++;
> > > > +       put_page(page);
> > > > +xdp_xmit:
> > > > +       return NULL;
> > > > +}
> > >
> > > It looks like some of the comments of the above version is not addres=
sed?
> > >
> > > "
> > > So we end up with some code duplication between receive_small() and
> > > receive_small_xdp() on building skbs. Is this intended?
> > > "
> >
> > I answer you in the #13 commit of the above version. This patch-set has=
 optimize
> > this with the last two commits. This commit is not unchanged.

For some reason I miss that.

>
> Sorry, typo.
>
> "This commit is unchanged."

Ok.

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>
> Thanks.
>
> >
> > Thanks.
> >
> >
> > >
> > > Thanks
> > >
> > > > +
> > > >  static struct sk_buff *receive_small(struct net_device *dev,
> > > >                                      struct virtnet_info *vi,
> > > >                                      struct receive_queue *rq,
> > > > @@ -947,9 +1040,6 @@ static struct sk_buff *receive_small(struct ne=
t_device *dev,
> > > >         unsigned int buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + he=
adroom) +
> > > >                               SKB_DATA_ALIGN(sizeof(struct skb_shar=
ed_info));
> > > >         struct page *page =3D virt_to_head_page(buf);
> > > > -       unsigned int delta =3D 0;
> > > > -       struct page *xdp_page;
> > > > -       unsigned int metasize =3D 0;
> > > >
> > > >         len -=3D vi->hdr_len;
> > > >         stats->bytes +=3D len;
> > > > @@ -969,56 +1059,10 @@ static struct sk_buff *receive_small(struct =
net_device *dev,
> > > >         rcu_read_lock();
> > > >         xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > > >         if (xdp_prog) {
> > > > -               struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + head=
er_offset;
> > > > -               struct xdp_buff xdp;
> > > > -               void *orig_data;
> > > > -               u32 act;
> > > > -
> > > > -               if (unlikely(hdr->hdr.gso_type))
> > > > -                       goto err_xdp;
> > > > -
> > > > -               if (unlikely(xdp_headroom < virtnet_get_headroom(vi=
))) {
> > > > -                       int offset =3D buf - page_address(page) + h=
eader_offset;
> > > > -                       unsigned int tlen =3D len + vi->hdr_len;
> > > > -                       int num_buf =3D 1;
> > > > -
> > > > -                       xdp_headroom =3D virtnet_get_headroom(vi);
> > > > -                       header_offset =3D VIRTNET_RX_PAD + xdp_head=
room;
> > > > -                       headroom =3D vi->hdr_len + header_offset;
> > > > -                       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN +=
 headroom) +
> > > > -                                SKB_DATA_ALIGN(sizeof(struct skb_s=
hared_info));
> > > > -                       xdp_page =3D xdp_linearize_page(rq, &num_bu=
f, page,
> > > > -                                                     offset, heade=
r_offset,
> > > > -                                                     &tlen);
> > > > -                       if (!xdp_page)
> > > > -                               goto err_xdp;
> > > > -
> > > > -                       buf =3D page_address(xdp_page);
> > > > -                       put_page(page);
> > > > -                       page =3D xdp_page;
> > > > -               }
> > > > -
> > > > -               xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> > > > -               xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->h=
dr_len,
> > > > -                                xdp_headroom, len, true);
> > > > -               orig_data =3D xdp.data;
> > > > -
> > > > -               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xd=
p_xmit, stats);
> > > > -
> > > > -               switch (act) {
> > > > -               case XDP_PASS:
> > > > -                       /* Recalculate length in case bpf program c=
hanged it */
> > > > -                       delta =3D orig_data - xdp.data;
> > > > -                       len =3D xdp.data_end - xdp.data;
> > > > -                       metasize =3D xdp.data - xdp.data_meta;
> > > > -                       break;
> > > > -               case XDP_TX:
> > > > -               case XDP_REDIRECT:
> > > > -                       rcu_read_unlock();
> > > > -                       goto xdp_xmit;
> > > > -               default:
> > > > -                       goto err_xdp;
> > > > -               }
> > > > +               skb =3D receive_small_xdp(dev, vi, rq, xdp_prog, bu=
f, xdp_headroom,
> > > > +                                       len, xdp_xmit, stats);
> > > > +               rcu_read_unlock();
> > > > +               return skb;
> > > >         }
> > > >         rcu_read_unlock();
> > > >
> > > > @@ -1026,25 +1070,16 @@ static struct sk_buff *receive_small(struct=
 net_device *dev,
> > > >         skb =3D build_skb(buf, buflen);
> > > >         if (!skb)
> > > >                 goto err;
> > > > -       skb_reserve(skb, headroom - delta);
> > > > +       skb_reserve(skb, headroom);
> > > >         skb_put(skb, len);
> > > > -       if (!xdp_prog) {
> > > > -               buf +=3D header_offset;
> > > > -               memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> > > > -       } /* keep zeroed vnet hdr since XDP is loaded */
> > > > -
> > > > -       if (metasize)
> > > > -               skb_metadata_set(skb, metasize);
> > > >
> > > > +       buf +=3D header_offset;
> > > > +       memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> > > >         return skb;
> > > >
> > > > -err_xdp:
> > > > -       rcu_read_unlock();
> > > > -       stats->xdp_drops++;
> > > >  err:
> > > >         stats->drops++;
> > > >         put_page(page);
> > > > -xdp_xmit:
> > > >         return NULL;
> > > >  }
> > > >
> > > > --
> > > > 2.32.0.3.g01195cf9f
> > > >
> > >
>

