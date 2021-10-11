Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53BD428C55
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 13:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbhJKLtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 07:49:10 -0400
Received: from verein.lst.de ([213.95.11.211]:37037 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231659AbhJKLtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 07:49:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F16AD68B05; Mon, 11 Oct 2021 13:47:06 +0200 (CEST)
Date:   Mon, 11 Oct 2021 13:47:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Message-ID: <20211011114706.GA16350@lst.de>
References: <20210518125443.34148-1-someguy@effective-light.com> <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com> <20210914154504.z6vqxuh3byqwgfzx@skbuf> <185e7ee4-3749-4ccb-6d2e-da6bc8f30c04@linux.ibm.com> <20211001145256.0323957a@thinkpad> <20211006151043.61fe9613@thinkpad> <4a96b583-1119-8b26-cc85-f77a6b4550a2@arm.com> <fd4a2d8d-3f9d-51f3-1c86-8009ad50e6a1@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd4a2d8d-3f9d-51f3-1c86-8009ad50e6a1@linux.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:59:32PM +0200, Karsten Graul wrote:
> In our case its really that a buffer is mapped twice for 2 different devices which we use in SMC to provide failover capabilities. We see that -EEXIST is returned when a buffer is mapped for the second device. Since there is a maximum of 2 parallel mappings we never see the warning shown by active_cacheline_inc_overlap() because we don't exceed ACTIVE_CACHELINE_MAX_OVERLAP.

Mapping something twice is possible, but needs special care.
Basically one device always needs to do the first mapping and the other
one needs to use DMA_ATTR_SKIP_CPU_SYNC to opt out of the coherency
protocol.  So we have two TODO items here: 1) the driver needs to use the
above scheme and 2) this dma-debug check needs to understand
DMA_ATTR_SKIP_CPU_SYNC.  Can I trick you into doing both?
