Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2090A5079B9
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357508AbiDSTEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357500AbiDSTEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:04:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF993F31E
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:01:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a18-20020a25bad2000000b0063360821ea7so15607245ybk.15
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 12:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WsbIvWJzyW+xGxjw/3+rbSUhNFPySw8SJoOh+xXQbd0=;
        b=bbqNhgU0thhNE2t0TRW3C3wZT5PDQJLOeRL6fJh2uakx13B7qwlZiw32zw5m+kRKR1
         BmkBSHJEj/M2yck1xK/LJWSrBdG3o4Y3YpKH0vYMf/RYeEVV4PthAza0Y758NE3Vo0Tj
         6L1bsvm7jur20cOaKgSgQ9ZettlU2sCjYT+14d0ZUu8dAI8pP4KRUFFL1Mfooe0PpEAe
         VDZkIuiBZ2MVzZOSBmORkI9V3grLBZmqvRzdCRQ0Wj2hwvNlIThYk02rooZ1P0mqn8q9
         OosPVFGlmMKDwamOhQ3NdrY3MEqw8qrEKS4ul55yOmOsReJ/1sf4jSaxp5nwq7bFnowT
         HT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WsbIvWJzyW+xGxjw/3+rbSUhNFPySw8SJoOh+xXQbd0=;
        b=rTlJ6zqIqqwMIerTyg5FZ+Z0vdqiDkdO5T3JyePrfdoPZkwPCwQ1SVBNlKkPCz0eoM
         JK3LwZxH13ikaVLnQoSmMp+q4ll0IKyLXaZBPvnUHNcn9lwzty8J0uaRjmexDyUEBGWh
         vtcij9f9ZpdNAnLotCCoRO4r9ayzF9QXGPsA1PpBHKHzbP/m5vhXwLcimQPhKndorme2
         4u2WRCJqsmcgJ2yOekIJau06MBRgqTEAKMCrIE+ItDxL0JqDUC0MQz/xm/v2YzH5Wrsj
         OTmsBLjwOWt7/gtLk8yA00G8FbKSr/iFnydAnndvQ0uyeaiQVIoGzJjSGXpWiosS1FwS
         CuvQ==
X-Gm-Message-State: AOAM532dXewwiNbDm1WWcWXj0oeNAH0gA2AiSrwf6rLYe3T4iq7/hMip
        Q8TITGpPbb+gUW7Ru1i6H/plEYxpfhijRAKatD169Ea0amh1OGQeS3aBZRLeO5KyxSoLfoiMJBi
        EekY1eh2U9wmFf1kEgvzJrQBoLBwx+tt4Thn8bz0yVwJPvh9rPXstmQ==
X-Google-Smtp-Source: ABdhPJyo13oHyEWyEmnxqb/sF/lXonDDeo6pSOqbpHewg2xxqivDPkFoeaBPdVGClAgz1uuLaW0xne0=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:37f:6746:8e66:a291])
 (user=sdf job=sendgmr) by 2002:a5b:cd:0:b0:641:6d0c:30f5 with SMTP id
 d13-20020a5b00cd000000b006416d0c30f5mr16086598ybp.489.1650394869742; Tue, 19
 Apr 2022 12:01:09 -0700 (PDT)
Date:   Tue, 19 Apr 2022 12:00:50 -0700
In-Reply-To: <20220419190053.3395240-1-sdf@google.com>
Message-Id: <20220419190053.3395240-6-sdf@google.com>
Mime-Version: 1.0
References: <20220419190053.3395240-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH bpf-next v5 5/8] bpf: allow writing to a subset of sock fields
 from lsm progtype
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

For now, allow only the obvious ones, like sk_priority and sk_mark.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/bpf_lsm.c  | 58 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c |  3 ++-
 2 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 7f8a631da90f..d49663685946 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -301,7 +301,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
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
index cc84954846d7..0d6d5be30a36 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12872,7 +12872,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
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
2.36.0.rc0.470.gd361397f0d-goog

