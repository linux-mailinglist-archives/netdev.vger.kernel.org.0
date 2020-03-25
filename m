Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB56192BB0
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727612AbgCYPCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:02:24 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:39364 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727402AbgCYPCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585148543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ftwhfLW9CceJEU5KFU6f433wIMZK18g3iVfsQmQn64A=;
        b=Juaw7BREV0QsPG/waiv/uYNozrabnKccRDWLHSqhWby7g8kxBxL7fpeXBiUGK0WVjVVL/H
        IBp4DEihApsZfl632WAzSeRUgQjNb/pua/zITiKX2RJhoPwJkYsNLRWiD8W4VF1EBj4nCI
        EE6AbAWpH5cvFRhn40paWV/fx+n0WoI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-0ZgnwLN9PyOxPMRukOFCVw-1; Wed, 25 Mar 2020 11:02:19 -0400
X-MC-Unique: 0ZgnwLN9PyOxPMRukOFCVw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31EB0189F762;
        Wed, 25 Mar 2020 15:02:18 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 563D7BBBC2;
        Wed, 25 Mar 2020 15:02:13 +0000 (UTC)
Date:   Wed, 25 Mar 2020 16:02:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] net: page pool: allow to pass zero flags to
 page_pool_init()
Message-ID: <20200325160211.1b887ca5@carbon>
In-Reply-To: <1585145575-14477-1-git-send-email-kda@linux-powerpc.org>
References: <1585145575-14477-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 17:12:55 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> page pool API can be useful for non-DMA cases like
> xen-netfront driver so let's allow to pass zero flags to
> page pool flags.
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  net/core/page_pool.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)

The pool->p.dma_dir is only used when flag PP_FLAG_DMA_MAP is used, so
it looks more simple to do:

$ git diff
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 626db912fce4..ef98372facf6 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -43,9 +43,11 @@ static int page_pool_init(struct page_pool *pool,
         * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
         * which is the XDP_TX use-case.
         */
-       if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
-           (pool->p.dma_dir != DMA_BIDIRECTIONAL))
-               return -EINVAL;
+       if (pool->p.flags & PP_FLAG_DMA_MAP) {
+               if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
+                   (pool->p.dma_dir != DMA_BIDIRECTIONAL))
+                       return -EINVAL;
+       }
 


> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 10d2b25..eeeb0d9 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -39,27 +39,29 @@ static int page_pool_init(struct page_pool *pool,
>  	if (ring_qsize > 32768)
>  		return -E2BIG;
>  
> -	/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
> -	 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
> -	 * which is the XDP_TX use-case.
> -	 */
> -	if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
> -	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
> -		return -EINVAL;
> -
> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
> -		/* In order to request DMA-sync-for-device the page
> -		 * needs to be mapped
> +	if (pool->p.flags) {
> +		/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
> +		 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
> +		 * which is the XDP_TX use-case.
>  		 */
> -		if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> +		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
> +		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>  			return -EINVAL;
>  
> -		if (!pool->p.max_len)
> -			return -EINVAL;
> +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
> +			/* In order to request DMA-sync-for-device the page
> +			 * needs to be mapped
> +			 */
> +			if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> +				return -EINVAL;
>  
> -		/* pool->p.offset has to be set according to the address
> -		 * offset used by the DMA engine to start copying rx data
> -		 */
> +			if (!pool->p.max_len)
> +				return -EINVAL;
> +
> +			/* pool->p.offset has to be set according to the address
> +			 * offset used by the DMA engine to start copying rx data
> +			 */
> +		}
>  	}
>  
>  	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

