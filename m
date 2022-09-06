Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9255AEF8E
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 17:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbiIFPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbiIFPzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 11:55:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F198D3F5
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662477206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EN0gZ7KX3l2ofZoDtpWQPp8Bi3n6Z9ichaklbTKAD6Q=;
        b=b98na0FG/p/yenLDdco8oTAFGI3DVPYFgZXt5uCSxhN3rCE3fzDTGt3fBQIwBcoSOuDwEg
        Cm8CxXsXHKu1fbH4wpCh949iXsdPVk+bqtUdj+2GfJeiGa3oZ4HSfh6ekc/zGNc3i6ktS+
        5h9fEYJYoX5uPK0bafk322ftwvAaRyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-Efo7MM1UNLaxIWQUg9MRVA-1; Tue, 06 Sep 2022 11:13:21 -0400
X-MC-Unique: Efo7MM1UNLaxIWQUg9MRVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92252805B9A;
        Tue,  6 Sep 2022 15:13:20 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5801A40D296C;
        Tue,  6 Sep 2022 15:13:18 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v11 3/7] bpf/verifier: allow all functions to read user provided context
Date:   Tue,  6 Sep 2022 17:12:59 +0200
Message-Id: <20220906151303.2780789-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
References: <20220906151303.2780789-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

no changes in v11

changes in v10:
- dropped the hunk in btf.c saving/restoring max_ctx_offset

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
 kernel/bpf/verifier.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d27fae3ce949..3f9e6fa92cde 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5233,6 +5233,25 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
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

