Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA6136120F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234407AbhDOSXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbhDOSXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:23:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5BAC061574;
        Thu, 15 Apr 2021 11:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gKCpPVH0zLH7350hew5abAqhtVNiLjtRV76fLbYYb+0=; b=wG2nyDBrfmLZ4TcBpx88r9PWVl
        3U4kADELcVjuOPtZ5l8fWM5FpiPi0MvBChU6z4pigm+4d3/IyA/rykcPa6Ez2VigbwsC3UPnAkc+W
        vmN6atSs4SENxN5qvX557Ool3O69b3V6wSZcG/sJdVonl+UIoHK4kJPxespkgvCzKBL4WcPuyLpsq
        dViYcOw65GEk5Yxkc7RgzTl1+mj9yvOsC/RM+WdC+denGdvUNnPA+IkH0/brZB3SoO7Z69nF0JFbG
        amnxq8lvQoXIjmGnk8OMhvVLPob0uEI+l0LEm5vy67THKuFe7CM62OBgG/ON01RHKhpOZ7BZZS/fQ
        ZY8+hw0g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lX6cl-008vZa-Uh; Thu, 15 Apr 2021 18:22:01 +0000
Date:   Thu, 15 Apr 2021 19:21:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210415182155.GD2531743@casper.infradead.org>
References: <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415200832.32796445@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> +static inline
> +dma_addr_t page_pool_dma_addr_read(dma_addr_t dma_addr)
> +{
> +	/* Workaround for storing 64-bit DMA-addr on 32-bit machines in struct
> +	 * page.  The page->dma_addr share area with page->compound_head which
> +	 * use bit zero to mark compound pages. This is okay, as DMA-addr are
> +	 * aligned pointers which have bit zero cleared.
> +	 *
> +	 * In the 32-bit case, page->compound_head is 32-bit.  Thus, when
> +	 * dma_addr_t is 64-bit it will be located in top 32-bit.  Solve by
> +	 * swapping dma_addr 32-bit segments.
> +	 */
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT

#if defined(CONFIG_ARCH_DMA_ADDR_T_64BIT) && defined(__BIG_ENDIAN)
otherwise you'll create the problem on ARM that you're avoiding on PPC ...

I think you want to delete the word '_read' from this function name because
you're using it for both read and write.

