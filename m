Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC97A3EEF5D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238300AbhHQPqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbhHQPqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 11:46:35 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF55BC0613C1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:46:01 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f8-20020a2585480000b02905937897e3daso20639256ybn.2
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 08:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lNhDLK5X+HI8/KKYOncoy8HlwWwZCMsAcseeTB6ZMlU=;
        b=noFiPtuxPimiZMlQhYytzSBx9S5waYGbZfSUcfUd67xPDodjI20APHtg1JLdEUNxG+
         727Ia59qnZatVBratAICxwalBwTUU3ZE6avj5O9vAVPE/vHRpF+61qJiJ9qx9Ku6gQkH
         DbO8n4s4sCgjTmmxl+xDZWiW8cG+32xzvleTSGsxuVTN+iJLN3svBFp5XlunmRH3AZo3
         tNGyeCNS1QKEPLYblqy2tMLETSEl3CIIFkFWHup2Dwg5/DgcHXD73bkMdhBixp6Xtx8X
         l/+ZOt8pa5gEIt5nCpBSOEKLSUrwGSaqEF1SDwsv+zLviqpKGTmVxsopmrkgBv+4QMdG
         Bceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lNhDLK5X+HI8/KKYOncoy8HlwWwZCMsAcseeTB6ZMlU=;
        b=p7oVhilfjGyDK1R28w4d0n4XnVLXCif0Eb7vLCthgJ3JFbZw+rG8Tv39q43I5ytula
         f2QoS0/eup3FHGPhuCn+WUYLTDWBt5WCw0Hxo+MZ7vhcsQgvzxx5AmuaBdmPuyWenqyX
         AP3q6vVchulR926ODB0Ax14kvhUlWdE/ExoitEnzzghrY1xtixl8w24nt4tAC7+IQD0g
         OoDgmNCLY3eDaR1SLUtCi3OiGapC5s8fEjjOe/lXY7Xg/ZdPFbBYG4+9aa5TckYeXdjq
         nI3MwGoHbo7QoGap9CpHaKuaviCcX0KylNpvr/7zRt3lZafYH06enct3BUUhsDlSz6iX
         EErA==
X-Gm-Message-State: AOAM5333d8bLrt+vP/iFgtovFYs3zrEaT77HX1qi1hzmi0I2UqGnAYG9
        8AEGPIAq/rpXYFNES/KdbuHGYBp5CNg6TIksbPc8EBqpqVsdMNuoIZlEzxHszPOenfSx+e8od6n
        ZpSZMF9M4rz3+Un9GMB3U9eQW4dn3AcjLu9wVhaOC1cOdmJEuiugEvQ==
X-Google-Smtp-Source: ABdhPJxOFj1wgxv+4Heod5c/Rr5pLLl0Gbx15EsbHA1TETxlbWC+9LuVFN0Pt+/VLD9x9bRtooZUF0A=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:e3f2:64ab:dda:c30f])
 (user=sdf job=sendgmr) by 2002:a25:764e:: with SMTP id r75mr5021506ybc.263.1629215161138;
 Tue, 17 Aug 2021 08:46:01 -0700 (PDT)
Date:   Tue, 17 Aug 2021 08:45:56 -0700
In-Reply-To: <20210817154556.92901-1-sdf@google.com>
Message-Id: <20210817154556.92901-2-sdf@google.com>
Mime-Version: 1.0
References: <20210817154556.92901-1-sdf@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH bpf-next v2 2/2] bpf: use kvmalloc for map keys in syscalls
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as previous patch but for the keys. memdup_bpfptr is renamed
to vmemdup_bpfptr (and converted to kvmalloc).

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpfptr.h | 12 ++++++++++--
 kernel/bpf/syscall.c   | 34 +++++++++++++++++-----------------
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
index 5cdeab497cb3..84eeffb4316a 100644
--- a/include/linux/bpfptr.h
+++ b/include/linux/bpfptr.h
@@ -62,9 +62,17 @@ static inline int copy_to_bpfptr_offset(bpfptr_t dst, size_t offset,
 	return copy_to_sockptr_offset((sockptr_t) dst, offset, src, size);
 }
 
-static inline void *memdup_bpfptr(bpfptr_t src, size_t len)
+static inline void *vmemdup_bpfptr(bpfptr_t src, size_t len)
 {
-	return memdup_sockptr((sockptr_t) src, len);
+	void *p = kvmalloc(len, GFP_USER | __GFP_NOWARN);
+
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+	if (copy_from_sockptr(p, (sockptr_t) src, len)) {
+		kvfree(p);
+		return ERR_PTR(-EFAULT);
+	}
+	return p;
 }
 
 static inline long strncpy_from_bpfptr(char *dst, bpfptr_t src, size_t count)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 075f650d297a..ac230f4234cd 100644
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
+		return vmemdup_bpfptr(ukey, key_size);
 
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
2.33.0.rc1.237.g0d66db33f3-goog

