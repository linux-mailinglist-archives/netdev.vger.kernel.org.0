Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5751326F7
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgAGNDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:03:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:35674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgAGNDg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jan 2020 08:03:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 788E4B193;
        Tue,  7 Jan 2020 13:03:34 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stanislav Fomichev <sdf@google.com>,
        Peter Wu <peter@lekensteyn.nl>,
        Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] libbpf: Add probe for large INSN limit
Date:   Tue,  7 Jan 2020 14:03:05 +0100
Message-Id: <20200107130308.20242-2-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200107130308.20242-1-mrostecki@opensuse.org>
References: <20200107130308.20242-1-mrostecki@opensuse.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new probe which checks whether kernel has large maximum
program size (1M) which was increased in the following commit:

c04c0d2b968a ("bpf: increase complexity limit and maximum program size")

Based on the similar check in Cilium[0], authored by Daniel Borkmann.

[0] https://github.com/cilium/cilium/commit/657d0f585afd26232cfa5d4e70b6f64d2ea91596

Co-authored-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/lib/bpf/libbpf.h        |  1 +
 tools/lib/bpf/libbpf.map      |  1 +
 tools/lib/bpf/libbpf_probes.c | 21 +++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index fe592ef48f1b..26bf539f1b3c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -521,6 +521,7 @@ LIBBPF_API bool bpf_probe_prog_type(enum bpf_prog_type prog_type,
 LIBBPF_API bool bpf_probe_map_type(enum bpf_map_type map_type, __u32 ifindex);
 LIBBPF_API bool bpf_probe_helper(enum bpf_func_id id,
 				 enum bpf_prog_type prog_type, __u32 ifindex);
+LIBBPF_API bool bpf_probe_large_insn_limit(__u32 ifindex);
 
 /*
  * Get bpf_prog_info in continuous memory
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index e9713a574243..b300d74c921a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -219,6 +219,7 @@ LIBBPF_0.0.7 {
 		bpf_object__detach_skeleton;
 		bpf_object__load_skeleton;
 		bpf_object__open_skeleton;
+		bpf_probe_large_insn_limit;
 		bpf_prog_attach_xattr;
 		bpf_program__attach;
 		bpf_program__name;
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index a9eb8b322671..221e6ad97012 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -321,3 +321,24 @@ bool bpf_probe_helper(enum bpf_func_id id, enum bpf_prog_type prog_type,
 
 	return res;
 }
+
+/*
+ * Probe for availability of kernel commit (5.3):
+ *
+ * c04c0d2b968a ("bpf: increase complexity limit and maximum program size")
+ */
+bool bpf_probe_large_insn_limit(__u32 ifindex)
+{
+	struct bpf_insn insns[BPF_MAXINSNS + 1];
+	int i;
+
+	for (i = 0; i < BPF_MAXINSNS; i++)
+		insns[i] = BPF_MOV64_IMM(BPF_REG_0, 1);
+	insns[BPF_MAXINSNS] = BPF_EXIT_INSN();
+
+	errno = 0;
+	probe_load(BPF_PROG_TYPE_SCHED_CLS, insns, ARRAY_SIZE(insns), NULL, 0,
+		   ifindex);
+
+	return errno != E2BIG && errno != EINVAL;
+}
-- 
2.16.4

