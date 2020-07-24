Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86922CC5B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 19:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgGXRlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 13:41:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:38188 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGXRlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 13:41:14 -0400
IronPort-SDR: qnOxSD3y70GqL4WedxxICCsrjzVqipBqpccnOhVVqJ2BlZQEGuwVMLSzPoYXPJ67FuNNujSTgc
 RNd1lWhnQ5+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="168883185"
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="168883185"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 10:41:09 -0700
IronPort-SDR: gizsJVzPmTo/1xzOvhV2PcdwKxKFEloPJQCd1HLqT6DAySI8x0sxQZzwwnji3auuKZY3Q7RsyL
 PEqQ0YLhEnIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,391,1589266800"; 
   d="scan'208";a="463300029"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 24 Jul 2020 10:41:06 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 5/6] bpf: allow for tailcalls in BPF subprograms for x64 JIT
Date:   Fri, 24 Jul 2020 19:35:56 +0200
Message-Id: <20200724173557.5764-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200724173557.5764-1-maciej.fijalkowski@intel.com>
References: <20200724173557.5764-1-maciej.fijalkowski@intel.com>
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
index f4955b4bf8a6..3ea769555246 100644
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
@@ -10284,7 +10286,9 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
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

