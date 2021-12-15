Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF26C475B03
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243320AbhLOOt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243237AbhLOOt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:49:27 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0115CC061574;
        Wed, 15 Dec 2021 06:49:26 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o20so76091560eds.10;
        Wed, 15 Dec 2021 06:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QfUUna1hBkPwin+B6qYw3DhSbrwH5M5ZIY+5z6qWCO0=;
        b=K5n6p1hT0XJDe4nb1QmCDDCYs/hC89LG1+1HwI0H1KqSog3dRai3e5xEq7c6V8TKql
         sC7vouJ2ylObdh8J0Q52Sqxyb7tEwiY8t8yM1wAgyFHK30DjYuUv5cAqyq+B2xgaRhYy
         yB7qe+adFXfw3I9IZgWyEkNIRszsGL+YcMlSQngLTqTf43k2mTzGYtCodHJh0MTuTHeO
         IhMaWnz7Uca+kvtgd64tBekd33eIRf00zj3q20yAk1KB65UPUlLEiYphp454CwJrN9A5
         q3y5xlq+RRzpGIuGzsfUKRvIx6Et5nkr3PN06ocrDhVZ2KH9WJGEBykZN0+3lV8P9e64
         cFWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QfUUna1hBkPwin+B6qYw3DhSbrwH5M5ZIY+5z6qWCO0=;
        b=ACUgLio/WogSmEfPWc08CexnCFpvZQfDHBl+WLrT0v/5HKrrfVONAikUAw1+/eDjsS
         aWI/hY8rLthzqZLhkUZnq6ASLTIsNS+yyr/quHfoOW3nPGEoGEiPIeagjDMuE1S3mqUB
         gjxPxmwXdh4ByVlH7VSsWKoNbhwMYvaxH2IHRiXlCXyf1tgVzFJkS541jMXF5QNl7EZb
         G7bqfBCPG3NSBRS52JwoYe0wwwhLKsD33/WV8muTUNliv1ed0AatRQKYNJQx5MJOnG+h
         /G6J1AFVKV6now0Mn3mhje/Hme6SN06J0WMlEB4ORF3d5eO8p1dZx5JI9FdeTVIEFBCH
         l/1A==
X-Gm-Message-State: AOAM530LBeKgFPfURlCk8LVdq0jXrLDRHjUzOgi6swcWpfnT1WsGdnLT
        VvdhQ4Ygz3MKrrFEIm82iO1Ewu7zxdg=
X-Google-Smtp-Source: ABdhPJyc6SeHIXFi6hLc2m24/mreBmvaCKcOi5IbkQV9fXyMw3VUcBYXQ1rGxA+LN/CGqT87Gt0mtw==
X-Received: by 2002:a17:906:544f:: with SMTP id d15mr11392395ejp.373.1639579763730;
        Wed, 15 Dec 2021 06:49:23 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id hg19sm788245ejc.1.2021.12.15.06.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 06:49:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
Date:   Wed, 15 Dec 2021 14:49:18 +0000
Message-Id: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add per socket fast path for not enabled BPF skb filtering, which sheds
a nice chunk of send/recv overhead when affected. Testing udp with 128
byte payload and/or zerocopy with any payload size showed 2-3%
improvement in requests/s on the tx side using fast NICs across network,
and around 4% for dummy device. Same goes for rx, not measured, but
numbers should be relatable.
In my understanding, this should affect a good share of machines, and at
least it includes my laptops and some checked servers.

The core of the problem is that even though there is
cgroup_bpf_enabled_key guarding from __cgroup_bpf_run_filter_skb()
overhead, there are cases where we have several cgroups and loading a
BPF program to one also makes all others to go through the slow path
even when they don't have any BPF attached. It's even worse, because
apparently systemd or some other early init loads some BPF and so
triggers exactly this situation for normal networking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: replace bitmask appoach with empty_prog_array (suggested by Martin)
v3: add "bpf_" prefix to empty_prog_array (Martin)

 include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
 include/linux/bpf.h        | 13 +++++++++++++
 kernel/bpf/cgroup.c        | 18 ++----------------
 kernel/bpf/core.c          | 16 ++++------------
 4 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 11820a430d6c..c6dacdbdf565 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -219,11 +219,28 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				     void *value, u64 flags);
 
