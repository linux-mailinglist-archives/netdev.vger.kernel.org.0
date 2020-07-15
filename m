Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67BCE221888
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 01:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgGOXln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 19:41:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:52501 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbgGOXlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 19:41:42 -0400
IronPort-SDR: XVhuE0l5QxPvET520x8oMt2hm4lfNN8ZI3JDLjl8vZBJuN7bK78SmV1bhpGKiybhlAwjFGlW6x
 F5g8i7yJFhlg==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210823663"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="210823663"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 16:41:42 -0700
IronPort-SDR: 6UNKbwhd3zof/kOnMy0Q3kfn+PvHhCHrCijvgw39aBLQfLKFjcep/sc8ik/OT9YkjIFMjaYfN1
 9dnt++gZVacw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="390935580"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 15 Jul 2020 16:41:40 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 2/5] bpf: allow for tailcalls in BPF subprograms
Date:   Thu, 16 Jul 2020 01:36:31 +0200
Message-Id: <20200715233634.3868-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
References: <20200715233634.3868-1-maciej.fijalkowski@intel.com>
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
 kernel/bpf/verifier.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c1efc9d08fd..6481342b31ba 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4172,10 +4172,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_FUNC_tail_call:
 		if (map->map_type != BPF_MAP_TYPE_PROG_ARRAY)
 			goto error;
-		if (env->subprog_cnt > 1) {
-			verbose(env, "tail_calls are not allowed in programs with bpf-to-bpf calls\n");
-			return -EINVAL;
-		}
 		break;
 	case BPF_FUNC_perf_event_read:
 	case BPF_FUNC_perf_event_output:
@@ -10252,7 +10248,6 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			 * the program array.
 			 */
 			prog->cb_access = 1;
-			env->prog->aux->stack_depth = MAX_BPF_STACK;
 			env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 
 			/* mark bpf_tail_call as different opcode to avoid
-- 
2.20.1

