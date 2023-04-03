Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA16D6D3C56
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 06:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjDCEMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 00:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjDCEMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 00:12:07 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27636AF3C;
        Sun,  2 Apr 2023 21:12:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfBP8vX_1680495121;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VfBP8vX_1680495121)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 12:12:02 +0800
Message-ID: <1680495109.5691578-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce mergeable_xdp_prepare
Date:   Mon, 3 Apr 2023 12:11:49 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
References: <20230328120412.110114-1-xuanzhuo@linux.alibaba.com>
 <20230328120412.110114-3-xuanzhuo@linux.alibaba.com>
 <a5b743d1-37d1-1225-c1cb-62cd23d26aef@redhat.com>
In-Reply-To: <a5b743d1-37d1-1225-c1cb-62cd23d26aef@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 17:14:33 +0800, Jason Wang <jasowang@redhat.com> wrote:
>
> =E5=9C=A8 2023/3/28 20:04, Xuan Zhuo =E5=86=99=E9=81=93:
> > Separating the logic of preparation for xdp from receive_mergeable.
> >
> > The purpose of this is to simplify the logic of execution of XDP.
> >
> > The main logic here is that when headroom is insufficient, we need to
> > allocate a new page and calculate offset. It should be noted that if
> > there is new page, the variable page will refer to the new page.
> >
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > ---
> >   drivers/net/virtio_net.c | 135 ++++++++++++++++++++++-----------------
> >   1 file changed, 77 insertions(+), 58 deletions(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 4d2bf1ce0730..bb426958cdd4 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1162,6 +1162,79 @@ static int virtnet_build_xdp_buff_mrg(struct net=
_device *dev,
> >   	return 0;
> >   }
> >
> > +static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> > +				   struct receive_queue *rq,
> > +				   struct bpf_prog *xdp_prog,
> > +				   void *ctx,
> > +				   unsigned int *frame_sz,
> > +				   int *num_buf,
> > +				   struct page **page,
> > +				   int offset,
> > +				   unsigned int *len,
> > +				   struct virtio_net_hdr_mrg_rxbuf *hdr)
> > +{
> > +	unsigned int truesize =3D mergeable_ctx_to_truesize(ctx);
> > +	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
> > +	struct page *xdp_page;
> > +	unsigned int xdp_room;
> > +
> > +	/* Transient failure which in theory could occur if
> > +	 * in-flight packets from before XDP was enabled reach
> > +	 * the receive path after XDP is loaded.
> > +	 */
> > +	if (unlikely(hdr->hdr.gso_type))
> > +		return NULL;
> > +
> > +	/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> > +	 * with headroom may add hole in truesize, which
> > +	 * make their length exceed PAGE_SIZE. So we disabled the
> > +	 * hole mechanism for xdp. See add_recvbuf_mergeable().
> > +	 */
> > +	*frame_sz =3D truesize;
> > +
> > +	/* This happens when headroom is not enough because
> > +	 * of the buffer was prefilled before XDP is set.
> > +	 * This should only happen for the first several packets.
> > +	 * In fact, vq reset can be used here to help us clean up
> > +	 * the prefilled buffers, but many existing devices do not
> > +	 * support it, and we don't want to bother users who are
> > +	 * using xdp normally.
> > +	 */
> > +	if (!xdp_prog->aux->xdp_has_frags &&
> > +	    (*num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> > +		/* linearize data for XDP */
> > +		xdp_page =3D xdp_linearize_page(rq, num_buf,
> > +					      *page, offset,
> > +					      VIRTIO_XDP_HEADROOM,
> > +					      len);
> > +
> > +		if (!xdp_page)
> > +			return NULL;
> > +	} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> > +		xdp_room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> > +					  sizeof(struct skb_shared_info));
> > +		if (*len + xdp_room > PAGE_SIZE)
> > +			return NULL;
> > +
> > +		xdp_page =3D alloc_page(GFP_ATOMIC);
> > +		if (!xdp_page)
> > +			return NULL;
> > +
> > +		memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> > +		       page_address(*page) + offset, *len);
> > +	} else {
> > +		return page_address(*page) + offset;
>
>
> This makes the code a little harder to be read than the original code.
>
> Why not do a verbatim moving without introducing new logic? (Or
> introducing new logic on top?)


Yes. Will fix.

Thanks.

>
> Thanks
>
>
> > +	}
> > +
> > +	*frame_sz =3D PAGE_SIZE;
> > +
> > +	put_page(*page);
> > +
> > +	*page =3D xdp_page;
> > +
> > +	return page_address(xdp_page) + VIRTIO_XDP_HEADROOM;
> > +}
> > +
> >   static struct sk_buff *receive_mergeable(struct net_device *dev,
> >   					 struct virtnet_info *vi,
> >   					 struct receive_queue *rq,
> > @@ -1181,7 +1254,7 @@ static struct sk_buff *receive_mergeable(struct n=
et_device *dev,
> >   	unsigned int headroom =3D mergeable_ctx_to_headroom(ctx);
> >   	unsigned int tailroom =3D headroom ? sizeof(struct skb_shared_info) =
: 0;
> >   	unsigned int room =3D SKB_DATA_ALIGN(headroom + tailroom);
> > -	unsigned int frame_sz, xdp_room;
> > +	unsigned int frame_sz;
> >   	int err;
> >
> >   	head_skb =3D NULL;
> > @@ -1211,65 +1284,11 @@ static struct sk_buff *receive_mergeable(struct=
 net_device *dev,
> >   		u32 act;
> >   		int i;
> >
> > -		/* Transient failure which in theory could occur if
> > -		 * in-flight packets from before XDP was enabled reach
> > -		 * the receive path after XDP is loaded.
> > -		 */
> > -		if (unlikely(hdr->hdr.gso_type))
> > +		data =3D mergeable_xdp_prepare(vi, rq, xdp_prog, ctx, &frame_sz, &nu=
m_buf, &page,
> > +					     offset, &len, hdr);
> > +		if (!data)
> >   			goto err_xdp;
> >
> > -		/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> > -		 * with headroom may add hole in truesize, which
> > -		 * make their length exceed PAGE_SIZE. So we disabled the
> > -		 * hole mechanism for xdp. See add_recvbuf_mergeable().
> > -		 */
> > -		frame_sz =3D truesize;
> > -
> > -		/* This happens when headroom is not enough because
> > -		 * of the buffer was prefilled before XDP is set.
> > -		 * This should only happen for the first several packets.
> > -		 * In fact, vq reset can be used here to help us clean up
> > -		 * the prefilled buffers, but many existing devices do not
> > -		 * support it, and we don't want to bother users who are
> > -		 * using xdp normally.
> > -		 */
> > -		if (!xdp_prog->aux->xdp_has_frags &&
> > -		    (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> > -			/* linearize data for XDP */
> > -			xdp_page =3D xdp_linearize_page(rq, &num_buf,
> > -						      page, offset,
> > -						      VIRTIO_XDP_HEADROOM,
> > -						      &len);
> > -			frame_sz =3D PAGE_SIZE;
> > -
> > -			if (!xdp_page)
> > -				goto err_xdp;
> > -			offset =3D VIRTIO_XDP_HEADROOM;
> > -
> > -			put_page(page);
> > -			page =3D xdp_page;
> > -		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> > -			xdp_room =3D SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> > -						  sizeof(struct skb_shared_info));
> > -			if (len + xdp_room > PAGE_SIZE)
> > -				goto err_xdp;
> > -
> > -			xdp_page =3D alloc_page(GFP_ATOMIC);
> > -			if (!xdp_page)
> > -				goto err_xdp;
> > -
> > -			memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> > -			       page_address(page) + offset, len);
> > -			frame_sz =3D PAGE_SIZE;
> > -			offset =3D VIRTIO_XDP_HEADROOM;
> > -
> > -			put_page(page);
> > -			page =3D xdp_page;
> > -		} else {
> > -			xdp_page =3D page;
> > -		}
> > -
> > -		data =3D page_address(xdp_page) + offset;
> >   		err =3D virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, fr=
ame_sz,
> >   						 &num_buf, &xdp_frags_truesz, stats);
> >   		if (unlikely(err))
>
