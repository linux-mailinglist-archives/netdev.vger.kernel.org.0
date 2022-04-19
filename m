Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6844C5079BA
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357335AbiDSTDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357522AbiDSTDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:03:45 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB703FBC3
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:01:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e4-20020a056902034400b00633691534d5so15542228ybs.7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U3vVgH2NlbkVZIyE6h8qEg+2yOyx9o0HgNpsv0hYRjs=;
        b=NIiCksVLU+66F739wvBj12P/ySMKF+TU0dBODHhFcudCh4oeYFlLFVdpRI6iBFYjH0
         eZHP1ZMys49bRaM1ZvDnlrmPsZqY+Fh2TDxU1ClAhF3j6/h24HPYexTB9Vb6UWMLkBQv
         qr6/aHivnoygiKLPDktwyYpouH+QMRDmWR6CavJ8jC5IBUgHCo5PJnCcSmToBYNbe1CF
         X6ersrsvdZToRpOVoPcH3uEmpx5rB21Wi7T5Rg+Em6HYxrKLw+uBnXBBlHyMlHFnfA/c
         ympxxkQCKiK2CmbUpPiPy5+k+eCW6t0znm14G2pDjhSkLV/Lt5IhSdl3jN2zkhKDAWZv
         ERnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U3vVgH2NlbkVZIyE6h8qEg+2yOyx9o0HgNpsv0hYRjs=;
        b=2L84FrAh6i5x+Nijcre8X7IfcVOfHuVOqvmEIGlRJV/ETu9nq9U0W1gyjmem1w9ji1
         uc0tF/gra+yFQdNf1FpeXv9/tLvc9gwZtLqvfX4Woi73TACvpHMScqZt7XQqG8I9lEzY
         FO2hZgaW3lZGkvNugtWfkIZF66ogPWuA/h7OF2hwkqu0olf9tafZH3ttrrir5bBZFqN7
         0ljmqhx1hZC2NzrSRQfjZEgOrmp6i5cNOvHDCLyfp+ozmpeGaYQgsLTAkurF5UTWbzP9
         azRd8g5+0bZlTVDSKtCIIdEAPIo4b1lGpY2d++Lb3FoB0TuNFlZoBYB0VZeFS/q6aGPN
         JaiA==
X-Gm-Message-State: AOAM5316GL4/7wmQ1tAZd2Jh5RHdswuTH2fCya7fVVoero2IJM0Rq09t
        dnWMHzlXQrGyaUTL2nxrU/II9cvDVJQ7wyCOpr/Ix8PilKGCF6mSN/LCBcksxtr1Nm8SX+ddG+G
        kVtbr7mc3AT0jArsteLpmBSyb8obDNFq9K03QZ5soz0TSFPqJSg+Iew==
X-Google-Smtp-Source: ABdhPJwZPtJLf+kCo4bUnp9XCOizAmZyVy1xIzyahoOSIS2JOHvGrRAwLNbQq0CX/TfEgpOcJcwa7ow=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:37f:6746:8e66:a291])
 (user=sdf job=sendgmr) by 2002:a05:6902:506:b0:645:4553:b943 with SMTP id
 x6-20020a056902050600b006454553b943mr3182436ybs.557.1650394859378; Tue, 19
 Apr 2022 12:00:59 -0700 (PDT)
Date:   Tue, 19 Apr 2022 12:00:46 -0700
In-Reply-To: <20220419190053.3395240-1-sdf@google.com>
Message-Id: <20220419190053.3395240-2-sdf@google.com>
Mime-Version: 1.0
References: <20220419190053.3395240-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next v5 1/8] bpf: add bpf_func_t and trampoline helpers
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'll be adding lsm cgroup specific helpers that grab
trampoline mutex.

No functional changes.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 include/linux/bpf.h     | 11 ++++---
 kernel/bpf/trampoline.c | 63 +++++++++++++++++++++++------------------
 2 files changed, 40 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7bf441563ffc..ab2ba5f4bc9c 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -52,6 +52,8 @@ typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
