Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4CDBCE895
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbfJGQEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 12:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfJGQEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 12:04:00 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70664205C9;
        Mon,  7 Oct 2019 16:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570464239;
        bh=VZrwNSHDhzmHEYRyOMcrc/O6gd9pB06xwupgGuWpIv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZZwmF9MYXkte4e3LrOi3WkpQhdTOmdoLTV4N1Z8lBudKK+cPcK0TvZlE8npXU21D1
         sfsSevL6ofKDI42iVWhT4YJXnzzAVy+9XhT7pH0JQLFARhfjtpJ1HVY6DO89+mdjua
         n/XEgwMlE//ZfQdblU1jo0GU7pcCvv5OGARPvWJA=
Date:   Mon, 7 Oct 2019 19:03:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007160336.GB5855@unreal>
References: <20191007135933.12483-1-leon@kernel.org>
 <20191007135933.12483-3-leon@kernel.org>
 <c0105196-b0e4-854e-88ff-40f5ba2d4105@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0105196-b0e4-854e-88ff-40f5ba2d4105@acm.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 07, 2019 at 08:07:55AM -0700, Bart Van Assche wrote:
> On 10/7/19 6:59 AM, Leon Romanovsky wrote:
> >   /*
> > - * Check if the device might use memory registration.  This is currently only
> > - * true for iWarp devices. In the future we can hopefully fine tune this based
> > - * on HCA driver input.
> > + * Check if the device might use memory registration. This is currently
> > + * true for iWarp devices and devices that have optimized SGL registration
> > + * logic.
> >    */
>
> The following sentence in the above comment looks confusing to me: "Check if
> the device might use memory registration." That sentence suggests that the
> HCA decides whether or not to use memory registration. Isn't it the RDMA R/W
> code that decides whether or not to use memory registration?

I'm open for any reasonable text, what do you expect to be written there?

>
> > + * For RDMA READs we must use MRs on iWarp and can optionaly use them as an
> > + * optimaztion otherwise.  Additionally we have a debug option to force usage
> > + * of MRs to help testing this code path.
>
> You may want to change "optionaly" into "optionally" and "optimaztion" into
> "optimization".

Thanks

>
> >   static inline bool rdma_rw_io_needs_mr(struct ib_device *dev, u8 port_num,
> >   		enum dma_data_direction dir, int dma_nents)
> >   {
> > -	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
> > -		return true;
> > +	if (dir == DMA_FROM_DEVICE) {
> > +		if (rdma_protocol_iwarp(dev, port_num))
> > +			return true;
> > +		if (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)
> > +			return true;
> > +	}
> >   	if (unlikely(rdma_rw_force_mr))
> >   		return true;
> >   	return false;
>
> Should this function be renamed? The function name suggests if this function
> returns 'true' that using memory registration is mandatory. My understanding
> is if this function returns true for the mlx5 HCA that using memory
> registration improves performance but is not mandatory.

The end result the same, better to work with MR while working with mlx5 for "dma_nents >
dev->attrs.max_sgl_rd",

Thanks

>
> Thanks,
>
> Bart.
