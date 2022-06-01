Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BCE53AD24
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 21:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiFATGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 15:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiFATGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 15:06:51 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BD11181C
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 12:06:48 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id z12-20020a170903018c00b001651395dcb8so1496896plg.12
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 12:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FFB2suG8cFo0y0QCZ+gGk4yWBmnHr1ArG9MtWFGk+Jk=;
        b=fCiMYQmCZazeJfbkHT8SEt8S0Vkv1a6q7U7Q3yYSj2uXlN9zs7cKorjEQ2YrW19PY7
         E/OJzXoa7wWm+Kb1w4pvv4T5jZ+bNFPW09107/xISMTX3SfBMn4HLjn2XqaeVGaEGuob
         tnyGYpqnt2aUQsIJTPsH/SLx4J6rPARSs0YTIUmIwAI6JmUbnYqTpsj1IMij8djqQo9/
         nOjocgae/+XL0oWDYcXcJ56PWzBSQUx6ibtPWpd/neoNWNkMF3Q21az3P5ad3vr3PTQ4
         gf6mml1CmAfcdWvnzq/NmcO+hk+5Ot0M09J2KvjHzVY7VBGgP9toCnT06J/YpCj7PtbD
         uiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FFB2suG8cFo0y0QCZ+gGk4yWBmnHr1ArG9MtWFGk+Jk=;
        b=zDp7GS0t+41lf9Accl9+f4fM6/iQxGzuzD4sMTwbSsLbYYegcZDEjsE3LV1r3hKZyA
         vw8jJAHEB9Tw0WQ3fS8cHUlSOUP548PC2wEMAoIg7vBrn58aRPcKFsxW3jWYZX9kVXUd
         u84YM602QvItoLUAJBGQOEfMV93fLitoDKzUpdklvOTMrVlrDGEKTNmzFYgdZcoAqfoQ
         yGD1kTyu691cOrS+9Otopey40XXetPWzlN32nQwntJuyvxQQsGlSs7UUQr555pIYq/bg
         ft9AyKPMfsLB6URYxJf4mljn7P5lGAeUgFMvn95lEqExdB18LmhFNvh0ZOi0LSaAT8iO
         7aOQ==
X-Gm-Message-State: AOAM532cmSbjHKAs+tdBUV5Tqy8MMRqB/QCL1scXDsC5iG0wXCbblE03
        yXDd9Jrg2KyHLZtFAGBOtkjcbJoG6CmjomGd57eSUhr6N75LAZFZ7hlBRpnD6nkGYhulC1hS1Ee
        hQTN9zM4SVZ/ks4IeoaNd414WUwwKdwPSkY5gYe1TWiQsaxFIfr7YcQ==
X-Google-Smtp-Source: ABdhPJwpmUY21UlX/04WqtyIF73T+IOPYUKLIosAu7laWb5Uowi2fdPqMtdJMiRXSAQTq6l7wjKwdZo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:14d4:b0:518:b918:fae4 with SMTP id
 w20-20020a056a0014d400b00518b918fae4mr45446381pfu.55.1654110141845; Wed, 01
 Jun 2022 12:02:21 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:08 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-2-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 01/11] bpf: add bpf_func_t and trampoline helpers
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
 kernel/bpf/trampoline.c | 63 +++++++++++++++++++++--------------------
 2 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 8e6092d0ea95..b0af68b6297b 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -53,6 +53,8 @@ typedef u64 (*bpf_callback_t)(u64, u64, u64, u64, u64);
 typedef int (*bpf_iter_init_seq_priv_t)(void *private_data,
 					struct bpf_iter_aux_info *aux);
 typedef void (*bpf_iter_fini_seq_priv_t)(void *private_data);
