Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70015018F4
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbiDNQoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 12:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242055AbiDNQms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 12:42:48 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840AD111DFC
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:12:36 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2ec13b4bd42so45739387b3.16
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 09:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pPBA9ngXkQ7pfQr/obANkqANrFFR6bnlc1gj50FTqLw=;
        b=cVEh5XP0m5Hme4LgtEZDvyhD4cYhHetpC2S69ENBS0NzxE5Il3yZdmjhW49uvyQKQk
         GiHZ+sO/uAomqUQ1cbW6Ml0aNS0fZ59py3m6Z4ud7hrkx7lAAib95RI+2S4YP6Msgri6
         MrbIdzTu83pNNI8HEj6UsB1jTEXHi2bPAyStsEHrHzAHW1Z9/ubsuDBr4xbBDceOXYPl
         QxhYdLg1Dqg4v8N2BWm3RuZMzbeV3MTN7J77GOibc2XBG1qtYWOxk7cG4YWViSjfRA2/
         JSO2OmZVbLPs7hvnRGJU+qdb3O09qF9YSi4oT/zYN33y0lDQyItPO+EyQaLqCYqBIAOu
         m7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pPBA9ngXkQ7pfQr/obANkqANrFFR6bnlc1gj50FTqLw=;
        b=KWoSP2Bga44y4S4zRVVc/7NCXFAjfdbs9x8qohb6PRL9KMtLrCgC7qATmxf471D8C7
         sDpjr4mzWCVeKNOE9Eeo5sfOi1GtnEB5aNWp6sZSLktjI/IhikQfvJZWgBsWUFHthbM1
         PUn233dJAjeT0D5jASJPUalSEOyFt5U4z/IghHjHPMjurediNzHQbtLA7QR1Ofqr8K07
         zPVB52lbUIN2np8yTS3iYamjb7hYgi7Cz51j8tEYZD6RwEDUnYtO0j4qEt+238ykzXZL
         wErYqPrgypKpUe8iBWAQ4GvE39q2dfI1Q3n0UPSF5OrRuH/UB9R88I3iqaa0fVumFKDI
         37iw==
X-Gm-Message-State: AOAM530kmIyHE21NuewGdQ99yS6OU9p1aBB7eUlRNDvwA2VzZyMabR5r
        9q0lcU2i1EC7zZ4sv/HobG1zn2rs9uOmCwqWz8M9xGfLqWGrb5VQVKYZrVBZw2/H05GP975jGd0
        ndqaOhiUHVH429GWSsXXf6XQXzLg5dsfYgml78lhxCwIo+vOXrggX0g==
X-Google-Smtp-Source: ABdhPJzdXfTIvTcdZDzYDBuEXcRfrOCIWv7x8zdiIUn3fKJaH1nh4yDCUcaXPM53TttqHBbRnYzEHi0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:45c6:42d5:e443:72cc])
 (user=sdf job=sendgmr) by 2002:a05:6902:187:b0:63d:9c95:edca with SMTP id
 t7-20020a056902018700b0063d9c95edcamr2200850ybh.81.1649952755335; Thu, 14 Apr
 2022 09:12:35 -0700 (PDT)
Date:   Thu, 14 Apr 2022 09:12:33 -0700
Message-Id: <20220414161233.170780-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next v2] bpf: move rcu lock management out of BPF_PROG_RUN routines
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
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

Commit 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros
into functions") switched a bunch of BPF_PROG_RUN macros to inline
routines. This changed the semantic a bit. Due to arguments expansion
of macros, it used to be:

	rcu_read_lock();
	array = rcu_dereference(cgrp->bpf.effective[atype]);
	...

Now, with with inline routines, we have:
	array_rcu = rcu_dereference(cgrp->bpf.effective[atype]);
	/* array_rcu can be kfree'd here */
	rcu_read_lock();
	array = rcu_dereference(array_rcu);

I'm assuming in practice rcu subsystem isn't fast enough to trigger
this but let's use rcu API properly.

Also, rename to lower caps to not confuse with macros. Additionally,
drop and expand BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY.

See [1] for more context.

  [1] https://lore.kernel.org/bpf/CAKH8qBs60fOinFdxiiQikK_q0EcVxGvNTQoWvHLEUGbgcj1UYg@mail.gmail.com/T/#u

