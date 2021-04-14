Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC635EF3F
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349922AbhDNILW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349916AbhDNILS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 04:11:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618387857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EwYB5nz8yfF5tg561fCrH5gbdVVTxmjpf7rPCaT4AzE=;
        b=LXxmECgSxCEzoIMOehaD1mPIswEhibo5RGmsyBaoDSSHOnwkcd3QiR1HHYvRu0MQT2tpXY
        sSjZIX5qIbHbRHFhRaYFXljiD48NACsuw3kSOii/S7CsqGSAHFGunjlNwK3xOMJ3y1xePh
        FWcvBQK5cUD9FYhJ+0ru5jIsV3G+nr0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-uxPR0e8iMvqotYdo8VKEqQ-1; Wed, 14 Apr 2021 04:10:54 -0400
X-MC-Unique: uxPR0e8iMvqotYdo8VKEqQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E40087504F;
        Wed, 14 Apr 2021 08:10:52 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4FFE5D9CA;
        Wed, 14 Apr 2021 08:10:45 +0000 (UTC)
Date:   Wed, 14 Apr 2021 10:10:44 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Christoph Hellwig <hch@lst.de>, brouer@redhat.com
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210414101044.19da09df@carbon>
In-Reply-To: <20210412011532.GG2531743@casper.infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
        <20210410205246.507048-2-willy@infradead.org>
        <20210411114307.5087f958@carbon>
        <20210411103318.GC2531743@casper.infradead.org>
        <20210412011532.GG2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 02:15:32 +0100
Matthew Wilcox <willy@infradead.org> wrote:

> On Sun, Apr 11, 2021 at 11:33:18AM +0100, Matthew Wilcox wrote:
> > Basically, we have three aligned dwords here.  We can either alias with
> > @flags and the first word of @lru, or the second word of @lru and @mapping,
> > or @index and @private.  @flags is a non-starter.  If we use @mapping,
> > then you have to set it to NULL before you free it, and I'm not sure
> > how easy that will be for you.  If that's trivial, then we could use
> > the layout:
> > 
> > 	unsigned long _pp_flags;
> > 	unsigned long pp_magic;
> > 	union {
> > 		dma_addr_t dma_addr;    /* might be one or two words */
> > 		unsigned long _pp_align[2];
> > 	};
> > 	unsigned long pp_pfmemalloc;
> > 	unsigned long xmi;  
> 
> I forgot about the munmap path.  That calls zap_page_range() which calls
> set_page_dirty() which calls page_mapping().  If we use page->mapping,
> that's going to get interpreted as an address_space pointer.
> 
> *sigh*.  Foiled at every turn.

Yes, indeed! - And very frustrating.  It's keeping me up at night.
I'm dreaming about 32 vs 64 bit data structures. My fitbit stats tell
me that I don't sleep well with these kind of dreams ;-)

> I'm kind of inclined towards using two (or more) bits for PageSlab as
> we discussed here:
> 
> https://lore.kernel.org/linux-mm/01000163efe179fe-d6270c58-eaba-482f-a6bd-334667250ef7-000000@email.amazonses.com/
> 
> so we have PageKAlloc that's true for PageSlab, PagePool, PageDMAPool,
> PageVMalloc, PageFrag and maybe a few other kernel-internal allocations.

I actually like this idea a lot.  I also think it will solve or remove
Matteo/Ilias'es[2] need to introduce the pp_magic signature.  Ilias do
say[1] that page_pool pages could be used for TCP RX zerocopy, but I
don't think we should "allow" that (meaning page_pool should drop the
DMA-mapping and give up recycling).  I should argue why in that thread.

That said, I think we need to have a quicker fix for the immediate
issue with 64-bit bit dma_addr on 32-bit arch and the misalignment hole
it leaves[3] in struct page.  In[3] you mention ppc32, does it only
happens on certain 32-bit archs?

I'm seriously considering removing page_pool's support for doing/keeping
DMA-mappings on 32-bit arch's.  AFAIK only a single driver use this.

> (see also here:)
> https://lore.kernel.org/linux-mm/20180518194519.3820-18-willy@infradead.org/

[1] https://lore.kernel.org/netdev/YHHuE7g73mZNrMV4@enceladus/
[2] https://patchwork.kernel.org/project/netdevbpf/patch/20210409223801.104657-3-mcroce@linux.microsoft.com/
[3] https://lore.kernel.org/linux-mm/20210410024313.GX2531743@casper.infradead.org/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

