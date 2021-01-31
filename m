Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E0C309C30
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhAaM5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhAaMY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:24:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47054C06178C;
        Sun, 31 Jan 2021 04:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3ierbyMbeaakxC40P45R1nniLaglqq7PY9us93p+KQw=; b=qikTLHGH1/fMk3qHWKTEUrYKqH
        etPBhwUXi1FP84nl4bQv22D1vd7cXGv1k3A2f0MR8w4bQVcChcXIBzUeUgK1INLwq0kvSXZIUwDox
        SPtHCeDYP+1+P2kT3BFBRC0r3bqMxLC0UwoZOEcmVDEAZy7pKWzOCVqS8GiF/guphGy85q0IfoJrD
        6+8p98UD5vx+Cw2dtA98qN7b/xLPz3tqpy4S+GWv5XhneeDzuHjPw3Ts0lyDTV7hs8PReKkQdAXnb
        dnaOvjZEtkMKNa33REsiB1lFXuKg59mF/vT3GVvd1mGxU9H9JTUpjEFS9KQXcS36kLRDGuUrsfM1w
        MH6iUUog==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l6Bjx-00CQj7-90; Sun, 31 Jan 2021 12:22:05 +0000
Date:   Sun, 31 Jan 2021 12:22:05 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 net-next 3/5] net: introduce common
 dev_page_is_reusable()
Message-ID: <20210131122205.GL308988@casper.infradead.org>
References: <20210131120844.7529-1-alobakin@pm.me>
 <20210131120844.7529-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210131120844.7529-4-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 12:11:52PM +0000, Alexander Lobakin wrote:
> A bunch of drivers test the page before reusing/recycling for two
> common conditions:
>  - if a page was allocated under memory pressure (pfmemalloc page);
>  - if a page was allocated at a distant memory node (to exclude
>    slowdowns).
> 
> Introduce a new common inline for doing this, with likely() already
> folded inside to make driver code a bit simpler.

I don't see the need for the 'dev_' prefix.  That actually confuses me
because it makes me think this is tied to ZONE_DEVICE or some such.

So how about calling it just 'page_is_reusable' and putting it in mm.h
with page_is_pfmemalloc() and making the comment a little less network-centric?

Or call it something like skb_page_is_recyclable() since it's only used
by networking today.  But I bet it could/should be used more widely.

> +/**
> + * dev_page_is_reusable - check whether a page can be reused for network Rx
> + * @page: the page to test
> + *
> + * A page shouldn't be considered for reusing/recycling if it was allocated
> + * under memory pressure or at a distant memory node.
> + *
> + * Returns false if this page should be returned to page allocator, true
> + * otherwise.
> + */
> +static inline bool dev_page_is_reusable(const struct page *page)
> +{
> +	return likely(page_to_nid(page) == numa_mem_id() &&
> +		      !page_is_pfmemalloc(page));
> +}
> +
