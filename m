Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD057DCC0
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiGVIqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiGVIqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:46:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 880599FE36
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 01:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658479567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RSXimuUd+71j8JzSdjJ27yBRxj8T4NPAJaqSzLdyIx8=;
        b=YRTE23413sJ1NgvWddh00IIzEoJcyRhHvQ6mzWlD+X0a+Oa7/A1LJs9lBvJG+y9P1lcmUl
        v6YhEUGMIxTcmwWg667YKdyYyv3PudlQchYvZpaJQau/532QNAYHOt1T3aTJZDZ2IeRe2F
        7cmmmoh2CzV3Bdhf6d/QNo0MUs1/u+c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-QBEJYLHdNXuKeJd-ALmdnQ-1; Fri, 22 Jul 2022 04:46:03 -0400
X-MC-Unique: QBEJYLHdNXuKeJd-ALmdnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B101A3C1014E;
        Fri, 22 Jul 2022 08:46:02 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 420A340CFD0A;
        Fri, 22 Jul 2022 08:45:59 +0000 (UTC)
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
Subject: [PATCH bpf-next v8 02/24] bpf/verifier: allow kfunc to read user provided context
Date:   Fri, 22 Jul 2022 10:45:56 +0200
Message-Id: <20220722084556.1342406-1-benjamin.tissoires@redhat.com>
In-Reply-To: <20220721153625.1282007-3-benjamin.tissoires@redhat.com>
References: <20220721153625.1282007-3-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a kfunc was trying to access data from context in a syscall eBPF
program, the verifier was rejecting the call.
This is because the syscall context is not known at compile time, and
so we need to check this when actually accessing it.

Check for the valid memory access and allow such situation to happen.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

changes in v8:
- fixup comment
- return -EACCESS instead of -EINVAL for consistency

changes in v7:
- renamed access_t into atype
- allow zero-byte read
- check_mem_access() to the correct offset/size

new in v6
---
 kernel/bpf/verifier.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7c1e056624f9..c807c5d7085a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -248,6 +248,7 @@ struct bpf_call_arg_meta {
 	struct bpf_map *map_ptr;
 	bool raw_mode;
 	bool pkt_access;
+	bool is_kfunc;
 	u8 release_regno;
 	int regno;
 	int access_size;
@@ -5170,6 +5171,7 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				   struct bpf_call_arg_meta *meta)
 {
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
+	enum bpf_prog_type prog_type = resolve_prog_type(env->prog);
 	u32 *max_access;
 
 	switch (base_type(reg->type)) {
@@ -5223,6 +5225,24 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				env,
 				regno, reg->off, access_size,
 				zero_size_allowed, ACCESS_HELPER, meta);
+	case PTR_TO_CTX:
+		/* in case of a kfunc called in a program of type SYSCALL, the context is
+		 * user supplied, so not computed statically.
+		 * Dynamically check it now
+		 */
+		if (prog_type == BPF_PROG_TYPE_SYSCALL && meta && meta->is_kfunc) {
+			enum bpf_access_type atype = meta->raw_mode ? BPF_WRITE : BPF_READ;
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
@@ -5335,6 +5355,7 @@ int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state
 	WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
 
 	memset(&meta, 0, sizeof(meta));
+	meta.is_kfunc = true;
 
 	if (may_be_null) {
 		saved_reg = *mem_reg;
-- 
2.36.1

