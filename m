Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30EA82593D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728228AbfEUUkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:40:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33046 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfEUUku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:40:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdX4H190544;
        Tue, 21 May 2019 20:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id :
 mime-version : date : from : to : cc : subject : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=rHw3RD2pZ30P5+J4IoEd6gYWviq+0Fs1RqdPdV/i9Gw=;
 b=znSDB3YG9EGhuthv0mnEO63jsZfcLK5mPqXM8kV2CQSHaPqiBV+HbND09+qNJSBdHHhC
 KKOW4S6k/fhtG/NHKOJ5ZKW+AakSNPXhF6sI7wGxZiVsOUBds4nyMgRXTzWsMjcZ/g1/
 RAKZINaBx8BBnxIT3YYIZ71D6Lm7cB4SNqqgf2nWgwZjAS5Ig1vUuatG1NGt31Vvg1mx
 Qc6jssRWP4gdV/VdHY/sKeloR6LYSH5wPXreDshWJOirCOgLKiY3ny7tZ6W2RmQUeMc4
 9XrnnMmCQ7vjiKKkpG2+fvslJDc7+3CWBzqUFbw4ZCgrrMzVOvuxbbrclA3w7g3pPIxe AQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sj9ftg1pm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:40:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4LKdbXp128175;
        Tue, 21 May 2019 20:40:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2sks1ydpkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 May 2019 20:40:03 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4LKe3F4129465;
        Tue, 21 May 2019 20:40:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2sks1ydpk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 May 2019 20:40:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4LKe2Qq028091;
        Tue, 21 May 2019 20:40:02 GMT
Message-Id: <201905212040.x4LKe2Qq028091@aserv0122.oracle.com>
Received: from localhost (/10.159.211.99) by default (Oracle Beehive Gateway
 v4.0) with ESMTP ; Tue, 21 May 2019 20:40:02 +0000
MIME-Version: 1.0
Date:   Tue, 21 May 2019 20:40:02 +0000 (UTC)
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net
Subject: [RFC PATCH 11/11] dtrace: make use of writable buffers in BPF
In-Reply-To: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9264 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905210129
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit modifies the tiny proof-of-concept DTrace utility to use
the writable-buffer support in BPF along with the new helpers for
buffer reservation and commit.  The dtrace_finalize_context() helper
is updated and is now marked with ctx_update because it sets the
buffer pointer to NULL (and size 0).

Signed-off-by: Kris Van Hees <kris.van.hees@oracle.com>
Reviewed-by: Nick Alcock <nick.alcock@oracle.com>
---
 include/uapi/linux/dtrace.h |   4 +
 kernel/trace/dtrace/bpf.c   | 150 ++++++++++++++++++++++++++++++++++++
 tools/dtrace/dt_buffer.c    |  54 +++++--------
 tools/dtrace/probe1_bpf.c   |  47 ++++++-----
 4 files changed, 198 insertions(+), 57 deletions(-)

