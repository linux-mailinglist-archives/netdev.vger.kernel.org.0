Return-Path: <netdev+bounces-10194-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B1B72CC57
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 19:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2A4B281077
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:23:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E19B1F948;
	Mon, 12 Jun 2023 17:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3F1F931
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 17:23:12 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19242DB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:11 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1b3a82ef241so20215605ad.2
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686590590; x=1689182590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qsajQXCojYmprUydGUF65Mhm0IhEwrrdRl69Y6JxBAY=;
        b=FxlIAzQJZCeMZDT0zEWVeGeQ8Zt37o/EPBh2ybLUqF2+nAbENnHB/cKJ6ihVmKQdni
         K7CAJa/3DZHF1E43Bkr1JLK9OPxG07vRFvbBoRCQmIROX2lOArttc4pcEHqig24Xqus6
         g0aLWuvEJtrqS6CWoxwRnDLHLOKDhX0jIfgVueZmsVG16G1c1VpMAyu/K71KMgYnka7y
         mXgUpu5c4aG5Jh6LCwTLq1aPsR6hY2MR8yrzeE4tmUuvaSFFXqcs8R0ZLTkXWHoZk/kr
         mDt8uMuQFJnMelhCrpXvGIW5/u9QnpSeTh/QnnqjQWF+SoeGN849z/pK7SySfy1ULyKv
         ywBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686590590; x=1689182590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsajQXCojYmprUydGUF65Mhm0IhEwrrdRl69Y6JxBAY=;
        b=ZzL8FSnFO72qOnjpVQz1v/pToKlnSfSouSbBJZsrRNaJxi16lO8N5+gfSJpWErJgSt
         U6WCkBT4s2slRNf98F+ROEmhS59/DkoN7GI7k9FbIQHcWxldFTMuGWX9VtJBzC5Bs5zE
         nHPt98pk4LRzjgjZWWz/Qtav90jk3l6Uz0z5WZrKT7CUts2NJqfnb1OXU6bLddM7xT+6
         gdGGVtNpbNG8OMK2yhfa9w7In0o00eMMREqxnNjk7SZhlvhwPNCUDrlOLNGXnq2nEnQQ
         NiFNgHrFNl1LI7MznEjRlsD8kMaeCMemwTH4qGR5ervX/wbjrKCI0y0JgLyzWY5hpdcY
         ozpw==
X-Gm-Message-State: AC+VfDy/6dES94f7UNxLiQNmjxxs4zQZhOV5vRQjjrNXd0TQH+cyfQ1W
	lGWuF+v4xnMJSYHLUInLBhzD96k=
X-Google-Smtp-Source: ACHHUZ6pUpd6PQxwI8A6BG0/L7h7zgVB4IwuR63bmoW8iPCtAJGU6HJzEZKxQ9RRI22pv3ELLAin6sQ=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:44e:b0:1b3:ddff:2b4e with SMTP id
 iw14-20020a170903044e00b001b3ddff2b4emr329221plb.10.1686590590652; Mon, 12
 Jun 2023 10:23:10 -0700 (PDT)
Date: Mon, 12 Jun 2023 10:23:01 -0700
In-Reply-To: <20230612172307.3923165-1-sdf@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230612172307.3923165-2-sdf@google.com>
Subject: [RFC bpf-next 1/7] bpf: rename some xdp-metadata functions into dev-bound
From: Stanislav Fomichev <sdf@google.com>
To: bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@google.com, haoluo@google.com, jolsa@kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

No functional changes.

To make existing dev-bound infrastructure more generic and be
less tightly bound to the xdp layer, rename some functions and
move kfunc-related things into kernel/bpf/offload.c

Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/net/offload.h | 28 ++++++++++++++++++++++++++++
 include/net/xdp.h     | 18 +-----------------
 kernel/bpf/offload.c  | 26 ++++++++++++++++++++++++--
 kernel/bpf/verifier.c |  4 ++--
 net/core/xdp.c        | 20 ++------------------
 5 files changed, 57 insertions(+), 39 deletions(-)
 create mode 100644 include/net/offload.h

