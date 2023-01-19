Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2967303B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjASE2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjASDoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 22:44:46 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FEB45BE5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 19:42:02 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Ny7fZ6rjHz16N6D;
        Thu, 19 Jan 2023 11:39:34 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 19 Jan 2023 11:41:19 +0800
Message-ID: <3f6722cf-8bc7-387f-d9eb-f6161a56b91c@huawei.com>
Date:   Thu, 19 Jan 2023 11:41:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
To:     Kyle Zeng <zengyhkyle@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
CC:     David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thank you for your answer.

On 2023/1/18 8:10, Kyle Zeng wrote:
> Hi Zhengchao,
> 
> I'm the finder of the vulnerability. In my initial report, there was a
> more detailed explanation of why this bug happened. But it got left
> out in the commit message.
> So, I'll explain it here and see whether people want to patch the
> actual root cause of the crash.
> 
> The underlying bug that this patch was trying to address is actually
> in `__tcf_classify`. Notice that `struct tcf_result` is actually a
> union type, so whenever the kernel sets res.goto_tp, it also sets
> res.class. And this can happen inside `tcf_action_goto_chain_exec`. In
> other words, `tcf_action_goto_chain_exec` will set res.class. Notice
> that goto_chain can point back to itself, which causes an infinite
> loop. To avoid the infinite loop situation, `__tcf_classify` checks
> how many times the loop has been executed
> (https://elixir.bootlin.com/linux/v6.1/source/net/sched/cls_api.c#L1586),
> if it is more than a specific number, it will mark the result as
> TC_ACT_SHOT and then return:
> 
> if (unlikely(limit++ >= max_reclassify_loop)) {
>      ...
>      return TC_ACT_SHOT;
> }
> 
> However, when it returns in the infinite loop handler, it forgets to
> clear whatever is in the `res` variable, which still holds pointers in
> `goto_tp`. As a result, cbq_classify will think it is a valid
> `res.class` and causes type confusion.

It's very meaningful for me to understand that patch. I think I've
missed the path where there's a problem when I analyze the patch.
> 
> My initial proposed patch was to memset `res` before `return
> TC_ACT_SHOT` in `__tcf_classify`, but it didn't get merged. But I
> guess the merged patch is more generic.
> 
> BTW, I'm not sure whether it is a bug or it is intended in the merged
> patch for this bug: moving `return NULL` statement in `cbq_classify`
> results in a behavior change that is not documented anywhere:
> previously, packets that return TC_ACT_QUEUED, TC_ACT_STOLEN, and
> TC_ACT_TRAP will eventually return NULL, but now they will be passed
> into `cbq_reclassify`. Is this expected?
> 
> Best,
> Kyle Zeng
> 
> On Tue, Jan 17, 2023 at 12:07 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>
>> +Cc netdev
>>
>> On Tue, Jan 17, 2023 at 10:06 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>>
>>> Trimmed Cc (+Davide).
>>>
>>> I am not sure i followed what you are saying because i dont see the
>>> relationship between the
>>> two commits. Did that patch(9410c9409d3e) cause a problem?
>>> How do you reproduce the issue that is caused by this patch that you are seeing?
>>>
>>> One of the challenges we have built over time is consumers of classification and
>>> action execution may not be fully conserving the semantics of the return code.
>>> The return code is a "verdict" on what happened; a safer approach is to get the
>>> return code to be either an error/success code. But that seems to be a
>>> separate issue.
>>>
>>> cheers,
>>> jamal
>>>
>>> On Mon, Jan 16, 2023 at 3:28 AM shaozhengchao <shaozhengchao@huawei.com> wrote:
>>>>
>>>> When I analyzed the following LTS 5.10 patch, I had a small question:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-5.10.y&id=b2c917e510e5ddbc7896329c87d20036c8b82952
>>>>
>>>> As described in this patch, res is obtained through the tcf_classify()
>>>> interface. If result is TC_ACT_SHOT, res may be an abnormal value.
>>>> Accessing class in res will cause abnormal access.
>>>>
>>>> For LTS version 5.10, if tcf_classify() is to return a positive value,
>>>> the classify hook function to the filter must be called, and the hook
>>>> function returns a positive number. Observe the classify function of
>>>> each filter. Generally, res is initialized in four scenarios.
>>>> 1. res is assigned a value by res in the private member of each filter.
>>>> Generally, kzalloc is used to assign initial values to res of various
>>>> filters. Therefore, class in res is initialized to 0. Then use the
>>>> tcf_bind_filter() interface to assign values to members in res.
>>>> Therefore, value of class is assigned. For example, cls_basic.
>>>> 2. The classify function of the filter directly assigns a value to the
>>>> class of res, for example, cls_cgroup.
>>>> 3. The filter classify function references tp and assigns a value to
>>>> res, for example, cls_u32.
>>>> 4. The change function of the filter references fh and assigns a value
>>>> to class in res, for example, cls_rsvp.
>>>>
>>>> This Mainline problem is caused by commit:3aa260559455 (" net/sched:
>>>> store the last executed chain also for clsact egress") and
>>>> commit:9410c9409d3e ("net: sched: Introduce ingress classification
>>>> function"). I don't know if my analysis is correct, please help correct,
>>>> thank you very much.
>>>>
>>>> Zhengchao Shao
