Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8590363234
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 22:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237017AbhDQUX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 16:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbhDQUXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 16:23:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CCBC061574;
        Sat, 17 Apr 2021 13:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BnSKcc0JSuohlN33+Pj8bhxKsI7DT+Owp2PFJxUm9vg=; b=OEMC9XOgR/fKU/0oPNUu/P7cCL
        FT4t01GafWZlc1vjwl9KSjRt1IY8zFxgga7gHLRR+WCKupSKq6t9mxOaZIZufePDNN7mCVh1kH9jR
        F0u0g7a9CwiXrlGEHglrLCjcUmY6riPVWU0Qfcwq6bjvHqJmgaIV9kM3woRxgGCelw9NDnFMhLDTu
        ddS052/dNjJg/5EC844nFoPlje4sglQZ/dDMtCOaSHxgsq/MS3GcQFiMjlzkT3lk3nRsLRtoZo+VR
        X2xbTp+70dqUigqbpfzkNLRorcOijpiu4WZdd3t8LIzJQrj1saQRlw3+7gG/AlVzE/uFz4w1OL3ap
        wbKEi5/Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXrSi-00Belm-JF; Sat, 17 Apr 2021 20:22:44 +0000
Date:   Sat, 17 Apr 2021 21:22:40 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        mcroce@linux.microsoft.com, grygorii.strashko@ti.com,
        arnd@kernel.org, hch@lst.de, linux-snps-arc@lists.infradead.org,
        mhocko@kernel.org, mgorman@suse.de
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210417202240.GS2531743@casper.infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org>
 <YHspptFx+T588KcG@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHspptFx+T588KcG@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 09:32:06PM +0300, Ilias Apalodimas wrote:
> > +static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> > +{
> > +	page->dma_addr[0] = addr;
> > +	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> > +		page->dma_addr[1] = addr >> 16 >> 16;
> 
> The 'error' that was reported will never trigger right?
> I assume this was compiled with dma_addr_t as 32bits (so it triggered the
> compilation error), but the if check will never allow this codepath to run.
> If so can we add a comment explaining this, since none of us will remember why
> in 6 months from now?

That's right.  I compiled it all three ways -- 32-bit, 64-bit dma, 32-bit long
and 64-bit.  The 32/64 bit case turn into:

	if (0)
		page->dma_addr[1] = addr >> 16 >> 16;

which gets elided.  So the only case that has to work is 64-bit dma and
32-bit long.

I can replace this with upper_32_bits().

