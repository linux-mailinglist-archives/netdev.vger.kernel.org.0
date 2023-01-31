Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456D76825AC
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjAaHkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjAaHkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:40:39 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815F73B3DE;
        Mon, 30 Jan 2023 23:40:35 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VaVkH6A_1675150832;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VaVkH6A_1675150832)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 15:40:32 +0800
Date:   Tue, 31 Jan 2023 15:40:32 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] virtio-net: fix possible unsigned integer
 overflow
Message-ID: <20230131074032.GD34480@h68b04307.sqa.eu95>
References: <20230131034337.55445-1-hengqi@linux.alibaba.com>
 <20230131021758-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131021758-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 02:20:49AM -0500, Michael S. Tsirkin wrote:
> On Tue, Jan 31, 2023 at 11:43:37AM +0800, Heng Qi wrote:
> > When the single-buffer xdp is loaded and after xdp_linearize_page()
> > is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
> > a large integer in virtnet_build_xdp_buff_mrg(), resulting in
> > unexpected packet dropping.
> > 
> > Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
> > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> 
> Given the confusion, just make num_buf an int?

In the structure virtio_net_hdr_mrg_rxbuf, \field{num_buffers} is unsigned int,
which matches each other. And num_buf is used in many different places, it seems
to be a lot of work to modify it to int.

> 
> > ---
> >  drivers/net/virtio_net.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index aaa6fe9b214a..a8e9462903fa 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -1007,6 +1007,9 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> >  	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
> >  			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
> >  
> > +	if (!*num_buf)
> > +		return 0;
> > +
> >  	if (*num_buf > 1) {
> >  		/* If we want to build multi-buffer xdp, we need
> >  		 * to specify that the flags of xdp_buff have the
> 
> 
> This means truesize won't be set.

Do you mean xdp_frags_truesize please? If yes, the answer is yes, this fix
is only for single-buffer xdp, which doesn't need xdp_frags_truesize, and
already set it to 0 in its wrapper receive_mergeable().

> 
> > @@ -1020,10 +1023,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> >  		shinfo->xdp_frags_size = 0;
> >  	}
> >  
> > -	if ((*num_buf - 1) > MAX_SKB_FRAGS)
> > +	if (*num_buf > MAX_SKB_FRAGS + 1)
> >  		return -EINVAL;
> 
> Admittedly this is cleaner.
> 
> >  
> > -	while ((--*num_buf) >= 1) {
> > +	while (--*num_buf) {
> 
> A bit more fragile, > 0 would be better.

Sure.

Thanks.

> 
> >  		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
> >  		if (unlikely(!buf)) {
> >  			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> > -- 
> > 2.19.1.6.gb485710b