+typedef unsigned int (*bpf_func_t)(const void *,
+				   const struct bpf_insn *);
 struct bpf_iter_seq_info {
 	const struct seq_operations *seq_ops;
 	bpf_iter_init_seq_priv_t init_seq_private;
@@ -863,8 +865,7 @@ struct bpf_dispatcher {
 static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
-	unsigned int (*bpf_func)(const void *,
-				 const struct bpf_insn *))
+	bpf_func_t bpf_func)
 {
 	return bpf_func(ctx, insnsi);
 }
@@ -893,8 +894,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
-		unsigned int (*bpf_func)(const void *,			\
-					 const struct bpf_insn *))	\
+		bpf_func_t bpf_func)					\
 	{								\
 		return bpf_func(ctx, insnsi);				\
 	}								\
@@ -905,8 +905,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
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
index 93c7675f0c9e..5466e15be61f 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -410,7 +410,7 @@ static enum bpf_tramp_prog_type bpf_attach_type_to_tramp(struct bpf_prog *prog)
 	}
 }
 
-int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+static int __bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	struct bpf_tramp_link *link_exiting;
@@ -418,44 +418,33 @@ int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline
 	int cnt = 0, i;
 
 	kind = bpf_attach_type_to_tramp(link->link.prog);
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
 
 	for (i = 0; i < BPF_TRAMP_MAX; i++)
 		cnt += tr->progs_cnt[i];
 
 	if (kind == BPF_TRAMP_REPLACE) {
 		/* Cannot attach extension if fentry/fexit are in use. */
-		if (cnt) {
-			err = -EBUSY;
-			goto out;
-		}
+		if (cnt)
+			return -EBUSY;
 		tr->extension_prog = link->link.prog;
-		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
-					 link->link.prog->bpf_func);
-		goto out;
-	}
-	if (cnt >= BPF_MAX_TRAMP_LINKS) {
-		err = -E2BIG;
-		goto out;
+		return bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP, NULL,
+					  link->link.prog->bpf_func);
 	}
-	if (!hlist_unhashed(&link->tramp_hlist)) {
+	if (cnt >= BPF_MAX_TRAMP_LINKS)
+		return -E2BIG;
+	if (!hlist_unhashed(&link->tramp_hlist))
 		/* prog already linked */
-		err = -EBUSY;
-		goto out;
-	}
+		return -EBUSY;
 	hlist_for_each_entry(link_exiting, &tr->progs_hlist[kind], tramp_hlist) {
 		if (link_exiting->link.prog != link->link.prog)
 			continue;
 		/* prog already linked */
-		err = -EBUSY;
-		goto out;
+		return -EBUSY;
 	}
 
 	hlist_add_head(&link->tramp_hlist, &tr->progs_hlist[kind]);
@@ -465,30 +454,44 @@ int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline
 		hlist_del_init(&link->tramp_hlist);
 		tr->progs_cnt[kind]--;
 	}
-out:
+	return err;
+}
+
+int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+{
+	int err;
+
+	mutex_lock(&tr->mutex);
+	err = __bpf_trampoline_link_prog(link, tr);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
 
-/* bpf_trampoline_unlink_prog() should never fail. */
-int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
 {
 	enum bpf_tramp_prog_type kind;
 	int err;
 
 	kind = bpf_attach_type_to_tramp(link->link.prog);
-	mutex_lock(&tr->mutex);
 	if (kind == BPF_TRAMP_REPLACE) {
 		WARN_ON_ONCE(!tr->extension_prog);
 		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
 					 tr->extension_prog->bpf_func, NULL);
 		tr->extension_prog = NULL;
-		goto out;
+		return err;
 	}
 	hlist_del_init(&link->tramp_hlist);
 	tr->progs_cnt[kind]--;
-	err = bpf_trampoline_update(tr);
-out:
+	return bpf_trampoline_update(tr);
+}
+
+/* bpf_trampoline_unlink_prog() should never fail. */
+int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
+{
+	int err;
+
+	mutex_lock(&tr->mutex);
+	err = __bpf_trampoline_unlink_prog(link, tr);
 	mutex_unlock(&tr->mutex);
 	return err;
 }
-- 
2.36.1.255.ge46751e96f-goog

