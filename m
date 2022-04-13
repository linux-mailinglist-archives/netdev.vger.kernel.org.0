Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD0F64FFDE2
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 20:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237744AbiDMSfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 14:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiDMSfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 14:35:21 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 810145C375
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:32:59 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d7eaa730d9so23420167b3.13
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Br919Apk+2uBQJBESyyoPhVSQl8Eq/kv2f0ZpWyFRj8=;
        b=XVGoqFlqHrb/Bt1iMOqI79bfHy0KbeuXuc2t/l1WX7NFSuXRk7/Gc68mPxpsSk+Wd5
         ho/KDwkRtMYMu4ri5PrESmLxIMwlIZ//2mfxVSSXEX9S6Rp3Hdy34aImo+ppsuRX9jET
         t36I179KyknsvF/fS8XrCIIbnqYBxbH26R+WpJuHGWD0MJfCjvfEcdJr/M+jxxlaBOOC
         v0Hh4rKK6/dm7fF/GfEZirNbJLkARsEHyg0jsIBmVZ/kcKuhkPmYuJrIzSptbFGwBZ3W
         RONHg0yeYRNNWB01O3x+yZsWyuBn+xpsTwtODnQPGysz7Q4Fhd/XLT3dBRbBOQbdZObE
         B1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Br919Apk+2uBQJBESyyoPhVSQl8Eq/kv2f0ZpWyFRj8=;
        b=79G8rXE277zWSRIVNZDVU4xABOLGp8QU3yfrxvLeqSKFxrNHET/EpKxgVYnh/K3Ti2
         Pgq+c/INwjbmlOO/r15ZWpyR1AvRK4lfl0NCwa8RMmD776VuVg5K1Rc5o7bB/1mrA/L4
         DhmpfLzC5DHtZrY4Y+O/JYt+FQt4s8wp+XJ+GPdwm59JjGNTgG2MyRZEMW1aJdmWza+4
         Euh3U6SdjzbcNwrCDnDavUKSdMfFRftHGj6rnFM+gtxaQEpt1Sb5QIbktWtYJulPqzeS
         U5HkyGNUfMtxBPxq+Ln8IddF+1CM8PskTAFZQ/fxTDdY3LCAjy2ouqs1RPtQKwuPFglF
         uo+Q==
X-Gm-Message-State: AOAM533/4Jz/GjpFrRrwWalHYslt+hvtVptdL538MdOgwUOKrmC8Kyoy
        d6mDkhmBN1c986pTx2eirmZoJ2AyCUngxdS5+OV+DX26hndH+2DjdMdpkTNg0b78SQhGr0AW/kX
        rsz86x8ODdtpg/LVRO4otaAfpDX4T51aRLhIOSmyvx4HD0L7LHh4t6w==
X-Google-Smtp-Source: ABdhPJyzoMVPi1MBAHOnwHm5Uhe+ex7shUu8ixbvU4OTlKfo6UfF29k9K3xff91TI9blFWRn894atvw=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:45c6:42d5:e443:72cc])
 (user=sdf job=sendgmr) by 2002:a25:dc4:0:b0:641:438e:dd2a with SMTP id
 187-20020a250dc4000000b00641438edd2amr194966ybn.456.1649874778696; Wed, 13
 Apr 2022 11:32:58 -0700 (PDT)
Date:   Wed, 13 Apr 2022 11:32:56 -0700
Message-Id: <20220413183256.1819164-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next] bpf: move rcu lock management out of BPF_PROG_RUN routines
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
this but let's use rcu API properly: ask callers of BPF_PROG_RUN
to manage rcu themselves.

Also, rename to lower caps to not confuse with macros. Additionally,
drop and expand BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY.

See [1] for more context.

  [1] https://lore.kernel.org/bpf/CAKH8qBs60fOinFdxiiQikK_q0EcVxGvNTQoWvHLEUGbgcj1UYg@mail.gmail.com/T/#u

Cc: Martin KaFai Lau <kafai@fb.com>
Fixes: 7d08c2c91171 ("bpf: Refactor BPF_PROG_RUN_ARRAY family of macros into functions")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/media/rc/bpf-lirc.c |  8 +++-
 include/linux/bpf.h         | 70 ++++++-------------------------
 kernel/bpf/cgroup.c         | 84 +++++++++++++++++++++++++++++--------
 kernel/trace/bpf_trace.c    |  5 ++-
 4 files changed, 90 insertions(+), 77 deletions(-)

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
index bdb5298735ce..16111924fa3e 100644
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
@@ -1316,21 +1316,20 @@ static inline void bpf_reset_run_ctx(struct bpf_run_ctx *old_ctx)
 typedef u32 (*bpf_prog_run_fn)(const struct bpf_prog *prog, const void *ctx);
 
 static __always_inline int
