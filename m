Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A76925D33B
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgIDILD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:11:03 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:45830 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726425AbgIDILB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 04:11:01 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2CABDE12EC3A4C7AC792;
        Fri,  4 Sep 2020 16:10:58 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 16:10:51 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
 <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
 <1f7208e6-8667-e542-88dd-bd80a6c59fd2@gmail.com>
 <6984825d-1ef7-bf58-75fe-cee1bafe3c1a@huawei.com>
 <df8423fb-63ed-604d-df4d-a94be5b47b31@gmail.com>
 <041539d7-fb42-908d-5638-49ca51d758f1@huawei.com>
 <1c01f9e0-fde4-a8ee-caa3-598738a9a98d@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <5223daf1-a7a2-5d20-7dde-b5b6284f8e02@huawei.com>
Date:   Fri, 4 Sep 2020 16:10:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1c01f9e0-fde4-a8ee-caa3-598738a9a98d@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/3 15:24, Eric Dumazet wrote:
> 
> 
> On 9/2/20 6:14 PM, Yunsheng Lin wrote:
> 
>>
>> It seems semantics for some_qdisc_is_busy() is changed, which does not only do
>> the checking, but also do the reseting?
> 
> Yes, obviously, we would have to rename to a better name.
> 
>>
>> Also, qdisc_reset() could be called multi times for the same qdisc if some_qdisc_is_busy()
>> return true multi times?
> 
> This should not matter, qdisc_reset() can be called multiple times,
> as we also call it from qdisc_destroy() anyway.

How about the below patch, which does not need to change the semantics
for some_qdisc_is_busy() and avoid calling qdisc_reset() multi times?


diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 265a61d..ce9031c 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1131,24 +1131,7 @@ EXPORT_SYMBOL(dev_activate);

 static void qdisc_deactivate(struct Qdisc *qdisc)
 {
-	bool nolock = qdisc->flags & TCQ_F_NOLOCK;
-
-	if (qdisc->flags & TCQ_F_BUILTIN)
-		return;
-	if (test_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state))
-		return;
-
-	if (nolock)
-		spin_lock_bh(&qdisc->seqlock);
-	spin_lock_bh(qdisc_lock(qdisc));
-
 	set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
-
-	qdisc_reset(qdisc);
-
-	spin_unlock_bh(qdisc_lock(qdisc));
-	if (nolock)
-		spin_unlock_bh(&qdisc->seqlock);
 }

 static void dev_deactivate_queue(struct net_device *dev,
@@ -1165,6 +1148,33 @@ static void dev_deactivate_queue(struct net_device *dev,
 	}
 }

+static void dev_reset_qdisc(struct net_device *dev)
+{
+	unsigned int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *dev_queue;
+		struct Qdisc *q;
+		bool nolock;
+
+		dev_queue = netdev_get_tx_queue(dev, i);
+		q = dev_queue->qdisc_sleeping;
+		nolock = q->flags & TCQ_F_NOLOCK;
+
+		if (nolock)
+			spin_lock_bh(&q->seqlock);
+
+		spin_lock_bh(qdisc_lock(q));
+
+		qdisc_reset(q);
+
+		spin_unlock_bh(qdisc_lock(q));
+
+		if (nolock)
+			spin_unlock_bh(&q->seqlock);
+	}
+}
+
 static bool some_qdisc_is_busy(struct net_device *dev)
 {
 	unsigned int i;
@@ -1219,6 +1229,9 @@ void dev_deactivate_many(struct list_head *head)
 	 */
 	synchronize_net();

+	list_for_each_entry(dev, head, close_list)
+		dev_reset_qdisc(dev);
+
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, close_list) {
 		while (some_qdisc_is_busy(dev)) {



> 
> 
