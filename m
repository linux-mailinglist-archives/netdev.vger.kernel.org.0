Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92626335DD
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiKVHeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:34:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiKVHd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:33:58 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26CC17057;
        Mon, 21 Nov 2022 23:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669102437; x=1700638437;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GlheoP3S8KQYlEN0ZjlBFqE/Uf9kh5WCBdTEusKSsHE=;
  b=UkZN1cTzD5/gIu4fr20ZcOanEOieuyFkWTXjlZVsGBwjet9KFdWnfZwk
   PJoplC4nONg5gS8402cQu2f1nDOxoPwG/nZSR1FxKEntfOU6iQgh+il9L
   nBCr3mWmRs8NTB5YD5b+c/0ILWayXey164ZP+94721uiGbDIOZWoZi8Ez
   6aEfDF9fSjSNQ8lqupG/KZQ9aMkHt9MTM/+1gFlNgvbEjj5v6DI/G1SlX
   lKdJW0M6CRgeOmiMGX7/QFoK74p8reePa61x9ejXZ2PTnbcR2TwFXpHoZ
   6I1AEV7Pt8tavFQ9oEyvrvacrtRsFtcCSROb8AITW6gUfLWKkfbypxHB+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="313785041"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="313785041"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 23:33:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="641323236"
X-IronPort-AV: E=Sophos;i="5.96,183,1665471600"; 
   d="scan'208";a="641323236"
Received: from a0cec8d9c8fc.jf.intel.com ([10.45.77.137])
  by orsmga002.jf.intel.com with ESMTP; 21 Nov 2022 23:33:56 -0800
From:   Chen Hu <hu1.chen@intel.com>
Cc:     hu1.chen@intel.com, jpoimboe@kernel.org, memxor@gmail.com,
        bpf@vger.kernel.org, Pengfei Xu <pengfei.xu@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v2] selftests/bpf: Fix "missing ENDBR" BUG for destructor kfunc
Date:   Mon, 21 Nov 2022 23:32:43 -0800
Message-Id: <20221122073244.21279-1-hu1.chen@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CONFIG_X86_KERNEL_IBT enabled, the test_verifier triggers the
following BUG:

  traps: Missing ENDBR: bpf_kfunc_call_test_release+0x0/0x30
  ------------[ cut here ]------------
  kernel BUG at arch/x86/kernel/traps.c:254!
  invalid opcode: 0000 [#1] PREEMPT SMP
  <TASK>
   asm_exc_control_protection+0x26/0x50
  RIP: 0010:bpf_kfunc_call_test_release+0x0/0x30
  Code: 00 48 c7 c7 18 f2 e1 b4 e8 0d ca 8c ff 48 c7 c0 00 f2 e1 b4 c3
	0f 1f 44 00 00 66 0f 1f 00 0f 1f 44 00 00 0f 0b 31 c0 c3 66 90
       <66> 0f 1f 00 0f 1f 44 00 00 48 85 ff 74 13 4c 8d 47 18 b8 ff ff ff
   bpf_map_free_kptrs+0x2e/0x70
   array_map_free+0x57/0x140
   process_one_work+0x194/0x3a0
   worker_thread+0x54/0x3a0
   ? rescuer_thread+0x390/0x390
   kthread+0xe9/0x110
   ? kthread_complete_and_exit+0x20/0x20

This is because there are no compile-time references to the destructor
kfuncs, bpf_kfunc_call_test_release() for example. So objtool marked
them sealable and ENDBR in the functions were sealed (converted to NOP)
by apply_ibt_endbr().

This fix creates dummy compile-time references to destructor kfuncs so
ENDBR stay there.

Fixes: 05a945deefaa ("selftests/bpf: Add verifier tests for kptr")
Signed-off-by: Chen Hu <hu1.chen@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
v2:
- Use generic macro name and place the macro after function body as
- suggested by Jiri Olsa

v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/

 include/linux/btf_ids.h | 7 +++++++
 net/bpf/test_run.c      | 4 ++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/btf_ids.h b/include/linux/btf_ids.h
index 2aea877d644f..db02691b506d 100644
--- a/include/linux/btf_ids.h
+++ b/include/linux/btf_ids.h
@@ -266,4 +266,11 @@ MAX_BTF_TRACING_TYPE,
 
 extern u32 btf_tracing_ids[];
 
+#if defined(CONFIG_X86_KERNEL_IBT) && !defined(__DISABLE_EXPORTS)
+#define FUNC_IBT_NOSEAL(name)					\
+	asm(IBT_NOSEAL(#name));
+#else
+#define FUNC_IBT_NOSEAL(name)
+#endif /* CONFIG_X86_KERNEL_IBT */
+
 #endif
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 13d578ce2a09..07263b7cc12d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -597,10 +597,14 @@ noinline void bpf_kfunc_call_test_release(struct prog_test_ref_kfunc *p)
 	refcount_dec(&p->cnt);
 }
 
+FUNC_IBT_NOSEAL(bpf_kfunc_call_test_release)
+
 noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
 {
 }
 
+FUNC_IBT_NOSEAL(bpf_kfunc_call_memb_release)
+
 noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
 {
 	WARN_ON_ONCE(1);
-- 
2.34.1

