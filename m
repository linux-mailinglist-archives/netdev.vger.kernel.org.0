Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17E855AB78
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 18:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbiFYQCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 12:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFYQCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 12:02:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A821580B;
        Sat, 25 Jun 2022 09:02:43 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LVdxR4HYyzhXY5;
        Sun, 26 Jun 2022 00:00:27 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 26 Jun
 2022 00:02:38 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH bpf-next v6 0/4] bpf trampoline for arm64
Date:   Sat, 25 Jun 2022 12:12:51 -0400
Message-ID: <20220625161255.547944-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset introduces bpf trampoline on arm64. A bpf trampoline converts
native calling convention to bpf calling convention and is used to implement
various bpf features, such as fentry, fexit, fmod_ret and struct_ops.

The trampoline introduced does essentially the same thing as the bpf
trampoline does on x86.

Tested on raspberry pi 4b and qemu:

 #18 /1     bpf_tcp_ca/dctcp:OK
 #18 /2     bpf_tcp_ca/cubic:OK
 #18 /3     bpf_tcp_ca/invalid_license:OK
 #18 /4     bpf_tcp_ca/dctcp_fallback:OK
 #18 /5     bpf_tcp_ca/rel_setsockopt:OK
 #18        bpf_tcp_ca:OK
 #51 /1     dummy_st_ops/dummy_st_ops_attach:OK
 #51 /2     dummy_st_ops/dummy_init_ret_value:OK
 #51 /3     dummy_st_ops/dummy_init_ptr_arg:OK
 #51 /4     dummy_st_ops/dummy_multiple_args:OK
 #51        dummy_st_ops:OK
 #57 /1     fexit_bpf2bpf/target_no_callees:OK
 #57 /2     fexit_bpf2bpf/target_yes_callees:OK
 #57 /3     fexit_bpf2bpf/func_replace:OK
 #57 /4     fexit_bpf2bpf/func_replace_verify:OK
 #57 /5     fexit_bpf2bpf/func_sockmap_update:OK
 #57 /6     fexit_bpf2bpf/func_replace_return_code:OK
 #57 /7     fexit_bpf2bpf/func_map_prog_compatibility:OK
 #57 /8     fexit_bpf2bpf/func_replace_multi:OK
 #57 /9     fexit_bpf2bpf/fmod_ret_freplace:OK
 #57        fexit_bpf2bpf:OK
 #237       xdp_bpf2bpf:OK

v6:
- Since Mark is refactoring arm64 ftrace to support long jump and reduce the
  ftrace trampoline overhead, it's not clear how we'll attach bpf trampoline
  to regular kernel functions, so remove ftrace related patches for now.
- Add long jump support for attaching bpf trampoline to bpf prog, since bpf
  trampoline and bpf prog are allocated via vmalloc, there is chance the
  distance exceeds the max branch range.
- Collect ACK/Review-by, not sure if the ACK and Review-bys for bpf_arch_text_poke()
  should be kept, since the changes to it is not trivial
- Update some commit messages and comments

v5: https://lore.kernel.org/bpf/20220518131638.3401509-1-xukuohai@huawei.com/
- As Alexei suggested, remove is_valid_bpf_tramp_flags()

v4: https://lore.kernel.org/bpf/20220517071838.3366093-1-xukuohai@huawei.com/
- Run the test cases on raspberry pi 4b
- Rebase and add cookie to trampoline
- As Steve suggested, move trace_direct_tramp() back to entry-ftrace.S to
  avoid messing up generic code with architecture specific code
- As Jakub suggested, merge patch 4 and patch 5 of v3 to provide full function
  in one patch
- As Mark suggested, add a comment for the use of aarch64_insn_patch_text_nosync()
- Do not generate trampoline for long jump to avoid triggering ftrace_bug
- Round stack size to multiples of 16B to avoid SPAlignmentFault
- Use callee saved register x20 to reduce the use of mov_i64
- Add missing BTI J instructions
- Trivial spelling and code style fixes

v3: https://lore.kernel.org/bpf/20220424154028.1698685-1-xukuohai@huawei.com/
- Append test results for bpf_tcp_ca, dummy_st_ops, fexit_bpf2bpf,
  xdp_bpf2bpf
- Support to poke bpf progs
- Fix return value of arch_prepare_bpf_trampoline() to the total number
  of bytes instead of number of instructions 
- Do not check whether CONFIG_DYNAMIC_FTRACE_WITH_REGS is enabled in
  arch_prepare_bpf_trampoline, since the trampoline may be hooked to a bpf
  prog
- Restrict bpf_arch_text_poke() to poke bpf text only, as kernel functions
  are poked by ftrace
- Rewrite trace_direct_tramp() in inline assembly in trace_selftest.c
  to avoid messing entry-ftrace.S
- isolate arch_ftrace_set_direct_caller() with macro
  CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS to avoid compile error
  when this macro is disabled
- Some trivial code sytle fixes

v2: https://lore.kernel.org/bpf/20220414162220.1985095-1-xukuohai@huawei.com/
- Add Song's ACK
- Change the multi-line comment in is_valid_bpf_tramp_flags() into net
  style (patch 3)
- Fix a deadloop issue in ftrace selftest (patch 2)
- Replace pt_regs->x0 with pt_regs->orig_x0 in patch 1 commit message 
- Replace "bpf trampoline" with "custom trampoline" in patch 1, as
  ftrace direct call is not only used by bpf trampoline.

v1: https://lore.kernel.org/bpf/20220413054959.1053668-1-xukuohai@huawei.com/

Xu Kuohai (4):
  bpf: Remove is_valid_bpf_tramp_flags()
  arm64: Add LDR (literal) instruction
  bpf, arm64: Impelment bpf_arch_text_poke() for arm64
  bpf, arm64: bpf trampoline for arm64

 arch/arm64/include/asm/insn.h |   3 +
 arch/arm64/lib/insn.c         |  30 +-
 arch/arm64/net/bpf_jit.h      |   7 +
 arch/arm64/net/bpf_jit_comp.c | 717 +++++++++++++++++++++++++++++++++-
 arch/x86/net/bpf_jit_comp.c   |  20 -
 kernel/bpf/bpf_struct_ops.c   |   3 +
 kernel/bpf/trampoline.c       |   3 +
 7 files changed, 742 insertions(+), 41 deletions(-)

-- 
2.30.2

