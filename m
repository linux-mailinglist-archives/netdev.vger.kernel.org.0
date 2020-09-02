Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891BC25B52D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgIBUOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:14:31 -0400
Received: from mga05.intel.com ([192.55.52.43]:48037 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIBUOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:14:25 -0400
IronPort-SDR: 37MusKCEUF88d0rT40u4CdjGweyrUT0Uz+qYey7OXW92XF9ih4tiRzTGAHvhvlRl//JaC4gi8S
 0H3at8MgW+Sw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="242291935"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="242291935"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 13:14:24 -0700
IronPort-SDR: NHvtzV1AHi+W5BUygx0E5pAzHqQCbfsK8Ef6e1B4YmikscHL1Hfk7rDxXnLLLYQWjIUX4u2vMQ
 x+nBWGLZG+WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="477778254"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 02 Sep 2020 13:14:23 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 bpf-next 2/7] bpf: propagate poke descriptors to subprograms
Date:   Wed,  2 Sep 2020 22:08:10 +0200
Message-Id: <20200902200815.3924-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, there was no need for poke descriptors being present in
subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
in them. Each subprog is JITed independently so in order to enable
JITing subprograms that use tailcalls, do the following:

- in fixup_bpf_calls() store the index of tailcall insn onto the generated
  poke descriptor,
- then in jit_subprogs() check whether the given poke descriptor belongs
  to the current subprog by checking if that previously stored absolute
  index of tail call insn is in the scope of the insns of given subprog,
- update the insn->imm with new poke descriptor slot so that while JITing
  the proper poke descriptor will be grabbed

This way each of the main program's poke descriptors are distributed
across the subprograms poke descriptor array, so main program's
descriptors can be untracked out of the prog array map.

Add also subprog's aux struct to the BPF map poke_progs list by calling
on it map_poke_track().

In case of any error, call the map_poke_untrack() on subprog's aux
structs that have already been registered to prog array map.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/linux/bpf.h   |  1 +
 kernel/bpf/verifier.c | 53 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c6d9f2c444f4..a3f92500e493 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -707,6 +707,7 @@ struct bpf_jit_poke_descriptor {
 	bool ip_stable;
 	u8 adj_off;
 	u16 reason;
+	u32 insn_idx;
 };
 
 /* reg_type info for ctx arguments */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b4e9c56b8b32..8f9e95f5f73f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10165,6 +10165,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog, **func, *tmp;
 	int i, j, subprog_start, subprog_end = 0, len, subprog;
+	struct bpf_map *map_ptr;
 	struct bpf_insn *insn;
 	void *old_bpf_func;
 	int err, num_exentries;
@@ -10232,6 +10233,31 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
 
+		for (j = 0; j < prog->aux->size_poke_tab; j++) {
+			u32 insn_idx = prog->aux->poke_tab[j].insn_idx;
+			int ret;
+
+			if (!(insn_idx >= subprog_start &&
+			      insn_idx <= subprog_end))
+				continue;
+
+			ret = bpf_jit_add_poke_descriptor(func[i],
+							  &prog->aux->poke_tab[j]);
+			if (ret < 0) {
+				verbose(env, "adding tail call poke descriptor failed\n");
+				goto out_free;
+			}
+
+			func[i]->insnsi[insn_idx - subprog_start].imm = ret + 1;
+
+			map_ptr = func[i]->aux->poke_tab[ret].tail_call.map;
+			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
+			if (ret < 0) {
+				verbose(env, "tracking tail call prog failed\n");
+				goto out_free;
+			}
+		}
+
 		/* Use bpf_prog_F_tag to indicate functions in stack traces.
 		 * Long term would need debug info to populate names
 		 */
@@ -10257,6 +10283,19 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		}
 		cond_resched();
 	}
+
+	/* Untrack main program's aux structs so that during map_poke_run()
+	 * we will not stumble upon the unfilled poke descriptors; each
+	 * of the main program's poke descs got distributed across subprogs
+	 * and got tracked onto map, so we are sure that none of them will
+	 * be missed after the operation below
+	 */
+	for (i = 0; i < prog->aux->size_poke_tab; i++) {
+		map_ptr = prog->aux->poke_tab[i].tail_call.map;
+
+		map_ptr->ops->map_poke_untrack(map_ptr, prog->aux);
+	}
+
 	/* at this point all bpf functions were successfully JITed
 	 * now populate all bpf_calls with correct addresses and
 	 * run last pass of JIT
@@ -10325,9 +10364,16 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	bpf_prog_free_unused_jited_linfo(prog);
 	return 0;
 out_free:
-	for (i = 0; i < env->subprog_cnt; i++)
-		if (func[i])
-			bpf_jit_free(func[i]);
+	for (i = 0; i < env->subprog_cnt; i++) {
+		if (!func[i])
+			continue;
+
+		for (j = 0; j < func[i]->aux->size_poke_tab; j++) {
+			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
+			map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
+		}
+		bpf_jit_free(func[i]);
+	}
 	kfree(func);
 out_undo_insn:
 	/* cleanup main prog to be interpreted */
@@ -10545,6 +10591,7 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 					.reason = BPF_POKE_REASON_TAIL_CALL,
 					.tail_call.map = BPF_MAP_PTR(aux->map_ptr_state),
 					.tail_call.key = bpf_map_key_immediate(aux),
+					.insn_idx = i,
 				};
 
 				ret = bpf_jit_add_poke_descriptor(prog, &desc);
-- 
2.20.1

