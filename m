Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 454ECCDC9F
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfJGHym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:33736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbfJGHym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 03:54:42 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A05A2133F;
        Mon,  7 Oct 2019 07:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570434882;
        bh=vcGFifv/FN2I5j8yx1asPPdxtr49ZmxuZ4+VHZfojsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZpMf+B7eM4Xn0JRvD/C8P6GXqSdldQVDvribvai5UypGBnebqaVtofcxcORtEB+JS
         TgNraA5CU/Wo1y2X+MfiGecVBF8KlSIVpgWw4GgtP3vPe/kIGtF5KpD6K70q88e2Mw
         1IBLi4ZUCpG7/owlmYvOSH6hwwBlMqzLm2Phfk+o=
Date:   Mon, 7 Oct 2019 10:54:37 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 3/3] RDMA/rw: Support threshold for
 registration vs scattering to local pages
Message-ID: <20191007075437.GV5855@unreal>
References: <20191006155955.31445-1-leon@kernel.org>
 <20191006155955.31445-4-leon@kernel.org>
 <20191007065825.GA17401@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007065825.GA17401@infradead.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 06, 2019 at 11:58:25PM -0700, Christoph Hellwig wrote:
> >  /*
> > - * Check if the device might use memory registration.  This is currently only
> > - * true for iWarp devices. In the future we can hopefully fine tune this based
> > - * on HCA driver input.
> > + * Check if the device might use memory registration.
> >   */
>
> Please keep the important bits of this comments instead of just
> removing them.
>
> >  {
> > @@ -30,6 +28,8 @@ static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)
> >  		return true;
> >  	if (unlikely(rdma_rw_force_mr))
> >  		return true;
> > +	if (dev->attrs.max_sgl_rd)
> > +		return true;
>
> Logically this should go before the rdma_rw_force_mr check.
>
> >  	if (unlikely(rdma_rw_force_mr))
> >  		return true;
> > +	if (dev->attrs.max_sgl_rd && dir == DMA_FROM_DEVICE
> > +	    && dma_nents > dev->attrs.max_sgl_rd)
>
> Wrong indendation.  The && belongs on the first line.  And again, this
> logically belongs before the rdma_rw_force_mr check.

I'll fix.

Thanks
