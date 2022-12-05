Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B83642CD2
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiLEQb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 11:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiLEQbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 11:31:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92961E723
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 08:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SGd7TXZdDfHrbb1WwiVgQv6yQ1EyRbidqpbDSF4IWfE=; b=vIU7rbD2ffrSWFQprhISZrBpUU
        65tdh4jTvUGRiHWmPAlG+U3BeTV9vam1i8Z4Nw0XtUxYdT131B0NceGDxZr2ckCsrVC/mW0xQlN5r
        5KdA6Q1K2lVpykdu1+3Tyszq5KEgdrElpw2KGtY59m+wpQeM18oD9/baqv0R3QON7qiyPkLznM1a7
        5URojQK7NgPV1/J/iaZXN5vUaGdr6/YmS1GPvsBjL8z5Ng7s21y2W+3Qms4xZeyRZGtjIc6+3p/hY
        7mdNY7XEqxGrGwJbRRQZ5KcnmTjTtkiIesmieY9bkiyLAsEjf6thIUqmsfZMQ8vrO8eqsZkcEp3Bn
        zT6Dc8ug==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2ENA-003QtC-5c; Mon, 05 Dec 2022 16:31:16 +0000
Date:   Mon, 5 Dec 2022 16:31:16 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 00/24] Split page pools from struct page
Message-ID: <Y44c1KKE797U3kCM@casper.infradead.org>
References: <20221130220803.3657490-1-willy@infradead.org>
 <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfe0b2ca-824d-3a52-423a-f8262f12fabe@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 04:34:10PM +0100, Jesper Dangaard Brouer wrote:
> I have a micro-benchmark [1][2], that I want to run on this patchset.
> Reducing the asm code 'text' size is less likely to improve a
> microbenchmark. The 100Gbit mlx5 driver uses page_pool, so perhaps I can
> run a packet benchmark that can show the (expected) performance improvement.
> 
> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_simple.c
> [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/bench_page_pool_cross_cpu.c

Appreciate it!  I'm not expecting any performance change outside noise,
but things do surprise me.  I'd appreciate it if you'd test with a
"distro" config, ie enabling CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
we show the most expensive case.

> > I've only converted one user of the page_pool APIs to use the new netmem
> > APIs, all the others continue to use the page based ones.
> > 
> 
> I guess we/netdev-devels need to update the NIC drivers that uses page_pool.

Oh, it's not a huge amount of work, and I don't mind doing it.  I only
did one in order to show the kinds of changes that are needed.  I can
do the mlx5 conversion now ...
