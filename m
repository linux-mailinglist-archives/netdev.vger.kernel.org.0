Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F40268FCF
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgINP1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgINP0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:26:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE965C06174A;
        Mon, 14 Sep 2020 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7O2Rc307Jq8KkaDn7zbVItvtt/ecHc/too3yP9zxMNw=; b=M80c+D3BqJySppi+H3eNYCcnH/
        gkfi1LX5tkOxqiYr7vGlDhimfScWmyFoD4H7IZc29yxj59fxiZw4CTf73qE/Frs6kv2D1VP9Z0cDk
        mxHwC6y23VXZp0GWVeuCJj/TuYsYfRbshYeLxTfn4NkxNbZt/mCYZDG48aAzhZnPSD26Tjx+8/mwu
        2BX9yzKsoQKr11uV/Bwnigc9od3UdV8s2rG69+T+l2QU+9l3XPVzWYgBbLqR3TeV+3H8nv+hHYZRQ
        AbZDHlAxP767K2OWIVLYATsG32mlziFsc93sPs4pmGxH1oa7RFwa/hq19KGZWcLA7yuKXtQ9v35Ul
        oAwe3FdQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHqN0-0004bK-27; Mon, 14 Sep 2020 15:26:18 +0000
Date:   Mon, 14 Sep 2020 16:26:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: Re: a saner API for allocating DMA addressable pages v2
Message-ID: <20200914152617.GR6583@casper.infradead.org>
References: <20200914144433.1622958-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914144433.1622958-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 04:44:16PM +0200, Christoph Hellwig wrote:
> I'm still a little unsure about the API naming, as alloc_pages sort of
> implies a struct page return value, but we return a kernel virtual
> address.

Erm ... dma_alloc_pages() returns a struct page, so is this sentence
stale?

From patch 14:

+struct page *dma_alloc_pages(struct device *dev, size_t size,
+               dma_addr_t *dma_handle, enum dma_data_direction dir, gfp_t gfp);

> The other alternative would be to name the API
> dma_alloc_noncoherent, but the whole non-coherent naming seems to put
> people off.

You say that like it's a bad thing.  I think the problem is more that
people don't understand what non-coherent means and think they're
supporting it when they're not.

dma_alloc_manual_flushing()?

> As a follow up I plan to move the implementation of the
> DMA_ATTR_NO_KERNEL_MAPPING flag over to this framework as well, given
> that is also is a fundamentally non coherent allocation.  The replacement
> for that flag would then return a struct page, as it is allowed to
> actually return pages without a kernel mapping as the name suggested
> (although most of the time they will actually have a kernel mapping..)

If the page doesn't have a kernel mapping, shouldn't it return a PFN
or a phys_addr?

