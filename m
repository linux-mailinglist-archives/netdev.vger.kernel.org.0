Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7595495A45
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 08:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349008AbiAUHFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 02:05:06 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:50531 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233755AbiAUHFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 02:05:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V2Ps0xP_1642748702;
Received: from 30.225.24.42(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V2Ps0xP_1642748702)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 Jan 2022 15:05:03 +0800
Message-ID: <ad5c1c9b-5d9e-cd0f-88c7-4420bc9ed0e5@linux.alibaba.com>
Date:   Fri, 21 Jan 2022 15:05:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: Transitional solution for clcsock race issue
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1642086177-130611-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1642086177-130611-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/1/13 11:02 pm, Wen Gu wrote:
> We encountered a crash in smc_setsockopt() and it is caused by
> accessing smc->clcsock after clcsock was released.
> 
>   BUG: kernel NULL pointer dereference, address: 0000000000000020
>   #PF: supervisor read access in kernel mode
>   #PF: error_code(0x0000) - not-present page
>   PGD 0 P4D 0
>   Oops: 0000 [#1] PREEMPT SMP PTI
>   CPU: 1 PID: 50309 Comm: nginx Kdump: loaded Tainted: G E     5.16.0-rc4+ #53
>   RIP: 0010:smc_setsockopt+0x59/0x280 [smc]
>   Call Trace:
>    <TASK>
>    __sys_setsockopt+0xfc/0x190
>    __x64_sys_setsockopt+0x20/0x30
>    do_syscall_64+0x34/0x90
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>   RIP: 0033:0x7f16ba83918e
>    </TASK>
> 
> This patch tries to fix it by holding clcsock_release_lock and
> checking whether clcsock has already been released before access.
> 
> In case that a crash of the same reason happens in smc_getsockopt()
> or smc_switch_to_fallback(), this patch also checkes smc->clcsock
> in them too. And the caller of smc_switch_to_fallback() will identify
> whether fallback succeeds according to the return value.
> 
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>   net/smc/af_smc.c | 63 +++++++++++++++++++++++++++++++++++++++++++++-----------
>   1 file changed, 51 insertions(+), 12 deletions(-)
> 

Sorry for bothering, just wonder if this patch needs further improvements?

The previous discussion can be found in:
https://lore.kernel.org/lkml/5dd7ffd1-28e2-24cc-9442-1defec27375e@linux.ibm.com/T/

I sent this patch with a new subject instead of sending a v2 of the previously
discussed patch because I think the original subject seems not appropriate anymore
after introducing check of clcsock in smc_switch_to_fallback().

Thanks,
Wen Gu

