Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA8F2D6C5D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 01:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393108AbgLKAHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 19:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392129AbgLKAHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 19:07:40 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8239CC0613D3;
        Thu, 10 Dec 2020 16:07:00 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id b18so6712920ots.0;
        Thu, 10 Dec 2020 16:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yygU5NAXWVy/uMevreNO6dRLr+BDbLez0blcakg1cFs=;
        b=b45FKa4AizelnbIIikqeyA+T2oEE5F2LkTBSUQ7udKqSP8N6hVy9uSqoL8BjCb7sWX
         RkHPN5BLCqTJ+TIzoHxTHXdMhyK0GwTKzWdfI+YWmZa/uM7X13DTA+uV6hEB5YpKN19V
         vWwt9VVI1hukiTpHAfbdej06O0p6fRkF/BE/zvqL3vSJxLvTxswfrV1ZtgwqyKjaYIPf
         +rvDae6FwHwhWoKm+Oe29NRyBcj9XJu/KhFhs5ePGEyFW+7IpRFN3Z27yNW7IWq2+T3x
         pxne+/EemslkEOsELEqPxTq1t9aS0J8cErnc0v+JKEE55D0YHAo01U8sz0KEpsB12RC/
         H2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yygU5NAXWVy/uMevreNO6dRLr+BDbLez0blcakg1cFs=;
        b=fdAr+YHjqNuK97gfOTyxAc3/2Kag9dP064emXCnws2RiDoXhe4wxbSlJkJoYP4leFa
         WwgTaeO47suPW0rj6eoW16YBEBWSJm1ZXZ4Ms9WYMEagI7OgcoTrhQA7qVRiXaZc+4fu
         4RLzPrChVJEY2t7MTaXcj+sg+RcRrJXwK0Ir7dgxcuPhT9mIUfbYRGpx1yjBiFVmAmv7
         j9yUx9CrvyBW9tODyUZ14AddbEMFDn2pjRtdMqlieuEAZ8fna98bwb26yG1Qg/jGaXrt
         8472jMWn8R9jUmxi76egazjl9zZWmTb2wkaTTtu8fwgx5dcaJhPbtL2ZxRsL19nbe/I3
         mKmw==
X-Gm-Message-State: AOAM533t3+TH1+qBqIul8j/qNcypkYWSLhE7X2LiQPRSBDYCZpoSdwIi
        I1zVJMEXCfUBs9AFt1ypkEE2H54SRoAPRg==
X-Google-Smtp-Source: ABdhPJzkqkqjEX+kMdUzI2grAiUJqfkbrcLPnELfYKoNgt9yy/YX2/NG+dN164UxCIUs98+Xemn2Gw==
X-Received: by 2002:a9d:875:: with SMTP id 108mr7930671oty.164.1607645219612;
        Thu, 10 Dec 2020 16:06:59 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:4819:cc94:4d6e:dad2])
        by smtp.gmail.com with ESMTPSA id l21sm1543570otd.0.2020.12.10.16.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 16:06:58 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Subject: [Patch bpf-next 1/3] bpf: use index instead of hash for map_locked[]
Date:   Thu, 10 Dec 2020 16:06:47 -0800
Message-Id: <20201211000649.236635-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
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

