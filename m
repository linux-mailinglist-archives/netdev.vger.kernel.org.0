Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9696D55AA
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 02:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjDDAxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 20:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDDAxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 20:53:45 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4033F26A2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 17:53:44 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Pr8L83cBxzSlwr;
        Tue,  4 Apr 2023 08:49:52 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 08:53:36 +0800
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized
 NAPI
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>
References: <20230331043906.3015706-1-kuba@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
Date:   Tue, 4 Apr 2023 08:53:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230331043906.3015706-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/31 12:39, Jakub Kicinski wrote:
> Recent patches to mlx5 mentioned a regression when moving from
> driver local page pool to only using the generic page pool code.
> Page pool has two recycling paths (1) direct one, which runs in
> safe NAPI context (basically consumer context, so producing
> can be lockless); and (2) via a ptr_ring, which takes a spin
> lock because the freeing can happen from any CPU; producer
> and consumer may run concurrently.
> 
> Since the page pool code was added, Eric introduced a revised version
> of deferred skb freeing. TCP skbs are now usually returned to the CPU
> which allocated them, and freed in softirq context. This places the
> freeing (producing of pages back to the pool) enticingly close to
> the allocation (consumer).
> 
> If we can prove that we're freeing in the same softirq context in which
> the consumer NAPI will run - lockless use of the cache is perfectly fine,
> no need for the lock.
> 
> Let drivers link the page pool to a NAPI instance. If the NAPI instance
> is scheduled on the same CPU on which we're freeing - place the pages
> in the direct cache.
> 
> With that and patched bnxt (XDP enabled to engage the page pool, sigh,
> bnxt really needs page pool work :() I see a 2.6% perf boost with
> a TCP stream test (app on a different physical core than softirq).
> 
> The CPU use of relevant functions decreases as expected:
> 
>   page_pool_refill_alloc_cache   1.17% -> 0%
>   _raw_spin_lock                 2.41% -> 0.98%
> 
> Only consider lockless path to be safe when NAPI is scheduled
> - in practice this should cover majority if not all of steady state
> workloads. It's usually the NAPI kicking in that causes the skb flush.

Interesting.
I wonder if we can make this more generic by adding the skb to per napi
list instead of sd->defer_list, so that we can always use NAPI kicking to
flush skb as net_tx_action() done for sd->completion_queue instead of
softirq kicking?

And it seems we know which napi binds to a specific socket through
busypoll mechanism, we can reuse that to release a skb to the napi
bound to that socket?

> 
> The main case we'll miss out on is when application runs on the same
> CPU as NAPI. In that case we don't use the deferred skb free path.
> We could disable softirq one that path, too... maybe?
> 
