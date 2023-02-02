Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A643687A3E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjBBKcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjBBKcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:32:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B782237B51
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 02:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675333894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uv4tJA8ZKwKPX/rEMjh0N/WR/MUEVGDamiWgWgPNb8c=;
        b=Sq4Ib09mkqazsrq5rhoncnssbOvS6FyMCPHhbDfSMd6sEd7eJ4cRof8PvWLPiWPCSrm5Q2
        v5gHvc902G3KtLsTn1MMb8q9awsdM2EeDitXaQ7l8h4k95od3EMW/5BH6udZSHPYTHMCEw
        tuohrzwZF2sBRkDs+Su4iCfpVGePj8M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-qKefHaaPNbWjllyPWr4-nA-1; Thu, 02 Feb 2023 05:31:33 -0500
X-MC-Unique: qKefHaaPNbWjllyPWr4-nA-1
Received: by mail-wm1-f71.google.com with SMTP id e38-20020a05600c4ba600b003dc434dabbdso2595638wmp.6
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 02:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uv4tJA8ZKwKPX/rEMjh0N/WR/MUEVGDamiWgWgPNb8c=;
        b=y0MMbKBKyrSRIE12bTZHaQGwDgyFoLbRhC6+BGa/cFOHVYoJAZWmCQmIYqhVoaxAXp
         mmumaF7aMeaHSz3ljFU9a16bxlOl9nqw6Pw5piXFEWxg/+kEiXrWTQTbFQUawI2WSvDj
         a4vNB1wHXH+9Kzo0sLgQC48gK2by0yAgtcatydu3rRkLv602b9cxuZpUDoN3u77Qh1Zf
         Vd7rcYLqpkHNsFzYxP/+MDbc/GgHTFR+xPvZpYyzmhM2+u7jjLJzJylVGEzG//nbp8Rr
         9glRHBWnYmGVa550fbZEgSSoD5BKCIEt+0t+LOA9PuuT3AaqXyJN1Jip8RqBiuhZ5Wf4
         7ILQ==
X-Gm-Message-State: AO0yUKXVipKhsXQCi+jhbjsmTDCnKNzjjsixMX8JFTqRTUN+Y7/RFyNB
        fxvEakjbVEwzQwHM1lZhO789nJILccG+bsT2e/mdUDx4K0vvtZTMjWn7vkKM7oeXsOOQLTnIq6M
        MAqLL7T5EQuftsSm3
X-Received: by 2002:a5d:4bca:0:b0:2be:338f:bc55 with SMTP id l10-20020a5d4bca000000b002be338fbc55mr4900578wrt.66.1675333890816;
        Thu, 02 Feb 2023 02:31:30 -0800 (PST)
X-Google-Smtp-Source: AK7set/LFQoefVJGEW+JTGAGAP0Ztiz+5MjNDZWnM9xHyNCGq1m64mkFb+U8X16bfkMp6/z2cG/c8Q==
X-Received: by 2002:a5d:4bca:0:b0:2be:338f:bc55 with SMTP id l10-20020a5d4bca000000b002be338fbc55mr4900564wrt.66.1675333890542;
        Thu, 02 Feb 2023 02:31:30 -0800 (PST)
Received: from redhat.com ([2a02:14f:1fc:826d:55d8:70a4:3d30:fc2f])
        by smtp.gmail.com with ESMTPSA id v9-20020a056000144900b002c3b2afae00sm4648799wrx.41.2023.02.02.02.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 02:31:29 -0800 (PST)
Date:   Thu, 2 Feb 2023 05:31:24 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
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
Subject: Re: [PATCH net-next v2] virtio-net: fix possible unsigned integer
 overflow
Message-ID: <20230202052930-mutt-send-email-mst@kernel.org>
References: <20230131085004.98687-1-hengqi@linux.alibaba.com>
 <20230202030550-mutt-send-email-mst@kernel.org>
 <f510df2b-25fd-6c88-d796-3e6f6ef6799e@linux.alibaba.com>
 <20230202031609-mutt-send-email-mst@kernel.org>
 <e321e1f2-10b8-3308-88d5-d4dd6cabc2b6@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e321e1f2-10b8-3308-88d5-d4dd6cabc2b6@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 05:07:04PM +0800, Heng Qi wrote:
