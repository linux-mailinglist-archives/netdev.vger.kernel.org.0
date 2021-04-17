Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C634D362D2C
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbhDQDUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhDQDUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:20:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3A7C061574;
        Fri, 16 Apr 2021 20:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GyfHo5X+9TYxXDQBPsebhce873z4IO94hxWr4yFJsxk=; b=eLkRpqM9nVcIRoyRLRDTRb+BGw
        8Awo1hTN6pG0fPX4ENPtHTgJ48U/u51Nl9T7MLyFIioyj8ndHPm3xgvLjM9WDUKO5myVwtcj1L/tA
        vxyewxTVxm2oJidWu97Sn26XMpfCR94JhZaH1KmJvz8URVQ+vtrELkUHkUpY25zznz8ZZsxrr1F4C
        jZFWtzr1IDbg8asen9M5hZEr8pqF5z+i2kZWHrwxjbtCtUXLIA2GHxtapiozrml/Zzh4A0tEnLKFb
        ZThBj+SmcItxXjZ5LILeRy9iqYUuhHuFH2RjpdGU724ns0j//tKwz/QkauIH43rk3hZw41DH66Nr6
        qRM5Tlkw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXbUA-00AmRw-8N; Sat, 17 Apr 2021 03:19:10 +0000
Date:   Sat, 17 Apr 2021 04:19:06 +0100
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
Message-ID: <20210417031906.GQ2531743@casper.infradead.org>
References: <20210411103318.GC2531743@casper.infradead.org>
 <20210412011532.GG2531743@casper.infradead.org>
 <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210416152755.GL2531743@casper.infradead.org>
 <20210416190823.3b3aace0@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416190823.3b3aace0@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 07:08:23PM +0200, Jesper Dangaard Brouer wrote:
> On Fri, 16 Apr 2021 16:27:55 +0100
> Matthew Wilcox <willy@infradead.org> wrote:
> 
> > On Thu, Apr 15, 2021 at 08:08:32PM +0200, Jesper Dangaard Brouer wrote:
> > > See below patch.  Where I swap32 the dma address to satisfy
> > > page->compound having bit zero cleared. (It is the simplest fix I could
> > > come up with).  
> > 
> > I think this is slightly simpler, and as a bonus code that assumes the
> > old layout won't compile.
> 
> This is clever, I like it!  When reading the code one just have to
> remember 'unsigned long' size difference between 64-bit vs 32-bit.
> And I assume compiler can optimize the sizeof check out then doable.

I checked before/after with the replacement patch that doesn't
have compiler warnings.  On x86, there is zero codegen difference
(objdump -dr before/after matches exactly) for both x86-32 with 32-bit
dma_addr_t and x86-64.  For x86-32 with 64-bit dma_addr_t, the compiler
makes some different inlining decisions in page_pool_empty_ring(),
page_pool_put_page() and page_pool_put_page_bulk(), but it's not clear
to me that they're wrong.

Function                                     old     new   delta
page_pool_empty_ring                         387     307     -80
page_pool_put_page                           604     516     -88
page_pool_put_page_bulk                      690     517    -173

