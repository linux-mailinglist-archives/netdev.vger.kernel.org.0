Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ED6212548
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgGBNyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:54:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:63657 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgGBNyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:54:31 -0400
IronPort-SDR: xoPajdBlLDRPAb1JtN3QPMl9tuBwtIm2whlUR3VDnX2R3yz4BRadfXDHhtvEG8kcmZ2UZaqCAk
 RQMu5nGbd2pA==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="208420019"
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="208420019"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 06:54:30 -0700
IronPort-SDR: 47+noT2RDTYHWxcR/EEmk9Pif8Phd9Xr2VUwA5NDLkBlNxSxwqyvmzM3NoxxHr16oCQtdugnZ5
 Qfc58uAU/wlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,304,1589266800"; 
   d="scan'208";a="482009570"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 02 Jul 2020 06:54:29 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [RFC PATCH bpf-next 2/5] bpf: allow for tailcalls in BPF subprograms
Date:   Thu,  2 Jul 2020 15:49:27 +0200
Message-Id: <20200702134930.4717-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
References: <20200702134930.4717-1-maciej.fijalkowski@intel.com>
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
index 7de98906ddf4..e7b6b059e6e9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4173,10 +4173,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
@@ -10243,7 +10239,6 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 			 * the program array.
 			 */
 			prog->cb_access = 1;
-			env->prog->aux->stack_depth = MAX_BPF_STACK;
 			env->prog->aux->max_pkt_offset = MAX_PACKET_OFF;
 
 			/* mark bpf_tail_call as different opcode to avoid
-- 
2.20.1

