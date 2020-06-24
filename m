Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24E8207A20
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405489AbgFXRTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405475AbgFXRTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:41 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB475C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:40 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id e18so1718141pgn.7
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tz/dNrPVum4it+Ly6TC8fULsSd8JuS1v0zXevdgvvhs=;
        b=ObvuDFFWTmxx/SvK/KVsAor3wSKsnk/ZUgjGsWyvjW8R55vRGplzyzfwHHZeJEgLX+
         aHIRjs44PTPlsgq5u/lVovLtomhC8geTUM1MJ9YOjHKB6SccIZRiuqWRtjoY/H60v3YU
         VGaevvu3HyhJDGv3M9rGgW9gQhPNeLFmoaMAZxYfwTbn562ZQPl4s3pjhankdISF2iv7
         Qn+UqvadTe9b5k1iBcrAU2qwV/uHuMzhQHfghdRjvK9fJdct/Ebzn9+j7ipYG0XC6Wuy
         c52L2LuDW75tnGDKv3eTvSieVH80LIVVkQX5Tbiaq0N5r498KhLhQNuM0/e/VYL/iirc
         AVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tz/dNrPVum4it+Ly6TC8fULsSd8JuS1v0zXevdgvvhs=;
        b=Va5+9GxCrvLkpuWr1UWvjxKGnTdc6Yx3LLzwG5VqwdzFsZkKy9CH8phUumJOwgswZy
         LWkx08+oiL65/zXD1idvSEVkCiXnNJi42Lq0VrDRRJGUm+HCh+MkFrhUHov9smAt52oW
         KQr/LmQyBAdRCbzGgUHFy1UdNg876fKT4OHmHUk0IZkDjt1vg6S9wQUOgHUpUTh5gkmO
         SKQfwdoVe6UQsDA+lOa6vor2qYDIoNEarkE4i5qLY9hOvwvipGLZEik/qB1/TocA18VX
         5i4OYZiYz7vRsc21XbyCxwwyOa2oMhQffc6TQbQfsQrBpnQIwnlAXxtiV9kPPr2+idIn
         hy2g==
X-Gm-Message-State: AOAM531UMMOzzim2QbmywJ5CwO4diZmdXRVhknp8ZsDmyLQtEv4/vNBi
        qHoinbDjwlmyMLtGiu4nuerlF/jj0cQ=
X-Google-Smtp-Source: ABdhPJzKAtBETvPWNaCV0bwfd8SU/QRIzQ7FwF62ylXKfvhzUPnzTsJPfYTNTzXVNYO1YBbuaAbe4A==
X-Received: by 2002:aa7:9404:: with SMTP id x4mr30433227pfo.158.1593019179276;
        Wed, 24 Jun 2020 10:19:39 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:38 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 08/11] ptq: Per Thread Queues
Date:   Wed, 24 Jun 2020 10:17:47 -0700
Message-Id: <20200624171749.11927-9-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Per Thread Queues allows assigning a transmit and receive queue to each
thread via a cgroup controller. These queues are "global queues" that
are mapped to a real device queue when the sending or receiving device
is known.

Patch includes:
	- Create net_queues cgroup controller
	- Cgroup controller includes attributes to set a transmit
	  and receive queue range, unique assignment attributes, and
	  symmetric assignment attribute. Also, a read-only
	  attribute that lists task of the cgroup and their assigned
	  queues
	- Add a net_queue_pair to task_struct
	- Make ptq_cgroup_queue_desc which defines a index range by
	  a base index and length of the range
	- Assign queues to tasks when they attach to the cgroup.
	  For each of receive and transmit, a queue is selected
	  from the perspective range configured in the cgroup. If the
	  "assign" attribute is set for receive or transmit, a
	  unique queue (one not previously assigned to another task)
	  is chosen. If the "symmetric" attribute is set then
	  the receive and transmit queues are selected to be the same
	  number. If there are no queues available (e.g. assign
	  attribute is set for receive and all the queues in the
	  receive range are already assigned) then assignment
	  silently fails.
	- The assigned transmit and receive queues are set in
	  net_queue_pair structure for the task_struct
