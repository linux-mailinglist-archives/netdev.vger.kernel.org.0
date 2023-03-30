Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D30F6CFBDF
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjC3Grf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjC3Grd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:47:33 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDA961AE
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:47:31 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PnDVW5y7WzKq3d;
        Thu, 30 Mar 2023 14:46:59 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 30 Mar
 2023 14:47:29 +0800
Subject: Re: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid
 extra NET_RX_SOFTIRQ
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>
References: <20230328235021.1048163-1-edumazet@google.com>
 <20230328235021.1048163-5-edumazet@google.com>
 <fa860d02-0310-2666-1043-6909dc68ea01@huawei.com>
 <CANn89iLmugenUSDAQT9ryHTG9tRuKUfYgc8OqPMQwVv-1-ajNg@mail.gmail.com>
 <8610abc4-65c6-6808-e5d4-c2da8083595a@huawei.com>
 <CANn89iJCYSA_LmpTRXz3rWRgYYHgiGsia_utwTxZa03ct7hfiQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <670bbde5-9d39-092d-bb3b-aab2be56853c@huawei.com>
Date:   Thu, 30 Mar 2023 14:47:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CANn89iJCYSA_LmpTRXz3rWRgYYHgiGsia_utwTxZa03ct7hfiQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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

On 2023/3/30 10:57, Eric Dumazet wrote:
> On Thu, Mar 30, 2023 at 4:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>
>> On 2023/3/29 23:47, Eric Dumazet wrote:
>>> On Wed, Mar 29, 2023 at 2:47 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>>
>>>> On 2023/3/29 7:50, Eric Dumazet wrote:
>>>>> ____napi_schedule() adds a napi into current cpu softnet_data poll_list,
>>>>> then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process it.
>>>>>
>>>>> Idea of this patch is to not raise NET_RX_SOFTIRQ when being called indirectly
>>>>> from net_rx_action(), because we can process poll_list from this point,
>>>>> without going to full softirq loop.
>>>>>
>>>>> This needs a change in net_rx_action() to make sure we restart
>>>>> its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
>>>>> being raised.
>>>>>
>>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>>> Cc: Jason Xing <kernelxing@tencent.com>
>>>>> ---
>>>>>  net/core/dev.c | 22 ++++++++++++++++++----
>>>>>  1 file changed, 18 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>>>> index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036fb05842dab023f65dc3 100644
>>>>> --- a/net/core/dev.c
>>>>> +++ b/net/core/dev.c
>>>>> @@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct softnet_data *sd,
>>>>>       }
>>>>>
>>>>>       list_add_tail(&napi->poll_list, &sd->poll_list);
>>>>> -     __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>>>>> +     /* If not called from net_rx_action()
>>>>> +      * we have to raise NET_RX_SOFTIRQ.
>>>>> +      */
>>>>> +     if (!sd->in_net_rx_action)
>>>>
>>>> It seems sd->in_net_rx_action may be read/writen by different CPUs at the same
>>>> time, does it need something like READ_ONCE()/WRITE_ONCE() to access
>>>> sd->in_net_rx_action?
>>>
>>> You probably missed the 2nd patch, explaining the in_net_rx_action is
>>> only read and written by the current (owning the percpu var) cpu.
>>>
>>> Have you found a caller that is not providing to ____napi_schedule( sd
>>> = this_cpu_ptr(&softnet_data)) ?
>>
>> You are right.
>>
>> The one small problem I see is that ____napi_schedule() call by a irq handle
>> may preempt the running net_rx_action() in the current cpu, I am not sure if
>> it worth handling, given that it is expected that the irq should be disabled
>> when net_rx_action() is running?
> 
> And what will happen ? If the interrupts comes before
> 
> in_net_rx_action = val;
> 
> The interrupt handler will see the old value, this is fine really in all points.
> 
> If it comes after the assignment, the interrupt handler will see the new value,
> because a cpu can not reorder its own reads/writes.
> 
> Otherwise simple things like this would fail:
> 
> a = 2;
> b = a ;
> assert (b == 2) ;
> 
> 
> 1) Note that the local_irq_disable(); after the first
> 
> sd->in_net_rx_action = true;
> 
> in net_rx_action() already provides a strong barrier.
> 
> 2) sd->in_net_rx_action = false before the barrier() is enough to
> provide needed safety for _this_ cpu.
> 
> 3) Final sd->in_net_rx_action = false; at the end of net_rx_action()
> is performed while hard irq are masked.
> 
> 
> 
> 
>> Do we need to protect against buggy hw or unbehaved driver?
> 
> If you think there is an issue please elaborate with the exact call
> site/ interruption point, because I do not see any.

