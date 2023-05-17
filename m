Return-Path: <netdev+bounces-3254-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 43F2A7063DA
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79848280F31
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A9441095A;
	Wed, 17 May 2023 09:16:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1200AD2A;
	Wed, 17 May 2023 09:16:33 +0000 (UTC)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE7D10E6;
	Wed, 17 May 2023 02:16:30 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0Vis8QPm_1684314984;
Received: from 30.221.150.40(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Vis8QPm_1684314984)
          by smtp.aliyun-inc.com;
          Wed, 17 May 2023 17:16:25 +0800
Message-ID: <cba4cb83-4a6e-00b5-82ed-facb783f4707@linux.alibaba.com>
Date: Wed, 17 May 2023 17:16:22 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [PATCH bpf-next v1 2/5] net/smc: allow smc to negotiate protocols
 on policies
Content-Language: en-US
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
 kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, pabeni@redhat.com,
 song@kernel.org, sdf@google.com, haoluo@google.com, yhs@fb.com,
 edumazet@google.com, john.fastabend@gmail.com, kpsingh@kernel.org,
 jolsa@kernel.org, guwen@linux.alibaba.com
References: <1683872684-64872-1-git-send-email-alibuda@linux.alibaba.com>
 <1683872684-64872-3-git-send-email-alibuda@linux.alibaba.com>
 <0e1656dc-b67c-ec65-83a4-6709fb186061@linux.dev>
 <beed306a-9f5a-c05b-6f0a-ee28e17f8100@linux.alibaba.com>
 <b6b0a3ad-af30-371b-f46f-eb9524c7730d@linux.dev>
