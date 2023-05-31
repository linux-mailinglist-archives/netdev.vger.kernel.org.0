Return-Path: <netdev+bounces-6658-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1642C717427
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52D0B1C20DF2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 03:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907F21113;
	Wed, 31 May 2023 03:12:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A59EC4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:12:23 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DF0E5;
	Tue, 30 May 2023 20:12:19 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vjvjzal_1685502735;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vjvjzal_1685502735)
          by smtp.aliyun-inc.com;
          Wed, 31 May 2023 11:12:16 +0800
Message-ID: <1685502651.282807-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/5] virtio_net: Add page_pool support to improve performance
Date: Wed, 31 May 2023 11:10:51 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Liang Chen <liangchen.linux@gmail.com>
Cc: Jason Wang <jasowang@redhat.com>,
 virtualization@lists.linux-foundation.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kuba@kernel.org,
 edumazet@google.com,
 davem@davemloft.net,
 pabeni@redhat.com,
 alexander.duyck@gmail.com,
 "Michael S. Tsirkin" <mst@redhat.com>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-2-liangchen.linux@gmail.com>
 <CACGkMEv+5150S4ooWFMnUs-GpwRYgRMTku0ZgkFpH5iFR1qQsw@mail.gmail.com>
 <CAKhg4tL2b9LEsaNuLi94Zf9XQ4S2FyoXWzW9wTTkrU8L1qNQcQ@mail.gmail.com>
 <20230528023956-mutt-send-email-mst@kernel.org>
 <CAKhg4t+8TsNZ-0hzfo63qCh_uFYHCmyZR+Fx+rC8garnMBt9jw@mail.gmail.com>
In-Reply-To: <CAKhg4t+8TsNZ-0hzfo63qCh_uFYHCmyZR+Fx+rC8garnMBt9jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Mon, 29 May 2023 15:28:17 +0800, Liang Chen <liangchen.linux@gmail.com> =
wrote:
> On Sun, May 28, 2023 at 2:40=E2=80=AFPM Michael S. Tsirkin <mst@redhat.co=
m> wrote:
> >
> > On Sat, May 27, 2023 at 08:35:01PM +0800, Liang Chen wrote:
> > > On Fri, May 26, 2023 at 2:51=E2=80=AFPM Jason Wang <jasowang@redhat.c=
om> wrote:
> > > >
> > > > On Fri, May 26, 2023 at 1:46=E2=80=AFPM Liang Chen <liangchen.linux=
@gmail.com> wrote:
> > > > >
> > > > > The implementation at the moment uses one page per packet in both=
 the
> > > > > normal and XDP path.
> > > >
> > > > It's better to explain why we need a page pool and how it can help =
the
> > > > performance.
> > > >
> > >
> > > Sure, I will include that on v2.
> > > > > In addition, introducing a module parameter to enable
> > > > > or disable the usage of page pool (disabled by default).
> > > >
> > > > If page pool wins for most of the cases, any reason to disable it b=
y default?
> > > >
> > >
> > > Thank you for raising the point. It does make sense to enable it by d=
efault.
> >
> > I'd like to see more benchmarks pls then, with a variety of packet
> > sizes, udp and tcp.
> >
>
> Sure, more benchmarks will be provided. Thanks.


I think so.

I did this, but I did not found any improve. So I gave up it.

Thanks.


