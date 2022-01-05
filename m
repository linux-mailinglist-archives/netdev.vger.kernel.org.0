Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AD0484CA1
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiAEDDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiAEDDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:03:52 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878B5C061761;
        Tue,  4 Jan 2022 19:03:52 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id ie13so215973pjb.1;
        Tue, 04 Jan 2022 19:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lcFqDTjeFGBwrZNHRnNh9af0ehtq+KJ9lCMfNLza1NE=;
        b=CuRpkgBnmNWJkVle0EcTSB3MZ6woiP1lAc33eEWdhMadZC/YMZI7eWBgWqfyagzP6p
         dgJtZUbZSRnO+nVmnPJuprFzKjzzucFDTK4HQ7fgdLplNJ9BzuGh1+uYcHAqD1BjrpNC
         PHW1JpXE9Moq6sKom9n9SZGmt8DRahGMCnMBeOd4Mmts6DwbLljVkHAP30WUsA2317MY
         SVCAhZcpwwLYPLg2tKfWNd8zacXA9Tee83qegyOIFcI6glHy3r0yWDhxdM6mzmbRn5PT
         qYVgzWTPhGBGZxStTBBU9QCMZ703kUXIfAHLvI+3yIl108Rb2cUsLrtFv1Tt9w7TVRcL
         Y1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lcFqDTjeFGBwrZNHRnNh9af0ehtq+KJ9lCMfNLza1NE=;
        b=hoG5D612JC6gIx8D77HJ6SNrwssk96GO17xnHK7We6faIRYohh6Zq4qXf4/HznF6mT
         o9FA49omFUmzRGCot8FGFzYbvtxx4fC5rFKDXQ3gGIF+R0qkL7J49jxKGGLLlK1w+dvL
         ixaJaLcbBwzio4cffMqFEKiqGpL0ZnwmevlEcP0URB9UrAX2PfQJF25vhliGm3XheOM3
         /6FoI/9IRxXAPWJjomXV2GXk7bsoyicU3coSX3xQXb6wN9H+JzWbfSwPmtJ+tZ1rLtO/
         hVoDzuDlHbgtvE3q4byZQNa2jUAp+M9f1eC43KO0ZUhe8JSmSr3auDHKM7muqXCCqhrZ
         MWAA==
X-Gm-Message-State: AOAM533wno7NSm9LQf6od3rJUKbbWKV+uFtwnxYUyqD+nDR61Y+l0Ukt
        6z5yNXNdOMmlm/2OwrlWyw==
X-Google-Smtp-Source: ABdhPJxIo+SONptg1STxL0lc/7tny0XTUob1ArKCEwwXH1A7fK9ux1xBkyE5TTu0mQu0cvAF/2tuPA==
X-Received: by 2002:a17:90b:3903:: with SMTP id ob3mr1720071pjb.178.1641351832027;
        Tue, 04 Jan 2022 19:03:52 -0800 (PST)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id i9sm34280818pgc.27.2022.01.04.19.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:03:51 -0800 (PST)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ppenkov@google.com,
        sdf@google.com, haoluo@google.com
Cc:     Joe Burton <jevburton@google.com>
Subject: [PATCH bpf-next v4 1/3] bpf: Add map tracing functions and call sites
Date:   Wed,  5 Jan 2022 03:03:43 +0000
Message-Id: <20220105030345.3255846-2-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
In-Reply-To: <20220105030345.3255846-1-jevburton.kernel@gmail.com>
References: <20220105030345.3255846-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add two functions that fentry/fexit/fmod_ret programs can attach to:
	bpf_map_trace_update_elem
	bpf_map_trace_delete_elem
These functions have the same arguments as bpf_map_{update,delete}_elem.

Invoke these functions from the following map types:
	BPF_MAP_TYPE_ARRAY
	BPF_MAP_TYPE_PERCPU_ARRAY
	BPF_MAP_TYPE_HASH
	BPF_MAP_TYPE_PERCPU_HASH
	BPF_MAP_TYPE_LRU_HASH
	BPF_MAP_TYPE_LRU_PERCPU_HASH

The only guarantee about these functions is that they are invoked before
the corresponding action occurs. Other conditions may prevent the
corresponding action from occurring after the function is invoked.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 kernel/bpf/Makefile    |  2 +-
 kernel/bpf/arraymap.c  |  4 +++-
 kernel/bpf/hashtab.c   | 20 +++++++++++++++++++-
 kernel/bpf/map_trace.c | 17 +++++++++++++++++
 kernel/bpf/map_trace.h | 19 +++++++++++++++++++
 5 files changed, 59 insertions(+), 3 deletions(-)
 create mode 100644 kernel/bpf/map_trace.c
 create mode 100644 kernel/bpf/map_trace.h

diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index c1a9be6a4b9f..0cf38dab339a 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -9,7 +9,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
 obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
 obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
-obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
+obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o map_trace.o
 obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index c7a5be3bf8be..e9e7bd27ffad 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -13,6 +13,7 @@
 #include <linux/rcupdate_trace.h>
 
 #include "map_in_map.h"