diff --git a/include/uapi/linux/dtrace.h b/include/uapi/linux/dtrace.h
index bbe2562c11f2..3fcc075a429f 100644
--- a/include/uapi/linux/dtrace.h
+++ b/include/uapi/linux/dtrace.h
@@ -33,6 +33,10 @@ struct dtrace_bpf_context {
 	u32 gid;	/* from_kgid(&init_user_ns, current_real_cred()->gid */
 	u32 euid;	/* from_kuid(&init_user_ns, current_real_cred()->euid */
 	u32 egid;	/* from_kgid(&init_user_ns, current_real_cred()->egid */
+
+	/* General output buffer */
+	__bpf_md_ptr(u8 *, buf);
+	__bpf_md_ptr(u8 *, buf_end);
 };
 
 /*
diff --git a/kernel/trace/dtrace/bpf.c b/kernel/trace/dtrace/bpf.c
index 95f4103d749e..93bd2f0319cc 100644
--- a/kernel/trace/dtrace/bpf.c
+++ b/kernel/trace/dtrace/bpf.c
@@ -7,6 +7,7 @@
 #include <linux/filter.h>
 #include <linux/ptrace.h>
 #include <linux/sched.h>
+#include <linux/perf_event.h>
 
 /*
  * Actual kernel definition of the DTrace BPF context.
@@ -16,6 +17,9 @@ struct dtrace_bpf_ctx {
 	u32				ecb_id;
 	u32				probe_id;
 	struct task_struct		*task;
+	struct perf_output_handle	handle;
+	u64				buf_len;
+	u8				*buf;
 };
 
 /*
@@ -55,6 +59,8 @@ BPF_CALL_2(dtrace_finalize_context, struct dtrace_bpf_ctx *, ctx,
 
 	ctx->ecb_id = ecb->id;
 	ctx->probe_id = ecb->probe_id;
+	ctx->buf_len = 0;
+	ctx->buf = NULL;
 
 	return 0;
 }
@@ -62,17 +68,119 @@ BPF_CALL_2(dtrace_finalize_context, struct dtrace_bpf_ctx *, ctx,
 static const struct bpf_func_proto dtrace_finalize_context_proto = {
 	.func           = dtrace_finalize_context,
 	.gpl_only       = false,
+	.ctx_update	= true,
 	.ret_type       = RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,		/* ctx */
 	.arg2_type      = ARG_CONST_MAP_PTR,		/* map */
 };
 
+BPF_CALL_4(dtrace_buffer_reserve, struct dtrace_bpf_ctx *, ctx,
+				  int, id, struct bpf_map *, map, int, size)
+{
+	struct bpf_array	*arr = container_of(map, struct bpf_array, map);
+	int			cpu = smp_processor_id();
+	struct bpf_event_entry	*ee;
+	struct perf_event	*ev;
+	int			err;
+
+	/*
+	 * Make sure the writable-buffer id is valid.  We use the default which
+	 * is the offset of the start-of-buffer pointer in the public context.
+	 */
+	if (id != offsetof(struct dtrace_bpf_context, buf))
+		return -EINVAL;
+
+	/*
+	 * Verify whether we have an uncommitted reserve.  If so, we deny this
+	 * request.
+	 */
+	if (ctx->handle.rb)
+		return -EBUSY;
+
+	/*
+	 * Perform sanity checks.
+	 */
+	if (cpu >= arr->map.max_entries)
+		return -E2BIG;
+	ee = READ_ONCE(arr->ptrs[cpu]);
+	if (!ee)
+		return -ENOENT;
+	ev = ee->event;
+	if (unlikely(ev->attr.type != PERF_TYPE_SOFTWARE ||
+		     ev->attr.config != PERF_COUNT_SW_BPF_OUTPUT))
+		return -EINVAL;
+	if (unlikely(ev->oncpu != cpu))
+		return -EOPNOTSUPP;
+
+	size = round_up(size, sizeof(u64));
+
+	err = perf_output_begin_forward_in_page(&ctx->handle, ev, size);
+	if (err < 0)
+		return err;
+
+	ctx->buf_len = size;
+	ctx->buf = ctx->handle.addr;
+
+	return 0;
+}
+
+static const struct bpf_func_proto dtrace_buffer_reserve_proto = {
+	.func           = dtrace_buffer_reserve,
+	.gpl_only       = false,
+	.ctx_update	= true,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,		/* ctx */
+	.arg2_type      = ARG_ANYTHING,			/* id */
+	.arg3_type      = ARG_CONST_MAP_PTR,		/* map */
+	.arg4_type      = ARG_ANYTHING,			/* size */
+};
+
+BPF_CALL_3(dtrace_buffer_commit, struct dtrace_bpf_ctx *, ctx,
+				 int, id, struct bpf_map *, map)
+{
+	/*
+	 * Make sure the writable-buffer id is valid.  We use the default which
+	 * is the offset of the start-of-buffer pointer in the public context.
+	 */
+	if (id != offsetof(struct dtrace_bpf_context, buf))
+		return -EINVAL;
+
+	/*
+	 * Verify that we have an uncommitted reserve.  If not, there is really
+	 * nothing to be done here.
+	 */
+	if (!ctx->handle.rb)
+		return 0;
+
+	perf_output_end(&ctx->handle);
+
+	ctx->handle.rb = NULL;
+	ctx->buf_len = 0;
+	ctx->buf = NULL;
+
+	return 0;
+}
+
+static const struct bpf_func_proto dtrace_buffer_commit_proto = {
+	.func           = dtrace_buffer_commit,
+	.gpl_only       = false,
+	.ctx_update	= true,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,		/* ctx */
+	.arg2_type      = ARG_ANYTHING,			/* id */
+	.arg3_type      = ARG_CONST_MAP_PTR,		/* map */
+};
+
 static const struct bpf_func_proto *
 dtrace_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
 	case BPF_FUNC_finalize_context:
 		return &dtrace_finalize_context_proto;
