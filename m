Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0CD471597
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhLKTTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231826AbhLKTS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:18:58 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB9EC061714;
        Sat, 11 Dec 2021 11:18:57 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id t9so20361535wrx.7;
        Sat, 11 Dec 2021 11:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOZsAlRxtdOEaYKZZzJe2RJHIDxrF9SsgyDHCqepb50=;
        b=TfgokTPrZqAgWgNgKBr1AbfKyxRdqe/hbSxakLIHk77fzil3DZDXLVC0M1/+v5My7C
         YPqG3o7nmMFDR1pEMXEyZoLzkrBVaLCvhovRdgmmO2ArtyfC+9iRKWjTiYlfXz1B2I8e
         qCD43yMzDLH3vxnW07SDl+V6ZAjEpfDA0qTAZdp3zzv+4OlXDBb1bsU/ec7qGg9z9xRI
         J43ckh5ohn9x7r+vlvn2uYF3FhNnRpcpRKIpGjrmijNl6K796e4cCmms4v9l/nQkEKqK
         6PMzdS3sBfk4B8I7FnNMxl1oC1Etx7XcC4yj+4x2nUs4h10CqiovO+Zm3ia9Yd9KG7jh
         9X7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOZsAlRxtdOEaYKZZzJe2RJHIDxrF9SsgyDHCqepb50=;
        b=0EYRMS+UPvmQ8Ho8Ud09S2U0d2EDsbZgGIPYvatNg+ZkmeBH9GCpYuUQWxPDKfvLvz
         tqkew55sLf0PXlx3F790lpUMqvq6WIb6sCDJNqFTE9rmUabtU82V37SPcAqwJI6hkx6/
         oWEy4owZs2e/tQxrBDMAX/IJjYs+AXCYvi3Vg8sbMEXJXHFif3G6t5Vy5yqK9CG+ksBP
         4PdBxdSvUTEqQiuCV/ri+lWtk0xEPWVESffEBEKJhKTS0Z42RgNjnuYjP/5BQhwwprP1
         F8FnqZnmDIKSMkOpvOQudMJuaNd9sIgPOALcGaB/0sa5T1pjHxijZ946dHOGPWCsJE77
         nEdA==
X-Gm-Message-State: AOAM533xisNWy11y8AGiD4Pt9i2V2RK4F7i1WQPbZr4q6eWxgcSuFDnb
        AW/0vU/3ib3TZKdY3n5+gcwpZKB35z8=
X-Google-Smtp-Source: ABdhPJy40r4znIMVC3SwDLt2W21bOBCBdQzfojiDdTu6yLRZJQKiyv9r6uOIj4EUQQ9kXHDIdaDB5Q==
X-Received: by 2002:a5d:4107:: with SMTP id l7mr21713734wrp.209.1639250335994;
        Sat, 11 Dec 2021 11:18:55 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.149])
        by smtp.gmail.com with ESMTPSA id y7sm5463219wrw.55.2021.12.11.11.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:18:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2] cgroup/bpf: fast path for not loaded skb BPF filtering
Date:   Sat, 11 Dec 2021 19:17:49 +0000
Message-Id: <d1b6d4756287c28faf9ad9ce824e1a62be9a5e84.1639200253.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgroup_bpf_enabled_key static key guards from overhead in cases where
no cgroup bpf program of a specific type is loaded in any cgroup. Turn
out that's not always good enough, e.g. when there are many cgroups but
ones that we're interesting in are without bpf. It's seen in server
environments, but the problem seems to be even wider as apparently
systemd loads some BPF affecting my laptop.

Profiles for small packet or zerocopy transmissions over fast network
show __cgroup_bpf_run_filter_skb() taking 2-3%, 1% of which is from
migrate_disable/enable(), and similarly on the receiving side. Also
got +4-5% of t-put for local testing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: replace bitmask appoach with empty_prog_array (suggested by Martin)

 include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
 include/linux/bpf.h        | 13 +++++++++++++
 kernel/bpf/cgroup.c        | 18 ++----------------
 kernel/bpf/core.c          | 12 ++----------
 4 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 11820a430d6c..793e4f65ccb5 100644
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
+	return array == &empty_prog_array.hdr;
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
index e7a163a3146b..4a081065b77d 100644
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
+ * don't have bpf program attached use one global 'empty_prog_array'
+ * It will not be modified the caller of bpf_prog_array_alloc()
+ * (since caller requested prog_cnt == 0)
+ * that pointer should be 'freed' by bpf_prog_array_free()
+ */
+extern struct bpf_empty_prog_array empty_prog_array;
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
index 2405e39d800f..fedc7b44a1a9 100644
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
+struct bpf_empty_prog_array empty_prog_array = {
 	.null_prog = NULL,
 };
+EXPORT_SYMBOL(empty_prog_array);
 
 struct bpf_prog_array *bpf_prog_array_alloc(u32 prog_cnt, gfp_t flags)
 {
-- 
2.34.0

