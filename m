Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B28D6258
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbfJNMVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:21:31 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43990 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730305AbfJNMVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 08:21:31 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4F49752E844D1AFB089A;
        Mon, 14 Oct 2019 20:21:28 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Mon, 14 Oct 2019
 20:21:23 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     <linux-block@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <axboe@kernel.dk>, <ast@kernel.org>
CC:     <hare@suse.com>, <osandov@fb.com>, <ming.lei@redhat.com>,
        <damien.lemoal@wdc.com>, <bvanassche@acm.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>
Subject: [RFC PATCH 1/2] block: add support for redirecting IO completion through eBPF
Date:   Mon, 14 Oct 2019 20:28:32 +0800
Message-ID: <20191014122833.64908-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191014122833.64908-1-houtao1@huawei.com>
References: <20191014122833.64908-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For network stack, RPS, namely Receive Packet Steering, is used to
distribute network protocol processing from hardware-interrupted CPU
to specific CPUs and alleviating soft-irq load of the interrupted CPU.

For block layer, soft-irq (for single queue device) or hard-irq
(for multiple queue device) is used to handle IO completion, so
RPS will be useful when the soft-irq load or the hard-irq load
of a specific CPU is too high, or a specific CPU set is required
to handle IO completion.

Instead of setting the CPU set used for handling IO completion
through sysfs or procfs, we can attach an eBPF program to the
request-queue, provide some useful info (e.g., the CPU
which submits the request) to the program, and let the program
decides the proper CPU for IO completion handling.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 block/Makefile             |   2 +-
 block/blk-bpf.c            | 127 +++++++++++++++++++++++++++++++++++++
 block/blk-mq.c             |  22 +++++--
 block/blk-softirq.c        |  27 ++++++--
 include/linux/blkdev.h     |   3 +
 include/linux/bpf_blkdev.h |   9 +++
 include/linux/bpf_types.h  |   1 +
 include/uapi/linux/bpf.h   |   2 +
 kernel/bpf/syscall.c       |   9 +++
 9 files changed, 190 insertions(+), 12 deletions(-)
 create mode 100644 block/blk-bpf.c
 create mode 100644 include/linux/bpf_blkdev.h

diff --git a/block/Makefile b/block/Makefile
index 9ef57ace90d4..0adb0f655e8c 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
 			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
 			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
 			genhd.o partition-generic.o ioprio.o \
-			badblocks.o partitions/ blk-rq-qos.o
+			badblocks.o partitions/ blk-rq-qos.o blk-bpf.o
 
 obj-$(CONFIG_BOUNCE)		+= bounce.o
 obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