+static inline bool
+__cgroup_bpf_prog_array_is_empty(struct cgroup_bpf *cgrp_bpf,
+				 enum cgroup_bpf_attach_type type)
+{
+	struct bpf_prog_array *array = rcu_access_pointer(cgrp_bpf->effective[type]);
+
+	return array == &bpf_empty_prog_array.hdr;
+}
+
+#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
+({									       \
+	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
+									       \
+	!__cgroup_bpf_prog_array_is_empty(&__cgrp->bpf, (atype));	       \
+})
+
 /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
 ({									      \
 	int __ret = 0;							      \
-	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))		      \
+	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&		      \
+	    CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS)) 	      \
 		__ret = __cgroup_bpf_run_filter_skb(sk, skb,		      \
 						    CGROUP_INET_INGRESS); \
 									      \
@@ -235,9 +252,10 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(CGROUP_INET_EGRESS) && sk && sk == skb->sk) { \
 		typeof(sk) __sk = sk_to_full_sk(sk);			       \
-		if (sk_fullsock(__sk))					       \
+		if (sk_fullsock(__sk) &&				       \
+		    CGROUP_BPF_TYPE_ENABLED(__sk, CGROUP_INET_EGRESS))	       \
 			__ret = __cgroup_bpf_run_filter_skb(__sk, skb,	       \
-						      CGROUP_INET_EGRESS); \
+						      CGROUP_INET_EGRESS);     \
 	}								       \
 	__ret;								       \
 })
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e7a163a3146b..0d2195c6fb2a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1161,6 +1161,19 @@ struct bpf_prog_array {
 	struct bpf_prog_array_item items[];
 };
 
+struct bpf_empty_prog_array {
+	struct bpf_prog_array hdr;
+	struct bpf_prog *null_prog;
+};
+
+/* to avoid allocating empty bpf_prog_array for cgroups that
+ * don't have bpf program attached use one global 'bpf_empty_prog_array'
+ * It will not be modified the caller of bpf_prog_array_alloc()
+ * (since caller requested prog_cnt == 0)
+ * that pointer should be 'freed' by bpf_prog_array_free()
+ */
+extern struct bpf_empty_prog_array bpf_empty_prog_array;
+
 struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags);
 void bpf_prog_array_free(struct bpf_prog_array *progs);
 int bpf_prog_array_length(struct bpf_prog_array *progs);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 43eb3501721b..99e85f44e257 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1354,20 +1354,6 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 }
 
 #ifdef CONFIG_NET
-static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
-					     enum cgroup_bpf_attach_type attach_type)
-{
-	struct bpf_prog_array *prog_array;
-	bool empty;
-
-	rcu_read_lock();
-	prog_array = rcu_dereference(cgrp->bpf.effective[attach_type]);
-	empty = bpf_prog_array_is_empty(prog_array);
-	rcu_read_unlock();
-
-	return empty;
-}
-
 static int sockopt_alloc_buf(struct bpf_sockopt_kern *ctx, int max_optlen,
 			     struct bpf_sockopt_buf *buf)
 {
@@ -1430,7 +1416,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
 	 */
-	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_SETSOCKOPT))
+	if (__cgroup_bpf_prog_array_is_empty(&cgrp->bpf, CGROUP_SETSOCKOPT))
 		return 0;
 
 	/* Allocate a bit more than the initial user buffer for
@@ -1526,7 +1512,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
 	 */
-	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_GETSOCKOPT))
+	if (__cgroup_bpf_prog_array_is_empty(&cgrp->bpf, CGROUP_GETSOCKOPT))
 		return retval;
 
 	ctx.optlen = max_optlen;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 2405e39d800f..fa76d1d839ad 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1967,18 +1967,10 @@ static struct bpf_prog_dummy {
 	},
 };
 
-/* to avoid allocating empty bpf_prog_array for cgroups that
- * don't have bpf program attached use one global 'empty_prog_array'
- * It will not be modified the caller of bpf_prog_array_alloc()
- * (since caller requested prog_cnt == 0)
- * that pointer should be 'freed' by bpf_prog_array_free()
- */
-static struct {
-	struct bpf_prog_array hdr;
-	struct bpf_prog *null_prog;
-} empty_prog_array = {
+struct bpf_empty_prog_array bpf_empty_prog_array = {
 	.null_prog = NULL,
 };
+EXPORT_SYMBOL(bpf_empty_prog_array);
 
 struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags)
 {
@@ -1988,12 +1980,12 @@ struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags)
 			       (prog_cnt + 1),
 			       flags);
 
-	return &empty_prog_array.hdr;
+	return &bpf_empty_prog_array.hdr;
 }
 
 void bpf_prog_array_free(struct bpf_prog_array *progs)
 {
-	if (!progs || progs == &empty_prog_array.hdr)
+	if (!progs || progs == &bpf_empty_prog_array.hdr)
 		return;
 	kfree_rcu(progs, rcu);
 }
-- 
2.34.0

