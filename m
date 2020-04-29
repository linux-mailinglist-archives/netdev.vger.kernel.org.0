Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6081BD140
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgD2Aig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbgD2Aig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:38:36 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B09AC03C1AC
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 17:38:35 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id f8so175891lfe.12
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 17:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I/x8An6SXti07R7+/Bt1kXKVbp/TozSLPGc5SfRA9G4=;
        b=MsvnquY+sc2qn97UftFa4ZLSl1tmvl2rSpnwcYZimqt1fJ9ljPT1NLQSHBpVdqUg+k
         dFnavPNnuy5FQ2TRPGYQUCWQ2UF9qTbIUyVg4pOQdjrC8uuYuDVYvUQG+3Ki6KLryV0P
         BgT0uCYzSDkNVEPrqrj8Njx7hXEGvwbuZaFMULAU1a6A0j9qk35t6AzWxRNa8ZWLsbDW
         VIuMe9H8dDAwuvvvXepoU0hypWxNsDn+Nx5XVJvTsMaJn8FE2mvFN15hy1/ovllQFve1
         UeC3ErYEGSaqBKHVspcyptsQJ3T5i+hFq9v7j/lC/+fNiNh3P9cKVM3HDmMX1uXudnV6
         toBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I/x8An6SXti07R7+/Bt1kXKVbp/TozSLPGc5SfRA9G4=;
        b=pNNjcwBDgLhuoa1wAyj0hm1wPRkOhttrRIitSTeY9DhB6ZB+Zzjcbr9KdZ7PSxv7K5
         dHIrq6liDw6gJVGDhNpCJled+uiPoUKqbHeTL4EzMx+thjY5PjQwvGXT7YSqZmK1BjqM
         Vy7Z/ihUtbmKjKimOsXVrFO7S5H5VTIBY4whBQiQR4Dxv7hiWjsttZabUmJgopV8ghMB
         DIgvgfUsLfAi3wBySeHTO+yV/zQ45YucO3ZAziCw0B2AAgrJeAI02JDVIniLtbZzDQqb
         iugUDAkYMxIn7qbI6m0JSOmTxDSYftSymBr8WkD7GM4rul6RitM4mOo7Hb5cTnYOMz2b
         ew/A==
X-Gm-Message-State: AGi0Puahxj3cvFk3MC2zzIewZCd0ivqv1XQVzvLnWewE9SFDSDMvKg3U
        rR6NAwIStyd7bYhXAfvICXYB3g==
X-Google-Smtp-Source: APiQypLMyc9iXIT2gOmeK2EqbCOl+Idkd9uEjvQ42TnYWs5shRvqnUQruptet0p/7dvmK2mQzPSLqg==
X-Received: by 2002:a05:6512:46d:: with SMTP id x13mr830338lfd.56.1588120714064;
        Tue, 28 Apr 2020 17:38:34 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id o23sm770668ljh.63.2020.04.28.17.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 17:38:33 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id D887C10235A; Wed, 29 Apr 2020 03:38:43 +0300 (+03)
Date:   Wed, 29 Apr 2020 03:38:43 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        willy@infradead.org, Saeed Mahameed <saeedm@mellanox.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        mgorman@techsingularity.net,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next PATCH V3 1/3] mm: add dma_addr_t to struct page
Message-ID: <20200429003843.rh2pasek7v5o3h63@box>
References: <155002290134.5597.6544755780651689517.stgit@firesoul>
 <155002294008.5597.13759027075590385810.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155002294008.5597.13759027075590385810.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 13, 2019 at 02:55:40AM +0100, Jesper Dangaard Brouer wrote:
> The page_pool API is using page->private to store DMA addresses.
> As pointed out by David Miller we can't use that on 32-bit architectures
> with 64-bit DMA
> 
> This patch adds a new dma_addr_t struct to allow storing DMA addresses
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Acked-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/mm_types.h |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 2c471a2c43fa..0a36a22228e7 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -95,6 +95,13 @@ struct page {
>  			 */
>  			unsigned long private;
>  		};
> +		struct {	/* page_pool used by netstack */
> +			/**
> +			 * @dma_addr: might require a 64-bit value even on
> +			 * 32-bit architectures.
> +			 */
> +			dma_addr_t dma_addr;
> +		};

[ I'm slow, but I've just noticed this change into struct page. ]

Is there a change that the dma_addr would have bit 0 set? If yes it may
lead to false-positive PageTail() and really strange behaviour.

I think it's better to put some padding into the struct to avoid aliasing
to compound_head.

See commit 1d798ca3f164 ("mm: make compound_head() robust") for context.

>  		struct {	/* slab, slob and slub */
>  			union {
>  				struct list_head slab_list;	/* uses lru */
> 

-- 
 Kirill A. Shutemov
