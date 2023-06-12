Return-Path: <netdev+bounces-9955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E17F272B503
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 02:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EAE628110D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 00:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E3C10EA;
	Mon, 12 Jun 2023 00:49:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB8A55
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:49:59 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53292E41
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 17:49:57 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QfXyj0pKZz18M2L;
	Mon, 12 Jun 2023 08:45:01 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 08:49:54 +0800
Message-ID: <a6b677b2-b2bf-c91d-a6ae-d043081f9026@huawei.com>
Date: Mon, 12 Jun 2023 08:49:53 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
To: Vladimir Oltean <vladimir.oltean@nxp.com>
CC: Vinicius Costa Gomes <vinicius.gomes@intel.com>, <netdev@vger.kernel.org>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
 <87zg59sbzb.fsf@intel.com> <e01c0675-da18-b1a9-64b1-4eaa1627fcb8@huawei.com>
 <20230609094542.y3doavs6t4qk2jlo@skbuf>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20230609094542.y3doavs6t4qk2jlo@skbuf>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023/6/9 17:45, Vladimir Oltean wrote:
> On Fri, Jun 09, 2023 at 09:57:20AM +0800, shaozhengchao wrote:
>>> btw, (2) sounds better to me at this point.
>>>
>>> Or is there another valid/sensible interpretation to '0@0' that I am missing?
>> I think I know what you mean. Your intention is to make judgments
>> simultaneously during the enqueue process, as shown below?
>>
>> static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>>                            struct sk_buff **to_free)
>>   {
>>          struct taprio_sched *q = qdisc_priv(sch);
>> +       struct net_device *dev = qdisc_dev(sch);
>>          struct Qdisc *child;
>>          int queue;
>> +       int i;
>> +
>> +       for (i = 0; i < dev->num_tc; i++) {
>> +               if (unlikely(!dev->tc_to_txq[i].count))
>> +                       return qdisc_drop(skb, sch, to_free);
>> +       }
>>
>>          queue = skb_get_queue_mapping(skb);
>>
>> Is it like this?
> 

Hi Vladimir:
	Thank you for your reply.
> No. If we go down this path (not saying that we should), you should only
> validate the queue count of the packet's traffic class, not all queue counts...
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 978c3504fbaa..d1d10341278d 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -633,11 +633,16 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>   			  struct sk_buff **to_free)
>   {
>   	struct taprio_sched *q = qdisc_priv(sch);
> +	struct net_device *dev = qdisc_dev(sch);
> +	int tc, queue, prio = skb->priority;
>   	struct Qdisc *child;
> -	int queue;
>   
>   	queue = skb_get_queue_mapping(skb);
>   
> +	tc = netdev_get_prio_tc_map(dev, prio);
> +	if (!dev->tc_to_txq[tc].count)
> +		return qdisc_drop(skb, sch, to_free);
> +

It looks good to me. I'll add it in subsequent patch.
>   	child = q->qdiscs[queue];
>   	if (unlikely(!child))
>   		return qdisc_drop(skb, sch, to_free);
> 
>>
>>>
>>>> 2)When packets are dequeued, taprio can be deleted. In this case, the tc
>>>> rule of dev is cleared. The count and offset values are also set to 0. In
>>>> this case, out-of-bounds access is also caused.
>>>
>>> This looks like more like working around the issue than fixing it, and
>>> it just happens, it's a coincidence, that both issues have the same
>>> symptoms.
>>>
>> There are many trigger paths for this problem, and I worry that there
>> may be missing scenarios after I modify taprio_change and
>> taprio_destroy, so I modify the dequeue process.
> 
> Many other trigger paths like what?
> 
> The main code path leading to 0 TXQs for a traffic class that Vinicius
> seems to worry about ("queues 0@0" in configuration) should already be
> rejected by mqprio_validate_queue_counts():
> 
I added the local print information to confirm that some scenarios
cannot be filtered by mqprio_validate_queue_counts. But I can't find a
command line that can reproduce the problem.
> tc qdisc replace dev eno0 handle 8001: parent root stab overhead 24 taprio \
> 	num_tc 3 map 0 1 2 queues 0@0 0@0 0@0 base-time 200 \
> 	sched-entry S 80 20000 sched-entry S a0 20000 sched-entry S 5f 60000 clockid CLOCK_TAI
> Error: sch_mqprio_lib: No queues for TC 0.
> 
> We should thus concentrate on the other (involuntary) code paths that
> can lead to there being 0 TXQs for a TC. Modifying the data path because
> we can't figure out the control path seems desperate.
> 
> Is there a reproducer for the bug?
Only the syz reproduction program.
https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
Thank you.

Zhengchao Shao



