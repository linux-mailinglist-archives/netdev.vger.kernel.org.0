Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA6837CD6
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 20:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfFFSzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 14:55:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46678 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726379AbfFFSzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 14:55:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56IlpQW010083;
        Thu, 6 Jun 2019 11:54:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=bLomYIHuVcipbAMZ+czyy/4GoLUzdwyUq/qjc/WfjVo=;
 b=WQJq3JGKk3R/Si9GwrJ6Qbu3Jy+NhqaGmtVszRPwms2MFKLymga6M3XjXGJl/rWL88WQ
 Rvylfyi0XqDBtiEm66akD0J1t5gk68vthtafZ0JZHVk9ARKqZ4e63MpbM+V+qt4RMUFf
 qPvmuGFtnxWc5Cu24CkudqYfrhY/aXtFWfU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2sy7pu87gm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Jun 2019 11:54:36 -0700
Received: from mmullins-1.thefacebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server id
 15.1.1713.5; Thu, 6 Jun 2019 11:54:34 -0700
From:   Matt Mullins <mmullins@fb.com>
To:     <hall@fb.com>, <mmullins@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf] bpf: fix nested bpf tracepoints with per-cpu data
Date:   Thu, 6 Jun 2019 11:54:27 -0700
Message-ID: <20190606185427.7558-1-mmullins@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com>
References: <a6a31da39debb8bde6ca5085b0f4e43a96a88ea5.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [2620:10d:c081:10::13]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_PROG_TYPE_RAW_TRACEPOINTs can be executed nested on the same CPU, as
they do not increment bpf_prog_active while executing.

This enables three levels of nesting, to support
  - a kprobe or raw tp or perf event,
  - another one of the above that irq context happens to call, and
  - another one in nmi context
(at most one of which may be a kprobe or perf event).

Fixes: 20b9d7ac4852 ("bpf: avoid excessive stack usage for perf_sample_data")
---
This is more lines of code, but possibly less intrusive than the
per-array-element approach.

I don't necessarily like that I duplicated the nest_level logic in two
places, but I don't see a way to unify them:
  - kprobes' bpf_perf_event_output doesn't use bpf_raw_tp_regs, and does
    use the perf_sample_data,
  - raw tracepoints' bpf_get_stackid uses bpf_raw_tp_regs, but not
    the perf_sample_data, and
  - raw tracepoints' bpf_perf_event_output uses both...

 kernel/trace/bpf_trace.c | 95 +++++++++++++++++++++++++++++++++-------
 1 file changed, 80 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index f92d6ad5e080..4f5419837ddd 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -410,8 +410,6 @@ static const struct bpf_func_proto bpf_perf_event_read_value_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
-static DEFINE_PER_CPU(struct perf_sample_data, bpf_trace_sd);
-
 static __always_inline u64
 __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
 			u64 flags, struct perf_sample_data *sd)
@@ -442,24 +440,47 @@ __bpf_perf_event_output(struct pt_regs *regs, struct bpf_map *map,
 	return perf_event_output(event, sd, regs);
 }
 
+/*
+ * Support executing tracepoints in normal, irq, and nmi context that each call
+ * bpf_perf_event_output
+ */
+struct bpf_trace_sample_data {
+	struct perf_sample_data sds[3];
+};
+
+static DEFINE_PER_CPU(struct bpf_trace_sample_data, bpf_trace_sds);
+static DEFINE_PER_CPU(int, bpf_trace_nest_level);
 BPF_CALL_5(bpf_perf_event_output, struct pt_regs *, regs, struct bpf_map *, map,
 	   u64, flags, void *, data, u64, size)
 {
-	struct perf_sample_data *sd = this_cpu_ptr(&bpf_trace_sd);
+	struct bpf_trace_sample_data *sds = this_cpu_ptr(&bpf_trace_sds);
+	struct perf_sample_data *sd;
+	int nest_level = this_cpu_inc_return(bpf_trace_nest_level);
 	struct perf_raw_record raw = {
 		.frag = {
 			.size = size,
 			.data = data,
 		},
 	};
+	int err = -EBUSY;
 
+	if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(sds->sds)))
+		goto out;
+
+	sd = &sds->sds[nest_level - 1];
+
+	err = -EINVAL;
 	if (unlikely(flags & ~(BPF_F_INDEX_MASK)))
