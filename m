Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1116669A81F
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjBQJaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBQJaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:30:09 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A68EC38E98;
        Fri, 17 Feb 2023 01:30:07 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 581931FDC1;
        Fri, 17 Feb 2023 09:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1676626206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scYh//7n4UiKTBLeV1t9pIL7YuyPxKt/8nZ35rpMs4Y=;
        b=S4Klg0HI5jyVWLSwmzrGFSSFPi00vtRFxNV59BfMJecder+ozW8oI28WuXg/HxU18Xv4LE
        S4xbiMINcymc5r43IksMMzlhmd2dVDjBGGiXvFwmH6p3np4AVz4fYi8BGFk31eE9kDFhl3
        H1a8GQ++wTBJjKFdQWDjcCo3OoOwnlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1676626206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=scYh//7n4UiKTBLeV1t9pIL7YuyPxKt/8nZ35rpMs4Y=;
        b=nYpr4daAyNGwQbRH+NZBJuYebacl7yicFA7SsIs8ueMglsuj6cNMgviwylTQMmRTXI2864
        Co6zAFkxwY2hS8Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4031D138E3;
        Fri, 17 Feb 2023 09:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zFQGDx5J72M1FgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 17 Feb 2023 09:30:06 +0000
Message-ID: <d68edefb-4930-a9cf-1150-9bd2a2a9a02f@suse.cz>
Date:   Fri, 17 Feb 2023 10:30:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [net PATCH 1/2] mm: Use fixed constant in page_frag_alloc instead
 of size + 1
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org, jannh@google.com
References: <20190215223741.16881.84864.stgit@localhost.localdomain>
 <20190215224412.16881.89296.stgit@localhost.localdomain>
Content-Language: en-US
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20190215224412.16881.89296.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/19 23:44, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> This patch replaces the size + 1 value introduced with the recent fix for 1
> byte allocs with a constant value.
> 
> The idea here is to reduce code overhead as the previous logic would have
> to read size into a register, then increment it, and write it back to
> whatever field was being used. By using a constant we can avoid those
> memory reads and arithmetic operations in favor of just encoding the
> maximum value into the operation itself.
> 
> Fixes: 2c2ade81741c ("mm: page_alloc: fix ref bias in page_frag_alloc() for 1-byte allocs")
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  mm/page_alloc.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ebb35e4d0d90..37ed14ad0b59 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4857,11 +4857,11 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  		/* Even if we own the page, we do not use atomic_set().
>  		 * This would break get_page_unless_zero() users.
>  		 */
> -		page_ref_add(page, size);
> +		page_ref_add(page, PAGE_FRAG_CACHE_MAX_SIZE);

But this value can be theoretically too low when PAGE_SIZE >
PAGE_FRAG_CACHE_MAX_SIZE? Such as on architectures with 64kB page size,
while PAGE_FRAG_CACHE_MAX_SIZE is 32kB?

Maybe impossible to exploit in practice thanks to the minimum alignment, but
still IMHO we should be using the larger of PAGE_FRAG_CACHE_MAX_SIZE and
PAGE_SIZE, which should still be a build-time constant, so not defeat the
optimization.

>  
>  		/* reset page count bias and offset to start of new frag */
>  		nc->pfmemalloc = page_is_pfmemalloc(page);
> -		nc->pagecnt_bias = size + 1;
> +		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
>  		nc->offset = size;
>  	}
>  
> @@ -4877,10 +4877,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  		size = nc->size;
>  #endif
>  		/* OK, page count is 0, we can safely set it */
> -		set_page_count(page, size + 1);
> +		set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
>  
>  		/* reset page count bias and offset to start of new frag */
> -		nc->pagecnt_bias = size + 1;
> +		nc->pagecnt_bias = PAGE_FRAG_CACHE_MAX_SIZE + 1;
>  		offset = size - fragsz;
>  	}
>  
> 

