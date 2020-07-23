Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E7322B50C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgGWRkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:40:25 -0400
Received: from mga06.intel.com ([134.134.136.31]:56242 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730198AbgGWRkY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 13:40:24 -0400
IronPort-SDR: pT14UnaD/gDWX7q675ZyG0AQH/ZaJ8ycV8eyPw87etUIeQNttoyorIFexkjFI4rI8kaUG9Nobz
 CcBI0yDi/r9A==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="212124608"
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="212124608"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 10:40:23 -0700
IronPort-SDR: Qduyl20cZmyPnFWt3HDKVa9lmNaetSz3kGkYlwNPCVfA636ex/SuWOwI/szok6oqiKMV1BexBp
 v1KdgcYqUQog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,387,1589266800"; 
   d="scan'208";a="462940330"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 23 Jul 2020 10:40:21 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 5/6] bpf: allow for tailcalls in BPF subprograms for x64 JIT
Date:   Thu, 23 Jul 2020 19:35:07 +0200
Message-Id: <20200723173508.62285-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
References: <20200723173508.62285-1-maciej.fijalkowski@intel.com>
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
index 0cf5e4e4af95..2e8f20875c90 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4176,10 +4176,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
@@ -10290,7 +10292,9 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
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

