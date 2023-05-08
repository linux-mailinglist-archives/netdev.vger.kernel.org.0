Return-Path: <netdev+bounces-778-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A03086F9E48
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 05:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D62B81C2091D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 03:37:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C69125CE;
	Mon,  8 May 2023 03:37:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2C6442B
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 03:37:25 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4024483;
	Sun,  7 May 2023 20:37:22 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QF6QK2JbgzpW6Q;
	Mon,  8 May 2023 11:36:09 +0800 (CST)
Received: from [10.174.176.93] (10.174.176.93) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 11:37:19 +0800
Message-ID: <a1bd617b-c3ae-f2df-b643-aaa7b6eaf531@huawei.com>
Date: Mon, 8 May 2023 11:37:19 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 4/9] softirq: Allow early break
To: Eric Dumazet <edumazet@google.com>
CC: <corbet@lwn.net>, <paulmck@kernel.org>, <frederic@kernel.org>,
	<quic_neeraju@quicinc.com>, <joel@joelfernandes.org>,
	<josh@joshtriplett.org>, <boqun.feng@gmail.com>, <rostedt@goodmis.org>,
	<mathieu.desnoyers@efficios.com>, <jiangshanlai@gmail.com>,
	<qiang1.zhang@intel.com>, <jstultz@google.com>, <tglx@linutronix.de>,
	<sboyd@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <peterz@infradead.org>, <frankwoo@google.com>,
	<Rhinewuwu@google.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <rcu@vger.kernel.org>,
	<netdev@vger.kernel.org>
References: <20230505113315.3307723-1-liujian56@huawei.com>
 <20230505113315.3307723-5-liujian56@huawei.com>
 <CANn89iJL3ywLwig8U6JKG6itL7Fr=ab_dv7Pz1YDiDvCiR-Fog@mail.gmail.com>
From: "liujian (CE)" <liujian56@huawei.com>
In-Reply-To: <CANn89iJL3ywLwig8U6JKG6itL7Fr=ab_dv7Pz1YDiDvCiR-Fog@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.93]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/5/5 20:10, Eric Dumazet wrote:
> On Fri, May 5, 2023 at 1:24 PM Liu Jian <liujian56@huawei.com> wrote:
>>
>> From: Peter Zijlstra <peterz@infradead.org>
>>
>> Allow terminating the softirq processing loop without finishing the
>> vectors.
>>
>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Signed-off-by: Liu Jian <liujian56@huawei.com>
>> ---
>>   kernel/softirq.c | 16 ++++++++++------
>>   1 file changed, 10 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/softirq.c b/kernel/softirq.c
>> index 48a81d8ae49a..e2cad5d108c8 100644
>> --- a/kernel/softirq.c
>> +++ b/kernel/softirq.c
>> @@ -582,6 +582,9 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
>>                                 prev_count, preempt_count());
>>                          preempt_count_set(prev_count);
>>                  }
>> +
>> +               if (pending && __softirq_needs_break(start))
>> +                       break;
> 
> This means that some softirq may starve, because
> 
> for_each_set_bit(vec_nr, &pending, NR_SOFTIRQS)
> 
> Always iterate using the same order (of bits)
> 
> 
Yes, we need to record the softirq that is not executed and continue 
next time. I will fix it in next version.
Thanks.
> 
> 
>>          }
>>
>>          if (!IS_ENABLED(CONFIG_PREEMPT_RT) &&
>> @@ -590,13 +593,14 @@ asmlinkage __visible void __softirq_entry __do_softirq(void)
>>
>>          local_irq_disable();
>>
>> -       pending = local_softirq_pending();
>> -       if (pending) {
>> -               if (!__softirq_needs_break(start) && --max_restart)
>> -                       goto restart;
>> +       if (pending)
>> +               or_softirq_pending(pending);
>> +       else if ((pending = local_softirq_pending()) &&
>> +                !__softirq_needs_break(start) &&
>> +                --max_restart)
>> +               goto restart;
>>
>> -               wakeup_softirqd();
>> -       }
>> +       wakeup_softirqd();
>>
>>          account_softirq_exit(current);
>>          lockdep_softirq_end(in_hardirq);
>> --
>> 2.34.1
>>

