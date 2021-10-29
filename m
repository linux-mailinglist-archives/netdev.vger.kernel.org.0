Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A255D43FFA9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 17:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhJ2Phk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 11:37:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:57318 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJ2Phk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 11:37:40 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgTuQ-000EDJ-U8; Fri, 29 Oct 2021 17:35:10 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mgTuQ-000DhD-Nv; Fri, 29 Oct 2021 17:35:10 +0200
Subject: Re: [PATCH] net: sched: check tc_skip_classify as far as possible
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211028135644.2258-1-xiangxia.m.yue@gmail.com>
 <3b8386fe-b3ff-1ed1-a02b-713b71c8a8d8@iogearbox.net>
 <CAMDZJNWhZjMe1MSfZYuOWcstzkhjTutxizdzq6S1M9=M_x_VMA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d4d45284-7584-6cff-0f43-4d6ac55b5a9a@iogearbox.net>
Date:   Fri, 29 Oct 2021 17:35:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAMDZJNWhZjMe1MSfZYuOWcstzkhjTutxizdzq6S1M9=M_x_VMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26337/Fri Oct 29 10:19:12 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 2:04 AM, Tonghao Zhang wrote:
> On Thu, Oct 28, 2021 at 10:28 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 10/28/21 3:56 PM, xiangxia.m.yue@gmail.com wrote:
>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>>
>>> We look up and then check tc_skip_classify flag in net
>>> sched layer, even though skb don't want to be classified.
>>> That case may consume a lot of cpu cycles.
>>>
>>> Install the rules as below:
>>> $ for id in $(seq 1 100); do
>>> $     tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
>>> $ done
>>
>> Do you actually have such a case in practice or is this just hypothetical?
> Hi Daniel, I did some research about this for k8s in production. There
> are not so many tc prio(~5 different prio).
> butg in this test, I use the 100 prio.
> 
> I reviewed the code, for the tx path, I think we check the
> tc_skip_classify too later. In the rx path, we check it
> in __netif_receive_skb_core.
> 
>> Asking as this feels rather broken to begin with.
>>> netperf:
>>> $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
>>> $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
>>>
>>> Without this patch:
>>> 10662.33 tps
>>> 108.95 Mbit/s
>>>
>>> With this patch:
>>> 12434.48 tps
>>> 145.89 Mbit/s
>>>
>>> For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
>>>
>>> Cc: Willem de Bruijn <willemb@google.com>
>>> Cc: Cong Wang <xiyou.wangcong@gmail.com>
>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>> ---
>>>    net/core/dev.c      | 3 ++-
>>>    net/sched/act_api.c | 3 ---
>>>    2 files changed, 2 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/net/core/dev.c b/net/core/dev.c
>>> index eb61a8821b3a..856ac1fb75b4 100644
>>> --- a/net/core/dev.c
>>> +++ b/net/core/dev.c
>>> @@ -4155,7 +4155,8 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
>>>    #ifdef CONFIG_NET_CLS_ACT
>>>        skb->tc_at_ingress = 0;
>>>    # ifdef CONFIG_NET_EGRESS
>>> -     if (static_branch_unlikely(&egress_needed_key)) {
>>> +     if (static_branch_unlikely(&egress_needed_key) &&
>>> +         !skb_skip_tc_classify(skb)) {
>>>                skb = sch_handle_egress(skb, &rc, dev);
>>>                if (!skb)
>>>                        goto out;
>>> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
>>> index 7dd3a2dc5fa4..bd66f27178be 100644
>>> --- a/net/sched/act_api.c
>>> +++ b/net/sched/act_api.c
>>> @@ -722,9 +722,6 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
>>>        int i;
>>>        int ret = TC_ACT_OK;
>>>
>>> -     if (skb_skip_tc_classify(skb))
>>> -             return TC_ACT_OK;
>>> -
>>
>> I think this might imply a change in behavior which could have the potential
>> to break setups in the wild.
> we may not change this code, i will send v2, if not comment.

Well none of it I'm afraid, the sch_handle_egress() is out for a very long time by
now and your change could have the potential to break setups in the wild.

>>>    restart_act_graph:
>>>        for (i = 0; i < nr_actions; i++) {
>>>                const struct tc_action *a = actions[i];
>>>
>>
> 
> 