diff --git a/include/net/offload.h b/include/net/offload.h
new file mode 100644
index 000000000000..264a35881473
--- /dev/null
+++ b/include/net/offload.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __LINUX_NET_OFFLOAD_H__
+#define __LINUX_NET_OFFLOAD_H__
+
+#include <linux/types.h>
+
+#define XDP_METADATA_KFUNC_xxx	\
+	NETDEV_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
+			      bpf_xdp_metadata_rx_timestamp) \
+	NETDEV_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
+			      bpf_xdp_metadata_rx_hash)
+
+enum {
+#define NETDEV_METADATA_KFUNC(name, _) name,
+XDP_METADATA_KFUNC_xxx
+#undef NETDEV_METADATA_KFUNC
+MAX_NETDEV_METADATA_KFUNC,
+};
+
+#ifdef CONFIG_NET
+u32 bpf_dev_bound_kfunc_id(int id);
+bool bpf_is_dev_bound_kfunc(u32 btf_id);
+#else
+static inline u32 bpf_dev_bound_kfunc_id(int id) { return 0; }
+static inline bool bpf_is_dev_bound_kfunc(u32 btf_id) { return false; }
+#endif
+
+#endif /* __LINUX_NET_OFFLOAD_H__ */
diff --git a/include/net/xdp.h b/include/net/xdp.h
index d1c5381fc95f..de4c3b70abde 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -9,6 +9,7 @@
 #include <linux/skbuff.h> /* skb_shared_info */
 #include <uapi/linux/netdev.h>
 #include <linux/bitfield.h>
+#include <net/offload.h>
 
 /**
  * DOC: XDP RX-queue information
@@ -384,19 +385,6 @@ void xdp_attachment_setup(struct xdp_attachment_info *info,
 
 #define DEV_MAP_BULK_SIZE XDP_BULK_QUEUE_SIZE
 
-#define XDP_METADATA_KFUNC_xxx	\
-	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_TIMESTAMP, \
-			   bpf_xdp_metadata_rx_timestamp) \
-	XDP_METADATA_KFUNC(XDP_METADATA_KFUNC_RX_HASH, \
-			   bpf_xdp_metadata_rx_hash) \
-
-enum {
-#define XDP_METADATA_KFUNC(name, _) name,
-XDP_METADATA_KFUNC_xxx
-#undef XDP_METADATA_KFUNC
-MAX_XDP_METADATA_KFUNC,
-};
-
 enum xdp_rss_hash_type {
 	/* First part: Individual bits for L3/L4 types */
 	XDP_RSS_L3_IPV4		= BIT(0),
@@ -444,14 +432,10 @@ enum xdp_rss_hash_type {
 };
 
 #ifdef CONFIG_NET
-u32 bpf_xdp_metadata_kfunc_id(int id);
-bool bpf_dev_bound_kfunc_id(u32 btf_id);
 void xdp_set_features_flag(struct net_device *dev, xdp_features_t val);
 void xdp_features_set_redirect_target(struct net_device *dev, bool support_sg);
 void xdp_features_clear_redirect_target(struct net_device *dev);
 #else
-static inline u32 bpf_xdp_metadata_kfunc_id(int id) { return 0; }
-static inline bool bpf_dev_bound_kfunc_id(u32 btf_id) { return false; }
 
 static inline void
 xdp_set_features_flag(struct net_device *dev, xdp_features_t val)
diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index 8a26cd8814c1..235d81f7e0ed 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -844,9 +844,9 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
 	if (!ops)
 		goto out;
 
-	if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
+	if (func_id == bpf_dev_bound_kfunc_id(XDP_METADATA_KFUNC_RX_TIMESTAMP))
 		p = ops->xmo_rx_timestamp;