> 
> 
> 在 2023/2/2 下午4:16, Michael S. Tsirkin 写道:
> > On Thu, Feb 02, 2023 at 04:14:51PM +0800, Heng Qi wrote:
> > > 
> > > 在 2023/2/2 下午4:07, Michael S. Tsirkin 写道:
> > > > On Tue, Jan 31, 2023 at 04:50:04PM +0800, Heng Qi wrote:
> > > > > When the single-buffer xdp is loaded and after xdp_linearize_page()
> > > > > is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
> > > > > a large integer in virtnet_build_xdp_buff_mrg(), resulting in
> > > > > unexpected packet dropping.
> > > > > 
> > > > > Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
> > > > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > ---
> > > > > v1->v2:
> > > > > - Change the type of num_buf from unsigned int to int. @Michael S . Tsirkin
> > > > > - Some cleaner codes. @Michael S . Tsirkin
> > > > > 
> > > > >    drivers/net/virtio_net.c | 15 +++++++++------
> > > > >    1 file changed, 9 insertions(+), 6 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index aaa6fe9b214a..8102861785a2 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -716,7 +716,7 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
> > > > >     * have enough headroom.
> > > > >     */
> > > > >    static struct page *xdp_linearize_page(struct receive_queue *rq,
> > > > > -				       u16 *num_buf,
> > > > > +				       int *num_buf,
> > > > >    				       struct page *p,
> > > > >    				       int offset,
> > > > >    				       int page_off,
> > > > > @@ -816,7 +816,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
> > > > >    		if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
> > > > >    			int offset = buf - page_address(page) + header_offset;
> > > > >    			unsigned int tlen = len + vi->hdr_len;
> > > > > -			u16 num_buf = 1;
> > > > > +			int num_buf = 1;
> > > > >    			xdp_headroom = virtnet_get_headroom(vi);
> > > > >    			header_offset = VIRTNET_RX_PAD + xdp_headroom;
> > > > > @@ -989,7 +989,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> > > > >    				      void *buf,
> > > > >    				      unsigned int len,
> > > > >    				      unsigned int frame_sz,
> > > > > -				      u16 *num_buf,
> > > > > +				      int *num_buf,
> > > > >    				      unsigned int *xdp_frags_truesize,
> > > > >    				      struct virtnet_rq_stats *stats)
> > > > >    {
> > > > > @@ -1007,6 +1007,9 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> > > > >    	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
> > > > >    			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
> > > > > +	if (!*num_buf)
> > > > > +		return 0;
> > > > > +
> > > > >    	if (*num_buf > 1) {
> > > > >    		/* If we want to build multi-buffer xdp, we need
> > > > >    		 * to specify that the flags of xdp_buff have the
> > > > Ouch. Why is this here? Merged so pls remove by a follow up patch, the
> > > > rest of the code handles 0 fine. I'm not sure this introduces a bug by
> > > > we don't want spaghetti code.
> > > Yes it would work without this, but I was keeping this because I wanted it
> > > to handle 0 early and exit early.
> > > 
> > > Do you want to remove this?
> > > 
> > > Thanks.
> > why do you want to exit early?
> 
> If num_buf is 0, we don't need to judge the subsequent process, because the
> latter process
> is used to build multi-buffer xdp, but this fix solves the possible problems
> of single-buffer xdp.
> 
> Thanks.

An optimization then? As any optimization I'd like to see some numbers.

Should have been documented as such not as part of a bugfix.

> > 
> > > > > @@ -1020,10 +1023,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> > > > >    		shinfo->xdp_frags_size = 0;
> > > > >    	}
> > > > > -	if ((*num_buf - 1) > MAX_SKB_FRAGS)
> > > > > +	if (*num_buf > MAX_SKB_FRAGS + 1)
> > > > >    		return -EINVAL;
> > > > > -	while ((--*num_buf) >= 1) {
> > > > > +	while (--*num_buf > 0) {
> > > > >    		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
> > > > >    		if (unlikely(!buf)) {
> > > > >    			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> > > > > @@ -1076,7 +1079,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> > > > >    					 struct virtnet_rq_stats *stats)
> > > > >    {
> > > > >    	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
> > > > > -	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> > > > > +	int num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
> > > > >    	struct page *page = virt_to_head_page(buf);
> > > > >    	int offset = buf - page_address(page);
> > > > >    	struct sk_buff *head_skb, *curr_skb;
> > > > > -- 
> > > > > 2.19.1.6.gb485710b

