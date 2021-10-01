Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399E141E68C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 06:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239140AbhJAEVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 00:21:47 -0400
Received: from verein.lst.de ([213.95.11.211]:33575 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230351AbhJAEVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 00:21:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C70FC67373; Fri,  1 Oct 2021 06:19:59 +0200 (CEST)
Date:   Fri, 1 Oct 2021 06:19:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Hamza Mahfooz <someguy@effective-light.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Message-ID: <20211001041959.GA17448@lst.de>
References: <20210518125443.34148-1-someguy@effective-light.com> <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com> <20210914154504.z6vqxuh3byqwgfzx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210914154504.z6vqxuh3byqwgfzx@skbuf>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 03:45:06PM +0000, Ioana Ciornei wrote:
> [  245.927020] fsl_dpaa2_eth dpni.3: scather-gather idx 0 P=20a7320000 N=20a7320 D=20a7320000 L=30 DMA_BIDIRECTIONAL dma map error check not applicable·
> [  245.927048] fsl_dpaa2_eth dpni.3: scather-gather idx 1 P=20a7320030 N=20a7320 D=20a7320030 L=5a8 DMA_BIDIRECTIONAL dma map error check not applicable
> [  245.927062] DMA-API: cacheline tracking EEXIST, overlapping mappings aren't supported
> 
> The first line is the dump of the dma_debug_entry which is already present
> in the radix tree and the second one is the entry which just triggered
> the EEXIST.
> 
> As we can see, they are not actually overlapping, at least from my
> understanding. The first one starts at 0x20a7320000 with a size 0x30
> and the second one at 0x20a7320030.

They overlap the cache lines.  Which means if you use this driver
on a system that is not dma coherent you will corrupt data.