v2
- keep rcu locks inside by passing cgroup_bpf

Cc: Martin KaFai Lau <kafai@fb.com>
Fixes: 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros into functions")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/media/rc/bpf-lirc.c |   8 ++-
 include/linux/bpf.h         | 115 +++-------------------------------
 kernel/bpf/cgroup.c         | 121 +++++++++++++++++++++++++++++++-----
 kernel/trace/bpf_trace.c    |   5 +-
 4 files changed, 121 insertions(+), 128 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 3eff08d7b8e5..fe17c7f98e81 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -216,8 +216,12 @@ void lirc_bpf_run(struct rc_dev *rcdev, u32 sample)
 
 	raw->bpf_sample = sample;
 
-	if (raw->progs)
-		BPF_PROG_RUN_ARRAY(raw->progs, &raw->bpf_sample, bpf_prog_run);
+	if (raw->progs) {
+		rcu_read_lock();
+		bpf_prog_run_array(rcu_dereference(raw->progs),
+				   &raw->bpf_sample, bpf_prog_run);
+		rcu_read_unlock();
+	}
 }
 
 /*
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index bdb5298735ce..7bf441563ffc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1221,7 +1221,7 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 /* an array of programs to be executed under rcu_lock.
  *
  * Typical usage:
- * ret = BPF_PROG_RUN_ARRAY(&bpf_prog_array, ctx, bpf_prog_run);
+ * ret = bpf_prog_run_array(rcu_dereference(&bpf_prog_array), ctx, bpf_prog_run);
  *
  * the structure returned by bpf_prog_array_alloc() should be populated
  * with program pointers and the last pointer must be NULL.
@@ -1315,83 +1315,22 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
 
 typedef u32 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
 
-static __always_inline int
-BPF_PROG_RUN_ARRAY_CG_FLAGS(const struct bpf_prog_array __rcu *array_rcu,
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
-	array = rcu_dereference(array_rcu);
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
-static __always_inline int
-BPF_PROG_RUN_ARRAY_CG(const struct bpf_prog_array __rcu *array_rcu,
-		      const void *ctx, bpf_prog_run_fn run_prog,
-		      int retval)
-{
-	const struct bpf_prog_array_item *item;
-	const struct bpf_prog *prog;
-	const struct bpf_prog_array *array;
-	struct bpf_run_ctx *old_run_ctx;
-	struct bpf_cg_run_ctx run_ctx;
-
-	run_ctx.retval = retval;
-	migrate_disable();
-	rcu_read_lock();
-	array = rcu_dereference(array_rcu);
-	item = &array->items[0];
-	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
-	while ((prog = READ_ONCE(item->prog))) {
-		run_ctx.prog_item = item;
-		if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
-			run_ctx.retval = -EPERM;
-		item++;
-	}
-	bpf_reset_run_ctx(old_run_ctx);
-	rcu_read_unlock();
-	migrate_enable();
-	return run_ctx.retval;
-}
-
 static __always_inline u32
-BPF_PROG_RUN_ARRAY(const struct bpf_prog_array __rcu *array_rcu,
+bpf_prog_run_array(const struct bpf_prog_array *array,
 		   const void *ctx, bpf_prog_run_fn run_prog)
 {
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
-	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_trace_run_ctx run_ctx;
 	u32 ret = 1;
 
-	migrate_disable();
-	rcu_read_lock();
-	array = rcu_dereference(array_rcu);
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
+
 	if (unlikely(!array))
-		goto out;
+		return ret;
+
+	migrate_disable();
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	item = &array->items[0];
 	while ((prog = READ_ONCE(item->prog))) {
@@ -1400,50 +1339,10 @@ BPF_PROG_RUN_ARRAY(const struct bpf_prog_array __rcu *array_rcu,
 		item++;
 	}
 	bpf_reset_run_ctx(old_run_ctx);
-out:
-	rcu_read_unlock();
 	migrate_enable();
 	return ret;
 }
 
-/* To be used by __cgroup_bpf_run_filter_skb for EGRESS BPF progs
- * so BPF programs can request cwr for TCP packets.
- *
- * Current cgroup skb programs can only return 0 or 1 (0 to drop the
- * packet. This macro changes the behavior so the low order bit
- * indicates whether the packet should be dropped (0) or not (1)
- * and the next bit is a congestion notification bit. This could be
- * used by TCP to call tcp_enter_cwr()
- *
- * Hence, new allowed return values of CGROUP EGRESS BPF programs are:
- *   0: drop packet
- *   1: keep packet
- *   2: drop packet and cn
- *   3: keep packet and cn
- *
- * This macro then converts it to one of the NET_XMIT or an error
- * code that is then interpreted as drop packet (and no cn):
- *   0: NET_XMIT_SUCCESS  skb should be transmitted
- *   1: NET_XMIT_DROP     skb should be dropped and cn
- *   2: NET_XMIT_CN       skb should be transmitted and cn
- *   3: -err              skb should be dropped
- */
-#define BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(array, ctx, func)		\
-	({						\
-		u32 _flags = 0;				\
-		bool _cn;				\
-		u32 _ret;				\
-		_ret = BPF_PROG_RUN_ARRAY_CG_FLAGS(array, ctx, func, 0, &_flags); \
-		_cn = _flags & BPF_RET_SET_CN;		\
-		if (_ret && !IS_ERR_VALUE((long)_ret))	\
-			_ret = -EFAULT;			\
-		if (!_ret)				\
-			_ret = (_cn ? NET_XMIT_CN : NET_XMIT_SUCCESS);	\
-		else					\
-			_ret = (_cn ? NET_XMIT_DROP : _ret);		\
-		_ret;					\
-	})
-
 #ifdef CONFIG_BPF_SYSCALL
 DECLARE_PER_CPU(int, bpf_prog_active);
 extern struct mutex bpf_stats_enabled_mutex;
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 128028efda64..9e95c03f8f7f 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -22,6 +22,69 @@
 DEFINE_STATIC_KEY_ARRAY_FALSE(cgroup_bpf_enabled_key, MAX_CGROUP_BPF_ATTACH_TYPE);
 EXPORT_SYMBOL(cgroup_bpf_enabled_key);
 
