Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1684150D2C5
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiDXPhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240447AbiDXPbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:31:21 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C61170E3F;
        Sun, 24 Apr 2022 08:28:18 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KmX3k0mGpzCs9g;
        Sun, 24 Apr 2022 23:23:46 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 23:28:14 +0800
From:   Xu Kuohai <xukuohai@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH bpf-next v3 0/7] bpf trampoline for arm64
Date:   Sun, 24 Apr 2022 11:40:21 -0400
Message-ID: <20220424154028.1698685-1-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.197]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf trampoline support for arm64. Most of the logic is the same as
x86.

Tested on qemu, result:
 #18  bpf_tcp_ca:OK
 #51  dummy_st_ops:OK
 #55  fentry_fexit:OK
 #56  fentry_test:OK
 #57  fexit_bpf2bpf:OK
 #58  fexit_sleep:OK
 #59  fexit_stress:OK
 #60  fexit_test:OK
 #67  get_func_args_test:OK
 #68  get_func_ip_test:OK
 #101 modify_return:OK
 #233 xdp_bpf2bpf:OK

Also tested bpftrace kfunc/kretfunc and it worked fine. 

v3:
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

Xu Kuohai (7):
  arm64: ftrace: Add ftrace direct call support
  ftrace: Fix deadloop caused by direct call in ftrace selftest
  bpf: Move is_valid_bpf_tramp_flags() to the public trampoline code
  bpf, arm64: Impelment bpf_arch_text_poke() for arm64
  bpf, arm64: Support to poke bpf prog
  bpf, arm64: bpf trampoline for arm64
  selftests/bpf: Fix trivial typo in fentry_fexit.c

 arch/arm64/Kconfig                            |   2 +
 arch/arm64/include/asm/ftrace.h               |  12 +
 arch/arm64/kernel/asm-offsets.c               |   1 +
 arch/arm64/kernel/entry-ftrace.S              |  18 +-
 arch/arm64/net/bpf_jit.h                      |   8 +
 arch/arm64/net/bpf_jit_comp.c                 | 446 +++++++++++++++++-
 arch/x86/net/bpf_jit_comp.c                   |  20 -
 include/linux/bpf.h                           |   5 +
 kernel/bpf/bpf_struct_ops.c                   |   4 +-
 kernel/bpf/trampoline.c                       |  34 +-
 kernel/trace/trace_selftest.c                 |  16 +
 .../selftests/bpf/prog_tests/fentry_fexit.c   |   4 +-
 12 files changed, 531 insertions(+), 39 deletions(-)

-- 
2.30.2

