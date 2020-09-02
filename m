Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C20F25B52C
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIBUOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:14:30 -0400
Received: from mga05.intel.com ([192.55.52.43]:48041 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgIBUO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:14:27 -0400
IronPort-SDR: KeiLLYJ49xo4QZD1kLUQ3+qyQ/hXIQZ0KNI1LJPP015SWegKYkuzKN0rSZvnZl6KEebdCnn+jT
 WhexlwziTduA==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="242291939"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="242291939"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 13:14:26 -0700
IronPort-SDR: nk6VJ0rmPShuHuIntkbJO28VhXVN+kEVdeD3SCmdxjPKfIPQmrvZKt9WKSrHfUQX0W9s3FnLn2
 S1CxHOp6QRVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="477778262"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 02 Sep 2020 13:14:25 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 bpf-next 3/7] bpf: rename poke descriptor's 'ip' member to 'tailcall_target'
Date:   Wed,  2 Sep 2020 22:08:11 +0200
Message-Id: <20200902200815.3924-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reflect the actual purpose of poke->ip and rename it to
poke->tailcall_target so that it will not the be confused with another
poke target that will be introduced in next commit.

While at it, do the same thing with poke->ip_stable - rename it to
poke->tailcall_target_stable.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 20 +++++++++++---------
 include/linux/bpf.h         |  4 ++--
 kernel/bpf/arraymap.c       | 17 +++++++++--------
 kernel/bpf/core.c           |  3 ++-
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 6fb8c9435980..7b0ff169c9a0 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -434,7 +434,7 @@ static void emit_bpf_tail_call_direct(struct bpf_jit_poke_descriptor *poke,
 	EMIT3(0x83, 0xC0, 0x01);                      /* add eax, 1 */
 	EMIT2_off32(0x89, 0x85, -36 - MAX_BPF_STACK); /* mov dword ptr [rbp -548], eax */
 
-	poke->ip = image + (addr - X86_PATCH_SIZE);
+	poke->tailcall_target = image + (addr - X86_PATCH_SIZE);
 	poke->adj_off = PROLOGUE_SIZE;
 
 	memcpy(prog, ideal_nops[NOP_ATOMIC5], X86_PATCH_SIZE);
@@ -453,7 +453,7 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 
 	for (i = 0; i < prog->aux->size_poke_tab; i++) {
 		poke = &prog->aux->poke_tab[i];
-		WARN_ON_ONCE(READ_ONCE(poke->ip_stable));
+		WARN_ON_ONCE(READ_ONCE(poke->tailcall_target_stable));
 
 		if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
 			continue;
@@ -464,18 +464,20 @@ static void bpf_tail_call_direct_fixup(struct bpf_prog *prog)
 		if (target) {
 			/* Plain memcpy is used when image is not live yet
 			 * and still not locked as read-only. Once poke
-			 * location is active (poke->ip_stable), any parallel
-			 * bpf_arch_text_poke() might occur still on the
-			 * read-write image until we finally locked it as
-			 * read-only. Both modifications on the given image
-			 * are under text_mutex to avoid interference.
+			 * location is active (poke->tailcall_target_stable),
+			 * any parallel bpf_arch_text_poke() might occur
+			 * still on the read-write image until we finally
+			 * locked it as read-only. Both modifications on
+			 * the given image are under text_mutex to avoid
+			 * interference.
 			 */
-			ret = __bpf_arch_text_poke(poke->ip, BPF_MOD_JUMP, NULL,
+			ret = __bpf_arch_text_poke(poke->tailcall_target,
+						   BPF_MOD_JUMP, NULL,
 						   (u8 *)target->bpf_func +
 						   poke->adj_off, false);
 			BUG_ON(ret < 0);
 		}
-		WRITE_ONCE(poke->ip_stable, true);
+		WRITE_ONCE(poke->tailcall_target_stable, true);
 		mutex_unlock(&array->aux->poke_mutex);
 	}
 }
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a3f92500e493..366cef9b67ee 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -697,14 +697,14 @@ enum bpf_jit_poke_reason {
 
 /* Descriptor of pokes pointing /into/ the JITed image. */
 struct bpf_jit_poke_descriptor {
-	void *ip;
+	void *tailcall_target;
 	union {
 		struct {
 			struct bpf_map *map;
 			u32 key;
 		} tail_call;
 	};
-	bool ip_stable;
+	bool tailcall_target_stable;
 	u8 adj_off;
 	u16 reason;
 	u32 insn_idx;
diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index e046fb7d17cd..60abf7fe12de 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -918,12 +918,13 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 			 *    there could be danger of use after free otherwise.
 			 * 2) Initially when we start tracking aux, the program
 			 *    is not JITed yet and also does not have a kallsyms
-			 *    entry. We skip these as poke->ip_stable is not
-			 *    active yet. The JIT will do the final fixup before
-			 *    setting it stable. The various poke->ip_stable are
-			 *    successively activated, so tail call updates can
-			 *    arrive from here while JIT is still finishing its
-			 *    final fixup for non-activated poke entries.
+			 *    entry. We skip these as poke->tailcall_target_stable
+			 *    is not active yet. The JIT will do the final fixup
+			 *    before setting it stable. The various
+			 *    poke->tailcall_target_stable are successively
+			 *    activated, so tail call updates can arrive from here
+			 *    while JIT is still finishing its final fixup for
+			 *    non-activated poke entries.
 			 * 3) On program teardown, the program's kallsym entry gets
 			 *    removed out of RCU callback, but we can only untrack
 			 *    from sleepable context, therefore bpf_arch_text_poke()
@@ -940,7 +941,7 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 			 * 5) Any other error happening below from bpf_arch_text_poke()
 			 *    is a unexpected bug.
 			 */
-			if (!READ_ONCE(poke->ip_stable))
+			if (!READ_ONCE(poke->tailcall_target_stable))
 				continue;
 			if (poke->reason != BPF_POKE_REASON_TAIL_CALL)
 				continue;
@@ -948,7 +949,7 @@ static void prog_array_map_poke_run(struct bpf_map *map, u32 key,
 			    poke->tail_call.key != key)
 				continue;
 
-			ret = bpf_arch_text_poke(poke->ip, BPF_MOD_JUMP,
+			ret = bpf_arch_text_poke(poke->tailcall_target, BPF_MOD_JUMP,
 						 old ? (u8 *)old->bpf_func +
 						 poke->adj_off : NULL,
 						 new ? (u8 *)new->bpf_func +
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ed0b3578867c..a60c342e27e9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -773,7 +773,8 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
 
 	if (size > poke_tab_max)
 		return -ENOSPC;
-	if (poke->ip || poke->ip_stable || poke->adj_off)
+	if (poke->tailcall_target || poke->tailcall_target_stable ||
+	    poke->adj_off)
 		return -EINVAL;
 
 	switch (poke->reason) {
-- 
2.20.1

