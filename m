Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A254F59FB94
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 15:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbiHXNlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 09:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238359AbiHXNlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 09:41:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19147E03D
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 06:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661348472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TByrnl5mvHzHJ+ulIX49DcCahKnXBzMQ+ewrPuje1Cw=;
        b=Cpzvp7/XVrZTpAUHepvrXkxrwbG/fdRsb4bGCqIahVXHpZ2/CP7rYk+LXqPQfkXK8G4YYj
        pTvs0gZXygr01LXzkBQY0r79lz5zGrB8tXHGAUZFCl2REb+v+I/2y7I3DLhQ45dbIHCP9l
        Ot+0c/l4z76pV8FByGHEQbrTbNikNm8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-183-Uzb7pSuZNGW9T9cNFwQvOw-1; Wed, 24 Aug 2022 09:41:07 -0400
X-MC-Unique: Uzb7pSuZNGW9T9cNFwQvOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB293101E985;
        Wed, 24 Aug 2022 13:41:05 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9B5AB945DD;
        Wed, 24 Aug 2022 13:41:02 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to read user provided context
Date:   Wed, 24 Aug 2022 15:40:31 +0200
Message-Id: <20220824134055.1328882-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a function was trying to access data from context in a syscall eBPF
program, the verifier was rejecting the call unless it was accessing the
first element.
This is because the syscall context is not known at compile time, and
so we need to check this when actually accessing it.

Check for the valid memory access if there is no convert_ctx callback,
and allow such situation to happen.

There is a slight hiccup with subprogs. btf_check_subprog_arg_match()
will check that the types are matching, which is a good thing, but to
have an accurate result, it hides the fact that the context register may
be null. This makes env->prog->aux->max_ctx_offset being set to the size
of the context, which is incompatible with a NULL context.

Solve that last problem by storing max_ctx_offset before the type check
and restoring it after.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v9:
- rewrote the commit title and description
- made it so all functions can make use of context even if there is
  no convert_ctx
- remove the is_kfunc field in bpf_call_arg_meta

changes in v8:
- fixup comment
- return -EACCESS instead of -EINVAL for consistency

changes in v7:
- renamed access_t into atype
- allow zero-byte read
- check_mem_access() to the correct offset/size

new in v6
---
 kernel/bpf/btf.c      | 11 ++++++++++-
 kernel/bpf/verifier.c | 19 +++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 903719b89238..386300f52b23 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6443,8 +6443,8 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 {
 	struct bpf_prog *prog = env->prog;
 	struct btf *btf = prog->aux->btf;
+	u32 btf_id, max_ctx_offset;
 	bool is_global;
-	u32 btf_id;
 	int err;
 
 	if (!prog->aux->func_info)
@@ -6457,9 +6457,18 @@ int btf_check_subprog_arg_match(struct bpf_verifier_env *env, int subprog,
 	if (prog->aux->func_info_aux[subprog].unreliable)
 		return -EINVAL;
 
+	/* subprogs arguments are not actually accessing the data, we need
+	 * to check for the types if they match.
+	 * Store the max_ctx_offset and restore it after btf_check_func_arg_match()
+	 * given that this function will have a side effect of changing it.
+	 */
+	max_ctx_offset = env->prog->aux->max_ctx_offset;
+
 	is_global = prog->aux->func_info_aux[subprog].linkage == BTF_FUNC_GLOBAL;
 	err = btf_check_func_arg_match(env, btf, btf_id, regs, is_global, 0);
 
+	env->prog->aux->max_ctx_offset = max_ctx_offset;
+
 	/* Compiler optimizations can remove arguments from static functions
 	 * or mismatched type can be passed into a global function.
 	 * In such cases mark the function as unreliable from BTF point of view.
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2c1f8069f7b7..d694f43ab911 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5229,6 +5229,25 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				env,
 				regno, reg->off, access_size,
 				zero_size_allowed, ACCESS_HELPER, meta);
+	case PTR_TO_CTX:
+		/* in case the function doesn't know how to access the context,
+		 * (because we are in a program of type SYSCALL for example), we
+		 * can not statically check its size.
+		 * Dynamically check it now.
+		 */
+		if (!env->ops->convert_ctx_access) {
+			enum bpf_access_type atype = meta && meta->raw_mode ? BPF_WRITE : BPF_READ;
+			int offset = access_size - 1;
+
+			/* Allow zero-byte read from PTR_TO_CTX */
+			if (access_size == 0)
+				return zero_size_allowed ? 0 : -EACCES;
+
+			return check_mem_access(env, env->insn_idx, regno, offset, BPF_B,
+						atype, -1, false);
+		}
+
+		fallthrough;
 	default: /* scalar_value or invalid ptr */
 		/* Allow zero-byte read from NULL, regardless of pointer type */
 		if (zero_size_allowed && access_size == 0 &&
-- 
2.36.1

