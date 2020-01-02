Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E12912E5D3
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 12:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgABLqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 06:46:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728216AbgABLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 06:46:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577965587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=US4wYhMCc3xHAX0fNldkKecHiJE+JAQdaMN2H3eHOPw=;
        b=T9LWkkF+gRv9pgQUsEtWdxuIPJGp6D2IvPORrByd6r2OVC64PK/70NogwBTnwfcGYDkzdy
        x6X7ePJKM7yf63+NEQwmJiqz5kXdeE0Hma0q2cQBaCr7UkoTyjvbFbEdEId78B4qIxgyDM
        ZxwYHTXmzv1SDf7Abij63m8ybfBeXys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-wsBGg0_lPQaqR5iCEBYzyQ-1; Thu, 02 Jan 2020 06:46:23 -0500
X-MC-Unique: wsBGg0_lPQaqR5iCEBYzyQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C53EC10CE781;
        Thu,  2 Jan 2020 11:46:21 +0000 (UTC)
Received: from carbon (ovpn-200-18.brq.redhat.com [10.40.200.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 36B365D9C9;
        Thu,  2 Jan 2020 11:46:15 +0000 (UTC)
Date:   Thu, 2 Jan 2020 12:46:14 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <netdev@vger.kernel.org>, <lirongqing@baidu.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, <mhocko@kernel.org>,
        <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: [net-next v6 PATCH 1/2] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20200102124614.1335fa32@carbon>
In-Reply-To: <b56069bd-ca8f-68bc-7e0b-bd0da423f891@huawei.com>
References: <157746672570.257308.7385062978550192444.stgit@firesoul>
        <157746679893.257308.4995193590996029483.stgit@firesoul>
        <b56069bd-ca8f-68bc-7e0b-bd0da423f891@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Dec 2019 09:59:23 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> On 2019/12/28 1:13, Jesper Dangaard Brouer wrote:
> > The check in pool_page_reusable (page_to_nid(page) == pool->p.nid) is
> > not valid if page_pool was configured with pool->p.nid = NUMA_NO_NODE.
> > 
> > The goal of the NUMA changes in commit d5394610b1ba ("page_pool: Don't
> > recycle non-reusable pages"), were to have RX-pages that belongs to the
> > same NUMA node as the CPU processing RX-packet during softirq/NAPI. As
> > illustrated by the performance measurements.
> > 
> > This patch moves the NAPI checks out of fast-path, and at the same time
> > solves the NUMA_NO_NODE issue.  
> 
> There seems to be a minor NUMA_NO_NODE case that has not been handled by
> this patch yet:
> 
> 1. When the page is always recycled to pool->alloc.cache.
> 2. And page_pool_alloc_pages always return pages from pool->alloc.cache.
> 
> Then non-local page will be reused when the rx NAPI affinity changes.
> 
> Of coure we can handle above by calling page_pool_update_nid(), which
> may require very user to call page_pool_update_nid() explicitly even
> the user has specify the pool->p.nid as NUMA_NO_NODE.
> 
> Any consideration for above case?

Yes, I tried to explain below, that "we accept that transitioning the
alloc cache doesn't happen immediately.".  Thus, I've not forgotten
about this case, and I still consider this patch correct.

You have to consider/understand how this page_pool cache is used.  The
alloc cache can only get "recycled" pages in rare situations.  The case
basically only happen for XDP_DROP (which have extreme performance
needs).  Sure, in a 100% XDP_DROP case, then your described case can
happen, but that case is unlikely/useless in real-life production. Some
packets must be let through, which will have to travel through the
ptr_ring, where the NUMA check is done.  Thus, pages will eventually
transition to the new NAPI node of the new IRQ-CPU.


> > 
> > First realize that alloc_pages_node() with pool->p.nid = NUMA_NO_NODE
> > will lookup current CPU nid (Numa ID) via numa_mem_id(), which is used
> > as the the preferred nid.  It is only in rare situations, where
> > e.g. NUMA zone runs dry, that page gets doesn't get allocated from
> > preferred nid.  The page_pool API allows drivers to control the nid
> > themselves via controlling pool->p.nid.
> > 
> > This patch moves the NAPI check to when alloc cache is refilled, via
> > dequeuing/consuming pages from the ptr_ring. Thus, we can allow placing
> > pages from remote NUMA into the ptr_ring, as the dequeue/consume step
> > will check the NUMA node. All current drivers using page_pool will
> > alloc/refill RX-ring from same CPU running softirq/NAPI process.
> > 
> > Drivers that control the nid explicitly, also use page_pool_update_nid
> > when changing nid runtime.  To speed up transision to new nid the alloc
> > cache is now flushed on nid changes.  This force pages to come from
> > ptr_ring, which does the appropate nid check.
> > 
> > For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> > node, we accept that transitioning the alloc cache doesn't happen
> > immediately. The preferred nid change runtime via consulting
> > numa_mem_id() based on the CPU processing RX-packets.

This is the section, where I say: "we accept that transitioning the
alloc cache doesn't happen immediately. "


> > Notice, to avoid stressing the page buddy allocator and avoid doing too
> > much work under softirq with preempt disabled, the NUMA check at
> > ptr_ring dequeue will break the refill cycle, when detecting a NUMA
> > mismatch. This will cause a slower transition, but its done on purpose.
> > 
> > Fixes: d5394610b1ba ("page_pool: Don't recycle non-reusable pages")
> > Reported-by: Li RongQing <lirongqing@baidu.com>
> > Reported-by: Yunsheng Lin <linyunsheng@huawei.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

