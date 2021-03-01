Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB7A327C80
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhCAKpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbhCAKoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:44:07 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F12C061788;
        Mon,  1 Mar 2021 02:43:27 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id e2so11653027ljo.7;
        Mon, 01 Mar 2021 02:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jrR8mvyeezm9YVlR4aY3Pdm07zd5OUjsWfQdM4GMkIE=;
        b=EiN5yrdgNq5YGG4uBLMUOX219WwxH5kcLwiAPLi4+r3LGyQYWCVl+kIVXW3HoDKfN5
         4eU4IwLRB3dUlWhcyGG99+8ySx5zyOaHM9FEjaUOBUHz1l0LBTytIJ8at2mSexWLVPXP
         K4ZfDgRbrYb8DF9I3MpnZo/o5LDbOrc8tQc1OqxA4saPZ5E5r4bP0xs64u4Pe8QByRTU
         /eXAqBD/sFLPCrSXQI/XB25UL/JrRbZNLwCqkakTpbPX1bc0iNfuiaO9c9KidajI99Ql
         XCKNQSPIuhxt8nJpSuVah2u1uWvXnJ33ELlEv+x8Nt/lX4QhxVI0LCxt9ehgyYxarZYM
         wLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jrR8mvyeezm9YVlR4aY3Pdm07zd5OUjsWfQdM4GMkIE=;
        b=k2et3OvCL1W5tNp28Iv+v7AFMLJS8tnKINiIsDnzpN+yYMBCvZbxyeJFR8FyVXXVso
         SeYk95PdcgQ4vxDhCLmKYHq77YuCWN2MR3E5DR/pd6UuCoTP0noP05BvHZykCdXGyHFD
         gg0JrG3hQumV9L9dLErTIf2I9Lsw9bSKdMFgyF1Vh4M6mdZNipfShMH9vLA6nmB/XZCo
         XygaQEovinkB0fahYHLOK8D1rn3gZy3edqx/+PVy2Ka9DCe3f2D3pFzwxGkb++d9gbCv
         9fR1uumTr/TvbpPxn/2QlDKiylNZNliW+24K7jsUi+cQwXWfppKyXPXyNp4iWi6ca9kf
         y7Lg==
X-Gm-Message-State: AOAM531vCPxpubsu2JnxOUHJ6VyaqilWvUCrL/ptKP3i2NfnjTkxSNdV
        B0ZlqMkTJwFRJcAilR8pO2I=
X-Google-Smtp-Source: ABdhPJyt1Er2THZ4KtoMfRS5teT3b5MB184Ed2+VHmhl0wbAXTIe8dl7WL4AlSyb+lFFiULYoJ1A8w==
X-Received: by 2002:a05:651c:2113:: with SMTP id a19mr8892070ljq.147.1614595405635;
        Mon, 01 Mar 2021 02:43:25 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w26sm2247492lfr.186.2021.03.01.02.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 02:43:25 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org
Subject: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire
Date:   Mon,  1 Mar 2021 11:43:18 +0100
Message-Id: <20210301104318.263262-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210301104318.263262-1-bjorn.topel@gmail.com>
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Now that the AF_XDP rings have load-acquire/store-release semantics,
move libbpf to that as well.

The library-internal libbpf_smp_{load_acquire,store_release} are only
valid for 32-bit words on ARM64.

Also, remove the barriers that are no longer in use.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/libbpf_util.h | 72 +++++++++++++++++++++++++------------
 tools/lib/bpf/xsk.h         | 17 +++------
 2 files changed, 55 insertions(+), 34 deletions(-)

diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
index 59c779c5790c..94a0d7bb6f3c 100644
--- a/tools/lib/bpf/libbpf_util.h
+++ b/tools/lib/bpf/libbpf_util.h
@@ -5,6 +5,7 @@
 #define __LIBBPF_LIBBPF_UTIL_H
 
 #include <stdbool.h>
+#include <linux/compiler.h>
 
 #ifdef __cplusplus
 extern "C" {
@@ -15,29 +16,56 @@ extern "C" {
  * application that uses libbpf.
  */
 #if defined(__i386__) || defined(__x86_64__)
-# define libbpf_smp_rmb() asm volatile("" : : : "memory")
-# define libbpf_smp_wmb() asm volatile("" : : : "memory")
-# define libbpf_smp_mb() \
-	asm volatile("lock; addl $0,-4(%%rsp)" : : : "memory", "cc")
-/* Hinders stores to be observed before older loads. */
-# define libbpf_smp_rwmb() asm volatile("" : : : "memory")
+# define libbpf_smp_store_release(p, v)					\
+	do {								\
+		asm volatile("" : : : "memory");			\
+		WRITE_ONCE(*p, v);					\
+	} while (0)
+# define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1 = READ_ONCE(*p);			\
+		asm volatile("" : : : "memory");			\
+		___p1;							\
+	})
 #elif defined(__aarch64__)
