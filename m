Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF4E3E0C30
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 03:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbhHEBvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 21:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbhHEBvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 21:51:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB35C061765;
        Wed,  4 Aug 2021 18:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=+AyhSExA3Fnz/39iPyMXN4re8NRswkCJG6tx7OX3bQs=; b=Po6jD2Fj1SsJ0rdIY4FEhex3hb
        UitNhZti2gsvHktX5KS1YXB6twYhbngjCjeQjwWnUoEgXvDmi5wVW3VBH/DNIkfJvOxsZ71foPJ8f
        tGNYJ0/0ZAzGxfp/WV9VRCDDe0Grnr9nST62P2cdDuIUWmNcIYVXvoBgRNWpaKENEPh9mIlq0Jk1p
        6W9iaFU+bfYDTn3FYhFdrg9GisiBnQhMzo+5UdDSvUaB5EUsLRIykkXDCV3EHX7dBcBljBdRJeeKi
        Wiv1JVE7CxqoFFsqrHQkNkZzeH6Jz77rb0p6I/RDTEXjJORaxvQwf1/limfYqMCi/81HoTRDJafyW
        qTC/iiNw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mBSWI-006UNQ-Pk; Thu, 05 Aug 2021 01:50:09 +0000
Date:   Thu, 5 Aug 2021 02:50:02 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, mcroce@microsoft.com,
        alexander.duyck@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        chenhao288@hisilicon.com
Subject: Re: [PATCH net] page_pool: mask the page->signature before the
 checking
Message-ID: <YQtDynWsDxZ/T41e@casper.infradead.org>
References: <1628125617-49538-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1628125617-49538-1-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 09:06:57AM +0800, Yunsheng Lin wrote:
> As mentioned in commit c07aea3ef4d4 ("mm: add a signature
> in struct page"):
> "The page->signature field is aliased to page->lru.next and
> page->compound_head."
> 
> And as the comment in page_is_pfmemalloc():
> "lru.next has bit 1 set if the page is allocated from the
> pfmemalloc reserves. Callers may simply overwrite it if they
> do not need to preserve that information."
> 
> The page->signature is or’ed with PP_SIGNATURE when a page is
> allocated in page pool, see __page_pool_alloc_pages_slow(),
> and page->signature is checked directly with PP_SIGNATURE in
> page_pool_return_skb_page(), which might cause resoure leaking
> problem for a page from page pool if bit 1 of lru.next is set for
> a pfmemalloc page.
> 
> As bit 0 is page->compound_head, So mask both bit 0 and 1 before
> the checking in page_pool_return_skb_page().

No, you don't understand.  We *want* the check to fail if we were low
on memory so we return the emergency allocation.