From: "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <b6b0a3ad-af30-371b-f46f-eb9524c7730d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/17/23 4:14 PM, Martin KaFai Lau wrote:
> On 5/17/23 12:08 AM, D. Wythe wrote:
>>
>>
>> On 5/16/23 6:52 AM, Martin KaFai Lau wrote:
>>> On 5/11/23 11:24 PM, D. Wythe wrote:
>>>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>>>
>>>> As we all know, the SMC protocol is not suitable for all scenarios,
>>>> especially for short-lived. However, for most applications, they 
>>>> cannot
>>>> guarantee that there are no such scenarios at all. Therefore, apps
>>>> may need some specific strategies to decide shall we need to use SMC
>>>> or not.
>>>>
>>>> Just like the congestion control implementation in TCP, this patch
>>>> provides a generic negotiator implementation. If necessary,
>>>> we can provide different protocol negotiation strategies for
>>>> apps based on this implementation.
>>>>
>>>> But most importantly, this patch provides the possibility of
>>>> eBPF injection, allowing users to implement their own protocol
>>>> negotiation policy in userspace.
>>>>
>>>> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>>>> ---
>>>>   include/net/smc.h        |  32 +++++++++++
>>>>   net/Makefile             |   1 +
>>>>   net/smc/Kconfig          |  11 ++++
>>>>   net/smc/af_smc.c         | 134 
>>>> ++++++++++++++++++++++++++++++++++++++++++++++-
>>>>   net/smc/smc_negotiator.c | 119 
>>>> +++++++++++++++++++++++++++++++++++++++++
>>>>   net/smc/smc_negotiator.h | 116 
>>>> ++++++++++++++++++++++++++++++++++++++++
>>>>   6 files changed, 412 insertions(+), 1 deletion(-)
>>>>   create mode 100644 net/smc/smc_negotiator.c
>>>>   create mode 100644 net/smc/smc_negotiator.h
>>>>
>>>> diff --git a/include/net/smc.h b/include/net/smc.h
>>>> index 6d076f5..191061c 100644
>>>> --- a/include/net/smc.h
>>>> +++ b/include/net/smc.h
>>>> @@ -296,6 +296,8 @@ struct smc_sock {                /* smc sock 
>>>> container */
>>>>       atomic_t                queued_smc_hs;  /* queued smc 
>>>> handshakes */
>>>>       struct inet_connection_sock_af_ops        af_ops;
>>>>       const struct inet_connection_sock_af_ops *ori_af_ops;
>>>> +    /* protocol negotiator ops */
>>>> +    const struct smc_sock_negotiator_ops *negotiator_ops;
>>>>                           /* original af ops */
>>>>       int            sockopt_defer_accept;
>>>>                           /* sockopt TCP_DEFER_ACCEPT
>>>> @@ -316,4 +318,34 @@ struct smc_sock {                /* smc sock 
>>>> container */
>>>>                            */
>>>>   };
>>>>   +#ifdef CONFIG_SMC_BPF
>>>> +/* BPF struct ops for smc protocol negotiator */
>>>> +struct smc_sock_negotiator_ops {
>>>> +
>>>> +    struct list_head    list;
>>>> +
>>>> +    /* ops name */
>>>> +    char        name[16];
>>>> +    /* key for name */
>>>> +    u32            key;
>>>> +
>>>> +    /* init with sk */
>>>> +    void (*init)(struct sock *sk);
>>>> +
>>>> +    /* release with sk */
>>>> +    void (*release)(struct sock *sk);
>>>> +
>>>> +    /* advice for negotiate */
>>>> +    int (*negotiate)(struct sock *sk);
>>>> +
>>>> +    /* info gathering timing */
>>>> +    void (*collect_info)(struct sock *sk, int timing);
>>>> +
>>>> +    /* module owner */
>>>> +    struct module *owner;
>>>> +};
>>>> +#else
>>>> +struct smc_sock_negotiator_ops {};
>>>> +#endif
>>>> +
>>>>   #endif    /* _SMC_H */
>>>> diff --git a/net/Makefile b/net/Makefile
>>>> index 4c4dc53..222916a 100644
>>>> --- a/net/Makefile
>>>> +++ b/net/Makefile
>>>> @@ -52,6 +52,7 @@ obj-$(CONFIG_TIPC)        += tipc/
>>>>   obj-$(CONFIG_NETLABEL)        += netlabel/
>>>>   obj-$(CONFIG_IUCV)        += iucv/
>>>>   obj-$(CONFIG_SMC)        += smc/
>>>> +obj-$(CONFIG_SMC_BPF)        += smc/smc_negotiator.o > 
>>>> obj-$(CONFIG_RFKILL)        += rfkill/
>>>>   obj-$(CONFIG_NET_9P)        += 9p/
>>>>   obj-$(CONFIG_CAIF)        += caif/
>>>> diff --git a/net/smc/Kconfig b/net/smc/Kconfig
>>>> index 1ab3c5a..bdcc9f1 100644
>>>> --- a/net/smc/Kconfig
>>>> +++ b/net/smc/Kconfig
>>>> @@ -19,3 +19,14 @@ config SMC_DIAG
>>>>         smcss.
>>>>           if unsure, say Y.
>>>> +
>>>> +config SMC_BPF
>>>> +    bool "SMC: support eBPF" if SMC
>>>
>>>
>>> so smc_negotiator will always be in the kernel image even af_smc is 
>>> compiled as a module? If the SMC_BPF needs to support af_smc as a 
>>> module, proper implementation needs to be added to bpf_struct_ops to 
>>> support module first. It is work-in-progress.
>>>
>>
>> smc_negotiator will not no in the kernel image when af_smc is 
>> compiled as a module,
>> it's requires config SMC_BPF also sets to be Y,  while it's default 
>> to be N. That's is,
>> even if af_smc is compiled as a module but with no SMC_BPF set, 
>> smc_negotiator
>> doesn't exist anywhere.
>
> CONFIG_SMC_BPF could be "y" while CONFIG_SMC is "m", no?
>
> Anyway, there is a build error when CONFIG_SMC is "m" :(
>

I am curious if users who proactively set CONFIG_SMC_BPF to Y would care 
about the issue you mentioned, while
CONFIG_SMC_BPF defaults to N ?

And I'm really sorry about this compilation error. Last time, I had got 
some comments about symbol export, so I tried to remove some symbol exports,
unfortunately, there are compilation issues when BPF_JIT is set 
(bpf_struct_ops_get is no exported), sorry for my incomplete
testing. I will fix this issue in the new version.

Anyway, if bpf_struct_ops can support module, that would be better, and 
can greatly reduce the trade-offs I make between modules and built-in.
Is there any details can shared on your progress ?

>>>> +    depends on BPF_SYSCALL
>>>> +    default n
>>>> +    help
>>>> +      Supports eBPF to allows user mode participation in SMC's 
>>>> protocol process
>>>> +      via ebpf programs. Alternatively, obtain information about 
>>>> the SMC socks
>>>> +      through the ebpf program.
>>>> +
>>>> +      If unsure, say N.
>>>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
>>>> index 50c38b6..7406fd4 100644
>>>> --- a/net/smc/af_smc.c
>>>> +++ b/net/smc/af_smc.c
>>>> @@ -52,6 +52,7 @@
>>>>   #include "smc_close.h"
>>>>   #include "smc_stats.h"
>>>>   #include "smc_tracepoint.h"
>>>> +#include "smc_negotiator.h"
>>>>   #include "smc_sysctl.h"
>>>>     static DEFINE_MUTEX(smc_server_lgr_pending);    /* serialize 
>>>> link group
>>>> @@ -68,6 +69,119 @@
>>>>   static void smc_tcp_listen_work(struct work_struct *);
>>>>   static void smc_connect_work(struct work_struct *);
>>>>   +#ifdef CONFIG_SMC_BPF
>>>> +
>>>> +/* Check if sock should use smc */
>>>> +int smc_sock_should_select_smc(const struct smc_sock *smc)
>>>> +{
>>>> +    const struct smc_sock_negotiator_ops *ops;
>>>> +    int ret;
>>>> +
>>>> +    rcu_read_lock();
>>>> +    ops = READ_ONCE(smc->negotiator_ops);
>>>> +
>>>> +    /* No negotiator_ops supply or no negotiate func set,
>>>> +     * always pass it.
>>>> +     */
>>>> +    if (!ops || !ops->negotiate) {
>>>
>>> A smc_sock_negotiator_ops without ->negotiate? Is it useful at all 
>>> to allow the register in the first place?
>>>
>>
>> You are right, this can be avoid before registration. I'll fix it.
>>
>>>> +        rcu_read_unlock();
>>>> +        return SK_PASS;
>>>> +    }
>>>> +
>>>> +    ret = ops->negotiate((struct sock *)&smc->sk);
>>>> +    rcu_read_unlock();
>>>> +    return ret;
>>>> +}
>>>> +
>>>> +void smc_sock_perform_collecting_info(const struct smc_sock *smc, 
>>>> int timing)
>>>> +{
>>>> +    const struct smc_sock_negotiator_ops *ops;
>>>> +
>>>> +    rcu_read_lock();
>>>> +    ops = READ_ONCE(smc->negotiator_ops);
>>>> +
>>>> +    if (!ops || !ops->collect_info) {
>>>> +        rcu_read_unlock();
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    ops->collect_info((struct sock *)&smc->sk, timing);
>>>> +    rcu_read_unlock();
>>>> +}
>>>> +
>>>> +int smc_sock_assign_negotiator_ops(struct smc_sock *smc, const 
>>>> char *name)
>>>> +{
>>>> +    struct smc_sock_negotiator_ops *ops;
>>>> +    int ret = -EINVAL;
>>>> +
>>>> +    /* already set */
>>>> +    if (READ_ONCE(smc->negotiator_ops))
>>>> +        smc_sock_cleanup_negotiator_ops(smc, /* might be still 
>>>> referenced */ false);
>>>> +
>>>> +    /* Just for clear negotiator_ops */
>>>> +    if (!name || !strlen(name))
>>>> +        return 0;
>>>> +
>>>> +    rcu_read_lock();
>>>> +    ops = smc_negotiator_ops_get_by_name(name);
>>>> +    if (likely(ops)) {
>>>> +        if (unlikely(!bpf_try_module_get(ops, ops->owner))) {
>>>> +            ret = -EACCES;
>>>> +        } else {
>>>> +            WRITE_ONCE(smc->negotiator_ops, ops);
>>>> +            /* make sure ops can be seen */
>>>> +            smp_wmb();
>>>
>>> This rcu_read_lock(), WRITE_ONCE, and smp_wmb() combo looks very 
>>> suspicious. smc->negotiator_ops is protected by rcu (+refcnt) or 
>>> lock_sock()?
>>>
>>
>> All access to ops is protected by RCU, and there are no lock_sock. 
>> WRITE_ONCE() and smp_wmb() do
>> not participate in any guarantee of the availability of ops, The 
>> purpose to using them is just wish the latest values
>> can be read as soon as possible , In fact, even if old value is read, 
>> there will be no problem in logic because all updates
>> will do synchronize_rcu() and all access to ops is under in 
>> rcu_read_lock().
>
> The explanation is not encouraging. No clear benefit while having this 
> kind of complexity here. Switching tcp congestion ops also does not 
> require this. Some of the new codes is in af_smc but bpf is the 
> primary user. It is not something that I would like to maintain and 
> then need to reason about this unusual pattern a year later. Beside, 
> this negotiator_ops assignment must be done under a lock_sock(). The 
> same probably is true for calling ops->negotiate() where the bpf prog 
> may be looking at the sk and calling bpf_setsockopt.

I got you point, If you feel that those code are complexity and 
unnecessary, I can remove them of course.

Additionally, smc_sock_assign_negotiator_ops is indeed executed under 
sock lock,  __smc_setsockopt will lock sock
for it. I misunderstood your meaning before.

As for ops ->negotiate(), thanks for this point, but considering 
performance,
I might prohibit calling setsockopt in negotiate().

>>
>>> I am going to stop reviewing here.
>>>
>>
>> Hoping my explanation can answer your questions and still looking 
>> forward to
>> your more feedback 😁.
>
> Sorry, based on the review so far (there was some RFC before), it is 
> not something that I want to continue to review and maintain a bpf 
> hook for it. You have to solicit other known community members for 
> review and sponsor this set from now on.

Okay, thank you very much for pointing out some issues and suggestions.

Thanks.

