Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E053689FA
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 02:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbhDWAnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 20:43:25 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3952 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhDWAnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 20:43:24 -0400
Received: from dggeml406-hub.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FRFnL0nyVz5swD;
        Fri, 23 Apr 2021 08:40:22 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggeml406-hub.china.huawei.com (10.3.17.50) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Fri, 23 Apr 2021 08:42:45 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 23 Apr
 2021 08:42:45 +0800
Subject: Re: [PATCH net-next 3/3] net: update netdev_rx_csum_fault() print
 dump only once
To:     Tanner Love <tannerlove.kernel@gmail.com>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, Tanner Love <tannerlove@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
References: <20210422194738.2175542-1-tannerlove.kernel@gmail.com>
 <20210422194738.2175542-4-tannerlove.kernel@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ab70ee56-5188-6bcc-819e-8d022552ed81@huawei.com>
Date:   Fri, 23 Apr 2021 08:42:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210422194738.2175542-4-tannerlove.kernel@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/23 3:47, Tanner Love wrote:
> From: Tanner Love <tannerlove@google.com>
> 
> Printing this stack dump multiple times does not provide additional
> useful information, and consumes time in the data path. Printing once
> is sufficient.
> 
> Signed-off-by: Tanner Love <tannerlove@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Mahesh Bandewar <maheshb@google.com>
> ---
>  net/core/dev.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index d9bf63dbe4fd..26b82b5d8563 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -148,6 +148,7 @@
>  #include <net/devlink.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/prandom.h>
> +#include <linux/once.h>
>  
>  #include "net-sysfs.h"
>  
> @@ -3487,13 +3488,16 @@ EXPORT_SYMBOL(__skb_gso_segment);
>  
>  /* Take action when hardware reception checksum errors are detected. */
>  #ifdef CONFIG_BUG
> -void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
> +static void do_netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
>  {
> -	if (net_ratelimit()) {
>  		pr_err("%s: hw csum failure\n", dev ? dev->name : "<unknown>");
>  		skb_dump(KERN_ERR, skb, true);
>  		dump_stack();

Once the "if ()" is removed, one level of indent seems enough?

> -	}
> +}
> +
> +void netdev_rx_csum_fault(struct net_device *dev, struct sk_buff *skb)
> +{
> +	DO_ONCE_LITE(do_netdev_rx_csum_fault, dev, skb);
>  }
>  EXPORT_SYMBOL(netdev_rx_csum_fault);
>  #endif
> 

