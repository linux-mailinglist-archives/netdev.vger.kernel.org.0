Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71DC115FF0
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 01:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLHAEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 19:04:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44988 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfLHAEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Dec 2019 19:04:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ACB0B15449D99;
        Sat,  7 Dec 2019 16:04:48 -0800 (PST)
Date:   Sat, 07 Dec 2019 16:04:48 -0800 (PST)
Message-Id: <20191207.160448.1331251675070842799.davem@davemloft.net>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
CC:     ast@kernel.org, daniel@iogearbox.net, tglx@linutronix.de
Subject: [RFC v1 PATCH 6/7] bpf: Use BPF prog locking in array macros and
 cgroup/lirc code.
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Dec 2019 16:04:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Replace the preemption disable/enable with BPF prog locking calls.
Including the code paths that go via __bpf_prog_run_save_cb().

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/media/rc/bpf-lirc.c |  2 +-
 include/linux/bpf.h         | 10 +++++-----
 include/linux/filter.h      |  7 ++++---
 kernel/bpf/cgroup.c         | 14 +++++++-------
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 0a0ce620e4a2..e5521f40f664 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -220,7 +220,7 @@ void lirc_bpf_run(struct rc_dev *rcdev, u32 sample)
 	raw->bpf_sample = sample;
 
 	if (raw->progs)
-		BPF_PROG_RUN_ARRAY(raw->progs, &raw->bpf_sample, BPF_PROG_RUN);
+		BPF_PROG_RUN_ARRAY(raw->progs, &raw->bpf_sample, __BPF_PROG_RUN);
 }
 
 /*
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 35903f148be5..3d3f8d3b419f 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -673,7 +673,7 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 /* an array of programs to be executed under rcu_lock.
  *
  * Typical usage:
- * ret = BPF_PROG_RUN_ARRAY(&bpf_prog_array, ctx, BPF_PROG_RUN);
+ * ret = BPF_PROG_RUN_ARRAY(&bpf_prog_array, ctx, __BPF_PROG_RUN);
  *
  * the structure returned by bpf_prog_array_alloc() should be populated
  * with program pointers and the last pointer must be NULL.
@@ -715,7 +715,7 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 		struct bpf_prog *_prog;			\
 		struct bpf_prog_array *_array;		\
 		u32 _ret = 1;				\
-		preempt_disable();			\
+		bpf_prog_lock();			\
 		rcu_read_lock();			\
 		_array = rcu_dereference(array);	\
 		if (unlikely(check_non_null && !_array))\
@@ -728,7 +728,7 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 		}					\
 _out:							\
 		rcu_read_unlock();			\
-		preempt_enable();			\
+		bpf_prog_unlock();			\
 		_ret;					\
 	 })
 
@@ -762,7 +762,7 @@ _out:							\
 		u32 ret;				\
 		u32 _ret = 1;				\
 		u32 _cn = 0;				\
-		preempt_disable();			\
+		bpf_prog_lock();			\
 		rcu_read_lock();			\
 		_array = rcu_dereference(array);	\
 		_item = &_array->items[0];		\
@@ -774,7 +774,7 @@ _out:							\
 			_item++;			\
 		}					\
 		rcu_read_unlock();			\
-		preempt_enable();			\
+		bpf_prog_unlock();			\
 		if (_ret)				\
 			_ret = (_cn ? NET_XMIT_CN : NET_XMIT_SUCCESS);	\
 		else					\
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a64adc7751e8..0d31cbf1d2ed 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -674,6 +674,7 @@ static inline u8 *bpf_skb_cb(struct sk_buff *skb)
 	return qdisc_skb_cb(skb)->data;
 }
 
+/* The BPF prog lock must be held here. */
 static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 					 struct sk_buff *skb)
 {
@@ -686,7 +687,7 @@ static inline u32 __bpf_prog_run_save_cb(const struct bpf_prog *prog,
 		memset(cb_data, 0, sizeof(cb_saved));
 	}
 
-	res = BPF_PROG_RUN(prog, skb);
+	res = __BPF_PROG_RUN(prog, skb);
 
 	if (unlikely(prog->cb_access))
 		memcpy(cb_data, cb_saved, sizeof(cb_saved));
@@ -699,9 +700,9 @@ static inline u32 bpf_prog_run_save_cb(const struct bpf_prog *prog,
 {
 	u32 res;
 
-	preempt_disable();
+	bpf_prog_lock();
 	res = __bpf_prog_run_save_cb(prog, skb);
-	preempt_enable();
+	bpf_prog_unlock();
 	return res;
 }
 
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 9f90d3c92bda..c6ce35b215cb 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -672,7 +672,7 @@ int __cgroup_bpf_run_filter_sk(struct sock *sk,
 	struct cgroup *cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
 	int ret;
 
-	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], sk, BPF_PROG_RUN);
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], sk, __BPF_PROG_RUN);
 	return ret == 1 ? 0 : -EPERM;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sk);
@@ -716,7 +716,7 @@ int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
 	}
 
 	cgrp = sock_cgroup_ptr(&sk->sk_cgrp_data);
-	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, BPF_PROG_RUN);
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, __BPF_PROG_RUN);
 
 	return ret == 1 ? 0 : -EPERM;
 }
@@ -746,7 +746,7 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 	int ret;
 
 	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], sock_ops,
-				 BPF_PROG_RUN);
+				 __BPF_PROG_RUN);
 	return ret == 1 ? 0 : -EPERM;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_ops);
@@ -765,7 +765,7 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
 	allow = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx,
-				   BPF_PROG_RUN);
+				   __BPF_PROG_RUN);
 	rcu_read_unlock();
 
 	return !allow;
@@ -923,7 +923,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
-	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, BPF_PROG_RUN);
+	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[type], &ctx, __BPF_PROG_RUN);
 	rcu_read_unlock();
 
 	kfree(ctx.cur_val);
@@ -1012,7 +1012,7 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 
 	lock_sock(sk);
 	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_SETSOCKOPT],
-				 &ctx, BPF_PROG_RUN);
+				 &ctx, __BPF_PROG_RUN);
 	release_sock(sk);
 
 	if (!ret) {
@@ -1096,7 +1096,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 
 	lock_sock(sk);
 	ret = BPF_PROG_RUN_ARRAY(cgrp->bpf.effective[BPF_CGROUP_GETSOCKOPT],
-				 &ctx, BPF_PROG_RUN);
+				 &ctx, __BPF_PROG_RUN);
 	release_sock(sk);
 
 	if (!ret) {
-- 
2.20.1