+typedef unsigned int (*bpf_func_t)(const void *,
+				   const struct bpf_insn *);
 struct bpf_iter_seq_info {
 	const struct seq_operations *seq_ops;
 	bpf_iter_init_seq_priv_t init_seq_private;
@@ -798,8 +800,7 @@ struct bpf_dispatcher {
 static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
-	unsigned int (*bpf_func)(const void *,
-				 const struct bpf_insn *))
+	bpf_func_t bpf_func)
 {
 	return bpf_func(ctx, insnsi);
 }
@@ -827,8 +828,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
-		unsigned int (*bpf_func)(const void *,			\
-					 const struct bpf_insn *))	\
+		bpf_func_t bpf_func)					\
 	{								\
 		return bpf_func(ctx, insnsi);				\
 	}								\
@@ -839,8 +839,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 	unsigned int bpf_dispatcher_##name##_func(			\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
-		unsigned int (*bpf_func)(const void *,			\
-					 const struct bpf_insn *));	\
+		bpf_func_t bpf_func);					\
 	extern struct bpf_dispatcher bpf_dispatcher_##name;
 #define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_##name##_func
 #define BPF_DISPATCHER_PTR(name) (&bpf_dispatcher_##name)
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index ada97751ae1b..0c4fd194e801 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -407,42 +407,34 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+static int __bpf_trampoline_link_prog(struct bpf_prog *prog,
+				      struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	int err = 0;
 	int cnt;
 
 	kind = bpf_attach_type_to_tramp(prog);
-	mutex_lock(&tr->mutex);
-	if (tr->extension_prog) {
+	if (tr->extension_prog)
 		/* cannot attach fentry/fexit if extension prog is attached.
 		 * cannot overwrite extension prog either.
 		 */
-		err = -EBUSY;
-		goto out;
-	}
+		return -EBUSY;
+
 	cnt = tr->progs_cnt[BPF_TRAMP_FENTRY] + tr->progs_cnt[BPF_TRAMP_FEXIT];
 	if (kind == BPF_TRAMP_REPLACE) {
 		/* Cannot attach extension if fentry/fexit are in use. */
-		if (cnt) {
-			err = -EBUSY;
-			goto out;
-		}
+		if (cnt)
+			return -EBUSY;
 		tr->extension_prog = prog;
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
-					 prog->bpf_func);
-		goto out;
-	}
-	if (cnt >= BPF_MAX_TRAMP_PROGS) {
-		err = -E2BIG;
-		goto out;
+		return bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
+					  prog->bpf_func);
 	}
-	if (!hlist_unhashed(&prog->aux->tramp_hlist)) {
+	if (cnt >= BPF_MAX_TRAMP_PROGS)
+		return -E2BIG;
+	if (!hlist_unhashed(&prog->aux->tramp_hlist))
 		/* prog already linked */
-		err = -EBUSY;
-		goto out;
-	}
+		return -EBUSY;
 	hlist_add_head(&prog->aux->tramp_hlist, &tr->progs_hlist[kind]);
 	tr->progs_cnt[kind]++;
 	err = bpf_trampoline_update(tr);
@@ -450,30 +442,45 @@ int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
 		hlist_del_init(&prog->aux->tramp_hlist);
 		tr->progs_cnt[kind]--;
 	}
-out:
+	return err;
+}
+
+int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+{
+	int err;
+
+	mutex_lock(&tr->mutex);
+	err = __bpf_trampoline_link_prog(prog, tr);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
 
-/* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+static int __bpf_trampoline_unlink_prog(struct bpf_prog *prog,
+					struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	int err;
 
 	kind = bpf_attach_type_to_tramp(prog);
-	mutex_lock(&tr->mutex);
 	if (kind == BPF_TRAMP_REPLACE) {
 		WARN_ON_ONCE(!tr->extension_prog);
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
-		goto out;
+		return err;
 	}
 	hlist_del_init(&prog->aux->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(tr);
-out:
+	return bpf_trampoline_update(tr);
+}
+
+/* bpf_trampoline_unlink_prog() should never fail. */
+int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampoline *tr)
+{
+	int err;
+
+	mutex_lock(&tr->mutex);
+	err = __bpf_trampoline_unlink_prog(prog, tr);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
-- 
2.36.0.rc0.470.gd361397f0d-goog

