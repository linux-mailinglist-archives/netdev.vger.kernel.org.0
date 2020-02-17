Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0473160BCA
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 08:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgBQHly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 02:41:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30099 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726811AbgBQHly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 02:41:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581925313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hqMNovNPLBTkcDZOPcJd85GoyTDK28xkZ5YRxHDZcBM=;
        b=ehZecdFbhkDmpuogn/fGY4Hn7cl2Mq+ft82DOojzr8RiU2EyV3LVGsa31VVQ2w/OnqcI7f
        ei9tOexGAoMJnjy5S8EXAokTScG1mr7MtqWPPmPYwdnatQCbHb+J3673J7H+kZE6FhXu8K
        LCLgl7kyKdVTrcKKjBRCOv7QIhBgjp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-tvWotQ_rP52F4XbMwzS7ew-1; Mon, 17 Feb 2020 02:41:50 -0500
X-MC-Unique: tvWotQ_rP52F4XbMwzS7ew-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94405800D53;
        Mon, 17 Feb 2020 07:41:47 +0000 (UTC)
Received: from carbon (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 299292CC39;
        Mon, 17 Feb 2020 07:41:35 +0000 (UTC)
Date:   Mon, 17 Feb 2020 08:41:33 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, lorenzo@kernel.org, toke@redhat.com,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: page_pool: API cleanup and comments
Message-ID: <20200217084133.1a67ae63@carbon>
In-Reply-To: <20200217062850.133121-1-ilias.apalodimas@linaro.org>
References: <20200217062850.133121-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Feb 2020 08:28:49 +0200
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index cfbed00ba7ee..7c1f23930035 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -162,39 +162,33 @@ static inline void page_pool_use_xdp_mem(struct page_pool *pool,
>  }
>  #endif
>  
> -/* Never call this directly, use helpers below */
> -void __page_pool_put_page(struct page_pool *pool, struct page *page,
> -			  unsigned int dma_sync_size, bool allow_direct);
> +void page_pool_release_page(struct page_pool *pool, struct page *page);
>  
> -static inline void page_pool_put_page(struct page_pool *pool,
> -				      struct page *page, bool allow_direct)
> +/* If the page refcnt == 1, this will try to recycle the page.
> + * if PP_FLAG_DMA_SYNC_DEV is set, it will try to sync the DMA area for
> + * the configured size min(dma_sync_size, pool->max_len).
> + * If the page refcnt != page will be returned

Is this last comment line fully formed?


> + */
> +void page_pool_put_page(struct page_pool *pool, struct page *page,
> +			unsigned int dma_sync_size, bool allow_direct);
> +
> +/* Same as above but will try to sync the entire area pool->max_len */
> +static inline void page_pool_put_full_page(struct page_pool *pool,
> +					   struct page *page, bool allow_direct)



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

