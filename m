Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6DA62B384
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 07:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiKPGx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 01:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiKPGxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 01:53:25 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1505B92;
        Tue, 15 Nov 2022 22:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1TLoj1jBh9mfMsybawiDvBcJ2RcbjxqyJGEX5P65aOg=; b=bU6HegogN9wH+X9y5iGWJdisoO
        k2Ymc/RhPss5DD1PUdAnIYOcGXq08cIdUXnSu7fknT3bN7sh8c3wALssuMTPRne3/L+ZS61ufQZXN
        9Pjuddt0jI5AnGbXPA5PnshgQxRaKH5b7pjnonneOw7g2lmW+ntc/7cpF944/iC6X9uPizKqiwGdK
        yGrPUs2DpOLpw/ssxLxrGHXcx4XRjB+G1SWH2nTjcb7aJl22kQaq1RTHL3H7Tjp2lZ/2/9XEwd+ud
        RJdtZE/gFeJt3xGddeKtNAsknRtiHqN+h32kyqNkDqp1o8h6rtdYkCvgae4U/ArvtBIqJ/eLjJGI0
        8fpeP64A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovCIM-000NU5-7X; Wed, 16 Nov 2022 06:53:14 +0000
Date:   Tue, 15 Nov 2022 22:53:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        iommu@lists.linux.dev
Subject: Re: [PATCH v2 -next] iommu/dma: avoid expensive indirect calls for
 sync operations
Message-ID: <Y3SI2vMf58/WZDwS@infradead.org>
References: <20221115182841.2640176-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115182841.2640176-1-edumazet@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Robing pointed out this really is mostly a dma-mapping layer
patch and the subject should reflect that.

> +		if (!IS_ENABLED(CONFIG_DMA_API_DEBUG) && dev_is_dma_coherent(dev))
> +			dev->skip_dma_sync = true;

I don't think CONFIG_DMA_API_DEBUG should come into play here.  It
is independent from the low-level sync calls.  That'll need a bit
of restructuring later on to only skil the sync calls and not the
debug_dma_* calls, but I think that is worth it to keep the concept
clean.
In fact that might lead to just checking the skip_dma_sync flag in
a wrapper in dma-mapping.h, avoiding the function call entirely
for the fast path, at the downside of increasing code size by
adding an extra branch in the callers, but I think that is ok.

I think we should also apply the skip_dma_sync to dma-direct while
we're it.  While dma-direct already avoids the indirect calls we can
shave off a few more cycles with this infrastructure, so why skip that?

> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -647,6 +647,7 @@ struct device {
>      defined(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL)
>  	bool			dma_coherent:1;
>  #endif
> +	bool			skip_dma_sync:1;

This also needs a blurb in the kerneldoc comment describing struct
device.  Please make it very clear in the comment that the flag is
only for internal use in the DMA mapping subsystem and not for use
by drives.

> +static inline bool dev_skip_dma_sync(struct device *dev)
> +{
> +	return dev->skip_dma_sync;
> +}

I'd drop this wrapper and just check the flag directly.

> +	if (unlikely(dev->skip_dma_sync))
> +		dev->skip_dma_sync = false;

Please add a comment here.


Btw, one thing I had in my mind for a while is to do direct calls to
dma-iommu from the core mapping code just like we for dma-direct.
Would that be useful for your networking loads, or are the actual
mapping calls rare enough to not matter?
