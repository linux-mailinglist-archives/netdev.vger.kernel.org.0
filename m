Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4402DA14A
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503067AbgLNUQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:16:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503051AbgLNUML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:12:11 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45872C061793;
        Mon, 14 Dec 2020 12:11:31 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id f16so17011024otl.11;
        Mon, 14 Dec 2020 12:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yygU5NAXWVy/uMevreNO6dRLr+BDbLez0blcakg1cFs=;
        b=o3HtlNau90LyxaDbf4q3WrIQ5NJOxBKtTWVEsFyG6i7g5jg62EXWKNPnVURdf0vWkR
         A8gf5eJQucjyyXCX7+1+pOAAZPjKDHiD8nq81CnC+8VI/XJb9/ehW2HltU6EoAgYDMS8
         hcIx8q/2jHzdWIoQVUTHCL0onQklHltK3nXNVj+DeCNtL5gIjEum3BPlzfHLshsdV8Dt
         Cjm9PUkBIKvcp0jMGDoAUBsLnezElVRZPWEg/r349wgScm+HV5Sf8sNDWHpmSga+pKdV
         csolezKEoTihqPZ2l/wfeC+q+mCAPRZk9zyHKONHw2T4u1uwv6SFuHjQ52Z8R0qvubYH
         p81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yygU5NAXWVy/uMevreNO6dRLr+BDbLez0blcakg1cFs=;
        b=UNxiQ/HLoI+yajGWzvChW6BjnC7jTEXqRSeodw3qMm/BosKYweR31bnV66NPMMJOBV
         t9PZnhNAX7mLEDQLR9D6PwG5Am91JYp0h+MDP0luJiPv9vFbFS6ZSen2+YY0IVOIIVAz
         Q0rCwvVaAAA796T+NMqhkeAvRi+zaRXhtHShbR+VFYxvQdkH7O5gT3M2/u9kD2rnxbdi
         JbZ9Ze2CkY05c9Ty/mCQitebJ+A9lchtketih6170GUkWUqeuzoqgI2UIcI8qR5FAX29
         yaUiV/0a+8Txv4++D7GiK9ULTXxF8TAY87X5PY7skqFiyTUjEg1ZNCgxkI6cO+nkepip
         czZw==
X-Gm-Message-State: AOAM531A6ZcbN8Phzk/RXeDl6OziauJEGxD7qI34rfcXFRGq6VHJ+f2n
        7wJQlSnfvWluLVmJ5knKLvLUpd5IQ1HUhw==
X-Google-Smtp-Source: ABdhPJyQ6MvXody+z+SEzCHIYo/RXfDxe1Hcq+dCQzigpgoBmeVIieqOlljnGlaU6MImq3TlkRL6vQ==
X-Received: by 2002:a9d:6414:: with SMTP id h20mr20677067otl.28.1607976690422;
        Mon, 14 Dec 2020 12:11:30 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:3825:1c64:a3d3:108])
        by smtp.gmail.com with ESMTPSA id h26sm3905850ots.9.2020.12.14.12.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:11:29 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next v2 1/5] bpf: use index instead of hash for map_locked[]
Date:   Mon, 14 Dec 2020 12:11:14 -0800
Message-Id: <20201214201118.148126-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Commit 20b6cc34ea74 ("bpf: Avoid hashtab deadlock with map_locked")
introduced a percpu counter map_locked to bail out NMI case. It uses
the hash of each bucket for indexing, which requires callers of
htab_lock_bucket()/htab_unlock_bucket() to pass it in. But hash value
is not always available, especially when we traverse the whole hash
table where we do not have keys to compute the hash. We can just
compute the index of each bucket with its address and use index
instead.

This is a prerequisite for the following timeout map patch.

