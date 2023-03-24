Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63D66C767C
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 05:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjCXEJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 00:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjCXEJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 00:09:07 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EFE3C13;
        Thu, 23 Mar 2023 21:09:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VeWKYmk_1679630939;
Received: from 30.221.149.192(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VeWKYmk_1679630939)
          by smtp.aliyun-inc.com;
          Fri, 24 Mar 2023 12:09:00 +0800
Message-ID: <6b4728e0-dfb7-ec7b-630f-87ee42233fe8@linux.alibaba.com>
Date:   Fri, 24 Mar 2023 12:08:59 +0800
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
 <72030784-451a-2042-cbb7-98e1f9a544d5@linux.alibaba.com>
 <366b9486-9a00-6add-d54b-5c3f4d35afe9@linux.dev>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <366b9486-9a00-6add-d54b-5c3f4d35afe9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/23 4:46 AM, Martin KaFai Lau wrote:
> On 3/9/23 3:49 AM, D. Wythe wrote:
>>>> --- /dev/null
>>>> +++ b/net/smc/bpf_smc_struct_ops.c
>>>> @@ -0,0 +1,146 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/bpf_verifier.h>
>>>> +#include <linux/btf_ids.h>
>>>> +#include <linux/bpf.h>
>>>> +#include <linux/btf.h>
>>>> +#include <net/sock.h>
>>>> +#include <net/smc.h>
>>>> +
>>>> +extern struct bpf_struct_ops smc_sock_negotiator_ops;
>>>> +
>>>> +DEFINE_RWLOCK(smc_sock_negotiator_ops_rwlock);
>>>> +struct smc_sock_negotiator_ops *negotiator;
>>>
>>> Is it sure one global negotiator (policy) will work for all 
>>> smc_sock? or each sk should have its own negotiator and the 
>>> negotiator is selected by setsockopt.
>>>
>> This is really a good question,  we can really consider adding an 
>> independent negotiator for each sock.
>>
>> But just like the TCP congestion control , the global negotiator can 
>> be used for sock without
>>
>> special requirements.
>
> It is different from TCP congestion control (CC). TCP CC has a global 
> default but each sk can select what tcp-cc to use and there can be 
> multiple tcp-cc registered under different names.
>
> It sounds like smc using tcp_sock should be able to have different 
> negotiator also (eg. based on dst IP or some other tcp connection 
> characteristic). The tcp-cc registration, per-sock selection and the 
> rcu_read_lock+refcnt are well understood and there are other bpf 
> infrastructure to support the per sock tcp-cc selection (like 
> bpf_setsockopt).
>
> For the network stack, there is little reason other af_* should not 
> follow at the beginning considering the infrastructure has already 
> been built. The one single global negotiator and reader/writer lock in 
> this patch reads like an effort wanted to give it a try and see if it 
> will be useful before implementing the whole thing. It is better to 
> keep it off the tree for now until it is more ready.

Hi Martin,

Thank you very much for your comments. I have indeed removed global 
negotiator from my latest implementation.

The latest design is that users can register a negotiator implementation 
indexed by name, smc_sock can use bpf_setsockopt to specify
whether a specific negotiation implementation is required via name. If 
there are no settings, there will be no negotiators.

What do you think?

In addition, I am very sorry that I have not issued my implementation 
for such a long time, and I have encountered some problems with the 
implementation because
the SMC needs to be built as kernel module, I have struggled with the 
bpf_setsockopt implementation, and there are some new self-testes that 
need to be written.

However, I believe that I can send a new version as soon as possible.


Best wishes
D. Wythe





