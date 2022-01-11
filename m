Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F2C48BA84
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345466AbiAKWJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:09:26 -0500
Received: from ale.deltatee.com ([204.191.154.188]:49446 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbiAKWJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 17:09:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=Ea3/TfTxnBizgPzQyGep0ghYBk0hbGQaIDnneO+IVxM=; b=n28l4tU4hMcGmq66NzaaHE2bgM
        DLtZM1k0CMmcynt95oE9h0HRhweiVxNXojoxFWf2yRWNJS9ZBjOqlWoQ2pd5h6x2Dja/MDMQxce4h
        oC4wWWh7fyC2fM+VSsghTwbh9vsQKdiXBQ1gn4feOPPSodQaYZq+Qjf9nVlB6xdH7gUCyyIyA5SDB
        kd+Jw0ZcrPVZTrek2/BUeREf/XC9z/tYBcWTs9Ss6gvRjyZX6HCf8rrhXu6Q3C/XPn/EfIrLxjRE3
        AFLxscv0jUHFqxFFUr+MNIjLV+z4FrJWWTnywtnmhaO9c987fXwNpO2H8Afye56wVIxz2W0+ce2Ej
        t7wlui9A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1n7PKO-009nQW-1A; Tue, 11 Jan 2022 15:09:17 -0700
To:     Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <20220111004126.GJ2328285@nvidia.com> <Yd0IeK5s/E0fuWqn@casper.infradead.org>
 <20220111150142.GL2328285@nvidia.com> <Yd3Nle3YN063ZFVY@casper.infradead.org>
 <20220111202159.GO2328285@nvidia.com> <Yd311C45gpQ3LqaW@casper.infradead.org>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ef01ce7d-f1d3-0bbb-38ba-2de4d3f7e31a@deltatee.com>
Date:   Tue, 11 Jan 2022 15:09:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Yd311C45gpQ3LqaW@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: nvdimm@lists.linux.dev, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-block@vger.kernel.org, ming.lei@redhat.com, jhubbard@nvidia.com, joao.m.martins@oracle.com, hch@lst.de, linux-kernel@vger.kernel.org, jgg@nvidia.com, willy@infradead.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A autolearn=ham autolearn_force=no version=3.4.6
Subject: Re: Phyr Starter
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-01-11 2:25 p.m., Matthew Wilcox wrote:
> That's reproducing the bad decision of the scatterlist, only with
> a different encoding.  You end up with something like:
> 
> struct neoscat {
> 	dma_addr_t dma_addr;
> 	phys_addr_t phys_addr;
> 	size_t dma_len;
> 	size_t phys_len;
> };
> 
> and the dma_addr and dma_len are unused by all-but-the-first entry when
> you have a competent IOMMU.  We want a different data structure in and
> out, and we may as well keep using the scatterlist for the dma-map-out.

With my P2PDMA patchset, even with a competent IOMMU, we need to support
multiple dma_addr/dma_len pairs (plus the flag bit). This is required to
program IOVAs and multiple bus addresses into a single DMA transactions.

I think using the scatter list for the DMA-out side is not ideal seeing
we don't need the page pointers or multiple length fields and we won't
be able to change the sgl substantially given the massive amount of
existing use cases that won't go away over night.

My hope would be along these lines:

struct phy_range {
    phys_addr_t phyr_addr;
    u32 phyr_len;
    u32 phyr_flags;
};

struct dma_range {
    dma_addr_t dmar_addr;
    u32 dmar_len;
    u32 dmar_flags;
};

A new GUP helper would somehow return a list of phy_range structs and
the new dma_map function would take that list and return a list of
dma_range structs. Each element in the list could represent a segment up
to 4GB, so any range longer than that would need multiple items in the
list. (Alternatively, perhaps the length could be a 64bit value and we
steal some of the top bits for flags or some such). The flags would not
only be needed by some of the use cases mentioned (FOLL_PIN or
DMA_BUS_ADDRESS) but could also support chaining these lists like SGLs
so continuous vmallocs would not be necessary for longer lists.

If there's an [phy|dma]_range_list struct (or some such) which contains
these range structs (per some details of Jason's suggestions) that'd be
fine by me too and would just depend on implementation details.

However, the main problem I see is a chicken and egg problem. The new
dma_map function would need to be implemented by every dma_map provider
or any driver trying to use it would need a messy fallback. Either that,
or we need a wrapper that allocates an appropriately sized SGL to pass
to any dma_map implementation that doesn't support the new structures.

Logan
