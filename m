Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9828E2591A0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbgIAOxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:53:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42334 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728454AbgIAOwp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:52:45 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 2FA1E8EE112;
        Tue,  1 Sep 2020 07:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598971964;
        bh=5QgiJp1XQuU8WeasWKUrByXxrzK/9M/xvKJovjxtOSE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wObSEMiIFiMQqpuLxaCfGj6fWwMB1SR5uR3WpqveV9O4eMPwCERYxZe+pGeu45B1s
         Hh0lHOhPmaDzTL+z1MwoTQwce39LAcI0HTI6j6IhhJYI3h5nKO0TMp801H3LPYpAS2
         cAlNurtUenHcZUudnTaoIqyV7yZakslR9e7UqKeA=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0Zy3Ukh5UkrA; Tue,  1 Sep 2020 07:52:44 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C9BD38EE0F5;
        Tue,  1 Sep 2020 07:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598971963;
        bh=5QgiJp1XQuU8WeasWKUrByXxrzK/9M/xvKJovjxtOSE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aKMifmu3auQ6FWaycnVm58I6hz9G+D25US7ZBIQmKPWtl/OO3oAlisEasTKoEqxvs
         l6ihGgc23PPx6Vjc2Wtc/36E47y53pW7IPIx5bd2ov50jG73PyojCzhwq4i11ZzTyB
         Dg3UC/gKa12A9sw0Wl45QN34rTiyU/vUbrJxeAio=
Message-ID: <1598971960.4238.5.camel@HansenPartnership.com>
Subject: Re: [PATCH 07/28] 53c700: improve non-coherent DMA handling
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Date:   Tue, 01 Sep 2020 07:52:40 -0700
In-Reply-To: <20200819065555.1802761-8-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
         <20200819065555.1802761-8-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-19 at 08:55 +0200, Christoph Hellwig wrote:
> Switch the 53c700 driver to only use non-coherent descriptor memory
> if it really has to because dma_alloc_coherent fails.  This doesn't
> matter for any of the platforms it runs on currently, but that will
> change soon.
> 
> To help with this two new helpers to transfer ownership to and from
> the device are added that abstract the syncing of the non-coherent
> memory. The two current bidirectional cases are mapped to transfers
> to the device, as that appears to what they are used for.  Note that
> for parisc, which is the only architecture this driver needs to use
> non-coherent memory on, the direction argument of dma_cache_sync is
> ignored, so this will not change behavior in any way.

I think this looks mostly OK, except for one misnamed parameter below. 
Unfortunately, the last non-coherent parisc was the 700 series and I no
longer own a box, so I can't test that part of it (I can fire up the
C360 to test it on a coherent arch).

[...]
> diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
> index 05fe439b66afe5..0f545b05fe611d 100644
> --- a/drivers/scsi/53c700.h
> +++ b/drivers/scsi/53c700.h
> @@ -209,6 +209,7 @@ struct NCR_700_Host_Parameters {
>  #endif
>  	__u32	chip710:1;	/* set if really a 710 not
> 700 */
>  	__u32	burst_length:4;	/* set to 0 to disable
> 710 bursting */
> +	__u32	noncoherent:1;	/* needs to use non-
> coherent DMA */
>  
>  	/* NOTHING BELOW HERE NEEDS ALTERING */
>  	__u32	fast:1;		/* if we can alter the
> SCSI bus clock
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

These macro arguments need updating.  Since you changed the input from
hostdata->dev to hostdata, leaving the macro argument as dev is simply
misleading.  It needs to become hostdata or h.

James

