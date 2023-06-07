Return-Path: <netdev+bounces-8657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67F2D725168
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF5CA1C20BF8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8899862A;
	Wed,  7 Jun 2023 01:15:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD697C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:15:44 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987DF172D
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 18:15:41 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QbTsz0pBvzTlBx;
	Wed,  7 Jun 2023 09:15:19 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 09:15:38 +0800
Message-ID: <4cbeb947-5230-4343-1380-95b2d81153d3@huawei.com>
Date: Wed, 7 Jun 2023 09:15:38 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
To: Pedro Tammela <pctammela@mojatatu.com>, <netdev@vger.kernel.org>,
	<vinicius.gomes@intel.com>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <vladimir.oltean@nxp.com>, <weiyongjun1@huawei.com>,
	<yuehaibing@huawei.com>
References: <20230606121009.1942606-1-shaozhengchao@huawei.com>
 <e1e8a050-f6da-beb3-c93e-e2568bf0df05@mojatatu.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <e1e8a050-f6da-beb3-c93e-e2568bf0df05@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 2023/6/6 23:10, Pedro Tammela wrote:
> On 06/06/2023 09:10, Zhengchao Shao wrote:
>> As shown in [1], when qdisc of the taprio type is set, count and 
>> offset in
>> tc_to_txq can be set to 0. In this case, the value of *txq in
>> taprio_next_tc_txq() will increases continuously. When the number of
>> accessed queues exceeds the number of queues on the device, out-of-bounds
>> access occurs. Now the restriction on the queue number is added.
>>
>> [1] https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
>> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to 
>> higher TCs in software dequeue mode")
>> Reported-by: syzbot+04afcb3d2c840447559a@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/sched/sch_taprio.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 3c4c2c334878..dccb64425852 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -801,7 +801,7 @@ static struct sk_buff 
>> *taprio_dequeue_tc_priority(struct Qdisc *sch,
>>               if (skb)
>>                   return skb;
>> -        } while (q->cur_txq[tc] != first_txq);
>> +        } while (q->cur_txq[tc] != first_txq && q->cur_txq[tc] < 
>> dev->num_tx_queues);
> 
Hi Pedro:
	Thank you for youe reply.
> I'm not sure this is the correct fix.
> If q->cur_txg[tc] == dev->num_tx_queues the next call to 
> taprio_dequeue_tc_priority() for the same tc index will have
> first_txq set to dev->num_tx_queues (no wrap around to first_txq happens).
yes, maybe the same problem will occur at the next dequeue skb. It can
be changed to the following:
			taprio_next_tc_txq(dev, tc, &q->cur_txq[tc]);

+                       if (q->cur_txq[tc] == dev->num_tx_queues)
+                               q->cur_txq[tc] = first_txq;
+
                         if (skb)
                                 return skb;
                 } while (q->cur_txq[tc] != first_txq);
However, I prefer to limit the value of count in taprio_change(), so 
that I don't add extra judgment to the data path.

Hi Vinicius,
	Do you have any better suggestions?
> If count and offset are 0 it will increment q->cur_txg[tc] and then bail 
> on the while condition but still growing unbounded (just slower than 
> before).
> 
>>       }
>>   taprio_dequeue_tc_priority
>>       return NULL;
> 
> 

