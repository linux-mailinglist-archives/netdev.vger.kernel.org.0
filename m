Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92F63F0ED8
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhHRXw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbhHRXw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 19:52:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26F0C0613CF
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:52:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t101-20020a25aaee0000b0290578c0c455b2so4654250ybi.13
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 16:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dNzVzG00YuL9BPubaFReOEmMNwvCEpVxzU7LeS/yc5w=;
        b=K4KV3UcU5YxbQ1Qg4BbCZXyoiODQYzv/uqz/faq2JQf1e/KVZI3U0R9m9Fxdx0cff5
         CasFwoKrR4WBAQ0c1TZOVIxk2/4CfUyMDZnvs1nX55Sw8SSdweXNid0r5FBSSM25VhGo
         oOobBVGTZZUqlxkX17PTJ2yB+NafV4zRdCTDf7auL4Whh+/QXXyw3rrvTnLA1EMxeWvK
         ttSHlFLBsRNeL9vQ3JTMSk/UJX2XS6z+FZPdLl2XJXQj8pDuopwXpSzTWXPG0/ZJFLfK
         2RVIHCw3Bs3wbYUuQaMeqy7XnK4ZWpMDSrnl/MJJcG3c/Z2TTh6xh1cTMdUm8EW0jTsC
         aPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dNzVzG00YuL9BPubaFReOEmMNwvCEpVxzU7LeS/yc5w=;
        b=cXxbkxq9bNMt4Jd6qUzcY7m06KVGJKHtvYjl2nrgGLhdvTls8crqt2BksP1fNL5e7g
         /M2rMYboQajDftaqSrAlw1dGkhMvouSakfqyPQCFeweBrQ4Ey0KAyT0lVQWFJr5o1DH2
         IlPxvDi1amHFZL2Xb5F4fbMCqBYhgYF4q2O2N/T9OEN5PGzyEfZIldbwdnnZaCUnVdpw
         jO961w5eRWK9X4afgJSVgoKLws5nvGZYki0u3By172XvptScWsZ4Zoi0l0InLAbQyCjj
         w4nnBzaEsZOnaO4C0yyeBjmPwe3YbqpTnS2er1P6xiG/f8VpwjVs62PLCjWG4hOG0RDi
         ///w==
X-Gm-Message-State: AOAM531494Z2mAz0UXGBfVDxQiafpujhpX5kHs2WHmdCH4cEgkwb7Lsc
        3+8lHYcGR2jtq8CSU9l4tuSUVmCJmBNSndzk+v8MpKBa6l2zCuLk69nNh6sWcLKA/nInj/1jgOT
        fwCeSYYtfeGP1op6Lzw3XU5m40jf0UcQ+hi/eMmbaND5waHF55vuDsA==
X-Google-Smtp-Source: ABdhPJwq/fLcYMJf7f4rPMWxBqhc4/YvPJqHBBwjUW1EphvmK0ERzdTWW/WB1aCVUWqjUYZoZtij67Q=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:7401:ef23:e119:5cbc])
 (user=sdf job=sendgmr) by 2002:a25:420b:: with SMTP id p11mr15255535yba.377.1629330740916;
 Wed, 18 Aug 2021 16:52:20 -0700 (PDT)
Date:   Wed, 18 Aug 2021 16:52:16 -0700
In-Reply-To: <20210818235216.1159202-1-sdf@google.com>
Message-Id: <20210818235216.1159202-2-sdf@google.com>
Mime-Version: 1.0
References: <20210818235216.1159202-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH bpf-next v3 2/2] bpf: use kvmalloc for map keys in syscalls
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as previous patch but for the keys. memdup_bpfptr is renamed
to kvmemdup_bpfptr (and converted to kvmalloc).

v3:
* kvmemdup_bpfptr and copy_from_bpfptr (Daniel Borkmann)

Signed-off-by: Stanislav Fomichev <sdf@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 include/linux/bpfptr.h | 12 ++++++++++--
 kernel/bpf/syscall.c   | 34 +++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
index 5cdeab497cb3..546e27fc6d46 100644
--- a/include/linux/bpfptr.h
+++ b/include/linux/bpfptr.h
@@ -62,9 +62,17 @@ static inline int copy_to_bpfptr_offset(bpfptr_t dst, size_t offset,
 	return copy_to_sockptr_offset((sockptr_t) dst, offset, src, size);
 }
 
