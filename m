Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7E29F769
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgJ2WJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2WJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 18:09:26 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF9AC0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:09:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id q8so4197145ybk.18
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 15:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=1cM6j3pKkngnTbCX3y8IdmZDWyWruLHgBjGmPp/ecPk=;
        b=iJd8+tQgBnYM/lmhDcjsMUy7GHqZGButn+ucz/xowxFTnUuOEFw53/5q+BjNufNaVv
         1y4KdC8+NqbEo7u3HDm3pLM0bHbAGdJJBp7JfFxT4uGu6T0vWcvBbnKE6soQsZ20WDkr
         bNjGGQD+0C0uXWgBLSdFl81nyuaa+f1NEJTxeA2HDU+3UdHi9jQM65PfDfq8dLHbnJeN
         qMb58Xb9Dcp/I3iL2MiwE85Oo1RvqJZgJyQ8v0BK//cj8eBy3IKpwhFYSUj6fxndEkv9
         Dhwb2BzJ64b4aModvvGFO36XVjlteRRX/AD3/qq/020Uanc8QQGD1S6IEYXm7mTlGwgh
         rs/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=1cM6j3pKkngnTbCX3y8IdmZDWyWruLHgBjGmPp/ecPk=;
        b=ISuR5OhSiBGUDqNOd+jWWpYs8+1FUFEODuACnY6dkxvCGNtB2nW+K+irJx20/QiUNe
         vlc4gMeeCcKovL8ExRAMChA54xqenvKWpmNFt91oVFZtvbkLBuH1rr5QIAk8JeNO8mMz
         XfXr0LogODqnQyJhVCxmT8/gLwup39QBECIPTkzOIjhB0QfQUH1Iwry5i873U0K8JsMD
         Kawtp2u8o+3XaOKzV39RLYWMrpu9BCnsyC6ZbOeVrQ2Y+FkXep8oWf4T8+rKLXw52eOq
         q1MxMIs4ZwgKggONXAFnw1+27W94wBmaQnLPxbWJ6AeUZ5gPGtPInCDeGt634sNFAb5z
         I26w==
X-Gm-Message-State: AOAM531OMfB4PG0HeyQLXRekvODm7OoC92ihKwtRyeTViaqu8wS0y9Wc
        G0KoEGCu8QCSsWD40SU7dxzVBBSxu6e2
X-Google-Smtp-Source: ABdhPJzADNuhOKyKxFcG37Lep6XsfQ5pKWZYgCHXVwIYTS/EuifKeuinSSnF1r4Zxn+2uk6ZrWXjHkN0gL7/
Sender: "irogers via sendgmr" <irogers@irogers.svl.corp.google.com>
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:2:f693:9fff:fef4:4583])
 (user=irogers job=sendgmr) by 2002:a25:d8a:: with SMTP id 132mr9311332ybn.7.1604009365495;
 Thu, 29 Oct 2020 15:09:25 -0700 (PDT)
Date:   Thu, 29 Oct 2020 15:09:19 -0700
Message-Id: <20201029220919.481279-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] libbpf hashmap: Avoid undefined behavior in hash_bits
From:   Ian Rogers <irogers@google.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If bits is 0, the case when the map is empty, then the >> is the size of
the register which is undefined behavior - on x86 it is the same as a
shift by 0.
Avoid calling hash_bits with bits == 0 by adding additional empty
hashmap tests.

Suggested-by: Andrii Nakryiko <andriin@fb.com>,
Suggested-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/lib/bpf/hashmap.c | 12 ++++++++++--
 tools/lib/bpf/hashmap.h | 12 ++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
index 3c20b126d60d..41e6f636101e 100644
--- a/tools/lib/bpf/hashmap.c
+++ b/tools/lib/bpf/hashmap.c
@@ -156,7 +156,7 @@ int hashmap__insert(struct hashmap *map, const void *key, void *value,
 		    const void **old_key, void **old_value)
 {
 	struct hashmap_entry *entry;
-	size_t h;
+	size_t h = 0;
 	int err;
 
 	if (old_key)
@@ -164,7 +164,9 @@ int hashmap__insert(struct hashmap *map, const void *key, void *value,
 	if (old_value)
 		*old_value = NULL;
 
-	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
+	if (map->buckets)
+		h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
+
 	if (strategy != HASHMAP_APPEND &&
 	    hashmap_find_entry(map, key, h, NULL, &entry)) {
 		if (old_key)
@@ -208,6 +210,9 @@ bool hashmap__find(const struct hashmap *map, const void *key, void **value)
 	struct hashmap_entry *entry;
 	size_t h;
 
+	if (!map->buckets)
+		return false;
+
 	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
 	if (!hashmap_find_entry(map, key, h, NULL, &entry))
 		return false;
@@ -223,6 +228,9 @@ bool hashmap__delete(struct hashmap *map, const void *key,
 	struct hashmap_entry **pprev, *entry;
 	size_t h;
 
+	if (!map->buckets)
+		return false;
+
 	h = hash_bits(map->hash_fn(key, map->ctx), map->cap_bits);
 	if (!hashmap_find_entry(map, key, h, &pprev, &entry))
 		return false;
diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
index d9b385fe808c..61236437876e 100644
--- a/tools/lib/bpf/hashmap.h
+++ b/tools/lib/bpf/hashmap.h
@@ -174,17 +174,17 @@ bool hashmap__find(const struct hashmap *map, const void *key, void **value);
  * @key: key to iterate entries for
  */
 #define hashmap__for_each_key_entry(map, cur, _key)			    \
-	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
-					     map->cap_bits);		    \
-		     map->buckets ? map->buckets[bkt] : NULL; });	    \
+	for (cur = map->buckets						    \
+		     ? map->buckets[hash_bits(map->hash_fn((_key), map->ctx), map->cap_bits)] \
+		     : NULL;						    \
 	     cur;							    \
 	     cur = cur->next)						    \
 		if (map->equal_fn(cur->key, (_key), map->ctx))
 
 #define hashmap__for_each_key_entry_safe(map, cur, tmp, _key)		    \
-	for (cur = ({ size_t bkt = hash_bits(map->hash_fn((_key), map->ctx),\
-					     map->cap_bits);		    \
-		     cur = map->buckets ? map->buckets[bkt] : NULL; });	    \
+	for (cur = map->buckets						    \
+		     ? map->buckets[hash_bits(map->hash_fn((_key), map->ctx), map->cap_bits)] \
+		     : NULL;						    \
 	     cur && ({ tmp = cur->next; true; });			    \
 	     cur = tmp)							    \
 		if (map->equal_fn(cur->key, (_key), map->ctx))
-- 
2.29.1.341.ge80a0c044ae-goog

