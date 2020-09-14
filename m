Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3350A268F92
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgINPUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:20:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48832 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgINPU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:20:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D94B18EE188;
        Mon, 14 Sep 2020 08:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1600096820;
        bh=GKXYjllCOYoz9s1DCxjF5LhZlRPIv8wDG6prJomb0DU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MwCEKT1C51gNQI4k2c/TW5TFLSyvCL+DaM8jG72BtMupIn9VJeN1dkJcyAJV4JkG0
         n6sSw+D1WaOUFen3nc5d+f9REcdFZ8Klept06jhzp/Us0zXjri6r0Pype5gmTqA+88
         YuaiMKfDE+athYdKXtMltIVOrUi9whs+u8kR+5FU=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d819rpRvd1Od; Mon, 14 Sep 2020 08:20:20 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 4E7098EE111;
        Mon, 14 Sep 2020 08:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1600096820;
        bh=GKXYjllCOYoz9s1DCxjF5LhZlRPIv8wDG6prJomb0DU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MwCEKT1C51gNQI4k2c/TW5TFLSyvCL+DaM8jG72BtMupIn9VJeN1dkJcyAJV4JkG0
         n6sSw+D1WaOUFen3nc5d+f9REcdFZ8Klept06jhzp/Us0zXjri6r0Pype5gmTqA+88
         YuaiMKfDE+athYdKXtMltIVOrUi9whs+u8kR+5FU=
Message-ID: <1600096818.4061.7.camel@HansenPartnership.com>
Subject: Re: [PATCH 07/17] 53c700: improve non-coherent DMA handling
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Date:   Mon, 14 Sep 2020 08:20:18 -0700
In-Reply-To: <20200914144433.1622958-8-hch@lst.de>
References: <20200914144433.1622958-1-hch@lst.de>
         <20200914144433.1622958-8-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-14 at 16:44 +0200, Christoph Hellwig wrote:
> @@ -429,7 +430,7 @@ struct NCR_700_Host_Parameters {
>  	for(i=0; i< (sizeof(A_##symbol##_used) / sizeof(__u32));
> i++) { \
>  		__u32 val =
> bS_to_cpu((script)[A_##symbol##_used[i]]) + da; \
>  		(script)[A_##symbol##_used[i]] = bS_to_host(val); \
> -		dma_cache_sync((dev),
> &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
> +		dma_sync_to_dev((dev),
> &(script)[A_##symbol##_used[i]], 4); \
>  		DEBUG((" script, patching %s at %d to %pad\n", \
>  		       #symbol, A_##symbol##_used[i], &da)); \
>  	} \
> @@ -441,7 +442,7 @@ struct NCR_700_Host_Parameters {
>  	dma_addr_t da = value; \
>  	for(i=0; i< (sizeof(A_##symbol##_used) / sizeof(__u32));
> i++) { \
>  		(script)[A_##symbol##_used[i]] = bS_to_host(da); \
> -		dma_cache_sync((dev),
> &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
> +		dma_sync_to_dev((dev),
> &(script)[A_##symbol##_used[i]], 4); \
>  		DEBUG((" script, patching %s at %d to %pad\n", \
>  		       #symbol, A_##symbol##_used[i], &da)); \
>  	} \
> @@ -456,7 +457,7 @@ struct NCR_700_Host_Parameters {
>  		val &= 0xff00ffff; \
>  		val |= ((value) & 0xff) << 16; \
>  		(script)[A_##symbol##_used[i]] = bS_to_host(val); \
> -		dma_cache_sync((dev),
> &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
> +		dma_sync_to_dev((dev),
> &(script)[A_##symbol##_used[i]], 4); \
>  		DEBUG((" script, patching ID field %s at %d to
> 0x%x\n", \
>  		       #symbol, A_##symbol##_used[i], val)); \
>  	} \
> @@ -470,7 +471,7 @@ struct NCR_700_Host_Parameters {
>  		val &= 0xffff0000; \
>  		val |= ((value) & 0xffff); \
>  		(script)[A_##symbol##_used[i]] = bS_to_host(val); \
> -		dma_cache_sync((dev),
> &(script)[A_##symbol##_used[i]], 4, DMA_TO_DEVICE); \
> +		dma_sync_to_dev((dev),
> &(script)[A_##symbol##_used[i]], 4); \
>  		DEBUG((" script, patching short field %s at %d to
> 0x%x\n", \
>  		       #symbol, A_##symbol##_used[i], val)); \
>  	} \

If you're going to change the macros from taking a device to taking a
hostdata structure then the descriptive argument name needs to change
... it can't be dev anymore.  I'm happy with it simply becoming 'h' if
hostdata is too long.

I already asked for this on the first go around:

https://lore.kernel.org/alsa-devel/1598971960.4238.5.camel@HansenPartnership.com/

James