-static inline void *memdup_bpfptr(bpfptr_t src, size_t len)
+static inline void *kvmemdup_bpfptr(bpfptr_t src, size_t len)
 {
-	return memdup_sockptr((sockptr_t) src, len);
+	void *p = kvmalloc(len, GFP_USER | __GFP_NOWARN);
+
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+	if (copy_from_bpfptr(p, src, len)) {
+		kvfree(p);
+		return ERR_PTR(-EFAULT);
+	}
+	return p;
 }
 
 static inline long strncpy_from_bpfptr(char *dst, bpfptr_t src, size_t count)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 075f650d297a..4e50c0bfdb7d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1013,7 +1013,7 @@ int __weak bpf_stackmap_copy(struct bpf_map *map, void *key, void *value)
 static void *__bpf_copy_key(void __user *ukey, u64 key_size)
 {
 	if (key_size)
-		return memdup_user(ukey, key_size);
+		return vmemdup_user(ukey, key_size);
 
 	if (ukey)
 		return ERR_PTR(-EINVAL);
@@ -1024,7 +1024,7 @@ static void *__bpf_copy_key(void __user *ukey, u64 key_size)
 static void *___bpf_copy_key(bpfptr_t ukey, u64 key_size)
 {
 	if (key_size)
-		return memdup_bpfptr(ukey, key_size);
+		return kvmemdup_bpfptr(ukey, key_size);
 
 	if (!bpfptr_is_null(ukey))
 		return ERR_PTR(-EINVAL);
@@ -1093,7 +1093,7 @@ static int map_lookup_elem(union bpf_attr *attr)
 free_value:
 	kvfree(value);
 free_key:
-	kfree(key);
+	kvfree(key);
 err_put:
 	fdput(f);
 	return err;
@@ -1153,7 +1153,7 @@ static int map_update_elem(union bpf_attr *attr, bpfptr_t uattr)
 free_value:
 	kvfree(value);
 free_key:
-	kfree(key);
+	kvfree(key);
 err_put:
 	fdput(f);
 	return err;
@@ -1205,7 +1205,7 @@ static int map_delete_elem(union bpf_attr *attr)
 	bpf_enable_instrumentation();
 	maybe_wait_bpf_programs(map);
 out:
-	kfree(key);
+	kvfree(key);
 err_put:
 	fdput(f);
 	return err;
@@ -1247,7 +1247,7 @@ static int map_get_next_key(union bpf_attr *attr)
 	}
 
 	err = -ENOMEM;
-	next_key = kmalloc(map->key_size, GFP_USER);
+	next_key = kvmalloc(map->key_size, GFP_USER);
 	if (!next_key)
 		goto free_key;
 
@@ -1270,9 +1270,9 @@ static int map_get_next_key(union bpf_attr *attr)
 	err = 0;
 
 free_next_key:
-	kfree(next_key);
+	kvfree(next_key);
 free_key:
-	kfree(key);
+	kvfree(key);
 err_put:
 	fdput(f);
 	return err;
@@ -1299,7 +1299,7 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
-	key = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
 
@@ -1326,7 +1326,7 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
 
-	kfree(key);
+	kvfree(key);
 	return err;
 }
 
@@ -1357,13 +1357,13 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
-	key = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	key = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!key)
 		return -ENOMEM;
 
 	value = kvmalloc(value_size, GFP_USER | __GFP_NOWARN);
 	if (!value) {
-		kfree(key);
+		kvfree(key);
 		return -ENOMEM;
 	}
 
@@ -1385,7 +1385,7 @@ int generic_map_update_batch(struct bpf_map *map,
 		err = -EFAULT;
 
 	kvfree(value);
-	kfree(key);
+	kvfree(key);
 	return err;
 }
 
@@ -1419,13 +1419,13 @@ int generic_map_lookup_batch(struct bpf_map *map,
 	if (put_user(0, &uattr->batch.count))
 		return -EFAULT;
 
-	buf_prevkey = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	buf_prevkey = kvmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
 	if (!buf_prevkey)
 		return -ENOMEM;
 
 	buf = kvmalloc(map->key_size + value_size, GFP_USER | __GFP_NOWARN);
 	if (!buf) {
-		kfree(buf_prevkey);
+		kvfree(buf_prevkey);
 		return -ENOMEM;
 	}
 
@@ -1485,7 +1485,7 @@ int generic_map_lookup_batch(struct bpf_map *map,
 		err = -EFAULT;
 
 free_buf:
-	kfree(buf_prevkey);
+	kvfree(buf_prevkey);
 	kvfree(buf);
 	return err;
 }
@@ -1575,7 +1575,7 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
 free_value:
 	kvfree(value);
 free_key:
-	kfree(key);
+	kvfree(key);
 err_put:
 	fdput(f);
 	return err;
-- 
2.33.0.rc2.250.ged5fa647cd-goog

