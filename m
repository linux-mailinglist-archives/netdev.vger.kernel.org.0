Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879C8528CED
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344837AbiEPS2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344832AbiEPS17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8001A3E0E5
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652725670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=CY4ff1BnqapePMK07WNltTRPHXz8albFraThTnxLBT4=;
        b=SDcRbH44w602mbPrGXIRyTYIkYpM5uJlT8D74FuPsmy8DbW8Z3E/LT2tYwDneuscAfmvpj
        V6+rpC036Xg3Xaaec02ikeS6rVPRAvc3/v7k9x6Eo6cs02EzSaCKOUuIfnB/fzRcOpJRLt
        NxMj75b9oVe+ANJU1OMEdoSoiZgtVd8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-30w22ZIzOYuu65uh1XF7Sw-1; Mon, 16 May 2022 14:27:47 -0400
X-MC-Unique: 30w22ZIzOYuu65uh1XF7Sw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EFAE100BAA0;
        Mon, 16 May 2022 18:27:46 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA1BD1121314;
        Mon, 16 May 2022 18:27:42 +0000 (UTC)
Date:   Mon, 16 May 2022 20:27:40 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 3/4] bpf_trace: handle compat in kprobe_multi_resolve_syms
Message-ID: <20220516182740.GA29979@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For compat processes, userspace pointer size is different.  Since the
copied array is iterated anyway, the simplest fix seems to be copy the
user-supplied array as-is and the iterate as an array of native or
compat pointers, depending on the in_compat_syscall() value.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d228440..5b0cf54 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2352,16 +2352,21 @@ static int
 kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 			  unsigned long *addrs)
 {
-	unsigned long addr, size;
+	unsigned long addr;
+	size_t sym_size;
+	u32 size, elem_size;
 	const char __user **syms;
+	compat_uptr_t __user *compat_syms;
 	int err = -ENOMEM;
 	unsigned int i;
 	char *func;
 
-	if (check_mul_overflow(cnt, sizeof(*syms), &size))
+	elem_size = in_compat_syscall() ? sizeof(*compat_syms) : sizeof(*syms);
+	if (check_mul_overflow(cnt, elem_size, &size))
 		return -EOVERFLOW;
-	size = cnt * sizeof(*syms);
+	size = cnt * elem_size;
 	syms = kvzalloc(size, GFP_KERNEL);
+	compat_syms = (void *)syms;
 	if (!syms)
 		return -ENOMEM;
 
@@ -2375,7 +2380,10 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 	}
 
 	for (i = 0; i < cnt; i++) {
-		err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
+		const char __user *ufunc = in_compat_syscall()
+					? (char __user *)(uintptr_t)compat_syms[i]
+					: syms[i];
+		err = strncpy_from_user(func, ufunc, KSYM_NAME_LEN);
 		if (err == KSYM_NAME_LEN)
 			err = -E2BIG;
 		if (err < 0)
@@ -2384,9 +2392,9 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 		addr = kallsyms_lookup_name(func);
 		if (!addr)
 			goto error;
-		if (!kallsyms_lookup_size_offset(addr, &size, NULL))
+		if (!kallsyms_lookup_size_offset(addr, &sym_size, NULL))
 			goto error;
-		addr = ftrace_location_range(addr, addr + size - 1);
+		addr = ftrace_location_range(addr, addr + sym_size - 1);
 		if (!addr)
 			goto error;
 		addrs[i] = addr;
-- 
2.1.4

