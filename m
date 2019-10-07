Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071C1CE22A
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbfJGMsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:48:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbfJGMsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 08:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wMm+Q1AQe3MKdu1giulBb8H+6dom7FXD4ybaYMRdbw4=; b=f4HDQY4mke2eSnFVGRilAYEPh
        PjWN+ZElO60g7xKKzWqDptByI0V5WdlXF2OZegEQmNoiVqEUsN4Ac7OktaLK2MBNZwTzUbKDVH6m/
        2bNT5UEF5W2k892ynRYWRIJGRTLZiNRAqXfgMusUObIUp+B3p+l4btEtEFYZYq4A9IMSWbg4/LocT
        /U3i+BVq3YD2E/ovLyR6X0wXFKqUoExvHpKM0Bc4ySfUrCVZZwUTll3rPIpbG9CAke8uAuUwidzeU
        0SHPlfYXHt+UZiEoaKFQDHv0IHg1EbN4JY7cCcbi3nmSbOEUpUy9vgs+LKKE8aj1XVMaPFQcmWkTR
        VA2UnvGmw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHSRD-00066o-FJ; Mon, 07 Oct 2019 12:48:31 +0000
Date:   Mon, 7 Oct 2019 05:48:31 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007124831.GA20840@infradead.org>
References: <20191007115819.9211-1-leon@kernel.org>
 <20191007115819.9211-3-leon@kernel.org>
 <20191007121244.GA19843@infradead.org>
 <20191007123656.GW5855@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007123656.GW5855@unreal>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 03:36:56PM +0300, Leon Romanovsky wrote:
> > >  	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
> > >  		return true;
> > > +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE &&
> > > +	    dma_nents > dev->attrs.max_sgl_rd)
> > > +		return true;
> >
> > This can be simplified to:
> >
> > 	if (dir == DMA_FROM_DEVICE &&
> > 	    (rdma_protocol_iwarp(dev, port_num) ||
> > 	     (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)))
> > 		return true;
> 
> I don't think that it simplifies and wanted to make separate checks to
> be separated. For example, rdma_protocol_iwarp() has nothing to do with
> attrs.max_sgl_rd.

The important bit is to have the DMA_FROM_DEVICE check only once, as
we only do the registration for reads with either parameter.  So if
you want it more verbose the wya would be:

 	if (dir == DMA_FROM_DEVICE) {
		if (rdma_protocol_iwarp(dev, port_num))
			return true;
		if (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)
			return true;
	}
