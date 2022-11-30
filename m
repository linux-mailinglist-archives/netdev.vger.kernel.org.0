Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D5263D2EC
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 11:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbiK3KM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 05:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbiK3KMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 05:12:22 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD7231DF0;
        Wed, 30 Nov 2022 02:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669803142; x=1701339142;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gkLkJR8RE36XG9BI0LgN87G1MnvrwDX8Iwn1/fvXg/U=;
  b=V4x8Six4JXLpmprvqJntS6w7bbIKKj/HSn7BGYTvxlvvde2rRn7UNP43
   tXSUt+p07FdJJ374nVYneE8FKH12Teur29W6dqn1KD/byuSM44OAC6Yl+
   n8IvNrD70oJ6u1Fp53D1STqz8xIrczI7LzUdmXiBkxsbU4GpQT8LXNhmP
   Lu7nRgsgMDIPCQJsQUXJ/9Eiz4oH44qwMEoFqNiC39cPwRAHgXcsyLfLF
   uSEt8xkyeDVMEcpcYfprIJ+D1BiI3dFxJVUoMq0m0kR6GKycDRschA27i
   oWxphPAAKOgy3v+rL4sciqcu0FmDO6J2pMoNj0iTUFPN1taZduPHIjnIQ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="316511239"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="316511239"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 02:12:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10546"; a="818575930"
X-IronPort-AV: E=Sophos;i="5.96,206,1665471600"; 
   d="scan'208";a="818575930"
Received: from b49691a74bf0.jf.intel.com ([10.165.59.99])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 02:12:20 -0800
From:   Chen Hu <hu1.chen@intel.com>
Cc:     hu1.chen@intel.com, jpoimboe@kernel.org, memxor@gmail.com,
        bpf@vger.kernel.org, Pengfei Xu <pengfei.xu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf v3] selftests/bpf: Fix "missing ENDBR" BUG for destructor kfunc
Date:   Wed, 30 Nov 2022 02:11:31 -0800
Message-Id: <20221130101135.26806-1-hu1.chen@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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

It turns out that ENDBR in bpf_kfunc_call_test_release() is converted to
NOP by apply_ibt_endbr().

The only text references to this function from kernel side are:

  $ grep -r bpf_kfunc_call_test_release
  net/bpf/test_run.c:noinline void bpf_kfunc_call_test_release(...)
  net/bpf/test_run.c:BTF_ID_FLAGS(func, bpf_kfunc_call_test_release, ...)
  net/bpf/test_run.c:BTF_ID(func, bpf_kfunc_call_test_release)

but it may be called from bpf program as kfunc. (no other caller from
kernel)

This fix creates dummy references to destructor kfuncs so ENDBR stay
there.

Also modify macro XXX_NOSEAL slightly:
- ASM_IBT_NOSEAL now stands for pure asm
- IBT_NOSEAL can be used directly in C

Signed-off-by: Chen Hu <hu1.chen@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
v3:
- Macro go to IBT related header as suggested by Jiri Olsa
- Describe reference to the func clearly in commit message as suggested
  by Peter Zijlstra and Jiri Olsa
 
v2: https://lore.kernel.org/all/20221122073244.21279-1-hu1.chen@intel.com/

v1: https://lore.kernel.org/all/20221121085113.611504-1-hu1.chen@intel.com/

 arch/x86/include/asm/ibt.h | 6 +++++-
 arch/x86/kvm/emulate.c     | 2 +-
 net/bpf/test_run.c         | 5 +++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/ibt.h b/arch/x86/include/asm/ibt.h
index 9b08082a5d9f..be86dc31661c 100644
--- a/arch/x86/include/asm/ibt.h
+++ b/arch/x86/include/asm/ibt.h
@@ -36,11 +36,14 @@
  * the function as needing to be "sealed" (i.e. ENDBR converted to NOP by
  * apply_ibt_endbr()).
  */
-#define IBT_NOSEAL(fname)				\
+#define ASM_IBT_NOSEAL(fname)				\
 	".pushsection .discard.ibt_endbr_noseal\n\t"	\
 	_ASM_PTR fname "\n\t"				\
 	".popsection\n\t"
 
+#define IBT_NOSEAL(name)				\
+	asm(ASM_IBT_NOSEAL(#name))
+
 static inline __attribute_const__ u32 gen_endbr(void)
 {
 	u32 endbr;
@@ -94,6 +97,7 @@ extern __noendbr void ibt_restore(u64 save);
 #ifndef __ASSEMBLY__
 
 #define ASM_ENDBR
+#define ASM_IBT_NOSEAL(name)
 #define IBT_NOSEAL(name)
 
 #define __noendbr
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4a43261d25a2..d870c8bb5831 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -327,7 +327,7 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
 	".type " name ", @function \n\t" \
 	name ":\n\t" \
 	ASM_ENDBR \
-	IBT_NOSEAL(name)
+	ASM_IBT_NOSEAL(name)
 
 #define FOP_FUNC(name) \
 	__FOP_FUNC(#name)
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index fcb3e6c5e03c..9e9c8e8d50d7 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -601,6 +601,11 @@ noinline void bpf_kfunc_call_memb_release(struct prog_test_member *p)
 {
 }
 
+#ifdef CONFIG_X86_KERNEL_IBT
+IBT_NOSEAL(bpf_kfunc_call_test_release);
+IBT_NOSEAL(bpf_kfunc_call_memb_release);
+#endif
+
 noinline void bpf_kfunc_call_memb1_release(struct prog_test_member1 *p)
 {
 	WARN_ON_ONCE(1);
-- 
2.34.1

