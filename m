Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834866B2366
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjCILtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbjCILtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:49:12 -0500
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF58E6828;
        Thu,  9 Mar 2023 03:49:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VdTRNaY_1678362543;
Received: from 30.221.149.231(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VdTRNaY_1678362543)
          by smtp.aliyun-inc.com;
          Thu, 09 Mar 2023 19:49:04 +0800
Message-ID: <72030784-451a-2042-cbb7-98e1f9a544d5@linux.alibaba.com>
Date:   Thu, 9 Mar 2023 19:49:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v2 1/2] net/smc: Introduce BPF injection
 capability for SMC
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, kgraul@linux.ibm.com, wenjia@linux.ibm.com,
        jaka@linux.ibm.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
References: <1676981919-64884-1-git-send-email-alibuda@linux.alibaba.com>
 <1676981919-64884-2-git-send-email-alibuda@linux.alibaba.com>
 <76e226e6-f3bf-f740-c86c-6ee214aff07d@linux.dev>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <76e226e6-f3bf-f740-c86c-6ee214aff07d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/23/23 5:40 AM, Martin KaFai Lau wrote:
> On 2/21/23 4:18 AM, D. Wythe wrote:
>> From: "D. Wythe" <alibuda@linux.alibaba.com>
>>
>> This PATCH attempts to introduce BPF injection capability for SMC.
>> As we all know that the SMC protocol is not suitable for all scenarios,
>> especially for short-lived. However, for most applications, they cannot
>> guarantee that there are no such scenarios at all. Therefore, apps
>> may need some specific strategies to decide shall we need to use SMC
>> or not, for example, apps can limit the scope of the SMC to a specific
>> IP address or port.
>>
>> Based on the consideration of transparent replacement, we hope that apps
>> can remain transparent even if they need to formulate some specific
>> strategies for SMC using. That is, do not need to recompile their code.
>>
>> On the other hand, we need to ensure the scalability of strategies
>> implementation. Although it is simple to use socket options or sysctl,
>> it will bring more complexity to subsequent expansion.
>>
>> Fortunately, BPF can solve these concerns very well, users can write
>> thire own strategies in eBPF to choose whether to use SMC or not.
>> And it's quite easy for them to modify their strategies in the future.
>>
>> This PATCH implement injection capability for SMC via struct_ops.
>> In that way, we can add new injection scenarios in the future.
>
> I have never used smc. I can only comment at its high level usage and 
> details on the bpf side.


Hi Martin,

Thank you very much for your comments and I'm very sorry for my mistakes.

>
>>
>> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
>> ---
>>   include/linux/btf_ids.h           |  15 +++
>>   include/net/smc.h                 | 254 
>> ++++++++++++++++++++++++++++++++++++++
>>   kernel/bpf/bpf_struct_ops_types.h |   4 +
>>   net/Makefile                      |   5 +
>>   net/smc/af_smc.c                  |  10 +-
>>   net/smc/bpf_smc_struct_ops.c      | 146 ++++++++++++++++++++++
>>   net/smc/smc.h                     | 220 
>> ---------------------------------
>>   7 files changed, 433 insertions(+), 221 deletions(-)
>>   create mode 100644 net/smc/bpf_smc_struct_ops.c
>>
>> diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
>> index 3a4f7cd..25eab1e 100644
>> --- a/include/linux/btf_ids.h
>> +++ b/include/linux/btf_ids.h
>> @@ -264,6 +264,21 @@ enum {
>>   MAX_BTF_TRACING_TYPE,
>>   };
>>   +#if IS_ENABLED(CONFIG_SMC)
>> +#define BTF_SMC_TYPE_xxx        \
>> +    BTF_SMC_TYPE(BTF_SMC_TYPE_SOCK, smc_sock)        \
>> +    BTF_SMC_TYPE(BTF_SMC_TYPE_CONNECTION, smc_connection)    \
>> +    BTF_SMC_TYPE(BTF_SMC_TYPE_HOST_CURSOR, smc_host_cursor)
>> +
>> +enum {
>> +#define BTF_SMC_TYPE(name, type) name,
>> +BTF_SMC_TYPE_xxx
>> +#undef BTF_SMC_TYPE
>> +MAX_BTF_SMC_TYPE,
>> +};
>> +extern u32 btf_smc_ids[];
>
> Do all these need to be in btf_ids.h?

My original intention is to do some security checks via btf_smc_ids,

but since it is not implemented at present, so it is not necessary here.

>
>> +#endif
>> +
>>   extern u32 btf_tracing_ids[];
>>   extern u32 bpf_cgroup_btf_id[];
>>   extern u32 bpf_local_storage_map_btf_id[];
>> diff --git a/include/net/smc.h b/include/net/smc.h
>> index 597cb93..912c269 100644
>> --- a/include/net/smc.h
>> +++ b/include/net/smc.h
>
> It is not obvious to me why the header moving is needed (from 
> net/smc/smc.h to include/net/smc.h ?). This can use some comment in 
> the commit message and please break it out to another patch.

