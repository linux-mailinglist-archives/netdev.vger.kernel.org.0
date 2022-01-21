Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2EC495F6A
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380543AbiAUNHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 08:07:12 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:55858 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1380552AbiAUNG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 08:06:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V2RxFW-_1642770412;
Received: from 30.225.24.42(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V2RxFW-_1642770412)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 21 Jan 2022 21:06:52 +0800
Message-ID: <9282186a-95d0-22df-1ddf-3d36d7efa1c4@linux.alibaba.com>
Date:   Fri, 21 Jan 2022 21:06:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net v2] net/smc: Transitional solution for clcsock race
 issue
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1642768988-126174-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1642768988-126174-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2022/1/21 8:43 pm, Wen Gu wrote:
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
> Fixes: fd57770dd198 ("net/smc: wait for pending work before clcsock release_sock")
> Link: https://lore.kernel.org/lkml/5dd7ffd1-28e2-24cc-9442-1defec27375e@linux.ibm.com/T/
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
> ---

I seem to have missed this:

---
v2 -> v1:

Add 'Fixes:' tag and 'Link:' tag.
---


Looks like I need a script to check the details to avoid mistake...


Thanks,
Wen Gu

