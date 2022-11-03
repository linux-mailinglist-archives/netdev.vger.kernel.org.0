Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C021B617C31
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbiKCMJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiKCMJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:09:33 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9653110DE;
        Thu,  3 Nov 2022 05:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=D+IbIcIImMPdQpJwzXPlYzbuRJccnY/ode4zkKbsw8o=; b=djh2MvwagoWZ2wxNVF79AMiAZ3
        cjSbuepOvsmsIVV3NzIPip4mJqeBySJZAlQgNs+So6jNLViKVTkIQalaosQNw//ZhVUZ1woL+FKfm
        sokEw4B7RcevgVDj0rLBX/Al2Xou+0iGvWvFFZsAcytESkIgoe0Yv9NgSyvwGx1R+vgsJtJ3QBY8o
        y03y4OwSLufc3l8LHzX/NmP4aUq0Xs1rErlQnMV3ws1oAXEHtRRT2wJ8WrJD4g0EtG2F8MjNhexlJ
        ptt5dLq1Zr3tZj5zjlKvFehj3UvM8rn8ct/aP4uzdVGL4tIgs/zqZPhzub4/01cMKq66YChAsmqn6
        D2Sj1+yw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqZ1d-008fpA-8v; Thu, 03 Nov 2022 12:08:51 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 311BE300411;
        Thu,  3 Nov 2022 13:08:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 855C720AB9A14; Thu,  3 Nov 2022 13:08:44 +0100 (CET)
Message-ID: <20221103120647.728830733@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 03 Nov 2022 13:00:13 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     olsajiri@gmail.com, ast@kernel.org, daniel@iogearbox.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, peterz@infradead.org, bjorn@kernel.org,
        toke@redhat.com, David.Laight@aculab.com, rostedt@goodmis.org
Subject: [PATCH 1/2] bpf: Revert ("Fix dispatcher patchable function entry to 5 bytes nop")
References: <20221103120012.717020618@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because __attribute__((patchable_function_entry)) is only available
since GCC-8 this solution fails to build on the minimum required GCC
version.

Undo these changes so we might try again -- without cluttering up the
patches with too many changes.

This is an almost complete revert of:

  dbe69b299884 ("bpf: Fix dispatcher patchable function entry to 5 bytes nop")
  ceea991a019c ("bpf: Move bpf_dispatcher function out of ftrace locations")

(notably the arch/x86/Kconfig hunk is kept).

Reported-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com
---
 arch/x86/net/bpf_jit_comp.c |   13 -------------
 include/linux/bpf.h         |   21 +--------------------
 kernel/bpf/dispatcher.c     |    6 ------
 3 files changed, 1 insertion(+), 39 deletions(-)

--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -11,7 +11,6 @@
 #include <linux/bpf.h>
 #include <linux/memory.h>
 #include <linux/sort.h>
-#include <linux/init.h>
 #include <asm/extable.h>
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
@@ -389,18 +388,6 @@ static int __bpf_arch_text_poke(void *ip
 	return ret;
 }
 
-int __init bpf_arch_init_dispatcher_early(void *ip)
-{
-	const u8 *nop_insn = x86_nops[5];
-
-	if (is_endbr(*(u32 *)ip))
-		ip += ENDBR_INSN_SIZE;
-
-	if (memcmp(ip, nop_insn, X86_PATCH_SIZE))
-		text_poke_early(ip, nop_insn, X86_PATCH_SIZE);
-	return 0;
-}
-
 int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type t,
 		       void *old_addr, void *new_addr)
 {
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,7 +27,6 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
-#include <linux/init.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -971,8 +970,6 @@ struct bpf_trampoline *bpf_trampoline_ge
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
-int __init bpf_arch_init_dispatcher_early(void *ip);
-
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
@@ -986,21 +983,7 @@ int __init bpf_arch_init_dispatcher_earl
 	},							\
 }
 
-#define BPF_DISPATCHER_INIT_CALL(_name)					\
-	static int __init _name##_init(void)				\
-	{								\
-		return bpf_arch_init_dispatcher_early(_name##_func);	\
-	}								\
-	early_initcall(_name##_init)
-
-#ifdef CONFIG_X86_64
-#define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
-#else
-#define BPF_DISPATCHER_ATTRIBUTES
-#endif
-
 #define DEFINE_BPF_DISPATCHER(name)					\
-	notrace BPF_DISPATCHER_ATTRIBUTES				\
 	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
@@ -1010,9 +993,7 @@ int __init bpf_arch_init_dispatcher_earl
 	}								\
 	EXPORT_SYMBOL(bpf_dispatcher_##name##_func);			\
 	struct bpf_dispatcher bpf_dispatcher_##name =			\
-		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);		\
-	BPF_DISPATCHER_INIT_CALL(bpf_dispatcher_##name);
-
+		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
 #define DECLARE_BPF_DISPATCHER(name)					\
 	unsigned int bpf_dispatcher_##name##_func(			\
 		const void *ctx,					\
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -4,7 +4,6 @@
 #include <linux/hash.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
-#include <linux/init.h>
 
 /* The BPF dispatcher is a multiway branch code generator. The
  * dispatcher is a mechanism to avoid the performance penalty of an
@@ -90,11 +89,6 @@ int __weak arch_prepare_bpf_dispatcher(v
 {
 	return -ENOTSUPP;
 }
-
-int __weak __init bpf_arch_init_dispatcher_early(void *ip)
-{
-	return -ENOTSUPP;
-}
 
 static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image, void *buf)
 {


