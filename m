Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE9D665D0B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAKNuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239515AbjAKNnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:43:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E819720E
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cItd0bY8oSKhHtDYzW+0pBisbZrmS7bJcbFH1GTRgO8=; b=rpw7rC4ch4ZPQlmQAxYYWGufXX
        9VYUI5FeCcGREzOlPcqkuSr7kuR+EaFyfUlCPv9YOy0hPxIXMY0smxBket2gMg/AuyckJxFrC0S8E
        Q6S/9xiJ0ULS9dQ+WxWrUaJi0DdPZdrDCJNlo+dRcXPA9m0xTPU1VCtsa3wrpGV+YbaS/lJGDyKOS
        hbLI3t3N9lSMf0KVnLbJ6km0WLYe///8G+TIAZnUPWwnqAPlMmDEOtrPkgtR7+jacov+mHsKmjUE5
        rvbM2jtAYLX9nJOLRqR79KtOkAgu0Y6yqnQ6uGQSrc5ZtS3piiPSqmhsEJU5EeJYnc7pxdxPfvnS3
        fIu8c+JA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFbON-004Ar5-2G; Wed, 11 Jan 2023 13:43:47 +0000
Date:   Wed, 11 Jan 2023 13:43:47 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 18/26] page_pool: Allow page_pool_recycle_direct() to
 take a netmem or a page
Message-ID: <Y769E3ZpCCuykk94@casper.infradead.org>
References: <20230111042214.907030-19-willy@infradead.org>
 <202301112022.zmClDxtO-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202301112022.zmClDxtO-lkp@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 08:48:30PM +0800, kernel test robot wrote:
> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c:2978:4: error: controlling expression type 'void *' not compatible with any generic association type
>                            page_pool_recycle_direct(rxr->page_pool, data);
>                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I swear I did an allmodconfig build ... don't know how I missed this
one.  I think I'll make the page_pool_recycle_direct() macro accept
void * as well, and treat it as a page.  Once we finish the conversion
to netmem, this problem will go away.

ie this:

+++ b/include/net/page_pool.h
@@ -485,7 +485,8 @@ static inline void __page_pool_recycle_page_direct(struct page_pool *pool,
 
 #define page_pool_recycle_direct(pool, mem)    _Generic((mem),         \
        struct netmem *: __page_pool_recycle_direct(pool, (struct netmem *)mem),                \
-       struct page *:   __page_pool_recycle_page_direct(pool, (struct page *)mem))
+       struct page *:   __page_pool_recycle_page_direct(pool, (struct page *)mem),     \
+       void *:  __page_pool_recycle_page_direct(pool, (struct page *)mem))
 
 #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT        \
                (sizeof(dma_addr_t) > sizeof(unsigned long))

