Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF3053697E
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 02:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiE1Avb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 20:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiE1Av2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 20:51:28 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0239E13D5F
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 17:51:25 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L931w4y9GzRhVR;
        Sat, 28 May 2022 08:48:20 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 28 May 2022 08:51:23 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sat, 28 May
 2022 08:51:23 +0800
Subject: Re: [PATCH v3 net] net: sched: add barrier to fix packet stuck
 problem for lockless qdisc
To:     Guoju Fang <gjfang@linux.alibaba.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <eric.dumazet@gmail.com>, <guoju.fgj@alibaba-inc.com>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <rgauguey@kalrayinc.com>, <sjones@kalrayinc.com>,
        <vladimir.oltean@nxp.com>, <vray@kalrayinc.com>, <will@kernel.org>
References: <20220526070145.127019-1-gjfang@linux.alibaba.com>
 <20220527091143.120509-1-gjfang@linux.alibaba.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <64b3c3dc-e36d-45b6-4b3a-45e3d26e8315@huawei.com>
Date:   Sat, 28 May 2022 08:51:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20220527091143.120509-1-gjfang@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/27 17:11, Guoju Fang wrote:
> In qdisc_run_end(), the spin_unlock() only has store-release semantic,
> which guarantees all earlier memory access are visible before it. But
> the subsequent test_bit() may be reordered ahead of the spin_unlock(),
> and may cause a packet stuck problem.
> 
> The concurrent operations can be described as below,
>          CPU 0                      |          CPU 1
>    qdisc_run_end()                  |     qdisc_run_begin()
>           .                         |           .
>  ----> /* may be reorderd here */   |           .
> |         .                         |           .
> |     spin_unlock()                 |         set_bit()
> |         .                         |         smp_mb__after_atomic()
>  ---- test_bit()                    |         spin_trylock()
>           .                         |          .
> 
> Consider the following sequence of events:
>     CPU 0 reorder test_bit() ahead and see MISSED = 0
>     CPU 1 calls set_bit()
>     CPU 1 calls spin_trylock() and return fail
>     CPU 0 executes spin_unlock()
> 
> At the end of the sequence, CPU 0 calls spin_unlock() and does nothing
> because it see MISSED = 0. The skb on CPU 1 has beed enqueued but no one
> take it, until the next cpu pushing to the qdisc (if ever ...) will
> notice and dequeue it.
> 
> So one explicit barrier is needed between spin_unlock() and test_bit()
> to ensure the correct order.

It might be better to mention why smp_mb() is used instead of smp_rmb()
or smp_wmb():

spin_unlock() and test_bit() ordering is a store-load ordering, which
requires a full memory barrier as smp_mb().

> 
> Fixes: 89837eb4b246 ("net: sched: add barrier to ensure correct ordering for lockless qdisc")

The Fixes tag should be:

Fixes: a90c57f2cedd ("net: sched: fix packet stuck problem for lockless qdisc")

Other than that, it looks good to me:
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> Signed-off-by: Guoju Fang <gjfang@linux.alibaba.com>
> ---
> V2 -> V3: Not split the Fixes tag across multiple lines
> V1 -> V2: Rewrite comments
> ---
>  include/net/sch_generic.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index 9bab396c1f3b..8a8738642ca0 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -229,6 +229,9 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
>  	if (qdisc->flags & TCQ_F_NOLOCK) {
>  		spin_unlock(&qdisc->seqlock);
>  
> +		/* ensure ordering between spin_unlock() and test_bit() */
> +		smp_mb();
> +
>  		if (unlikely(test_bit(__QDISC_STATE_MISSED,
>  				      &qdisc->state)))
>  			__netif_schedule(qdisc);
> 
