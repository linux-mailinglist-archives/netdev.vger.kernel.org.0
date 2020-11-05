Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388132A7F91
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 14:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730616AbgKENVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 08:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730445AbgKENVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 08:21:30 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C19C0613CF;
        Thu,  5 Nov 2020 05:21:30 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id n18so1739564wrs.5;
        Thu, 05 Nov 2020 05:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=a85H8wm4BS7+KUS0Jz6qx8lLSyd4auBcG9TW/HwKEug=;
        b=aeF/jsaUOlIaNhiby87PypQOR8fPBdYt6vbGRdvx+s8k5v2cJZ9rQ+jE7jKmLjNdAA
         ioTCfboogO1GvNTEsH01Bnj0Oisz1hQGdagdX8QnfXWzQxHao1kJBIpIP0Nax7+SX/qo
         K3pVhT371L3dq66UUcgDHq8VvDIY7xd6U4M+QywgVb7JaSiEy/j9FAnFiIwpUO9E/DOG
         mWDQPTPNcGsozaFvvcxIuGfBLQJDaGlc1SfKrEl3e95lKOSPDohId1ANJ1YAfoG4NPsE
         sAeEte5Atrh0hGCrNYAbLkL8vClMhsJ0JsUjwSc184r4AMwxV/B6y1Uc+U8mUQGIEp85
         EEGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a85H8wm4BS7+KUS0Jz6qx8lLSyd4auBcG9TW/HwKEug=;
        b=YjrGHNlau9Tq5MjNR9wjXImjL0vMabyZXdx5s9ZNFV/yghNX7i5idKb0AqjzEM8/Qr
         zp13Niu8LWzFnsuganJa1AXzJ5pf0MJap5Ixks6GRNPriZmfKgpCgg3BbqQizoqe+49N
         cAn6TnQBdbHav5lgIC7A0N5RLc7qyU1b7FIgFktDHnQvu/b00P85zkk1X3BF5skUIDwn
         2GfX35PkQnZ3LLTscIkvYP6Cf003MP/MsNkaNNfR4KhcTd/zl9g60B2Qzi52UnfafCmr
         Y7xtzRy8YKI/I1Tb7Zo2ARgbI0yzcBzbheBG8pDRJ4mwGTZ0WXPRMW4LkGEs/RCQb0Se
         Gnng==
X-Gm-Message-State: AOAM532+VPn93XSlaZfoJXGbvqjBOvOa7wcCTBkunoT3T3QeB+UazQuF
        u4DRRDFQyLxiZjJZFZAr/RcaUsiCdqk=
X-Google-Smtp-Source: ABdhPJzcPPmmQDOsAh46XusNjbHTKhW2hIOclIddxmjAM48WnAbH+DI7CPvSr06zoOWPP54SqXkXzA==
X-Received: by 2002:a5d:5387:: with SMTP id d7mr2899491wrv.224.1604582488598;
        Thu, 05 Nov 2020 05:21:28 -0800 (PST)
Received: from [192.168.8.114] ([37.172.191.42])
        by smtp.gmail.com with ESMTPSA id 89sm2699678wrp.58.2020.11.05.05.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 05:21:27 -0800 (PST)
Subject: Re: [PATCH] page_frag: Recover from memory pressure
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org
References: <20201105042140.5253-1-willy@infradead.org>
From:   Eric Dumazet <erdnetdev@gmail.com>
Message-ID: <d673308e-c9a6-85a7-6c22-0377dd33c019@gmail.com>
Date:   Thu, 5 Nov 2020 14:21:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201105042140.5253-1-willy@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/20 5:21 AM, Matthew Wilcox (Oracle) wrote:
> When the machine is under extreme memory pressure, the page_frag allocator
> signals this to the networking stack by marking allocations with the
> 'pfmemalloc' flag, which causes non-essential packets to be dropped.
> Unfortunately, even after the machine recovers from the low memory
> condition, the page continues to be used by the page_frag allocator,
> so all allocations from this page will continue to be dropped.
> 
> Fix this by freeing and re-allocating the page instead of recycling it.
> 
> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> Cc: Bert Barbe <bert.barbe@oracle.com>
> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Cc: SRINIVAS <srinivas.eeda@oracle.com>
> Cc: stable@vger.kernel.org
> Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")

Your patch looks fine, although this Fixes: tag seems incorrect.

79930f5892e ("net: do not deplete pfmemalloc reserve") was propagating
the page pfmemalloc status into the skb, and seems correct to me.

The bug was the page_frag_alloc() was keeping a problematic page for
an arbitrary period of time ?

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/page_alloc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 778e815130a6..631546ae1c53 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
>  
>  		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>  			goto refill;
> +		if (nc->pfmemalloc) {

                if (unlikely(nc->pfmemalloc)) {

> +			free_the_page(page, compound_order(page));
> +			goto refill;
> +		}
>  
>  #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
>  		/* if size can vary use size else just use PAGE_SIZE */
> 
