Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74AE66EDDAB
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 10:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233528AbjDYIKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 04:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjDYIKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 04:10:15 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6741BA2;
        Tue, 25 Apr 2023 01:10:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VgzMEEk_1682410208;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgzMEEk_1682410208)
          by smtp.aliyun-inc.com;
          Tue, 25 Apr 2023 16:10:09 +0800
Message-ID: <1682410175.9141502-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next v3 10/15] virtio_net: introduce receive_small_xdp()
Date:   Tue, 25 Apr 2023 16:09:35 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
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
        Jason Wang <jasowang@redhat.com>
References: <20230423105736.56918-1-xuanzhuo@linux.alibaba.com>
 <20230423105736.56918-11-xuanzhuo@linux.alibaba.com>
 <CACGkMEtv0zO=sjac3NMf78ut7o_Gb8-cnD=9zAEDBTqpCxTZAw@mail.gmail.com>
 <1682409605.658174-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1682409605.658174-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        URIBL_BLOCKED,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 16:00:05 +0800, Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> On Tue, 25 Apr 2023 15:58:03 +0800, Jason Wang <jasowang@redhat.com> wrot=
e:
> > On Sun, Apr 23, 2023 at 6:58=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.aliba=
ba.com> wrote:
> > >
> > > The purpose of this patch is to simplify the receive_small().
> > > Separate all the logic of XDP of small into a function.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/net/virtio_net.c | 165 ++++++++++++++++++++++++-------------=
--
> > >  1 file changed, 100 insertions(+), 65 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index de5a579e8603..9b5fd2e0d27f 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -931,6 +931,99 @@ static struct page *xdp_linearize_page(struct re=
ceive_queue *rq,
> > >         return NULL;
> > >  }
> > >
> > > +static struct sk_buff *receive_small_xdp(struct net_device *dev,
> > > +                                        struct virtnet_info *vi,
> > > +                                        struct receive_queue *rq,
> > > +                                        struct bpf_prog *xdp_prog,
> > > +                                        void *buf,
> > > +                                        unsigned int xdp_headroom,
> > > +                                        unsigned int len,
> > > +                                        unsigned int *xdp_xmit,
> > > +                                        struct virtnet_rq_stats *sta=
ts)
> > > +{
> > > +       unsigned int header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> > > +       unsigned int headroom =3D vi->hdr_len + header_offset;
> > > +       struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header_offset;
> > > +       struct page *page =3D virt_to_head_page(buf);
> > > +       struct page *xdp_page;
> > > +       unsigned int buflen;
> > > +       struct xdp_buff xdp;
> > > +       struct sk_buff *skb;
> > > +       unsigned int delta =3D 0;
> > > +       unsigned int metasize =3D 0;
> > > +       void *orig_data;
> > > +       u32 act;
> > > +
> > > +       if (unlikely(hdr->hdr.gso_type))
> > > +               goto err_xdp;
> > > +
> > > +       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom) +
> > > +               SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > +
> > > +       if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
> > > +               int offset =3D buf - page_address(page) + header_offs=
et;
> > > +               unsigned int tlen =3D len + vi->hdr_len;
> > > +               int num_buf =3D 1;
> > > +
> > > +               xdp_headroom =3D virtnet_get_headroom(vi);
> > > +               header_offset =3D VIRTNET_RX_PAD + xdp_headroom;
> > > +               headroom =3D vi->hdr_len + header_offset;
> > > +               buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + headroom)=
 +
> > > +                       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)=
);
> > > +               xdp_page =3D xdp_linearize_page(rq, &num_buf, page,
> > > +                                             offset, header_offset,
> > > +                                             &tlen);
> > > +               if (!xdp_page)
> > > +                       goto err_xdp;
> > > +
> > > +               buf =3D page_address(xdp_page);
> > > +               put_page(page);
> > > +               page =3D xdp_page;
> > > +       }
> > > +
> > > +       xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> > > +       xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr_len,
> > > +                        xdp_headroom, len, true);
> > > +       orig_data =3D xdp.data;
> > > +
> > > +       act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, st=
ats);
> > > +
> > > +       switch (act) {
> > > +       case XDP_PASS:
> > > +               /* Recalculate length in case bpf program changed it =
*/
> > > +               delta =3D orig_data - xdp.data;
> > > +               len =3D xdp.data_end - xdp.data;
> > > +               metasize =3D xdp.data - xdp.data_meta;
> > > +               break;
> > > +
> > > +       case XDP_TX:
> > > +       case XDP_REDIRECT:
> > > +               goto xdp_xmit;
> > > +
> > > +       default:
> > > +               goto err_xdp;
> > > +       }
> > > +
> > > +       skb =3D build_skb(buf, buflen);
> > > +       if (!skb)
> > > +               goto err;
> > > +
> > > +       skb_reserve(skb, headroom - delta);
> > > +       skb_put(skb, len);
> > > +       if (metasize)
> > > +               skb_metadata_set(skb, metasize);
> > > +
> > > +       return skb;
> > > +
> > > +err_xdp:
> > > +       stats->xdp_drops++;
> > > +err:
> > > +       stats->drops++;
> > > +       put_page(page);
> > > +xdp_xmit:
> > > +       return NULL;
> > > +}
> >
> > It looks like some of the comments of the above version is not addresse=
d?
> >
> > "
> > So we end up with some code duplication between receive_small() and
> > receive_small_xdp() on building skbs. Is this intended?
> > "
>
> I answer you in the #13 commit of the above version. This patch-set has o=
ptimize
> this with the last two commits. This commit is not unchanged.

