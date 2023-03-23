Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A366C660C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbjCWLCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbjCWLCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:02:05 -0400
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8980E222D0;
        Thu, 23 Mar 2023 04:01:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VeU6ljP_1679569312;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VeU6ljP_1679569312)
          by smtp.aliyun-inc.com;
          Thu, 23 Mar 2023 19:01:53 +0800
Message-ID: <1679569164.3774488-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce mergeable_xdp_prepare
Date:   Thu, 23 Mar 2023 18:59:24 +0800
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
 <20230322030308.16046-3-xuanzhuo@linux.alibaba.com>
 <c7749936-c154-da51-ccfb-f16150d19c62@huawei.com>
 <1679535924.6219428-2-xuanzhuo@linux.alibaba.com>
 <215e791d-1802-2419-ff59-49476bcdcd02@huawei.com>
In-Reply-To: <215e791d-1802-2419-ff59-49476bcdcd02@huawei.com>
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 12:45:41 +0800, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> On 2023/3/23 9:45, Xuan Zhuo wrote:
> > On Wed, 22 Mar 2023 19:52:48 +0800, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >> On 2023/3/22 11:03, Xuan Zhuo wrote:
> >>> Separating the logic of preparation for xdp from receive_mergeable.
> >>>
> >>> The purpose of this is to simplify the logic of execution of XDP.
> >>>
> >>> The main logic here is that when headroom is insufficient, we need to
> >>> allocate a new page and calculate offset. It should be noted that if
> >>> there is new page, the variable page will refer to the new page.
> >>>
> >>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >>> ---
> >>>  drivers/net/virtio_net.c | 135 ++++++++++++++++++++++-----------------
> >>>  1 file changed, 77 insertions(+), 58 deletions(-)
> >>>
> >>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >>> index 4d2bf1ce0730..bb426958cdd4 100644
> >>> --- a/drivers/net/virtio_net.c
> >>> +++ b/drivers/net/virtio_net.c
> >>> @@ -1162,6 +1162,79 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> >>>  	return 0;
> >>>  }
> >>>
> >>> +static void *mergeable_xdp_prepare(struct virtnet_info *vi,
> >>> +				   struct receive_queue *rq,
> >>> +				   struct bpf_prog *xdp_prog,
> >>> +				   void *ctx,
> >>> +				   unsigned int *frame_sz,
> >>> +				   int *num_buf,
> >>> +				   struct page **page,
> >>> +				   int offset,
> >>> +				   unsigned int *len,
> >>> +				   struct virtio_net_hdr_mrg_rxbuf *hdr)
> >>
> >> The naming convention seems to be xdp_prepare_mergeable().
> >
> > What convention?
> >
> >
> >>
> >>> +{
> >>> +	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
> >>> +	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
> >>> +	struct page *xdp_page;
> >>> +	unsigned int xdp_room;
> >>> +
> >>> +	/* Transient failure which in theory could occur if
> >>> +	 * in-flight packets from before XDP was enabled reach
> >>> +	 * the receive path after XDP is loaded.
> >>> +	 */
> >>> +	if (unlikely(hdr->hdr.gso_type))
> >>> +		return NULL;
> >>> +
> >>> +	/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> >>> +	 * with headroom may add hole in truesize, which
> >>> +	 * make their length exceed PAGE_SIZE. So we disabled the
> >>> +	 * hole mechanism for xdp. See add_recvbuf_mergeable().
> >>> +	 */
> >>> +	*frame_sz = truesize;
> >>> +
> >>> +	/* This happens when headroom is not enough because
> >>> +	 * of the buffer was prefilled before XDP is set.
> >>> +	 * This should only happen for the first several packets.
> >>> +	 * In fact, vq reset can be used here to help us clean up
> >>> +	 * the prefilled buffers, but many existing devices do not
> >>> +	 * support it, and we don't want to bother users who are
> >>> +	 * using xdp normally.
> >>> +	 */
> >>> +	if (!xdp_prog->aux->xdp_has_frags &&
> >>> +	    (*num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
> >>> +		/* linearize data for XDP */
> >>> +		xdp_page = xdp_linearize_page(rq, num_buf,
> >>> +					      *page, offset,
> >>> +					      VIRTIO_XDP_HEADROOM,
> >>> +					      len);
> >>> +
> >>> +		if (!xdp_page)
> >>> +			return NULL;
> >>> +	} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
> >>> +		xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
> >>> +					  sizeof(struct skb_shared_info));
> >>> +		if (*len + xdp_room > PAGE_SIZE)
> >>> +			return NULL;
> >>> +
> >>> +		xdp_page = alloc_page(GFP_ATOMIC);
> >>> +		if (!xdp_page)
> >>> +			return NULL;
> >>> +
> >>> +		memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> >>> +		       page_address(*page) + offset, *len);
> >>
> >> It seems the above 'else if' was not really tested even before this patch,
> >> as there is no "--*num_buf" if xdp_linearize_page() is not called, which
> >> may causes virtnet_build_xdp_buff_mrg() to comsume one more buffer than
> >> expected?
> >
> > Why do you think so?
>
>
> In first 'if' block, there is a "--*num_buf" before gotoing 'err_xdp'
> for virtqueue_get_buf() failure in xdp_linearize_page().
>
> But here there is no "--*num_buf" before gotoing 'err_xdp' for
> alloc_page() failure.

Inside err_xdp, we will get all bufs and free them util num_buf is 0.

Thanks.

>
> So one of them has to be wrong, right?
>
> >
> >>
> >> Also, it seems better to split the xdp_linearize_page() to two functions
> >> as pskb_expand_head() and __skb_linearize() do, one to expand the headroom,
> >> the other one to do the linearizing.
> >
> > No skb here.
>
> I means following the semantics of pskb_expand_head() and __skb_linearize(),
> not to combine the headroom expanding and linearizing into one function as
> xdp_linearize_page() does now if we want a better refoctor result.
>
> >
> >
> >>
