Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F58222CC59
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 19:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGXRlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 13:41:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:38164 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726995AbgGXRlA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 13:41:00 -0400
IronPort-SDR: t7Buh1V0Uldu4odRSElS64LDUl7EvIZIsqjo/uCLgXXP2FGmzVTVi0QH9ivksO+QPgmAl2FBzM
 Up3DIEogsarw==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="168883124"
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="168883124"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 10:40:59 -0700
IronPort-SDR: 9DzeIU3oJr3og8PbrlG5vwwjSDILyd8K+tw71jv1uIUl0PFxy+omzUj73kXspIzKjy2POFk2be
 QJIXSWjqXV5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="463299970"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 24 Jul 2020 10:40:57 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 2/6] bpf: propagate poke descriptors to subprograms
Date:   Fri, 24 Jul 2020 19:35:53 +0200
Message-Id: <20200724173557.5764-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200724173557.5764-1-maciej.fijalkowski@intel.com>
References: <20200724173557.5764-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, there was no need for poke descriptors being present in
subprogram's bpf_prog_aux struct since tailcalls were simply not allowed
in them. Each subprog is JITed independently so in order to enable
JITing such subprograms, simply copy poke descriptors from main program
to subprogram's poke tab.

Add also subprog's aux struct to the BPF map poke_progs list by calling
on it map_poke_track().

In case of any error, call the map_poke_untrack() on subprog's aux
structs that have already been registered to prog array map.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/verifier.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9a6703bc3f36..f4955b4bf8a6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9900,6 +9900,7 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 {
 	struct bpf_prog *prog = env->prog, **func, *tmp;
 	int i, j, subprog_start, subprog_end = 0, len, subprog;
+	struct bpf_map *map_ptr;
 	struct bpf_insn *insn;
 	void *old_bpf_func;
 	int err, num_exentries;
@@ -9967,6 +9968,23 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
 
+		for (j = 0; j < prog->aux->size_poke_tab; j++) {
+			int ret;
+
+			ret = bpf_jit_add_poke_descriptor(func[i],
+							  &prog->aux->poke_tab[j]);
+			if (ret < 0) {
+				verbose(env, "adding tail call poke descriptor failed\n");
+				goto out_free;
+			}
+			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
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
@@ -10060,9 +10078,16 @@ static int jit_subprogs(struct bpf_verifier_env *env)
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
-- 
2.20.1

