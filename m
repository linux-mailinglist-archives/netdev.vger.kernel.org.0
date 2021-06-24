Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C73B3373
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhFXQIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:08:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22694 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229464AbhFXQIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:08:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624550776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rcNRjPgryjNmiMXDsjGjnEaUR6gkIAj0Q9ptYwP/G2w=;
        b=NF4uQ8pHBuDFLKW2Sw8qu98XSSpvwewG0ZBXQXyaSN/+qFujtapLc/QA6mt1O1REU6nJ8p
        soqwgI6vSDHGMd3/p1UkwxqxU10jGnpj7km4l7IcjpWN8fIYCuSh3+JKcwCxJG/KctGu24
        m/dD9GtwA4FUvY6F4Lpisw0DNEfQjPA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-6jIArpHJPJq1xT6Pg8Kf7w-1; Thu, 24 Jun 2021 12:06:13 -0400
X-MC-Unique: 6jIArpHJPJq1xT6Pg8Kf7w-1
Received: by mail-ed1-f69.google.com with SMTP id cb4-20020a0564020b64b02903947455afa5so3596852edb.9
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 09:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rcNRjPgryjNmiMXDsjGjnEaUR6gkIAj0Q9ptYwP/G2w=;
        b=Fjb2/l1XeqUiUVxlNO3fAilrxwvHYuYJkbz2Zva4/flvMgScML9LuVZzAwMoFCCX5E
         2m+HhEHyDrwcU5YWtCCkuBfOPkoZiMVznDbez+FrhglVikBWO/fiYgYqXKcXuU6VC+kb
         IgKaqWz6TU/puFgIPW3/TMm75SVnsAhh1qErHxpahtyGYt28Lu8EO8kf5N8uoP9cx9JR
         ygcirqvz3/4Gh1s77hwjh96RBQk82gwWuKblLdqpTHTR0vFxiU4ae/2iGdxMtRHDu5A6
         y/BCyBJY2LBoRzZuSusmxoHNEoEZ85lB9HyGJSYkGRzE4s5sUAbIBbpY/c3VGrX95y6z
         36FA==
X-Gm-Message-State: AOAM532rHeyb2Bo1G8WCr/NhOjinV2fekQXIPVPeCPVpJ2+MRCYBQNPH
        3VGQrhlx3jtqt2C37MbBL18MUimAcE1qw2nUPDLifhfnDy/Vspxa6UIP2hHBN1cFvvYRjKT+wYF
        MOKZZfS7hw0I30QEn
X-Received: by 2002:a17:906:70cf:: with SMTP id g15mr5992920ejk.366.1624550772343;
        Thu, 24 Jun 2021 09:06:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXLWPCYjtJs8PWczQKfLhdebEoVn5ofDAARrFjqLwV5oNXsvuVt1jSqNQQLcPjdFiQD8422A==
X-Received: by 2002:a17:906:70cf:: with SMTP id g15mr5992875ejk.366.1624550771974;
        Thu, 24 Jun 2021 09:06:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id dn7sm2136513edb.29.2021.06.24.09.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:06:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 44BDF180735; Thu, 24 Jun 2021 18:06:10 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 04/19] bpf: allow RCU-protected lookups to happen from bh context
Date:   Thu, 24 Jun 2021 18:05:54 +0200
Message-Id: <20210624160609.292325-5-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210624160609.292325-1-toke@redhat.com>
References: <20210624160609.292325-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP programs are called from a NAPI poll context, which means the RCU
reference liveness is ensured by local_bh_disable(). Add
rcu_read_lock_bh_held() as a condition to the RCU checks for map lookups so
lockdep understands that the dereferences are safe from inside *either* an
rcu_read_lock() section *or* a local_bh_disable() section. While both
bh_disabled and rcu_read_lock() provide RCU protection, they are
semantically distinct, so we need both conditions to prevent lockdep
complaints.

This change is done in preparation for removing the redundant
rcu_read_lock()s from drivers.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 kernel/bpf/hashtab.c  | 21 ++++++++++++++-------
 kernel/bpf/helpers.c  |  6 +++---
 kernel/bpf/lpm_trie.c |  6 ++++--
 3 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 6f6681b07364..72c58cc516a3 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -596,7 +596,8 @@ static void *__htab_map_lookup_elem(struct bpf_map *map, void *key)
 	struct htab_elem *l;
 	u32 hash, key_size;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
@@ -989,7 +990,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
@@ -1082,7 +1084,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
@@ -1148,7 +1151,8 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
@@ -1202,7 +1206,8 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 		/* unknown flags */
 		return -EINVAL;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
@@ -1276,7 +1281,8 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	u32 hash, key_size;
 	int ret;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
@@ -1311,7 +1317,8 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	u32 hash, key_size;
 	int ret;
 
-	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
+		     !rcu_read_lock_bh_held());
 
 	key_size = map->key_size;
 
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a2f1f15ce432..62cf00383910 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -29,7 +29,7 @@
  */
 BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	return (unsigned long) map->ops->map_lookup_elem(map, key);
 }
 
@@ -45,7 +45,7 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	return map->ops->map_update_elem(map, key, value, flags);
 }
 
@@ -62,7 +62,7 @@ const struct bpf_func_proto bpf_map_update_elem_proto = {
 
 BPF_CALL_2(bpf_map_delete_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	return map->ops->map_delete_elem(map, key);
 }
 
diff --git a/kernel/bpf/lpm_trie.c b/kernel/bpf/lpm_trie.c
index 1b7b8a6f34ee..423549d2c52e 100644
--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -232,7 +232,8 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 
 	/* Start walking the trie from the root node ... */
 
-	for (node = rcu_dereference(trie->root); node;) {
+	for (node = rcu_dereference_check(trie->root, rcu_read_lock_bh_held());
+	     node;) {
 		unsigned int next_bit;
 		size_t matchlen;
 
@@ -264,7 +265,8 @@ static void *trie_lookup_elem(struct bpf_map *map, void *_key)
 		 * traverse down.
 		 */
 		next_bit = extract_bit(key->data, node->prefixlen);
-		node = rcu_dereference(node->child[next_bit]);
+		node = rcu_dereference_check(node->child[next_bit],
+					     rcu_read_lock_bh_held());
 	}
 
 	if (!found)
-- 
2.32.0

