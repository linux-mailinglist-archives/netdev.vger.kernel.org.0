Return-Path: <netdev+bounces-9410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E5E728D5F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 03:57:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8799281771
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A50A810F0;
	Fri,  9 Jun 2023 01:57:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94017EDB
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 01:57:26 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7096026B3
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:57:23 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Qckbz4yPRz18M7Q;
	Fri,  9 Jun 2023 09:52:31 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:57:20 +0800
Message-ID: <e01c0675-da18-b1a9-64b1-4eaa1627fcb8@huawei.com>
Date: Fri, 9 Jun 2023 09:57:20 +0800
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
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>, <netdev@vger.kernel.org>,
	<jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>
CC: <vladimir.oltean@nxp.com>, <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
 <87zg59sbzb.fsf@intel.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <87zg59sbzb.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/9 8:42, Vinicius Costa Gomes wrote:
> Zhengchao Shao <shaozhengchao@huawei.com> writes:
> 
>> As shown in [1], out-of-bounds access occurs in two cases:
>> 1)when the qdisc of the taprio type is used to replace the previously
>> configured taprio, count and offset in tc_to_txq can be set to 0. In this
>> case, the value of *txq in taprio_next_tc_txq() will increases
>> continuously. When the number of accessed queues exceeds the number of
>> queues on the device, out-of-bounds access occurs.
> 
Hi Vinicius:
	Thank you for your reply.
> The more I think about this, the more I think the problem is somewhere
> else, i.e. even enqueuing a packet from a TC with zero queues associated
> with it doesn't make much sense.
> 
> The behaviors that make more sense to me are:
>    1. reject configurations with '0@0' as invalid;
>    2. drop the packets from TCs mapped to the "empty set" queue (0@0)
>    during enqueue();
> 
> btw, (2) sounds better to me at this point.
> 
> Or is there another valid/sensible interpretation to '0@0' that I am missing?
I think I know what you mean. Your intention is to make judgments
simultaneously during the enqueue process, as shown below?

static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
                           struct sk_buff **to_free)
  {
         struct taprio_sched *q = qdisc_priv(sch);
+       struct net_device *dev = qdisc_dev(sch);
         struct Qdisc *child;
         int queue;
+       int i;
+
+       for (i = 0; i < dev->num_tc; i++) {
+               if (unlikely(!dev->tc_to_txq[i].count))
+                       return qdisc_drop(skb, sch, to_free);
+       }

         queue = skb_get_queue_mapping(skb);

Is it like this?

> 
>> 2)When packets are dequeued, taprio can be deleted. In this case, the tc
>> rule of dev is cleared. The count and offset values are also set to 0. In
>> this case, out-of-bounds access is also caused.
> 
> This looks like more like working around the issue than fixing it, and
> it just happens, it's a coincidence, that both issues have the same
> symptoms.
> 
There are many trigger paths for this problem, and I worry that there
may be missing scenarios after I modify taprio_change and
taprio_destroy, so I modify the dequeue process.

Do you have any other ideas? Thanks.

Zhengchao Shao
>>
>> Now the restriction on the queue number is added.
>>
>> [1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
>> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
>> Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>> v2: set q->cur_txq[tc] to prevent out-of-bounds access during next dequeue
>> ---
>>   net/sched/sch_taprio.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 3c4c2c334878..82983a6eb8f8 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -799,6 +799,9 @@ static struct sk_buff *taprio_dequeue_tc_priority(struct Qdisc *sch,
>>   
>>   			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);
>>   
>> +			if (q->cur_txq[tc] >= dev->num_tx_queues)
>> +				q->cur_txq[tc] = first_txq;
>> +
>>   			if (skb)
>>   				return skb;
>>   		} while (q->cur_txq[tc] != first_txq);
>> -- 
>> 2.34.1
>>
>>
> 

