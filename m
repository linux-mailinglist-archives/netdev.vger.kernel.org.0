Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF2291D3A
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733185AbgJRTny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:43:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:36782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730269AbgJRTXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:23:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2079D20791;
        Sun, 18 Oct 2020 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049010;
        bh=qBf58oDai6bWC91U46c4PuXGWtEl4hhIe0JUylRGiZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2+YB2UGuicez3HpMtajthih77REfzlMWIzpgwcB2Z6qm/a7vICjB7VjeLsJNMPh2
         uHmSKy64xo6tx0g5OCcV+dNUz3rlI7RyLgTWsb8nd9fpy6oAxAo/uZwVUtgC3JJrIZ
         SOBKjVpPlgS49EP4lFVixPyPi4VtYJKxwCPqIZ8A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 46/80] bpf: Limit caller's stack depth 256 for subprogs with tailcalls
Date:   Sun, 18 Oct 2020 15:21:57 -0400
Message-Id: <20201018192231.4054535-46-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192231.4054535-1-sashal@kernel.org>
References: <20201018192231.4054535-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 7f6e4312e15a5c370e84eaa685879b6bdcc717e4 ]

Protect against potential stack overflow that might happen when bpf2bpf
calls get combined with tailcalls. Limit the caller's stack depth for
such case down to 256 so that the worst case scenario would result in 8k
stack size (32 which is tailcall limit * 256 = 8k).

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h |  1 +
 kernel/bpf/verifier.c        | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 26a6d58ca78cc..81c7ea83e8079 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -342,6 +342,7 @@ struct bpf_subprog_info {
 	u32 start; /* insn idx of function entry point */
 	u32 linfo_idx; /* The idx to the main_prog->aux->linfo */
 	u16 stack_depth; /* max. stack depth used by this function */
+	bool has_tail_call;
 };
 
 /* single container for all structs
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ae27dd77a73cb..507474f79195f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1160,6 +1160,10 @@ static int check_subprogs(struct bpf_verifier_env *env)
 	for (i = 0; i < insn_cnt; i++) {
 		u8 code = insn[i].code;
 
+		if (code == (BPF_JMP | BPF_CALL) &&
+		    insn[i].imm == BPF_FUNC_tail_call &&
+		    insn[i].src_reg != BPF_PSEUDO_CALL)
+			subprog[cur_subprog].has_tail_call = true;
 		if (BPF_CLASS(code) != BPF_JMP && BPF_CLASS(code) != BPF_JMP32)
 			goto next;
 		if (BPF_OP(code) == BPF_EXIT || BPF_OP(code) == BPF_CALL)
@@ -2612,6 +2616,31 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 	int ret_prog[MAX_CALL_FRAMES];
 
 process_func:
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
+		verbose(env,
+			"tail_calls are not allowed when call stack of previous frames is %d bytes. Too large\n",
+			depth);
+		return -EACCES;
+	}
 	/* round up to 32-bytes, since this is granularity
 	 * of interpreter stack size
 	 */
-- 
2.25.1