diff --git a/block/blk-bpf.c b/block/blk-bpf.c
new file mode 100644
index 000000000000..d9e3b1caead4
--- /dev/null
+++ b/block/blk-bpf.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Hou Tao <houtao1@huawei.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <linux/fs.h>
+#include <linux/bpf_blkdev.h>
+#include <linux/blkdev.h>
+
+extern const struct file_operations def_blk_fops;
+
+static DEFINE_SPINLOCK(blkdev_bpf_lock);
+
+const struct bpf_prog_ops blkdev_prog_ops = {
+};
+
+static const struct bpf_func_proto *
+blkdev_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_map_lookup_elem:
+		return &bpf_map_lookup_elem_proto;
+	case BPF_FUNC_map_update_elem:
+		return &bpf_map_update_elem_proto;
+	case BPF_FUNC_map_delete_elem:
+		return &bpf_map_delete_elem_proto;
+	case BPF_FUNC_get_smp_processor_id:
+		return &bpf_get_smp_processor_id_proto;
+	case BPF_FUNC_get_numa_node_id:
+		return &bpf_get_numa_node_id_proto;
+	default:
+		return NULL;
+	}
+}
+
+const struct bpf_verifier_ops blkdev_verifier_ops = {
+	.get_func_proto = blkdev_prog_func_proto,
+};
+
+static struct request_queue *blkdev_rq_by_file(struct file *filp)
+{
+	struct block_device *bdev;
+
+	if (filp->f_op != &def_blk_fops)
+		return ERR_PTR(-EINVAL);
+
+	bdev = I_BDEV(filp->f_mapping->host);
+
+	return bdev->bd_queue;
+}
+
+int blkdev_bpf_prog_attach(const union bpf_attr *attr,
+		enum bpf_prog_type ptype, struct bpf_prog *prog)
+{
+	int ret = 0;
+	struct file *filp;
+	struct request_queue *rq;
+
+	filp = fget(attr->target_fd);
+	if (!filp) {
+		ret = -EINVAL;
+		goto fget_err;
+	}
+
+	rq = blkdev_rq_by_file(filp);
+	if (IS_ERR(rq)) {
+		ret = PTR_ERR(rq);
+		goto to_rq_err;
+	}
+
+	spin_lock(&blkdev_bpf_lock);
+	if (rq->prog) {
+		ret = -EBUSY;
+		goto set_prog_err;
+	}
+
+	rcu_assign_pointer(rq->prog, prog);
+
+set_prog_err:
+	spin_unlock(&blkdev_bpf_lock);
+to_rq_err:
+	fput(filp);
+fget_err:
+	return ret;
+}
+
+int blkdev_bpf_prog_detach(const union bpf_attr *attr)
+{
+	int ret = 0;
+	struct file *filp;
+	struct request_queue *rq;
+	struct bpf_prog *old_prog;
+
+	filp = fget(attr->target_fd);
+	if (!filp) {
+		ret = -EINVAL;
+		goto fget_err;
+	}
+
+	rq = blkdev_rq_by_file(filp);
+	if (IS_ERR(rq)) {
+		ret = PTR_ERR(rq);
+		goto to_rq_err;
+	}
+
+	old_prog = NULL;
+	spin_lock(&blkdev_bpf_lock);
+	if (!rq->prog) {
+		ret = -ENODATA;
+		goto clr_prog_err;
+	}
+	rcu_swap_protected(rq->prog, old_prog, 1);
+
+clr_prog_err:
+	spin_unlock(&blkdev_bpf_lock);
+	if (old_prog)
+		bpf_prog_put(old_prog);
+to_rq_err:
+	fput(filp);
+fget_err:
+	return ret;
+}
+
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 20a49be536b5..5ac6fe6dbcd0 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/crash_dump.h>
 #include <linux/prefetch.h>
+#include <linux/filter.h>
 
 #include <trace/events/block.h>
 
@@ -584,6 +585,9 @@ static void __blk_mq_complete_request(struct request *rq)
 	struct request_queue *q = rq->q;
 	bool shared = false;
 	int cpu;
+	int ccpu;
+	int bpf_ccpu = -1;
+	struct bpf_prog *prog;
 
 	WRITE_ONCE(rq->state, MQ_RQ_COMPLETE);
 	/*
@@ -610,15 +614,25 @@ static void __blk_mq_complete_request(struct request *rq)
 		return;
 	}
 
+	rcu_read_lock();
+	prog = rcu_dereference_protected(q->prog, 1);
+	if (prog)
+		bpf_ccpu = BPF_PROG_RUN(q->prog, NULL);
+	rcu_read_unlock();
+
 	cpu = get_cpu();
-	if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
-		shared = cpus_share_cache(cpu, ctx->cpu);
+	if (bpf_ccpu < 0 || !cpu_online(bpf_ccpu)) {
+		ccpu = ctx->cpu;
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
+			shared = cpus_share_cache(cpu, ctx->cpu);
+	} else
+		ccpu = bpf_ccpu;
 
-	if (cpu != ctx->cpu && !shared && cpu_online(ctx->cpu)) {
+	if (cpu != ccpu && !shared && cpu_online(ccpu)) {
 		rq->csd.func = __blk_mq_complete_request_remote;
 		rq->csd.info = rq;
 		rq->csd.flags = 0;
-		smp_call_function_single_async(ctx->cpu, &rq->csd);
+		smp_call_function_single_async(ccpu, &rq->csd);
 	} else {
 		q->mq_ops->complete(rq);
 	}
diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 457d9ba3eb20..1139a5352a59 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -11,6 +11,7 @@
 #include <linux/cpu.h>
 #include <linux/sched.h>
 #include <linux/sched/topology.h>
+#include <linux/filter.h>
 
 #include "blk.h"
 
@@ -101,20 +102,32 @@ void __blk_complete_request(struct request *req)
 	int cpu, ccpu = req->mq_ctx->cpu;
 	unsigned long flags;
 	bool shared = false;
+	int bpf_ccpu = -1;
+	struct bpf_prog *prog;
 
 	BUG_ON(!q->mq_ops->complete);
 
-	local_irq_save(flags);
-	cpu = smp_processor_id();
+	rcu_read_lock();
+	prog = rcu_dereference_protected(q->prog, 1);
+	if (prog)
+		bpf_ccpu = BPF_PROG_RUN(q->prog, NULL);
+	rcu_read_unlock();
 
 	/*
-	 * Select completion CPU
+	 * Select completion CPU.
+	 * If a valid CPU number is returned by eBPF program, use it directly.
 	 */