+	case BPF_FUNC_buffer_reserve:
+		return &dtrace_buffer_reserve_proto;
+	case BPF_FUNC_buffer_commit:
+		return &dtrace_buffer_commit_proto;
 	case BPF_FUNC_perf_event_output:
 		return bpf_get_perf_event_output_proto();
 	case BPF_FUNC_trace_printk:
@@ -131,6 +239,22 @@ static bool dtrace_is_valid_access(int off, int size, enum bpf_access_type type,
 		if (bpf_ctx_narrow_access_ok(off, size, sizeof(u32)))
 			return true;
 		break;
+	case bpf_ctx_range(struct dtrace_bpf_context, buf):
+		info->reg_type = PTR_TO_BUFFER;
+		info->buf_id = offsetof(struct dtrace_bpf_context, buf);
+
+		bpf_ctx_record_field_size(info, sizeof(u64));
+		if (bpf_ctx_narrow_access_ok(off, size, sizeof(u64)))
+			return true;
+		break;
+	case bpf_ctx_range(struct dtrace_bpf_context, buf_end):
+		info->reg_type = PTR_TO_BUFFER_END;
+		info->buf_id = offsetof(struct dtrace_bpf_context, buf);
+
+		bpf_ctx_record_field_size(info, sizeof(u64));
+		if (bpf_ctx_narrow_access_ok(off, size, sizeof(u64)))
+			return true;
+		break;
 	default:
 		if (size == sizeof(unsigned long))
 			return true;
@@ -152,6 +276,10 @@ static bool dtrace_is_valid_access(int off, int size, enum bpf_access_type type,
  *	si->dst_reg = ((type *)si->src_reg)->member
  *	target_size = sizeof(((type *)si->src_reg)->member)
  *
+ *  BPF_LDX_CTX_FIELD_DST(type, member, dst, si, target_size)
+ *	dst = ((type *)si->src_reg)->member
+ *	target_size = sizeof(((type *)si->src_reg)->member)
+ *
  *  BPF_LDX_LNK_FIELD(type, member, si, target_size)
  *	si->dst_reg = ((type *)si->dst_reg)->member
  *	target_size = sizeof(((type *)si->dst_reg)->member)
@@ -172,6 +300,13 @@ static bool dtrace_is_valid_access(int off, int size, enum bpf_access_type type,
 			*(target_size) = FIELD_SIZEOF(type, member); \
 			offsetof(type, member); \
 		    }))
