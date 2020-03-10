Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4120D1803BD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgCJQmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:42:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46893 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgCJQmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:42:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id c19so4443968pfo.13;
        Tue, 10 Mar 2020 09:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=hMrm75bYxh9PjSEHNwverWbTOfm3SuapmCwcq8mLQ4I=;
        b=RRu9L4RCG49kyVGM/81KTOfnKdLX8UVCHXJCNK81VMhZHuVrRbDLVeuftoeQcp/61C
         h8v0v8vfvBzlKiW9GsjJlgzYpNGBgQzq4/Bz/tCBOl1WPhm++VxXM2zGwEOFEX5xRmLL
         bh3/U1dbApk213763QT9MPqnZnWWjA7tVP2H+hIsmlGejD72/Y+rmHaHEbj8mPMPKeKG
         Q1d4zHSkN4MgdrcFaBL9GtNo+GNhmGV8uHeGco4JmIIyMgCYTds9A9Kntmi+ZPnOov3b
         B6t4LamjIyMvXfP4gJJavwUuFvZMtc0Y6A58UBNzDKyCPjzavHcmNRDW8WARCQtCvKqg
         OVxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=hMrm75bYxh9PjSEHNwverWbTOfm3SuapmCwcq8mLQ4I=;
        b=dkMBO5r11oBfEs4N+9XWPA3sk6HimlzC7Q590RDoD/Z8PgqjFJ9pUPy6QAJEJ1plYh
         HNZsydFJ/N4hTLD92PkkwEr6h9vOmMpojycL+raDC5/1UrTP9IFSRBh+HOJb647b5LZG
         U8QfZ2rR/zgoCQx2MMjMObBAlWX3NSnbAUBwWz3aMAUJ6hpQmBt8JDg15kL7RJGXHeGG
         I2x88khKWtEActZn7hH6Wrx8i6XsFjsoB9XRPdsCEcu58nax7ZZ2TT+h4bO4CQ+vCF0/
         VVPoGNiJCXz74UnNIWpXiSS2hNCEI1A71UsyfnOJcZ9HMXSRjGlX0Mv1ubEl/Yt0xu3j
         3GIQ==
X-Gm-Message-State: ANhLgQ1sQwU9zBQ6xHzofKM3W5+Vp9mEXVetxam9W8mxp5I4iUPMcESl
        gTrMeJqoF0rVCg51w6P0xUoO0OOc
X-Google-Smtp-Source: ADFU+vu9fHnXdIRHfu+who+PMBYX2u8OaYyeRVjqCS4SE48qncoIwWpTiIwyTGo36tG2TCQ8YRibdg==
X-Received: by 2002:a62:e318:: with SMTP id g24mr23009448pfh.40.1583858519816;
        Tue, 10 Mar 2020 09:41:59 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f3sm40243201pgg.46.2020.03.10.09.41.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 09:41:59 -0700 (PDT)
Subject: [bpf PATCH] bpf: sockmap,
 remove bucket->lock from sock_{hash|map}_free
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 10 Mar 2020 09:41:48 -0700
Message-ID: <158385850787.30597.8346421465837046618.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bucket->lock is not needed in the sock_hash_free and sock_map_free
calls, in fact it is causing a splat due to being inside rcu block.


| BUG: sleeping function called from invalid context at net/core/sock.c:2935
| in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 62, name: kworker/0:1
| 3 locks held by kworker/0:1/62:
|  #0: ffff88813b019748 ((wq_completion)events){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #1: ffffc900000abe50 ((work_completion)(&map->work)){+.+.}, at: process_one_work+0x1d7/0x5e0
|  #2: ffff8881381f6df8 (&stab->lock){+...}, at: sock_map_free+0x26/0x180
| CPU: 0 PID: 62 Comm: kworker/0:1 Not tainted 5.5.0-04008-g7b083332376e #454
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
| Workqueue: events bpf_map_free_deferred
| Call Trace:
|  dump_stack+0x71/0xa0
|  ___might_sleep.cold+0xa6/0xb6
|  lock_sock_nested+0x28/0x90
|  sock_map_free+0x5f/0x180
|  bpf_map_free_deferred+0x58/0x80
|  process_one_work+0x260/0x5e0
|  worker_thread+0x4d/0x3e0
|  kthread+0x108/0x140
|  ? process_one_work+0x5e0/0x5e0
|  ? kthread_park+0x90/0x90
|  ret_from_fork+0x3a/0x50

The reason we have stab->lock and bucket->locks in sockmap code is to
handle checking EEXIST in update/delete cases. We need to be careful during
an update operation that we check for EEXIST and we need to ensure that the
psock object is not in some partial state of removal/insertion while we do
this. So both map_update_common and sock_map_delete need to guard from being
run together potentially deleting an entry we are checking, etc. But by the
time we get to the tear-down code in sock_{ma[|hash}_free we have already
disconnected the map and we just did synchronize_rcu() in the line above so
no updates/deletes should be in flight. Because of this we can drop the
bucket locks from the map free'ing code, noting no update/deletes can be
in-flight.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/sock_map.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 085cef5..b70c844 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -233,8 +233,11 @@ static void sock_map_free(struct bpf_map *map)
 	struct bpf_stab *stab = container_of(map, struct bpf_stab, map);
 	int i;
 
+	/* After the sync no updates or deletes will be in-flight so it
+	 * is safe to walk map and remove entries without risking a race
+	 * in EEXIST update case.
+	 */
 	synchronize_rcu();
-	raw_spin_lock_bh(&stab->lock);
 	for (i = 0; i < stab->map.max_entries; i++) {
 		struct sock **psk = &stab->sks[i];
 		struct sock *sk;
@@ -248,7 +251,6 @@ static void sock_map_free(struct bpf_map *map)
 			release_sock(sk);
 		}
 	}
-	raw_spin_unlock_bh(&stab->lock);
 
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
@@ -863,10 +865,13 @@ static void sock_hash_free(struct bpf_map *map)
 	struct hlist_node *node;
 	int i;
 
+	/* After the sync no updates or deletes will be in-flight so it
+	 * is safe to walk map and remove entries without risking a race
+	 * in EEXIST update case.
+	 */
 	synchronize_rcu();
 	for (i = 0; i < htab->buckets_num; i++) {
 		bucket = sock_hash_select_bucket(htab, i);
-		raw_spin_lock_bh(&bucket->lock);
 		hlist_for_each_entry_safe(elem, node, &bucket->head, node) {
 			hlist_del_rcu(&elem->node);
 			lock_sock(elem->sk);
@@ -875,7 +880,6 @@ static void sock_hash_free(struct bpf_map *map)
 			rcu_read_unlock();
 			release_sock(elem->sk);
 		}
-		raw_spin_unlock_bh(&bucket->lock);
 	}
 
 	/* wait for psock readers accessing its map link */