-	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && ccpu != -1) {
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
-			shared = cpus_share_cache(cpu, ccpu);
+	local_irq_save(flags);
+	cpu = smp_processor_id();
+	if (bpf_ccpu < 0 || !cpu_online(bpf_ccpu)) {
+		if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) &&
+			ccpu != -1) {
+			if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
+				shared = cpus_share_cache(cpu, ccpu);
+		} else
+			ccpu = cpu;
 	} else
-		ccpu = cpu;
+		ccpu = bpf_ccpu;
 
 	/*
 	 * If current CPU and requested CPU share a cache, run the softirq on
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d9db32fb75ee..849589c3c51c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -397,6 +397,8 @@ static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+struct bpf_prog;
+
 struct request_queue {
 	struct request		*last_merge;
 	struct elevator_queue	*elevator;
@@ -590,6 +592,7 @@ struct request_queue {
 
 #define BLK_MAX_WRITE_HINTS	5
 	u64			write_hints[BLK_MAX_WRITE_HINTS];
+	struct bpf_prog __rcu *prog;
 };
 
 #define QUEUE_FLAG_STOPPED	0	/* queue is stopped */
diff --git a/include/linux/bpf_blkdev.h b/include/linux/bpf_blkdev.h
new file mode 100644
index 000000000000..0777428bc6e2
--- /dev/null
+++ b/include/linux/bpf_blkdev.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BPF_BLKDEV_H__
+#define __BPF_BLKDEV_H__
+
+extern int blkdev_bpf_prog_attach(const union bpf_attr *attr,
+		enum bpf_prog_type ptype, struct bpf_prog *prog);
+extern int blkdev_bpf_prog_detach(const union bpf_attr *attr);
+
+#endif /* !__BPF_BLKDEV_H__ */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index 36a9c2325176..008facd336e5 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -38,6 +38,7 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #ifdef CONFIG_INET
 BPF_PROG_TYPE(BPF_PROG_TYPE_SK_REUSEPORT, sk_reuseport)
 #endif
+BPF_PROG_TYPE(BPF_PROG_TYPE_BLKDEV, blkdev)
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 77c6be96d676..36aa35e29be2 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -173,6 +173,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
 	BPF_PROG_TYPE_CGROUP_SOCKOPT,
+	BPF_PROG_TYPE_BLKDEV,
 };
 
 enum bpf_attach_type {
@@ -199,6 +200,7 @@ enum bpf_attach_type {
 	BPF_CGROUP_UDP6_RECVMSG,
 	BPF_CGROUP_GETSOCKOPT,
 	BPF_CGROUP_SETSOCKOPT,
+	BPF_BLKDEV_IOC_CPU,
 	__MAX_BPF_ATTACH_TYPE
 };
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 82eabd4e38ad..9724c0809f21 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4,6 +4,7 @@
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
 #include <linux/bpf_lirc.h>
+#include <linux/bpf_blkdev.h>
 #include <linux/btf.h>
 #include <linux/syscalls.h>
 #include <linux/slab.h>
@@ -1942,6 +1943,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_CGROUP_SETSOCKOPT:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
 		break;
+	case BPF_BLKDEV_IOC_CPU:
+		ptype = BPF_PROG_TYPE_BLKDEV;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -1966,6 +1970,9 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_BLKDEV:
+		ret = blkdev_bpf_prog_attach(attr, ptype, prog);
+		break;
 	default:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
 	}
@@ -2029,6 +2036,8 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_CGROUP_SETSOCKOPT:
 		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
 		break;
+	case BPF_BLKDEV_IOC_CPU:
+		return blkdev_bpf_prog_detach(attr);
 	default:
 		return -EINVAL;
 	}
-- 
2.22.0

