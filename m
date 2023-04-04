Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269EA6D57BD
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbjDDEvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233226AbjDDEvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:51:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9806219BE;
        Mon,  3 Apr 2023 21:50:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ml21so7395766pjb.4;
        Mon, 03 Apr 2023 21:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680583858; x=1683175858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76CWmxuX1SyXCWRsf9iQqc6Xq2EOWu8B/zkczM90/Qo=;
        b=EshsSV9y5lgItYXm5ZEDwdHkapKXW4Ljl1zr6kzMgNznhOfXEg9aVrcr6ssq4ZGMfy
         +bOm5XhFY78edTfksSTvcOfspFUzk8i7MgIlh8u7JjsRVGHXx1ou6qM0Ezkl+Oo5fva2
         NwYoZ0sw2HkA4xtZt5+ajWbzmvQq6NEhh9W6F2ifq9VYZe8wl8kUWEC59YwCbEHTD5fj
         Sj76eTJS8Q47EMaeUiHVSJvtJCZxzhw3uLNh+5kohLdpfgF/PZihtO28KIxegqrqkvBl
         bb30/QuoCAZvauABseASMVT+GPG/kHB6FhuF0S7Prf43HrP5pUZkcq0nr8nJM7oRQZVt
         RYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680583858; x=1683175858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76CWmxuX1SyXCWRsf9iQqc6Xq2EOWu8B/zkczM90/Qo=;
        b=sCncQ8LH304B4lKlVQr4U6luDNYXcrB7wCEyPgJMioE41kX25l5xMqINEeO9JBCFlO
         Wqxr8mxOT8Kv67kOhFet6APf/v2tahyL6SHYjhiAsLavrLmLjvkeSWVNK6C5BkoEO34Z
         qxkYPa4Y5I6w/1uxs8aKM6P4RHOnXr0UjZMyl1tKvrSpNbE56wyjFFIjV50tVF1Fni9C
         jchzKH10xO/A9NzZjUZ3hdmQDR1/PgfpRkQ2g7ZpD8ZqGlfqmmHgwIE52qKldvzfssvW
         W1vvDp+6Li2XGNQKiLMQmk7TokDQ+ySS9jARvsIPKPGrfF0pt2NLBi6L5UAuRE+2jUz0
         N2fA==
X-Gm-Message-State: AAQBX9e7hrs9YjkqoOhaV5B3oA/th4k/7dbS642FpC18REPXXYGb6iU2
        vl8T5rrRfzwwZqDa9Deh2tM=
X-Google-Smtp-Source: AKy350ZVeyrL0ATa66Fy7PIYpfKvdh3+4gXiDdnXNECj4s8Y/xtzu90fsBVksc2vp/wGHs5ZPwgb/Q==
X-Received: by 2002:a17:90a:190f:b0:23f:990d:b5b1 with SMTP id 15-20020a17090a190f00b0023f990db5b1mr1371387pjg.46.1680583857934;
        Mon, 03 Apr 2023 21:50:57 -0700 (PDT)
Received: from dhcp-172-26-102-232.DHCP.thefacebook.com ([2620:10d:c090:400::5:3c8])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090a13c300b0023d16f05dd8sm6956945pjf.36.2023.04.03.21.50.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 03 Apr 2023 21:50:57 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, martin.lau@kernel.org,
        void@manifault.com, davemarchevsky@meta.com, tj@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH bpf-next 6/8] bpf: Allowlist few fields similar to __rcu tag.
Date:   Mon,  3 Apr 2023 21:50:27 -0700
Message-Id: <20230404045029.82870-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Allow bpf program access cgrp->kn, mm->exe_file, skb->sk, req->sk.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4e7d671497f4..fd90ba498ccc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5378,6 +5378,7 @@ static int bpf_map_direct_read(struct bpf_map *map, int off, int size, u64 *val)
 }
 
 #define BTF_TYPE_SAFE_RCU(__type)  __PASTE(__type, __safe_rcu)
+#define BTF_TYPE_SAFE_RCU_OR_NULL(__type)  __PASTE(__type, __safe_rcu_or_null)
 #define BTF_TYPE_SAFE_TRUSTED(__type)  __PASTE(__type, __safe_trusted)
 
 /*
@@ -5394,10 +5395,31 @@ BTF_TYPE_SAFE_RCU(struct task_struct) {
 	struct task_struct *group_leader;
 };
 
+BTF_TYPE_SAFE_RCU(struct cgroup) {
+	/* cgrp->kn is always accessible as documented in kernel/cgroup/cgroup.c */
+	struct kernfs_node *kn;
+};
+
 BTF_TYPE_SAFE_RCU(struct css_set) {
 	struct cgroup *dfl_cgrp;
 };
 
+/* RCU trusted: these fields are trusted in RCU CS and can be NULL */
+BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct) {
+	struct file __rcu *exe_file;
+};
+
+/* skb->sk, req->sk are not RCU protected, but we mark them as such
+ * because bpf prog accessible sockets are SOCK_RCU_FREE.
+ */
+BTF_TYPE_SAFE_RCU_OR_NULL(struct sk_buff) {
+	struct sock *sk;
+};
+
+BTF_TYPE_SAFE_RCU_OR_NULL(struct request_sock) {
+	struct sock *sk;
+};
+
 /* full trusted: these fields are trusted even outside of RCU CS and never NULL */
 BTF_TYPE_SAFE_TRUSTED(struct bpf_iter_meta) {
 	struct seq_file *seq;
@@ -5430,11 +5452,23 @@ static bool type_is_rcu(struct bpf_verifier_env *env,
 			const char *field_name, u32 btf_id)
 {
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct task_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct cgroup));
 	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU(struct css_set));
 
 	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_rcu");
 }
 
+static bool type_is_rcu_or_null(struct bpf_verifier_env *env,
+				struct bpf_reg_state *reg,
+				const char *field_name, u32 btf_id)
+{
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU_OR_NULL(struct mm_struct));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU_OR_NULL(struct sk_buff));
+	BTF_TYPE_EMIT(BTF_TYPE_SAFE_RCU_OR_NULL(struct request_sock));
+
+	return btf_nested_type_is_trusted(&env->log, reg, field_name, btf_id, "__safe_rcu_or_null");
+}
+
 static bool type_is_trusted(struct bpf_verifier_env *env,
 			    struct bpf_reg_state *reg,
 			    const char *field_name, u32 btf_id)
@@ -5561,9 +5595,10 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 			if (type_is_rcu(env, reg, field_name, btf_id)) {
 				/* ignore __rcu tag and mark it MEM_RCU */
 				flag |= MEM_RCU;
-			} else if (flag & MEM_RCU) {
+			} else if (flag & MEM_RCU ||
+				   type_is_rcu_or_null(env, reg, field_name, btf_id)) {
 				/* __rcu tagged pointers can be NULL */
-				flag |= PTR_MAYBE_NULL;
+				flag |= MEM_RCU | PTR_MAYBE_NULL;
 			} else if (flag & (MEM_PERCPU | MEM_USER)) {
 				/* keep as-is */
 			} else {
-- 
2.34.1

