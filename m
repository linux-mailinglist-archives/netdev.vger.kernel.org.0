Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721EA4CC46
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 12:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfFTKv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 06:51:56 -0400
Received: from verein.lst.de ([213.95.11.211]:59434 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFTKv4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 06:51:56 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id 558CF68B20; Thu, 20 Jun 2019 12:51:24 +0200 (CEST)
Date:   Thu, 20 Jun 2019 12:51:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: use exact allocation for dma coherent memory
Message-ID: <20190620105124.GA25233@lst.de>
References: <20190614134726.3827-1-hch@lst.de> <20190617082148.GF28859@kadam> <20190617083342.GA7883@lst.de> <20190619162903.GF9360@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190619162903.GF9360@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 01:29:03PM -0300, Jason Gunthorpe wrote:
> > Yes.  This will blow up badly on many platforms, as sq->queue
> > might be vmapped, ioremapped, come from a pool without page backing.
> 
> Gah, this addr gets fed into io_remap_pfn_range/remap_pfn_range too..
> 
> Potnuri, you should fix this.. 
> 
> You probably need to use dma_mmap_from_dev_coherent() in the mmap ?

The function to use is dma_mmap_coherent, dma_mmap_from_dev_coherent is
just an internal helper.

That beiŋ said the drivers/infiniband code has a lot of
*remap_pfn_range, and a lot of them look like they might be for
DMA memory.
