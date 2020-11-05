Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 381812A804D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731011AbgKEOC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730871AbgKEOC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:02:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA812C0613CF;
        Thu,  5 Nov 2020 06:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cD+eBYuUgW3bthVlBrXo+FI4A/dPV76Q94+GqMIroAA=; b=KeEMdK6FSs5d8bD8m7s0IrwI1S
        BnlylR6ITz29Uf5Ptcqq+iIjjeqZV8yePLzr6gmRSRJIVF4G+zLMA7VhEwXeyQmEc71RUQ9HBXLle
        hDH9Tok/1Re9tI9E/AlP127uY7UbbAMqO2b+cFW30SFAbkRXA96Z5ADy5faCwZRLaHr5C65KoFjKJ
        uKPLxs423qYunSWDIUnlITZQDIWNsvsl5MC9FvsykLF+CulJZuBAvfaszw8roRjzIdK3PILvwj/kc
        GB+sEbokt6ofDsyrELe8nY5hTseOlaWkiUO67+NGaqlhBbbKthBSk+chzwco9TW5n7WV0NYnFRq+i
        iol8H7xw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kafqL-0003KJ-1f; Thu, 05 Nov 2020 14:02:25 +0000
Date:   Thu, 5 Nov 2020 14:02:24 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Dumazet <erdnetdev@gmail.com>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] page_frag: Recover from memory pressure
Message-ID: <20201105140224.GK17076@casper.infradead.org>
References: <20201105042140.5253-1-willy@infradead.org>
 <d673308e-c9a6-85a7-6c22-0377dd33c019@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d673308e-c9a6-85a7-6c22-0377dd33c019@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 02:21:25PM +0100, Eric Dumazet wrote:
> On 11/5/20 5:21 AM, Matthew Wilcox (Oracle) wrote:
> > When the machine is under extreme memory pressure, the page_frag allocator
> > signals this to the networking stack by marking allocations with the
> > 'pfmemalloc' flag, which causes non-essential packets to be dropped.
> > Unfortunately, even after the machine recovers from the low memory
> > condition, the page continues to be used by the page_frag allocator,
> > so all allocations from this page will continue to be dropped.
> > 
> > Fix this by freeing and re-allocating the page instead of recycling it.
> > 
> > Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
> > Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
> > Cc: Bert Barbe <bert.barbe@oracle.com>
> > Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
> > Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
> > Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
> > Cc: Joe Jin <joe.jin@oracle.com>
> > Cc: SRINIVAS <srinivas.eeda@oracle.com>
> > Cc: stable@vger.kernel.org
> > Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
> 
> Your patch looks fine, although this Fixes: tag seems incorrect.
> 
> 79930f5892e ("net: do not deplete pfmemalloc reserve") was propagating
> the page pfmemalloc status into the skb, and seems correct to me.
> 
> The bug was the page_frag_alloc() was keeping a problematic page for
> an arbitrary period of time ?

Isn't this the commit which unmasks the problem, though?  I don't think
it's the buggy commit, but if your tree doesn't have 79930f5892e, then
you don't need this patch.

Or are you saying the problem dates back all the way to
c93bdd0e03e8 ("netvm: allow skb allocation to use PFMEMALLOC reserves")

> > +		if (nc->pfmemalloc) {
> 
>                 if (unlikely(nc->pfmemalloc)) {

ACK.  Will make the change once we've settled on an appropriate Fixes tag.
