Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC4F227F7A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 13:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729903AbgGUL6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 07:58:47 -0400
Received: from mga17.intel.com ([192.55.52.151]:50591 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbgGUL6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 07:58:46 -0400
IronPort-SDR: LTryhciaTkMfVNwzUVDSvj0mhwdShi0plAZYvssc0+kc5r5YB6czdozOAhJicTatU5hFUMbnw8
 kxFceOMrlCNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="130182765"
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="130182765"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 04:58:45 -0700
IronPort-SDR: E9cVa2oYinX49wVHyUjbIqqDFQRx/nn0MPlYmini1CMOuKqxFYeI4N+aH/WK/nE2o3MDz5FkfZ
 yc0RgbJodGmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,378,1589266800"; 
   d="scan'208";a="431968479"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 21 Jul 2020 04:58:44 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 5/6] bpf: allow for tailcalls in BPF subprograms for x64 JIT
Date:   Tue, 21 Jul 2020 13:53:20 +0200
Message-Id: <20200721115321.3099-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
References: <20200721115321.3099-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relax verifier's restriction that was meant to forbid tailcall usage
when subprog count was higher than 1.

Also, do not max out the stack depth of program that utilizes tailcalls.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3428edf85220..37b1b344b851 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4172,10 +4172,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_FUNC_tail_call:
 		if (map->map_type != BPF_MAP_TYPE_PROG_ARRAY)
 			goto error;
+#if !defined(CONFIG_X86_64) || !defined(CONFIG_BPF_JIT_ALWAYS_ON)
 		if (env->subprog_cnt > 1) {
 			verbose(env, "tail_calls are not allowed in programs with bpf-to-bpf calls\n");
 			return -EINVAL;
 		}
+#endif
 		break;
 	case BPF_FUNC_perf_event_read:
 	case BPF_FUNC_perf_event_output:
@@ -10272,7 +10274,9 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			 * the program array.
 			 */
 			prog->cb_access = 1;
+#if !defined(CONFIG_X86_64) || !defined(CONFIG_BPF_JIT_ALWAYS_ON)
 			env->prog->aux->stack_depth = MAX_BPF_STACK;
+#endif
 			env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 
 			/* mark bpf_tail_call as different opcode to avoid
-- 
2.20.1

