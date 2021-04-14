Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF6C35F008
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 10:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbhDNIqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 04:46:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3942 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhDNIqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 04:46:21 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FKwx72PKhz5rWh
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 16:43:39 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML404-HUB.china.huawei.com (10.3.17.39) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Wed, 14 Apr 2021 16:45:55 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Wed, 14 Apr
 2021 16:45:55 +0800
Subject: Re: [PATCH net v2] net: core: make napi_disable more robust
To:     Lijun Pan <lijunp213@gmail.com>, <netdev@vger.kernel.org>
References: <20210414080845.11426-1-lijunp213@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c72fd322-5181-16d6-5992-0fd71a083c31@huawei.com>
Date:   Wed, 14 Apr 2021 16:45:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210414080845.11426-1-lijunp213@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/4/14 16:08, Lijun Pan wrote:
> There are chances that napi_disable can be called twice by NIC driver.
> This could generate deadlock. For example,
> the first napi_disable will spin until NAPI_STATE_SCHED is cleared
> by napi_complete_done, then set it again.
> When napi_disable is called the second time, it will loop infinitely
> because no dev->poll will be running to clear NAPI_STATE_SCHED.
> 
> Though it is driver writer's responsibility to make sure it being
> called only once, making napi_disable more robust does not hurt, not
> to say it can prevent a buggy driver from crashing a system.
> So, we check the napi state bit to make sure that if napi is already
> disabled, we exit the call early enough to avoid spinning infinitely.
> 
> Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> ---
> v2: justify that this patch makes napi_disable more robust.
> 
>  net/core/dev.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 1f79b9aa9a3f..fa0aa212b7bb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6830,6 +6830,24 @@ EXPORT_SYMBOL(netif_napi_add);
>  void napi_disable(struct napi_struct *n)
>  {
>  	might_sleep();
> +
> +	/* make sure napi_disable() runs only once,
> +	 * When napi is disabled, the state bits are like:
> +	 * NAPI_STATE_SCHED (set by previous napi_disable)
> +	 * NAPI_STATE_NPSVC (set by previous napi_disable)
> +	 * NAPI_STATE_DISABLE (cleared by previous napi_disable)
> +	 * NAPI_STATE_PREFER_BUSY_POLL (cleared by previous napi_complete_done)
> +	 * NAPI_STATE_MISSED (cleared by previous napi_complete_done)
> +	 */
> +
> +	if (napi_disable_pending(n))
> +		return;
> +	if (test_bit(NAPI_STATE_SCHED, &n->state) &&
> +	    test_bit(NAPI_STATE_NPSVC, &n->state) &&
> +	    !test_bit(NAPI_STATE_MISSED, &n->state) &&
> +	    !test_bit(NAPI_STATE_PREFER_BUSY_POLL, &n->state))
> +		return;

The NAPI_STATE_DISABLE is cleared at the end of napi_disable(),
and if a buggy driver/hw triggers a interrupt and driver calls
napi_schedule_irqoff(), which may set NAPI_STATE_MISSED
if NAPI_STATE_SCHED is set(in napi_schedule_prep()), the above
checking does not seem to handle it?

> +
>  	set_bit(NAPI_STATE_DISABLE, &n->state);
>  
>  	while (test_and_set_bit(NAPI_STATE_SCHED, &n->state))
> 

