Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E721FB48E
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgFPOiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 10:38:25 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29550 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728919AbgFPOiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 10:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592318302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5nXojDArjm3fbdFQyCIywRTxpZLNfyYEE+NzV4MWLuM=;
        b=gq/gm7jjhPk21GeQwvhqHvmHg7YW17x+OAwrTMKB42Cu+sLU6SBOysKWs917wwwhyCEF+V
        +b+ileXRZsBqFGpYYUKUt2XaWAkRsi18K2ZTKyYvfNvAXfbjHeoNRpFWc7p0wpyucoA+7d
        qj7RKT+t+w3JHh616dUrfDJNa1s9Q1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-oIELlBwROymyFbPw2TibZQ-1; Tue, 16 Jun 2020 10:38:19 -0400
X-MC-Unique: oIELlBwROymyFbPw2TibZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BFCB1E919;
        Tue, 16 Jun 2020 14:38:17 +0000 (UTC)
Received: from carbon (unknown [10.40.208.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 063C719D61;
        Tue, 16 Jun 2020 14:38:05 +0000 (UTC)
Date:   Tue, 16 Jun 2020 16:38:04 +0200
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
Message-ID: <20200616163804.19d00d03@carbon>
In-Reply-To: <20200616101133.GV102436@dhcp-12-153.nay.redhat.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
        <20200526140539.4103528-1-liuhangbin@gmail.com>
        <20200526140539.4103528-2-liuhangbin@gmail.com>
        <20200610121859.0412c111@carbon>
        <20200612085408.GT102436@dhcp-12-153.nay.redhat.com>
        <20200616105506.163ea5a3@carbon>
        <20200616101133.GV102436@dhcp-12-153.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 18:11:33 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> HI Jesper,
> 
> On Tue, Jun 16, 2020 at 10:55:06AM +0200, Jesper Dangaard Brouer wrote:
> > > Is there anything else I should do except add the following line?
> > > 	nxdpf->mem.type = MEM_TYPE_PAGE_ORDER0;  
> > 
> > You do realize that you also have copied over the mem.id, right?  
> 
> Thanks for the reminding. To confirm, set mem.id to 0 is enough, right?

Yes.

> > And as I wrote below you also need to update frame_sz.
> >   
> > > > 
> > > > You also need to update xdpf->frame_sz, as you also cannot assume it is
> > > > the same.    
> > > 
> > > Won't the memcpy() copy xdpf->frame_sz to nxdpf?   
> > 
> > You obviously cannot use the frame_sz from the existing frame, as you
> > just allocated a new page for the new xdp_frame, that have another size
> > (here PAGE_SIZE).  
> 
> Thanks, I didn't understand the frame_sz correctly before.
> > 
> >   
> > > And I didn't see xdpf->frame_sz is set in xdp_convert_zc_to_xdp_frame(),
> > > do we need a fix?  
> > 
> > Good catch, that sounds like a bug, that should be fixed.
> > Will you send a fix?  
> 
> OK, I will.

Thanks.
 
> >   
> > > > > +
> > > > > +	nxdpf = addr;
> > > > > +	nxdpf->data = addr + headroom;
> > > > > +
> > > > > +	return nxdpf;
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(xdpf_clone);    
> > > > 
> > > > 
> > > > struct xdp_frame {
> > > > 	void *data;
> > > > 	u16 len;
> > > > 	u16 headroom;
> > > > 	u32 metasize:8;
> > > > 	u32 frame_sz:24;
> > > > 	/* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
> > > > 	 * while mem info is valid on remote CPU.
> > > > 	 */
> > > > 	struct xdp_mem_info mem;
> > > > 	struct net_device *dev_rx; /* used by cpumap */
> > > > };
> > > >     
> > >   
> > 
> > struct xdp_mem_info {
> > 	u32                        type;                 /*     0     4 */
> > 	u32                        id;                   /*     4     4 */
> > 
> > 	/* size: 8, cachelines: 1, members: 2 */
> > 	/* last cacheline: 8 bytes */
> > };
> >   
> 
> Is this a struct reference or you want to remind me something else?

This is just a struct reference to help the readers of this email.
I had to lookup the struct to review this code, so I included it to
save time for other reviewers.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

