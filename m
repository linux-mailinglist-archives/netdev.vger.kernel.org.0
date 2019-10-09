Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC3BD1874
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732500AbfJITON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:14:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732492AbfJITOL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 15:14:11 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 15EDE10DCC95;
        Wed,  9 Oct 2019 19:14:11 +0000 (UTC)
Received: from ovpn-116-36.ams2.redhat.com (ovpn-116-36.ams2.redhat.com [10.36.116.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA4AE5EE1D;
        Wed,  9 Oct 2019 19:14:08 +0000 (UTC)
Message-ID: <95c5a697932e19ebd6577b5dac4d7052fe8c4255.camel@redhat.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jonas Bonn <jonas.bonn@netrounds.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>
Date:   Wed, 09 Oct 2019 21:14:07 +0200
In-Reply-To: <d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com>
References: <d102074f-7489-e35a-98cf-e2cad7efd8a2@netrounds.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Wed, 09 Oct 2019 19:14:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-10-09 at 08:46 +0200, Jonas Bonn wrote:
> Hi,
> 
> The lockless pfifo_fast qdisc has an issue with packets getting stuck in 
> the queue.  What appears to happen is:
> 
> i)  Thread 1 holds the 'seqlock' on the qdisc and dequeues packets.
> ii)  Thread 1 dequeues the last packet in the queue.
> iii)  Thread 1 iterates through the qdisc->dequeue function again and 
> determines that the queue is empty.
> 
> iv)  Thread 2 queues up a packet.  Since 'seqlock' is busy, it just 
> assumes the packet will be dequeued by whoever is holding the lock.
> 
> v)  Thread 1 releases 'seqlock'.
> 
> After v), nobody will check if there are packets in the queue until a 
> new packet is enqueued.  Thereby, the packet enqueued by Thread 2 may be 
> delayed indefinitely.

I think you are right.

It looks like this possible race is present since the initial lockless
implementation - commit 6b3ba9146fe6 ("net: sched: allow qdiscs to
handle locking")

Anyhow the racing windows looks quite tiny - I never observed that
issue in my tests. Do you have a working reproducer?

Something alike the following code - completely untested - can possibly
address the issue, but it's a bit rough and I would prefer not adding
additonal complexity to the lockless qdiscs, can you please have a spin
a it?

Thanks,

Paolo
---
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6a70845bd9ab..65a1c03330d6 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -113,18 +113,23 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		     struct net_device *dev, struct netdev_queue *txq,
 		     spinlock_t *root_lock, bool validate);
 
-void __qdisc_run(struct Qdisc *q);
+int __qdisc_run(struct Qdisc *q);
 
 static inline void qdisc_run(struct Qdisc *q)
 {
+	int quota = 0;
+
 	if (qdisc_run_begin(q)) {
 		/* NOLOCK qdisc must check 'state' under the qdisc seqlock
 		 * to avoid racing with dev_qdisc_reset()
 		 */
 		if (!(q->flags & TCQ_F_NOLOCK) ||
 		    likely(!test_bit(__QDISC_STATE_DEACTIVATED, &q->state)))
-			__qdisc_run(q);
+			quota = __qdisc_run(q);
 		qdisc_run_end(q);
+
+		if (quota > 0 && q->flags & TCQ_F_NOLOCK && q->ops->peek(q))
+			__netif_schedule(q);
 	}
 }
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 17bd8f539bc7..013480f6a794 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -376,7 +376,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 	return sch_direct_xmit(skb, q, dev, txq, root_lock, validate);
 }
 
-void __qdisc_run(struct Qdisc *q)
+int __qdisc_run(struct Qdisc *q)
 {
 	int quota = dev_tx_weight;
 	int packets;
@@ -390,9 +390,10 @@ void __qdisc_run(struct Qdisc *q)
 		quota -= packets;
 		if (quota <= 0 || need_resched()) {
 			__netif_schedule(q);
-			break;
+			return 0;
 		}
 	}
+	return quota;
 }
 
 unsigned long dev_trans_start(struct net_device *dev)

