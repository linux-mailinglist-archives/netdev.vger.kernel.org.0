Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4983935B7FD
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 03:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhDLBQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 21:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235835AbhDLBQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 21:16:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B43FC061574;
        Sun, 11 Apr 2021 18:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=T0Zq9EStO1wC7R34W+g3UOBErmBYCTh0458TpX7pzAM=; b=sJNR212kfJE88C8nTxg0l1UoXm
        Cbal0fqU992DQHm3N5P+Ml/9N9Nv8acJ4+M9c61cLDw5tVx1vo3l6fZZROGO3u3JvlmQVNt4MgFBF
        g/LmZnGbLw61COtglVjylsbOp2kznKGio6cRT0PAyvdOG++3HcY0Qj2N4YAZR7/Ongh3aFzuLqR8m
        XpLj86Ky06EguyRTY9VLPmpIBLI0SVSSf/qM7da3I6iIUxLPkRa6HQGofx88BF7zq2UCvMpdlkUh2
        BFDTkwUVNukJv24on8dSKLRot4g8EsOusTp5QhTE7Rt9RCw1g68fuBAJPJZZ1YyczV5CDfiii3KiL
        qrpu7ngQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lVlAq-003fOL-Tu; Mon, 12 Apr 2021 01:15:34 +0000
Date:   Mon, 12 Apr 2021 02:15:32 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210412011532.GG2531743@casper.infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411103318.GC2531743@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 11:33:18AM +0100, Matthew Wilcox wrote:
> Basically, we have three aligned dwords here.  We can either alias with
> @flags and the first word of @lru, or the second word of @lru and @mapping,
> or @index and @private.  @flags is a non-starter.  If we use @mapping,
> then you have to set it to NULL before you free it, and I'm not sure
> how easy that will be for you.  If that's trivial, then we could use
> the layout:
> 
> 	unsigned long _pp_flags;
> 	unsigned long pp_magic;
> 	union {
> 		dma_addr_t dma_addr;    /* might be one or two words */
> 		unsigned long _pp_align[2];
> 	};
> 	unsigned long pp_pfmemalloc;
> 	unsigned long xmi;

I forgot about the munmap path.  That calls zap_page_range() which calls
set_page_dirty() which calls page_mapping().  If we use page->mapping,
that's going to get interpreted as an address_space pointer.

*sigh*.  Foiled at every turn.

I'm kind of inclined towards using two (or more) bits for PageSlab as
we discussed here:

https://lore.kernel.org/linux-mm/01000163efe179fe-d6270c58-eaba-482f-a6bd-334667250ef7-000000@email.amazonses.com/

so we have PageKAlloc that's true for PageSlab, PagePool, PageDMAPool,
PageVMalloc, PageFrag and maybe a few other kernel-internal allocations.

(see also here:)
https://lore.kernel.org/linux-mm/20180518194519.3820-18-willy@infradead.org/
