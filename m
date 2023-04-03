Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FFA6D3ED7
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 10:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbjDCIVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 04:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbjDCIVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 04:21:32 -0400
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2897CEC6E;
        Mon,  3 Apr 2023 01:21:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0VfFpMZ3_1680510077;
Received: from 30.221.149.127(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VfFpMZ3_1680510077)
          by smtp.aliyun-inc.com;
          Mon, 03 Apr 2023 16:21:18 +0800
Message-ID: <ee61468e-8eb3-3949-1a82-0eb2e0b6a279@linux.alibaba.com>
Date:   Mon, 3 Apr 2023 16:21:16 +0800
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
 <6b4728e0-dfb7-ec7b-630f-87ee42233fe8@linux.alibaba.com>
 <fe3db636-2f89-3175-a605-2124b43ae4fa@linux.dev>
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <fe3db636-2f89-3175-a605-2124b43ae4fa@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.4 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Martin,

Sorry to have been responding so late,  I've been working on the 
link_update you mentioned in last week,
I have completed the support and testing of the related functions of it. 
and it is expected to be released in the
next few days.

As you mentioned, I do have much experience in kernel network 
development, so I plan to resend the PATCH in the form of RFC.
I really hope to receive your suggestions in next serials. Thank you.😉

Best wishes.
D. Wythe


On 3/25/23 7:27 AM, Martin KaFai Lau wrote:
> On 3/23/23 9:08 PM, D. Wythe wrote:
>>
>> The latest design is that users can register a negotiator 
>> implementation indexed by name, smc_sock can use bpf_setsockopt to 
>> specify
>> whether a specific negotiation implementation is required via name. 
>> If there are no settings, there will be no negotiators.
>>
>> What do you think?
>
> tbh, bpf_setsockopt is many steps away. It needs to begin with a 
> syscall setsockopt first. There is little reason it can only be done 
> with a bpf prog. and how does the user know which negotiator a smc 
> sock is using? Currently, ss can learn the tcp-cc of a sk.
>
> ~~~~~~~~
>
> If this effort is serious, the code quality has to be much improved. 
> The obvious bug and unused variables make this set at most a RFC.
>
> From the bpf perspective, it is ok-ish to start with a global 
> negotiator first and skip the setsockopt details for now. However, it 
> needs to be have a name. The new link_update 
> (https://lore.kernel.org/bpf/20230323032405.3735486-1-kuifeng@meta.com/) 
> has to work also. The struct_ops is rcu reader safe, so leverage it 
> whenever it can instead of the read/write lock. It is how struct_ops 
> work for tcp, so try to stay consistent as much as possible in the 
> networking stack.
>
>>
>> In addition, I am very sorry that I have not issued my implementation 
>> for such a long time, and I have encountered some problems with the 
>> implementation because
>> the SMC needs to be built as kernel module, I have struggled with the 
>> bpf_setsockopt implementation, and there are some new self-testes 
>> that need to be written.
>>
>
> Regarding compiling as module,
>
> +ifneq ($(CONFIG_SMC),)
> +ifeq ($(CONFIG_BPF_SYSCALL),y)
> +obj-y                += smc/bpf_smc_struct_ops.o
> +endif
>
> struct_ops does not support module now. It is on the todo list. The 
> bpf_smc_struct_ops.o above can only be used when CONFIG_SMC=y. 
> Otherwise, the bpf_smc_struct_ops is always built in while most users 
> will never load the smc module.