+#include "map_trace.h"
 
 #define ARRAY_CREATE_FLAG_MASK \
 	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
@@ -329,7 +330,8 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
 			copy_map_value(map, val, value);
 		check_and_free_timer_in_array(array, val);
 	}
-	return 0;
+
+	return bpf_map_trace_update_elem(map, key, value, map_flags);
 }
 
 int bpf_percpu_array_update(struct bpf_map *map, void *key, void *value,
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index d29af9988f37..8fb19ed707e8 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -13,6 +13,7 @@
 #include "percpu_freelist.h"
 #include "bpf_lru_list.h"
 #include "map_in_map.h"
+#include "map_trace.h"
 
 #define HTAB_CREATE_FLAG_MASK						\
 	(BPF_F_NO_PREALLOC | BPF_F_NO_COMMON_LRU | BPF_F_NUMA_NODE |	\
@@ -1055,7 +1056,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 			copy_map_value_locked(map,
 					      l_old->key + round_up(key_size, 8),
 					      value, false);
-			return 0;
+			return bpf_map_trace_update_elem(map, key, value,
+							 map_flags);
 		}
 		/* fall through, grab the bucket lock and lookup again.
 		 * 99.9% chance that the element won't be found,
@@ -1109,6 +1111,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
 	ret = 0;
 err:
 	htab_unlock_bucket(htab, b, hash, flags);
+	if (!ret)
+		ret = bpf_map_trace_update_elem(map, key, value, map_flags);
 	return ret;
 }
 
@@ -1133,6 +1137,10 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 		/* unknown flags */
 		return -EINVAL;
 
+	ret = bpf_map_trace_update_elem(map, key, value, map_flags);
+	if (unlikely(ret))
+		return ret;
+
 	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
 		     !rcu_read_lock_bh_held());
 
@@ -1182,6 +1190,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
 	else if (l_old)
 		htab_lru_push_free(htab, l_old);
 
+	if (!ret)
+		ret = bpf_map_trace_update_elem(map, key, value, map_flags);
 	return ret;
 }
 
@@ -1237,6 +1247,8 @@ static int __htab_percpu_map_update_elem(struct bpf_map *map, void *key,
 	ret = 0;
 err:
 	htab_unlock_bucket(htab, b, hash, flags);
+	if (!ret)
+		ret = bpf_map_trace_update_elem(map, key, value, map_flags);
 	return ret;
 }
 
@@ -1304,6 +1316,8 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 	htab_unlock_bucket(htab, b, hash, flags);
 	if (l_new)
 		bpf_lru_push_free(&htab->lru, &l_new->lru_node);
+	if (!ret)
+		ret = bpf_map_trace_update_elem(map, key, value, map_flags);
 	return ret;
 }
 
@@ -1354,6 +1368,8 @@ static int htab_map_delete_elem(struct bpf_map *map, void *key)
 	}
 
 	htab_unlock_bucket(htab, b, hash, flags);
+	if (!ret)
+		ret = bpf_map_trace_delete_elem(map, key);
 	return ret;
 }
 
@@ -1390,6 +1406,8 @@ static int htab_lru_map_delete_elem(struct bpf_map *map, void *key)
 	htab_unlock_bucket(htab, b, hash, flags);
 	if (l)
 		htab_lru_push_free(htab, l);
+	if (!ret)
+		ret = bpf_map_trace_delete_elem(map, key);
 	return ret;
 }
 
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
new file mode 100644
index 000000000000..336848e83daf
--- /dev/null
+++ b/kernel/bpf/map_trace.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2022 Google */
+#include "map_trace.h"
+
+noinline int bpf_map_trace_update_elem(struct bpf_map *map, void *key,
+				       void *value, u64 map_flags)
+{
+	return 0;
+}
+ALLOW_ERROR_INJECTION(bpf_map_trace_update_elem, ERRNO);
+
+noinline int bpf_map_trace_delete_elem(struct bpf_map *map, void *key)
+{
+	return 0;
+}
+ALLOW_ERROR_INJECTION(bpf_map_trace_delete_elem, ERRNO);
+
diff --git a/kernel/bpf/map_trace.h b/kernel/bpf/map_trace.h
new file mode 100644
index 000000000000..ae943af9e2a5
--- /dev/null
+++ b/kernel/bpf/map_trace.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2022 Google */
+#ifndef __BPF_MAP_TRACE_H_
+#define __BPF_MAP_TRACE_H_
+
+#include <linux/bpf.h>
+
+/*
+ * Map tracing hooks. They are called from some, but not all, bpf map types.
+ * For those map types which call them, the only guarantee is that they are
+ * called after the corresponding action (bpf_map_update_elem, etc.) takes
+ * effect.
+ */
+int bpf_map_trace_update_elem(struct bpf_map *map, void *key,
+			      void *value, u64 map_flags);
+
+int bpf_map_trace_delete_elem(struct bpf_map *map, void *key);
+
+#endif  // __BPF_MAP_TRACE_H_
-- 
2.34.1.448.ga2b2bfdf31-goog