+#define BPF_LDX_CTX_FIELD_DST(type, member, dst, si, target_size) \
+	BPF_LDX_MEM(BPF_FIELD_SIZEOF(type, member), \
+		    (dst), (si)->src_reg, \
+		    ({ \
+			*(target_size) = FIELD_SIZEOF(type, member); \
+			offsetof(type, member); \
+		    }))
 #define BPF_LDX_LNK_FIELD(type, member, si, target_size) \
 	BPF_LDX_MEM(BPF_FIELD_SIZEOF(type, member), \
 		    (si)->dst_reg, (si)->dst_reg, \
@@ -261,6 +396,18 @@ static u32 dtrace_convert_ctx_access(enum bpf_access_type type,
 		*insn++ = BPF_LDX_LNK_PTR(struct task_struct, cred, si);
 		*insn++ = BPF_LDX_LNK_FIELD(struct cred, egid, si, target_size);
 		break;
+	case offsetof(struct dtrace_bpf_context, buf):
+		*insn++ = BPF_LDX_CTX_FIELD(struct dtrace_bpf_ctx, buf, si,
+					    target_size);
+		break;
+	case offsetof(struct dtrace_bpf_context, buf_end):
+		/* buf_end = ctx->buf + ctx->buf_len */
+		*insn++ = BPF_LDX_CTX_FIELD(struct dtrace_bpf_ctx, buf, si,
+					    target_size);
+		*insn++ = BPF_LDX_CTX_FIELD_DST(struct dtrace_bpf_ctx, buf_len,
+						BPF_REG_AX, si, target_size);
+		*insn++ = BPF_ALU64_REG(BPF_ADD, si->dst_reg, BPF_REG_AX);
+		break;
 	default:
 		*insn++ = BPF_LDX_CTX_PTR(struct dtrace_bpf_ctx, regs, si);
 		*insn++ = BPF_LDX_MEM(BPF_SIZEOF(long), si->dst_reg, si->dst_reg,
@@ -308,6 +455,9 @@ static void *dtrace_convert_ctx(enum bpf_prog_type stype, void *ctx)
 		gctx = this_cpu_ptr(&dtrace_ctx);
 		gctx->regs = (struct pt_regs *)ctx;
 		gctx->task = current;
+		gctx->handle.rb = NULL;
+		gctx->buf_len = 0;
+		gctx->buf = NULL;
 
 		return gctx;
 	}
diff --git a/tools/dtrace/dt_buffer.c b/tools/dtrace/dt_buffer.c
index 65c107ca8ac4..28fac9036d69 100644
--- a/tools/dtrace/dt_buffer.c
+++ b/tools/dtrace/dt_buffer.c
@@ -282,33 +282,27 @@ static void write_rb_tail(volatile struct perf_event_mmap_page *rb_page,
  */
 static int output_event(u64 *buf)
 {
-	u8				*data = (u8 *)buf;
-	struct perf_event_header	*hdr;
-	u32				size;
-	u64				probe_id, task;
-	u32				pid, ppid, cpu, euid, egid, tag;
+	u8	*data = (u8 *)buf;
+	u32	probe_id;
+	u32	flags;
+	u64	task;
+	u32	pid, ppid, cpu, euid, egid, tag;
 
-	hdr = (struct perf_event_header *)data;
-	data += sizeof(struct perf_event_header);
+	probe_id = *(u32 *)&(data[0]);
 
-	if (hdr->type != PERF_RECORD_SAMPLE)
-		return 1;
+	if (probe_id == PERF_RECORD_LOST) {
+		u16	size;
+		u64	lost;
 
-	size = *(u32 *)data;
-	data += sizeof(u32);
+		size = *(u16 *)&(data[6]);
+		lost = *(u16 *)&(data[16]);
 
-	/*
-	 * The sample should only take up 48 bytes, but as a result of how the
-	 * BPF program stores the data (filling in a struct that resides on the
-	 * stack, and sending that off using bpf_perf_event_output()), there is
-	 * some internal padding
-	 */
-	if (size != 52) {
-		printf("Sample size is wrong (%d vs expected %d)\n", size, 52);
-		goto out;
+		printf("[%ld probes dropped]\n", lost);
+
+		return size;
 	}
 
-	probe_id = *(u64 *)&(data[0]);
+	flags = *(u32 *)&(data[4]);
 	pid = *(u32 *)&(data[8]);
 	ppid = *(u32 *)&(data[12]);
 	cpu = *(u32 *)&(data[16]);
@@ -318,19 +312,14 @@ static int output_event(u64 *buf)
 	tag = *(u32 *)&(data[40]);
 
 	if (probe_id != 123)
-		printf("Corrupted data (probe_id = %ld)\n", probe_id);
+		printf("Corrupted data (probe_id = %d)\n", probe_id);
 	if (tag != 0xdace)
 		printf("Corrupted data (tag = %x)\n", tag);
 
-	printf("CPU-%d: EPID %ld PID %d PPID %d EUID %d EGID %d TASK %08lx\n",
-	       cpu, probe_id, pid, ppid, euid, egid, task);
+	printf("CPU-%d: [%d/%d] PID %d PPID %d EUID %d EGID %d TASK %08lx\n",
+	       cpu, probe_id, flags, pid, ppid, euid, egid, task);
 
-out:
-	/*
-	 * We processed the perf_event_header, the size, and ;size; bytes of
-	 * probe data.
-	 */
-	return sizeof(struct perf_event_header) + sizeof(u32) + size;
+	return 48;
 }
 
 /*
@@ -351,10 +340,9 @@ static void process_data(struct dtrace_buffer *buf)
 
 		/*
 		 * Ensure that the buffer contains enough data for at least one
-		 * sample (header + sample size + sample data).
+		 * sample.
 		 */
-		if (head - tail < sizeof(struct perf_event_header) +
-				  sizeof(u32) + 48)
+		if (head - tail < 48)
 			break;
 
 		if (*ptr)
diff --git a/tools/dtrace/probe1_bpf.c b/tools/dtrace/probe1_bpf.c
index 5b34edb61412..a3196261e66e 100644
--- a/tools/dtrace/probe1_bpf.c
+++ b/tools/dtrace/probe1_bpf.c
@@ -37,25 +37,16 @@ struct bpf_map_def SEC("maps") buffer_map = {
 	.max_entries = 2,
 };
 
-struct sample {
-	u64 probe_id;
-	u32 pid;
-	u32 ppid;
-	u32 cpu;
-	u32 euid;
-	u32 egid;
-	u64 task;
-	u32 tag;
-};
-
 #define DPROG(F)	SEC("dtrace/"__stringify(F)) int bpf_func_##F
+#define BUF_ID		offsetof(struct dtrace_bpf_context, buf)
 
 /* we jump here when syscall number == __NR_write */
 DPROG(__NR_write)(struct dtrace_bpf_context *ctx)
 {
 	int			cpu = bpf_get_smp_processor_id();
 	struct dtrace_ecb	*ecb;
-	struct sample		smpl;
+	u8			*buf, *buf_end;
+	int			err;
 
 	bpf_finalize_context(ctx, &probemap);
 
@@ -63,17 +54,25 @@ DPROG(__NR_write)(struct dtrace_bpf_context *ctx)
 	if (!ecb)
 		return 0;
 
-	memset(&smpl, 0, sizeof(smpl));
-	smpl.probe_id = ecb->probe_id;
-	smpl.pid = ctx->pid;
-	smpl.ppid = ctx->ppid;
-	smpl.cpu = ctx->cpu;
-	smpl.euid = ctx->euid;
-	smpl.egid = ctx->egid;
-	smpl.task = ctx->task;
-	smpl.tag = 0xdace;
-
-	bpf_perf_event_output(ctx, &buffer_map, cpu, &smpl, sizeof(smpl));
+	err = bpf_buffer_reserve(ctx, BUF_ID, &buffer_map, 48);
+	if (err < 0)
+		return -1;
+	buf = ctx->buf;
+	buf_end = ctx->buf_end;
+	if (buf + 48 > buf_end)
+		return -1;
+
+	*(u32 *)(&buf[0]) = ecb->probe_id;
+	*(u32 *)(&buf[4]) = 0;
+	*(u32 *)(&buf[8]) = ctx->pid;
+	*(u32 *)(&buf[12]) = ctx->ppid;
+	*(u32 *)(&buf[16]) = ctx->cpu;
+	*(u32 *)(&buf[20]) = ctx->euid;
+	*(u32 *)(&buf[24]) = ctx->egid;
+	*(u64 *)(&buf[32]) = ctx->task;
+	*(u32 *)(&buf[40]) = 0xdace;
+
+	bpf_buffer_commit(ctx, BUF_ID, &buffer_map);
 
 	return 0;
 }
@@ -84,7 +83,7 @@ int bpf_prog1(struct pt_regs *ctx)
 	struct dtrace_ecb	ecb;
 	int			cpu = bpf_get_smp_processor_id();
 
-	ecb.id = 1;
+	ecb.id = 3;
 	ecb.probe_id = 123;
 
 	bpf_map_update_elem(&probemap, &cpu, &ecb, BPF_ANY);
-- 
2.20.1

