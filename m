Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3395C6448E7
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbiLFQNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiLFQN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:13:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F46132BB9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 08:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3QwSqDt++m9/zROdaadAwgLq1cg/29F6bPU0ttuj7tI=; b=CMBgEFYOyS3y4QN9/81ROmNl5o
        15hL2UwsY9qP7a96tTeXPTM6DkywPCxjImVWpqZBs/61aHFK17OaD0miE9xujioc7krVBHUAnroIU
        L/YeYuLxiKGAIMbnf3KIolkRAz+WDyrv9vPhekiCpOQM8wFXlZMxpTgYVDmPQlzrqhPpJsJo1iDlS
        3W01kyob5g+akPa/S4vm/jkt9GeknBrWUZjlhvDZRUuLmXJiaPvC2sS3qre8stYU4b+F/piy50E8N
        BHdkGfnWfnMT7IPanqJHbtRKGnD5xgWujIk4PEwByinBqIv1tz+CxKXMVj2ZB1icINSg6yc+m4IaH
        rOhudT7Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2aUT-004aIf-Og; Tue, 06 Dec 2022 16:08:17 +0000
Date:   Tue, 6 Dec 2022 16:08:17 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/24] Split page pools from struct page
Message-ID: <Y49o8e6F5SP4h+wF@casper.infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
 <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
 <Y44c1KKE797U3kCM@casper.infradead.org>
 <7cfbcde0-9d17-0a89-49ae-942a80c63feb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cfbcde0-9d17-0a89-49ae-942a80c63feb@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 10:43:05AM +0100, Jesper Dangaard Brouer wrote:
> 
> 
> On 05/12/2022 17.31, Matthew Wilcox wrote:
> > On Mon, Dec 05, 2022 at 04:34:10PM +0100, Jesper Dangaard Brouer wrote:
> > > I have a micro-benchmark [1][2], that I want to run on this patchset.
> > > Reducing the asm code 'text' size is less likely to improve a
> > > microbenchmark. The 100Gbit mlx5 driver uses page_pool, so perhaps I can
> > > run a packet benchmark that can show the (expected) performance improvement.
> > > 
> > > [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> > > [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c
> > 
> > Appreciate it!  I'm not expecting any performance change outside noise,
> > but things do surprise me.  I'd appreciate it if you'd test with a
> > "distro" config, ie enabling CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
> > we show the most expensive case.
> > 
> 
> I have CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y BUT it isn't default
> runtime enabled.

That's fine.  I think the vast majority of machines won't actually have
it enabled.  It's mostly useful for hosting setups where allocating 1GB
pages for VMs is common.

The mlx5 driver was straightforward, but showed some gaps in the API.
You'd already got the majority of the wins by using page_ref_inc()
instead of get_page(), but I did find one put_page() ;-)