+static int
+bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
+			    enum cgroup_bpf_attach_type atype,
+			    const void *ctx, bpf_prog_run_fn run_prog,
+			    int retval, u32 *ret_flags)
+{
+	const struct bpf_prog_array_item *item;
+	const struct bpf_prog *prog;
+	const struct bpf_prog_array *array;
+	struct bpf_run_ctx *old_run_ctx;
+	struct bpf_cg_run_ctx run_ctx;
+	u32 func_ret;
+
+	run_ctx.retval = retval;
+	migrate_disable();
+	rcu_read_lock();
+	array = rcu_dereference(cgrp->effective[atype]);
+	item = &array->items[0];
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
+	while ((prog = READ_ONCE(item->prog))) {
+		run_ctx.prog_item = item;
+		func_ret = run_prog(prog, ctx);
+		if (!(func_ret & 1) && !IS_ERR_VALUE((long)run_ctx.retval))
+			run_ctx.retval = -EPERM;
+		*(ret_flags) |= (func_ret >> 1);
+		item++;
+	}
+	bpf_reset_run_ctx(old_run_ctx);
+	rcu_read_unlock();
+	migrate_enable();
+	return run_ctx.retval;
+}
+
+static int
+bpf_prog_run_array_cg(const struct cgroup_bpf *cgrp,
+		      enum cgroup_bpf_attach_type atype,
+		      const void *ctx, bpf_prog_run_fn run_prog,
+		      int retval)
+{
+	const struct bpf_prog_array_item *item;
+	const struct bpf_prog *prog;
+	const struct bpf_prog_array *array;
+	struct bpf_run_ctx *old_run_ctx;
+	struct bpf_cg_run_ctx run_ctx;
+
+	run_ctx.retval = retval;
+	migrate_disable();
+	rcu_read_lock();
+	array = rcu_dereference(cgrp->effective[atype]);
+	item = &array->items[0];
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
+	while ((prog = READ_ONCE(item->prog))) {
+		run_ctx.prog_item = item;
+		if (!run_prog(prog, ctx) && !IS_ERR_VALUE((long)run_ctx.retval))
+			run_ctx.retval = -EPERM;
+		item++;
+	}
+	bpf_reset_run_ctx(old_run_ctx);
+	rcu_read_unlock();
+	migrate_enable();
+	return run_ctx.retval;
+}
+
 void cgroup_bpf_offline(struct cgroup *cgrp)
 {
 	cgroup_get(cgrp);
@@ -1075,11 +1138,38 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 	bpf_compute_and_save_data_end(skb, &saved_data_end);
 
 	if (atype == CGROUP_INET_EGRESS) {
-		ret = BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(
-			cgrp->bpf.effective[atype], skb, __bpf_prog_run_save_cb);
+		u32 flags = 0;
+		bool cn;
+
+		ret = bpf_prog_run_array_cg_flags(
+			&cgrp->bpf, atype,
+			skb, __bpf_prog_run_save_cb, 0, &flags);
+
+		/* Return values of CGROUP EGRESS BPF programs are:
+		 *   0: drop packet
+		 *   1: keep packet
+		 *   2: drop packet and cn
+		 *   3: keep packet and cn
+		 *
+		 * The returned value is then converted to one of the NET_XMIT
+		 * or an error code that is then interpreted as drop packet
+		 * (and no cn):
+		 *   0: NET_XMIT_SUCCESS  skb should be transmitted
+		 *   1: NET_XMIT_DROP     skb should be dropped and cn
+		 *   2: NET_XMIT_CN       skb should be transmitted and cn
+		 *   3: -err              skb should be dropped
+		 */
+
+		cn = flags & BPF_RET_SET_CN;
+		if (ret && !IS_ERR_VALUE((long)ret))
+			ret = -EFAULT;
+		if (!ret)
+			ret = (cn ? NET_XMIT_CN : NET_XMIT_SUCCESS);
+		else
+			ret = (cn ? NET_XMIT_DROP : ret);
 	} else {
-		ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], skb,
-					    __bpf_prog_run_save_cb, 0);
+		ret = bpf_prog_run_array_cg(&cgrp->bpf, atype,
+					    skb, __bpf_prog_run_save_cb, 0);
 		if (ret && !IS_ERR_VALUE((long)ret))
 			ret = -EFAULT;
 	}
