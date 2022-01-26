Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B8849C014
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235211AbiAZAWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiAZAWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:22:25 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93859C06161C;
        Tue, 25 Jan 2022 16:22:24 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id me13so34728253ejb.12;
        Tue, 25 Jan 2022 16:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nz0fFNaJv8V071m+0tlnEEBLR27yRJyXOvGx0aRpT0o=;
        b=K2u9l98i3ZTacNZzQAYnMwsDlash43oe/hAObffA9XOdQxLlMpPXn4sdivZqCzDzXk
         p144mwg+T5Dp8wABrnJU4jo/LOavXuYaonWNPphB/7T6b6PFJulDQ4qZehzicPXI1AUF
         51Nvn1qFE/jKfDPntnMVLpuz+yIlV0WCQXvOu8hduM6XN0QcqsuvMmDgLP4e7/lia5Qj
         ZBWzCrdPYUsj7lfpGkTOTgHxtzH9emoEiaKhX+nXJyR7F4qwMyPNbc279mrJ+mKCY7ND
         ekpGjoZ9Hhw+/Mwz/KdBbxJ7IoI+Ski8U/KAieyst3vLF8xnqLU1CjlQex7neakki33M
         qZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nz0fFNaJv8V071m+0tlnEEBLR27yRJyXOvGx0aRpT0o=;
        b=Cx8yVXOkE9JXpAwIejVbAg86ZkGIu3rb8c2gIkmrW2MWnzDFS3tIiOmrkXpL17BeCH
         cmHcvZ6xAuOqM2cYQ26m5SqcLfBmIRr2sEpUAI3hERs/RFLmW/BYDQ9aUZ5fNoepMPJU
         V49hjrpjR1/9sDPOizGTydd27nR/0Y4Ne59b+pZt+LDdpTilPfgPxhkCdfUE8jmvWgt9
         YGcaqhorPxiCLGboHG3AuPaM8TPxtkJvCHgHrpod07LG1yXPQLeXlk+cfq0U0Daz7D1Z
         5j4mFMyJKMw+/wS7t77DmdehpKHXNAbGOvydCWS8qexSrwKOZXZvSjZBg4901Sy8h9vM
         Q3lA==
X-Gm-Message-State: AOAM532RA3GJmDWGpRMfXNQ0ALqhaGG+/Hm+sPHHedWr/lvFvY/54FFX
        drLeReRpO5cSklObNgeBiDN1jkg0zX4=
X-Google-Smtp-Source: ABdhPJyhpYTRraR77Gj1BHmcpNmWm3/OSvS/VadUPSsjlF47QGdVR58m7lme4Ai/LaBV9f4bSuZ5UA==
X-Received: by 2002:a17:906:4fc4:: with SMTP id i4mr17308553ejw.81.1643156542797;
        Tue, 25 Jan 2022 16:22:22 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.233.187])
        by smtp.gmail.com with ESMTPSA id gg14sm6779871ejb.62.2022.01.25.16.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 16:22:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next v4] cgroup/bpf: fast path skb BPF filtering
Date:   Wed, 26 Jan 2022 00:22:13 +0000
Message-Id: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though there is a static key protecting from overhead from
cgroup-bpf skb filtering when there is nothing attached, in many cases
it's not enough as registering a filter for one type will ruin the fast
path for all others. It's observed in production servers I've looked
at but also in laptops, where registration is done during init by
systemd or something else.

Add a per-socket fast path check guarding from such overhead. This
affects both receive and transmit paths of TCP, UDP and other
protocols. It showed ~1% tx/s improvement in small payload UDP
send benchmarks using a real NIC and in a server environment and the
number jumps to 2-3% for preemtible kernels.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: replace bitmask appoach with empty_prog_array
v3: add "bpf_" prefix to empty_prog_array
v4: replace macros with inline functions
    use cgroup_bpf_sock_enabled for set/getsockopt() filters

 include/linux/bpf-cgroup.h | 26 +++++++++++++++++++++-----
 include/linux/bpf.h        | 13 +++++++++++++
 kernel/bpf/cgroup.c        | 30 ------------------------------
 kernel/bpf/core.c          | 16 ++++------------
 4 files changed, 38 insertions(+), 47 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index b525d8cdc25b..165b0ba3d6c3 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -8,6 +8,7 @@
 #include <linux/jump_label.h>
 #include <linux/percpu.h>
 #include <linux/rbtree.h>
