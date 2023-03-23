Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC346C5F3B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjCWF6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCWF6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:58:50 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA382410B;
        Wed, 22 Mar 2023 22:58:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VeTApVT_1679551122;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeTApVT_1679551122)
          by smtp.aliyun-inc.com;
          Thu, 23 Mar 2023 13:58:43 +0800
Message-ID: <1679551089.625654-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 1/8] virtio_net: mergeable xdp: put old page immediately
Date:   Thu, 23 Mar 2023 13:58:09 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
 <20230322030308.16046-2-xuanzhuo@linux.alibaba.com>
 <4bd07874-b1ad-336b-b15e-ba56a10182e9@huawei.com>
 <1679535365.5410192-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEvS7N1tXFD2-2n2upY15JF6=0uaAebewsP8=K+Cwbtgsg@mail.gmail.com>
In-Reply-To: <CACGkMEvS7N1tXFD2-2n2upY15JF6=0uaAebewsP8=K+Cwbtgsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 13:38:30 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Thu, Mar 23, 2023 at 9:43=E2=80=AFAM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > On Wed, 22 Mar 2023 16:22:18 +0800, Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
> > > On 2023/3/22 11:03, Xuan Zhuo wrote:
> > > > In the xdp implementation of virtio-net mergeable, it always checks
> > > > whether two page is used and a page is selected to release. This is
> > > > complicated for the processing of action, and be careful.
> > > >
> > > > In the entire process, we have such principles:
> > > > * If xdp_page is used (PASS, TX, Redirect), then we release the old
> > > >   page.
> > > > * If it is a drop case, we will release two. The old page obtained =
from
> > > >   buf is release inside err_xdp, and xdp_page needs be relased by u=
s.
> > > >
> > > > But in fact, when we allocate a new page, we can release the old pa=
ge
> > > > immediately. Then just one is using, we just need to release the new
> > > > page for drop case. On the drop path, err_xdp will release the vari=
able
> > > > "page", so we only need to let "page" point to the new xdp_page in
> > > > advance.
> > > >
> > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > ---
> > > >  drivers/net/virtio_net.c | 15 ++++++---------
> > > >  1 file changed, 6 insertions(+), 9 deletions(-)
> > > >
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index e2560b6f7980..4d2bf1ce0730 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -1245,6 +1245,9 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >                     if (!xdp_page)
> > > >                             goto err_xdp;
> > > >                     offset =3D VIRTIO_XDP_HEADROOM;
> > > > +
> > > > +                   put_page(page);
> > >
> > > the error handling of xdp_linearize_page() does not seems self contai=
ned.
> > > Does it not seem better=EF=BC=9A
> > > 1. if xdp_linearize_page() succesed, call put_page() for first buffer=
 just
> > >    as put_page() is call for other buffer
> > > 2. or call virtqueue_get_buf() and put_page() for all the buffer of t=
he packet
> > >    so the error handling is not needed outside the virtqueue_get_buf(=
).
> > >
> > > In that case, it seems we can just do below without xdp_page:
> > > page =3D xdp_linearize_page(rq, num_buf, page, ...);
> >
> >
> > This does look better.
> >
> > In fact, we already have vq reset, we can load XDP based on vq reset.
> > In this way, we can run without xdp_linearize_page.
>
> The goal is to try our best not to drop packets, so I think it's
> better to keep it.


Yes. vq reset may drop some packets.

Thanks.

>
> Thanks
>
> >
> >
> > >
> > >
> > > > +                   page =3D xdp_page;
> > > >             } else if (unlikely(headroom < virtnet_get_headroom(vi)=
)) {
> > > >                     xdp_room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM=
 +
> > > >                                               sizeof(struct skb_sha=
red_info));
> > > > @@ -1259,6 +1262,9 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >                            page_address(page) + offset, len);
> > > >                     frame_sz =3D PAGE_SIZE;
> > > >                     offset =3D VIRTIO_XDP_HEADROOM;
> > > > +
> > > > +                   put_page(page);
> > > > +                   page =3D xdp_page;
> > >
> > > It seems we can limit the scope of xdp_page in this "else if" block.
> > >
> > > >             } else {
> > > >                     xdp_page =3D page;
> > > >             }
> > >
> > > It seems the above else block is not needed anymore.
> >
> > Yes, the follow-up patch has this optimization.
> >
> >
> > >
> > > > @@ -1278,8 +1284,6 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >                     if (unlikely(!head_skb))
> > > >                             goto err_xdp_frags;
> > > >
> > > > -                   if (unlikely(xdp_page !=3D page))
> > > > -                           put_page(page);
> > > >                     rcu_read_unlock();
> > > >                     return head_skb;
> > > >             case XDP_TX:
> > > > @@ -1297,8 +1301,6 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >                             goto err_xdp_frags;
> > > >                     }
> > > >                     *xdp_xmit |=3D VIRTIO_XDP_TX;
> > > > -                   if (unlikely(xdp_page !=3D page))
> > > > -                           put_page(page);
> > > >                     rcu_read_unlock();
> > > >                     goto xdp_xmit;
> > > >             case XDP_REDIRECT:
> > > > @@ -1307,8 +1309,6 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >                     if (err)
> > > >                             goto err_xdp_frags;
> > > >                     *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> > > > -                   if (unlikely(xdp_page !=3D page))
> > > > -                           put_page(page);
> > > >                     rcu_read_unlock();
> > > >                     goto xdp_xmit;
> > > >             default:
> > > > @@ -1321,9 +1321,6 @@ static struct sk_buff *receive_mergeable(stru=
ct net_device *dev,
> > > >                     goto err_xdp_frags;
> > > >             }
> > > >  err_xdp_frags:
> > > > -           if (unlikely(xdp_page !=3D page))
> > > > -                   __free_pages(xdp_page, 0);
> > >
> > > It seems __free_pages() and put_page() is used interchangeably here.
> > > Perhaps using __free_pages() have performance reason? As the comment =
below:
> > >
> > > https://elixir.bootlin.com/linux/v6.3-rc3/source/net/core/page_pool.c=
#L500
> >
> >
> > Yes, but now we don't seem to be very good to distinguish it. But I thi=
nk
> > it doesn't matter. This logic is rare under actual situation.
> >
> > Thanks.
> >
> >
> > >
> > > > -
> > > >             if (xdp_buff_has_frags(&xdp)) {
> > > >                     shinfo =3D xdp_get_shared_info_from_buff(&xdp);
> > > >                     for (i =3D 0; i < shinfo->nr_frags; i++) {
> > > >
> >
>
