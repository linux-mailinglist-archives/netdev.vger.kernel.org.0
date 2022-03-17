Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F1A4DBC1B
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 02:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347539AbiCQBNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 21:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiCQBNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 21:13:54 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC211D313
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:12:39 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22GMgcd5021127
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:12:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=HXNSN/x1BNmGK4V74Ssymrnz2ATVzyazkZyNwPrs4ng=;
 b=AQf+L7O2bb51XhDohKFfKH69RsXVXpg/sRcFSRk06v4rPnN/bPZ6s87vNQxC0HnZ2hK3
 Sd5mTiuAwVPlq/nFTD0EeH4+Hs5zou4cxZj6mksI1emGd/HrLLnCM+y7Q+Km1q4Czy4h
 Kli/3x0NrGryCA4sXfH7L93WNXxJRWhtJ5CasOsNibwqiUyP+3YeQ6huAmw+Dj7kGtdF
 v3fGNG0y3/bqhCyT18RhaedwuBFinXlb/p1sTLm9x7Tgy3kJyPzjOYoF0ucWYACSzf3L
 kZR46N9I9R49Uj4fBVbDqlD6taviXu3kMtxIqwcEajP0R7D6113zdJfKyR7I54FVOjuY sw== 
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eurx5t3js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:12:38 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22H17xgL025521
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:12:37 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 3erk59rd4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:12:37 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22H1CYVX23724452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Mar 2022 01:12:34 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDC85C6067;
        Thu, 17 Mar 2022 01:12:33 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E3B1C605B;
        Thu, 17 Mar 2022 01:12:32 +0000 (GMT)
