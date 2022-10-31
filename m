Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6516139E9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbiJaPVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbiJaPVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:21:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3539BE02F;
        Mon, 31 Oct 2022 08:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cNNN03pd2FB8JSjSVrRj3rY0J8S0KNTbVJzIxBWL6+U=; b=owxAgzqez1ZywLUgLkuTqsNUZM
        CLKEVWT5yusuKKn5TV+Z/jVuU8cWTOuRpRLou/8RpqPqEuEcKcVXY/IqvPPyelbg/0dcmto3P7kuu
        2yNU8bQZYW2r83nxz+S0C1YRREDZa1TqP9xKYmm/zBxzW6dOC1ibU0vZ6tMvriQBA0yZ6EEia2fCw
        UlVBCF4+NJyab/cgmyzdISbq23n2eaTTnNd7jhzUQt/0fqY757FgGoE3+5Mq3NYhXhg7md0wso2Hx
        AHFjxt7voxSOKrq50B8mypu+aH3sOQtobxZ7X2QZrTrYgDRT6i4AGGmm0TE0Nf1Oyp5s6oNL0YBz1
        4a/bfZoA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1opWbf-007tY9-QF; Mon, 31 Oct 2022 15:21:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9DC5F3002F1;
        Mon, 31 Oct 2022 16:21:42 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7D2F2205A8DAD; Mon, 31 Oct 2022 16:21:42 +0100 (CET)
Date:   Mon, 31 Oct 2022 16:21:42 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Linux 6.1-rc3 build fail in include/linux/bpf.h
Message-ID: <Y1/oBlK0yFk5c/Im@hirez.programming.kicks-ass.net>
References: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
 <Y1+8zIdf8mgQXwHg@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1+8zIdf8mgQXwHg@krava>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 01:17:16PM +0100, Jiri Olsa wrote:
> On Mon, Oct 31, 2022 at 11:14:31AM +0000, David Laight wrote:
> > The 6.1-rc3 sources fail to build because bpf.h unconditionally
> > #define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
> > for X86_64 builds.
> > 
> > I'm pretty sure that should depend on some other options
> > since the compiler isn't required to support it.
> > (The gcc 7.5.0 on my Ubunti 18.04 system certainly doesn't)
> > 
> > The only other reference to that attribute is in the definition
> > of 'notrace' in compiler.h.
> 
> I guess we need to make some __has_attribute check and make all that conditional
> 
> cc-ing Peter

Does something crazy like the below work? It compiles but is otherwise
totally untested.

---
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 9e7d46d16032..7d7a00306d19 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -953,6 +953,10 @@ struct bpf_dispatcher {
 	void *rw_image;
 	u32 image_off;
 	struct bpf_ksym ksym;
+#ifdef CONFIG_HAVE_STATIC_CALL
+	struct static_call_key *sc_key;
+	void *sc_tramp;
+#endif
 };
 
 static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
@@ -970,6 +974,20 @@ struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
 int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_funcs);
+
+
+#ifdef CONFIG_HAVE_STATIC_CALL
+#define BPF_DISPATCH_CALL(name)	static_call(bpf_dispatcher_##name##_call)(ctx, insnsi, bpf_func)
+
+#define __BPF_DISPATCHER_SC_INIT(_name)				\
+	.sc_key = &STATIC_CALL_KEY(_name),			\
+	.sc_tramp = STATIC_CALL_TRAMP_ADDR(_name),
+
+#else
+#define BPF_DISPATCH_CALL(name)	bpf_func(ctx, insnsi)
+#define __BPF_DISPATCHER_SC_INIT(name)
+#endif
+
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\
@@ -981,32 +999,29 @@ int arch_prepare_bpf_dispatcher(void *image, void *buf, s64 *funcs, int num_func
 		.name  = #_name,				\
 		.lnode = LIST_HEAD_INIT(_name.ksym.lnode),	\
 	},							\
+	__BPF_DISPATCHER_SC_INIT(_name##_call)			\
 }
 
-#ifdef CONFIG_X86_64
-#define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
-#else
-#define BPF_DISPATCHER_ATTRIBUTES
-#endif
-
 #define DEFINE_BPF_DISPATCHER(name)					\
-	notrace BPF_DISPATCHER_ATTRIBUTES				\
+	DEFINE_STATIC_CALL(bpf_dispatcher_##name##_call, bpf_dispatcher_nop_func); \
 	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
 		bpf_func_t bpf_func)					\
 	{								\
-		return bpf_func(ctx, insnsi);				\
+		return BPF_DISPATCH_CALL(name);				\
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
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
index fa64b80b8bca..1ca8bd6da6bb 100644
--- a/kernel/bpf/dispatcher.c
+++ b/kernel/bpf/dispatcher.c
@@ -4,6 +4,7 @@
 #include <linux/hash.h>
 #include <linux/bpf.h>
 #include <linux/filter.h>
+#include <linux/static_call.h>
 
 /* The BPF dispatcher is a multiway branch code generator. The
  * dispatcher is a mechanism to avoid the performance penalty of an
@@ -106,7 +107,6 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 {
 	void *old, *new, *tmp;
 	u32 noff;
-	int err;
 
 	if (!prev_num_progs) {
 		old = NULL;
@@ -128,11 +128,10 @@ static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
 			return;
 	}
 
-	err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP, old, new);
-	if (err || !new)
-		return;
+	__static_call_update(d->sc_key, d->sc_tramp, new ?: &bpf_dispatcher_nop_func);
 
-	d->image_off = noff;
+	if (new)
+		d->image_off = noff;
 }
 
 void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