-# define libbpf_smp_rmb() asm volatile("dmb ishld" : : : "memory")
-# define libbpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
-# define libbpf_smp_mb() asm volatile("dmb ish" : : : "memory")
-# define libbpf_smp_rwmb() libbpf_smp_mb()
-#elif defined(__arm__)
-/* These are only valid for armv7 and above */
-# define libbpf_smp_rmb() asm volatile("dmb ish" : : : "memory")
-# define libbpf_smp_wmb() asm volatile("dmb ishst" : : : "memory")
-# define libbpf_smp_mb() asm volatile("dmb ish" : : : "memory")
-# define libbpf_smp_rwmb() libbpf_smp_mb()
-#else
-/* Architecture missing native barrier functions. */
-# define libbpf_smp_rmb() __sync_synchronize()
-# define libbpf_smp_wmb() __sync_synchronize()
-# define libbpf_smp_mb() __sync_synchronize()
-# define libbpf_smp_rwmb() __sync_synchronize()
+# define libbpf_smp_store_release(p, v)					\
+		asm volatile ("stlr %w1, %0" : "=Q" (*p) : "r" (v) : "memory")
+# define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1;					\
+		asm volatile ("ldar %w0, %1"				\
+			      : "=r" (___p1) : "Q" (*p) : "memory");	\
+		__p1;							\
+	})
+#elif defined(__riscv)
+# define libbpf_smp_store_release(p, v)					\
+	do {								\
+		asm volatile ("fence rw,w" : : : "memory");		\
+		WRITE_ONCE(*p, v);					\
+	} while (0)
+# define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1 = READ_ONCE(*p);			\
+		asm volatile ("fence r,rw" : : : "memory");		\
+		___p1;							\
+	})
+#endif
+
+#ifndef libbpf_smp_store_release
+#define libbpf_smp_store_release(p, v)					\
+	do {								\
+		__sync_synchronize();					\
+		WRITE_ONCE(*p, v);					\
+	} while (0)
+#endif
+
+#ifndef libbpf_smp_load_acquire
+#define libbpf_smp_load_acquire(p)					\
+	({								\
+		typeof(*p) ___p1 = READ_ONCE(*p);			\
+		__sync_synchronize();					\
+		___p1;							\
+	})
 #endif
 
 #ifdef __cplusplus
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index e9f121f5d129..a9fdea87b5cd 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -96,7 +96,8 @@ static inline __u32 xsk_prod_nb_free(struct xsk_ring_prod *r, __u32 nb)
 	 * this function. Without this optimization it whould have been
 	 * free_entries = r->cached_prod - r->cached_cons + r->size.
 	 */
-	r->cached_cons = *r->consumer + r->size;
+	r->cached_cons = libbpf_smp_load_acquire(r->consumer);
+	r->cached_cons += r->size;
 
 	return r->cached_cons - r->cached_prod;
 }
@@ -106,7 +107,7 @@ static inline __u32 xsk_cons_nb_avail(struct xsk_ring_cons *r, __u32 nb)
 	__u32 entries = r->cached_prod - r->cached_cons;
 
 	if (entries == 0) {
-		r->cached_prod = *r->producer;
+		r->cached_prod = libbpf_smp_load_acquire(r->producer);
 		entries = r->cached_prod - r->cached_cons;
 	}
 
@@ -129,9 +130,7 @@ static inline void xsk_ring_prod__submit(struct xsk_ring_prod *prod, __u32 nb)
 	/* Make sure everything has been written to the ring before indicating
 	 * this to the kernel by writing the producer pointer.
 	 */
-	libbpf_smp_wmb();
-
-	*prod->producer += nb;
+	libbpf_smp_store_release(prod->producer, *prod->producer + nb);
 }
 
 static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __u32 *idx)
@@ -139,11 +138,6 @@ static inline __u32 xsk_ring_cons__peek(struct xsk_ring_cons *cons, __u32 nb, __
 	__u32 entries = xsk_cons_nb_avail(cons, nb);
 
 	if (entries > 0) {
-		/* Make sure we do not speculatively read the data before
-		 * we have received the packet buffers from the ring.
-		 */
-		libbpf_smp_rmb();
-
 		*idx = cons->cached_cons;
 		cons->cached_cons += entries;
 	}
@@ -161,9 +155,8 @@ static inline void xsk_ring_cons__release(struct xsk_ring_cons *cons, __u32 nb)
 	/* Make sure data has been read before indicating we are done
 	 * with the entries by updating the consumer pointer.
 	 */
-	libbpf_smp_rwmb();
+	libbpf_smp_store_release(cons->consumer, *cons->consumer + nb);
 
-	*cons->consumer += nb;
 }
 
 static inline void *xsk_umem__get_data(void *umem_area, __u64 addr)
-- 
2.27.0

