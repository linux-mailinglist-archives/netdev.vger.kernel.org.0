Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD455AB74
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 18:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiFYQCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 12:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiFYQCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 12:02:50 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E508515A2A;
        Sat, 25 Jun 2022 09:02:47 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LVdzM0VRzzDsNT;
        Sun, 26 Jun 2022 00:02:07 +0800 (CST)
Received: from huawei.com (10.67.174.197) by kwepemi500013.china.huawei.com
 (7.221.188.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Sun, 26 Jun
 2022 00:02:43 +0800
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
Subject: [PATCH bpf-next v6 1/4] bpf: Remove is_valid_bpf_tramp_flags()
Date:   Sat, 25 Jun 2022 12:12:52 -0400
Message-ID: <20220625161255.547944-2-xukuohai@huawei.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220625161255.547944-1-xukuohai@huawei.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
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

Before generating bpf trampoline, x86 calls is_valid_bpf_tramp_flags()
to check the input flags. This check is architecture independent.
So, to be consistent with x86, arm64 should also do this check
before generating bpf trampoline.

However, the BPF_TRAMP_F_XXX flags are not used by user code and the
flags argument is almost constant at copmile time, so this run time
check is a bit redundant.

Remove is_valid_bpf_tramp_flags() and add some comments to the usage of
BPF_TRAMP_F_XXX flags, as suggested by Alexei.

Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 arch/x86/net/bpf_jit_comp.c | 20 --------------------
 kernel/bpf/bpf_struct_ops.c |  3 +++
 kernel/bpf/trampoline.c     |  3 +++
 3 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 2c51ca9f7cec..4f8938db03b1 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1927,23 +1927,6 @@ static int invoke_bpf_mod_ret(const struct btf_func_model *m, u8 **pprog,
 	return 0;
 }
 
-static bool is_valid_bpf_tramp_flags(unsigned int flags)
-{
-	if ((flags & BPF_TRAMP_F_RESTORE_REGS) &&
-	    (flags & BPF_TRAMP_F_SKIP_FRAME))
-		return false;
-
-	/*
-	 * BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
-	 * and it must be used alone.
-	 */
-	if ((flags & BPF_TRAMP_F_RET_FENTRY_RET) &&
-	    (flags & ~BPF_TRAMP_F_RET_FENTRY_RET))
-		return false;
-
-	return true;
-}
-
 /* Example:
  * __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev);
  * its 'struct btf_func_model' will be nr_args=2
@@ -2022,9 +2005,6 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (nr_args > 6)
 		return -ENOTSUPP;
 
-	if (!is_valid_bpf_tramp_flags(flags))
-		return -EINVAL;
-
 	/* Generated trampoline stack layout:
 	 *
 	 * RBP + 8         [ return address  ]
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 7e0068c3399c..84b2d9dba79a 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -341,6 +341,9 @@ int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_links *tlinks,
 
 	tlinks[BPF_TRAMP_FENTRY].links[0] = link;
 	tlinks[BPF_TRAMP_FENTRY].nr_links = 1;
+	/* BPF_TRAMP_F_RET_FENTRY_RET is only used by bpf_struct_ops,
+	 * and it must be used alone.
+	 */
 	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
 	return arch_prepare_bpf_trampoline(NULL, image, image_end,
 					   model, flags, tlinks, NULL);
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 93c7675f0c9e..bd3f2e673874 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -358,6 +358,9 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr)
 
 	if (tlinks[BPF_TRAMP_FEXIT].nr_links ||
 	    tlinks[BPF_TRAMP_MODIFY_RETURN].nr_links)
+		/* NOTE: BPF_TRAMP_F_RESTORE_REGS and BPF_TRAMP_F_SKIP_FRAME
+		 * should not be set together.
+		 */
 		flags = BPF_TRAMP_F_CALL_ORIG | BPF_TRAMP_F_SKIP_FRAME;
 
 	if (ip_arg)
-- 
2.30.2

