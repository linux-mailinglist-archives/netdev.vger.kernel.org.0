Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5B66E0CDA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDMLmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDMLmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:42:25 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677156183
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:42:23 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PxyJG2LlHzSrKs;
        Thu, 13 Apr 2023 19:38:22 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 13 Apr
 2023 19:42:20 +0800
Subject: Re: [PATCH v5] skbuff: Fix a race between coalescing and releasing
 SKBs
To:     Liang Chen <liangchen.linux@gmail.com>, <kuba@kernel.org>,
        <ilias.apalodimas@linaro.org>, <edumazet@google.com>,
        <hawk@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <alexander.duyck@gmail.com>
References: <20230413090353.14448-1-liangchen.linux@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d7cd5acd-141f-32c4-6d7b-3563d67318e9@huawei.com>
Date:   Thu, 13 Apr 2023 19:42:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230413090353.14448-1-liangchen.linux@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/4/13 17:03, Liang Chen wrote:
> Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
> recycling") allowed coalescing to proceed with non page pool page and page
> pool page when @from is cloned, i.e.
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
> use-after-free or double-free errors. So it should be prohibited.
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
> 
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")

I am not quite sure the above is right Fixes tag.
As 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment recycling") has tried
to fix it, and it missed the case this patch is fixing, so we need another fix here.
