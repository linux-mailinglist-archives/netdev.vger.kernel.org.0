Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6411E220599
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 08:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgGOG6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 02:58:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7855 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727790AbgGOG6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 02:58:41 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BB49B181E6BED70C4B42;
        Wed, 15 Jul 2020 14:58:35 +0800 (CST)
Received: from huawei.com (10.179.179.12) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Jul 2020
 14:58:26 +0800
From:   guodeqing <geffrey.guo@huawei.com>
To:     <wensong@linux-vs.org>
CC:     <horms@verge.net.au>, <ja@ssi.bg>, <pablo@netfilter.org>,
        <kadlec@netfilter.org>, <fw@strlen.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <geffrey.guo@huawei.com>
Subject: [PATCH] ipvs: fix the connection sync failed in some cases
Date:   Wed, 15 Jul 2020 14:53:47 +0800
Message-ID: <1594796027-66136-1-git-send-email-geffrey.guo@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.179.179.12]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sync_thread_backup only checks sk_receive_queue is empty or not,
there is a situation which cannot sync the connection entries when
sk_receive_queue is empty and sk_rmem_alloc is larger than sk_rcvbuf,
the sync packets are dropped in __udp_enqueue_schedule_skb, this is
because the packets in reader_queue is not read, so the rmem is
not reclaimed.

Here I add the check of whether the reader_queue of the udp sock is
empty or not to solve this problem.

Fixes: 7c13f97ffde6 ("udp: do fwd memory scheduling on dequeue")
Reported-by: zhouxudong <zhouxudong8@huawei.com>
Signed-off-by: guodeqing <geffrey.guo@huawei.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 605e0f6..abe8d63 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1717,6 +1717,8 @@ static int sync_thread_backup(void *data)
 {
 	struct ip_vs_sync_thread_data *tinfo = data;
 	struct netns_ipvs *ipvs = tinfo->ipvs;
+	struct sock *sk = tinfo->sock->sk;
+	struct udp_sock *up = udp_sk(sk);
 	int len;
 
 	pr_info("sync thread started: state = BACKUP, mcast_ifn = %s, "
@@ -1724,12 +1726,14 @@ static int sync_thread_backup(void *data)
 		ipvs->bcfg.mcast_ifn, ipvs->bcfg.syncid, tinfo->id);
 
 	while (!kthread_should_stop()) {
-		wait_event_interruptible(*sk_sleep(tinfo->sock->sk),
-			 !skb_queue_empty(&tinfo->sock->sk->sk_receive_queue)
-			 || kthread_should_stop());
+		wait_event_interruptible(*sk_sleep(sk),
+					 !skb_queue_empty(&sk->sk_receive_queue) ||
+					 !skb_queue_empty(&up->reader_queue) ||
+					 kthread_should_stop());
 
 		/* do we have data now? */
-		while (!skb_queue_empty(&(tinfo->sock->sk->sk_receive_queue))) {
+		while (!skb_queue_empty(&sk->sk_receive_queue) ||
+		       !skb_queue_empty(&up->reader_queue)) {
 			len = ip_vs_receive(tinfo->sock, tinfo->buf,
 					ipvs->bcfg.sync_maxlen);
 			if (len <= 0) {
-- 
2.7.4

