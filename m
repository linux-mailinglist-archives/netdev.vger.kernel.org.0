Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8503227F75
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbgGUL6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:58:41 -0400
Received: from mga17.intel.com ([192.55.52.151]:50577 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgGUL6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:58:39 -0400
IronPort-SDR: cx8IN0aB+Ip6C/n1uP58vT54weU2w7twcSck74AaVbV2XfYQVsmkKq/cPz+H3We9htEwjbw4zu
 bjkZ9B5sLZvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="130182758"
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="130182758"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 04:58:39 -0700
IronPort-SDR: W+RCztn0uXu/o3i3QFoDrOtFmx25hCDo9kbtI5QyumQw58p4e9jAr1ynAV33ZWDgXBEvmTiOT1
 NoCzbXKqsB4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="431968447"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 21 Jul 2020 04:58:37 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 2/6] bpf: propagate poke descriptors to subprograms
Date:   Tue, 21 Jul 2020 13:53:17 +0200
Message-Id: <20200721115321.3099-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
References: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
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
 kernel/bpf/verifier.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c1efc9d08fd..3428edf85220 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9936,6 +9936,9 @@ static int jit_subprogs(struct bpf_verifier_env *env)
 		goto out_undo_insn;
 
 	for (i = 0; i < env->subprog_cnt; i++) {
+		struct bpf_map *map_ptr;
+		int j;
+
 		subprog_start = subprog_end;
 		subprog_end = env->subprog_info[i + 1].start;
 
@@ -9960,6 +9963,23 @@ static int jit_subprogs(struct bpf_verifier_env *env)
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
-- 
2.20.1

