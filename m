Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B34D2507C7D
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 00:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357841AbiDSWZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 18:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiDSWZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 18:25:47 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A738424960
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 15:23:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o188-20020a2541c5000000b0064334935847so10437662yba.16
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 15:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=C30lNOZbSpWyRYSDaW0/q/ggXZb6zLLiZejTeiEF1mE=;
        b=M6r75s8cg16c4DBNGIpFM8pS74CWBJXNGU/3nqCzDPIu4Y9zoY9Hns/Xy3HXKroTZz
         xNUtN2C90s3linphBUj3X2Rolmx60j2Ma/qpBJyvULo4iMXn03oKpmeIg79bhbqhvuGr
         edfZ10JbYOt8rg/OeEhtrypl8zjyIKBUG+nFgs9kdvb8wCPdlqwq7YIGaqOg6LDsIXm7
         IDLPhIwM7IpfB1sGgLfjXsA1m/rWyPRZooYt9HX7TmGjDjZQL6uCV1fjVKvNiXjlKxkS
         zqeZ26TuoxgD7v3jGU1NhsYVtzzPfbyRHaENtfcFET24sKPuuG4W+58sVMr+8uo0V9xk
         ltMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=C30lNOZbSpWyRYSDaW0/q/ggXZb6zLLiZejTeiEF1mE=;
        b=tQJzsnOGfo7qell2k/qwRVedwMaQCXopmPRZhLhnttQSFqLe8GQ9PlkOC6GzVIuxya
         6EFdvjKXcbVBxbbeio0QdXQ5QDLxTG5jEuxttby9DH3gKd4B3hcHk8dSOQI3Iflcs3w9
         C+Zlmsf+3T+PDWmcuk94aHsLFxTojJ/3ze7FZF6f1q8/GNaZ4RKDtjhivhmy2vUMMv0y
         9J/gS6ve8HrmXfXB3iZxquBV3/uVIr5nON97Sfw6cKtWrTXH2X10PrV/Bj8gMVj4Foi9
         fmLyAmusJW2D3xcTIjYVNUdqD+m33NrzAhMQdAAtf/wO9nOWhM3pVizWTu+msNqNPOib
         ZWlg==
X-Gm-Message-State: AOAM531VMJfMbTbhx+ywBwmYCPEOwx4kUf3bvO0GahoCfkEPmILmKdgv
        bsoMRGYwBIOT8EYPTXKwE4m0mhP9uqoclCgCn82yVpKVFdoCDqvv1JILhFSVjSBH++ySpXYVM4D
        SFjjj6ZUWpm9TPGQrftY2gjVacFgZbReGkGe/Zvf8eqcNFHNhv1qc1A==
X-Google-Smtp-Source: ABdhPJzEBJXwjGx2erc1pBkCUwdSCfRu7k8+yzUDNr4GjX5dYBt3C7iL1Vm3XFS18Fq27pnlsyR6+Es=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:37f:6746:8e66:a291])
 (user=sdf job=sendgmr) by 2002:a81:11c7:0:b0:2ec:4a58:4bf1 with SMTP id
 190-20020a8111c7000000b002ec4a584bf1mr12206857ywr.262.1650406981821; Tue, 19
 Apr 2022 15:23:01 -0700 (PDT)
Date:   Tue, 19 Apr 2022 15:22:59 -0700
Message-Id: <20220419222259.287515-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next] bpf: use bpf_prog_run_array_cg_flags everywhere
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename bpf_prog_run_array_cg_flags to bpf_prog_run_array_cg and
use it everywhere. check_return_code already enforces sane
return ranges for all cgroup types. (only egress and bind hooks have
uncanonical return ranges, the rest is using [0, 1])

No functional changes.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h |  8 ++---
 kernel/bpf/cgroup.c        | 70 ++++++++++++--------------------------
 2 files changed, 24 insertions(+), 54 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 88a51b242adc..669d96d074ad 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -225,24 +225,20 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
 
 #define BPF_CGROUP_RUN_SA_PROG(sk, uaddr, atype)				       \
 ({									       \
-	u32 __unused_flags;						       \
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(atype))					       \
 		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
-							  NULL,		       \
-							  &__unused_flags);    \
+							  NULL, NULL);	       \
 	__ret;								       \
 })
 
 #define BPF_CGROUP_RUN_SA_PROG_LOCK(sk, uaddr, atype, t_ctx)		       \
 ({									       \
-	u32 __unused_flags;						       \
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(atype))	{				       \
 		lock_sock(sk);						       \
 		__ret = __cgroup_bpf_run_filter_sock_addr(sk, uaddr, atype,     \
-							  t_ctx,	       \
-							  &__unused_flags);    \
+							  t_ctx, NULL);	       \
 		release_sock(sk);					       \
 	}								       \
 	__ret;								       \
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 0cb6211fcb58..f61eca32c747 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -25,50 +25,18 @@ EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 /* __always_inline is necessary to prevent indirect call through run_prog
  * function pointer.
  */