-		return -EINVAL;
+		goto out;
 
 	perf_sample_data_init(sd, 0, 0);
 	sd->raw = &raw;
 
-	return __bpf_perf_event_output(regs, map, flags, sd);
+	err = __bpf_perf_event_output(regs, map, flags, sd);
+
+out:
+	this_cpu_dec(bpf_trace_nest_level);
+	return err;
 }
 
 static const struct bpf_func_proto bpf_perf_event_output_proto = {
@@ -822,16 +843,48 @@ pe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 /*
  * bpf_raw_tp_regs are separate from bpf_pt_regs used from skb/xdp
  * to avoid potential recursive reuse issue when/if tracepoints are added
- * inside bpf_*_event_output, bpf_get_stackid and/or bpf_get_stack
+ * inside bpf_*_event_output, bpf_get_stackid and/or bpf_get_stack.
+ *
+ * Since raw tracepoints run despite bpf_prog_active, support concurrent usage
+ * in normal, irq, and nmi context.
  */
-static DEFINE_PER_CPU(struct pt_regs, bpf_raw_tp_regs);
+struct bpf_raw_tp_regs {
+	struct pt_regs regs[3];
+};
+static DEFINE_PER_CPU(struct bpf_raw_tp_regs, bpf_raw_tp_regs);
+static DEFINE_PER_CPU(int, bpf_raw_tp_nest_level);
+static struct pt_regs *get_bpf_raw_tp_regs(void)
+{
+	struct bpf_raw_tp_regs *tp_regs = this_cpu_ptr(&bpf_raw_tp_regs);
+	int nest_level = this_cpu_inc_return(bpf_raw_tp_nest_level);
+
+	if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(tp_regs->regs))) {
+		this_cpu_dec(bpf_raw_tp_nest_level);
+		return ERR_PTR(-EBUSY);
+	}
+
+	return &tp_regs->regs[nest_level - 1];
+}
+
+static void put_bpf_raw_tp_regs(void)
+{
+	this_cpu_dec(bpf_raw_tp_nest_level);
+}
+
 BPF_CALL_5(bpf_perf_event_output_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags, void *, data, u64, size)
 {
-	struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
+	struct pt_regs *regs = get_bpf_raw_tp_regs();
+	int ret;
+
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
 	perf_fetch_caller_regs(regs);
-	return ____bpf_perf_event_output(regs, map, flags, data, size);
+	ret = ____bpf_perf_event_output(regs, map, flags, data, size);
+
+	put_bpf_raw_tp_regs();
+	return ret;
 }
 
 static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
@@ -848,12 +901,18 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_raw_tp = {
 BPF_CALL_3(bpf_get_stackid_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   struct bpf_map *, map, u64, flags)
 {
-	struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
+	struct pt_regs *regs = get_bpf_raw_tp_regs();
+	int ret;
+
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
 	perf_fetch_caller_regs(regs);
 	/* similar to bpf_perf_event_output_tp, but pt_regs fetched differently */
-	return bpf_get_stackid((unsigned long) regs, (unsigned long) map,
-			       flags, 0, 0);
+	ret = bpf_get_stackid((unsigned long) regs, (unsigned long) map,
+			      flags, 0, 0);
+	put_bpf_raw_tp_regs();
+	return ret;
 }
 
 static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
@@ -868,11 +927,17 @@ static const struct bpf_func_proto bpf_get_stackid_proto_raw_tp = {
 BPF_CALL_4(bpf_get_stack_raw_tp, struct bpf_raw_tracepoint_args *, args,
 	   void *, buf, u32, size, u64, flags)
 {
-	struct pt_regs *regs = this_cpu_ptr(&bpf_raw_tp_regs);
+	struct pt_regs *regs = get_bpf_raw_tp_regs();
+	int ret;
+
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
 
 	perf_fetch_caller_regs(regs);
-	return bpf_get_stack((unsigned long) regs, (unsigned long) buf,
-			     (unsigned long) size, flags, 0);
+	ret = bpf_get_stack((unsigned long) regs, (unsigned long) buf,
+			    (unsigned long) size, flags, 0);
+	put_bpf_raw_tp_regs();
+	return ret;
 }
 
 static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
-- 
2.17.1

