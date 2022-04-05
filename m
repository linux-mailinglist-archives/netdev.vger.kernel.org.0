Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF04F539B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2361327AbiDFE0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577644AbiDEXMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:12:37 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6ED7F94C3
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 14:44:14 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2eb452a9529so4742797b3.8
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 14:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ef67EnXWWhCb2BYe2KO6rF+1VUv5TW07S9SVbOQXy7g=;
        b=J4G2I65mvrsZaQKVgzq5ohqRykvDGgexG0oPDdKoMCyKS/pmHFCAEIh+feMIt2zVun
         q5Er3hHnAFr+auynneQu9NNH0t9VkXlJed8Zj+dQr0KwaSSlfkmvqPdwDE9VRH4fFcTa
         hlGTksX8Hh0mBP1uL6Lux888X4zeMeNLnqXn27Cuc9A9NBjtvD0TsMq4Gupzoqf/mVXN
         DcTiWOz9T7rZuU6imAuTl+RSx5UUVR6QZCPXwifjuI0SdTgwX4q6bwp+Lh0UPMJVYUAp
         mmBHA0VN3DyjRl5Or2BM84uKQBgmCBNoHEnYprpQjJjrla1F1tcSR/AoYokgWDySeteT
         nuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ef67EnXWWhCb2BYe2KO6rF+1VUv5TW07S9SVbOQXy7g=;
        b=lysRqSAmTHS+ztYNoY6YoWOfGzEowc7dsuqodfm9QKlggfPYNVlVejLPC8K1WDb//4
         K1+oV9p/CZ9Y5IbD2l4wQYIPT/xtcj3T2t50+zCVAFRf6jTOE7s4ilTShNVqpWeql0CK
         TdObz+EG3+wnK1YieaSGuoh/08OEKebVSoi9Pn/NwfX/p6I+FUqw4AyZr9A8xAGQmqUl
         osWmKfsjvA6X4mcUtoBnihVVFUO48kdq5nKvKj3LZNyWHi1/+NHAJbDMswSxQOzrNw33
         ezt06sJdQdTGhhwAOg8EWa7LTKI2DtS1DKh+WABlg0OeH1QDsiRI8wfnvipm4oZUFPzn
         b5Gw==
X-Gm-Message-State: AOAM53111ij5+Y9rPviJq/tn4NYEXEcpKK0/FkCkHlsdncdoJ+2kxP+d
        lb+2SkyDxyR1ztVW8uoVCHuprDoXAUMnnwWshHcxC+z7hZcb8EOC8VgwoEkSPZc5LGg202/+E6Z
        ZmNpy5VkMkshbdllC7KPE+kj5Vszq/4eT3q08fxV17e+S6DK/pF8QoQ==
X-Google-Smtp-Source: ABdhPJwA90IuQhTY9kpiqRpGPw00uHt1oblCwF8RTdKKkahmlNwx3J5b0/oWh+H8r/eEhmUn2lQmmXg=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:73b5:ffab:2024:2901])
 (user=sdf job=sendgmr) by 2002:a81:6689:0:b0:2eb:6dc1:6a58 with SMTP id
 a131-20020a816689000000b002eb6dc16a58mr4592992ywc.47.1649195027666; Tue, 05
 Apr 2022 14:43:47 -0700 (PDT)
Date:   Tue,  5 Apr 2022 14:43:36 -0700
In-Reply-To: <20220405214342.1968262-1-sdf@google.com>
Message-Id: <20220405214342.1968262-2-sdf@google.com>
Mime-Version: 1.0
References: <20220405214342.1968262-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH bpf-next v2 1/7] bpf: add bpf_func_t and trampoline helpers
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
index bdb5298735ce..487aba40ce52 100644
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
2.35.1.1094.g7c7d902a7c-goog

