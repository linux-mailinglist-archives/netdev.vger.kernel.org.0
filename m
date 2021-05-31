Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980D03963AE
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 17:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbhEaPbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 11:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234451AbhEaPZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 11:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622474627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i17u7i2bEbZO5Ke3bJPruekBEIb7LASzWJbDq7cVY8E=;
        b=gJJarH/75bJcUcsyC7MOqIIYlPdg3VnLiA9EDtyP94ZXFIil3nqXvYw5nAS0qyMBvMjKAa
        1zYk9z1891M43c/zaIZuCNQH4HcvKY84B1y0cnM+dJJY9BZqn7J39oSlu3JtDuMDX61dK9
        vSjaeDG80sEbdkjkyJ4rLk88A0b8r8M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-gjN5G9evPfqtdiDICNaDQA-1; Mon, 31 May 2021 11:23:46 -0400
X-MC-Unique: gjN5G9evPfqtdiDICNaDQA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A01D106BB2A;
        Mon, 31 May 2021 15:23:44 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 863DE5D6D5;
        Mon, 31 May 2021 15:23:39 +0000 (UTC)
Date:   Mon, 31 May 2021 17:23:38 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Linux-MM <linux-mm@kvack.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, brouer@redhat.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/page_alloc: Allow high-order pages to be stored
 on the per-cpu lists
Message-ID: <20210531172338.2e7cb070@carbon>
In-Reply-To: <20210531120412.17411-3-mgorman@techsingularity.net>
References: <20210531120412.17411-1-mgorman@techsingularity.net>
        <20210531120412.17411-3-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 31 May 2021 13:04:12 +0100
Mel Gorman <mgorman@techsingularity.net> wrote:

> The per-cpu page allocator (PCP) only stores order-0 pages. This means
> that all THP and "cheap" high-order allocations including SLUB contends
> on the zone->lock. This patch extends the PCP allocator to store THP and
> "cheap" high-order pages. Note that struct per_cpu_pages increases in
> size to 256 bytes (4 cache lines) on x86-64.
> 
> Note that this is not necessarily a universal performance win because of
> how it is implemented. High-order pages can cause pcp->high to be exceeded
> prematurely for lower-orders so for example, a large number of THP pages
> being freed could release order-0 pages from the PCP lists. Hence, much
> depends on the allocation/free pattern as observed by a single CPU to
> determine if caching helps or hurts a particular workload.
> 
> That said, basic performance testing passed. The following is a netperf
> UDP_STREAM test which hits the relevant patches as some of the network
> allocations are high-order.

This series[1] looks very interesting!  I confirm that some network
allocations do use high-order allocations.  Thus, I think this will
increase network performance in general, like you confirm below:

> netperf-udp
>                                  5.13.0-rc2             5.13.0-rc2
>                            mm-pcpburst-v3r4   mm-pcphighorder-v1r7
> Hmean     send-64         261.46 (   0.00%)      266.30 *   1.85%*
> Hmean     send-128        516.35 (   0.00%)      536.78 *   3.96%*
> Hmean     send-256       1014.13 (   0.00%)     1034.63 *   2.02%*
> Hmean     send-1024      3907.65 (   0.00%)     4046.11 *   3.54%*
> Hmean     send-2048      7492.93 (   0.00%)     7754.85 *   3.50%*
> Hmean     send-3312     11410.04 (   0.00%)    11772.32 *   3.18%*
> Hmean     send-4096     13521.95 (   0.00%)    13912.34 *   2.89%*
> Hmean     send-8192     21660.50 (   0.00%)    22730.72 *   4.94%*
> Hmean     send-16384    31902.32 (   0.00%)    32637.50 *   2.30%*
> 
> From a functional point of view, a patch like this is necessary to
> make bulk allocation of high-order pages work with similar performance
> to order-0 bulk allocations. The bulk allocator is not updated in this
> series as it would have to be determined by bulk allocation users how
> they want to track the order of pages allocated with the bulk allocator.

Thanks for working on this Mel, it is great to see! :-)

Message-Id: <20210531120412.17411-3-mgorman@techsingularity.net>
 [1] https://lore.kernel.org/linux-mm/20210531120412.17411-3-mgorman@techsingularity.net/
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

