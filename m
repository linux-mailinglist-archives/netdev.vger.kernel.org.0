Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D245232E518
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbhCEJlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhCEJl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 04:41:29 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4D3C061574;
        Fri,  5 Mar 2021 01:41:28 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id q14so1947532ljp.4;
        Fri, 05 Mar 2021 01:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jrR8mvyeezm9YVlR4aY3Pdm07zd5OUjsWfQdM4GMkIE=;
        b=nG0obGZR/XiDgNQhnskTQscoRcTT9HNK4zziceHpgJJ3HFTmbCYeaJYCU+GbaspO/6
         Nya5ckBW+95miwQ7SdA2M+OlD7RYJGxT8siIGrwSYJpK6iySyAYkwKmt4OAxb8dgbrtr
         WkBPVsIzvenvIdDrWzt6sNyJDWDwYhhZwStFar1n5PjAryj7v4cX510WPnvY+NAqpb9o
         R/xUwFP5z18zn1xjZbo2iOryqN1SRP869k3TYPGvEM7SFEHayBoeH08nhreSoAbShvl1
         o5Ec/wli9BDrUyMmcyAjJ9f0EHNqhWnjtI/XKFMzUTbVIf+aAfP7a6S/bYvrXwC3yxnc
         oEeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jrR8mvyeezm9YVlR4aY3Pdm07zd5OUjsWfQdM4GMkIE=;
        b=sGmzg/wu8aOwoutw+uxsrQ27x2HDD4szv8sDVmN5zV9V9W3ilK7LfR9zSY6pAQAI4S
         HaQmsZAt8S72V7aH/Jnp+c56uLnsn+TCkJLsEo9yL/pzaylXp4kfWSAff6ib4C+Gpka9
         QHRTWXnHQIYm6aN9ZC7CcE2ETCxrzxDqUCX381lfLEPoL6QmbLTgbMgPOfsjo/Qybjd3
         mRWiwX1roDS33+ReAqvo/bsRJs5+bJiuQ9irKhk8Tea9Z/P/OXV9GtL/oGZwI/ZixSG4
         sJVLf/h87FjdEUCilJob7H+SRNqyyghjJ5RoOHRfI8S6jQOk5YVHqZR4b7lCVkfVgXSj
         H6eA==
X-Gm-Message-State: AOAM530VQm+zUiXxtZlMN8lWce6rpR2gdN+D98D7v58iORJgIDqY/aO+
        I88D1s4diesHOe05owOMd4s=
X-Google-Smtp-Source: ABdhPJyPiCLFge0DDKKY8JRZxeFnMrcaj2TjBDeAXNInOx+kPqE4YSNEaMRl9dhaurwsGP475q2cXQ==
X-Received: by 2002:a2e:5747:: with SMTP id r7mr4858745ljd.70.1614937287494;
        Fri, 05 Mar 2021 01:41:27 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id v80sm235371lfa.229.2021.03.05.01.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:41:26 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        maximmi@nvidia.com, andrii@kernel.org, toke@redhat.com,
        will@kernel.org, paulmck@kernel.org, stern@rowland.harvard.edu
Subject: [PATCH bpf-next v2 2/2] libbpf, xsk: add libbpf_smp_store_release libbpf_smp_load_acquire
Date:   Fri,  5 Mar 2021 10:41:13 +0100
Message-Id: <20210305094113.413544-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210305094113.413544-1-bjorn.topel@gmail.com>
References: <20210305094113.413544-1-bjorn.topel@gmail.com>
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

