Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AB848215F
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbhLaCA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:00:26 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60681 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229890AbhLaCAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 21:00:25 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0V0OEF90_1640916021;
Received: from 30.43.68.129(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0V0OEF90_1640916021)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 31 Dec 2021 10:00:22 +0800
Message-ID: <b94123d2-5a39-b635-4471-8962ba2a69fb@linux.alibaba.com>
Date:   Fri, 31 Dec 2021 10:00:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH -next] SUNRPC: Clean XPRT_CONGESTED of xprt->state when
 rpc task is killed
To:     Trond Myklebust <trondmy@hammerspace.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "pete.wl@alibaba-inc.com" <pete.wl@alibaba-inc.com>,
        "xiaoh.peixh@alibaba-inc.com" <xiaoh.peixh@alibaba-inc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "weipu.zy@alibaba-inc.com" <weipu.zy@alibaba-inc.com>,
        "wenan.mwa@alibaba-inc.com" <wenan.mwa@alibaba-inc.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>
References: <1639490018-128451-1-git-send-email-cuibixuan@linux.alibaba.com>
 <1639490018-128451-2-git-send-email-cuibixuan@linux.alibaba.com>
 <c5c17989-4c1e-35d2-5a75-a27e58cf6673@linux.alibaba.com>
 <c5d8fa4cfe87800afe588c4c3d54cd3178e04b47.camel@hammerspace.com>
 <efbf73f3-c6cd-90f6-ef22-bde14be708cc@linux.alibaba.com>
 <b8c236d99fd0f4e08dd0ee12a81274bd643a7690.camel@hammerspace.com>
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
In-Reply-To: <b8c236d99fd0f4e08dd0ee12a81274bd643a7690.camel@hammerspace.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/12/22 下午11:02, Trond Myklebust 写道:
> On Wed, 2021-12-22 at 10:55 +0800, Bixuan Cui wrote:
>> 在 2021/12/21 上午2:22, Trond Myklebust 写道:
>>   
>>> On Mon, 2021-12-20 at 11:39 +0800, Bixuan Cui wrote:
>>>   
>>>> ping~
>>>>
>>>> 在 2021/12/14 下午9:53, Bixuan Cui 写道:
>>>>   
>>>>> When the values of tcp_max_slot_table_entries and
>>>>> sunrpc.tcp_slot_table_entries are lower than the number of rpc
>>>>> tasks,
>>>>> xprt_dynamic_alloc_slot() in xprt_alloc_slot() will return -
>>>>> EAGAIN,
>>>>> and
>>>>> then set xprt->state to XPRT_CONGESTED:
>>>>>     xprt_retry_reserve
>>>>>       ->xprt_do_reserve
>>>>>         ->xprt_alloc_slot
>>>>>           ->xprt_dynamic_alloc_slot // return -EAGAIN and task-
>>>>>   
>>>>>> tk_rqstp is NULL
>>>>>             ->xprt_add_backlog // set_bit(XPRT_CONGESTED, &xprt-
>>>>>   
>>>>>> state);
>>>>> When rpc task is killed, XPRT_CONGESTED bit of xprt->state will
>>>>> not
>>>>> be
>>>>> cleaned up and nfs hangs:
>>>>>     rpc_exit_task
>>>>>       ->xprt_release // if (req == NULL) is true, then
>>>>> XPRT_CONGESTED
>>>>>                     // bit not clean
>>>>>
>>>>> Add xprt_wake_up_backlog(xprt) to clean XPRT_CONGESTED bit in
>>>>> xprt_release().
>>> I'm not seeing how this explanation makes sense. If the task
>>> doesn't
>>> hold a slot, then freeing that task isn't going to clear the
>>> congestion
>>> caused by all the slots being in use.
>> Hi，
>> If the rpc task is free, call xprt_release() :
>> void xprt_release(struct rpc_task *task)
>>   {
>>        if (req == NULL) {
>>                    if (task->tk_client) {
>>                            xprt = task->tk_xprt;
>>                            xprt_release_write(xprt, task); // 1.
>> release xprt
>>                    }
>>                    return;
>>            }
>>        ....
>>        if (likely(!bc_prealloc(req)))
>>                    xprt->ops->free_slot(xprt, req); // 2. release slot
>> and call xprt_wake_up_backlog(xprt, req) to wakeup next task(clear
>> XPRT_CONGESTED bit if next is NULL) in xprt_free_slot()
>>            else
>>                    xprt_free_bc_request(req);
>>   }
>>   I mean that in step 1, xprt was only released, but
>> xprt_wake_up_backlog was not called (I don’t know if it is necessary,
>> but xprt->state may still be XPRT_CONGESTED), which causes xprt to
>> hold up. I think it happens when the task that does not hold a slot
>> is the last released task，xprt_wake_up_backlog(clear XPRT_CONGESTED)
>> will not be executed. :-)
>> Thanks，
>> Bixuan Cui
>>
>>   
> My point is that in that case 1, there is no slot to free, so there is
> no change to the congestion state.
>
> IOW: your patch is incorrect because it is trying to assign a slot in a
> case where there is no slot to assign.
Hi，
I found the correct way to fix it, that is, do not free the request when 
there are tasks in the xprt->backlog :-)
And it has been fixed by e877a88d1f06 (SUNRPC in case of backlog, hand 
free slots directly to waiting task)
     commit e877a88d1f069edced4160792f42c2a8e2dba942
     Author: NeilBrown <neilb@suse.de>
     Date:   Mon May 17 09:59:10 2021 +1000

     SUNRPC in case of backlog, hand free slots directly to waiting task

     If sunrpc.tcp_max_slot_table_entries is small and there are tasks
     on the backlog queue, then when a request completes it is freed and the
     first task on the queue is woken.  The expectation is that it will wake
     and claim that request.  However if it was a sync task and the waiting
     process was killed at just that moment, it will wake and NOT claim the
     request.
Thanks for your advice.

Thanks,
Bixuan Cui

