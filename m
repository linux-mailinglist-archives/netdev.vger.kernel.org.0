Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8489453AF60
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiFAVQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 17:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiFAVQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 17:16:43 -0400
Received: from mail-vk1-xa4a.google.com (mail-vk1-xa4a.google.com [IPv6:2607:f8b0:4864:20::a4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA4A67D15
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 14:16:40 -0700 (PDT)
Received: by mail-vk1-xa4a.google.com with SMTP id f14-20020a1f1f0e000000b0035c54b75a8fso583171vkf.1
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 14:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=sOqyOc0RV6TEgXr+bTqTDYTCAUIFhqEy6NBax/+Wu4M=;
        b=KU/UBWFiNSw1xK3zhUj/mu+Sw97S5oYLcVxHB0vrW+tHOLlXTwlAPFq6vOaBcXokAR
         5mZ6mhsjGn7tmPRPQl6XXJxuFER/fIjJPRKReyerSnhIw6yEv4GfkraPv2lhHBpRS9+K
         Kf/5ch7ask0l7Vq8pIYtypF5/dbKXKQlIwjOS+vMhiIeaMWVwuRMryg5djXy8pPzIE7O
         ZurK2DIfjaHixJxLVN7J6zOVA/nyeGWYH5O4n07ev6MOJVfSQ1pQALIhuuSWUrJs+E9K
         rhIB0oHYJjt76zpqsgcWWGSOQ6+aWJbPDKVyJU8uii+7I1WddCPGh3cFAtHlUuDOY6BQ
         JxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sOqyOc0RV6TEgXr+bTqTDYTCAUIFhqEy6NBax/+Wu4M=;
        b=BNJfQ2LKr0QND+Dtd9/979HBEv967cUsXw0ri2iI9gaap5foRUhO23K4y5mBs4DOk/
         qRLSeI41X5oT2PmL9ggiDAOjLO+mc4qI19yoOFrML0wfCbkdwHskXbwQ/x9ztem8fMLK
         eZeZys3aRK8LNnlOgNBEAj8p9MxhdZtg2cKmQOhMcmDbO+/ohpmqQUBvQkgu/7/sZh9l
         LGEeb0Y+7WAWCkDyWC/54/EEwfN6DSYdCOpQ95m8pZX6CUcqUeHqSy+mR+ClmCK6hyxX
         AfehGdd4M9gG2xKs6SPCQOc91NaiedmPn8c/qR3SLJ9ZzcRQ8NAe/3SSK8oGButFv7r2
         meCQ==
X-Gm-Message-State: AOAM531DkjY7BZf5c8lDI30yECn6ejudqPMw6hBcD90IbOYndIxfX6UF
        NAha3DY69YbuRvsBOAmI5hYXSsvClKLUVR2vl63BnO1/ow0/Zo6TqC8JE+kC9O+hLmfSvG1Z+Fh
        sn5eb+yWAdFsJQMBc57aJL2oe53ZofrzAzGIozh3TnXEsauBjzpgn8w==
X-Google-Smtp-Source: ABdhPJxwkEk9yUDmAjCIG1NiTs1oDU04xt3JbFOSxkgPFy34ArqAEjPI9OzLCENagAjelN1XWFuFbKA=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:4008:b0:518:cc07:d1f8 with SMTP id
 by8-20020a056a00400800b00518cc07d1f8mr42089742pfb.8.1654110150604; Wed, 01
 Jun 2022 12:02:30 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:13 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-7-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 06/11] bpf: allow writing to a subset of sock
 fields from lsm progtype
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
index 83aa431dd52e..feba8e96f58d 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -303,7 +303,65 @@ bool bpf_lsm_is_sleepable_hook(u32 btf_id)
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
index caa5740b39b3..c54e171d9c23 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13413,7 +13413,8 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
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
2.36.1.255.ge46751e96f-goog

