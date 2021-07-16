Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44263CB1C3
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 07:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbhGPFGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 01:06:22 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:11324 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhGPFGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 01:06:22 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GQzXs6yJcz7tbH;
        Fri, 16 Jul 2021 12:58:53 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 13:03:24 +0800
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 13:03:23 +0800
Subject: Re: [PATCH] once: Fix panic when module unload
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Minmin chen <chenmingmin@huawei.com>
References: <20210622022138.23048-1-wangkefeng.wang@huawei.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <e0f1b9c7-622f-4269-634e-20cc61e26b70@huawei.com>
Date:   Fri, 16 Jul 2021 13:03:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20210622022138.23048-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all, kindly ping...

On 2021/6/22 10:21, Kefeng Wang wrote:
> DO_ONCE
> DEFINE_STATIC_KEY_TRUE(___once_key);
> __do_once_done
>    once_disable_jump(once_key);
>      INIT_WORK(&w->work, once_deferred);
>      struct once_work *w;
>      w->key = key;
>      schedule_work(&w->work);                     module unload
>                                                     //*the key is destroy*
> process_one_work
>    once_deferred
>      BUG_ON(!static_key_enabled(work->key));
>         static_key_count((struct static_key *)x)    //*access key, crash*
>
> When module uses DO_ONCE mechanism, it could crash due to the above
> concurrency problem, we could reproduce it with link[1].
>
> Fix it by add/put module refcount in the once work process.
>
> [1]
> https://lore.kernel.org/netdev/eaa6c371-465e-57eb-6be9-f4b16b9d7cbf@huawei.com/
>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Reported-by: Minmin chen <chenmingmin@huawei.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   lib/once.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/lib/once.c b/lib/once.c
> index 8b7d6235217e..959f8db41ccf 100644
> --- a/lib/once.c
> +++ b/lib/once.c
> @@ -3,10 +3,12 @@
>   #include <linux/spinlock.h>
>   #include <linux/once.h>
>   #include <linux/random.h>
> +#include <linux/module.h>
>   
>   struct once_work {
>   	struct work_struct work;
>   	struct static_key_true *key;
> +	struct module *module;
>   };
>   
>   static void once_deferred(struct work_struct *w)
> @@ -16,11 +18,24 @@ static void once_deferred(struct work_struct *w)
>   	work = container_of(w, struct once_work, work);
>   	BUG_ON(!static_key_enabled(work->key));
>   	static_branch_disable(work->key);
> +	module_put(work->module);
>   	kfree(work);
>   }
>   
> +static struct module *find_module_by_key(struct static_key_true *key)
> +{
> +	struct module *mod;
> +
> +	preempt_disable();
> +	mod = __module_address((unsigned long)key);
> +	preempt_enable();
> +
> +	return mod;
> +}
> +
>   static void once_disable_jump(struct static_key_true *key)
>   {
> +	struct module *mod = find_module_by_key(key);
>   	struct once_work *w;
>   
>   	w = kmalloc(sizeof(*w), GFP_ATOMIC);
> @@ -29,6 +44,8 @@ static void once_disable_jump(struct static_key_true *key)
>   
>   	INIT_WORK(&w->work, once_deferred);
>   	w->key = key;
> +	w->module = mod;
> +	__module_get(mod);
>   	schedule_work(&w->work);
>   }
>   