---
 include/linux/cgroup_subsys.h |   4 +
 include/linux/sched.h         |   4 +
 include/net/ptq.h             |  45 +++
 kernel/fork.c                 |   4 +
 net/Kconfig                   |  18 +
 net/core/Makefile             |   1 +
 net/core/ptq.c                | 688 ++++++++++++++++++++++++++++++++++
 7 files changed, 764 insertions(+)
 create mode 100644 include/net/ptq.h
 create mode 100644 net/core/ptq.c

diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
index acb77dcff3b4..9f80cde69890 100644
--- a/include/linux/cgroup_subsys.h
+++ b/include/linux/cgroup_subsys.h
@@ -49,6 +49,10 @@ SUBSYS(perf_event)
 SUBSYS(net_prio)
 #endif
 
+#if IS_ENABLED(CONFIG_CGROUP_NET_QUEUES)
+SUBSYS(net_queues)
+#endif
+
 #if IS_ENABLED(CONFIG_CGROUP_HUGETLB)
 SUBSYS(hugetlb)
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b62e6aaf28f0..97cb8288faca 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -32,6 +32,7 @@
 #include <linux/posix-timers.h>
 #include <linux/rseq.h>
 #include <linux/kcsan.h>
+#include <linux/netqueue.h>
 
 /* task_struct member predeclarations (sorted alphabetically): */
 struct audit_context;
@@ -1313,6 +1314,9 @@ struct task_struct {
 					__mce_reserved : 62;
 	struct callback_head		mce_kill_me;
 #endif
+#ifdef CONFIG_PER_THREAD_QUEUES
+	struct net_queue_pair		ptq_queues;
+#endif
 
 	/*
 	 * New fields for task_struct should be added above here, so that
diff --git a/include/net/ptq.h b/include/net/ptq.h
new file mode 100644
index 000000000000..a8ce39a85136
--- /dev/null
+++ b/include/net/ptq.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Per thread queues
+ *
+ * Copyright (c) 2020 Tom Herbert <tom@herbertland.com>
+ */
+
+#ifndef _NET_PTQ_H
+#define _NET_PTQ_H
+
+#include <linux/cgroup.h>
+#include <linux/netqueue.h>
+
+struct ptq_cgroup_queue_desc {
+	struct rcu_head rcu;
+
+	unsigned short base;
+	unsigned short num;
+	unsigned long alloced[0];
+};
+
+struct ptq_css {
+	struct cgroup_subsys_state css;
+
+	struct ptq_cgroup_queue_desc __rcu *txqs;
+	struct ptq_cgroup_queue_desc __rcu *rxqs;
+
+	unsigned short flags;
+#define PTQ_F_RX_ASSIGN		BIT(0)
+#define PTQ_F_TX_ASSIGN		BIT(1)
+#define PTQ_F_SYMMETRIC		BIT(2)
+};
+
+static inline struct ptq_css *css_to_ptq_css(struct cgroup_subsys_state *css)
+{
+	return (struct ptq_css *)css;
+}
+
+static inline struct ptq_cgroup_queue_desc **pcqd_select_desc(
+		struct ptq_css *pss, bool doing_tx)
+{
+	return doing_tx ? &pss->txqs : &pss->rxqs;
+}
+
+#endif /* _NET_PTQ_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 142b23645d82..5d604e778f4d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -958,6 +958,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 #ifdef CONFIG_MEMCG
 	tsk->active_memcg = NULL;
 #endif
+
+#ifdef CONFIG_PER_THREAD_QUEUES
+	init_net_queue_pair(&tsk->ptq_queues);
+#endif
 	return tsk;
 
 free_stack:
diff --git a/net/Kconfig b/net/Kconfig
index d1672280d6a4..fd2d1da89cb9 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -256,6 +256,24 @@ config RFS_ACCEL
 	select CPU_RMAP
 	default y
 
+config CGROUP_NET_QUEUES
+	depends on PER_THREAD_QUEUES
+	depends on CGROUPS
+	bool
+
+config PER_THREAD_QUEUES
+	bool "Per thread queues"
+	depends on RPS
+	depends on RFS_ACCEL
+	select CGROUP_NET_QUEUES
+	default y
+	help
+	  Assign network hardware queues to tasks. This creates a
+	  cgroup subsys net_queues that allows associating a hardware
+	  transmit queue and a receive queue with a thread. The interface
+	  specifies a range of queues for each side from which queues
+	  are assigned to each task.
+
 config XPS
 	bool
 	depends on SMP
diff --git a/net/core/Makefile b/net/core/Makefile
index 3e2c378e5f31..156a152e2b0a 100644
--- a/net/core/Makefile
+++ b/net/core/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_NET_DEVLINK) += devlink.o
 obj-$(CONFIG_GRO_CELLS) += gro_cells.o
 obj-$(CONFIG_FAILOVER) += failover.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_sk_storage.o
