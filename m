Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D9E571DA5
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbiGLPAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiGLO7V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:59:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E2505723D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657637959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgfSb7dECbTAHcInZBU6YqysYjB2PYG5wvQRH565Jew=;
        b=TJLL7qP0Ay2SZNHyqSkGpR/ZWL/RkG4QqhpaoSnEy8Zgr1qyCzxVr0Yfa+/egY3Y1kFVth
        GtVj+Jvrq1YD+T4suCa26iWM1P5DhXb5ZwhK9+6ph8lb+QNWHLwL6NYlYfx27gLAcs5E9H
        q0AhLUi2taH/OMqYeKHLsegDsGB2lGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-b6OaMCBnMBSFmByfnYzLkQ-1; Tue, 12 Jul 2022 10:59:09 -0400
X-MC-Unique: b6OaMCBnMBSFmByfnYzLkQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0FD831032964;
        Tue, 12 Jul 2022 14:59:08 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A423E2166B26;
        Tue, 12 Jul 2022 14:59:04 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v6 02/23] bpf/verifier: allow kfunc to read user provided context
Date:   Tue, 12 Jul 2022 16:58:29 +0200
Message-Id: <20220712145850.599666-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v6
---
 kernel/bpf/verifier.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 328cfab3af60..f6af57a84247 100644
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
@@ -5223,6 +5225,19 @@ static int check_helper_mem_access(struct bpf_verifier_env *env, int regno,
 				env,
 				regno, reg->off, access_size,
 				zero_size_allowed, ACCESS_HELPER, meta);
+	case PTR_TO_CTX:
+		/* in case of a kfunc called in a program of type SYSCALL, the context is
+		 * user supplied, so not computed statically.
+		 * Dynamically check it now
+		 */
+		if (prog_type == BPF_PROG_TYPE_SYSCALL && meta && meta->is_kfunc) {
+			enum bpf_access_type access_t = meta->raw_mode ? BPF_WRITE : BPF_READ;
+
+			return check_mem_access(env, env->insn_idx, regno, access_size, BPF_B,
+						access_t, -1, false);
+		}
+
+		fallthrough;
 	default: /* scalar_value or invalid ptr */
 		/* Allow zero-byte read from NULL, regardless of pointer type */
 		if (zero_size_allowed && access_size == 0 &&
@@ -5335,6 +5350,7 @@ int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state
 	WARN_ON_ONCE(regno < BPF_REG_2 || regno > BPF_REG_5);
 
 	memset(&meta, 0, sizeof(meta));
+	meta.is_kfunc = true;
 
 	if (may_be_null) {
 		saved_reg = *mem_reg;
-- 
2.36.1

