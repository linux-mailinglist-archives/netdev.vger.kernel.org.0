Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4FDCDBFE
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 08:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfJGG61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 02:58:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56574 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbfJGG60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 02:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zyEBeeYkj60O+Zh+MCV3QOZVp4TyJxeBjJ9brdBuww8=; b=X53Vm5Qa96dGI0P1E39GHGEvF
        8nXVVwUYCyuHehtCiHtmI30OWqPUtArrpyKAjod276QovVhtKSp3bwNMG/c6aIzixewkBM3Z4ulMx
        kDiqZBCcpy/06DKF8XZIiGyw1slOZ5+/uR7wGsSliiY8kj+xkkGVL5841fF2XIBjC6jSLkAiLHXne
        vUV+vVipQ5EoCYH2I8uW7kAMenq8GQPGewkrB/VuRT/kZLBJf+5jgZ7Ic5M7rt7CEFyaTaFVNq9dg
        n3LHq9mld2FrhAarSBNeFMPKefCi4koLL/I60KX4bP1BUn73l9GgzVZ2x1RahK4iWFMVNY6VQUjlW
        j9wzTDUpg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHMyP-0005rj-2p; Mon, 07 Oct 2019 06:58:25 +0000
Date:   Sun, 6 Oct 2019 23:58:25 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 3/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007065825.GA17401@infradead.org>
References: <20191006155955.31445-1-leon@kernel.org>
 <20191006155955.31445-4-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006155955.31445-4-leon@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /*
> - * Check if the device might use memory registration.  This is currently only
> - * true for iWarp devices. In the future we can hopefully fine tune this based
> - * on HCA driver input.
> + * Check if the device might use memory registration.
>   */

Please keep the important bits of this comments instead of just
removing them.

>  {
> @@ -30,6 +28,8 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
>  		return true;
>  	if (unlikely(rdma_rw_force_mr))
>  		return true;
> +	if (dev->attrs.max_sgl_rd)
> +		return true;

Logically this should go before the rdma_rw_force_mr check.

>  	if (unlikely(rdma_rw_force_mr))
>  		return true;
> +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE
> +	    && dma_nents > dev->attrs.max_sgl_rd)

Wrong indendation.  The && belongs on the first line.  And again, this
logically belongs before the rdma_rw_force_mr check.
