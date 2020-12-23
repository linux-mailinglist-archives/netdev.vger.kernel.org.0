Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283052E19CD
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgLWIOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:14:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgLWIOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:14:22 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A401C0613D6;
        Wed, 23 Dec 2020 00:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9mT6ehxNEt1jUz3TfJecdTTXQ2Ih2qfV3QTcUD44O04=; b=JPB0a4t7K8WEKPQv3hVXh7yGzq
        9wAt2jVARSqPuaCHW+1jygDtQ11enIvosGCFjiLDVmuSCI8gUnDAxJtkTlAzV5L94gaz7Nlurb6om
        yHj7+cinD8X0Hx0hjLaW/sFbtlTe5TqGuH4hTiPGacWQ8228r7/V1ZR7RvvW/gervcVRB6cU7hP9j
        8Ye+VK76pyC3CaL4DQ/AVEiAzsuPUIrmQTmCmkIqWzDKIiHn5tTplGa0VeBlmQNf2yjzl2DdKFAXy
        p/0B807UKBAiXZohjVUCLoOmCQL5L6j1HusyL4nlAeQapxfq2STMvgRXEPAa76V5nNERvvE7Y7T2U
        AR6qBiNQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krzGu-0005kz-5Q; Wed, 23 Dec 2020 08:13:24 +0000
Date:   Wed, 23 Dec 2020 08:13:24 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, akpm@linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, corbet@lwn.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC v2 01/13] mm: export zap_page_range() for driver use
Message-ID: <20201223081324.GA21558@infradead.org>
References: <CACycT3vevQQ8cGK_ac-1oyCb9+YPSAhLMue=4J3=2HzXVK7XHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3vevQQ8cGK_ac-1oyCb9+YPSAhLMue=4J3=2HzXVK7XHw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 02:32:07PM +0800, Yongji Xie wrote:
> Now I want to map/unmap some pages in an userland vma dynamically. The
> vm_insert_page() is being used for mapping. In the unmapping case, it
> looks like the zap_page_range() does what I want. So I export it.
> Otherwise, we need some ways to notify userspace to trigger it with
> madvise(MADV_DONTNEED), which might not be able to meet all our needs.
> For example, unmapping some pages in a memory shrinker function.
> 
> So I'd like to know what's the limitation to use zap_page_range() in a
> module. And if we can't use it in a module, is there any acceptable
> way to achieve that?

I think the anser is: don't play funny games with unmapped outside of
munmap.  Especially as synchronization is very hard to get right.
