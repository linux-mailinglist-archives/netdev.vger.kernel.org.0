Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A032B8663
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgKRVNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:13:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgKRVNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 16:13:37 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E33EA207D3;
        Wed, 18 Nov 2020 21:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1605734016;
        bh=+8//0K5UnMNFTVC4OTQS6tajK8TIdT39V94cceNEt5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DxQLDkJc7dR/Owjkxqg6kuft3IOF4f8GMCFk42XTrdXQn+utjhQHzyLVGCYFXgxKw
         yM1anhZN0FFirIqmnTXx7WuJZhmVUlBq53WYkjinDycCJIbBRT9/6qbnZEXr8AoXrU
         t4+32GFD2aalCBjNdWef+wGF/2qnkBG9m3Ewr96I=
Date:   Wed, 18 Nov 2020 13:13:35 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, willy@infradead.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, vbabka@suse.cz
Subject: Re: [PATCH v3 1/1] page_frag: Recover from memory pressure
Message-Id: <20201118131335.738bdade4f3dfcee190ea8c1@linux-foundation.org>
In-Reply-To: <20201118114654.3435f76c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201115201029.11903-1-dongli.zhang@oracle.com>
        <20201118114654.3435f76c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 11:46:54 -0800 Jakub Kicinski <kuba@kernel.org> wrote:

> > 1. The kernel is under memory pressure and allocation of
> > PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
> > the pfmemalloc page is allocated for page_frag_cache->va.
> > 
> > 2: All skb->data from page_frag_cache->va (pfmemalloc) will have
> > skb->pfmemalloc=true. The skb will always be dropped by sock without
> > SOCK_MEMALLOC. This is an expected behaviour.
> > 
> > 3. Suppose a large amount of pages are reclaimed and kernel is not under
> > memory pressure any longer. We expect skb->pfmemalloc drop will not happen.
> > 
> > 4. Unfortunately, page_frag_alloc() does not proactively re-allocate
> > page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
> > skb->pfmemalloc is always true even kernel is not under memory pressure any
> > longer.
> > 
> > Fix this by freeing and re-allocating the page instead of recycling it.
> 
> Andrew, are you taking this via -mm or should I put it in net? 
> I'm sending a PR to Linus tomorrow.

Please go ahead - if/when it appears in mainline or linux-next, I'll
drop the -mm copy.  
