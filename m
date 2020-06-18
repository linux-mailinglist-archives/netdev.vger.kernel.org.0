Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407581FE353
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgFRCIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:08:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730634AbgFRBWB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:22:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EABF621D82;
        Thu, 18 Jun 2020 01:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443320;
        bh=CYKwsNRlklR9n7s608J5ivmyKmhR5uw4tV/vcJUoaPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0MItbTM20M6Et9TPE37PD5d7QDeLhJLiDveUaCfgexLVnQzmP0Xum/O/2smNp/f6
         OE7TG3Zmu1AA6u/TPKCpKMzgxN8O9o48vD/t5p48sZXLvli6B+DV01xIIrNnq3txpW
         A30j44HWeUaZXO/6o1YTulygpvFj18p4wBCkqZGg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 255/266] bpf, sockhash: Synchronize delete from bucket list on map free
Date:   Wed, 17 Jun 2020 21:16:20 -0400
Message-Id: <20200618011631.604574-255-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 75e68e5bf2c7fa9d3e874099139df03d5952a3e1 ]

We can end up modifying the sockhash bucket list from two CPUs when a
sockhash is being destroyed (sock_hash_free) on one CPU, while a socket
that is in the sockhash is unlinking itself from it on another CPU
it (sock_hash_delete_from_link).

This results in accessing a list element that is in an undefined state as
reported by KASAN:

| ==================================================================
| BUG: KASAN: wild-memory-access in sock_hash_free+0x13c/0x280
| Write of size 8 at addr dead000000000122 by task kworker/2:1/95
|
| CPU: 2 PID: 95 Comm: kworker/2:1 Not tainted 5.7.0-rc7-02961-ge22c35ab0038-dirty #691
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x97/0xe0
|  ? sock_hash_free+0x13c/0x280
|  __kasan_report.cold+0x5/0x40
|  ? mark_lock+0xbc1/0xc00
|  ? sock_hash_free+0x13c/0x280
|  kasan_report+0x38/0x50
|  ? sock_hash_free+0x152/0x280
|  sock_hash_free+0x13c/0x280
|  bpf_map_free_deferred+0xb2/0xd0
|  ? bpf_map_charge_finish+0x50/0x50
|  ? rcu_read_lock_sched_held+0x81/0xb0
|  ? rcu_read_lock_bh_held+0x90/0x90
|  process_one_work+0x59a/0xac0
|  ? lock_release+0x3b0/0x3b0
|  ? pwq_dec_nr_in_flight+0x110/0x110
|  ? rwlock_bug.part.0+0x60/0x60
|  worker_thread+0x7a/0x680
|  ? _raw_spin_unlock_irqrestore+0x4c/0x60
|  kthread+0x1cc/0x220
|  ? process_one_work+0xac0/0xac0
|  ? kthread_create_on_node+0xa0/0xa0
|  ret_from_fork+0x24/0x30
| ==================================================================

Fix it by reintroducing spin-lock protected critical section around the
code that removes the elements from the bucket on sockhash free.

To do that we also need to defer processing of removed elements, until out
of atomic context so that we can unlink the socket from the map when
holding the sock lock.

Fixes: 90db6d772f74 ("bpf, sockmap: Remove bucket->lock from sock_{hash|map}_free")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200607205229.2389672-3-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ba65c608c228..b22e9f119180 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -861,6 +861,7 @@ static void sock_hash_free(struct bpf_map *map)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct bpf_htab_bucket *bucket;
+	struct hlist_head unlink_list;
 	struct bpf_htab_elem *elem;
 	struct hlist_node *node;
 	int i;
@@ -872,13 +873,31 @@ static void sock_hash_free(struct bpf_map *map)
 	synchronize_rcu();
 	for (i = 0; i < htab->buckets_num; i++) {
 		bucket = sock_hash_select_bucket(htab, i);
-		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
-			hlist_del_rcu(&elem->node);
+
+		/* We are racing with sock_hash_delete_from_link to
+		 * enter the spin-lock critical section. Every socket on
+		 * the list is still linked to sockhash. Since link
+		 * exists, psock exists and holds a ref to socket. That
+		 * lets us to grab a socket ref too.
+		 */
+		raw_spin_lock_bh(&bucket->lock);
+		hlist_for_each_entry(elem, &bucket->head, node)
+			sock_hold(elem->sk);
+		hlist_move_list(&bucket->head, &unlink_list);
+		raw_spin_unlock_bh(&bucket->lock);
+
+		/* Process removed entries out of atomic context to
+		 * block for socket lock before deleting the psock's
+		 * link to sockhash.
+		 */
+		hlist_for_each_entry_safe(elem, node, &unlink_list, node) {
+			hlist_del(&elem->node);
 			lock_sock(elem->sk);
 			rcu_read_lock();
 			sock_map_unref(elem->sk, elem);
 			rcu_read_unlock();
 			release_sock(elem->sk);
+			sock_put(elem->sk);
 			sock_hash_free_elem(htab, elem);
 		}
 	}
-- 
2.25.1

