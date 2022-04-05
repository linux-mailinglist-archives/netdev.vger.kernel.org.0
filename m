Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6484F5415
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2360370AbiDFEZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577682AbiDEXMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 19:12:40 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D50FABFA
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 14:44:21 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2eba71ef663so4547147b3.14
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 14:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6NblM4DdSDjYKjDgLxEintAgK2IySwji0MbdGVjQAJ0=;
        b=aH7t3UmNuSMetoAxnT29hxQBjyn++fuJ7enCmtqyWIsfGhMm81NfSU5Nsxn6Fj9iuA
         TD7F3D5JrZ9gjaADebR/1Y6cS6NJneMk4y3euudNGGK4sQfKW+8r/CwY7VbgYJDbgqLA
         Hn+nTh34dLgSC5vLlYbRCxxi0ln6Fw6i/Ba8vnN9S+9E8McgZTlcpLsmMVQz5ER5pNYW
         rQHwOYEx9T/ZvNJfJHXwlzP0ZGC6PMD8wlYPt11XffIgFhYO89O4en2PzT/qLTkyzX9p
         6Cfv7Spx/dXn5IbU95dJzaEYQHoj/3xpDXcOJt9GLg93KSMeaMqD5u+FaMYQeRL0Nzej
         JKUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6NblM4DdSDjYKjDgLxEintAgK2IySwji0MbdGVjQAJ0=;
        b=155SiztXZXyHR8dBsrPkAbzEIb8x4m11h6Sz56QOgHGg3q1VY9/ULRHr2rgFndQHuZ
         GWvsWa8Qr+u98L0Zn3SdaZ35AAyscrNJ211hryDH56LnUi/8U6AwbkyLIk22f2J1afcI
         IB6KqgcX+zHtu7SxHogrRRwWJT2RdxZ8muFeNPIlODcrGFPgHF53aTf59Xzpp59q0V4Q
         yOHy4XGAK2+LUacZP3vX/j69wghDfPQB8gzBUoL+XLQ8UJNdTEeflj/kUYderQho6ukW
         Bapsh4T5b0j0ftYuFA8YnHbsczMHNewXXQGF386yiNNNkUss5fZl7wfPVJce7h9mUKBG
         6dhA==
X-Gm-Message-State: AOAM530uB8t6sGhR+AxPh20t0CLP37ELfM8kDC+Dru6L+QwyT3i9tW0X
        KL2sgygeuMPGf4Y7tCQ4kvxUgO09Dr1mVnCQcETpWJ6Pa8YgTIuK6AqbXz/sGeoMlIPAhiFjffI
        5ykn11jirFX+vz5AQb8AMjsu+TZI0v58ocGVR2u8TLvieKhspa/uIOA==
X-Google-Smtp-Source: ABdhPJz3bIH4Nxzw2caA4SgqgSA/xVwcc5VpbPucgbV0dvxX8YFSZFFqtXVW0z6sHMfbuDac/SI7xW8=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:73b5:ffab:2024:2901])
 (user=sdf job=sendgmr) by 2002:a81:b288:0:b0:2d6:39d5:31a1 with SMTP id
 q130-20020a81b288000000b002d639d531a1mr4504807ywh.506.1649195035035; Tue, 05
 Apr 2022 14:43:55 -0700 (PDT)
Date:   Tue,  5 Apr 2022 14:43:39 -0700
In-Reply-To: <20220405214342.1968262-1-sdf@google.com>
Message-Id: <20220405214342.1968262-5-sdf@google.com>
Mime-Version: 1.0
References: <20220405214342.1968262-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH bpf-next v2 4/7] bpf: allow writing to a subset of sock fields
 from lsm progtype
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

For now, allow only the obvious ones, like sk_priority and sk_mark.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/bpf_lsm.c  | 58 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c |  3 ++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 8b948ec9ab73..cc13da18d8b3 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -332,7 +332,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
 const struct bpf_prog_ops lsm_prog_ops = {
 };
 
+static int lsm_btf_struct_access(struct bpf_verifier_log *log,
+					const struct btf *btf,
+					const struct btf_type *t, int off,
+					int size, enum bpf_access_type atype,
+					u32 *next_btf_id,
+					enum bpf_type_flag *flag)
+{
+	const struct btf_type *sock_type;
+	struct btf *btf_vmlinux;
+	s32 type_id;
+	size_t end;
+
+	if (atype == BPF_READ)
+		return btf_struct_access(log, btf, t, off, size, atype, next_btf_id,
+					 flag);
+
+	btf_vmlinux = bpf_get_btf_vmlinux();
+	if (!btf_vmlinux) {
+		bpf_log(log, "no vmlinux btf\n");
+		return -EOPNOTSUPP;
+	}
+
+	type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
+	if (type_id < 0) {
+		bpf_log(log, "'struct sock' not found in vmlinux btf\n");
+		return -EINVAL;
+	}
+
+	sock_type = btf_type_by_id(btf_vmlinux, type_id);
+
+	if (t != sock_type) {
+		bpf_log(log, "only 'struct sock' writes are supported\n");
+		return -EACCES;
+	}
+
+	switch (off) {
+	case bpf_ctx_range(struct sock, sk_priority):
+		end = offsetofend(struct sock, sk_priority);
+		break;
+	case bpf_ctx_range(struct sock, sk_mark):
+		end = offsetofend(struct sock, sk_mark);
+		break;
+	default:
+		bpf_log(log, "no write support to 'struct sock' at off %d\n", off);
+		return -EACCES;
+	}
+
+	if (off + size > end) {
+		bpf_log(log,
+			"write access at off %d with size %d beyond the member of 'struct sock' ended at %zu\n",
+			off, size, end);
+		return -EACCES;
+	}
+
+	return NOT_INIT;
+}
+
 const struct bpf_verifier_ops lsm_verifier_ops = {
 	.get_func_proto = bpf_lsm_func_proto,
 	.is_valid_access = btf_ctx_access,
+	.btf_struct_access = lsm_btf_struct_access,
 };
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1d2f2e7babb2..d42ee0033755 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12843,7 +12843,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				insn->code = BPF_LDX | BPF_PROBE_MEM |
 					BPF_SIZE((insn)->code);
 				env->prog->aux->num_exentries++;
-			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS) {
+			} else if (resolve_prog_type(env->prog) != BPF_PROG_TYPE_STRUCT_OPS &&
+				   resolve_prog_type(env->prog) != BPF_PROG_TYPE_LSM) {
 				verbose(env, "Writes through BTF pointers are not allowed\n");
 				return -EINVAL;
 			}
-- 
2.35.1.1094.g7c7d902a7c-goog