Sorry, typo.

"This commit is unchanged."

Thanks.

>
> Thanks.
>
>
> >
> > Thanks
> >
> > > +
> > >  static struct sk_buff *receive_small(struct net_device *dev,
> > >                                      struct virtnet_info *vi,
> > >                                      struct receive_queue *rq,
> > > @@ -947,9 +1040,6 @@ static struct sk_buff *receive_small(struct net_=
device *dev,
> > >         unsigned int buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + head=
room) +
> > >                               SKB_DATA_ALIGN(sizeof(struct skb_shared=
_info));
> > >         struct page *page =3D virt_to_head_page(buf);
> > > -       unsigned int delta =3D 0;
> > > -       struct page *xdp_page;
> > > -       unsigned int metasize =3D 0;
> > >
> > >         len -=3D vi->hdr_len;
> > >         stats->bytes +=3D len;
> > > @@ -969,56 +1059,10 @@ static struct sk_buff *receive_small(struct ne=
t_device *dev,
> > >         rcu_read_lock();
> > >         xdp_prog =3D rcu_dereference(rq->xdp_prog);
> > >         if (xdp_prog) {
> > > -               struct virtio_net_hdr_mrg_rxbuf *hdr =3D buf + header=
_offset;
> > > -               struct xdp_buff xdp;
> > > -               void *orig_data;
> > > -               u32 act;
> > > -
> > > -               if (unlikely(hdr->hdr.gso_type))
> > > -                       goto err_xdp;
> > > -
> > > -               if (unlikely(xdp_headroom < virtnet_get_headroom(vi))=
) {
> > > -                       int offset =3D buf - page_address(page) + hea=
der_offset;
> > > -                       unsigned int tlen =3D len + vi->hdr_len;
> > > -                       int num_buf =3D 1;
> > > -
> > > -                       xdp_headroom =3D virtnet_get_headroom(vi);
> > > -                       header_offset =3D VIRTNET_RX_PAD + xdp_headro=
om;
> > > -                       headroom =3D vi->hdr_len + header_offset;
> > > -                       buflen =3D SKB_DATA_ALIGN(GOOD_PACKET_LEN + h=
eadroom) +
> > > -                                SKB_DATA_ALIGN(sizeof(struct skb_sha=
red_info));
> > > -                       xdp_page =3D xdp_linearize_page(rq, &num_buf,=
 page,
> > > -                                                     offset, header_=
offset,
> > > -                                                     &tlen);
> > > -                       if (!xdp_page)
> > > -                               goto err_xdp;
> > > -
> > > -                       buf =3D page_address(xdp_page);
> > > -                       put_page(page);
> > > -                       page =3D xdp_page;
> > > -               }
> > > -
> > > -               xdp_init_buff(&xdp, buflen, &rq->xdp_rxq);
> > > -               xdp_prepare_buff(&xdp, buf + VIRTNET_RX_PAD + vi->hdr=
_len,
> > > -                                xdp_headroom, len, true);
> > > -               orig_data =3D xdp.data;
> > > -
> > > -               act =3D virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_=
xmit, stats);
> > > -
> > > -               switch (act) {
> > > -               case XDP_PASS:
> > > -                       /* Recalculate length in case bpf program cha=
nged it */
> > > -                       delta =3D orig_data - xdp.data;
> > > -                       len =3D xdp.data_end - xdp.data;
> > > -                       metasize =3D xdp.data - xdp.data_meta;
> > > -                       break;
> > > -               case XDP_TX:
> > > -               case XDP_REDIRECT:
> > > -                       rcu_read_unlock();
> > > -                       goto xdp_xmit;
> > > -               default:
> > > -                       goto err_xdp;
> > > -               }
> > > +               skb =3D receive_small_xdp(dev, vi, rq, xdp_prog, buf,=
 xdp_headroom,
> > > +                                       len, xdp_xmit, stats);
> > > +               rcu_read_unlock();
> > > +               return skb;
> > >         }
> > >         rcu_read_unlock();
> > >
> > > @@ -1026,25 +1070,16 @@ static struct sk_buff *receive_small(struct n=
et_device *dev,
> > >         skb =3D build_skb(buf, buflen);
> > >         if (!skb)
> > >                 goto err;
> > > -       skb_reserve(skb, headroom - delta);
> > > +       skb_reserve(skb, headroom);
> > >         skb_put(skb, len);
> > > -       if (!xdp_prog) {
> > > -               buf +=3D header_offset;
> > > -               memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> > > -       } /* keep zeroed vnet hdr since XDP is loaded */
> > > -
> > > -       if (metasize)
> > > -               skb_metadata_set(skb, metasize);
> > >
> > > +       buf +=3D header_offset;
> > > +       memcpy(skb_vnet_hdr(skb), buf, vi->hdr_len);
> > >         return skb;
> > >
> > > -err_xdp:
> > > -       rcu_read_unlock();
> > > -       stats->xdp_drops++;
> > >  err:
> > >         stats->drops++;
> > >         put_page(page);
> > > -xdp_xmit:
> > >         return NULL;
> > >  }
> > >
> > > --
> > > 2.32.0.3.g01195cf9f
> > >
> >
