Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986B36731CA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 07:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjASGd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 01:33:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjASGdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 01:33:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1BB12F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 22:33:49 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NyCTs17j6zJs9f;
        Thu, 19 Jan 2023 14:32:17 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 19 Jan 2023 14:33:35 +0800
Message-ID: <b44d1100-af59-8f8a-ed59-1375a40f0d44@huawei.com>
Date:   Thu, 19 Jan 2023 14:33:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: Question: Patch:("net: sched: cbq: dont intepret cls results when
 asked to drop") may be not bug for branch LTS 5.10
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>
CC:     Kyle Zeng <zengyhkyle@gmail.com>,
        David Miller <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4538d7d2-0d43-16b7-9f80-77355f08cc61@huawei.com>
 <CAM0EoM=rqF8K997AmC0VDncJ9LeA0PJku2BL96iiatAOiv1-vw@mail.gmail.com>
 <CAM0EoM=VwZWzz1n_y8bj3y44NKBmhnmn+HUHtHwBb5qcCqETfg@mail.gmail.com>
 <CADW8OBvNcMCogJsMJkVXw70PL3oGU9s1a16DOK+xqdnCfgQzvg@mail.gmail.com>
 <Y8fSmFD2dNtBpbwK@dcaratti.users.ipa.redhat.com>
 <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CAM0EoMmhHns_bY-JsXvrUkRhqu3xTDaRNk+cP-x=O_848R0W3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

Hi Jamal:

On 2023/1/18 21:06, Jamal Hadi Salim wrote:
> The reproducer the Kyle included back then was not useful - it seemed
> like a cutnpaste
> from some syzkaller dashboard (and didnt compile); however, for this one issue,
> you can reproduce the problem by creating the infinite loop setup that
> Davide describes.
> 
> The main issue is bigger than tcf_classify: It has to do with
> interpretation of tcf_result
> and the return codes.
> I reviewed all consumers of tcf_results and only 3 (all happened to be qdiscs)
> were fixed in that patch set. Note consumers include all objects in
> the hierarchy
> including classifiers and action.
> 
> Typically, the LinuxWay(tm) of cutting and pasting what other people before you
> did works - but sometimes people forget environmental rules even when they are
> documented. The main environmental rule that was at stake here is the return
> (verdict) code said to drop the packet. The validity of tcf_result in
> such a case is
> questionable and setting it to 0 was irrelevant. So that is all the
> fix had to do for -net.
> 
> The current return code is a "verdict" on what happened. Given that
> there is potential
> to misinterpret - as was seen here - a safer approach is to get the
> return code to be either
> an error/success code(eg ELOOP for the example being quoted) since
> that is a more
> common pattern and we store the "verdict code" in tcf_result (TC_ACT_SHOT).
> I was planning to send an RFC patch for that.
> 
> I am still not clear on the correlation that Zhengchao Shao was making between
> Davide's patch and this issue...
> 
I'm just looking for the specific possible root cause of the issue.
Please help check whether the possible causes are as follows:
1. __tcf_classify returns TC_ACT_UNSPEC,tc_skb_ext_alloc allocation 
failure, and the res may be abnormal. Maybe fix commit:9410c9409d3e
("net: sched: Introduce ingress classification function")
2.tcf_chain_lookup_rcu return NULL,and tcf_classify will return 
TC_ACT_SHOT. In this way, res is abnormal. Oh, I am sorry. In
cbq_classify, pass NULL as block. So tcf_chain_lookup_rcu will not be
called in tcf_classify. Ignore this.

Thank you again for your careful answer.

Zhengchao Shao
> cheers,
> jamal
> 
> 
> On Wed, Jan 18, 2023 at 6:06 AM Davide Caratti <dcaratti@redhat.com> wrote:
>>
>> hello,
>>
>> On Tue, Jan 17, 2023 at 05:10:58PM -0700, Kyle Zeng wrote:
>>> Hi Zhengchao,
>>>
>>> I'm the finder of the vulnerability. In my initial report, there was a
>>> more detailed explanation of why this bug happened. But it got left
>>> out in the commit message.
>>> So, I'll explain it here and see whether people want to patch the
>>> actual root cause of the crash.
>>>
>>> The underlying bug that this patch was trying to address is actually
>>> in `__tcf_classify`. Notice that `struct tcf_result` is actually a
>>> union type, so whenever the kernel sets res.goto_tp, it also sets
>>> res.class.
>>
>>  From what I see/remember, 'res' (struct tcf_result) is unassigned
>> unless the packet is matched by a classifier (i.e. it does not return
>> TC_ACT_UNSPEC).
>>
>> When this match happens (__tcf_classify returns non-negative) and the
>> control action says TC_ACT_GOTO_CHAIN, res->goto_tp is written.
>> Like you say, 'res.class' is written as well because it's a union.
>>
>>> And this can happen inside `tcf_action_goto_chain_exec`. In
>>> other words, `tcf_action_goto_chain_exec` will set res.class. Notice
>>> that goto_chain can point back to itself, which causes an infinite
>>> loop. To avoid the infinite loop situation, `__tcf_classify` checks
>>> how many times the loop has been executed
>>> (https://elixir.bootlin.com/linux/v6.1/source/net/sched/cls_api.c#L1586),
>>> if it is more than a specific number, it will mark the result as
>>> TC_ACT_SHOT and then return:
>>>
>>> if (unlikely(limit++ >= max_reclassify_loop)) {
>>>      ...
>>>      return TC_ACT_SHOT;
>>> }
>>
>> maybe there is an easier reproducer, something made of 2 TC actions.
>> The first one goes to a valid chain, and then the second one (executed from
>> within the chain) drops the packet. I think that unpatched CBQ scheduler
>> will find 'res.class' with a value also there.
>>
>>> However, when it returns in the infinite loop handler, it forgets to
>>> clear whatever is in the `res` variable, which still holds pointers in
>>> `goto_tp`. As a result, cbq_classify will think it is a valid
>>> `res.class` and causes type confusion.
>>>
>>> My initial proposed patch was to memset `res` before `return
>>> TC_ACT_SHOT` in `__tcf_classify`, but it didn't get merged. But I
>>> guess the merged patch is more generic.
>>
>> The merged patch looks good to me; however, I wonder if it's sufficient.
>> If I well read the code, there is still the possibility of hitting the
>> same problem on a patched kernel when TC_ACT_TRAP / TC_ACT_STOLEN is
>> returned after a 'goto chain' when the qdisc is CBQ.
>>
>> I like Jamal's idea of sharing the reproducer :)
> 
> 
>> thanks!
>> --
>> davide
>>
>>
>>
> 
