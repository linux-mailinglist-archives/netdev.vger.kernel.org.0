Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C584911BC2A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLKStq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:49:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47688 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726242AbfLKStq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:49:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576090184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BiLSYDkRntIU858BzJstZyuUBPdrBkPDKmfLrKClZAk=;
        b=ALZfhn+nuMwWMipe+3Q1EFiePNkQ4/KciAC6YFv7tC66H8O/QuDaDjrPJ2mtRwwIdRmks5
        R/feF41Q+B4Jg9vK28KqDnRZrfgE2D8kwISmz2e5qZpks3oGmQbfkT1PwXkWNsupZwqOSS
        mMgJr4oLb/vWRMC7ess+jCwsuEhdzEM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-KXCLEEqOO1SUHuSbF4k6uQ-1; Wed, 11 Dec 2019 13:49:41 -0500
X-MC-Unique: KXCLEEqOO1SUHuSbF4k6uQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A2244800C75;
        Wed, 11 Dec 2019 18:49:39 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C8DAB5C1BB;
        Wed, 11 Dec 2019 18:49:34 +0000 (UTC)
Date:   Wed, 11 Dec 2019 19:49:33 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        brouer@redhat.com
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
Message-ID: <20191211194933.15b53c11@carbon>
In-Reply-To: <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
        <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 7 Dec 2019 03:52:41 +0000
Saeed Mahameed <saeedm@mellanox.com> wrote:

> I don't think it is correct to check that the page nid is same as
> numa_mem_id() if pool is NUMA_NO_NODE. In such case we should allow all
> pages to recycle, because you can't assume where pages are allocated
> from and where they are being handled.

I agree, using numa_mem_id() is not valid, because it takes the numa
node id from the executing CPU and the call to __page_pool_put_page()
can happen on a remote CPU (e.g. cpumap redirect, and in future SKBs).


> I suggest the following:
> 
> return !page_pfmemalloc() && 
> ( page_to_nid(page) == pool->p.nid || pool->p.nid == NUMA_NO_NODE );

Above code doesn't generate optimal ASM code, I suggest:

 static bool pool_page_reusable(struct page_pool *pool, struct page *page)
 {
	return !page_is_pfmemalloc(page) &&
		pool->p.nid != NUMA_NO_NODE &&
		page_to_nid(page) == pool->p.nid;
 }

I have compiled different variants and looked at the ASM code generated
by GCC.  This seems to give the best result.


> 1) never recycle emergency pages, regardless of pool nid.
> 2) always recycle if pool is NUMA_NO_NODE.

Yes, this defines the semantics, that a page_pool configured with
NUMA_NO_NODE means skip NUMA checks.  I think that sounds okay...


> the above change should not add any overhead, a modest branch
> predictor will handle this with no effort.

It still annoys me that we keep adding instructions to this code
hot-path (I counted 34 bytes and 11 instructions in my proposed
function).

I think that it might be possible to move these NUMA checks to
alloc-side (instead of return/recycles side as today), and perhaps only
on slow-path when dequeuing from ptr_ring (as recycles that call
__page_pool_recycle_direct() will be pinned during NAPI).  But lets
focus on a smaller fix for the immediate issue...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

