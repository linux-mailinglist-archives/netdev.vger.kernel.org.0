Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EB14B7BA4
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244962AbiBPANB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:13:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244813AbiBPANA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:13:00 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B597DD460
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id b64-20020a256743000000b0061e169a5f19so788013ybc.11
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5EUxcrErCsNmjbOMc+BbJfxjTVhsz7Xhh+knicHeLos=;
        b=GWT4PvuRedUwXdkk9G0ey4k/5joKdqDJPJj2NV7m/7rDP2Z3u2AzUxq+VsFC/AJPVj
         nc24Sc+fcDS/J1tAtSBBRq0+N6hxXF8QinSQpnhmwSxnM01CT/UO+CgBMH4RwfWdqatc
         Y5GQxaLDmJoYoY4vk+DqR/R870sz+/xZTTggH5V74QxAqxaEB1ZU4sGEhI++dl/EnmRu
         Kk+TPwA1rKHlfHvY+UwxOjBmDXKcmdYltcka1tf0MeHtkRqIiH2b6PZhx7ErZ913GDZQ
         TNHBq9Lzvw5UmUEPYtMkXtYPgQR5FYsR19JCLCrnMT8nBu1468Q5WTuyAUVMCAmkVMeo
         /hHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5EUxcrErCsNmjbOMc+BbJfxjTVhsz7Xhh+knicHeLos=;
        b=u+todQSc/0lvEv+rFn5yvuz0V4DsW3QhgPfILGw4xSkhZUeAq3MZTvvD0lrIGodZrx
         Ydpo1FHQCv1ahCtxuWBYupnLOLh5NWtgpYsHBdzobtPnI7TuYJCHfURrEjPMZa/QnAfA
         qeOc+52t41BR3Se/KGdgUp+D0sc1lTKD1bLdNqfZ5T4oPKijSZoYKdG+MWBVDXpMd/mA
         4RMWyACAg7911S1tTX3zawKC9NKywPhwPAkJ3T/mfM/1qso14MkXcRixBfZ1s9iD5I+1
         fdBi7/AXip4UVL8dufvK4xi/eSukPayOOh4EuCQCFQIKeZ08KdWug2QeG5cI6GDxj7Mq
         rIRw==
X-Gm-Message-State: AOAM533ia4IPjNJy/CdL5tu1gjBVLD3WSIl1S363ooM3XFVN7v2uvVmn
        FDtX4KPwBNTzvQaiF6vtC/qkX7jA210Xt0bGX+iGanoxSsV7s7GQCuGXR3voqACBHulf1sxgjAY
        SMk4eRInUnq93+b9n5235+34Z5M2kKhgKnUmc33DUIzhNVdU86V1erQ==
X-Google-Smtp-Source: ABdhPJzCQyipgZ3OEAttZ9NB2xLOOHJzoEgGhxjP5lbSLKpWHRZ2IPE3icuXYQB2GBn9fsJQUKUqpFU=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:754a:e17d:48a0:d1db])
 (user=sdf job=sendgmr) by 2002:a05:6902:83:b0:610:7e09:64bd with SMTP id
 h3-20020a056902008300b006107e0964bdmr67757ybs.653.1644970368755; Tue, 15 Feb
 2022 16:12:48 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:12:39 -0800
In-Reply-To: <20220216001241.2239703-1-sdf@google.com>
Message-Id: <20220216001241.2239703-3-sdf@google.com>
Mime-Version: 1.0
References: <20220216001241.2239703-1-sdf@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC bpf-next 2/4] bpf: allow writing to sock->sk_priority from lsm progtype
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

Open up enough fields for selftests. Will be extended in the real
patch series to match bpf_sock fields.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/bpf_lsm.c  | 49 +++++++++++++++++++++++++++++++++++++++++++
 kernel/bpf/verifier.c |  3 ++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 9e4ecc990647..1a68661e1b9c 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -222,7 +222,56 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
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
+
+	type_id = btf_find_by_name_kind(btf_vmlinux, "sock", BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return -EINVAL;
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
index 1563723759d9..b8991460d17d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12801,7 +12801,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
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
2.35.1.265.g69c8d7142f-goog