-static __always_inline int
-bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
-			    enum cgroup_bpf_attach_type atype,
-			    const void *ctx, bpf_prog_run_fn run_prog,
-			    int retval, u32 *ret_flags)
-{
-	const struct bpf_prog_array_item *item;
-	const struct bpf_prog *prog;
-	const struct bpf_prog_array *array;
-	struct bpf_run_ctx *old_run_ctx;
-	struct bpf_cg_run_ctx run_ctx;
-	u32 func_ret;
-
-	run_ctx.retval = retval;
-	migrate_disable();
-	rcu_read_lock();
-	array = rcu_dereference(cgrp->effective[atype]);
-	item = &array->items[0];
-	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
-	while ((prog = READ_ONCE(item->prog))) {
-		run_ctx.prog_item = item;
-		func_ret = run_prog(prog, ctx);
-		if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
-			run_ctx.retval = -EPERM;
-		*(ret_flags) |= (func_ret >> 1);
-		item++;
-	}
-	bpf_reset_run_ctx(old_run_ctx);
-	rcu_read_unlock();
-	migrate_enable();
-	return run_ctx.retval;
-}
-
 static __always_inline int
 bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 		      enum cgroup_bpf_attach_type atype,
 		      const void *ctx, bpf_prog_run_fn run_prog,
-		      int retval)
+		      int retval, u32 *ret_flags)
 {
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
 	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_cg_run_ctx run_ctx;
+	u32 func_ret;
 
 	run_ctx.retval = retval;
 	migrate_disable();
@@ -78,8 +46,11 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	while ((prog = READ_ONCE(item->prog))) {
 		run_ctx.prog_item = item;
-		if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
+		func_ret = run_prog(prog, ctx);
+		if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
 			run_ctx.retval = -EPERM;
+		if (ret_flags)
+			*(ret_flags) |= (func_ret >> 1);
 		item++;
 	}
 	bpf_reset_run_ctx(old_run_ctx);
@@ -1144,9 +1115,8 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 		u32 flags = 0;
 		bool cn;
 
-		ret = bpf_prog_run_array_cg_flags(
-			&cgrp->bpf, atype,
-			skb, __bpf_prog_run_save_cb, 0, &flags);
+		ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, skb,
+					    __bpf_prog_run_save_cb, 0, &flags);
 
 		/* Return values of CGROUP EGRESS BPF programs are:
 		 *   0: drop packet
@@ -1172,7 +1142,8 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 			ret = (cn ? NET_XMIT_DROP : ret);
 	} else {
 		ret = bpf_prog_run_array_cg(&cgrp->bpf, atype,
-					    skb, __bpf_prog_run_save_cb, 0);
+					    skb, __bpf_prog_run_save_cb, 0,
+					    NULL);
 		if (ret && !IS_ERR_VALUE((long)ret))
 			ret = -EFAULT;
 	}
@@ -1202,7 +1173,8 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 
-	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
+	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0,
+				     NULL);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
 
@@ -1247,8 +1219,8 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 	}
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	return bpf_prog_run_array_cg_flags(&cgrp->bpf, atype,
-					   &ctx, bpf_prog_run, 0, flags);
+	return bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run,
+				     0, flags);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
 
@@ -1275,7 +1247,7 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 
 	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sock_ops, bpf_prog_run,
-				     0);
+				     0, NULL);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_ops);
 
@@ -1292,7 +1264,8 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0,
+				    NULL);
 	rcu_read_unlock();
 
 	return ret;
@@ -1457,7 +1430,8 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0,
+				    NULL);
 	rcu_read_unlock();
 
 	kfree(ctx.cur_val);
@@ -1550,7 +1524,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	lock_sock(sk);
 	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_SETSOCKOPT,
-				    &ctx, bpf_prog_run, 0);
+				    &ctx, bpf_prog_run, 0, NULL);
 	release_sock(sk);
 
 	if (ret)
@@ -1650,7 +1624,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	lock_sock(sk);
 	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
-				    &ctx, bpf_prog_run, retval);
+				    &ctx, bpf_prog_run, retval, NULL);
 	release_sock(sk);
 
 	if (ret < 0)
@@ -1699,7 +1673,7 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	 */
 
 	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
-				    &ctx, bpf_prog_run, retval);
+				    &ctx, bpf_prog_run, retval, NULL);
 	if (ret < 0)
 		return ret;
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

