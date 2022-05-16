Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 116945294A4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350162AbiEPXFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350213AbiEPXFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:05:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79A0846B24
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 16:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652742332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/PrpIF0lAA7w2fu9g8XdUbK+AXcZafepF1JXwFuF0QE=;
        b=i+/x2WeJBNUk0XJ8o/YB5y4FJkGq63DKo15SSpzRS6rCpKLL/nPRoq8RanqJ0NEpOL1KmU
        nGmrPM52BL11Zp7sb7fd7XBSIFB0pSJSIpZ5FgfPqpxV8C3jWsq0AzdHbtw8FuTl7NZB5K
        dO2uFvTQ7zJNcVKNoH5POzJuyCcXC/M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-442-ZlOt9hVaPm6IfjLVuzpThA-1; Mon, 16 May 2022 19:05:25 -0400
X-MC-Unique: ZlOt9hVaPm6IfjLVuzpThA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9BCC801210;
        Mon, 16 May 2022 23:05:24 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D83CF400E122;
        Mon, 16 May 2022 23:05:20 +0000 (UTC)
Date:   Tue, 17 May 2022 01:05:17 +0200
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
Subject: [PATCH bpf v2 3/4] bpf_trace: handle compat in
 kprobe_multi_resolve_syms
Message-ID: <20220516230517.GA25568@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
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
 kernel/trace/bpf_trace.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index bf5bcfb..268c92b 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2353,16 +2353,19 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 			  unsigned long *addrs)
 {
 	unsigned long addr, sym_size;
-	u32 size;
+	u32 size, elem_size;
 	const char __user **syms;
+	compat_uptr_t __user *compat_syms;
 	int err = -ENOMEM;
 	unsigned int i;
 	char *func;
 
-	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
+	elem_size = in_compat_syscall() ? sizeof(*compat_syms) : sizeof(*syms);
+	if (check_mul_overflow(cnt, elem_size, &size))
 		return -EOVERFLOW;
-	size = cnt * sizeof(*syms);
+	size = cnt * elem_size;
 	syms = kvzalloc(size, GFP_KERNEL);
+	compat_syms = (void *)syms;
 	if (!syms)
 		return -ENOMEM;
 
@@ -2376,7 +2379,10 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
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
-- 
2.1.4

