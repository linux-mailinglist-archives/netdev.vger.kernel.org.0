Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683F225B531
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgIBUOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:14:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:48055 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIBUOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:14:34 -0400
IronPort-SDR: 9qHG6LMdJ/+TmOvn1asajj+spLXRutOWk4yIfyeaYom1wJn8ApTLgJRvWmZmYpFJEKsjHs1F0c
 T4ht9hH0z/mQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="242291955"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="242291955"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 13:14:32 -0700
IronPort-SDR: y/o2psJxavFkJiftCTTeWy4GutkMYpextkFn9DMf22PPutCOrtfuASBjV/NOb9Ss4Iznu+SyQc
 wcczWZGlmNig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="477778284"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 02 Sep 2020 13:14:32 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v7 bpf-next 6/7] bpf: allow for tailcalls in BPF subprograms for x64 JIT
Date:   Wed,  2 Sep 2020 22:08:14 +0200
Message-Id: <20200902200815.3924-7-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
References: <20200902200815.3924-1-maciej.fijalkowski@intel.com>
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
index b12527d87edb..deb6bf3d9f5d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4367,10 +4367,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
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
@@ -10598,7 +10600,9 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
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