Received: from suka-w540.ibmuc.com (unknown [9.65.206.159])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 17 Mar 2022 01:12:32 +0000 (GMT)
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Brian King <brking@linux.ibm.com>, Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Vaishnavi Bhat <vaish123@in.ibm.com>
Subject: [PATCH net v2 1/1] ibmvnic: fix race between xmit and reset
Date:   Wed, 16 Mar 2022 18:12:31 -0700
Message-Id: <20220317011231.1925467-1-sukadev@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: xYyyIPeXdLzy0KkXFYX_pQj5Di_po792
X-Proofpoint-ORIG-GUID: xYyyIPeXdLzy0KkXFYX_pQj5Di_po792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_09,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203170005
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a race between reset and the transmit paths that can lead to
ibmvnic_xmit() accessing an scrq after it has been freed in the reset
path. It can result in a crash like:

	Kernel attempted to read user page (0) - exploit attempt? (uid: 0)
	BUG: Kernel NULL pointer dereference on read at 0x00000000
	Faulting instruction address: 0xc0080000016189f8
	Oops: Kernel access of bad area, sig: 11 [#1]
	...
	NIP [c0080000016189f8] ibmvnic_xmit+0x60/0xb60 [ibmvnic]
	LR [c000000000c0046c] dev_hard_start_xmit+0x11c/0x280
	Call Trace:
	[c008000001618f08] ibmvnic_xmit+0x570/0xb60 [ibmvnic] (unreliable)
	[c000000000c0046c] dev_hard_start_xmit+0x11c/0x280
	[c000000000c9cfcc] sch_direct_xmit+0xec/0x330
	[c000000000bfe640] __dev_xmit_skb+0x3a0/0x9d0
	[c000000000c00ad4] __dev_queue_xmit+0x394/0x730
	[c008000002db813c] __bond_start_xmit+0x254/0x450 [bonding]
	[c008000002db8378] bond_start_xmit+0x40/0xc0 [bonding]
	[c000000000c0046c] dev_hard_start_xmit+0x11c/0x280
	[c000000000c00ca4] __dev_queue_xmit+0x564/0x730
	[c000000000cf97e0] neigh_hh_output+0xd0/0x180
	[c000000000cfa69c] ip_finish_output2+0x31c/0x5c0
	[c000000000cfd244] __ip_queue_xmit+0x194/0x4f0
	[c000000000d2a3c4] __tcp_transmit_skb+0x434/0x9b0
	[c000000000d2d1e0] __tcp_retransmit_skb+0x1d0/0x6a0
	[c000000000d2d984] tcp_retransmit_skb+0x34/0x130
	[c000000000d310e8] tcp_retransmit_timer+0x388/0x6d0
	[c000000000d315ec] tcp_write_timer_handler+0x1bc/0x330
	[c000000000d317bc] tcp_write_timer+0x5c/0x200
	[c000000000243270] call_timer_fn+0x50/0x1c0
	[c000000000243704] __run_timers.part.0+0x324/0x460
	[c000000000243894] run_timer_softirq+0x54/0xa0
	[c000000000ea713c] __do_softirq+0x15c/0x3e0
	[c000000000166258] __irq_exit_rcu+0x158/0x190
	[c000000000166420] irq_exit+0x20/0x40
	[c00000000002853c] timer_interrupt+0x14c/0x2b0
	[c000000000009a00] decrementer_common_virt+0x210/0x220
	--- interrupt: 900 at plpar_hcall_norets_notrace+0x18/0x2c

The immediate cause of the crash is the access of tx_scrq in the following
snippet during a reset, where the tx_scrq can be either NULL or an address
that will soon be invalid:

	ibmvnic_xmit()
	{
		...
		tx_scrq = adapter->tx_scrq[queue_num];
		txq = netdev_get_tx_queue(netdev, queue_num);
		ind_bufp = &tx_scrq->ind_buf;

		if (test_bit(0, &adapter->resetting)) {
		...
	}

But beyond that, the call to ibmvnic_xmit() itself is not safe during a
reset and the reset path attempts to avoid this by stopping the queue in
ibmvnic_cleanup(). However just after the queue was stopped, an in-flight
ibmvnic_complete_tx() could have restarted the queue even as the reset is
progressing.

Since the queue was restarted we could get a call to ibmvnic_xmit() which
can then access the bad tx_scrq (or other fields).

We cannot however simply have ibmvnic_complete_tx() check the ->resetting
bit and skip starting the queue. This can race at the "back-end" of a good
reset which just restarted the queue but has not cleared the ->resetting
bit yet. If we skip restarting the queue due to ->resetting being true,
the queue would remain stopped indefinitely potentially leading to transmit
timeouts.

IOW ->resetting is too broad for this purpose. Instead use a new flag
that indicates whether or not the queues are active. Only the open/
reset paths control when the queues are active. ibmvnic_complete_tx()
and others wake up the queue only if the queue is marked active.

So we will have:
	A. reset/open thread in ibmvnic_cleanup() and __ibmvnic_open()

		->resetting = true
		->tx_queues_active = false
		disable tx queues
		...
		->tx_queues_active = true
		start tx queues

	B. Tx interrupt in ibmvnic_complete_tx():

		if (->tx_queues_active)
			netif_wake_subqueue();

To ensure that ->tx_queues_active and state of the queues are consistent,
we need a lock which:

	- must also be taken in the interrupt path (ibmvnic_complete_tx())
	- shared across the multiple queues in the adapter (so they don't
	  become serialized)

Use rcu_read_lock() and have the reset thread synchronize_rcu() after
updating the ->tx_queues_active state.

While here, consolidate a few boolean fields in ibmvnic_adapter for
better alignment.

Based on discussions with Brian King and Dany Madden.

Fixes: 7ed5b31f4a66 ("net/ibmvnic: prevent more than one thread from running in reset")
Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
---

Changelog [v2]
	- [Jakub Kicinski] Rebase to current net/master

 drivers/net/ethernet/ibm/ibmvnic.c | 63 ++++++++++++++++++++++++------
 drivers/net/ethernet/ibm/ibmvnic.h |  7 +++-
 2 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b423e94956f1..b4804ce63151 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1429,6 +1429,15 @@ static int __ibmvnic_open(struct net_device *netdev)
 		return rc;
 	}
 
+	adapter->tx_queues_active = true;
+
+	/* Since queues were stopped until now, there shouldn't be any
+	 * one in ibmvnic_complete_tx() or ibmvnic_xmit() so maybe we
+	 * don't need the synchronize_rcu()? Leaving it for consistency
+	 * with setting ->tx_queues_active = false.
+	 */
+	synchronize_rcu();
+
 	netif_tx_start_all_queues(netdev);
 
 	if (prev_state == VNIC_CLOSED) {
@@ -1603,6 +1612,14 @@ static void ibmvnic_cleanup(struct net_device *netdev)
 	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
 
 	/* ensure that transmissions are stopped if called by do_reset */
+
+	adapter->tx_queues_active = false;
+
+	/* Ensure complete_tx() and ibmvnic_xmit() see ->tx_queues_active
+	 * update so they don't restart a queue after we stop it below.
+	 */
+	synchronize_rcu();
+
 	if (test_bit(0, &adapter->resetting))
 		netif_tx_disable(netdev);
 	else
@@ -1842,14 +1859,21 @@ static void ibmvnic_tx_scrq_clean_buffer(struct ibmvnic_adapter *adapter,
 		tx_buff->skb = NULL;
 		adapter->netdev->stats.tx_dropped++;
 	}
+
 	ind_bufp->index = 0;
+
 	if (atomic_sub_return(entries, &tx_scrq->used) <=
 	    (adapter->req_tx_entries_per_subcrq / 2) &&
-	    __netif_subqueue_stopped(adapter->netdev, queue_num) &&
-	    !test_bit(0, &adapter->resetting)) {
-		netif_wake_subqueue(adapter->netdev, queue_num);
-		netdev_dbg(adapter->netdev, "Started queue %d\n",
-			   queue_num);
+	    __netif_subqueue_stopped(adapter->netdev, queue_num)) {
+		rcu_read_lock();
+
+		if (adapter->tx_queues_active) {
+			netif_wake_subqueue(adapter->netdev, queue_num);
+			netdev_dbg(adapter->netdev, "Started queue %d\n",
+				   queue_num);
+		}
+
+		rcu_read_unlock();
 	}
 }
 
@@ -1904,11 +1928,12 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int index = 0;
 	u8 proto = 0;
 
-	tx_scrq = adapter->tx_scrq[queue_num];
-	txq = netdev_get_tx_queue(netdev, queue_num);
-	ind_bufp = &tx_scrq->ind_buf;
-
-	if (test_bit(0, &adapter->resetting)) {
+	/* If a reset is in progress, drop the packet since
+	 * the scrqs may get torn down. Otherwise use the
+	 * rcu to ensure reset waits for us to complete.
+	 */
+	rcu_read_lock();
+	if (!adapter->tx_queues_active) {
 		dev_kfree_skb_any(skb);
 
 		tx_send_failed++;
@@ -1917,6 +1942,10 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		goto out;
 	}
 
+	tx_scrq = adapter->tx_scrq[queue_num];
+	txq = netdev_get_tx_queue(netdev, queue_num);
+	ind_bufp = &tx_scrq->ind_buf;
+
 	if (ibmvnic_xmit_workarounds(skb, netdev)) {
 		tx_dropped++;
 		tx_send_failed++;
@@ -1924,6 +1953,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		ibmvnic_tx_scrq_flush(adapter, tx_scrq);
 		goto out;
 	}
+
 	if (skb_is_gso(skb))
 		tx_pool = &adapter->tso_pool[queue_num];
 	else
@@ -2078,6 +2108,7 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		netif_carrier_off(netdev);
 	}
 out:
+	rcu_read_unlock();
 	netdev->stats.tx_dropped += tx_dropped;
 	netdev->stats.tx_bytes += tx_bytes;
 	netdev->stats.tx_packets += tx_packets;
@@ -3732,9 +3763,15 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 		    (adapter->req_tx_entries_per_subcrq / 2) &&
 		    __netif_subqueue_stopped(adapter->netdev,
 					     scrq->pool_index)) {
-			netif_wake_subqueue(adapter->netdev, scrq->pool_index);
-			netdev_dbg(adapter->netdev, "Started queue %d\n",
-				   scrq->pool_index);
+			rcu_read_lock();
+			if (adapter->tx_queues_active) {
+				netif_wake_subqueue(adapter->netdev,
+						    scrq->pool_index);
+				netdev_dbg(adapter->netdev,
+					   "Started queue %d\n",
+					   scrq->pool_index);
+			}
+			rcu_read_unlock();
 		}
 	}
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index fa2d607a7b1b..8f5cefb932dd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -1006,11 +1006,14 @@ struct ibmvnic_adapter {
 	struct work_struct ibmvnic_reset;
 	struct delayed_work ibmvnic_delayed_reset;
 	unsigned long resetting;
-	bool napi_enabled, from_passive_init;
-	bool login_pending;
 	/* last device reset time */
 	unsigned long last_reset_time;
 
+	bool napi_enabled;
+	bool from_passive_init;
+	bool login_pending;
+	/* protected by rcu */
+	bool tx_queues_active;
 	bool failover_pending;
 	bool force_reset_recovery;
 
-- 
2.27.0

