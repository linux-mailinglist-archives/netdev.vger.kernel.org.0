Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868BF6C5D06
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjCWDF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjCWDF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:05:57 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4E9DF
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:05:54 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Phqvs73MVz9w5c;
        Thu, 23 Mar 2023 11:05:13 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 23 Mar
 2023 11:05:36 +0800
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <willemb@google.com>,
        <alexander.duyck@gmail.com>
References: <20230322233028.269410-1-kuba@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <e66b0ae0-8c26-927f-2342-a7a4383068a3@huawei.com>
Date:   Thu, 23 Mar 2023 11:05:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230322233028.269410-1-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/23 7:30, Jakub Kicinski wrote:
> A lot of drivers follow the same scheme to stop / start queues
> without introducing locks between xmit and NAPI tx completions.
> I'm guessing they all copy'n'paste each other's code.
> 
> Smaller drivers shy away from the scheme and introduce a lock
> which may cause deadlocks in netpoll.
> 
> Provide macros which encapsulate the necessary logic.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> rfc: https://lore.kernel.org/all/20230311050130.115138-1-kuba@kernel.org/
>  - perdicate -> predicate
>  - on race use start instead of wake and make a note of that
>    in the doc / comment at the start
> ---
>  include/net/netdev_queues.h | 171 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 171 insertions(+)
>  create mode 100644 include/net/netdev_queues.h
> 
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> new file mode 100644
> index 000000000000..64e059647274
> --- /dev/null
> +++ b/include/net/netdev_queues.h
> @@ -0,0 +1,171 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_NET_QUEUES_H
> +#define _LINUX_NET_QUEUES_H
> +
> +#include <linux/netdevice.h>
> +
> +/* Lockless queue stopping / waking helpers.
> + *
> + * These macros are designed to safely implement stopping and waking
> + * netdev queues without full lock protection. We assume that there can
> + * be no concurrent stop attempts and no concurrent wake attempts.
> + * The try-stop should happen from the xmit handler*, while wake up

unnecessary '*' after handler?

> + * should be triggered from NAPI poll context. The two may run
> + * concurrently (single producer, single consumer).
> + *
> + * All descriptor ring indexes (and other relevant shared state) must
> + * be updated before invoking the macros.
> + *
> + * * the try-stop side does not reschedule Tx (netif_tx_start_queue()

double '*' here?

> + *   instead of netif_tx_wake_queue()) so uses outside of the xmit
> + *   handler may lead to bugs
> + */
> +
> +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
> +	({								\
> +		int _res;						\
> +									\
> +		netif_tx_stop_queue(txq);				\
> +									\
> +		smp_mb();						\
> +									\
> +		/* We need to check again in a case another		\
> +		 * CPU has just made room available.			\
> +		 */							\
> +		if (likely(get_desc < start_thrs)) {			\
> +			_res = 0;					\
> +		} else {						\
> +			netif_tx_start_queue(txq);			\
> +			_res = -1;					\
> +		}							\
> +		_res;							\
> +	})								\
> +
> +/**
> + * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if needed
> + * @txq:	struct netdev_queue to stop/start
> + * @get_desc:	get current number of free descriptors (see requirements below!)
> + * @stop_thrs:	minimal number of available descriptors for queue to be left
> + *		enabled
> + * @start_thrs:	minimal number of descriptors to re-enable the queue, can be
> + *		equal to @stop_thrs or higher to avoid frequent waking
> + *
> + * All arguments may be evaluated multiple times, beware of side effects.
> + * @get_desc must be a formula or a function call, it must always
> + * return up-to-date information when evaluated!
> + * Expected to be used from ndo_start_xmit, see the comment on top of the file.

For now，there seems to be three ways of calling *_maybe_stop():
1. called before transimting a skb.
2. called after transimting a skb.
3. called both before and after transimting a skb.

Which one should new driver follow?
Do we need to make it clear here?