>
>
> > > > >
> > > > > In single-core vm testing environments, it gives a modest perform=
ance gain
> > > > > in the normal path.
> > > > >   Upstream codebase: 47.5 Gbits/sec
> > > > >   Upstream codebase + page_pool support: 50.2 Gbits/sec
> > > > >
> > > > > In multi-core vm testing environments, The most significant perfo=
rmance
> > > > > gain is observed in XDP cpumap:
> > > > >   Upstream codebase: 1.38 Gbits/sec
> > > > >   Upstream codebase + page_pool support: 9.74 Gbits/sec
> > > >
> > > > Please show more details on the test. E.g which kinds of tests have
> > > > you measured?
> > > >
> > > > Btw, it would be better to measure PPS as well.
> > > >
> > >
> > > Sure. It will be added on v2.
> > > > >
> > > > > With this foundation, we can further integrate page pool fragment=
ation and
> > > > > DMA map/unmap support.
> > > > >
> > > > > Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 188 ++++++++++++++++++++++++++++++---=
------
> > > >
> > > > I believe we should make virtio-net to select CONFIG_PAGE_POOL or do
> > > > the ifdef tricks at least.
> > > >
> > >
> > > Sure. it will be done on v2.
> > > > >  1 file changed, 146 insertions(+), 42 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index c5dca0d92e64..99c0ca0c1781 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -31,6 +31,9 @@ module_param(csum, bool, 0444);
> > > > >  module_param(gso, bool, 0444);
> > > > >  module_param(napi_tx, bool, 0644);
> > > > >
> > > > > +static bool page_pool_enabled;
> > > > > +module_param(page_pool_enabled, bool, 0400);
> > > > > +
> > > > >  /* FIXME: MTU in config. */
> > > > >  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> > > > >  #define GOOD_COPY_LEN  128
> > > > > @@ -159,6 +162,9 @@ struct receive_queue {
> > > > >         /* Chain pages by the private ptr. */
> > > > >         struct page *pages;
> > > > >
> > > > > +       /* Page pool */
> > > > > +       struct page_pool *page_pool;
> > > > > +
> > > > >         /* Average packet length for mergeable receive buffers. */
> > > > >         struct ewma_pkt_len mrg_avg_pkt_len;
> > > > >
> > > > > @@ -459,6 +465,14 @@ static struct sk_buff *virtnet_build_skb(voi=
d *buf, unsigned int buflen,
> > > > >         return skb;
> > > > >  }
> > > > >
> > > > > +static void virtnet_put_page(struct receive_queue *rq, struct pa=
ge *page)
> > > > > +{
> > > > > +       if (rq->page_pool)
> > > > > +               page_pool_put_full_page(rq->page_pool, page, true=
);
> > > > > +       else
> > > > > +               put_page(page);
> > > > > +}
> > > > > +
> > > > >  /* Called from bottom half context */
> > > > >  static struct sk_buff *page_to_skb(struct virtnet_info *vi,
> > > > >                                    struct receive_queue *rq,
> > > > > @@ -555,7 +569,7 @@ static struct sk_buff *page_to_skb(struct vir=
tnet_info *vi,
> > > > >         hdr =3D skb_vnet_hdr(skb);
> > > > >         memcpy(hdr, hdr_p, hdr_len);
> > > > >         if (page_to_free)
> > > > > -               put_page(page_to_free);
> > > > > +               virtnet_put_page(rq, page_to_free);
> > > > >
> > > > >         return skb;
> > > > >  }
> > > > > @@ -802,7 +816,7 @@ static int virtnet_xdp_xmit(struct net_device=
 *dev,
> > > > >         return ret;
> > > > >  }
> > > > >
> > > > > -static void put_xdp_frags(struct xdp_buff *xdp)
> > > > > +static void put_xdp_frags(struct xdp_buff *xdp, struct receive_q=
ueue *rq)
> > > > >  {
> > > >
> > > > rq could be fetched from xdp_rxq_info?
> > >
> > > Yeah, it has the queue_index there.
> > > >
> > > > >         struct skb_shared_info *shinfo;
> > > > >         struct page *xdp_page;
> > > > > @@ -812,7 +826,7 @@ static void put_xdp_frags(struct xdp_buff *xd=
p)
> > > > >                 shinfo =3D xdp_get_shared_info_from_buff(xdp);
> > > > >                 for (i =3D 0; i < shinfo->nr_frags; i++) {
> > > > >                         xdp_page =3D skb_frag_page(&shinfo->frags=
[i]);
> > > > > -                       put_page(xdp_page);
> > > > > +                       virtnet_put_page(rq, xdp_page);
> > > > >                 }
> > > > >         }
> > > > >  }
> > > > > @@ -903,7 +917,11 @@ static struct page *xdp_linearize_page(struc=
t receive_queue *rq,
> > > > >         if (page_off + *len + tailroom > PAGE_SIZE)
> > > > >                 return NULL;
> > > > >
> > > > > -       page =3D alloc_page(GFP_ATOMIC);
> > > > > +       if (rq->page_pool)
> > > > > +               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > > > > +       else
> > > > > +               page =3D alloc_page(GFP_ATOMIC);
> > > > > +
> > > > >         if (!page)
> > > > >                 return NULL;
> > > > >
> > > > > @@ -926,21 +944,24 @@ static struct page *xdp_linearize_page(stru=
ct receive_queue *rq,
> > > > >                  * is sending packet larger than the MTU.
> > > > >                  */
> > > > >                 if ((page_off + buflen + tailroom) > PAGE_SIZE) {
> > > > > -                       put_page(p);
> > > > > +                       virtnet_put_page(rq, p);
> > > > >                         goto err_buf;
> > > > >                 }
> > > > >
> > > > >                 memcpy(page_address(page) + page_off,
> > > > >                        page_address(p) + off, buflen);
> > > > >                 page_off +=3D buflen;
> > > > > -               put_page(p);
> > > > > +               virtnet_put_page(rq, p);
> > > > >         }
> > > > >
> > > > >         /* Headroom does not contribute to packet length */
> > > > >         *len =3D page_off - VIRTIO_XDP_HEADROOM;
> > > > >         return page;
> > > > >  err_buf:
> > > > > -       __free_pages(page, 0);
> > > > > +       if (rq->page_pool)
> > > > > +               page_pool_put_full_page(rq->page_pool, page, true=
);
> > > > > +       else
> > > > > +               __free_pages(page, 0);
> > > > >         return NULL;
> > > > >  }
> > > > >
> > > > > @@ -1144,7 +1165,7 @@ static void mergeable_buf_free(struct recei=
ve_queue *rq, int num_buf,
> > > > >                 }
> > > > >                 stats->bytes +=3D len;
> > > > >                 page =3D virt_to_head_page(buf);
> > > > > -               put_page(page);
> > > > > +               virtnet_put_page(rq, page);
> > > > >         }
> > > > >  }
> > > > >
> > > > > @@ -1264,7 +1285,7 @@ static int virtnet_build_xdp_buff_mrg(struc=
t net_device *dev,
> > > > >                 cur_frag_size =3D truesize;
> > > > >                 xdp_frags_truesz +=3D cur_frag_size;
> > > > >                 if (unlikely(len > truesize - room || cur_frag_si=
ze > PAGE_SIZE)) {
> > > > > -                       put_page(page);
> > > > > +                       virtnet_put_page(rq, page);
> > > > >                         pr_debug("%s: rx error: len %u exceeds tr=
uesize %lu\n",
> > > > >                                  dev->name, len, (unsigned long)(=
truesize - room));
> > > > >                         dev->stats.rx_length_errors++;
> > > > > @@ -1283,7 +1304,7 @@ static int virtnet_build_xdp_buff_mrg(struc=
t net_device *dev,
> > > > >         return 0;
> > > > >
> > > > >  err:
> > > > > -       put_xdp_frags(xdp);
> > > > > +       put_xdp_frags(xdp, rq);
> > > > >         return -EINVAL;
> > > > >  }
> > > > >
> > > > > @@ -1344,7 +1365,10 @@ static void *mergeable_xdp_get_buf(struct =
virtnet_info *vi,
> > > > >                 if (*len + xdp_room > PAGE_SIZE)
> > > > >                         return NULL;
> > > > >
> > > > > -               xdp_page =3D alloc_page(GFP_ATOMIC);
> > > > > +               if (rq->page_pool)
> > > > > +                       xdp_page =3D page_pool_dev_alloc_pages(rq=
->page_pool);
> > > > > +               else
> > > > > +                       xdp_page =3D alloc_page(GFP_ATOMIC);
> > > > >                 if (!xdp_page)
> > > > >                         return NULL;
> > > > >
> > > > > @@ -1354,7 +1378,7 @@ static void *mergeable_xdp_get_buf(struct v=
irtnet_info *vi,
> > > > >
> > > > >         *frame_sz =3D PAGE_SIZE;
> > > > >
> > > > > -       put_page(*page);
> > > > > +       virtnet_put_page(rq, *page);
> > > > >
> > > > >         *page =3D xdp_page;
> > > > >
> > > > > @@ -1400,6 +1424,8 @@ static struct sk_buff *receive_mergeable_xd=
p(struct net_device *dev,
> > > > >                 head_skb =3D build_skb_from_xdp_buff(dev, vi, &xd=
p, xdp_frags_truesz);
> > > > >                 if (unlikely(!head_skb))
> > > > >                         break;
> > > > > +               if (rq->page_pool)
> > > > > +                       skb_mark_for_recycle(head_skb);
> > > > >                 return head_skb;
> > > > >
> > > > >         case XDP_TX:
> > > > > @@ -1410,10 +1436,10 @@ static struct sk_buff *receive_mergeable_=
xdp(struct net_device *dev,
> > > > >                 break;
> > > > >         }
> > > > >
> > > > > -       put_xdp_frags(&xdp);
> > > > > +       put_xdp_frags(&xdp, rq);
> > > > >
> > > > >  err_xdp:
> > > > > -       put_page(page);
> > > > > +       virtnet_put_page(rq, page);
> > > > >         mergeable_buf_free(rq, num_buf, dev, stats);
> > > > >
> > > > >         stats->xdp_drops++;
> > > > > @@ -1467,6 +1493,9 @@ static struct sk_buff *receive_mergeable(st=
ruct net_device *dev,
> > > > >         head_skb =3D page_to_skb(vi, rq, page, offset, len, trues=
ize, headroom);
> > > > >         curr_skb =3D head_skb;
> > > > >
> > > > > +       if (rq->page_pool)
> > > > > +               skb_mark_for_recycle(curr_skb);
> > > > > +
> > > > >         if (unlikely(!curr_skb))
> > > > >                 goto err_skb;
> > > > >         while (--num_buf) {
> > > > > @@ -1509,6 +1538,8 @@ static struct sk_buff *receive_mergeable(st=
ruct net_device *dev,
> > > > >                         curr_skb =3D nskb;
> > > > >                         head_skb->truesize +=3D nskb->truesize;
> > > > >                         num_skb_frags =3D 0;
> > > > > +                       if (rq->page_pool)
> > > > > +                               skb_mark_for_recycle(curr_skb);
> > > > >                 }
> > > > >                 if (curr_skb !=3D head_skb) {
> > > > >                         head_skb->data_len +=3D len;
> > > > > @@ -1517,7 +1548,7 @@ static struct sk_buff *receive_mergeable(st=
ruct net_device *dev,
> > > > >                 }
> > > > >                 offset =3D buf - page_address(page);
> > > > >                 if (skb_can_coalesce(curr_skb, num_skb_frags, pag=
e, offset)) {
> > > > > -                       put_page(page);
> > > > > +                       virtnet_put_page(rq, page);
> > > >
> > > > I wonder why not we can't do this during buffer allocation like oth=
er drivers?
> > > >
> > >
> > > Sorry, I don't quite understand the point here. Would you please
> > > elaborate a bit more?
> > > > >                         skb_coalesce_rx_frag(curr_skb, num_skb_fr=
ags - 1,
> > > > >                                              len, truesize);
> > > > >                 } else {
> > > > > @@ -1530,7 +1561,7 @@ static struct sk_buff *receive_mergeable(st=
ruct net_device *dev,
> > > > >         return head_skb;
> > > > >
> > > > >  err_skb:
> > > > > -       put_page(page);
> > > > > +       virtnet_put_page(rq, page);
> > > > >         mergeable_buf_free(rq, num_buf, dev, stats);
> > > > >
> > > > >  err_buf:
> > > > > @@ -1737,31 +1768,40 @@ static int add_recvbuf_mergeable(struct v=
irtnet_info *vi,
> > > > >          * disabled GSO for XDP, it won't be a big issue.
> > > > >          */
> > > > >         len =3D get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, r=
oom);
> > > > > -       if (unlikely(!skb_page_frag_refill(len + room, alloc_frag=
, gfp)))
> > > > > -               return -ENOMEM;
> > > > > +       if (rq->page_pool) {
> > > > > +               struct page *page;
> > > > >
> > > > > -       buf =3D (char *)page_address(alloc_frag->page) + alloc_fr=
ag->offset;
> > > > > -       buf +=3D headroom; /* advance address leaving hole at fro=
nt of pkt */
> > > > > -       get_page(alloc_frag->page);
> > > > > -       alloc_frag->offset +=3D len + room;
> > > > > -       hole =3D alloc_frag->size - alloc_frag->offset;
> > > > > -       if (hole < len + room) {
> > > > > -               /* To avoid internal fragmentation, if there is v=
ery likely not
> > > > > -                * enough space for another buffer, add the remai=
ning space to
> > > > > -                * the current buffer.
> > > > > -                * XDP core assumes that frame_size of xdp_buff a=
nd the length
> > > > > -                * of the frag are PAGE_SIZE, so we disable the h=
ole mechanism.
> > > > > -                */
> > > > > -               if (!headroom)
> > > > > -                       len +=3D hole;
> > > > > -               alloc_frag->offset +=3D hole;
> > > > > -       }
> > > > > +               page =3D page_pool_dev_alloc_pages(rq->page_pool);
> > > > > +               if (unlikely(!page))
> > > > > +                       return -ENOMEM;
> > > > > +               buf =3D (char *)page_address(page);
> > > > > +               buf +=3D headroom; /* advance address leaving hol=
e at front of pkt */
> > > > > +       } else {
> > > > > +               if (unlikely(!skb_page_frag_refill(len + room, al=
loc_frag, gfp)))
> > > >
> > > > Why not simply use a helper like virtnet_page_frag_refill() and add
> > > > the page_pool allocation logic there? It helps to reduce the
> > > > changeset.
> > > >
> > >
> > > Sure. Will do that on v2.
> > > > > +                       return -ENOMEM;
> > > > >
> > > > > +               buf =3D (char *)page_address(alloc_frag->page) + =
alloc_frag->offset;
> > > > > +               buf +=3D headroom; /* advance address leaving hol=
e at front of pkt */
> > > > > +               get_page(alloc_frag->page);
> > > > > +               alloc_frag->offset +=3D len + room;
> > > > > +               hole =3D alloc_frag->size - alloc_frag->offset;
> > > > > +               if (hole < len + room) {
> > > > > +                       /* To avoid internal fragmentation, if th=
ere is very likely not
> > > > > +                        * enough space for another buffer, add t=
he remaining space to
> > > > > +                        * the current buffer.
> > > > > +                        * XDP core assumes that frame_size of xd=
p_buff and the length
> > > > > +                        * of the frag are PAGE_SIZE, so we disab=
le the hole mechanism.
> > > > > +                        */
> > > > > +                       if (!headroom)
> > > > > +                               len +=3D hole;
> > > > > +                       alloc_frag->offset +=3D hole;
> > > > > +               }
> > > > > +       }
> > > > >         sg_init_one(rq->sg, buf, len);
> > > > >         ctx =3D mergeable_len_to_ctx(len + room, headroom);
> > > > >         err =3D virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, c=
tx, gfp);
> > > > >         if (err < 0)
> > > > > -               put_page(virt_to_head_page(buf));
> > > > > +               virtnet_put_page(rq, virt_to_head_page(buf));
> > > > >
> > > > >         return err;
> > > > >  }
> > > > > @@ -1994,8 +2034,15 @@ static int virtnet_enable_queue_pair(struc=
t virtnet_info *vi, int qp_index)
> > > > >         if (err < 0)
> > > > >                 return err;
> > > > >
> > > > > -       err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_=
rxq,
> > > > > -                                        MEM_TYPE_PAGE_SHARED, NU=
LL);
> > > > > +       if (vi->rq[qp_index].page_pool)
> > > > > +               err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_ind=
ex].xdp_rxq,
> > > > > +                                                MEM_TYPE_PAGE_PO=
OL,
> > > > > +                                                vi->rq[qp_index]=
.page_pool);
> > > > > +       else
> > > > > +               err =3D xdp_rxq_info_reg_mem_model(&vi->rq[qp_ind=
ex].xdp_rxq,
> > > > > +                                                MEM_TYPE_PAGE_SH=
ARED,
> > > > > +                                                NULL);
> > > > > +
> > > > >         if (err < 0)
> > > > >                 goto err_xdp_reg_mem_model;
> > > > >
> > > > > @@ -2951,6 +2998,7 @@ static void virtnet_get_strings(struct net_=
device *dev, u32 stringset, u8 *data)
> > > > >                                 ethtool_sprintf(&p, "tx_queue_%u_=
%s", i,
> > > > >                                                 virtnet_sq_stats_=
desc[j].desc);
> > > > >                 }
> > > > > +               page_pool_ethtool_stats_get_strings(p);
> > > > >                 break;
> > > > >         }
> > > > >  }
> > > > > @@ -2962,12 +3010,30 @@ static int virtnet_get_sset_count(struct =
net_device *dev, int sset)
> > > > >         switch (sset) {
> > > > >         case ETH_SS_STATS:
> > > > >                 return vi->curr_queue_pairs * (VIRTNET_RQ_STATS_L=
EN +
> > > > > -                                              VIRTNET_SQ_STATS_L=
EN);
> > > > > +                                              VIRTNET_SQ_STATS_L=
EN +
> > > > > +                                               (page_pool_enable=
d && vi->mergeable_rx_bufs ?
> > > > > +                                                page_pool_ethtoo=
l_stats_get_count() : 0));
> > > > >         default:
> > > > >                 return -EOPNOTSUPP;
> > > > >         }
> > > > >  }
> > > > >
> > > > > +static void virtnet_get_page_pool_stats(struct net_device *dev, =
u64 *data)
> > > > > +{
> > > > > +#ifdef CONFIG_PAGE_POOL_STATS
> > > > > +       struct virtnet_info *vi =3D netdev_priv(dev);
> > > > > +       struct page_pool_stats pp_stats =3D {};
> > > > > +       int i;
> > > > > +
> > > > > +       for (i =3D 0; i < vi->curr_queue_pairs; i++) {
> > > > > +               if (!vi->rq[i].page_pool)
> > > > > +                       continue;
> > > > > +               page_pool_get_stats(vi->rq[i].page_pool, &pp_stat=
s);
> > > > > +       }
> > > > > +       page_pool_ethtool_stats_get(data, &pp_stats);
> > > > > +#endif /* CONFIG_PAGE_POOL_STATS */
> > > > > +}
> > > > > +
> > > > >  static void virtnet_get_ethtool_stats(struct net_device *dev,
> > > > >                                       struct ethtool_stats *stats=
, u64 *data)
> > > > >  {
> > > > > @@ -3003,6 +3069,8 @@ static void virtnet_get_ethtool_stats(struc=
t net_device *dev,
> > > > >                 } while (u64_stats_fetch_retry(&sq->stats.syncp, =
start));
> > > > >                 idx +=3D VIRTNET_SQ_STATS_LEN;
> > > > >         }
> > > > > +
> > > > > +       virtnet_get_page_pool_stats(dev, &data[idx]);
> > > > >  }
> > > > >
> > > > >  static void virtnet_get_channels(struct net_device *dev,
> > > > > @@ -3623,6 +3691,8 @@ static void virtnet_free_queues(struct virt=
net_info *vi)
> > > > >         for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > > > >                 __netif_napi_del(&vi->rq[i].napi);
> > > > >                 __netif_napi_del(&vi->sq[i].napi);
> > > > > +               if (vi->rq[i].page_pool)
> > > > > +                       page_pool_destroy(vi->rq[i].page_pool);
> > > > >         }
> > > > >
> > > > >         /* We called __netif_napi_del(),
> > > > > @@ -3679,12 +3749,19 @@ static void virtnet_rq_free_unused_buf(st=
ruct virtqueue *vq, void *buf)
> > > > >         struct virtnet_info *vi =3D vq->vdev->priv;
> > > > >         int i =3D vq2rxq(vq);
> > > > >
> > > > > -       if (vi->mergeable_rx_bufs)
> > > > > -               put_page(virt_to_head_page(buf));
> > > > > -       else if (vi->big_packets)
> > > > > +       if (vi->mergeable_rx_bufs) {
> > > > > +               if (vi->rq[i].page_pool) {
> > > > > +                       page_pool_put_full_page(vi->rq[i].page_po=
ol,
> > > > > +                                               virt_to_head_page=
(buf),
> > > > > +                                               true);
> > > > > +               } else {
> > > > > +                       put_page(virt_to_head_page(buf));
> > > > > +               }
> > > > > +       } else if (vi->big_packets) {
> > > > >                 give_pages(&vi->rq[i], buf);
> > > >
> > > > Any reason only mergeable were modified but not for small and big?
> > > >
> > > > Thanks
> > > >
> > >
> > > Big mode uses the page chain to recycle pages, thus the using of
> > > "private" of the buffer page. I will take further look into that to
> > > see if it is better to use page pool in these cases. Thanks!
> > >
> > >
> > >
> > > > > -       else
> > > > > +       } else {
> > > > >                 put_page(virt_to_head_page(buf));
> > > > > +       }
> > > > >  }
> > > > >
> > > > >  static void free_unused_bufs(struct virtnet_info *vi)
> > > > > @@ -3718,6 +3795,26 @@ static void virtnet_del_vqs(struct virtnet=
_info *vi)
> > > > >         virtnet_free_queues(vi);
> > > > >  }
> > > > >
> > > > > +static void virtnet_alloc_page_pool(struct receive_queue *rq)
> > > > > +{
> > > > > +       struct virtio_device *vdev =3D rq->vq->vdev;
> > > > > +
> > > > > +       struct page_pool_params pp_params =3D {
> > > > > +               .order =3D 0,
> > > > > +               .pool_size =3D rq->vq->num_max,
> > > > > +               .nid =3D dev_to_node(vdev->dev.parent),
> > > > > +               .dev =3D vdev->dev.parent,
> > > > > +               .offset =3D 0,
> > > > > +       };
> > > > > +
> > > > > +       rq->page_pool =3D page_pool_create(&pp_params);
> > > > > +       if (IS_ERR(rq->page_pool)) {
> > > > > +               dev_warn(&vdev->dev, "page pool creation failed: =
%ld\n",
> > > > > +                        PTR_ERR(rq->page_pool));
> > > > > +               rq->page_pool =3D NULL;
> > > > > +       }
> > > > > +}
> > > > > +
> > > > >  /* How large should a single buffer be so a queue full of these =
can fit at
> > > > >   * least one full packet?
> > > > >   * Logic below assumes the mergeable buffer header is used.
> > > > > @@ -3801,6 +3898,13 @@ static int virtnet_find_vqs(struct virtnet=
_info *vi)
> > > > >                 vi->rq[i].vq =3D vqs[rxq2vq(i)];
> > > > >                 vi->rq[i].min_buf_len =3D mergeable_min_buf_len(v=
i, vi->rq[i].vq);
> > > > >                 vi->sq[i].vq =3D vqs[txq2vq(i)];
> > > > > +
> > > > > +               if (page_pool_enabled && vi->mergeable_rx_bufs)
> > > > > +                       virtnet_alloc_page_pool(&vi->rq[i]);
> > > > > +               else
> > > > > +                       dev_warn(&vi->vdev->dev,
> > > > > +                                "page pool only support mergeabl=
e mode\n");
> > > > > +
> > > > >         }
> > > > >
> > > > >         /* run here: ret =3D=3D 0. */
> > > > > --
> > > > > 2.31.1
> > > > >
> > > >
> >

