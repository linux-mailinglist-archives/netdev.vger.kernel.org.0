Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F830627C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344175AbhA0Rra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:47:30 -0500
Received: from sym2.noone.org ([178.63.92.236]:50532 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236250AbhA0RrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 12:47:11 -0500
Received: by sym2.noone.org (Postfix, from userid 1002)
        id 4DQrcl2jklzvjfn; Wed, 27 Jan 2021 18:46:15 +0100 (CET)
From:   Tobias Klauser <tklauser@distanz.ch>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next] bpf: simplify cases in bpf_base_func_proto
Date:   Wed, 27 Jan 2021 18:46:15 +0100
Message-Id: <20210127174615.3038-1-tklauser@distanz.ch>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

!perfmon_capable() is checked before the last switch(func_id) in
bpf_base_func_proto. Thus, the cases BPF_FUNC_trace_printk and
BPF_FUNC_snprintf_btf can be moved to that last switch(func_id) to omit
the inline !perfmon_capable() checks.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 kernel/bpf/helpers.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 41ca280b1dc1..308427fe03a3 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -720,14 +720,6 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_spin_lock_proto;
 	case BPF_FUNC_spin_unlock:
 		return &bpf_spin_unlock_proto;
-	case BPF_FUNC_trace_printk:
-		if (!perfmon_capable())
-			return NULL;
-		return bpf_get_trace_printk_proto();
-	case BPF_FUNC_snprintf_btf:
-		if (!perfmon_capable())
-			return NULL;
-		return &bpf_snprintf_btf_proto;
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
 	case BPF_FUNC_per_cpu_ptr:
@@ -742,6 +734,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return NULL;
 
 	switch (func_id) {
+	case BPF_FUNC_trace_printk:
+		return bpf_get_trace_printk_proto();
 	case BPF_FUNC_get_current_task:
 		return &bpf_get_current_task_proto;
 	case BPF_FUNC_probe_read_user:
@@ -752,6 +746,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_probe_read_user_str_proto;
 	case BPF_FUNC_probe_read_kernel_str:
 		return &bpf_probe_read_kernel_str_proto;
+	case BPF_FUNC_snprintf_btf:
+		return &bpf_snprintf_btf_proto;
 	default:
 		return NULL;
 	}
-- 
2.30.0

