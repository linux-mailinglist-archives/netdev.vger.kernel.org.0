Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E917D6825E2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjAaHvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:51:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjAaHvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:51:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B050E4EC6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675151458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fkrRP7RpjOnONHlxgICu52rfJGhEUI73DmaTHiOVAcw=;
        b=JjfFBn8bE0DpGfzMOAg6uwe4HUZxUXUgfheXUNFP6yOH3sTF2kfy2QtzJaV4Y/81zXBeUZ
        v7xp9fWLr0I7gSLbEaQsRU8NAFNiBfxzL88/YRElXLdJH99fmb592WVGCiQbgJxHViDFRQ
        iEXJWki2j79O5SPsZyNyUM5eK+iAHUI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-267-R1bFqSPKMHivlvic8ivQBQ-1; Tue, 31 Jan 2023 02:50:55 -0500
X-MC-Unique: R1bFqSPKMHivlvic8ivQBQ-1
Received: by mail-wr1-f70.google.com with SMTP id o9-20020adfa109000000b002bfc062eaa8so2314492wro.20
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:50:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fkrRP7RpjOnONHlxgICu52rfJGhEUI73DmaTHiOVAcw=;
        b=XixvTbGDgv68FTZYsfYPhF6/p9Y5o82FGyVgQFQ2wbOHHqZp9MuK0Zf4LxAlKEJP/l
         wcchxxDfmT3hW1zqqm6VM5rtsNN+3iFQRMRl3So5JGIbZK13YY9g3avu+Krio9Frw2Ms
         zO1Knt7QkogyZEr3jKpi60TUZvDybGyd1e+1QKdVTLGYFLtkoudn7elF//BynlgDSeKK
         Kb3QzNFnJVwbWqm/304g74WPEmspVZ2N6vuCjxrSZQaSxMoZZTA0Z77urY5umhlXRqUo
         4HozUM19p4aJQkOFqIBLpQIYrovK1E3fZx2YS3UhMDIIPlsLIq80myjqmQ/btEvBWUdK
         I04A==
X-Gm-Message-State: AO0yUKWy4d4OndO4TaDq1HbTxmDbmc10+/CrjpJ3W1zWGYOd0YFu2jUG
        uJ/wlflmrAtou72SlA1AmEUb7G9TBzI481Lz1m7HGNEnOf6G9EBsR7gNE6ul5HbeXzkhBUx/MkC
        ANtPLOQ6lkztyU708
X-Received: by 2002:a05:600c:3b17:b0:3dd:1ac1:2572 with SMTP id m23-20020a05600c3b1700b003dd1ac12572mr3404415wms.1.1675151454739;
        Mon, 30 Jan 2023 23:50:54 -0800 (PST)
X-Google-Smtp-Source: AK7set+lQ5wqmAsvC1NObSC/5LNacEoNIfDtmnn5U/XVAD2LTE3FEsvavzU28/Q1DowOrJ7HL6uCHA==
X-Received: by 2002:a05:600c:3b17:b0:3dd:1ac1:2572 with SMTP id m23-20020a05600c3b1700b003dd1ac12572mr3404403wms.1.1675151454512;
        Mon, 30 Jan 2023 23:50:54 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id n24-20020a7bcbd8000000b003daf7721bb3sm17541710wmi.12.2023.01.30.23.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 23:50:53 -0800 (PST)
Date:   Tue, 31 Jan 2023 02:50:49 -0500
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
Subject: Re: [PATCH net-next] virtio-net: fix possible unsigned integer
 overflow
Message-ID: <20230131024630-mutt-send-email-mst@kernel.org>
References: <20230131034337.55445-1-hengqi@linux.alibaba.com>
 <20230131021758-mutt-send-email-mst@kernel.org>
 <20230131074032.GD34480@h68b04307.sqa.eu95>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131074032.GD34480@h68b04307.sqa.eu95>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 03:40:32PM +0800, Heng Qi wrote:
> On Tue, Jan 31, 2023 at 02:20:49AM -0500, Michael S. Tsirkin wrote:
> > On Tue, Jan 31, 2023 at 11:43:37AM +0800, Heng Qi wrote:
> > > When the single-buffer xdp is loaded and after xdp_linearize_page()
> > > is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
> > > a large integer in virtnet_build_xdp_buff_mrg(), resulting in
> > > unexpected packet dropping.
> > > 
> > > Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
> > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > 
> > Given the confusion, just make num_buf an int?
> 
> In the structure virtio_net_hdr_mrg_rxbuf, \field{num_buffers} is unsigned int,
> which matches each other.

Because hardware buffers are all unsigned. Does not mean we need
to do all math unsigned now.

> And num_buf is used in many different places, it seems
> to be a lot of work to modify it to int.

Are you sure?

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>


diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 18b3de854aeb..97f2e9bfc6f9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -722,7 +722,7 @@ static unsigned int virtnet_get_headroom(struct virtnet_info *vi)
  * have enough headroom.
  */
 static struct page *xdp_linearize_page(struct receive_queue *rq,
-				       u16 *num_buf,
+				       int *num_buf,
 				       struct page *p,
 				       int offset,
 				       int page_off,
@@ -822,7 +822,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 		if (unlikely(xdp_headroom < virtnet_get_headroom(vi))) {
 			int offset = buf - page_address(page) + header_offset;
 			unsigned int tlen = len + vi->hdr_len;
-			u16 num_buf = 1;
+			int num_buf = 1;
 
 			xdp_headroom = virtnet_get_headroom(vi);
 			header_offset = VIRTNET_RX_PAD + xdp_headroom;
@@ -948,7 +948,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 					 struct virtnet_rq_stats *stats)
 {
 	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
-	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
+	int num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
 	struct page *page = virt_to_head_page(buf);
 	int offset = buf - page_address(page);
 	struct sk_buff *head_skb, *curr_skb;

Feel free to reuse.


> > 
> > > ---
> > >  drivers/net/virtio_net.c | 7 +++++--
> > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index aaa6fe9b214a..a8e9462903fa 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1007,6 +1007,9 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> > >  	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
> > >  			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
> > >  
> > > +	if (!*num_buf)
> > > +		return 0;
> > > +
> > >  	if (*num_buf > 1) {
> > >  		/* If we want to build multi-buffer xdp, we need
> > >  		 * to specify that the flags of xdp_buff have the
> > 
> > 
> > This means truesize won't be set.
> 
> Do you mean xdp_frags_truesize please? If yes, the answer is yes, this fix
> is only for single-buffer xdp, which doesn't need xdp_frags_truesize, and
> already set it to 0 in its wrapper receive_mergeable().

It seems cleaner to always set the value not rely on caller to do so.

> > 
> > > @@ -1020,10 +1023,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> > >  		shinfo->xdp_frags_size = 0;
> > >  	}
> > >  
> > > -	if ((*num_buf - 1) > MAX_SKB_FRAGS)
> > > +	if (*num_buf > MAX_SKB_FRAGS + 1)
> > >  		return -EINVAL;
> > 
> > Admittedly this is cleaner.
> > 
> > >  
> > > -	while ((--*num_buf) >= 1) {
> > > +	while (--*num_buf) {
> > 
> > A bit more fragile, > 0 would be better.
> 
> Sure.
> 
> Thanks.
> 
> > 
> > >  		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
> > >  		if (unlikely(!buf)) {
> > >  			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> > > -- 
> > > 2.19.1.6.gb485710b

