Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC76B66085C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 21:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbjAFUfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 15:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbjAFUfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 15:35:14 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11767A3B5
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 12:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/+ywmFzjmOxKFjuWdyH/7WIPX8vR48fvhI6fnLdcaGs=; b=hBC5oAW/uNU4kZV3mETyOEesnc
        kUprwIvvs/cepzlZ+y0PQcvTNxBM1L6EVEmnEGaGgV0T4arcJjGIs40CNCGq1B3p17utvahf1Y4GP
        lMmqmtIBy2xHV36Q+tY3NsfdFnTx0mopXiIhJmmnRL9jDNklrqZcbWOUn52MUDhQD0702zQVUXlf7
        0OQ9p4OGl4G+O2oyBlWuohhuUTKgE46VI4C0Bc9xo7CgLu2wTAusM2kNWiKliBFHD1D3mr+Fj8gbD
        0AmK09uQNL4YcKYEs2mwyVSeXe1yh8CNEnPWMuGBTClYp4kE4Efkwk+4TTAdD6MWlO/JnGtZC4ctn
        1yu957Og==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pDtQi-00HU5f-Lt; Fri, 06 Jan 2023 20:35:08 +0000
Date:   Fri, 6 Jan 2023 20:35:08 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 02/24] netmem: Add utility functions
Message-ID: <Y7iF/Mu6Wigwkolg@casper.infradead.org>
References: <20230105214631.3939268-3-willy@infradead.org>
 <202301061057.hnJABXCX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202301061057.hnJABXCX-lkp@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 10:24:30AM +0800, kernel test robot wrote:
> >> include/net/page_pool.h:111:21: warning: due to lvalue conversion of the controlling expression, association of type 'const struct netmem' will never be selected because it is qualified [-Wunreachable-code-generic-assoc]
>            return page_to_pfn(netmem_page(nmem));
>                               ^
>    include/net/page_pool.h:100:8: note: expanded from macro 'netmem_page'
>            const struct netmem:    (const struct page *)nmem,              \
>                  ^

OK, figured out what this error means.

#define netmem_page(nmem) (_Generic((*nmem),                            \
        const struct netmem:    (const struct page *)nmem,              \
        struct netmem:          (struct page *)nmem))

Because I defined this with _Generic((*nmem),...) instead of
_Generic((nmem),...) (like page_folio() is defined), clang always
selects the second case and not the const case.  Apparently lvalue
coversions remove the const (backed up by
https://en.cppreference.com/w/c/language/conversion) but I had no idea
that _Generic applied lvalue conversion to the controlling-expression
(it does!  https://en.cppreference.com/w/c/language/generic)

So, yay for clang's extra warning.  I'll fix this up (as below) and send
a v3 next week including the various R-b that I've received.

-#define netmem_page(nmem) (_Generic((*nmem),                           \
-       const struct netmem:    (const struct page *)nmem,              \
-       struct netmem:          (struct page *)nmem))
+#define netmem_page(nmem) (_Generic((nmem),                            \
+       const struct netmem *:  (const struct page *)nmem,              \
+       struct netmem *:        (struct page *)nmem))


