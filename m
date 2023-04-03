Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6558D6D3C53
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 06:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbjDCEL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 00:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjDCELx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 00:11:53 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BE583F7;
        Sun,  2 Apr 2023 21:11:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfB1fOn_1680495103;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VfB1fOn_1680495103)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 12:11:44 +0800
Message-ID: <1680495091.0610447-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 1/8] virtio_net: mergeable xdp: put old page immediately
Date:   Mon, 3 Apr 2023 12:11:31 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
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
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-2-xuanzhuo@linux.alibaba.com>
 <CACGkMEseX1+oi+unZspnGzPduQc-tFkxpVg+9KfEhPSWWqCTrg@mail.gmail.com>
In-Reply-To: <CACGkMEseX1+oi+unZspnGzPduQc-tFkxpVg+9KfEhPSWWqCTrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 17:01:54 +0800, Jason Wang <jasowang@redhat.com> wrote:
> On Tue, Mar 28, 2023 at 8:04=E2=80=AFPM Xuan Zhuo <xuanzhuo@linux.alibaba=
.com> wrote:
> >
> > In the xdp implementation of virtio-net mergeable, it always checks
> > whether two page is used and a page is selected to release. This is
> > complicated for the processing of action, and be careful.
> >
> > In the entire process, we have such principles:
> > * If xdp_page is used (PASS, TX, Redirect), then we release the old
> >   page.
> > * If it is a drop case, we will release two. The old page obtained from
> >   buf is release inside err_xdp, and xdp_page needs be relased by us.
> >
> > But in fact, when we allocate a new page, we can release the old page
> > immediately. Then just one is using, we just need to release the new
> > page for drop case. On the drop path, err_xdp will release the variable
> > "page", so we only need to let "page" point to the new xdp_page in
> > advance.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >  drivers/net/virtio_net.c | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index e2560b6f7980..4d2bf1ce0730 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1245,6 +1245,9 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                         if (!xdp_page)
> >                                 goto err_xdp;
> >                         offset =3D VIRTIO_XDP_HEADROOM;
> > +
> > +                       put_page(page);
> > +                       page =3D xdp_page;
> >                 } else if (unlikely(headroom < virtnet_get_headroom(vi)=
)) {
> >                         xdp_room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM=
 +
> >                                                   sizeof(struct skb_sha=
red_info));
> > @@ -1259,6 +1262,9 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                                page_address(page) + offset, len);
> >                         frame_sz =3D PAGE_SIZE;
> >                         offset =3D VIRTIO_XDP_HEADROOM;
> > +
> > +                       put_page(page);
> > +                       page =3D xdp_page;
> >                 } else {
> >                         xdp_page =3D page;
> >                 }
>
> While at this I would go a little further, just remove the above
> assignment then we can use:
>
>                 data =3D page_address(page) + offset;
>
> Which seems cleaner?

I will try.

Thanks.


>
> Thanks
>
> > @@ -1278,8 +1284,6 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                         if (unlikely(!head_skb))
> >                                 goto err_xdp_frags;
> >
> > -                       if (unlikely(xdp_page !=3D page))
> > -                               put_page(page);
> >                         rcu_read_unlock();
> >                         return head_skb;
> >                 case XDP_TX:
> > @@ -1297,8 +1301,6 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                                 goto err_xdp_frags;
> >                         }
> >                         *xdp_xmit |=3D VIRTIO_XDP_TX;
> > -                       if (unlikely(xdp_page !=3D page))
> > -                               put_page(page);
> >                         rcu_read_unlock();
> >                         goto xdp_xmit;
> >                 case XDP_REDIRECT:
> > @@ -1307,8 +1309,6 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                         if (err)
> >                                 goto err_xdp_frags;
> >                         *xdp_xmit |=3D VIRTIO_XDP_REDIR;
> > -                       if (unlikely(xdp_page !=3D page))
> > -                               put_page(page);
> >                         rcu_read_unlock();
> >                         goto xdp_xmit;
> >                 default:
> > @@ -1321,9 +1321,6 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >                         goto err_xdp_frags;
> >                 }
> >  err_xdp_frags:
> > -               if (unlikely(xdp_page !=3D page))
> > -                       __free_pages(xdp_page, 0);
> > -
> >                 if (xdp_buff_has_frags(&xdp)) {
> >                         shinfo =3D xdp_get_shared_info_from_buff(&xdp);
> >                         for (i =3D 0; i < shinfo->nr_frags; i++) {
> > --
> > 2.32.0.3.g01195cf9f
> >
>
