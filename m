Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF14725B530
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgIBUOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:14:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:48051 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgIBUOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:14:32 -0400
IronPort-SDR: AWlKX7be8k7f3MGccJDTMQopKa6Rwq9kHwY1K6L/l07E78nY71i6RQZMPWUwNnpHvDJFbGcENZ
 hj4noj4jKoaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="242291952"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="242291952"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 13:14:30 -0700
IronPort-SDR: 8RZe0q/ynjijoP/vSD8tnpLtw3B/ameEnsl07LYN+kRtp8wfBL5aA34N6Z3LhHcqVSbYBGX3Qy
 Q1K87gkBD9rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="477778276"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 02 Sep 2020 13:14:29 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 bpf-next 5/7] bpf: limit caller's stack depth 256 for subprogs with tailcalls
Date:   Wed,  2 Sep 2020 22:08:13 +0200
Message-Id: <20200902200815.3924-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Protect against potential stack overflow that might happen when bpf2bpf
calls get combined with tailcalls. Limit the caller's stack depth for
such case down to 256 so that the worst case scenario would result in 8k
stack size (32 which is tailcall limit * 256 = 8k).

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 53c7bd568c5d..5026b75db972 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -358,6 +358,7 @@ struct bpf_subprog_info {
 	u32 start; /* insn idx of function entry point */
 	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
 	u16 stack_depth; /* max. stack depth used by this function */
+	bool has_tail_call;
 };
 
 /* single container for all structs
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8f9e95f5f73f..b12527d87edb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1490,6 +1490,8 @@ static int check_subprogs(struct bpf_verifier_env *env)
 	for (i = 0; i < insn_cnt; i++) {
 		u8 code = insn[i].code;
 
+		if (insn[i].imm == BPF_FUNC_tail_call)
+			subprog[cur_subprog].has_tail_call = true;
 		if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
 			goto next;
 		if (BPF_OP(code) == BPF_EXIT || BPF_OP(code) == BPF_CALL)
@@ -2983,6 +2985,32 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 	int ret_prog[MAX_CALL_FRAMES];
 
 process_func:
+#if defined(CONFIG_X86_64) && defined(CONFIG_BPF_JIT_ALWAYS_ON)
+	/* protect against potential stack overflow that might happen when
+	 * bpf2bpf calls get combined with tailcalls. Limit the caller's stack
+	 * depth for such case down to 256 so that the worst case scenario
+	 * would result in 8k stack size (32 which is tailcall limit * 256 =
+	 * 8k).
+	 *
+	 * To get the idea what might happen, see an example:
+	 * func1 -> sub rsp, 128
+	 *  subfunc1 -> sub rsp, 256
+	 *  tailcall1 -> add rsp, 256
+	 *   func2 -> sub rsp, 192 (total stack size = 128 + 192 = 320)
+	 *   subfunc2 -> sub rsp, 64
+	 *   subfunc22 -> sub rsp, 128
+	 *   tailcall2 -> add rsp, 128
+	 *    func3 -> sub rsp, 32 (total stack size 128 + 192 + 64 + 32 = 416)
+	 *
+	 * tailcall will unwind the current stack frame but it will not get rid
+	 * of caller's stack as shown on the example above.
+	 */
+	if (idx && subprog[idx].has_tail_call && depth >= 256) {
+		verbose(env, "Cannot do bpf_tail_call in subprog %d when call stack of previous frames is %d bytes. Too large\n",
+			idx, depth);
+		return -EACCES;
+	}
+#endif
 	/* round up to 32-bytes, since this is granularity
 	 * of interpreter stack size
 	 */
-- 
2.20.1