-BPF_PROG_RUN_ARRAY_CG_FLAGS(const struct bpf_prog_array __rcu *array_rcu,
+bpf_prog_run_array_cg_flags(const struct bpf_prog_array *array,
 			    const void *ctx, bpf_prog_run_fn run_prog,
 			    int retval, u32 *ret_flags)
 {
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
-	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_cg_run_ctx run_ctx;
 	u32 func_ret;
 
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
+
 	run_ctx.retval = retval;
 	migrate_disable();
-	rcu_read_lock();
-	array = rcu_dereference(array_rcu);
 	item = &array->items[0];
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	while ((prog = READ_ONCE(item->prog))) {
@@ -1342,26 +1341,24 @@ BPF_PROG_RUN_ARRAY_CG_FLAGS(const struct bpf_prog_array __rcu *array_rcu,
 		item++;
 	}
 	bpf_reset_run_ctx(old_run_ctx);
-	rcu_read_unlock();
 	migrate_enable();
 	return run_ctx.retval;
 }
 
 static __always_inline int
-BPF_PROG_RUN_ARRAY_CG(const struct bpf_prog_array __rcu *array_rcu,
+bpf_prog_run_array_cg(const struct bpf_prog_array *array,
 		      const void *ctx, bpf_prog_run_fn run_prog,
 		      int retval)
 {
 	const struct bpf_prog_array_item *item;
 	const struct bpf_prog *prog;
-	const struct bpf_prog_array *array;
 	struct bpf_run_ctx *old_run_ctx;
 	struct bpf_cg_run_ctx run_ctx;
 
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
+
 	run_ctx.retval = retval;
 	migrate_disable();
-	rcu_read_lock();
-	array = rcu_dereference(array_rcu);
 	item = &array->items[0];
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	while ((prog = READ_ONCE(item->prog))) {
@@ -1371,27 +1368,26 @@ BPF_PROG_RUN_ARRAY_CG(const struct bpf_prog_array __rcu *array_rcu,
 		item++;
 	}
 	bpf_reset_run_ctx(old_run_ctx);
-	rcu_read_unlock();
 	migrate_enable();
 	return run_ctx.retval;
 }
 
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
@@ -1400,50 +1396,10 @@ BPF_PROG_RUN_ARRAY(const struct bpf_prog_array __rcu *array_rcu,
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
index 128028efda64..f5babdac245c 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1074,15 +1074,45 @@ int __cgroup_bpf_run_filter_skb(struct sock *sk,
 	/* compute pointers for the bpf prog */
 	bpf_compute_and_save_data_end(skb, &saved_data_end);
 
+	rcu_read_lock();
 	if (atype == CGROUP_INET_EGRESS) {
-		ret = BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY(
-			cgrp->bpf.effective[atype], skb, __bpf_prog_run_save_cb);
+		u32 flags = 0;
+		bool cn;
+
+		ret = bpf_prog_run_array_cg_flags(
+			rcu_dereference(cgrp->bpf.effective[atype]),
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
+		ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[atype]),
+					    skb, __bpf_prog_run_save_cb, 0);
 		if (ret && !IS_ERR_VALUE((long)ret))
 			ret = -EFAULT;
 	}
+	rcu_read_unlock();
+
 	bpf_restore_data_end(skb, saved_data_end);
 	__skb_pull(skb, offset);
 	skb->sk = save_sk;
@@ -1108,9 +1138,14 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 			       enum cgroup_bpf_attach_type atype)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	int ret;
+
+	rcu_read_lock();
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[atype]),
+				    sk, bpf_prog_run, 0);
+	rcu_read_unlock();
 
-	return BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], sk,
-				     bpf_prog_run, 0);
+	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
 
@@ -1142,6 +1177,7 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 	};
 	struct sockaddr_storage unspec;
 	struct cgroup *cgrp;
+	int ret;
 
 	/* Check socket family since not all sockets represent network
 	 * endpoint (e.g. AF_UNIX).
@@ -1154,9 +1190,12 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 		ctx.uaddr = (struct sockaddr *)&unspec;
 	}
 
+	rcu_read_lock();
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	return BPF_PROG_RUN_ARRAY_CG_FLAGS(cgrp->bpf.effective[atype], &ctx,
-					   bpf_prog_run, 0, flags);
+	ret = bpf_prog_run_array_cg_flags(rcu_dereference(cgrp->bpf.effective[atype]),
+					  &ctx, bpf_prog_run, 0, flags);
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_addr);
 
@@ -1181,9 +1220,14 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 				     enum cgroup_bpf_attach_type atype)
 {
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
+	int ret;
+
+	rcu_read_lock();
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[atype]),
+				    sock_ops, bpf_prog_run, 0);
+	rcu_read_unlock();
 
-	return BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], sock_ops,
-				     bpf_prog_run, 0);
+	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_ops);
 
@@ -1200,8 +1244,8 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], &ctx,
-				    bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[atype]),
+				    &ctx, bpf_prog_run, 0);
 	rcu_read_unlock();
 
 	return ret;
@@ -1366,8 +1410,8 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[atype], &ctx,
-				    bpf_prog_run, 0);
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[atype]),
+				    &ctx, bpf_prog_run, 0);
 	rcu_read_unlock();
 
 	kfree(ctx.cur_val);
@@ -1459,8 +1503,10 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 	}
 
 	lock_sock(sk);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[CGROUP_SETSOCKOPT],
+	rcu_read_lock();
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[CGROUP_SETSOCKOPT]),
 				    &ctx, bpf_prog_run, 0);
+	rcu_read_unlock();
 	release_sock(sk);
 
 	if (ret)
@@ -1559,8 +1605,10 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	}
 
 	lock_sock(sk);
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[CGROUP_GETSOCKOPT],
+	rcu_read_lock();
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[CGROUP_GETSOCKOPT]),
 				    &ctx, bpf_prog_run, retval);
+	rcu_read_unlock();
 	release_sock(sk);
 
 	if (ret < 0)
@@ -1608,8 +1656,10 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	 * be called if that data shouldn't be "exported".
 	 */
 
-	ret = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[CGROUP_GETSOCKOPT],
+	rcu_read_lock();
+	ret = bpf_prog_run_array_cg(rcu_dereference(cgrp->bpf.effective[CGROUP_GETSOCKOPT]),
 				    &ctx, bpf_prog_run, retval);
+	rcu_read_unlock();
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

