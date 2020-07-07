Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E58B2166AC
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 08:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgGGGre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 02:47:34 -0400
Received: from verein.lst.de ([213.95.11.211]:57348 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgGGGrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 02:47:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id AD38268AFE; Tue,  7 Jul 2020 08:47:30 +0200 (CEST)
Date:   Tue, 7 Jul 2020 08:47:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] dma-mapping: add a new dma_need_sync API
Message-ID: <20200707064730.GA23602@lst.de>
References: <20200629130359.2690853-1-hch@lst.de> <20200629130359.2690853-2-hch@lst.de> <20200706194227.vfhv5o4lporxjxmq@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706194227.vfhv5o4lporxjxmq@bsd-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 12:42:27PM -0700, Jonathan Lemon wrote:
> On Mon, Jun 29, 2020 at 03:03:56PM +0200, Christoph Hellwig wrote:
> > Add a new API to check if calls to dma_sync_single_for_{device,cpu} are
> > required for a given DMA streaming mapping.
> > 
> > +::
> > +
> > +	bool
> > +	dma_need_sync(struct device *dev, dma_addr_t dma_addr);
> > +
> > +Returns %true if dma_sync_single_for_{device,cpu} calls are required to
> > +transfer memory ownership.  Returns %false if those calls can be skipped.
> 
> Hi Christoph -
> 
> Thie call above is for a specific dma_addr.  For correctness, would I
> need to check every addr, or can I assume that for a specific memory
> type (pages returned from malloc), that the answer would be identical?

You need to check every mapping.  E.g. this API pairs with a
dma_map_single/page call.  For S/G mappings you'd need to call it for
each entry, although if you have a use case for that we really should
add a dma_sg_need_sync helper instea of open coding the scatterlist walk.
