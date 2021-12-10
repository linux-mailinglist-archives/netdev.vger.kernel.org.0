Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F9C46F917
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 03:24:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbhLJC1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 21:27:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbhLJC1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 21:27:38 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C7C061746;
        Thu,  9 Dec 2021 18:24:04 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o13so12671975wrs.12;
        Thu, 09 Dec 2021 18:24:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qz15omFRU65z5zl9a7yi+KME4wV48vu63QsJyCO0P9w=;
        b=omuOCROJmUB7re+QbIAKWR50MHIg3ndo1wbbBgUxNgJvugQFpE+8mJWSJH9a3+/3ZM
         NQ5BZR5x1WFtIAy+jnvy1OKbFqHfxnqQdSe2OM/ppmErOcJMM2xQWiaETGjqTyTSWB5r
         xFaiDskFpsXDDqFB8ImrjBgNbfloVLOgNeBAkEx4FPjDTBbdGh/9sOthth5GJnqxG90p
         svM2AWwhaht/B97iPMD94zi5vW7PcJZV5H4jWHrHuXYgF6XqrcPXBmavIQYnkvEcqT4m
         4TnrE3+PUKKH2Xh1t5LtuNzewuvBdJMVN1FpBSCtH4Ftb/YxSCZzXCkJ/yuo5bwfRQmN
         aYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qz15omFRU65z5zl9a7yi+KME4wV48vu63QsJyCO0P9w=;
        b=HgMkua+5M/wxZln2PHb9U4S1f+8IrzCXi+bd2+OplIJtw6rzPgk1jSrxvPyl/KVmsy
         wW7xoCTXiY7hotmyfkVScSkOIZ5pKOf2rN8qPE3Y5JgYrIbdc2Rg18bqCisxHg0GIW9N
         P0FzVPXvUWqPplHrXTqJNwzho302CFpARRdXsdC7XPXcNaA0ruP9QdteDh4zwSlIZf2h
         JDgleuzxvAeRHzj2jFMUIkmjYAIdlwAVgeHcnA8JweRKr0mEMriJ2PeGNSWOx4yDr1dS
         7smqjDzvYhprN9QXxikrFO9tq6Z0Bb9B/TtHQ0k5lKxABtgZhXVcT1i7csKCargnk4VR
         e+MQ==
X-Gm-Message-State: AOAM530x//04+ujXIPRs3R13OwSgUYbbDFlbHa6Vf6RMbD+5BbGy3Srr
        jBYkL/Av7iIwTzpRh2wKIUQV/hRYnqA=
X-Google-Smtp-Source: ABdhPJxSnp9slnbMCvoFhrO6F409orm92ZJAdLkqbJ65LLvl9JMEGbIQwEHLbEIC5ml2hNHZX+yg7g==
X-Received: by 2002:adf:fd4c:: with SMTP id h12mr11092665wrs.429.1639103042721;
        Thu, 09 Dec 2021 18:24:02 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.149])
        by smtp.gmail.com with ESMTPSA id l26sm1480543wms.15.2021.12.09.18.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 18:24:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [BPF PATCH for-next] cgroup/bpf: fast path for not loaded skb BPF filtering
Date:   Fri, 10 Dec 2021 02:23:34 +0000
Message-Id: <d77b08bf757a8ea8dab3a495885c7de6ff6678da.1639102791.git.asml.silence@gmail.com>
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
 include/linux/bpf-cgroup.h | 24 +++++++++++++++++++++---
 kernel/bpf/cgroup.c        | 23 +++++++----------------
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 11820a430d6c..99b01201d7db 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -141,6 +141,9 @@ struct cgroup_bpf {
 	struct list_head progs[MAX_CGROUP_BPF_ATTACH_TYPE];
 	u32 flags[MAX_CGROUP_BPF_ATTACH_TYPE];
 
+	/* for each type tracks whether effective prog array is not empty */
+	unsigned long enabled_mask;
+
 	/* list of cgroup shared storages */
 	struct list_head storages;
 
@@ -219,11 +222,25 @@ int bpf_percpu_cgroup_storage_copy(struct bpf_map *map, void *key, void *value);
 int bpf_percpu_cgroup_storage_update(struct bpf_map *map, void *key,
 				     void *value, u64 flags);
 
+static inline bool __cgroup_bpf_type_enabled(struct cgroup_bpf *cgrp_bpf,
+					     enum cgroup_bpf_attach_type atype)
+{
+	return test_bit(atype, &cgrp_bpf->enabled_mask);
+}
+
+#define CGROUP_BPF_TYPE_ENABLED(sk, atype)				       \
+({									       \
+	struct cgroup *__cgrp = sock_cgroup_ptr(&(sk)->sk_cgrp_data);	       \
+									       \
+	__cgroup_bpf_type_enabled(&__cgrp->bpf, (atype));		       \
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
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 2ca643af9a54..28c8d0d6ea45 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -272,6 +272,11 @@ static void activate_effective_progs(struct cgroup *cgrp,
 				     enum cgroup_bpf_attach_type atype,
 				     struct bpf_prog_array *old_array)
 {
+	if (!bpf_prog_array_is_empty(old_array))
+		set_bit(atype, &cgrp->bpf.enabled_mask);
+	else
+		clear_bit(atype, &cgrp->bpf.enabled_mask);
+
 	old_array = rcu_replace_pointer(cgrp->bpf.effective[atype], old_array,
 					lockdep_is_held(&cgroup_mutex));
 	/* free prog array after grace period, since __cgroup_bpf_run_*()
@@ -1354,20 +1359,6 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
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
@@ -1430,7 +1421,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
 	 */
-	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_SETSOCKOPT))
+	if (!__cgroup_bpf_type_enabled(&cgrp->bpf, CGROUP_SETSOCKOPT))
 		return 0;
 
 	/* Allocate a bit more than the initial user buffer for
@@ -1526,7 +1517,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	 * attached to the hook so we don't waste time allocating
 	 * memory and locking the socket.
 	 */
-	if (__cgroup_bpf_prog_array_is_empty(cgrp, CGROUP_GETSOCKOPT))
+	if (!__cgroup_bpf_type_enabled(&cgrp->bpf, CGROUP_GETSOCKOPT))
 		return retval;
 
 	ctx.optlen = max_optlen;
-- 
2.34.0