+#include <net/sock.h>
 #include <uapi/linux/bpf.h>
 
 struct sock;
@@ -165,11 +166,23 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				     void *value, u64 flags);
 
+/* Opportunistic check to see whether we have any BPF program attached*/
+static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
+					   enum cgroup_bpf_attach_type type)
+{
+	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	struct bpf_prog_array *array;
+
+	array = rcu_access_pointer(cgrp->bpf.effective[type]);
+	return array != &bpf_empty_prog_array.hdr;
+}
+
 /* Wrappers for __cgroup_bpf_run_filter_skb() guarded by cgroup_bpf_enabled. */
 #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
 ({									      \
 	int __ret = 0;							      \
-	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))		      \
+	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&		      \
+	    cgroup_bpf_sock_enabled(sk, CGROUP_INET_INGRESS)) 	      \
 		__ret = __cgroup_bpf_run_filter_skb(sk, skb,		      \
 						    CGROUP_INET_INGRESS); \
 									      \
@@ -181,9 +194,10 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(CGROUP_INET_EGRESS) && sk && sk == skb->sk) { \
 		typeof(sk) __sk = sk_to_full_sk(sk);			       \
-		if (sk_fullsock(__sk))					       \
+		if (sk_fullsock(__sk) &&				       \
+		    cgroup_bpf_sock_enabled(__sk, CGROUP_INET_EGRESS))	       \
 			__ret = __cgroup_bpf_run_filter_skb(__sk, skb,	       \
-						      CGROUP_INET_EGRESS); \
+						      CGROUP_INET_EGRESS);     \
 	}								       \
 	__ret;								       \
 })
@@ -347,7 +361,8 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				       kernel_optval)			       \
 ({									       \
 	int __ret = 0;							       \
-	if (cgroup_bpf_enabled(CGROUP_SETSOCKOPT))			       \
+	if (cgroup_bpf_enabled(CGROUP_SETSOCKOPT) &&			       \
+	    cgroup_bpf_sock_enabled(sock, CGROUP_SETSOCKOPT))		       \
 		__ret = __cgroup_bpf_run_filter_setsockopt(sock, level,	       \
 							   optname, optval,    \
 							   optlen,	       \
@@ -367,7 +382,8 @@ int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				       max_optlen, retval)		       \
 ({									       \
 	int __ret = retval;						       \
-	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))			       \
+	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT) &&			       \
+	    cgroup_bpf_sock_enabled(sock, CGROUP_GETSOCKOPT))		       \
 		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
 		    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
 					tcp_bpf_bypass_getsockopt,	       \
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 394305a5e02f..dcfe2de59b59 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1233,6 +1233,19 @@ struct bpf_prog_array {
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
index 279ebbed75a5..098632fdbc45 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1384,20 +1384,6 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
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
@@ -1456,19 +1442,11 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	};
 	int ret, max_optlen;
 
-	/* Opportunistic check to see whether we have any BPF program
-	 * attached to the hook so we don't waste time allocating
-	 * memory and locking the socket.
-	 */
-	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_SETSOCKOPT))
-		return 0;
-
 	/* Allocate a bit more than the initial user buffer for
 	 * BPF program. The canonical use case is overriding
 	 * TCP_CONGESTION(nv) to TCP_CONGESTION(cubic).
 	 */
 	max_optlen = max_t(int, 16, *optlen);
-
 	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
@@ -1550,15 +1528,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	};
 	int ret;
 
-	/* Opportunistic check to see whether we have any BPF program
-	 * attached to the hook so we don't waste time allocating
-	 * memory and locking the socket.
-	 */
-	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_GETSOCKOPT))
-		return retval;
-
 	ctx.optlen = max_optlen;
-
 	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
 		return max_optlen;
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0a1cfd8544b9..04a8d5bea552 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1968,18 +1968,10 @@ static struct bpf_prog_dummy {
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
@@ -1989,12 +1981,12 @@ struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags)
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
2.34.1