-	else if (func_id == bpf_xdp_metadata_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
+	else if (func_id == bpf_dev_bound_kfunc_id(XDP_METADATA_KFUNC_RX_HASH))
 		p = ops->xmo_rx_hash;
 out:
 	up_read(&bpf_devs_lock);
@@ -854,6 +854,28 @@ void *bpf_dev_bound_resolve_kfunc(struct bpf_prog *prog, u32 func_id)
 	return p;
 }
 
+BTF_SET_START(dev_bound_kfunc_ids)
+#define NETDEV_METADATA_KFUNC(name, str) BTF_ID(func, str)
+XDP_METADATA_KFUNC_xxx
+#undef NETDEV_METADATA_KFUNC
+BTF_SET_END(dev_bound_kfunc_ids)
+
+BTF_ID_LIST(dev_bound_kfunc_ids_unsorted)
+#define NETDEV_METADATA_KFUNC(name, str) BTF_ID(func, str)
+XDP_METADATA_KFUNC_xxx
+#undef NETDEV_METADATA_KFUNC
+
+u32 bpf_dev_bound_kfunc_id(int id)
+{
+	/* dev_bound_kfunc_ids is sorted and can't be used */
+	return dev_bound_kfunc_ids_unsorted[id];
+}
+
+bool bpf_is_dev_bound_kfunc(u32 btf_id)
+{
+	return btf_id_set_contains(&dev_bound_kfunc_ids, btf_id);
+}
+
 static int __init bpf_offload_init(void)
 {
 	return rhashtable_init(&offdevs, &offdevs_params);
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1e38584d497c..4db48b5af47e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2721,7 +2721,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
 		}
 	}
 
-	if (bpf_dev_bound_kfunc_id(func_id)) {
+	if (bpf_is_dev_bound_kfunc(func_id)) {
 		err = bpf_dev_bound_kfunc_check(&env->log, prog_aux);
 		if (err)
 			return err;
@@ -17757,7 +17757,7 @@ static void specialize_kfunc(struct bpf_verifier_env *env,
 	void *xdp_kfunc;
 	bool is_rdonly;
 
-	if (bpf_dev_bound_kfunc_id(func_id)) {
+	if (bpf_is_dev_bound_kfunc(func_id)) {
 		xdp_kfunc = bpf_dev_bound_resolve_kfunc(prog, func_id);
 		if (xdp_kfunc) {
 			*addr = (unsigned long)xdp_kfunc;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 41e5ca8643ec..819767697370 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -741,9 +741,9 @@ __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, u32 *hash,
 __diag_pop();
 
 BTF_SET8_START(xdp_metadata_kfunc_ids)
-#define XDP_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
+#define NETDEV_METADATA_KFUNC(_, name) BTF_ID_FLAGS(func, name, 0)
 XDP_METADATA_KFUNC_xxx
-#undef XDP_METADATA_KFUNC
+#undef NETDEV_METADATA_KFUNC
 BTF_SET8_END(xdp_metadata_kfunc_ids)
 
 static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
@@ -751,22 +751,6 @@ static const struct btf_kfunc_id_set xdp_metadata_kfunc_set = {
 	.set   = &xdp_metadata_kfunc_ids,
 };
 
-BTF_ID_LIST(xdp_metadata_kfunc_ids_unsorted)
-#define XDP_METADATA_KFUNC(name, str) BTF_ID(func, str)
-XDP_METADATA_KFUNC_xxx
-#undef XDP_METADATA_KFUNC
-
-u32 bpf_xdp_metadata_kfunc_id(int id)
-{
-	/* xdp_metadata_kfunc_ids is sorted and can't be used */
-	return xdp_metadata_kfunc_ids_unsorted[id];
-}
-
-bool bpf_dev_bound_kfunc_id(u32 btf_id)
-{
-	return btf_id_set8_contains(&xdp_metadata_kfunc_ids, btf_id);
-}
-
 static int __init xdp_metadata_init(void)
 {
 	return register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &xdp_metadata_kfunc_set);
-- 
2.41.0.162.gfafddb0af9-goog


