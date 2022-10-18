Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7E960242A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJRGJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJRGJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:09:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6051F62C
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:09:46 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ms3HL2kvKzmV8b;
        Tue, 18 Oct 2022 14:05:02 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 18 Oct 2022 14:09:44 +0800
Message-ID: <d8c1daa0-32d4-7c95-1ebe-037396309e86@huawei.com>
Date:   Tue, 18 Oct 2022 14:09:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 2/3] net: sched: fq_codel: fix null pointer access
 issue when fq_codel_init() fails
To:     Eric Dumazet <edumazet@google.com>
CC:     <cake@lists.bufferbloat.net>, <netdev@vger.kernel.org>,
        <toke@toke.dk>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <dave.taht@gmail.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221018034718.82389-1-shaozhengchao@huawei.com>
 <20221018034718.82389-3-shaozhengchao@huawei.com>
 <CANn89iJubvtbdpgKXhP8CMcWEn8Ws80sLeu=F4RMTAEKWePoyg@mail.gmail.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <CANn89iJubvtbdpgKXhP8CMcWEn8Ws80sLeu=F4RMTAEKWePoyg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/18 12:02, Eric Dumazet wrote:
> On Mon, Oct 17, 2022 at 8:39 PM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>>
>> When the default qdisc is fq_codel, if the qdisc of dev_queue fails to be
>> inited during mqprio_init(), fq_codel_reset() is invoked to clear
>> resources. In this case, the flow is NULL, and it will cause gpf issue.
>>
>> The process is as follows:
>> qdisc_create_dflt()
>>          fq_codel_init()
>>                  ...
>>                  q->flows_cnt = 1024;
>>                  ...
>>                  q->flows = kvcalloc(...)      --->failed, q->flows is NULL
>>                  ...
>>          ...
>>          qdisc_put()
>>                  ...
>>                  fq_codel_reset()
>>                          ...
>>                          flow = q->flows + i   --->q->flows is NULL
>>
>> The following is the Call Trace information:
>> general protection fault, probably for non-canonical address
>> 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>> RIP: 0010:fq_codel_reset+0x14d/0x350
>> Call Trace:
>> <TASK>
>> qdisc_reset+0xed/0x6f0
>> qdisc_destroy+0x82/0x4c0
>> qdisc_put+0x9e/0xb0
>> qdisc_create_dflt+0x2c3/0x4a0
>> mqprio_init+0xa71/0x1760
>> qdisc_create+0x3eb/0x1000
>> tc_modify_qdisc+0x408/0x1720
>> rtnetlink_rcv_msg+0x38e/0xac0
>> netlink_rcv_skb+0x12d/0x3a0
>> netlink_unicast+0x4a2/0x740
>> netlink_sendmsg+0x826/0xcc0
>> sock_sendmsg+0xc5/0x100
>> ____sys_sendmsg+0x583/0x690
>> ___sys_sendmsg+0xe8/0x160
>> __sys_sendmsg+0xbf/0x160
>> do_syscall_64+0x35/0x80
>> entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> RIP: 0033:0x7fd272b22d04
>> </TASK>
>>
>> Fixes: 494f5063b86c ("net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()")
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
> 
> I vote for a revert, previous code was much cleaner.
Hi Eric:
	Thank you for your review. I will revert it in V2.

Zhengchao Shao
