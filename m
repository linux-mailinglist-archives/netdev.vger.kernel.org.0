Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79AEA398B1E
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhFBNzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:55:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhFBNzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:55:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622642013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pCBKr2wIH//NMX0nOhN8wkcrLeZTPVtJZ1oKWDlYtoc=;
        b=XUeNz67km9wNoMugM9hY2qg8ubYjcTFw66SPxV/j0a1KzOjGka3CHp6fxkR3tFJEZK0r5W
        fn9KdOsoseDPu/glDumQDQIPpiPsN5WACkF+p8sUXKSIjSgu8T+k/eQ9r4/oY+2P3QyaF/
        u55eDf9UOHns0MJxHJtHWBl1czZJ2gM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-DjOoTLC1P82VMAoTaG_qWA-1; Wed, 02 Jun 2021 09:53:30 -0400
X-MC-Unique: DjOoTLC1P82VMAoTaG_qWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F1FE8015F8;
        Wed,  2 Jun 2021 13:53:28 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 838011001281;
        Wed,  2 Jun 2021 13:53:23 +0000 (UTC)
Date:   Wed, 2 Jun 2021 15:53:22 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Linux-MM <linux-mm@kvack.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [PATCH 2/2] mm/page_alloc: Allow high-order pages to be stored
 on the per-cpu lists
Message-ID: <20210602155322.6f286ea4@carbon>
In-Reply-To: <20210601124533.GU30378@techsingularity.net>
References: <20210531120412.17411-1-mgorman@techsingularity.net>
        <20210531120412.17411-3-mgorman@techsingularity.net>
        <20210531172338.2e7cb070@carbon>
        <20210601124533.GU30378@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 13:45:33 +0100
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Mon, May 31, 2021 at 05:23:38PM +0200, Jesper Dangaard Brouer wrote:
> > On Mon, 31 May 2021 13:04:12 +0100
> > Mel Gorman <mgorman@techsingularity.net> wrote:
> >   
> > > The per-cpu page allocator (PCP) only stores order-0 pages. This means
> > > that all THP and "cheap" high-order allocations including SLUB contends
> > > on the zone->lock. This patch extends the PCP allocator to store THP and
> > > "cheap" high-order pages. Note that struct per_cpu_pages increases in
> > > size to 256 bytes (4 cache lines) on x86-64.
> > > 
> > > Note that this is not necessarily a universal performance win because of
> > > how it is implemented. High-order pages can cause pcp->high to be exceeded
> > > prematurely for lower-orders so for example, a large number of THP pages
> > > being freed could release order-0 pages from the PCP lists. Hence, much
> > > depends on the allocation/free pattern as observed by a single CPU to
> > > determine if caching helps or hurts a particular workload.
> > > 
> > > That said, basic performance testing passed. The following is a netperf
> > > UDP_STREAM test which hits the relevant patches as some of the network
> > > allocations are high-order.  
> > 
> > This series[1] looks very interesting!  I confirm that some network
> > allocations do use high-order allocations.  Thus, I think this will
> > increase network performance in general, like you confirm below:
> >   
> 
> Would you be able to do a small test on a real high-speed network? It's
> something I can do easily myself in a few weeks but I do not have testbed
> readily available at the moment. It's ok if you do not have the time,
> it would just be nice if I could include independent results in the
> changelog if the results are positive. 

I don't have time right now.

If others have time, you can use this git tree provided by Mel:

 https://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git/
 git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git
 branch: mm-pcphighorder-v1r7


> Alternatively, a negative result would mean going back to the drawing
> board :)

I'm confident that this will be a positive performance change. (I
remember we played with similar patches back in 2017).

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

