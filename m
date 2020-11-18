Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06182B8856
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgKRXXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:23:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgKRXXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 18:23:49 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D99D221FE;
        Wed, 18 Nov 2020 23:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605741828;
        bh=xKZACUxyV23LrsDvEaCr6ps7gloZQxSkyTsA5BorCtw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CJB+DNkG/PSKh2h7xzlh2JPaZcjPQ3l5+B7dGhFsGA+6XgmKAdBFt9Kc2o3SBhhi2
         215LJepGQZyeu1Bhb1n2PSRb5fyVAwzDUjQEzdlDR9pN/dUQblFNjk+cqP/uFRXaOP
         FatgJ4J1zUi6bU5mlUmoxZd0BmmysU15OmzzncK0=
Date:   Wed, 18 Nov 2020 15:23:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>, linux-mm@kvack.org,
        netdev@vger.kernel.org, willy@infradead.org,
        aruna.ramakrishna@oracle.com, bert.barbe@oracle.com,
        rama.nichanamatlu@oracle.com, venkat.x.venkatsubra@oracle.com,
        manjunath.b.patil@oracle.com, joe.jin@oracle.com,
        srinivas.eeda@oracle.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, vbabka@suse.cz
Subject: Re: [PATCH v3 1/1] page_frag: Recover from memory pressure
Message-ID: <20201118152346.5a4fe12d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118131335.738bdade4f3dfcee190ea8c1@linux-foundation.org>
References: <20201115201029.11903-1-dongli.zhang@oracle.com>
        <20201118114654.3435f76c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201118131335.738bdade4f3dfcee190ea8c1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 13:13:35 -0800 Andrew Morton wrote:
> On Wed, 18 Nov 2020 11:46:54 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> 
> > > 1. The kernel is under memory pressure and allocation of
> > > PAGE_FRAG_CACHE_MAX_ORDER in __page_frag_cache_refill() will fail. Instead,
> > > the pfmemalloc page is allocated for page_frag_cache->va.
> > > 
> > > 2: All skb->data from page_frag_cache->va (pfmemalloc) will have
> > > skb->pfmemalloc=true. The skb will always be dropped by sock without
> > > SOCK_MEMALLOC. This is an expected behaviour.
> > > 
> > > 3. Suppose a large amount of pages are reclaimed and kernel is not under
> > > memory pressure any longer. We expect skb->pfmemalloc drop will not happen.
> > > 
> > > 4. Unfortunately, page_frag_alloc() does not proactively re-allocate
> > > page_frag_alloc->va and will always re-use the prior pfmemalloc page. The
> > > skb->pfmemalloc is always true even kernel is not under memory pressure any
> > > longer.
> > > 
> > > Fix this by freeing and re-allocating the page instead of recycling it.  
> > 
> > Andrew, are you taking this via -mm or should I put it in net? 
> > I'm sending a PR to Linus tomorrow.  
> 
> Please go ahead - if/when it appears in mainline or linux-next, I'll
> drop the -mm copy.  

Okay, applied, thank you!
