Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33CDB3174A
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfEaWih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:38:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726446AbfEaWih (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:38:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VMOrc7003247;
        Fri, 31 May 2019 15:37:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=vyABID+kZojQHooTMHL8Mq7VmrGS7PzW4XMZp/EOHR4=;
 b=gN3apRhPMyoT9mh8MGSLp25iWUoJTh+nrrZBSeWLzWX6xfI3r2Wu4TKC7Z0P3iUeaTXh
 f6CjswR5wEz5kf2o+44e2Pe7w64cK+S/wbIOI4Glo3ijI66R3kUqxF7xc4YCqGMwC2jJ
 8WF6iPoKU3QFLc8jlO6ECmcKQ7TIT25nb7M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2subm50au8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 31 May 2019 15:37:48 -0700
Received: from mmullins-1.thefacebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server id
 15.1.1713.5; Fri, 31 May 2019 15:37:47 -0700
From:   Matt Mullins <mmullins@fb.com>
To:     <hall@fb.com>, <mmullins@fb.com>, <ast@kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Date:   Fri, 31 May 2019 15:37:34 -0700
Message-ID: <20190531223735.4998-1-mmullins@fb.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [2620:10d:c081:10::13]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that a BPF program can be called while another BPF
program is executing bpf_perf_event_output.  This has been observed with
I/O completion occurring as a result of an interrupt:

	bpf_prog_247fd1341cddaea4_trace_req_end+0x8d7/0x1000
	? trace_call_bpf+0x82/0x100
	? sch_direct_xmit+0xe2/0x230
	? blk_mq_end_request+0x1/0x100
	? blk_mq_end_request+0x5/0x100
	? kprobe_perf_func+0x19b/0x240
	? __qdisc_run+0x86/0x520
	? blk_mq_end_request+0x1/0x100
	? blk_mq_end_request+0x5/0x100
	? kprobe_ftrace_handler+0x90/0xf0
	? ftrace_ops_assist_func+0x6e/0xe0
	? ip6_input_finish+0xbf/0x460
	? 0xffffffffa01e80bf
	? nbd_dbg_flags_show+0xc0/0xc0 [nbd]
	? blkdev_issue_zeroout+0x200/0x200
	? blk_mq_end_request+0x1/0x100
	? blk_mq_end_request+0x5/0x100
	? flush_smp_call_function_queue+0x6c/0xe0
	? smp_call_function_single_interrupt+0x32/0xc0
	? call_function_single_interrupt+0xf/0x20
	? call_function_single_interrupt+0xa/0x20
	? swiotlb_map_page+0x140/0x140
	? refcount_sub_and_test+0x1a/0x50
	? tcp_wfree+0x20/0xf0
	? skb_release_head_state+0x62/0xc0
	? skb_release_all+0xe/0x30
	? napi_consume_skb+0xb5/0x100
	? mlx5e_poll_tx_cq+0x1df/0x4e0
	? mlx5e_poll_tx_cq+0x38c/0x4e0
	? mlx5e_napi_poll+0x58/0xc30
	? mlx5e_napi_poll+0x232/0xc30
	? net_rx_action+0x128/0x340
	? __do_softirq+0xd4/0x2ad
	? irq_exit+0xa5/0xb0
	? do_IRQ+0x7d/0xc0
	? common_interrupt+0xf/0xf
	</IRQ>
	? __rb_free_aux+0xf0/0xf0
	? perf_output_sample+0x28/0x7b0
	? perf_prepare_sample+0x54/0x4a0
	? perf_event_output+0x43/0x60
	? bpf_perf_event_output_raw_tp+0x15f/0x180
	? blk_mq_start_request+0x1/0x120
	? bpf_prog_411a64a706fc6044_should_trace+0xad4/0x1000
	? bpf_trace_run3+0x2c/0x80
	? nbd_send_cmd+0x4c2/0x690 [nbd]

This also cannot be alleviated by further splitting the per-cpu
perf_sample_data structs (as in commit 283ca526a9bd ("bpf: fix
corruption on concurrent perf_event_output calls")), as a raw_tp could
be attached to the block:block_rq_complete tracepoint and execute during
another raw_tp.  Instead, keep a pre-allocated perf_sample_data
structure per perf_event_array element and fail a bpf_perf_event_output
if that element is concurrently being used.

Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
Signed-off-by: Matt Mullins <mmullins@fb.com>
---
v1->v2:
	keep a pointer to the struct perf_sample_data rather than directly
	embedding it in the structure, avoiding the circular include and
	removing the need for in_use.  Suggested by Song.

 include/linux/bpf.h      |  1 +
 kernel/bpf/arraymap.c    |  3 ++-
 kernel/trace/bpf_trace.c | 29 ++++++++++++++++-------------
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4fb3aa2dc975..47fd85cfbbaf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -472,6 +472,7 @@ struct bpf_event_entry {
 	struct file *perf_file;
 	struct file *map_file;
 	struct rcu_head rcu;
+	struct perf_sample_data *sd;
 };
 
 bool bpf_prog_array_compatible(struct bpf_array *array, const struct bpf_prog *fp);
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 584636c9e2eb..c7f5d593e04f 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -654,11 +654,12 @@ static struct bpf_event_entry *bpf_event_entry_gen(struct file *perf_file,
 {
 	struct bpf_event_entry *ee;
 
-	ee = kzalloc(sizeof(*ee), GFP_ATOMIC);
+	ee = kzalloc(sizeof(*ee) + sizeof(struct perf_sample_data), GFP_ATOMIC);
 	if (ee) {
 		ee->event = perf_file->private_data;
 		ee->perf_file = perf_file;
 		ee->map_file = map_file;
+		ee->sd = (void *)ee + sizeof(*ee);
 	}
 
 	return ee;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f92d6ad5e080..076f8e987355 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -410,17 +410,17 @@ static const struct bpf_func_proto bpf_perf_event_read_value_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
-static DEFINE_PER_CPU(struct perf_sample_data, bpf_trace_sd);
-
 static __always_inline u64
 __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
-			u64 flags, struct perf_sample_data *sd)
+			u64 flags, struct perf_raw_record *raw)
 {
 	struct bpf_array *array = container_of(map, struct bpf_array, map);
 	unsigned int cpu = smp_processor_id();
 	u64 index = flags & BPF_F_INDEX_MASK;
 	struct bpf_event_entry *ee;
 	struct perf_event *event;
+	struct perf_sample_data *sd;
+	u64 ret;
 
 	if (index == BPF_F_CURRENT_CPU)
 		index = cpu;
@@ -439,13 +439,22 @@ __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
 	if (unlikely(event->oncpu != cpu))
 		return -EOPNOTSUPP;
 
-	return perf_event_output(event, sd, regs);
+	sd = xchg(&ee->sd, NULL);
+	if (!sd)
+		return -EBUSY;
+
+	perf_sample_data_init(sd, 0, 0);
+	sd->raw = raw;
+
+	ret = perf_event_output(event, sd, regs);
+
+	xchg(&ee->sd, sd);
+	return ret;
 }
 
 BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map *, map,
 	   u64, flags, void *, data, u64, size)
 {
-	struct perf_sample_data *sd = this_cpu_ptr(&bpf_trace_sd);
 	struct perf_raw_record raw = {
 		.frag = {
 			.size = size,
@@ -456,10 +465,8 @@ BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map *, map,
 	if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
 		return -EINVAL;
 
-	perf_sample_data_init(sd, 0, 0);
-	sd->raw = &raw;
 
-	return __bpf_perf_event_output(regs, map, flags, sd);
+	return __bpf_perf_event_output(regs, map, flags, &raw);
 }
 
 static const struct bpf_func_proto bpf_perf_event_output_proto = {
@@ -474,12 +481,10 @@ static const struct bpf_func_proto bpf_perf_event_output_proto = {
 };
 
 static DEFINE_PER_CPU(struct pt_regs, bpf_pt_regs);
-static DEFINE_PER_CPU(struct perf_sample_data, bpf_misc_sd);
 
 u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 		     void *ctx, u64 ctx_size, bpf_ctx_copy_t ctx_copy)
 {
-	struct perf_sample_data *sd = this_cpu_ptr(&bpf_misc_sd);
 	struct pt_regs *regs = this_cpu_ptr(&bpf_pt_regs);
 	struct perf_raw_frag frag = {
 		.copy		= ctx_copy,
@@ -497,10 +502,8 @@ u64 bpf_event_output(struct bpf_map *map, u64 flags, void *meta, u64 meta_size,
 	};
 
 	perf_fetch_caller_regs(regs);
-	perf_sample_data_init(sd, 0, 0);
-	sd->raw = &raw;
 
-	return __bpf_perf_event_output(regs, map, flags, sd);
+	return __bpf_perf_event_output(regs, map, flags, &raw);
 }
 
 BPF_CALL_0(bpf_get_current_task)
-- 
2.17.1

