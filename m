Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF896A04A8
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbjBWJUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbjBWJUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:20:11 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6985B48E3F
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 01:20:10 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PMnW54H40zKpsm;
        Thu, 23 Feb 2023 17:18:09 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Thu, 23 Feb
 2023 17:19:44 +0800
Subject: Re: [PATCH v2 net] net: fix __dev_kfree_skb_any() vs drop monitor
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <eric.dumazet@gmail.com>
References: <20230223083845.1555914-1-edumazet@google.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <348a6ba6-9c0e-6c62-6750-7944961b0487@huawei.com>
Date:   Thu, 23 Feb 2023 17:19:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230223083845.1555914-1-edumazet@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/2/23 16:38, Eric Dumazet wrote:
> dev_kfree_skb() is aliased to consume_skb().
> 
> When a driver is dropping a packet by calling dev_kfree_skb_any()
> we should propagate the drop reason instead of pretending
> the packet was consumed.
> 
> Note: Now we have enum skb_drop_reason we could remove
> enum skb_free_reason (for linux-6.4)

LGTM.
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> 
> v2: added an unlikely(), suggested by Yunsheng Lin.
> 
> Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  net/core/dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 18dc8d75ead9795163ace74e8e86fe35cb9b7552..253584777101f2e6af3fc30107516f1e1197f8d3 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3134,8 +3134,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
>  {
>  	if (in_hardirq() || irqs_disabled())
>  		__dev_kfree_skb_irq(skb, reason);
> +	else if (unlikely(reason == SKB_REASON_DROPPED))
> +		kfree_skb(skb);
>  	else
> -		dev_kfree_skb(skb);
> +		consume_skb(skb);
>  }
>  EXPORT_SYMBOL(__dev_kfree_skb_any);
>  
> 
