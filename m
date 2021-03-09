Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A682C332CFB
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 18:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhCIRNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 12:13:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbhCIRNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 12:13:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBEAC06174A;
        Tue,  9 Mar 2021 09:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5U491TQdNsjhbIYsUSmgNKAf6MVmCm1WHLEIdhpS/JU=; b=gPUvkAbBbisJ6IK3aBstPSkfYW
        LukBQjq/CPDnD0C7fLKVYWPdq9Iiad/BOrw2QSQfrb6a4muKVZ7KrqbRUBTR+lMUA+KCNg3xdtlQt
        sAGf6WDADgoDIcO5wmX6UkX1Vtz2XQLXRFYZef49Hn4NcdwbVdoz428WnEGx+0zTA6zvcLTpbvHjG
        JJHVj+uGRN8OrHg62WGpB64yAOFpCqCyhmX2wvRrNOMuWd4IqrETREBWRWrMGnYY5TilXWe3EhFwK
        goyU/0YkSUWwsxfFfzhkhX6/4xLVqLCC2FMOQ8KfyjAGZ0OS7LGeC2XNoorKDvehK520r4/YMpWxB
        UAOpD0Yg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJfuI-000q0x-T5; Tue, 09 Mar 2021 17:12:39 +0000
Date:   Tue, 9 Mar 2021 17:12:30 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] mm/page_alloc: Add a bulk page allocator
Message-ID: <20210309171230.GA198878@infradead.org>
References: <20210301161200.18852-1-mgorman@techsingularity.net>
 <20210301161200.18852-3-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210301161200.18852-3-mgorman@techsingularity.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Would vmalloc be another good user of this API? 

> +	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
> +	if (!prepare_alloc_pages(gfp_mask, 0, preferred_nid, nodemask, &ac, &alloc_mask, &alloc_flags))

This crazy long line is really hard to follow.

> +		return 0;
> +	gfp_mask = alloc_mask;
> +
> +	/* Find an allowed local zone that meets the high watermark. */
> +	for_each_zone_zonelist_nodemask(zone, z, ac.zonelist, ac.highest_zoneidx, ac.nodemask) {

Same here.

> +		unsigned long mark;
> +
> +		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
> +		    !__cpuset_zone_allowed(zone, gfp_mask)) {
> +			continue;
> +		}

No need for the curly braces.

>  	}
>  
> -	gfp_mask &= gfp_allowed_mask;
> -	alloc_mask = gfp_mask;

Is this change intentional?
