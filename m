Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63828CE14B
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfJGMMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 08:12:47 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727467AbfJGMMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 08:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NqZCL9FFV5jxg5SgSyY7hAFsJqUG9yJ1eIIIYBNoz4I=; b=M5unEYoRvbqLicq7WjdHaoVUi
        8hGurkSClm928w67S9VpITLU8TWdna7SA5MaLMKRABr84waLVuYTUNinFSeVQ6c3hvXrYfd6+3e5k
        qF8cw1Gn1RzIIAnpan12O3lc9uOu6vk7Ym+ogEaXaDCLNYJtifUq9ClJu1HsMorJWJ9/7TbHF3qmf
        LNLWHyVDfWtB4pAvc1/d4IMu6sCVAeiTiGFA/9ezlwk+bYa1kXB7DhaT2H8Pe5sW/Xtp6XDz04eC6
        e7ZuMtoYNRw1cJlhzBaCKhV4t5RAFrPvwVhNXfF9/XQGVIVl5k9DLT+trkoLgBLVBoJWVW6MFlTw1
        D40X8zR9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHRsa-0006vi-GH; Mon, 07 Oct 2019 12:12:44 +0000
Date:   Mon, 7 Oct 2019 05:12:44 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Christoph Hellwig <hch@infradead.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 2/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007121244.GA19843@infradead.org>
References: <20191007115819.9211-1-leon@kernel.org>
 <20191007115819.9211-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007115819.9211-3-leon@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for nitpicking again, but..

On Mon, Oct 07, 2019 at 02:58:18PM +0300, Leon Romanovsky wrote:
> @@ -37,15 +39,15 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
>   * Check if the device will use memory registration for this RW operation.
>   * We currently always use memory registrations for iWarp RDMA READs, and
>   * have a debug option to force usage of MRs.
> - *
> - * XXX: In the future we can hopefully fine tune this based on HCA driver
> - * input.

The above comment needs an updated a la:

 * Check if the device will use memory registration for this RW operation.
 * For RDMA READs we must use MRs on iWarp and can optionaly use them as an
 * optimaztion otherwise.  Additionally we have a debug option to force usage
 * of MRs to help testing this code path.
	

>  	if (rdma_protocol_iwarp(dev, port_num) && dir == DMA_FROM_DEVICE)
>  		return true;
> +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE &&
> +	    dma_nents > dev->attrs.max_sgl_rd)
> +		return true;

This can be simplified to:

	if (dir == DMA_FROM_DEVICE &&
	    (rdma_protocol_iwarp(dev, port_num) ||
	     (dev->attrs.max_sgl_rd && dma_nents > dev->attrs.max_sgl_rd)))
		return true;

