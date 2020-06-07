Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEF51F0FE5
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 22:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgFGUwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 16:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727797AbgFGUwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 16:52:35 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F58C08C5C3
        for <netdev@vger.kernel.org>; Sun,  7 Jun 2020 13:52:35 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n24so16025587ejd.0
        for <netdev@vger.kernel.org>; Sun, 07 Jun 2020 13:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a7cTe9lHJ0Tcm8GY6e2Wo0eV9aS0hOnp7kZnr703qjg=;
        b=lLGRHVd04oD1XH2Wl4Kf+DHbyMtzVE7KdSOBORw1MN90BfytknCNC6+qc2i0cLN5w3
         Wz+Nx2rOe0sgBViBnnKhP9VAueG3IDJy2Z3NuafqePxekSmkOrKk/Le26209bhWY88Tp
         2tsUm6R7xxo/XuJT0AE45fcSWmqXAmajVbSmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a7cTe9lHJ0Tcm8GY6e2Wo0eV9aS0hOnp7kZnr703qjg=;
        b=IMctHydKZEYUrNEnVBy3N33uDgwiVEDZXQosYoSzmacmMwp0wMduL1lDoR7DJAtpZA
         3ety0pZMun7AoRcP4lZEAVn5mwnAQfskyjqDU80c51Xd1dbNFt8qMHogsN2m4qQm6TJO
         oJck4Nr7IAGWma8LUbU7PJQyC1ajJ6uoM3Ly7JlxiU91MUGZ0H2tABOTj8R6O49DV0XE
         FxxjF2uarKrj1i4VEJuZtzJkzEegcLnt7c098QUhcItp6WLwgO62osDvuyGSC4Uc1Bh6
         osjgVCMC8W810uLcQn5gmP8mNvFXvDogKcxrOAo8OEDQ9mJoZF4242PSilGxKLJQDwvk
         GOZw==
X-Gm-Message-State: AOAM532p25ezzrJOaXbn7ItP0PQun9B6aDjM+oqQOoiJlCjALnTU+hXH
        1WczrgsfUGYo0LwSzwt2FkBj4g==
X-Google-Smtp-Source: ABdhPJzH83ytLClaKstlaYyUAnnSJMkc3anhVa2ePqbxqIDgiN1URyA9uRxsVK3zYjNmu1C5NqvgWg==
X-Received: by 2002:a17:906:4ecf:: with SMTP id i15mr18967826ejv.515.1591563153669;
        Sun, 07 Jun 2020 13:52:33 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j5sm11096865edk.53.2020.06.07.13.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2020 13:52:33 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH bpf 2/2] bpf, sockhash: Synchronize delete from bucket list on map free
Date:   Sun,  7 Jun 2020 22:52:29 +0200
Message-Id: <20200607205229.2389672-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200607205229.2389672-1-jakub@cloudflare.com>
References: <20200607205229.2389672-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/core/sock_map.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index ea46f07a22d8..17a40a947546 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1013,6 +1013,7 @@ static void sock_hash_free(struct bpf_map *map)
 {
 	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
 	struct bpf_htab_bucket *bucket;
+	struct hlist_head unlink_list;
 	struct bpf_htab_elem *elem;
 	struct hlist_node *node;
 	int i;
@@ -1024,13 +1025,31 @@ static void sock_hash_free(struct bpf_map *map)
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
2.25.4

