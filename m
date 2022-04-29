Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF53D515699
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236639AbiD2VT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiD2VTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C487EA1C
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so8475003ybg.8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZAfKPNLYcqo0cDIFYU+gDT4lGoQqRciZy76yQyksGOk=;
        b=Jn02PSlAt7hRdUC4/C7UYX2Yp/CiotucNpXs4yFDhhG7mR3/5HKAW6M7uCyLgRDstm
         bUigB37Iy7b5XnTmNM5UOfGVv0p9D2XwRqtHJTVuPU6C9X+fiP1WIJD1uUS06rf9rE0P
         N++AXZD+r3tGrWqy9oEI4RnigbdQCazfLAY73JtpjthRVtcxDfXA5eFldCHUz0PVMchi
         nKhcOaRCtL5YWWd2NvTV4oK6z8xH5zGxZC1fmK+Jq5INtmCKcUQJiFRULPtpu0YFpaDM
         zce71GDqYhvisS1tskyjtz2tOAtjAN7Ex9M6EAefmMfkIcnHvhUeIRT44tgBlsUt45Kg
         fBkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZAfKPNLYcqo0cDIFYU+gDT4lGoQqRciZy76yQyksGOk=;
        b=ptZIXdP0R35Yy6O+oRripHJ6GOMdJdb9uGx2ZbaJKGtFXOw7jNNYJ2RoUw78lTHrg5
         GicUVxRoeHJrSfDjo0Ej+IUZt7RSPPLO97GlEsgMuLRHR1xKCrQEwWakmzuaOcD+BkjI
         RHHTOWoGOBIvWhwprXeizbYBwaNPksuT5DN8M/zPb/pVwUD0ndt6VuYtn/lrGVCfdkTY
         EyUJ3hgKyeWeondXR83adHK8v2DMKGT/BKDv0n0afyQzUMPztWz+bbymYTLMA2MtVmgI
         0dUaHxaX5HKG2dnFVxMTrn8KQE9TOIOJ21Kmn4ZWV2pjftaQvYaTj1s6lzWTWsgyMi+g
         swrA==
X-Gm-Message-State: AOAM531w/D9aONtHU63hyvhXI3Wyu6gMSig2ftSzVq4UAfr8/9Kv+Uk6
        A7u5zAStbv0eRHNWPzUAT8KqqoBolM72pztvunXO3mdd/OFpak/vz9mYRcPLlycj49q7fGevjSJ
        eZdRLM1trl4fo6SedqlEAqK9HSjM9eVz36/6ZDZTPgK+RtDGVtYvlTA==
X-Google-Smtp-Source: ABdhPJwQwcdzZuWFq3lhlVYpgvCYZ/8qASglsvbF0JLfvjwZoqwvAYnX3MexsPbHuqbm+O9ZsZVp+SE=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a81:1545:0:b0:2f7:b6d6:c486 with SMTP id
 66-20020a811545000000b002f7b6d6c486mr1244997ywv.261.1651266957393; Fri, 29
 Apr 2022 14:15:57 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:36 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-7-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 06/10] bpf: allow writing to a subset of sock
 fields from lsm progtype
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 1079c747e061..64406d39e861 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -302,7 +302,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
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
index 99703d96c579..2ada6fd48638 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13130,7 +13130,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
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
2.36.0.464.gb9c8b46e94-goog

