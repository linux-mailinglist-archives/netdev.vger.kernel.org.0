Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F262233C74
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 02:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgGaAJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 20:09:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:31495 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730874AbgGaAI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 20:08:59 -0400
IronPort-SDR: m9KX8/8YqL3FNfILa0d0vw1GxPD9TTocxdyR7NsmBtXEzTBACtDnMFsGOvOGS7qKBstayzb7jW
 U+WoKuvBMAiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131278095"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131278095"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 17:08:58 -0700
IronPort-SDR: 6XNMhwAc4uOr1U3z63I0Dh4MveplumSh1W54/SZ05wKpqQMospM4BDt3HrCeM9H3iBP3UjLddD
 xIK4oJrwxGUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="435237893"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 30 Jul 2020 17:08:56 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v6 bpf-next 5/6] bpf: allow for tailcalls in BPF subprograms for x64 JIT
Date:   Fri, 31 Jul 2020 02:03:23 +0200
Message-Id: <20200731000324.2253-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
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
index 96a339e24e93..fefc91f350d8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4251,10 +4251,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
@@ -10387,7 +10389,9 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
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