@@ -1109,8 +1199,7 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 
-	return BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], sk,
-				     bpf_prog_run, 0);
+	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sk, bpf_prog_run, 0);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
 
@@ -1155,8 +1244,8 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 	}
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	return BPF_PROG_RUN_ARRAY_CG_FLAGS(cgrp->bpf.effective[atype], &ctx,
-					   bpf_prog_run, 0, flags);
+	return bpf_prog_run_array_cg_flags(&cgrp->bpf, atype,
+					   &ctx, bpf_prog_run, 0, flags);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
 
@@ -1182,8 +1271,8 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 
-	return BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], sock_ops,
-				     bpf_prog_run, 0);
+	return bpf_prog_run_array_cg(&cgrp->bpf, atype, sock_ops, bpf_prog_run,
+				     0);
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_ops);
 
@@ -1200,8 +1289,7 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], &ctx,
-				    bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0);
 	rcu_read_unlock();
 
 	return ret;
@@ -1366,8 +1454,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], &ctx,
-				    bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, atype, &ctx, bpf_prog_run, 0);
 	rcu_read_unlock();
 
 	kfree(ctx.cur_val);
@@ -1459,7 +1546,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	}
 
 	lock_sock(sk);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[CGROUP_SETSOCKOPT],
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_SETSOCKOPT,
 				    &ctx, bpf_prog_run, 0);
 	release_sock(sk);
 
@@ -1559,7 +1646,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	}
 
 	lock_sock(sk);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[CGROUP_GETSOCKOPT],
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
 				    &ctx, bpf_prog_run, retval);
 	release_sock(sk);
 
@@ -1608,7 +1695,7 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	 * be called if that data shouldn't be "exported".
 	 */
 
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[CGROUP_GETSOCKOPT],
+	ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
 				    &ctx, bpf_prog_run, retval);
 	if (ret < 0)
 		return ret;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b26f3da943de..f15b826f9899 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -129,7 +129,10 @@ unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx)
 	 * out of events when it was updated in between this and the
 	 * rcu_dereference() which is accepted risk.
 	 */
-	ret = BPF_PROG_RUN_ARRAY(call->prog_array, ctx, bpf_prog_run);
+	rcu_read_lock();
+	ret = bpf_prog_run_array(rcu_dereference(call->prog_array),
+				 ctx, bpf_prog_run);
+	rcu_read_unlock();
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-- 
2.36.0.rc0.470.gd361397f0d-goog

