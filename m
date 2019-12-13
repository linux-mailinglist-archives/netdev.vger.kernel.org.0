Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94CC11DFD3
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfLMItB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:49:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbfLMItA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:49:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576226938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f1sU8L67ldoVATnqCmyBu0614LHoOQga3GZ5zDAlGKw=;
        b=Bw4MC9tJZqRL0ZsDlHjrEFRqEzzFFQ1efkojpCAZFM3fL3icdsvnWierBHDJSItLnvzpnQ
        cDx9e97I1Cdl8GNTNdO6vR7LBR96JVIaJdB/6rELGDFXFrv628KqzmZ39+EI0Y41vkkfo0
        XE/LlOPNvmlmSKTaoPdqCHCHAZOYHxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-JQVY3WICNuaxPUj_6vBMFQ-1; Fri, 13 Dec 2019 03:48:55 -0500
X-MC-Unique: JQVY3WICNuaxPUj_6vBMFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95BF6107ACC4;
        Fri, 13 Dec 2019 08:48:53 +0000 (UTC)
Received: from carbon (ovpn-200-20.brq.redhat.com [10.40.200.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 642595D6BE;
        Fri, 13 Dec 2019 08:48:46 +0000 (UTC)
Date:   Fri, 13 Dec 2019 09:48:45 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "Li,Rongqing" <lirongqing@baidu.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        brouer@redhat.com
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191213094845.56fb42a4@carbon>
In-Reply-To: <079a0315-efea-9221-8538-47decf263684@huawei.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
        <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
        <20191211194933.15b53c11@carbon>
        <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
        <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
        <20191212111831.2a9f05d3@carbon>
        <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
        <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
        <079a0315-efea-9221-8538-47decf263684@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 14:53:37 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> On 2019/12/13 14:27, Li,Rongqing wrote:
> >>
> >> It is good to allocate the rx page close to both cpu and device,
> >> but if both goal can not be reached, maybe we choose to allocate
> >> page that close to cpu?
> >>  
> > I think it is true
> > 
> > If it is true, , we can remove pool->p.nid, and replace
> > alloc_pages_node with alloc_pages in __page_pool_alloc_pages_slow,
> > and change pool_page_reusable as that page_to_nid(page) is checked
> > with numa_mem_id()  

No, as I explained before, you cannot use numa_mem_id() in pool_page_reusable,
because recycle call can happen from/on a remote CPU (and numa_mem_id()
uses the local CPU to determine the NUMA id).

Today we already have XDP cpumap redirect.  And we are working on
extending this to SKBs, which will increase the likelihood even more.

I don't think we want to not-recycle if a remote NUMA node CPU happened
to touch the packet?

(Based on the optimizations done for Facebook (the reason we added this))
What seems to matter is the NUMA node of CPU that runs RX NAPI-polling,
this is the first CPU that touch the packet memory and struct-page
memory.  For these drivers, it is also the same "RX-CPU" that does the
allocation of new pages (to refill the RX-ring), and these "new" pages
can come from the page_pool.

With this in mind, it does seem strange that we are doing the check on
the "free"/recycles code path, that can run on remote CPUs...


> > since alloc_pages hint to use the current node page, and
> > __page_pool_alloc_pages_slow will be called in NAPI polling often
> > if recycle failed, after some cycle, the page will be from local
> > memory node.  

You are basically saying that the NUMA check should be moved to
allocation time, as it is running the RX-CPU (NAPI).  And eventually
after some time the pages will come from correct NUMA node.

I think we can do that, and only affect the semi-fast-path.
We just need to handle that pages in the ptr_ring that are recycled can
be from the wrong NUMA node.  In __page_pool_get_cached() when
consuming pages from the ptr_ring (__ptr_ring_consume_batched), then we
can evict pages from wrong NUMA node.

For the pool->alloc.cache we either accept, that it will eventually
after some time be emptied (it is only in a 100% XDP_DROP workload that
it will continue to reuse same pages).   Or we simply clear the
pool->alloc.cache when calling page_pool_update_nid().


> Yes if allocation and recycling are in the same NAPI polling context.

Which is a false assumption.

> As pointed out by Saeed and Ilias, the allocation and recycling seems
> to may not be happening in the same NAPI polling context, see:
> 
> "In the current code base if they are only called under NAPI this
> might be true. On the page_pool skb recycling patches though (yes
> we'll eventually send those :)) this is called from kfree_skb()."
> 
> So there may need some additionl attention.

Yes, as explained above.



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

