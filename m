Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D52B33F697
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhCQRVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:21:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231833AbhCQRT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 13:19:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616001597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0NhvvvHmyT/STmm3le4+4DkjnpET7hVpc/Bo+3kH164=;
        b=E0i8ADBm0ma7+2R/RZj3aAj0Csb+rTsteeDDinbdqgU8Ooiv97CSxvN/OTi926Ejzo+XuB
        B/YErfR6sUQRPW3EYzIzA5bMsGWI//e7nM2sJjCj6fmjQ/fkE6uGAZQg4KZbW/lVhkFZP+
        TsDXp59eH/3nmhbuPMKLR2gukPtPRXs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-594-5zsbSrqYM2e8rRrQeWjybg-1; Wed, 17 Mar 2021 13:19:53 -0400
X-MC-Unique: 5zsbSrqYM2e8rRrQeWjybg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0954A9CC00;
        Wed, 17 Mar 2021 17:19:51 +0000 (UTC)
Received: from carbon (unknown [10.36.110.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 02EB919C45;
        Wed, 17 Mar 2021 17:19:44 +0000 (UTC)
Date:   Wed, 17 Mar 2021 18:19:43 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 0/7 v4] Introduce a bulk order-0 page allocator with two
 in-tree users
Message-ID: <20210317181943.1a339b1e@carbon>
In-Reply-To: <20210317165220.808975-1-alobakin@pm.me>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
        <20210317163055.800210-1-alobakin@pm.me>
        <20210317173844.6b10f879@carbon>
        <20210317165220.808975-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Mar 2021 16:52:32 +0000
Alexander Lobakin <alobakin@pm.me> wrote:

> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Wed, 17 Mar 2021 17:38:44 +0100
> 
> > On Wed, 17 Mar 2021 16:31:07 +0000
> > Alexander Lobakin <alobakin@pm.me> wrote:
> >  
> > > From: Mel Gorman <mgorman@techsingularity.net>
> > > Date: Fri, 12 Mar 2021 15:43:24 +0000
> > >
> > > Hi there,
> > >  
> > > > This series is based on top of Matthew Wilcox's series "Rationalise
> > > > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > > > test and are not using Andrew's tree as a baseline, I suggest using the
> > > > following git tree
> > > >
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v4r2  
> > >
> > > I gave this series a go on my setup, it showed a bump of 10 Mbps on
> > > UDP forwarding, but dropped TCP forwarding by almost 50 Mbps.
> > >
> > > (4 core 1.2GHz MIPS32 R2, page size of 16 Kb, Page Pool order-0
> > > allocations with MTU of 1508 bytes, linear frames via build_skb(),
> > > GRO + TSO/USO)  
> >
> > What NIC driver is this?  
> 
> Ah, forgot to mention. It's a WIP driver, not yet mainlined.
> The NIC itself is basically on-SoC 1G chip.

Hmm, then it is really hard to check if your driver is doing something
else that could cause this.

Well, can you try to lower the page_pool bulking size, to test the
theory from Wilcox that we should do smaller bulking to avoid pushing
cachelines into L2 when walking the LRU list.  You might have to go as
low as bulk=8 (for N-way associative level of L1 cache).

In function: __page_pool_alloc_pages_slow() adjust variable:
  const int bulk = PP_ALLOC_CACHE_REFILL;


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

