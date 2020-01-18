Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E881417C9
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 14:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgARNuP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Jan 2020 08:50:15 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50079 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726614AbgARNuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 08:50:15 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-NoregmapOz-GfutR4GXN4A-1; Sat, 18 Jan 2020 08:50:11 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69DCB107ACC5;
        Sat, 18 Jan 2020 13:50:09 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-18.brq.redhat.com [10.40.204.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 55AF884BC9;
        Sat, 18 Jan 2020 13:49:59 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 3/6] bpf: Add bpf_get_stackid_kfunc
Date:   Sat, 18 Jan 2020 14:49:42 +0100
Message-Id: <20200118134945.493811-4-jolsa@kernel.org>
In-Reply-To: <20200118134945.493811-1-jolsa@kernel.org>
References: <20200118134945.493811-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: NoregmapOz-GfutR4GXN4A-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding support to use bpf_get_stackid_kfunc in
BPF_TRACE_FENTRY/BPF_TRACE_FEXIT programs.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/bpf_trace.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6a18e2ae6e30..18d6e96751c4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1198,12 +1198,39 @@ static const struct bpf_func_proto bpf_perf_event_output_proto_kfunc = {
 	.arg5_type	= ARG_CONST_SIZE_OR_ZERO,
 };
 
+BPF_CALL_3(bpf_get_stackid_kfunc, void*, args,
+	   struct bpf_map *, map, u64, flags)
+{
+	struct pt_regs *regs = get_bpf_raw_tp_regs();
+	int ret;
+
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
+	perf_fetch_caller_regs(regs);
+	ret = bpf_get_stackid((unsigned long) regs, (unsigned long) map,
+			      flags, 0, 0);
+	put_bpf_raw_tp_regs();
+	return ret;
+}
+
+static const struct bpf_func_proto bpf_get_stackid_proto_kfunc = {
+	.func		= bpf_get_stackid_kfunc,
+	.gpl_only	= true,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_PTR_TO_CTX,
+	.arg2_type	= ARG_CONST_MAP_PTR,
+	.arg3_type	= ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 kfunc_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
 	case BPF_FUNC_perf_event_output:
 		return &bpf_perf_event_output_proto_kfunc;
+	case BPF_FUNC_get_stackid:
+		return &bpf_get_stackid_proto_kfunc;
 	default:
 		return tracing_func_proto(func_id, prog);
 	}
-- 
2.24.1

