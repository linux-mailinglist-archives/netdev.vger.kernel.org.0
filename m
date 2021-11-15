Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6F2451DB2
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353238AbhKPAca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345463AbhKOT2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 14:28:31 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3353C043193;
        Mon, 15 Nov 2021 10:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WBVQU7ONb1dg6gbZK1HaW1EBdo6qodk77XckevyZUq4=; b=G/na0F58vH4bDXGufMVfFBLv8U
        EBlW/VxENPOy30Ge109XsLBySAMwiYYn6wINE/Lazu4XfJOCGRrbyrbZm5TdkjMRO4og74pon7gHc
        iPo+KcylzeKLXXdFXDNW6nx4c5QV9qPzTEO0cif72PSetQjUUOV6nqQfL9kfwXrjkvkfJ7wB7INa9
        2+LdQS7lxEOqHpiktwiGvQ41IMClQ4QDQx6kEiBV4smBeQsNtFIx62xe66y70Oxi8a1HJBGJE3ffg
        Qt+MMAOYbVye9yo6ydzuF7d+1u+nbYC6oLSMEqFljNkfxHZrbxtgM5dyEgq+bbmxalJuJ4p4xGeiL
        EVnbX77w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmh6O-00GmMZ-7i; Mon, 15 Nov 2021 18:53:12 +0000
Date:   Mon, 15 Nov 2021 10:53:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, akpm@linux-foundation.org, peterz@infradead.org,
        will@kernel.org, jhubbard@nvidia.com, yuzhao@google.com,
        mcroce@microsoft.com, fenghua.yu@intel.com, feng.tang@intel.com,
        jgg@ziepe.ca, aarcange@redhat.com, guro@fb.com,
        "kernelci@groups.io" <kernelci@groups.io>
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
Message-ID: <YZKsmCHWFUUtph2F@infradead.org>
References: <20211013091920.1106-1-linyunsheng@huawei.com>
 <b9c0e7ef-a7a2-66ad-3a19-94cc545bd557@collabora.com>
 <1090744a-3de6-1dc2-5efe-b7caae45223a@huawei.com>
 <644e10ca-87b8-b553-db96-984c0b2c6da1@collabora.com>
 <93173400-1d37-09ed-57ef-931550b5a582@huawei.com>
 <YZJKNLEm6YTkygHM@apalos.home>
 <YZKgFqwJOIEObMg7@infradead.org>
 <YZKrfvt01uTosWc8@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZKrfvt01uTosWc8@apalos.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 08:48:30PM +0200, Ilias Apalodimas wrote:
> page_pool (the API in question), apart from allocating memory can manage
> the mappings for you.  However while doing so it stores some parts (incl
> the dma addr) in struct page.  The code in there could be simplified if 
> we skipped support of the 'mapping' feature for 32-bit architectures with 
> 64-bit DMA.  We thought no driver was using the mapping feature (on 32bits)
> and cleaned up that part, but apparently we missed 
> '32-bit -- LPAE -- page pool manages DMA mappings'

It is a very common configuration on various architectures, so I fear
you'll have to support it and undo the cleanup.
