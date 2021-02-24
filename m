Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDE3323B4A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhBXL3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:29:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234871AbhBXL3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:29:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614166076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uKVLad2iARoW1c2dRwOltL8pSbyE/6ChbP13Q5obmTg=;
        b=Uk+hyuXL80v+e6HMYGbrkgdreT+94O2PhxTXPv8nhPlemS07TKOeN9X+Wq9PInS0TY3pnD
        nOEGSDST8yn459n2ALP1ba0uh5rr4cFDHcS8ZMJXiKAEK+8nmzU6ty8/goNxHIFh6tuNtA
        +wSpyUxTKgvvP1egvWIYH9NVbQBkLCA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-VNUKl0siP7qMYyLUDwGloA-1; Wed, 24 Feb 2021 06:27:31 -0500
X-MC-Unique: VNUKl0siP7qMYyLUDwGloA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 349E6104ED67;
        Wed, 24 Feb 2021 11:27:30 +0000 (UTC)
Received: from carbon (unknown [10.36.110.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7922360C5F;
        Wed, 24 Feb 2021 11:27:24 +0000 (UTC)
Date:   Wed, 24 Feb 2021 12:27:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [RFC PATCH 0/3] Introduce a bulk order-0 page allocator for
 sunrpc
Message-ID: <20210224122723.15943e95@carbon>
In-Reply-To: <20210224102603.19524-1-mgorman@techsingularity.net>
References: <20210224102603.19524-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 10:26:00 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> This is a prototype series that introduces a bulk order-0 page allocator
> with sunrpc being the first user. The implementation is not particularly
> efficient and the intention is to iron out what the semantics of the API
> should be. That said, sunrpc was reported to have reduced allocation
> latency when refilling a pool.

I also have a use-case in page_pool, and I've been testing with the
earlier patches, results are here[1]

[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org

Awesome to see this newer patchset! thanks a lot for working on this!
I'll run some new tests based on this.

> As a side-note, while the implementation could be more efficient, it
> would require fairly deep surgery in numerous places. The lock scope would
> need to be significantly reduced, particularly as vmstat, per-cpu and the
> buddy allocator have different locking protocol that overal -- e.g. all
> partially depend on irqs being disabled at various points. Secondly,
> the core of the allocator deals with single pages where as both the bulk
> allocator and per-cpu allocator operate in batches. All of that has to
> be reconciled with all the existing users and their constraints (memory
> offline, CMA and cpusets being the trickiest).

As you can see in[1], I'm getting a significant speedup from this.  I
guess that the cost of finding the "zone" is higher than I expected, as
this basically what we/you amortize for the bulk.

 
> In terms of semantics required by new users, my preference is that a pair
> of patches be applied -- the first which adds the required semantic to
> the bulk allocator and the second which adds the new user.
> 
> Patch 1 of this series is a cleanup to sunrpc, it could be merged
> 	separately but is included here for convenience.
> 
> Patch 2 is the prototype bulk allocator
> 
> Patch 3 is the sunrpc user. Chuck also has a patch which further caches
> 	pages but is not included in this series. It's not directly
> 	related to the bulk allocator and as it caches pages, it might
> 	have other concerns (e.g. does it need a shrinker?)
> 
> This has only been lightly tested on a low-end NFS server. It did not break
> but would benefit from an evaluation to see how much, if any, the headline
> performance changes. The biggest concern is that a light test case showed
> that there are a *lot* of bulk requests for 1 page which gets delegated to
> the normal allocator.  The same criteria should apply to any other users.

If you change local_irq_save(flags) to local_irq_disable() then you can
likely get better performance for 1 page requests via this API.  This
limits the API to be used in cases where IRQs are enabled (which is
most cases).  (For my use-case I will not do 1 page requests).


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

