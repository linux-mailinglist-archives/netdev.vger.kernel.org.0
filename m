Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBE4268274
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 04:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgINCKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 22:10:44 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725965AbgINCKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 22:10:43 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4FE7837DAEF3B9BAE1FC;
        Mon, 14 Sep 2020 10:10:39 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 14 Sep 2020 10:10:31 +0800
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>
CC:     Hillf Danton <hdanton@sina.com>, Paolo Abeni <pabeni@redhat.com>,
        "Jike Song" <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        "David Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com>
 <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com>
 <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AM7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com>
 <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <20200903101957.428-1-hdanton@sina.com>
 <CACS=qqLKSpnRrgROm8jzzFid3MH97phPXWsk28b371dfu0mnVA@mail.gmail.com>
 <CAM_iQpUq9-wja3JHz9+TMeXGyAOmJfZDxWUZJ9v25i7vd0Z-Wg@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c97908eb-5a0b-363c-93fd-59c037bbd9f0@huawei.com>
Date:   Mon, 14 Sep 2020 10:10:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpUq9-wja3JHz9+TMeXGyAOmJfZDxWUZJ9v25i7vd0Z-Wg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/11 4:19, Cong Wang wrote:
> On Thu, Sep 3, 2020 at 8:21 PM Kehuan Feng <kehuan.feng@gmail.com> wrote:
>> I also tried Cong's patch (shown below on my tree) and it could avoid
>> the issue (stressing for 30 minutus for three times and not jitter
>> observed).
> 
> Thanks for verifying it!
> 
>>
>> --- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +0800
>> +++ ./include/net/sch_generic.h 2020-09-03 21:36:11.468383738 +0800
>> @@ -127,8 +127,7 @@
>>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
>>  {
>>   if (qdisc->flags & TCQ_F_NOLOCK) {
>> - if (!spin_trylock(&qdisc->seqlock))
>> - return false;
>> + spin_lock(&qdisc->seqlock);
>>   } else if (qdisc_is_running(qdisc)) {
>>   return false;
>>   }
>>
>> I am not actually know what you are discussing above. It seems to me
>> that Cong's patch is similar as disabling lockless feature.
> 
>>From performance's perspective, yeah. Did you see any performance
> downgrade with my patch applied? It would be great if you can compare
> it with removing NOLOCK. And if the performance is as bad as no
> NOLOCK, then we can remove the NOLOCK bit for pfifo_fast, at least
> for now.

It seems the lockless qdisc may have below concurrent problem:
  cpu0:                                                           cpu1:
q->enqueue							    .
qdisc_run_begin(q)  						    .
__qdisc_run(q) ->qdisc_restart() -> dequeue_skb()		    .
		                 -> sch_direct_xmit()		    .
 								    .
                                                                q->enqueue
				                             qdisc_run_begin(q)			
qdisc_run_end(q)


cpu1 enqueue a skb without calling __qdisc_run(), and cpu0 did not see the
enqueued skb when calling __qdisc_run(q) because cpu1 may enqueue the skb
after cpu0 called __qdisc_run(q) and before cpu0 called qdisc_run_end(q).


Kehuan, do you care to try the below patch if it is the same problem?

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d60e7c3..c97c1ed 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -36,6 +36,7 @@ struct qdisc_rate_table {
 enum qdisc_state_t {
 	__QDISC_STATE_SCHED,
 	__QDISC_STATE_DEACTIVATED,
+	__QDISC_STATE_ENQUEUED,
 };

 struct qdisc_size_table {
diff --git a/net/core/dev.c b/net/core/dev.c
index 0362419..5985648 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3748,6 +3748,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 	qdisc_calculate_pkt_len(skb, q);

 	if (q->flags & TCQ_F_NOLOCK) {
+		set_bit(__QDISC_STATE_ENQUEUED, &q->state);
+		smp_mb__after_atomic();
 		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
 		qdisc_run(q);

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d..c389641 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -381,6 +381,8 @@ void __qdisc_run(struct Qdisc *q)
 	int quota = dev_tx_weight;
 	int packets;

+	clear_bit(__QDISC_STATE_ENQUEUED, &q->state);
+	smp_mb__after_atomic();
 	while (qdisc_restart(q, &packets)) {
 		quota -= packets;
 		if (quota <= 0) {
@@ -388,6 +390,9 @@ void __qdisc_run(struct Qdisc *q)
 			break;
 		}
 	}
+
+	if (test_bit(__QDISC_STATE_ENQUEUED, &q->state))
+		__netif_schedule(q);
 }

 unsigned long dev_trans_start(struct net_device *dev)


> 
> Thanks.
> 
