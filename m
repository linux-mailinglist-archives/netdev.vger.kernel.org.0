Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E474104AA
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbhIRHU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 03:20:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9893 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhIRHU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 03:20:27 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HBMWr6xPNz8yXN;
        Sat, 18 Sep 2021 15:14:32 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 18 Sep 2021 15:19:01 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Sat, 18 Sep
 2021 15:19:01 +0800
Subject: Re: [PATCH net] napi: fix race inside napi_enable
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        "Wei Wang" <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        <dust.li@linux.alibaba.com>
References: <20210918064822.58208-1-xuanzhuo@linux.alibaba.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <d9c86150-94e7-b812-5b23-56a2c5cbeeb6@huawei.com>
Date:   Sat, 18 Sep 2021 15:19:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210918064822.58208-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/9/18 14:48, Xuan Zhuo wrote:
> The process will cause napi.state to contain NAPI_STATE_SCHED and
> not in the poll_list, which will cause napi_disable() to get stuck.
> 
> The prefix "NAPI_STATE_" is removed in the figure below, and
> NAPI_STATE_HASHED is ignored in napi.state.
> 
>                       CPU0       |                   CPU1       | napi.state
> ===============================================================================
> napi_disable()                   |                              | SCHED | NPSVC
> napi_enable()                    |                              |
> {                                |                              |
>     smp_mb__before_atomic();     |                              |
>     clear_bit(SCHED, &n->state); |                              | NPSVC
>                                  | napi_schedule_prep()         | SCHED | NPSVC
>                                  | napi_poll()                  |
>                                  |   napi_complete_done()       |
>                                  |   {                          |
>                                  |      if (n->state & (NPSVC | | (1)
>                                  |               _BUSY_POLL)))  |
>                                  |           return false;      |
>                                  |     ................         |
>                                  |   }                          | SCHED | NPSVC
>                                  |                              |
>     clear_bit(NPSVC, &n->state); |                              | SCHED
> }                                |                              |
>                                  |                              |
> napi_schedule_prep()             |                              | SCHED | MISSED (2)
> 
> (1) Here return direct. Because of NAPI_STATE_NPSVC exists.
> (2) NAPI_STATE_SCHED exists. So not add napi.poll_list to sd->poll_list
> 
> Since NAPI_STATE_SCHED already exists and napi is not in the
> sd->poll_list queue, NAPI_STATE_SCHED cannot be cleared and will always
> exist.
> 
> 1. This will cause this queue to no longer receive packets.
> 2. If you encounter napi_disable under the protection of rtnl_lock, it
>    will cause the entire rtnl_lock to be locked, affecting the overall
>    system.
> 
> This patch uses cmpxchg to implement napi_enable(), which ensures that
> there will be no race due to the separation of clear two bits.
> 

a Fixes tag is needed here.

> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>  net/core/dev.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 74fd402d26dd..3457ae964b8c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6923,12 +6923,19 @@ EXPORT_SYMBOL(napi_disable);
>   */
>  void napi_enable(struct napi_struct *n)
>  {
> +	unsigned long val, new;
> +
>  	BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));
> -	smp_mb__before_atomic();
> -	clear_bit(NAPI_STATE_SCHED, &n->state);
> -	clear_bit(NAPI_STATE_NPSVC, &n->state);
> -	if (n->dev->threaded && n->thread)
> -		set_bit(NAPI_STATE_THREADED, &n->state);
> +
> +	do {
> +		val = READ_ONCE(n->state);

It seems we might need to move the above BUG_ON here to preserve
the orginial BUG_ON behavior?

> +
> +		new = val & ~(NAPIF_STATE_SCHED | NAPIF_STATE_NPSVC);
> +
> +		if (n->dev->threaded && n->thread)
> +			new |= NAPIF_STATE_THREADED;
> +
> +	} while (cmpxchg(&n->state, val, new) != val);
>  }
>  EXPORT_SYMBOL(napi_enable);
>  
> 
