Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17E50EBA4
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbiDYWYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343671AbiDYWH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 18:07:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E2B63D1
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 15:04:51 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f7ddeb73c1so38392987b3.5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 15:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jswLwyCW7JO4G1NhhirfPLGOt4sA4tQpeVLq7C4Wm5Q=;
        b=EjzLsa/ZyjcSCYU3TU9optqHNGRprIvSsgcDUHbbfziiAvvt57s44ENEHWJs65tIPQ
         hpqesMg5PxyvmSCWHEDghCbFQ3EjXJ5sweU/qASvn1CfQ+pV9T/6VIp9PNdMeknf7yDL
         pcHRcZI5g3AymIV6b5K0ZfpR/x2NqMZkCb3YCKtJPgeOxmVxWTq0B5knCISAVesTjvIi
         /1J9kJSMJHbS3kBEkTdutRucZ8iM1O7GdVyn/iO5FM4wcVwQjyfLE9Y3aR2R8jpUX9Og
         mjMUtK/9deUxmMST91zr67av5o15hS9ScYpcuseXfZywxX+DzfURq/XgCH9Rf73BUW47
         8Cpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jswLwyCW7JO4G1NhhirfPLGOt4sA4tQpeVLq7C4Wm5Q=;
        b=0QuR7aL2KaAruCmhekFFrNXRmRyIaP0vdwTC/v0FL4xwmnuT/fy7Z2MlEsDpwXIOjZ
         XiXHj4EushgcHVDt9IMOuToPs9NE3ibMrlmY1iWQNZ/+fdnpemc2zSVDOKyaajabTq94
         VT3WlbU8mKxKhxCrbMELaP9uqGt4mfoaz3/bhM/RqfJybA2Xi+6G0n1uPe/2WV6boLfD
         aPTENA5iPXp0SSuxDtKFwr1lrp28c5mJynEQsQ0GSXF6ueWJIoFbfCCSK+eSRJueKl70
         L3G1upiyHhCMCglyO9kY89LEEqcKAuOQ5JwevxtjEmO40vVYNe5GjFs9DM9s1BOGrFhz
         kL3w==
X-Gm-Message-State: AOAM5325YiwURyUsMCM94B/znWBHs4Ragufhs6HVKtNma8sXnGZ2hnlC
        Sy8ud2Vo9DaE1S+xfwEl4h9uDz3AT6P0Ght9EESF8JwswXi82cmXclmGPQSfCr8s5Z/k5pr0PB0
        25Hpu36H9fvswW4mhYXio0VrnWdvI73Mz622QX2HPj5qDa/EZfPlQtw==
X-Google-Smtp-Source: ABdhPJxdeANHu0LPftt5eo5a50s7bGkdSNzw0DDclWy1+ZYH99xT26unyKj3ymfg6dD1Hwk4u2hxD5s=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:3c54:4c01:c96b:a0be])
 (user=sdf job=sendgmr) by 2002:a25:20b:0:b0:648:6d57:a774 with SMTP id
 11-20020a25020b000000b006486d57a774mr6107285ybc.78.1650924290999; Mon, 25 Apr
 2022 15:04:50 -0700 (PDT)
Date:   Mon, 25 Apr 2022 15:04:48 -0700
Message-Id: <20220425220448.3669032-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH bpf-next v2] bpf: use bpf_prog_run_array_cg_flags everywhere
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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

v2:
- 'func_ret & 1' under explicit test (Andrii & Martin)

Cc: Martin KaFai Lau <kafai@fb.com>
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf-cgroup.h |  8 ++---
 kernel/bpf/cgroup.c        | 72 +++++++++++++-------------------------
 2 files changed, 26 insertions(+), 54 deletions(-)

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
index 0cb6211fcb58..afb414b26d01 100644
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
@@ -78,7 +46,12 @@ bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	while ((prog = READ_ONCE(item->prog))) {
 		run_ctx.prog_item = item;
-		if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
+		func_ret = run_prog(prog, ctx);
+		if (ret_flags) {
+			*(ret_flags) |= (func_ret >> 1);
+			func_ret &= 1;
+		}
+		if (!func_ret && !IS_ERR_VALUE((long)run_ctx.retval))
 			run_ctx.retval = -EPERM;
 		item++;
 	}
@@ -1144,9 +1117,8 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 		u32 flags = 0;
 		bool cn;
 
-		ret = bpf_prog_run_array_cg_flags(
-			&cgrp->bpf, atype,
-			skb, __bpf_prog_run_save_cb, 0, &flags);
+		ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, skb,
+					    __bpf_prog_run_save_cb, 0, &flags);
 
 		/* Return values of CGROUP EGRESS BPF programs are:
 		 *   0: drop packet
@@ -1172,7 +1144,8 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 			ret = (cn ? NET_XMIT_DROP : ret);
 	} else {
 		ret = bpf_prog_run_array_cg(&cgrp->bpf, atype,
-					    skb, __bpf_prog_run_save_cb, 0);
+					    skb, __bpf_prog_run_save_cb, 0,
+					    NULL);
 		if (ret && !IS_ERR_VALUE((long)ret))
 			ret = -EFAULT;
 	}
@@ -1202,7 +1175,8 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 
-	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
+	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0,
+				     NULL);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
 
@@ -1247,8 +1221,8 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 	}
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	return bpf_prog_run_array_cg_flags(&cgrp->bpf, atype,
-					   &ctx, bpf_prog_run, 0, flags);
+	return bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run,
+				     0, flags);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
 
@@ -1275,7 +1249,7 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 
 	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sock_ops, bpf_prog_run,
-				     0);
+				     0, NULL);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_ops);
 
@@ -1292,7 +1266,8 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0,
+				    NULL);
 	rcu_read_unlock();
 
 	return ret;
@@ -1457,7 +1432,8 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0,
+				    NULL);
 	rcu_read_unlock();
 
 	kfree(ctx.cur_val);
@@ -1550,7 +1526,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	lock_sock(sk);
 	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_SETSOCKOPT,
-				    &ctx, bpf_prog_run, 0);
+				    &ctx, bpf_prog_run, 0, NULL);
 	release_sock(sk);
 
 	if (ret)
@@ -1650,7 +1626,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	lock_sock(sk);
 	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
-				    &ctx, bpf_prog_run, retval);
+				    &ctx, bpf_prog_run, retval, NULL);
 	release_sock(sk);
 
 	if (ret < 0)
@@ -1699,7 +1675,7 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	 */
 
 	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
-				    &ctx, bpf_prog_run, retval);
+				    &ctx, bpf_prog_run, retval, NULL);
 	if (ret < 0)
 		return ret;
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