+obj-$(CONFIG_PER_THREAD_QUEUES) += ptq.o
diff --git a/net/core/ptq.c b/net/core/ptq.c
new file mode 100644
index 000000000000..edf6718e0a71
--- /dev/null
+++ b/net/core/ptq.c
@@ -0,0 +1,688 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* net/core/ptq.c
+ *
+ * Copyright (c) 2020 Tom Herbert
+ */
+#include <linux/bitmap.h>
+#include <linux/mutex.h>
+#include <linux/netdevice.h>
+#include <linux/types.h>
+#include <linux/random.h>
+#include <linux/rcupdate.h>
+#include <net/ptq.h>
+
+struct ptq_cgroup_queue_desc null_pcdesc;
+
+static DEFINE_MUTEX(ptq_mutex);
+
+#define NETPTQ_ID_MAX	USHRT_MAX
+
+/* Check is a queue identifier is in the range of a descriptor */
+
+static inline bool idx_in_range(struct ptq_cgroup_queue_desc *pcdesc,
+				unsigned short idx)
+{
+	return (idx >= pcdesc->base && idx < (pcdesc->base + pcdesc->num));
+}
+
+/* Mutex held */
+static int assign_one(struct ptq_cgroup_queue_desc *pcdesc,
+		      bool assign, unsigned short requested_idx)
+{
+	unsigned short idx;
+
+	if (!pcdesc->num)
+		return NO_QUEUE;
+
+	if (idx_in_range(pcdesc, requested_idx)) {
+		/* Try to use requested queue id */
+
+		if (assign) {
+			idx = requested_idx - pcdesc->base;
+			if (!test_bit(idx, pcdesc->alloced)) {
+				set_bit(idx, pcdesc->alloced);
+				return requested_idx;
+			}
+		} else {
+			return requested_idx;
+		}
+	}
+
+	/* Need new queue id */
+
+	if (assign)  {
+		idx = find_first_zero_bit(pcdesc->alloced, pcdesc->num);
+		if (idx >= pcdesc->num)
+			return -EBUSY;
+		set_bit(idx, pcdesc->alloced);
+		return pcdesc->base + idx;
+	}
+
+	/* Checked for zero ranged above */
+	return pcdesc->base + (get_random_u32() % pcdesc->num);
+}
+
+/* Compute the overlap between two queue ranges. Indicate
+ * the overlap by returning the relative offsets for the two
+ * queue descriptors where the overlap starts and the
+ * length of the overlap region.
+ */
+static inline unsigned short
+make_relative_idxs(struct ptq_cgroup_queue_desc *pcdesc0,
+		   struct ptq_cgroup_queue_desc *pcdesc1,
+		   unsigned short *rel_idx0,
+		   unsigned short *rel_idx1)
+{
+	if (pcdesc0->base + pcdesc0->num <= pcdesc1->base ||
+	    pcdesc1->base + pcdesc1->num <= pcdesc0->base) {
+		/* No overlap */
+		return 0;
+	}
+
+	if (pcdesc0->base >= pcdesc1->base) {
+		*rel_idx0 = 0;
+		*rel_idx1 = pcdesc0->base - pcdesc1->base;
+	} else {
+		*rel_idx0 = pcdesc1->base - pcdesc0->base;
+		*rel_idx1 = 0;
+	}
+
+	return min_t(unsigned short, pcdesc0->num - *rel_idx0,
+		     pcdesc1->num - *rel_idx1);
+}
+
+/* Mutex held */
+static int assign_symmetric(struct ptq_css *pss,
+			    struct ptq_cgroup_queue_desc *tx_pcdesc,
+			    struct ptq_cgroup_queue_desc *rx_pcdesc,
+			    unsigned short requested_idx1,
+			    unsigned short requested_idx2)
+{
+	unsigned short base_tidx, base_ridx, overlap;
+	unsigned short tidx, ridx, num_tx, num_rx;
+	unsigned int requested_idx = NO_QUEUE;
+	int ret;
+
+	if (idx_in_range(tx_pcdesc, requested_idx1) &&
+	    idx_in_range(rx_pcdesc, requested_idx1))
+		requested_idx = requested_idx1;
+	else if (idx_in_range(tx_pcdesc, requested_idx2) &&
+		 idx_in_range(rx_pcdesc, requested_idx2))
+		requested_idx = requested_idx2;
+
+	if (requested_idx != NO_QUEUE) {
+		unsigned short tidx = requested_idx - tx_pcdesc->base;
+		unsigned short ridx = requested_idx - rx_pcdesc->base;
+
+		/* Try to use requested queue id */
+
+		ret = requested_idx; /* Be optimisitic */
+
+		if ((pss->flags & (PTQ_F_TX_ASSIGN | PTQ_F_RX_ASSIGN)) ==
+		    (PTQ_F_TX_ASSIGN | PTQ_F_RX_ASSIGN)) {
+			if (!test_bit(tidx, tx_pcdesc->alloced) &&
+			    !test_bit(ridx, rx_pcdesc->alloced)) {
+				set_bit(tidx, tx_pcdesc->alloced);
+				set_bit(ridx, rx_pcdesc->alloced);
+
+				goto out;
+			}
+		} else if (pss->flags & PTQ_F_TX_ASSIGN) {
+			if (!test_bit(tidx, tx_pcdesc->alloced)) {
+				set_bit(tidx, tx_pcdesc->alloced);
+
+				goto out;
+			}
+		} else if (pss->flags & PTQ_F_RX_ASSIGN) {
+			if (!test_bit(ridx, rx_pcdesc->alloced)) {
+				set_bit(ridx, rx_pcdesc->alloced);
+
+				goto out;
+			}
+		} else {
+			goto out;
+		}
+	}
+
+	/* Need new queue id */
+
+	overlap = make_relative_idxs(tx_pcdesc, rx_pcdesc, &base_tidx,
+				     &base_ridx);
+	if (!overlap) {
+		/* No overlap in ranges */
+		ret = -ERANGE;
+		goto out;
+	}
+
+	num_tx = base_tidx + overlap;
+	num_rx = base_ridx + overlap;
+
+	ret = -EBUSY;
+
+	if ((pss->flags & (PTQ_F_TX_ASSIGN | PTQ_F_RX_ASSIGN)) ==
+	    (PTQ_F_TX_ASSIGN | PTQ_F_RX_ASSIGN)) {
+		/* Both sides need to be assigned, find common cleared
+		 * bit in respective bitmaps
+		 */
+		for (tidx = base_tidx;
+		     (tidx = find_next_zero_bit(tx_pcdesc->alloced,
+						num_tx, tidx)) < num_tx;
+		     tidx++) {
+			ridx = base_ridx + (tidx - base_tidx);
+			if (!test_bit(ridx, rx_pcdesc->alloced))
+				break;
+		}
+		if (tidx < num_tx) {
+			/* Found symmetric queue index that is unassigned
+			 * for both transmit and receive
+			 */
+
+			set_bit(tidx, tx_pcdesc->alloced);
+			set_bit(ridx, rx_pcdesc->alloced);
+			ret = tx_pcdesc->base + tidx;
+		}
+	} else if (pss->flags & PTQ_F_TX_ASSIGN) {
+		tidx = find_next_zero_bit(tx_pcdesc->alloced,
+					  num_tx, base_tidx);
+		if (tidx < num_tx) {
+			set_bit(tidx, tx_pcdesc->alloced);
+			ret = tx_pcdesc->base + tidx;
+		}
+	} else if (pss->flags & PTQ_F_RX_ASSIGN) {
+		ridx = find_next_zero_bit(rx_pcdesc->alloced,
+					  num_rx, base_ridx);
+		if (ridx < num_rx) {
+			set_bit(ridx, rx_pcdesc->alloced);
+			ret = rx_pcdesc->base + ridx;
+		}
+	} else {
+		/* Overlap can't be zero from check above */
+		ret = tx_pcdesc->base + base_tidx +
+		    (get_random_u32() % overlap);
+	}
+out:
+	return ret;
+}
+
+/* Mutex held */
+static int assign_queues(struct ptq_css *pss, struct task_struct *task)
+{
+	struct ptq_cgroup_queue_desc *tx_pcdesc, *rx_pcdesc;
+	unsigned short txq_id = NO_QUEUE, rxq_id = NO_QUEUE;
+	struct net_queue_pair *qpair = &task->ptq_queues;
+	int ret, ret2;
+
+	tx_pcdesc = rcu_dereference_protected(pss->txqs,
+					      mutex_is_locked(&ptq_mutex));
+	rx_pcdesc = rcu_dereference_protected(pss->rxqs,
+					      mutex_is_locked(&ptq_mutex));
+
+	if (pss->flags & PTQ_F_SYMMETRIC) {
+		/* Assigning symmetric queues. Requested identifier is from
+		 * existing queue pair corresponding to side (TX or RX)
+		 * that is being tracked based on assign flag.
+		 */
+		ret =  assign_symmetric(pss, tx_pcdesc, rx_pcdesc,
+					qpair->txq_id, qpair->rxq_id);
+		if (ret >= 0) {
+			txq_id = ret;
+			rxq_id = ret;
+			ret = 0;
+		}
+	} else {
+		/* Not doing symmetric assignment. Assign transmit and
+		 * receive queues independently.
+		 */
+		ret = assign_one(tx_pcdesc, pss->flags & PTQ_F_TX_ASSIGN,
+				 qpair->txq_id);
+		if (ret >= 0)
+			txq_id = ret;
+
+		ret2 = assign_one(rx_pcdesc, pss->flags & PTQ_F_RX_ASSIGN,
+				  qpair->rxq_id);
+		if (ret2 >= 0)
+			rxq_id = ret2;
+
+		/* Return error if either assignment failed. Note that one
+		 * assignment for side may succeed and the other may fail.
+		 */
+		if (ret2 < 0)
+			ret = ret2;
+		else if (ret >= 0)
+			ret = 0;
+	}
+
+	qpair->txq_id = txq_id;
+	qpair->rxq_id = rxq_id;
+
+	return ret;
+}
+
+/* Mutex held */
+static void unassign_one(struct ptq_cgroup_queue_desc *pcdesc,
+			 unsigned short idx, bool assign)
+{
+	if (!pcdesc->num) {
+		WARN_ON(idx != NO_QUEUE);
+		return;
+	}
+	if (!assign || WARN_ON(!idx_in_range(pcdesc, idx)))
+		return;
+
+	idx -= pcdesc->base;
+	clear_bit(idx, pcdesc->alloced);
+}
+
+/* Mutex held */
+static void unassign_queues(struct ptq_css *pss, struct task_struct *task)
+{
+	struct ptq_cgroup_queue_desc *tx_pcdesc, *rx_pcdesc;
+	struct net_queue_pair *qpair = &task->ptq_queues;
+
+	tx_pcdesc = rcu_dereference_protected(pss->txqs,
+					      mutex_is_locked(&ptq_mutex));
+	rx_pcdesc = rcu_dereference_protected(pss->rxqs,
+					      mutex_is_locked(&ptq_mutex));
+
+	unassign_one(tx_pcdesc, qpair->txq_id, pss->flags & PTQ_F_TX_ASSIGN);
+	unassign_one(rx_pcdesc, qpair->rxq_id, pss->flags & PTQ_F_RX_ASSIGN);
+
+	init_net_queue_pair(qpair);
+}
+
+/* Mutex held */
+static void reassign_queues_all(struct ptq_css *pss)
+{
+	struct ptq_cgroup_queue_desc *tx_pcdesc, *rx_pcdesc;
+	struct task_struct *task;
+	struct css_task_iter it;
+
+	tx_pcdesc = rcu_dereference_protected(pss->txqs,
+					      mutex_is_locked(&ptq_mutex));
+	rx_pcdesc = rcu_dereference_protected(pss->rxqs,
+					      mutex_is_locked(&ptq_mutex));
+
+	/* PTQ configuration has changed, attempt to reassign queues for new
+	 * configuration. The assignment functions try to keep threads using
+	 * the same queues as much as possible to avoid thrashing.
+	 */
+
+	/* Clear the bitmaps, we will resonstruct them in the assignments */
+	bitmap_zero(tx_pcdesc->alloced, tx_pcdesc->num);
+	bitmap_zero(rx_pcdesc->alloced, rx_pcdesc->num);
+
+	css_task_iter_start(&pss->css, 0, &it);
+	while ((task = css_task_iter_next(&it)))
+		assign_queues(pss, task);
+	css_task_iter_end(&it);
+}
+
+static struct cgroup_subsys_state *
+cgrp_css_alloc(struct cgroup_subsys_state *parent_css)
+{
+	struct ptq_css *pss;
+
+	pss = kzalloc(sizeof(*pss), GFP_KERNEL);
+	if (!pss)
+		return ERR_PTR(-ENOMEM);
+
+	RCU_INIT_POINTER(pss->txqs, &null_pcdesc);
+	RCU_INIT_POINTER(pss->rxqs, &null_pcdesc);
+
+	return &pss->css;
+}
+
+static int cgrp_css_online(struct cgroup_subsys_state *css)
+{
+	struct cgroup_subsys_state *parent_css = css->parent;
+	int ret = 0;
+
+	if (css->id > NETPTQ_ID_MAX)
+		return -ENOSPC;
+
+	if (!parent_css)
+		return 0;
+
+	/* Don't inherit from parent for the time being */
+
+	return ret;
+}
+
+static void cgrp_css_free(struct cgroup_subsys_state *css)
+{
+	kfree(css);
+}
+
+static u64 read_ptqidx(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return css->id;
+}
+
+/* Takes mutex */
+static int ptq_can_attach(struct cgroup_taskset *tset)
+{
+	struct cgroup_subsys_state *dst_css, *src_css;
+	struct task_struct *task;
+
+	/* Unassign queues for tasks in preparation for attaching the tasks
+	 * to a different css
+	 */
+
+	mutex_lock(&ptq_mutex);
+
+	cgroup_taskset_for_each(task, dst_css, tset) {
+		src_css = task_css(task, net_queues_cgrp_id);
+		unassign_queues(css_to_ptq_css(src_css), task);
+	}
+
+	mutex_unlock(&ptq_mutex);
+
+	return 0;
+}
+
+/* Takes mutex */
+static void ptq_attach(struct cgroup_taskset *tset)
+{
+	struct cgroup_subsys_state *css;
+	struct task_struct *task;
+
+	mutex_lock(&ptq_mutex);
+
+	/* Assign queues for tasks their new css */
+
+	cgroup_taskset_for_each(task, css, tset)
+		assign_queues(css_to_ptq_css(css), task);
+
+	mutex_unlock(&ptq_mutex);
+}
+
+/* Takes mutex */
+static void ptq_cancel_attach(struct cgroup_taskset *tset)
+{
+	struct cgroup_subsys_state *dst_css, *src_css;
+	struct task_struct *task;
+
+	mutex_lock(&ptq_mutex);
+
+	/* Attach failed, reassign queues for tasks in their original
+	 * cgroup (previously they were unassigned in can_attach)
+	 */
+
+	cgroup_taskset_for_each(task, dst_css, tset) {
+		/* Reassign in old cgroup */
+		src_css = task_css(task, net_queues_cgrp_id);
+		assign_queues(css_to_ptq_css(src_css), task);
+	}
+
+	mutex_unlock(&ptq_mutex);
+}
+
+/* Takes mutex */
+static void ptq_fork(struct task_struct *task)
+{
+	struct cgroup_subsys_state *css =
+		task_css(task, net_queues_cgrp_id);
+
+	mutex_lock(&ptq_mutex);
+	assign_queues(css_to_ptq_css(css), task);
+	mutex_unlock(&ptq_mutex);
+}
+
+/* Takes mutex */
+static void ptq_exit(struct task_struct *task)
+{
+	struct cgroup_subsys_state *css =
+		task_css(task, net_queues_cgrp_id);
+
+	mutex_lock(&ptq_mutex);
+	unassign_queues(css_to_ptq_css(css), task);
+	mutex_unlock(&ptq_mutex);
+}
+
+static u64 read_flag(struct cgroup_subsys_state *css, unsigned int flag)
+{
+	return !!(css_to_ptq_css(css)->flags & flag);
+}
+
+/* Takes mutex */
+static int write_flag(struct cgroup_subsys_state *css, unsigned int flag,
+		      u64 val)
+{
+	struct ptq_css *pss = css_to_ptq_css(css);
+	int ret = 0;
+
+	mutex_lock(&ptq_mutex);
+
+	if (val)
+		pss->flags |= flag;
+	else
+		pss->flags &= ~flag;
+
+	/* If we've changed a flag that affects how queues are assigned then
+	 * reassign the queues.
+	 */
+	if (flag & (PTQ_F_TX_ASSIGN | PTQ_F_RX_ASSIGN | PTQ_F_SYMMETRIC))
+		reassign_queues_all(pss);
+
+	mutex_unlock(&ptq_mutex);
+
+	return ret;
+}
+
+static int show_queue_desc(struct seq_file *sf,
+			   struct ptq_cgroup_queue_desc *pcdesc)
+{
+	seq_printf(sf, "%u:%u\n", pcdesc->base, pcdesc->num);
+
+	return 0;
+}
+
+static int parse_queues(char *buf, unsigned short *base,
+			unsigned short *num)
+{
+	return (sscanf(buf, "%hu:%hu", base, num) != 2) ? -EINVAL : 0;
+}
+
+static void format_queue(char *buf, unsigned short idx)
+{
+	if (idx == NO_QUEUE)
+		sprintf(buf, "none");
+	else
+		sprintf(buf, "%hu", idx);
+}
+
+static int cgroup_procs_show(struct seq_file *sf, void *v)
+{
+	struct net_queue_pair *qpair;
+	struct task_struct *task = v;
+	char buf1[32], buf2[32];
+
+	qpair = &task->ptq_queues;
+	format_queue(buf1, qpair->txq_id);
+	format_queue(buf2, qpair->rxq_id);
+
+	seq_printf(sf, "%d: %s %s\n", task_pid_vnr(v), buf1, buf2);
+	return 0;
+}
+
+#define QDESC_LEN(NUM) (sizeof(struct ptq_cgroup_queue_desc) + \
+			      BITS_TO_LONGS(NUM) * sizeof(unsigned long))
+
+/* Takes mutex */
+static int set_queue_desc(struct ptq_css *pss,
+			  struct ptq_cgroup_queue_desc **pcdescp,
+			  unsigned short base, unsigned short num)
+{
+	struct ptq_cgroup_queue_desc *new_pcdesc = &null_pcdesc, *old_pcdesc;
+	int ret = 0;
+
+	/* Check if RPS maximum queues can accommodate the range */
+	ret = rps_check_max_queues(base + num);
+	if (ret)
+		return ret;
+
+	mutex_lock(&ptq_mutex);
+
+	old_pcdesc = rcu_dereference_protected(*pcdescp,
+					       mutex_is_locked(&ptq_mutex));
+
+	if (old_pcdesc && old_pcdesc->base == base && old_pcdesc->num == num) {
+		/* Nothing to do */
+		goto out;
+	}
+
+	if (num != 0) {
+		new_pcdesc = kzalloc(QDESC_LEN(num), GFP_KERNEL);
+		if (!new_pcdesc) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		new_pcdesc->base = base;
+		new_pcdesc->num = num;
+	}
+	rcu_assign_pointer(*pcdescp, new_pcdesc);
+	if (old_pcdesc != &null_pcdesc)
+		kfree_rcu(old_pcdesc, rcu);
+
+	reassign_queues_all(pss);
+out:
+	mutex_unlock(&ptq_mutex);
+
+	return ret;
+}
+
+static ssize_t write_tx_queues(struct kernfs_open_file *of,
+			       char *buf, size_t nbytes, loff_t off)
+{
+	struct ptq_css *pss = css_to_ptq_css(of_css(of));
+	unsigned short base, num;
+	int ret;
+
+	ret = parse_queues(buf, &base, &num);
+	if (ret < 0)
+		return ret;
+
+	return set_queue_desc(pss, &pss->txqs, base, num) ? : nbytes;
+}
+
+static int read_tx_queues(struct seq_file *sf, void *v)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = show_queue_desc(sf, rcu_dereference(css_to_ptq_css(seq_css(sf))->
+								 txqs));
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static ssize_t write_rx_queues(struct kernfs_open_file *of,
+			       char *buf, size_t nbytes, loff_t off)
+{
+	struct ptq_css *pss = css_to_ptq_css(of_css(of));
+	unsigned short base, num;
+	int ret;
+
+	ret = parse_queues(buf, &base, &num);
+	if (ret < 0)
+		return ret;
+
+	return set_queue_desc(pss, &pss->rxqs, base, num) ? : nbytes;
+}
+
+static int read_rx_queues(struct seq_file *sf, void *v)
+{
+	int ret;
+
+	rcu_read_lock();
+	ret = show_queue_desc(sf, rcu_dereference(css_to_ptq_css(seq_css(sf))->
+								 rxqs));
+	rcu_read_unlock();
+
+	return ret;
+}
+
+static u64 read_tx_assign(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return read_flag(css, PTQ_F_TX_ASSIGN);
+}
+
+static int write_tx_assign(struct cgroup_subsys_state *css,
+			   struct cftype *cft, u64 val)
+{
+	return write_flag(css, PTQ_F_TX_ASSIGN, val);
+}
+
+static u64 read_rx_assign(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return read_flag(css, PTQ_F_RX_ASSIGN);
+}
+
+static int write_rx_assign(struct cgroup_subsys_state *css,
+			   struct cftype *cft, u64 val)
+{
+	return write_flag(css, PTQ_F_RX_ASSIGN, val);
+}
+
+static u64 read_symmetric(struct cgroup_subsys_state *css, struct cftype *cft)
+{
+	return read_flag(css, PTQ_F_SYMMETRIC);
+}
+
+static int write_symmetric(struct cgroup_subsys_state *css,
+			   struct cftype *cft, u64 val)
+{
+	return write_flag(css, PTQ_F_SYMMETRIC, val);
+}
+
+static struct cftype ss_files[] = {
+	{
+		.name = "ptqidx",
+		.read_u64 = read_ptqidx,
+	},
+	{
+		.name = "rx-queues",
+		.seq_show = read_rx_queues,
+		.write = write_rx_queues,
+	},
+	{
+		.name = "tx-queues",
+		.seq_show = read_tx_queues,
+		.write = write_tx_queues,
+	},
+	{
+		.name = "rx-assign",
+		.read_u64 = read_rx_assign,
+		.write_u64 = write_rx_assign,
+	},
+	{
+		.name = "tx-assign",
+		.read_u64 = read_tx_assign,
+		.write_u64 = write_tx_assign,
+	},
+	{
+		.name = "symmetric",
+		.read_u64 = read_symmetric,
+		.write_u64 = write_symmetric,
+	},
+	{
+		.name = "task-queues",
+		.seq_start = cgroup_threads_start,
+		.seq_next = cgroup_procs_next,
+		.seq_show = cgroup_procs_show,
+	},
+	{ }	/* terminate */
+};
+
+struct cgroup_subsys net_queues_cgrp_subsys = {
+	.css_alloc	= cgrp_css_alloc,
+	.css_online	= cgrp_css_online,
+	.css_free	= cgrp_css_free,
+	.attach		= ptq_attach,
+	.can_attach	= ptq_can_attach,
+	.cancel_attach	= ptq_cancel_attach,
+	.fork		= ptq_fork,
+	.exit		= ptq_exit,
+	.legacy_cftypes	= ss_files,
+};
-- 
2.25.1

