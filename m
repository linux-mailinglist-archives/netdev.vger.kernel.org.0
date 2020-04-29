Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8963D1BD1E7
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 03:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgD2By0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 21:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2By0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 21:54:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C46C03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 18:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jY0wjklF6SswnoOtnaHaRYY82tksyHsmPYoz5b7AlCo=; b=j6ViSTNOlrtt5ENsDEtQgXZ/zR
        4+qOOLR4pUCwuVDfeKLrc82h1NAPdcZltjT8WH0mzAGdwj7Kaxps4/thC/B2QobCzfeqDFvv+XYBx
        8+IqVPBoPLef2xfy6ylSUw6faafETYMIgPHg42+3LclkrBDRZudyACN3miRK0naDhcALp7JFbjb8M
        Q118XbXZVPEckJDm82SO9ZrmergkPGpa9W5akT3wD2+lCZFo49ORC17zrWq84L1j5kgbkast+DgeT
        Pih7xzD/0RV7g/YtapfSZSBnvdP6PH4CCVCHEr96XwuiLBCyNio0j01I4rDP0J7UweArfeYNhrgwW
        frVisnLQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTbva-0000FA-If; Wed, 29 Apr 2020 01:54:22 +0000
Date:   Tue, 28 Apr 2020 18:54:22 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mgorman@techsingularity.net,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next PATCH V3 1/3] mm: add dma_addr_t to struct page
Message-ID: <20200429015422.GQ29705@bombadil.infradead.org>
References: <155002290134.5597.6544755780651689517.stgit@firesoul>
 <155002294008.5597.13759027075590385810.stgit@firesoul>
 <20200429003843.rh2pasek7v5o3h63@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429003843.rh2pasek7v5o3h63@box>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 03:38:43AM +0300, Kirill A. Shutemov wrote:
> On Wed, Feb 13, 2019 at 02:55:40AM +0100, Jesper Dangaard Brouer wrote:
> > The page_pool API is using page->private to store DMA addresses.
> > As pointed out by David Miller we can't use that on 32-bit architectures
> > with 64-bit DMA
> > +		struct {	/* page_pool used by netstack */
> > +			/**
> > +			 * @dma_addr: might require a 64-bit value even on
> > +			 * 32-bit architectures.
> > +			 */
> > +			dma_addr_t dma_addr;
> > +		};
> 
> [ I'm slow, but I've just noticed this change into struct page. ]
> 
> Is there a change that the dma_addr would have bit 0 set? If yes it may
> lead to false-positive PageTail() and really strange behaviour.

No.  It's the DMA address of the page, so it's going to be page aligned
and have the bottom 12 (or so) bits cleared.  It's not feasible for some
wacky IOMMU to use the bottom N bits for its own purposes because you can,
say, add three to the DMA address of the page and expect the device to
DMA to the third byte within the page.

Wacky IOMMUs use the top bits for storing "interesting" information.

