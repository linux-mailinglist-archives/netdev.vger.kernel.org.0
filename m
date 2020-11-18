Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131E62B8511
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKRTq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:46:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgKRTq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:46:57 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F094A246AA;
        Wed, 18 Nov 2020 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605728816;
        bh=r4rtZMhdAiBSx+HYth3NByAdBaTUCKCee8fL0I2kNRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lHosobLoK22MXnVs0MjQ4ibqeRWzsM41/a6EmjFHtqfruDDk9og6FzvPaO2faW0zv
         jQOzL9YbAkVIz/w2o10YIQlrnodjuJmvIEddKJIog1qKb02XCdvby4FWQi8+pJ4hnn
         FJxAwQkeq4Ut9VCw2cr3TAjjTkzgoyf5DvczvGq4=
Date:   Wed, 18 Nov 2020 11:46:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     akpm@linux-foundation.org
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, willy@infradead.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, vbabka@suse.cz
Subject: Re: [PATCH v3 1/1] page_frag: Recover from memory pressure
Message-ID: <20201118114654.3435f76c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201115201029.11903-1-dongli.zhang@oracle.com>
References: <20201115201029.11903-1-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Nov 2020 12:10:29 -0800 Dongli Zhang wrote:
> The ethernet driver may allocate skb (and skb->data) via napi_alloc_skb().
> This ends up to page_frag_alloc() to allocate skb->data from
> page_frag_cache->va.
> 
> During the memory pressure, page_frag_cache->va may be allocated as
> pfmemalloc page. As a result, the skb->pfmemalloc is always true as
> skb->data is from page_frag_cache->va. The skb will be dropped if the
> sock (receiver) does not have SOCK_MEMALLOC. This is expected behaviour
> under memory pressure.
> 
> However, once kernel is not under memory pressure any longer (suppose large
> amount of memory pages are just reclaimed), the page_frag_alloc() may still
> re-use the prior pfmemalloc page_frag_cache->va to allocate skb->data. As a
> result, the skb->pfmemalloc is always true unless page_frag_cache->va is
> re-allocated, even if the kernel is not under memory pressure any longer.
> 
> Here is how kernel runs into issue.
> 
> 1. The kernel is under memory pressure and allocation of
> PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
> the pfmemalloc page is allocated for page_frag_cache->va.
> 
> 2: All skb->data from page_frag_cache->va (pfmemalloc) will have
> skb->pfmemalloc=true. The skb will always be dropped by sock without
> SOCK_MEMALLOC. This is an expected behaviour.
> 
> 3. Suppose a large amount of pages are reclaimed and kernel is not under
> memory pressure any longer. We expect skb->pfmemalloc drop will not happen.
> 
> 4. Unfortunately, page_frag_alloc() does not proactively re-allocate
> page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
> skb->pfmemalloc is always true even kernel is not under memory pressure any
> longer.
> 
> Fix this by freeing and re-allocating the page instead of recycling it.

Andrew, are you taking this via -mm or should I put it in net? 
I'm sending a PR to Linus tomorrow.
