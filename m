Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2755235FD57
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhDNVgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhDNVgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 17:36:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DA1C061574;
        Wed, 14 Apr 2021 14:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tiw0DSloQ939N1jQWOHUVqWakm9NGqZcvctG7ish7wk=; b=NsnSuNJytEImhL0Wo1cnKZ+7p9
        hHDLgKAJmuc/sHV7PxTbuuD4fJJ/J45u+/OMxBTS22YR7iIa+UYkqxN/gw8DmaU/dhnYxfek0WAl/
        EbqdwP8/2gdyPo96cf2wgNpsRvCy2X2e0tY8tuXdetX5UUk2RVgLrDNfo1FCPU5d0nU+b2vDEXV+F
        R5rW9JgGm8/SUwNGZuq+2tWKp47J0pTlUAu56KYCGGg4qlZ9MsL9iwJxxGMhITMU3iNjoYQVhtdH1
        huQUgK3Omj03NxN1K8suu9wQDUZb56zB4+gYivQGVkqHlCi/oYqL/F+XGVdyzo4j22SCP0GWB3riv
        tV58OZWw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lWnAy-007fMW-F1; Wed, 14 Apr 2021 21:36:00 +0000
Date:   Wed, 14 Apr 2021 22:35:56 +0100
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
Message-ID: <20210414213556.GY2531743@casper.infradead.org>
References: <20210410205246.507048-1-willy@infradead.org>
 <20210410205246.507048-2-willy@infradead.org>
 <20210411114307.5087f958@carbon>
 <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414211322.3799afd4@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 09:13:22PM +0200, Jesper Dangaard Brouer wrote:
> (If others want to reproduce).  First I could not reproduce on ARM32.
> Then I found out that enabling CONFIG_XEN on ARCH=arm was needed to
> cause the issue by enabling CONFIG_ARCH_DMA_ADDR_T_64BIT.

hmmm ... you should be able to provoke it by enabling ARM_LPAE,
which selects PHYS_ADDR_T_64BIT, and

config ARCH_DMA_ADDR_T_64BIT
        def_bool 64BIT || PHYS_ADDR_T_64BIT

>  struct page {
>         long unsigned int          flags;                /*     0     4 */
> 
>         /* XXX 4 bytes hole, try to pack */
> 
>         union {
>                 struct {
>                         struct list_head lru;            /*     8     8 */
>                         struct address_space * mapping;  /*    16     4 */
>                         long unsigned int index;         /*    20     4 */
>                         long unsigned int private;       /*    24     4 */
>                 };                                       /*     8    20 */
>                 struct {
>                         dma_addr_t dma_addr;             /*     8     8 */
>                 };                                       /*     8     8 */
[...]
>         } __attribute__((__aligned__(8)));               /*     8    24 */
>         union {
>                 atomic_t           _mapcount;            /*    32     4 */
>                 unsigned int       page_type;            /*    32     4 */
>                 unsigned int       active;               /*    32     4 */
>                 int                units;                /*    32     4 */
>         };                                               /*    32     4 */
>         atomic_t                   _refcount;            /*    36     4 */
> 
>         /* size: 40, cachelines: 1, members: 4 */
>         /* sum members: 36, holes: 1, sum holes: 4 */
>         /* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
>         /* last cacheline: 40 bytes */
> } __attribute__((__aligned__(8)));

If you also enable CONFIG_MEMCG or enough options to make
LAST_CPUPID_NOT_IN_PAGE_FLAGS true, you'll end up with another 4-byte
hole at the end.
