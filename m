Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566CA50D2B7
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbiDXPhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240449AbiDXPbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 11:31:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEC8171C03;
        Sun, 24 Apr 2022 08:28:20 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KmX8l38tLzhYWb;
        Sun, 24 Apr 2022 23:28:07 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 24 Apr
 2022 23:28:16 +0800
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
Subject: [PATCH bpf-next v3 2/7] ftrace: Fix deadloop caused by direct call in ftrace selftest
Date:   Sun, 24 Apr 2022 11:40:23 -0400
Message-ID: <20220424154028.1698685-3-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424154028.1698685-1-xukuohai@huawei.com>
References: <20220424154028.1698685-1-xukuohai@huawei.com>
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

After direct call is enabled for arm64, ftrace selftest enters a
dead loop:

<trace_selftest_dynamic_test_func>:
00  bti     c
01  mov     x9, x30                            <trace_direct_tramp>:
02  bl      <trace_direct_tramp>    ---------->     ret
                                                     |
                                         lr/x30 is 03, return to 03
                                                     |
03  mov     w0, #0x0   <-----------------------------|
     |                                               |
     |                   dead loop!                  |
     |                                               |
04  ret   ---- lr/x30 is still 03, go back to 03 ----|

The reason is that when the direct caller trace_direct_tramp() returns
to the patched function trace_selftest_dynamic_test_func(), lr is still
the address after the instrumented instruction in the patched function,
so when the patched function exits, it returns to itself!

To fix this issue, we need to restore lr before trace_direct_tramp()
exits, so rewrite a dedicated trace_direct_tramp() for arm64.

Reported-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
---
 kernel/trace/trace_selftest.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index abcadbe933bb..d2eff2b1d743 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -785,8 +785,24 @@ static struct fgraph_ops fgraph_ops __initdata  = {
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
+#ifdef CONFIG_ARM64
+extern void trace_direct_tramp(void);
+
+asm (
+"	.pushsection	.text, \"ax\", @progbits\n"
+"	.type		trace_direct_tramp, %function\n"
+"	.global		trace_direct_tramp\n"
+"trace_direct_tramp:"
+"	mov	x10, x30\n"
+"	mov	x30, x9\n"
+"	ret	x10\n"
+"	.size		trace_direct_tramp, .-trace_direct_tramp\n"
+"	.popsection\n"
+);
+#else
 noinline __noclone static void trace_direct_tramp(void) { }
 #endif
+#endif
 
 /*
  * Pretty much the same than for the function tracer from which the selftest
-- 
2.30.2

