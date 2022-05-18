Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15FE52C712
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 01:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiERW6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiERW4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4775F2265E9
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:36 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 135-20020a25058d000000b0064dd6bc9cfdso2874197ybf.23
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TmU3TPEQ71AzbFMJrCVCfzfvu+DBevj7Y5+l60jkcnw=;
        b=Hsr7rkeJB/HX80tKJuoXVSAlGsYmIOfqMCoRsDOMv1A2V5RuaCNNR9BVnegOWYkxmt
         0Ldw4GgDSFFP94Eo6iEu4ccs2lD9/bQO01WdNGDrOql71DggkXNccGW+veZxtdVmbmNd
         4GyY/NwyeH2qsfAxqsNQ7a5e6gpTko9qlSpuN6dx+GI5U8m/Atdb6PrAX5xlPSImfI4c
         O0drbzz0IQ60i3gbPsQlYfTWRDqfm/dYA/3ec8lnINkRU6Q4I3MK2gL4TMPD90RKQVbM
         BHX3Sm+ZGZfiMagU5vi7LOeSCeI2nrJtyb72oX2bgj+VOYbKif1O9FQEb10LP1lDb73e
         jTjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TmU3TPEQ71AzbFMJrCVCfzfvu+DBevj7Y5+l60jkcnw=;
        b=jWiH+MDqty72pghDZPvvWuu07oiFDC0n0Qfk5weRhfPr6OCJ3ixBTPcJqQOmYALHvf
         eEAn1qHU5+hEGrVCiiGhxXKIVICH778m9aAFoISVZtmPIyf5SsabJ+5WTL9c+j+VNrGl
         I0xqTagS3JyRtoOh8FLTymL0lrq0N/0Vk9rVhuRAVi+Ag2FN6PmNQUEXFENTRGNvkaXs
         7t7NHJQz6vsF8dkyy4CtmnHuvAVOyD3KNjDA8c0ER6TJA5t4DiB8KrtrcJ5NGutrA1Nz
         YVYfsa4K+r9gL0vklE/xpLbyHOX/yi00O3RfiTsu7IMmJebLzV0YV4KiHON6YdO2Xkiq
         GHMw==
X-Gm-Message-State: AOAM531bMvvIfLDKOsEotWcIGa1PT0SztYBNW2s3jxvsnJQC7L8lDpxw
        kNyzbq1uCI6UAwOIA6kaDi5APrhT1T8TEHuUPL4LtfhfZBcQut/wZ46b+22x2J5ZQhLn6Krwum3
        LUj8xWdId0XpF7DJ1OMVv+iZ4TV+9SWyAZ6WwXEV00ri/l/MAu+Wm/w==
X-Google-Smtp-Source: ABdhPJxvP2lVCm3fAuqiwDxhA5l3tJKZjDngrv6uB7L6UsvWUmjra1avVr2Wlppvi3ARakPcoVEBpik=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a25:dc02:0:b0:64d:b6a3:e0bf with SMTP id
 y2-20020a25dc02000000b0064db6a3e0bfmr1810299ybe.41.1652914535428; Wed, 18 May
 2022 15:55:35 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:21 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-2-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 01/11] bpf: add bpf_func_t and trampoline helpers
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/bpf.h     | 11 ++++----
 kernel/bpf/trampoline.c | 62 ++++++++++++++++++++++-------------------
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index c107392b0ba7..ea3674a415f9 100644
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
@@ -853,8 +855,7 @@ struct bpf_dispatcher {
 static __always_inline __nocfi unsigned int bpf_dispatcher_nop_func(
 	const void *ctx,
 	const struct bpf_insn *insnsi,
-	unsigned int (*bpf_func)(const void *,
-				 const struct bpf_insn *))
+	bpf_func_t bpf_func)
 {
 	return bpf_func(ctx, insnsi);
 }
@@ -883,8 +884,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 	noinline __nocfi unsigned int bpf_dispatcher_##name##_func(	\
 		const void *ctx,					\
 		const struct bpf_insn *insnsi,				\
-		unsigned int (*bpf_func)(const void *,			\
-					 const struct bpf_insn *))	\
+		bpf_func_t bpf_func)					\
 	{								\
 		return bpf_func(ctx, insnsi);				\
 	}								\
@@ -895,8 +895,7 @@ int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
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
index 93c7675f0c9e..01ce78c1df80 100644
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
@@ -465,30 +454,45 @@ int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline
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
 
 /* bpf_trampoline_unlink_prog() should never fail. */
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
2.36.1.124.g0e6072fb45-goog

