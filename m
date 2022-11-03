Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D2E617C2A
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiKCMJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiKCMJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:09:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106E0FD1;
        Thu,  3 Nov 2022 05:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=KYBwDtUVZtl4ICiIQ6x4pKdkkIuJAYSCVKXUwRe3sYI=; b=BOizHypuaKlhX11+jt8hI9YbjV
        TnOrcNkasSXlMm56qZYZ77K12wtHC4bw8CITLCqQ8ozcCjpPNCDZO9eg7MEWrv8I0ZKKq6M3m3xMC
        VNb7JYaUOK301Ld6LUh0nBdn6fmnsTqeGUjDDdOWxZKfWn5wwI6bouGTlAzwCHrJGsvipnV3S53HJ
        Tmzbl2WZXW9CERPwtbRH8gMcFWHszVe8QKGtyVc4eGkaZ/29RHNqP52jeNKjmdqaPqbCaCYweX9JJ
        VklcerTX+cmiCLzSxXXJPHvrFHZutqH0R0+Wtf6LmeaFThkHi/zTQUkJxsFjXIPMNMa8LP6CWxsQe
        ttZ+Hb3Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqZ1g-006RMW-9b; Thu, 03 Nov 2022 12:08:52 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2F8BD3003E1;
        Thu,  3 Nov 2022 13:08:44 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 8886120AB9A25; Thu,  3 Nov 2022 13:08:44 +0100 (CET)
Message-ID: <20221103120647.796772565@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 03 Nov 2022 13:00:14 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     olsajiri@gmail.com, ast@kernel.org, daniel@iogearbox.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, peterz@infradead.org, bjorn@kernel.org,
        toke@redhat.com, David.Laight@aculab.com, rostedt@goodmis.org
Subject: [PATCH 2/2] bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)
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

The dispatcher function is currently abusing the ftrace __fentry__
call location for its own purposes -- this obviously gives trouble
when the dispatcher and ftrace are both in use.

A previous solution tried using __attribute__((patchable_function_entry()))
which works, except it is GCC-8+ only, breaking the build on the
earlier still supported compilers. Instead use static_call() -- which
has its own annotations and does not conflict with ftrace -- to
rewrite the dispatch function.

By using: return static_call()(ctx, insni, bpf_func) you get a perfect
forwarding tail call as function body (iow a single jmp instruction).
By having the default static_call() target be
bpf_dispatcher_nop_func() it retains the default behaviour (an
indirect call to the argument function). Only
once a dispatcher program is attached is the target rewritten to
directly call the JIT'ed image.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/Y1/oBlK0yFk5c/Im@hirez.programming.kicks-ass.net
---
 include/linux/bpf.h     |   39 ++++++++++++++++++++++++++++++++++++++-
 kernel/bpf/dispatcher.c |   22 ++++++++--------------
 2 files changed, 46 insertions(+), 15 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -27,6 +27,7 @@
 #include <linux/bpfptr.h>
 #include <linux/btf.h>
 #include <linux/rcupdate_trace.h>
+#include <linux/static_call.h>
 
 struct bpf_verifier_env;
 struct bpf_verifier_log;
@@ -953,6 +954,10 @@ struct bpf_dispatcher {
 	void *rw_image;
 	u32 image_off;
 	struct bpf_ksym ksym;
+#ifdef CONFIG_HAVE_STATIC_CALL
+	struct static_call_key *sc_key;
+	void *sc_tramp;
+#endif
 };
 
 static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
@@ -970,6 +975,34 @@ struct bpf_trampoline *bpf_trampoline_ge
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
+
+/*
+ * When the architecture supports STATIC_CALL replace the bpf_dispatcher_fn
+ * indirection with a direct call to the bpf program. If the architecture does
+ * not have STATIC_CALL, avoid a double-indirection.
+ */
+#ifdef CONFIG_HAVE_STATIC_CALL
+
+#define __BPF_DISPATCHER_SC_INIT(_name)				\
+	.sc_key = &STATIC_CALL_KEY(_name),			\
+	.sc_tramp = STATIC_CALL_TRAMP_ADDR(_name),
+
+#define __BPF_DISPATCHER_SC(name)				\
+	DEFINE_STATIC_CALL(bpf_dispatcher_##name##_call, bpf_dispatcher_nop_func)
+
+#define __BPF_DISPATCHER_CALL(name)				\
+	static_call(bpf_dispatcher_##name##_call)(ctx, insnsi, bpf_func)
+
+#define __BPF_DISPATCHER_UPDATE(_d, _new)			\
+	__static_call_update((_d)->sc_key, (_d)->sc_tramp, (_new))
+
+#else
+#define __BPF_DISPATCHER_SC_INIT(name)
+#define __BPF_DISPATCHER_SC(name)
+#define __BPF_DISPATCHER_CALL(name)		bpf_func(ctx, insnsi)
+#define __BPF_DISPATCHER_UPDATE(_d, _new)
+#endif
+
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
@@ -981,25 +1014,29 @@ int arch_prepare_bpf_dispatcher(void *im
 		.name  = #_name,				\
 		.lnode = LIST_HEAD_INIT(_name.ksym.lnode),	\
 	},							\
+	__BPF_DISPATCHER_SC_INIT(_name##_call)			\
 }
 
 #define DEFINE_BPF_DISPATCHER(name)					\
+	__BPF_DISPATCHER_SC(name);					\
 	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func)					\
 	{								\
-		return bpf_func(ctx, insnsi);				\
+		return __BPF_DISPATCHER_CALL(name);			\
 	}								\
 	EXPORT_SYMBOL(bpf_dispatcher_##name##_func);			\
 	struct bpf_dispatcher bpf_dispatcher_##name =			\
 		BPF_DISPATCHER_INIT(bpf_dispatcher_##name);
+
 #define DECLARE_BPF_DISPATCHER(name)					\
 	unsigned int bpf_dispatcher_##name##_func(			\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func);					\
 	extern struct bpf_dispatcher bpf_dispatcher_##name;
+
 #define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_##name##_func
 #define BPF_DISPATCHER_PTR(name) (&bpf_dispatcher_##name)
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -4,6 +4,7 @@
 #include <linux/hash.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/static_call.h>
 
 /* The BPF dispatcher is a multiway branch code generator. The
  * dispatcher is a mechanism to avoid the performance penalty of an
@@ -104,17 +105,11 @@ static int bpf_dispatcher_prepare(struct
 
 static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 {
-	void *old, *new, *tmp;
-	u32 noff;
-	int err;
-
-	if (!prev_num_progs) {
-		old = NULL;
-		noff = 0;
-	} else {
-		old = d->image + d->image_off;
+	void *new, *tmp;
+	u32 noff = 0;
+
+	if (prev_num_progs)
 		noff = d->image_off ^ (PAGE_SIZE / 2);
-	}
 
 	new = d->num_progs ? d->image + noff : NULL;
 	tmp = d->num_progs ? d->rw_image + noff : NULL;
@@ -128,11 +123,10 @@ static void bpf_dispatcher_update(struct
 			return;
 	}
 
-	err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP, old, new);
-	if (err || !new)
-		return;
+	__BPF_DISPATCHER_UPDATE(d, new ?: &bpf_dispatcher_nop_func);
 
-	d->image_off = noff;
+	if (new)
+		d->image_off = noff;
 }
 
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,


