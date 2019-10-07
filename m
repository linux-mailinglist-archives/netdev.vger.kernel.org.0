Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81613CE1DF
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfJGMhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727467AbfJGMhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 08:37:00 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDDD21655;
        Mon,  7 Oct 2019 12:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570451819;
        bh=KbrfUILisgZfU+U/a7mv6OG2qRS311DhSAdU6VQp+lQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ESuZ98AWJ6z0c/ECqNw6QJwwqGm+nIcU+RMnrQ1F8TOh6OOpIbUMwQ4ekDTR2k48B
         ycA6/6U6lkBhEUMGnKsn333VBszbzp9PS1YD7OZ0NHGjgRg0uqbk1ADkXgH2jwgavN
         evUlk4f/YCqmerDGnhQXHu9oxpJIV/GjQC5BUuUo=
Date:   Mon, 7 Oct 2019 15:36:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007123656.GW5855@unreal>
References: <20191007115819.9211-1-leon@kernel.org>
 <20191007115819.9211-3-leon@kernel.org>
 <20191007121244.GA19843@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007121244.GA19843@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 05:12:44AM -0700, Christoph Hellwig wrote:
> Sorry for nitpicking again, but..
>
> On Mon, Oct 07, 2019 at 02:58:18PM +0300, Leon Romanovsky wrote:
> > @@ -37,15 +39,15 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
> >   * Check if the device will use memory registration for this RW operation.
> >   * We currently always use memory registrations for iWarp RDMA READs, and
> >   * have a debug option to force usage of MRs.
> > - *
> > - * XXX: In the future we can hopefully fine tune this based on HCA driver
> > - * input.
>
> The above comment needs an updated a la:
>
>  * Check if the device will use memory registration for this RW operation.
>  * For RDMA READs we must use MRs on iWarp and can optionaly use them as an
>  * optimaztion otherwise.  Additionally we have a debug option to force usage
>  * of MRs to help testing this code path.
>
>
> >  	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
> >  		return true;
> > +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE &&
> > +	    dma_nents > dev->attrs.max_sgl_rd)
> > +		return true;
>
> This can be simplified to:
>
> 	if (dir == DMA_FROM_DEVICE &&
> 	    (rdma_protocol_iwarp(dev, port_num) ||
> 	     (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)))
> 		return true;

I don't think that it simplifies and wanted to make separate checks to
be separated. For example, rdma_protocol_iwarp() has nothing to do with
attrs.max_sgl_rd.

I'll fix comment.

Thanks
