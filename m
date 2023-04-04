Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A786D5ED3
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbjDDLS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjDDLS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:18:27 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428991703
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 04:18:25 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PrQCR49mzz17K9r;
        Tue,  4 Apr 2023 19:14:59 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 4 Apr
 2023 19:18:22 +0800
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Liang Chen <liangchen.linux@gmail.com>,
        <ilias.apalodimas@linaro.org>, <hawk@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b945cf5b-4085-551f-7bb8-9bc4e38d0397@huawei.com>
Date:   Tue, 4 Apr 2023 19:18:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230404074733.22869-1-liangchen.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/4 15:47, Liang Chen wrote:
> Commit 1effe8ca4e34 allowed coalescing to proceed with non page pool page
> and page pool page when @from is cloned, i.e.
> 
> to->pp_recycle    --> false
> from->pp_recycle  --> true
> skb_cloned(from)  --> true
> 
> However, it actually requires skb_cloned(@from) to hold true until
> coalescing finishes in this situation. If the other cloned SKB is
> released while the merging is in process, from_shinfo->nr_frags will be
> set to 0 toward the end of the function, causing the increment of frag
> page _refcount to be unexpectedly skipped resulting in inconsistent
> reference counts. Later when SKB(@to) is released, it frees the page
> directly even though the page pool page is still in use, leading to
> use-after-free or double-free errors. So it should be prohibitted.

Nice catch.

> 
> The double-free error message below prompted us to investigate:
> BUG: Bad page state in process swapper/1  pfn:0e0d1
> page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
> index:0x2 pfn:0xe0d1
> flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
> raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
> raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
> page dumped because: nonzero _refcount
> 
> CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
> Call Trace:
>  <IRQ>
> dump_stack_lvl+0x32/0x50
> bad_page+0x69/0xf0
> free_pcp_prepare+0x260/0x2f0
> free_unref_page+0x20/0x1c0
> skb_release_data+0x10b/0x1a0
> napi_consume_skb+0x56/0x150
> net_rx_action+0xf0/0x350
> ? __napi_schedule+0x79/0x90
> __do_softirq+0xc8/0x2b1
> __irq_exit_rcu+0xb9/0xf0
> common_interrupt+0x82/0xa0
> </IRQ>
> <TASK>
> asm_common_interrupt+0x22/0x40
> RIP: 0010:default_idle+0xb/0x20

A Fixes tag is needed for the backport of the fix.
Fixes: 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment recycling")

And target the net branch for bugfix:
 [PATCH net] skbuff: Fix a race between coalescing and releasing SKBs

Otherwise, it looks good to me:
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  net/core/skbuff.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 050a875d09c5..9be23ece5f03 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5598,17 +5598,14 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>  		return false;
>  
>  	/* In general, avoid mixing slab allocated and page_pool allocated
> -	 * pages within the same SKB. However when @to is not pp_recycle and
> -	 * @from is cloned, we can transition frag pages from page_pool to
> -	 * reference counted.
> -	 *
> -	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
> -	 * @from is cloned, in case the SKB is using page_pool fragment
> -	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
> -	 * references for cloned SKBs at the moment that would result in
> -	 * inconsistent reference counts.
> +	 * pages within the same SKB. However don't allow coalescing two
> +	 * pp_recycle SKBs if @from is cloned, in case the SKB is using
> +	 * page_pool fragment references (PP_FLAG_PAGE_FRAG). Since we only
> +	 * take full page references for cloned SKBs at the moment that would
> +	 * result in inconsistent reference counts.
>  	 */
> -	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
> +	if ((to->pp_recycle != from->pp_recycle)
> +		|| (from->pp_recycle && skb_cloned(from)))
>  		return false;
>  
>  	if (len <= skb_tailroom(to)) {
> 
