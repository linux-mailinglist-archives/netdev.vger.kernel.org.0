Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEF966490D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 19:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbjAJSRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 13:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239071AbjAJSRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 13:17:17 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998B285C96
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 10:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MdbdlmiuJNQCX/3+KpwhOIUbZ8WZP/ZzBLy4PzTanL0=; b=Ixq/CIyv/IEWQN4WI0sODkxeot
        GgM/isjKrkPkbIi3MKouB+5Ki5pj3kMMEzkYQnOQAa5whJwqWO330oSoyFI1nm6WqJZOnEgN4UH2y
        gHsJiSoeOoBnLdO99xQkTs/xn2hguVOSakuu3ga2gI8zXreHmuWuoiiiOJVRQnESdgxUxxvFPF7ym
        xYLVYKkxGXJiWr3VPUSwV8VOZfwNqCe/t5tFl8qWynJ+2pvz3x4K7N5pCdjQnNa895XLwlC7v2lAS
        BC05VoTOUIcGsHvNxnuHiNvmM/f8y6RLBh9CC8bNotYldOJnxuyeFrCseO3nUR5KTYlSJA7rLhlZE
        zXp1ixDA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFJ9y-003Qmw-Tm; Tue, 10 Jan 2023 18:15:43 +0000
Date:   Tue, 10 Jan 2023 18:15:42 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 03/24] page_pool: Add netmem_set_dma_addr() and
 netmem_get_dma_addr()
Message-ID: <Y72rTrFzDiMJLfc3@casper.infradead.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-4-willy@infradead.org>
 <CAC_iWj+bDVMptma_DjQkCZzcardXxShJ965=6zc0_6ffciQhXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_iWj+bDVMptma_DjQkCZzcardXxShJ965=6zc0_6ffciQhXw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 07:30:30PM +0200, Ilias Apalodimas wrote:
> Hi Matthew

Hey Ilias.  Thanks for all the review!

> > -static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> > +static inline dma_addr_t netmem_get_dma_addr(struct netmem *nmem)
> 
> Ideally, we'd like to avoid having people call these directly and use
> the page_pool_(get|set)_dma_addr wrappers.  Can we add a comment in
> v3?

I don't think this is what we want.  Currently drivers call
page_pool_get_dma_addr() on pages that are presumably from the page
pool, but the compiler isn't going to help them out if they just
get the struct page from somewhere random.  They'll get garbage and
presumably crash.

By returning a netmem pointer from page_pool, we help drivers ensure
that they're only passing around memory that was actually allocated
from the page_pool and so they won't get garbage if they pass it to
netmem_get_dma_addr().  The page_pool_get_dma_addr() wrapper is
a temporary measure until we have all the drivers converted to
use netmem alone.

Does that all make sense, or have I misunderstood what you wanted
from a comment?

