Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E8E2DBCB9
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 09:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLPIb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 03:31:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51373 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725287AbgLPIb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 03:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608107430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJk4b0qKB9nHSk8Z04RQF0+zGdRza+ILSu4IdYlp+aU=;
        b=YdT+++jRHXW/my78rtRIFxax7/CGE0yJltnX+NFzeq+iFRkDJbkUaX+Kr0tngjITFOp6IZ
        LcLpdjkYM+q+5ngb7oc7cuJiCYLH8gdt4f0+COMV6XHn2r8nkh3HXpkqIjq+Igm7arRjBo
        xy/0opV3YEDIOAUwjgM8ZOd43NgVyjs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98--dbtsSWaMaaEcTdveJUEGg-1; Wed, 16 Dec 2020 03:30:28 -0500
X-MC-Unique: -dbtsSWaMaaEcTdveJUEGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7657803621;
        Wed, 16 Dec 2020 08:30:26 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5889860C15;
        Wed, 16 Dec 2020 08:30:17 +0000 (UTC)
Date:   Wed, 16 Dec 2020 09:30:15 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, alexander.duyck@gmail.com, saeed@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201216093015.3a0b78e2@carbon>
In-Reply-To: <20201215151344.GA24650@ranger.igk.intel.com>
References: <cover.1607794551.git.lorenzo@kernel.org>
        <71d5ae9f810c2c80f1cb09e304330be0b5ce5345.1607794552.git.lorenzo@kernel.org>
        <20201215123643.GA23785@ranger.igk.intel.com>
        <20201215134710.GB5477@lore-desk>
        <6886cd02-8dec-1905-b878-d45ee9a0c9b4@iogearbox.net>
        <20201215150620.GC5477@lore-desk>
        <20201215151344.GA24650@ranger.igk.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 16:13:44 +0100
Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:

> On Tue, Dec 15, 2020 at 04:06:20PM +0100, Lorenzo Bianconi wrote:
> > > On 12/15/20 2:47 PM, Lorenzo Bianconi wrote:
> > > [...]  
> > > > > > diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> > > > > > index 329397c60d84..61d3f5f8b7f3 100644
> > > > > > --- a/drivers/net/xen-netfront.c
> > > > > > +++ b/drivers/net/xen-netfront.c
> > > > > > @@ -866,10 +866,8 @@ static u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> > > > > >   	xdp_init_buff(xdp, XEN_PAGE_SIZE - XDP_PACKET_HEADROOM,
> > > > > >   		      &queue->xdp_rxq);
> > > > > > -	xdp->data_hard_start = page_address(pdata);
> > > > > > -	xdp->data = xdp->data_hard_start + XDP_PACKET_HEADROOM;
> > > > > > +	xdp_prepare_buff(xdp, page_address(pdata), XDP_PACKET_HEADROOM, len);
> > > > > >   	xdp_set_data_meta_invalid(xdp);
> > > > > > -	xdp->data_end = xdp->data + len;
> > > > > >   	act = bpf_prog_run_xdp(prog, xdp);
> > > > > >   	switch (act) {
> > > > > > diff --git a/include/net/xdp.h b/include/net/xdp.h
> > > > > > index 3fb3a9aa1b71..66d8a4b317a3 100644
> > > > > > --- a/include/net/xdp.h
> > > > > > +++ b/include/net/xdp.h
> > > > > > @@ -83,6 +83,18 @@ xdp_init_buff(struct xdp_buff *xdp, u32 frame_sz, struct xdp_rxq_info *rxq)
> > > > > >   	xdp->rxq = rxq;
> > > > > >   }
> > > > > > +static inline void  
> > > 
> > > nit: maybe __always_inline  
> > 
> > ack, I will add in v4
> >   
> > >   
> > > > > > +xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > > > > > +		 int headroom, int data_len)
> > > > > > +{
> > > > > > +	unsigned char *data = hard_start + headroom;
> > > > > > +
> > > > > > +	xdp->data_hard_start = hard_start;
> > > > > > +	xdp->data = data;
> > > > > > +	xdp->data_end = data + data_len;
> > > > > > +	xdp->data_meta = data;
> > > > > > +}
> > > > > > +
> > > > > >   /* Reserve memory area at end-of data area.
> > > > > >    *  
> > > 
> > > For the drivers with xdp_set_data_meta_invalid(), we're basically setting xdp->data_meta
> > > twice unless compiler is smart enough to optimize the first one away (did you double check?).
> > > Given this is supposed to be a cleanup, why not integrate this logic as well so the
> > > xdp_set_data_meta_invalid() doesn't get extra treatment?  
> 
> That's what I was trying to say previously.
> 
> > 
> > we discussed it before, but I am fine to add it in v4. Something like:
> > 
> > static __always_inline void
> > xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> > 		 int headroom, int data_len, bool meta_valid)
> > {
> > 	unsigned char *data = hard_start + headroom;
> > 	
> > 	xdp->data_hard_start = hard_start;
> > 	xdp->data = data;
> > 	xdp->data_end = data + data_len;
> > 	xdp->data_meta = meta_valid ? data : data + 1;  
> 
> This will introduce branch, so for intel drivers we're getting the
> overhead of one add and a branch. I'm still opting for a separate helper.

I should think, as this gets inlined the compiler should be able to
remove the branch.  I assume that the usage of 'meta_valid' will be a
const in the drivers.  Maybe we should have the API be 'const bool meta_valid'?


> static __always_inline void
> xdp_prepare_buff(struct xdp_buff *xdp, unsigned char *hard_start,
> 		 int headroom, int data_len)
> {
> 	unsigned char *data = hard_start + headroom;
> 
> 	xdp->data_hard_start = hard_start;
> 	xdp->data = data;
> 	xdp->data_end = data + data_len;
> 	xdp_set_data_meta_invalid(xdp);
> }
> 
> static __always_inline void
> xdp_prepare_buff_meta(struct xdp_buff *xdp, unsigned char *hard_start,
> 		      int headroom, int data_len)
> {
> 	unsigned char *data = hard_start + headroom;
> 
> 	xdp->data_hard_start = hard_start;
> 	xdp->data = data;
> 	xdp->data_end = data + data_len;
> 	xdp->data_meta = data;
> }

Thanks to you Maciej for reviewing this! :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

