Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0827622B507
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgGWRkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:40:18 -0400
Received: from mga06.intel.com ([134.134.136.31]:56227 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgGWRkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 13:40:16 -0400
IronPort-SDR: PlG8WkeFKGPdlqn8I1BcMjMc4gPHx/N/qL2C6KJw+GwPeV9xsdNZzRCyRJCqlcseJO4GJaGsoa
 cPRZewkhF23g==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="212124555"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="212124555"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 10:40:16 -0700
IronPort-SDR: 3bbGuuME/b8hfbyGZZrD/VLT9gyx1EnJdYlZ/or5kfk/H7i1OMF3uN1AFz03oOV90RuVNhJH8A
 F2c9pN46InzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="462940302"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2020 10:40:14 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 2/6] bpf: propagate poke descriptors to subprograms
Date:   Thu, 23 Jul 2020 19:35:04 +0200
Message-Id: <20200723173508.62285-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
References: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
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
 kernel/bpf/verifier.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9a6703bc3f36..0cf5e4e4af95 100644
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
@@ -9943,6 +9944,8 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		goto out_undo_insn;
 
 	for (i = 0; i < env->subprog_cnt; i++) {
+		int j;
+
 		subprog_start = subprog_end;
 		subprog_end = env->subprog_info[i + 1].start;
 
@@ -9967,6 +9970,23 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
 
+		for (j = 0; j < prog->aux->size_poke_tab; j++) {
+			int ret;
+
+			ret = bpf_jit_add_poke_descriptor(func[i],
+							  &prog->aux->poke_tab[j]);
+			if (ret < 0) {
+				verbose(env, "adding tail call poke descriptor failed\n");
+				goto out_untrack;
+			}
+			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
+			ret = map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
+			if (ret < 0) {
+				verbose(env, "tracking tail call prog failed\n");
+				goto out_untrack;
+			}
+		}
+
 		/* Use bpf_prog_F_tag to indicate functions in stack traces.
 		 * Long term would need debug info to populate names
 		 */
@@ -10059,6 +10079,17 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 	prog->aux->func_cnt = env->subprog_cnt;
 	bpf_prog_free_unused_jited_linfo(prog);
 	return 0;
+out_untrack:
+	while (j--) {
+		map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
+		map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
+	}
+	while (i--) {
+		for (j = 0; j < prog->aux->size_poke_tab; j++) {
+			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
+			map_ptr->ops->map_poke_untrack(map_ptr, func[i]->aux);
+		}
+	}
 out_free:
 	for (i = 0; i < env->subprog_cnt; i++)
 		if (func[i])
-- 
2.20.1

