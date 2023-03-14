Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E32D6B919C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjCNL2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCNL2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:28:12 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D771FA251;
        Tue, 14 Mar 2023 04:28:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VdsByGS_1678793285;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VdsByGS_1678793285)
          by smtp.aliyun-inc.com;
          Tue, 14 Mar 2023 19:28:06 +0800
Message-ID: <1678793273.5523777-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net v1 2/2] virtio_net: free xdp shinfo frags when build_skb_from_xdp_buff() fails
Date:   Tue, 14 Mar 2023 19:27:53 +0800
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
References: <20230314104939.67212-1-xuanzhuo@linux.alibaba.com>
 <20230314104939.67212-3-xuanzhuo@linux.alibaba.com>
 <faf3772c-b494-54bd-b29a-6cc3068985d5@huawei.com>
In-Reply-To: <faf3772c-b494-54bd-b29a-6cc3068985d5@huawei.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023 19:19:19 +0800, Yunsheng Lin <linyunsheng@huawei.com> wrote:
> On 2023/3/14 18:49, Xuan Zhuo wrote:
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
> > index 8ecf7a341d54..d36183be0481 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1273,9 +1273,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> >
> >  		switch (act) {
> >  		case XDP_PASS:
> > +			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> > +			if (!head_skb)
>
> It is a error case, perhaps add a unlikely() for it.

Yes. Will fix.

Thanks.


>
> > +				goto err_xdp_frags;
> > +
> >  			if (unlikely(xdp_page != page))
> >  				put_page(page);
> > -			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> >  			rcu_read_unlock();
> >  			return head_skb;
> >  		case XDP_TX:
> >
