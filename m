Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05F76BA525
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 03:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjCOCUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 22:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbjCOCUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 22:20:10 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52FB30FB;
        Tue, 14 Mar 2023 19:19:55 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R501e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VduCST._1678846792;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VduCST._1678846792)
          by smtp.aliyun-inc.com;
          Wed, 15 Mar 2023 10:19:52 +0800
Message-ID: <1678846773.823149-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net v2 2/2] virtio_net: free xdp shinfo frags when build_skb_from_xdp_buff() fails
Date:   Wed, 15 Mar 2023 10:19:33 +0800
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
        Heng Qi <hengqi@linux.alibaba.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20230315015223.89137-1-xuanzhuo@linux.alibaba.com>
 <20230315015223.89137-3-xuanzhuo@linux.alibaba.com>
 <0ebbc591-c1db-b11d-c7bd-c9869122caa7@huawei.com>
In-Reply-To: <0ebbc591-c1db-b11d-c7bd-c9869122caa7@huawei.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 10:14:34 +0800, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> On 2023/3/15 9:52, Xuan Zhuo wrote:
> > build_skb_from_xdp_buff() may return NULL, in this case
> > we need to free the frags of xdp shinfo.
> >
> > Fixes: fab89bafa95b ("virtio-net: support multi-buffer xdp")
> > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  drivers/net/virtio_net.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 8ecf7a341d54..2396c28c0122 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1273,9 +1273,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >
> >  		switch (act) {
> >  		case XDP_PASS:
> > +			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> > +			if (unlikely(!head_skb))
> > +				goto err_xdp_frags;
>
> LGTM.
> Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
>
> Note, "stats->drops++; dev_kfree_skb(head_skb);" is also done for the above case,
> I assume it is ok as other "goto err_xdp_frags" case also do that.


Yes. It's ok.

Thanks.


>
> > +
> >  			if (unlikely(xdp_page != page))
> >  				put_page(page);
> > -			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> >  			rcu_read_unlock();
> >  			return head_skb;
> >  		case XDP_TX:
> >
