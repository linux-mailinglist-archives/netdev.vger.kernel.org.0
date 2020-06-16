Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2AA1FABAF
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 10:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgFPIz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 04:55:26 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22427 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726112AbgFPIzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 04:55:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592297724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wPF4qSfy9sktQyy2eeERuhgmZWCBKew9r91uHe9yaxg=;
        b=KY2s0GGBwUcJZqzXtVC84ES0iG6TXmRYrpMf6uiXxQMoGC5B5ZagxKZZKUW1VKk6jbdIb6
        KlwMDDjvcr5n5FSN4gpWkHEd+EGz7yoEb6OpRoaSuCjZykZbhSI91qlDQccb1nEiSN/L32
        WIkj3Um/1PdzH4FSHYYeNRkjCJQceCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-AjfjPjU3O7eoLgJpO1VzbQ-1; Tue, 16 Jun 2020 04:55:20 -0400
X-MC-Unique: AjfjPjU3O7eoLgJpO1VzbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67A6C10AB647;
        Tue, 16 Jun 2020 08:55:19 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 243D01002396;
        Tue, 16 Jun 2020 08:55:07 +0000 (UTC)
Date:   Tue, 16 Jun 2020 10:55:06 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxh?= =?UTF-8?B?bmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv4 bpf-next 1/2] xdp: add a new helper for dev map
 multicast support
Message-ID: <20200616105506.163ea5a3@carbon>
In-Reply-To: <20200612085408.GT102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
        <20200526140539.4103528-1-liuhangbin@gmail.com>
        <20200526140539.4103528-2-liuhangbin@gmail.com>
        <20200610121859.0412c111@carbon>
        <20200612085408.GT102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 16:54:08 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Wed, Jun 10, 2020 at 12:18:59PM +0200, Jesper Dangaard Brouer wrote:
> > On Tue, 26 May 2020 22:05:38 +0800
> > Hangbin Liu <liuhangbin@gmail.com> wrote:
> >   
> > > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > > index 90f44f382115..acdc63833b1f 100644
> > > --- a/net/core/xdp.c
> > > +++ b/net/core/xdp.c
> > > @@ -475,3 +475,29 @@ void xdp_warn(const char *msg, const char *func, const int line)
> > >  	WARN(1, "XDP_WARN: %s(line:%d): %s\n", func, line, msg);
> > >  };
> > >  EXPORT_SYMBOL_GPL(xdp_warn);
> > > +
> > > +struct xdp_frame *xdpf_clone(struct xdp_frame *xdpf)
> > > +{
> > > +	unsigned int headroom, totalsize;
> > > +	struct xdp_frame *nxdpf;
> > > +	struct page *page;
> > > +	void *addr;
> > > +
> > > +	headroom = xdpf->headroom + sizeof(*xdpf);
> > > +	totalsize = headroom + xdpf->len;
> > > +
> > > +	if (unlikely(totalsize > PAGE_SIZE))
> > > +		return NULL;
> > > +	page = dev_alloc_page();
> > > +	if (!page)
> > > +		return NULL;
> > > +	addr = page_to_virt(page);
> > > +
> > > +	memcpy(addr, xdpf, totalsize);  
> > 
> > I don't think this will work.  You are assuming that the memory model
> > (xdp_mem_info) is the same.
> > 
> > You happened to use i40, that have MEM_TYPE_PAGE_SHARED, and you should
> > have changed this to MEM_TYPE_PAGE_ORDER0, but it doesn't crash as they
> > are compatible.  If you were using mlx5, I suspect that this would
> > result in memory leaking.  
> 
> Is there anything else I should do except add the following line?
> 	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;

You do realize that you also have copied over the mem.id, right?

And as I wrote below you also need to update frame_sz.

> > 
> > You also need to update xdpf->frame_sz, as you also cannot assume it is
> > the same.  
> 
> Won't the memcpy() copy xdpf->frame_sz to nxdpf? 

You obviously cannot use the frame_sz from the existing frame, as you
just allocated a new page for the new xdp_frame, that have another size
(here PAGE_SIZE).


> And I didn't see xdpf->frame_sz is set in xdp_convert_zc_to_xdp_frame(),
> do we need a fix?

Good catch, that sounds like a bug, that should be fixed.
Will you send a fix?


> > > +
> > > +	nxdpf = addr;
> > > +	nxdpf->data = addr + headroom;
> > > +
> > > +	return nxdpf;
> > > +}
> > > +EXPORT_SYMBOL_GPL(xdpf_clone);  
> > 
> > 
> > struct xdp_frame {
> > 	void *data;
> > 	u16 len;
> > 	u16 headroom;
> > 	u32 metasize:8;
> > 	u32 frame_sz:24;
> > 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
> > 	 * while mem info is valid on remote CPU.
> > 	 */
> > 	struct xdp_mem_info mem;
> > 	struct net_device *dev_rx; /* used by cpumap */
> > };
> >   
> 

struct xdp_mem_info {
	u32                        type;                 /*     0     4 */
	u32                        id;                   /*     4     4 */

	/* size: 8, cachelines: 1, members: 2 */
	/* last cacheline: 8 bytes */
};

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

