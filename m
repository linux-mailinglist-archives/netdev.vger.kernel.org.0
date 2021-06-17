Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB30C3ABE05
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 23:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhFQVaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 17:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232361AbhFQVaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 17:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623965278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+C1vvBih2DDvMDumUaYzwO9FAV6D2CItQN3YHn0G7w=;
        b=UyVLYk+R40TPN2gjxxJ6AnCrY6BqKrtvb/0N0vPT7aiuiIw/e9n0o+5Jhq00VvueZDnc5v
        ANOLoNNYA3sOIM+A0ZDWza8+EMrc8CWERzq9bOFS9Vw2Lt2nZxhSYw4Q910PAv0E9Fc2J4
        /bZRNSO5Pd3OMB3LK6crZ5N4dmaDIm0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-iO4mQaxmNCWliZExLPJ2JQ-1; Thu, 17 Jun 2021 17:27:57 -0400
X-MC-Unique: iO4mQaxmNCWliZExLPJ2JQ-1
Received: by mail-ed1-f71.google.com with SMTP id i22-20020a05640242d6b0290392e051b029so2389052edc.11
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 14:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+C1vvBih2DDvMDumUaYzwO9FAV6D2CItQN3YHn0G7w=;
        b=mzqpfMZWJt4rf6n4SwvfZW+VUbb1nXzTkGv6cez9Y5Ih+Km+qvideACGqZmi1kj7qY
         BrfkvvNUKtpQtb8kJ7Tk4Zy++4FFYJzg4//ec2hAucSkhbhAxaCARWdxOxGmcvsLGIop
         +mkmseOVgC9P/ASuDXF1ntRm6wFjnymWmwID6J0QMRLwXH8pYKgQR9p1J2FynqDnwL6U
         aNJxZv91eSCDcDP28xTxmus3ynUwRN7mXJHLsjgq7IwbLH3DHhQ+nhK6R5YwsvrwVMVQ
         NzgvhnnW3BlKS8JoyEaPTFmfNvbkNdGZcMW5OxQbNtfGcI+K/p5JMsBiO94qX7p4zkHA
         NnLQ==
X-Gm-Message-State: AOAM5306xf4sNrQvE5HaYjzPhqU2r2Hq3v0KuTUejnSqPatBFWWo1ZdG
        nq5zuM0/6BteMxCjNN1oCKfZjcX4kt4KhVn/+L209UwUQEW08/qzZkKkZLd3oYpxfPnzK5eo5lC
        uIfTBHECcwnPWJfSQ
X-Received: by 2002:a05:6402:51d1:: with SMTP id r17mr451089edd.91.1623965276166;
        Thu, 17 Jun 2021 14:27:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuJMoUy1hXydwhfMQBzqzr6BrEg7lbvkkFSNeTBiotlbBoHDl0qp+bpeu9UXkB60eR8jNOsQ==
X-Received: by 2002:a05:6402:51d1:: with SMTP id r17mr451071edd.91.1623965276019;
        Thu, 17 Jun 2021 14:27:56 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t18sm5186222edw.47.2021.06.17.14.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:27:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7E6BC18071E; Thu, 17 Jun 2021 23:27:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v3 02/16] bpf: allow RCU-protected lookups to happen from bh context
Date:   Thu, 17 Jun 2021 23:27:34 +0200
Message-Id: <20210617212748.32456-3-toke@redhat.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617212748.32456-1-toke@redhat.com>
References: <20210617212748.32456-1-toke@redhat.com>
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
index 544773970dbc..e880f6bb6f28 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -28,7 +28,7 @@
  */
 BPF_CALL_2(bpf_map_lookup_elem, struct bpf_map *, map, void *, key)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	return (unsigned long) map->ops->map_lookup_elem(map, key);
 }
 
@@ -44,7 +44,7 @@ const struct bpf_func_proto bpf_map_lookup_elem_proto = {
 BPF_CALL_4(bpf_map_update_elem, struct bpf_map *, map, void *, key,
 	   void *, value, u64, flags)
 {
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 	return map->ops->map_update_elem(map, key, value, flags);
 }
 
@@ -61,7 +61,7 @@ const struct bpf_func_proto bpf_map_update_elem_proto = {
 
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

