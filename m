Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6223D22188A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgGOXlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:41:46 -0400
Received: from mga06.intel.com ([134.134.136.31]:52501 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgGOXlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 19:41:44 -0400
IronPort-SDR: jmhNPQTZpE9UFZ/gnrUQtZTxonm0qMiA3FVBgycAYK9JXUzQSBtURaPgAaXicZ5fR67GpaLCEC
 KmgljHDtcVBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210823664"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210823664"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 16:41:44 -0700
IronPort-SDR: noQi8yOnnUPrvGa1AUOu207EPxmoFkDA8G+VT5M9J7IiRK15aNnYW9H4ce84r6TADgSXQ6cKgf
 PtZxrsFRASsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="390935584"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jul 2020 16:41:42 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 3/5] bpf: propagate poke descriptors to subprograms
Date:   Thu, 16 Jul 2020 01:36:32 +0200
Message-Id: <20200715233634.3868-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
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

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6481342b31ba..3b406b2860ef 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9932,6 +9932,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		goto out_undo_insn;
 
 	for (i = 0; i < env->subprog_cnt; i++) {
+		struct bpf_map *map_ptr;
+		int j;
+
 		subprog_start = subprog_end;
 		subprog_end = env->subprog_info[i + 1].start;
 
@@ -9956,6 +9959,12 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		func[i]->aux->btf = prog->aux->btf;
 		func[i]->aux->func_info = prog->aux->func_info;
 
+		for (j = 0; j < prog->aux->size_poke_tab; j++) {
+			bpf_jit_add_poke_descriptor(func[i], &prog->aux->poke_tab[j]);
+			map_ptr = func[i]->aux->poke_tab[j].tail_call.map;
+			map_ptr->ops->map_poke_track(map_ptr, func[i]->aux);
+		}
+
 		/* Use bpf_prog_F_tag to indicate functions in stack traces.
 		 * Long term would need debug info to populate names
 		 */
-- 
2.20.1

