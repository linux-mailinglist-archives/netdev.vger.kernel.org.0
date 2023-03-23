Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44AA6C5D68
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjCWDq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjCWDqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:46:25 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463C92C677;
        Wed, 22 Mar 2023 20:46:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VeShdPK_1679543179;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeShdPK_1679543179)
          by smtp.aliyun-inc.com;
          Thu, 23 Mar 2023 11:46:19 +0800
Message-ID: <1679543111.9544318-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 1/8] virtio_net: mergeable xdp: put old page immediately
Date:   Thu, 23 Mar 2023 11:45:11 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
 <20230322030308.16046-2-xuanzhuo@linux.alibaba.com>
 <4bd07874-b1ad-336b-b15e-ba56a10182e9@huawei.com>
 <1679535365.5410192-1-xuanzhuo@linux.alibaba.com>
 <941a16c5-ba64-ca49-9af9-68d9615dca00@huawei.com>
In-Reply-To: <941a16c5-ba64-ca49-9af9-68d9615dca00@huawei.com>
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

On Thu, 23 Mar 2023 11:38:34 +0800, Yunsheng Lin <linyunsheng@huawei.com> w=
rote:
> On 2023/3/23 9:36, Xuan Zhuo wrote:
> > On Wed, 22 Mar 2023 16:22:18 +0800, Yunsheng Lin <linyunsheng@huawei.co=
m> wrote:
> >> On 2023/3/22 11:03, Xuan Zhuo wrote:
> >>> In the xdp implementation of virtio-net mergeable, it always checks
> >>> whether two page is used and a page is selected to release. This is
> >>> complicated for the processing of action, and be careful.
> >>>
> >>> In the entire process, we have such principles:
> >>> * If xdp_page is used (PASS, TX, Redirect), then we release the old
> >>>   page.
> >>> * If it is a drop case, we will release two. The old page obtained fr=
om
> >>>   buf is release inside err_xdp, and xdp_page needs be relased by us.
> >>>
> >>> But in fact, when we allocate a new page, we can release the old page
> >>> immediately. Then just one is using, we just need to release the new
> >>> page for drop case. On the drop path, err_xdp will release the variab=
le
> >>> "page", so we only need to let "page" point to the new xdp_page in
> >>> advance.
> >>>
> >>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >>> ---
> >>>  drivers/net/virtio_net.c | 15 ++++++---------
> >>>  1 file changed, 6 insertions(+), 9 deletions(-)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index e2560b6f7980..4d2bf1ce0730 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -1245,6 +1245,9 @@ static struct sk_buff *receive_mergeable(struct=
 net_device *dev,
> >>>  			if (!xdp_page)
> >>>  				goto err_xdp;
> >>>  			offset =3D VIRTIO_XDP_HEADROOM;
> >>> +
> >>> +			put_page(page);
> >>
> >> the error handling of xdp_linearize_page() does not seems self contain=
ed.
> >> Does it not seem better=EF=BC=9A
> >> 1. if xdp_linearize_page() succesed, call put_page() for first buffer =
just
> >>    as put_page() is call for other buffer
> >> 2. or call virtqueue_get_buf() and put_page() for all the buffer of th=
e packet
> >>    so the error handling is not needed outside the virtqueue_get_buf().
> >>
> >> In that case, it seems we can just do below without xdp_page:
> >> page =3D xdp_linearize_page(rq, num_buf, page, ...);
> >
> >
> > This does look better.
> >
> > In fact, we already have vq reset, we can load XDP based on vq reset.
> > In this way, we can run without xdp_linearize_page.
>
> For compatibility, it is still needed, right?

Yes


>
> >
> >
> >>
> >>
> >>> +			page =3D xdp_page;
> >>>  		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> >>>  			xdp_room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> >>>  						  sizeof(struct skb_shared_info));
> >>> @@ -1259,6 +1262,9 @@ static struct sk_buff *receive_mergeable(struct=
 net_device *dev,
> >>>  			       page_address(page) + offset, len);
> >>>  			frame_sz =3D PAGE_SIZE;
> >>>  			offset =3D VIRTIO_XDP_HEADROOM;
> >>> +
> >>> +			put_page(page);
> >>> +			page =3D xdp_page;
> >>
> >> It seems we can limit the scope of xdp_page in this "else if" block.
> >>
> >>>  		} else {
> >>>  			xdp_page =3D page;
> >>>  		}
> >>
> >> It seems the above else block is not needed anymore.
> >
> > Yes, the follow-up patch has this optimization.
>
> Isn't refoctor patch supposed to be self-contianed too, instead of
> depending on follow-up patch?


I mean that the #2 patch do this.

Thanks.