I was thinking if load/store tearing and out of out-of-order execution
would make something go wrong here.

For load/store tearing, in_net_rx_action in 'struct softnet_data' is a
bool, so I think it should be ok here, it would be better to make it
clear by using READ_ONCE()/WRITE_ONCE()?
LWN article about load/store tearing:
https://lwn.net/Articles/793253/

For out-of-order execution, I am not sure if it is really a problem
for irq preempting softirq in the same CPU yet, for example, for the below code,
if list_empty(&sd->poll_list) checking is executed out-of-order with
"sd->in_net_rx_action = false", and the irq which calls ____napi_schedule()
preempt between list_empty(&sd->poll_list) checking and "sd->in_net_rx_action = false",
then ____napi_schedule() will not raise softirq as sd->in_net_rx_action is
still true, after irq finishs, as list_empty(&sd->poll_list) is already
checked, it may not goto 'start' in net_rx_action().


+				sd->in_net_rx_action = false;
+				barrier();
+				/* We need to check if ____napi_schedule()
+				 * had refilled poll_list while
+				 * sd->in_net_rx_action was true.
+				 */
+				if (!list_empty(&sd->poll_list))



> 
> 
>>
>>>
>>>
>>>
>>>>
>>>>> +             __raise_softirq_irqoff(NET_RX_SOFTIRQ);
>>>>>  }
>>>>>
>>>>>  #ifdef CONFIG_RPS
>>>>> @@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>>>>>       LIST_HEAD(list);
>>>>>       LIST_HEAD(repoll);
>>>>>
>>>>> +start:
>>>>>       sd->in_net_rx_action = true;
>>>>>       local_irq_disable();
>>>>>       list_splice_init(&sd->poll_list, &list);
>>>>> @@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>>>>>               skb_defer_free_flush(sd);
>>>>>
>>>>>               if (list_empty(&list)) {
>>>>> -                     sd->in_net_rx_action = false;
>>>>> -                     if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
>>>>> -                             goto end;
>>>>> +                     if (list_empty(&repoll)) {
>>>>> +                             sd->in_net_rx_action = false;
>>>>> +                             barrier();
>>>>
>>>> Do we need a stronger barrier to prevent out-of-order execution
>>>> from cpu?
>>>
>>> We do not need more than barrier() to make sure local cpu wont move this
>>> write after the following code.
>>
>> Is there any reason why we need the barrier() if we are not depending
>> on how list_empty() is coded?
>> It seems not obvious to me at least:)
>>
>>>
>>> It should not, even without the barrier(), because of the way
>>> list_empty() is coded,
>>> but a barrier() makes things a bit more explicit.
>>
>> In that case, a comment explaining that may help a lot.
>>
>> Thanks.
>>
>>>
>>>> Do we need a barrier between list_add_tail() and sd->in_net_rx_action
>>>> checking in ____napi_schedule() to pair with the above barrier?
>>>
>>> I do not think so.
>>>
>>> While in ____napi_schedule(), sd->in_net_rx_action is stable
>>> because we run with hardware IRQ masked.
>>>
>>> Thanks.
>>>
>>>
>>>
> .
> 
