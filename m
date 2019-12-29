Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586A912C2BA
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 15:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfL2Oh4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 29 Dec 2019 09:37:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47349 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726702AbfL2Ohz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 09:37:55 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-NCbSZOvOMXyKRDCtIq-2Bw-1; Sun, 29 Dec 2019 09:37:51 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 187D81005502;
        Sun, 29 Dec 2019 14:37:50 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-25.brq.redhat.com [10.40.204.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9824A5DA7D;
        Sun, 29 Dec 2019 14:37:47 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>
Subject: [PATCH 2/5] bpf: Add bpf_perf_event_output_kfunc
Date:   Sun, 29 Dec 2019 15:37:37 +0100
Message-Id: <20191229143740.29143-3-jolsa@kernel.org>
In-Reply-To: <20191229143740.29143-1-jolsa@kernel.org>
References: <20191229143740.29143-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: NCbSZOvOMXyKRDCtIq-2Bw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to use perf_event_output in
BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.

There are no pt_regs available in the trampoline,
so getting one via bpf_kfunc_regs array.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 67 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e5ef4ae9edb5..1b270bbd9016 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1151,6 +1151,69 @@ raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	}
 }
 
+struct bpf_kfunc_regs {
+	struct pt_regs regs[3];
+};
+
+static DEFINE_PER_CPU(struct bpf_kfunc_regs, bpf_kfunc_regs);
+static DEFINE_PER_CPU(int, bpf_kfunc_nest_level);
+
+static struct pt_regs *get_bpf_kfunc_regs(void)
+{
+	struct bpf_kfunc_regs *tp_regs = this_cpu_ptr(&bpf_kfunc_regs);
+	int nest_level = this_cpu_inc_return(bpf_kfunc_nest_level);
+
+	if (WARN_ON_ONCE(nest_level > ARRAY_SIZE(tp_regs->regs))) {
+		this_cpu_dec(bpf_kfunc_nest_level);
+		return ERR_PTR(-EBUSY);
+	}
+
+	return &tp_regs->regs[nest_level - 1];
+}
+
+static void put_bpf_kfunc_regs(void)
+{
+	this_cpu_dec(bpf_kfunc_nest_level);
+}
+
+BPF_CALL_5(bpf_perf_event_output_kfunc, void *, ctx, struct bpf_map *, map,
+	   u64, flags, void *, data, u64, size)
+{
+	struct pt_regs *regs = get_bpf_kfunc_regs();
+	int ret;
+
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	perf_fetch_caller_regs(regs);
+	ret = ____bpf_perf_event_output(regs, map, flags, data, size);
+
+	put_bpf_kfunc_regs();
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_perf_event_output_proto_kfunc = {
+	.func		= bpf_perf_event_output_kfunc,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_CONST_MAP_PTR,
+	.arg3_type	= ARG_ANYTHING,
+	.arg4_type	= ARG_PTR_TO_MEM,
+	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
+};
+
+static const struct bpf_func_proto *
+kfunc_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	switch (func_id) {
+	case BPF_FUNC_perf_event_output:
+		return &bpf_perf_event_output_proto_kfunc;
+	default:
+		return tracing_func_proto(func_id, prog);
+	}
+}
+
 static const struct bpf_func_proto *
 tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1160,6 +1223,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_output_proto;
 #endif
 	default:
+		if (prog->expected_attach_type == BPF_TRACE_FENTRY ||
+		    prog->expected_attach_type == BPF_TRACE_FEXIT)
+			return kfunc_prog_func_proto(func_id, prog);
+
 		return raw_tp_prog_func_proto(func_id, prog);
 	}
 }
-- 
2.21.1