Cc: Song Liu <songliubraving@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dongdong Wang <wangdongdong.6@bytedance.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 kernel/bpf/hashtab.c | 57 +++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 7e848200cd26..f0b7b54fa3a8 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -156,16 +156,17 @@ static void htab_init_buckets(struct bpf_htab *htab)
 }
 
 static inline int htab_lock_bucket(const struct bpf_htab *htab,
-				   struct bucket *b, u32 hash,
-				   unsigned long *pflags)
+				   struct bucket *b, unsigned long *pflags)
 {
 	unsigned long flags;
+	unsigned int index;
 
-	hash = hash & HASHTAB_MAP_LOCK_MASK;
+	index = b - htab->buckets;
+	index &= HASHTAB_MAP_LOCK_MASK;
 
 	migrate_disable();
-	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
-		__this_cpu_dec(*(htab->map_locked[hash]));
+	if (unlikely(__this_cpu_inc_return(*(htab->map_locked[index])) != 1)) {
+		__this_cpu_dec(*(htab->map_locked[index]));
 		migrate_enable();
 		return -EBUSY;
 	}
@@ -180,15 +181,17 @@ static inline int htab_lock_bucket(const struct bpf_htab *htab,
 }
 
 static inline void htab_unlock_bucket(const struct bpf_htab *htab,
-				      struct bucket *b, u32 hash,
-				      unsigned long flags)
+				      struct bucket *b, unsigned long flags)
 {
-	hash = hash & HASHTAB_MAP_LOCK_MASK;
+	unsigned int index;
+
+	index = b - htab->buckets;
+	index &= HASHTAB_MAP_LOCK_MASK;
 	if (htab_use_raw_lock(htab))
 		raw_spin_unlock_irqrestore(&b->raw_lock, flags);
 	else
 		spin_unlock_irqrestore(&b->lock, flags);
-	__this_cpu_dec(*(htab->map_locked[hash]));
+	__this_cpu_dec(*(htab->map_locked[index]));
 	migrate_enable();
 }
 
@@ -710,7 +713,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 	b = __select_bucket(htab, tgt_l->hash);
 	head = &b->head;
 
-	ret = htab_lock_bucket(htab, b, tgt_l->hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return false;
 
@@ -720,7 +723,7 @@ static bool htab_lru_map_delete_node(void *arg, struct bpf_lru_node *node)
 			break;
 		}
 
-	htab_unlock_bucket(htab, b, tgt_l->hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 
 	return l == tgt_l;
 }
@@ -1019,7 +1022,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		 */
 	}
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return ret;
 
@@ -1062,7 +1065,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	}
 	ret = 0;
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1100,7 +1103,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		return -ENOMEM;
 	memcpy(l_new->key + round_up(map->key_size, 8), value, map->value_size);
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return ret;
 
@@ -1121,7 +1124,7 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	ret = 0;
 
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 
 	if (ret)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
@@ -1156,7 +1159,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return ret;
 
@@ -1181,7 +1184,7 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 	}
 	ret = 0;
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1221,7 +1224,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 			return -ENOMEM;
 	}
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return ret;
 
@@ -1245,7 +1248,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	}
 	ret = 0;
 err:
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
 	return ret;
@@ -1283,7 +1286,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return ret;
 
@@ -1296,7 +1299,7 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 		ret = -ENOENT;
 	}
 
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 	return ret;
 }
 
@@ -1318,7 +1321,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	b = __select_bucket(htab, hash);
 	head = &b->head;
 
-	ret = htab_lock_bucket(htab, b, hash, &flags);
+	ret = htab_lock_bucket(htab, b, &flags);
 	if (ret)
 		return ret;
 
@@ -1329,7 +1332,7 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	else
 		ret = -ENOENT;
 
-	htab_unlock_bucket(htab, b, hash, flags);
+	htab_unlock_bucket(htab, b, flags);
 	if (l)
 		bpf_lru_push_free(&htab->lru, &l->lru_node);
 	return ret;
@@ -1480,7 +1483,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 	head = &b->head;
 	/* do not grab the lock unless need it (bucket_cnt > 0). */
 	if (locked) {
-		ret = htab_lock_bucket(htab, b, batch, &flags);
+		ret = htab_lock_bucket(htab, b, &flags);
 		if (ret)
 			goto next_batch;
 	}
@@ -1500,7 +1503,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		/* Note that since bucket_cnt > 0 here, it is implicit
 		 * that the locked was grabbed, so release it.
 		 */
-		htab_unlock_bucket(htab, b, batch, flags);
+		htab_unlock_bucket(htab, b, flags);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
 		goto after_loop;
@@ -1511,7 +1514,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		/* Note that since bucket_cnt > 0 here, it is implicit
 		 * that the locked was grabbed, so release it.
 		 */
-		htab_unlock_bucket(htab, b, batch, flags);
+		htab_unlock_bucket(htab, b, flags);
 		rcu_read_unlock();
 		bpf_enable_instrumentation();
 		kvfree(keys);
@@ -1564,7 +1567,7 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
 		dst_val += value_size;
 	}
 
-	htab_unlock_bucket(htab, b, batch, flags);
+	htab_unlock_bucket(htab, b, flags);
 	locked = false;
 
 	while (node_to_free) {
-- 
2.25.1

