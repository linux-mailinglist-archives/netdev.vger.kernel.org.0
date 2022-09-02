Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92975AB283
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 15:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbiIBN73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238274AbiIBN6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:58:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B5CEEC4F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmXuOjUugSdvFfhnfCLRZhRw10ucC5QWiKjJxW2knIY=;
        b=Xls7jcAxXaiF+S2Kliiw4/lY/nJkmRwHWeASanDiB16QVh9D580uyIr2EIv9iQtGe6MAYf
        C8MTw+9pmyNpOHQlDOgUJQTYTF0OEsnnSFx+EXYJ4pB2fB2s/fl1sq1LRNaQjksOr/xfe2
        2KkwBQOQO78Tz7nSKq9c06L0Xm6fHoc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-C2v1YD0hOziZ3XJ_0yDWmA-1; Fri, 02 Sep 2022 09:29:56 -0400
X-MC-Unique: C2v1YD0hOziZ3XJ_0yDWmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6B63C0F37B;
        Fri,  2 Sep 2022 13:29:55 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BEDC492C3B;
        Fri,  2 Sep 2022 13:29:51 +0000 (UTC)
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
Subject: [PATCH bpf-next v10 03/23] bpf/verifier: allow all functions to read user provided context
Date:   Fri,  2 Sep 2022 15:29:18 +0200
Message-Id: <20220902132938.2409206-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
References: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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