Got it, , I have finished the splitting.

>
> [ ... ]
>
>> --- a/net/Makefile
>> +++ b/net/Makefile
>> @@ -52,6 +52,11 @@ obj-$(CONFIG_TIPC)        += tipc/
>>   obj-$(CONFIG_NETLABEL)        += netlabel/
>>   obj-$(CONFIG_IUCV)        += iucv/
>>   obj-$(CONFIG_SMC)        += smc/
>> +ifneq ($(CONFIG_SMC),)
>> +ifeq ($(CONFIG_BPF_SYSCALL),y)
>> +obj-y                += smc/bpf_smc_struct_ops.o
>
> This will ensure bpf_smc_struct_ops.c compiled as builtin even when 
> smc is compiled as module?

Yes,  smc allow compiled as module.

We are also struggling here. If you have a better way, please let me 
know. 😁

>
>> diff --git a/net/smc/bpf_smc_struct_ops.c b/net/smc/bpf_smc_struct_ops.c
>> new file mode 100644
>> index 0000000..a5989b6
>> --- /dev/null
>> +++ b/net/smc/bpf_smc_struct_ops.c
>> @@ -0,0 +1,146 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/bpf_verifier.h>
>> +#include <linux/btf_ids.h>
>> +#include <linux/bpf.h>
>> +#include <linux/btf.h>
>> +#include <net/sock.h>
>> +#include <net/smc.h>
>> +
>> +extern struct bpf_struct_ops smc_sock_negotiator_ops;
>> +
>> +DEFINE_RWLOCK(smc_sock_negotiator_ops_rwlock);
>> +struct smc_sock_negotiator_ops *negotiator;
>
> Is it sure one global negotiator (policy) will work for all smc_sock? 
> or each sk should have its own negotiator and the negotiator is 
> selected by setsockopt.
>
This is really a good question,  we can really consider adding an 
independent negotiator for each sock.

But just like the TCP congestion control , the global negotiator can be 
used for sock without

special requirements.


>> +
>> +/* convert sk to smc_sock */
>> +static inline struct smc_sock *smc_sk(const struct sock *sk)
>> +{
>> +    return (struct smc_sock *)sk;
>> +}
>> +
>> +/* register ops */
>> +static inline void smc_reg_passive_sk_ops(struct 
>> smc_sock_negotiator_ops *ops)
>> +{
>> +    write_lock_bh(&smc_sock_negotiator_ops_rwlock);
>> +    negotiator = ops;
>
> What happens to the existing negotiator?

What if we return a failure when the negotiator already exists ?

>
>> + write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
>> +}
>> +
>> +/* unregister ops */
>> +static inline void smc_unreg_passive_sk_ops(struct 
>> smc_sock_negotiator_ops *ops)
>> +{
>> +    write_lock_bh(&smc_sock_negotiator_ops_rwlock);
>> +    if (negotiator == ops)
>> +        negotiator = NULL;
>> +    write_unlock_bh(&smc_sock_negotiator_ops_rwlock);
>> +}
>> +
>> +int smc_sock_should_select_smc(const struct smc_sock *smc)
>> +{
>> +    int ret = SK_PASS;
>> +
>> +    read_lock_bh(&smc_sock_negotiator_ops_rwlock);
>> +    if (negotiator && negotiator->negotiate)
>> +        ret = negotiator->negotiate((struct smc_sock *)smc);
>> +    read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
>> +    return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(smc_sock_should_select_smc);
>> +
>> +void smc_sock_perform_collecting_info(const struct smc_sock *smc, 
>> int timing)
>> +{
>> +    read_lock_bh(&smc_sock_negotiator_ops_rwlock);
>> +    if (negotiator && negotiator->collect_info)
>> +        negotiator->collect_info((struct smc_sock *)smc, timing);
>> +    read_unlock_bh(&smc_sock_negotiator_ops_rwlock);
>> +}
>> +EXPORT_SYMBOL_GPL(smc_sock_perform_collecting_info);
>> +
>> +/* define global smc ID for smc_struct_ops */
>> +BTF_ID_LIST_GLOBAL(btf_smc_ids, MAX_BTF_SMC_TYPE)
>
> How is btf_smc_ids used?

Yes, it is useless here for the time being. I will remove them in the 
new version.

>
>> +#define BTF_SMC_TYPE(name, type) BTF_ID(struct, type)
>> +BTF_SMC_TYPE_xxx
>> +#undef BTF_SMC_TYPE
>> +
>
