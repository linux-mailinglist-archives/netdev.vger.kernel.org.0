Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE9735F2DD
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348987AbhDNLwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233595AbhDNLwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:52:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02765C061574;
        Wed, 14 Apr 2021 04:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6j2YFPpldChGlEhTkgAYG/8AUFiAqXWlLNjztkCHHPQ=; b=J5BS1O4q7ajQjzXd/LDJSC/n5W
        nLaatbwhpGPw27uZHO96g6+/tyMJhvL6qzIDuTqVYDpLZWsiE1eH4gs+RGnwjwtZofj11rAp/QNXo
        5zG9CPBgECBICOpGLmaKDiNFg88n/0HpOy3h47nUCcA+napEcZ6cGJeegmGXvIMAF1IlI0QKv3yBn
        t6pmOrCaFDoZvjKu2kkCNcN34EEDw6FAeKgqXUk9Y5TV1rcrTtUeqHGfKDG51wcCgKv9JHy4zWIOT
        ccnhwj9yHyFetqx/J/jBsogxkFb+x3kADp7eIqy6wSJt5ccTYHYk9f87uwXMNh3c7s66KKsbIgnZx
        RoTlxVDw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWe2m-0073tL-Rj; Wed, 14 Apr 2021 11:51:01 +0000
Date:   Wed, 14 Apr 2021 12:50:52 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210414115052.GS2531743@casper.infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414101044.19da09df@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 10:10:44AM +0200, Jesper Dangaard Brouer wrote:
> Yes, indeed! - And very frustrating.  It's keeping me up at night.
> I'm dreaming about 32 vs 64 bit data structures. My fitbit stats tell
> me that I don't sleep well with these kind of dreams ;-)

Then you're going to love this ... even with the latest patch, there's
still a problem.  Because dma_addr_t is still 64-bit aligned _as a type_,
that forces the union to be 64-bit aligned (as we already knew and worked
around), but what I'd forgotten is that forces the entirety of struct
page to be 64-bit aligned.  Which means ...

        /* size: 40, cachelines: 1, members: 4 */
        /* padding: 4 */
        /* forced alignments: 1 */
        /* last cacheline: 40 bytes */
} __attribute__((__aligned__(8)));

.. that we still have a hole!  It's just moved from being at offset 4
to being at offset 36.

> That said, I think we need to have a quicker fix for the immediate
> issue with 64-bit bit dma_addr on 32-bit arch and the misalignment hole
> it leaves[3] in struct page.  In[3] you mention ppc32, does it only
> happens on certain 32-bit archs?

AFAICT it happens on mips32, ppc32, arm32 and arc.  It doesn't happen
on x86-32 because dma_addr_t is 32-bit aligned.

Doing this fixes it:

+++ b/include/linux/types.h
@@ -140,7 +140,7 @@ typedef u64 blkcnt_t;
  * so they don't care about the size of the actual bus addresses.
  */
 #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
-typedef u64 dma_addr_t;
+typedef u64 __attribute__((aligned(sizeof(void *)))) dma_addr_t;
 #else
 typedef u32 dma_addr_t;
 #endif

> I'm seriously considering removing page_pool's support for doing/keeping
> DMA-mappings on 32-bit arch's.  AFAIK only a single driver use this.

... if you're going to do that, then we don't need to do this.
