Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0AF3529AFC
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbiEQHg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241573AbiEQHgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:36:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57DE6483B4
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652773009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pQ8Tbw3YXlfFnImshaS6CSiXIKXl6akxMQXuGl5HlAA=;
        b=B/K3rxSKLAWOCOGAEPVOGarsDYPHdOWGH9wWCWggXJ+mYYeeHaeqGanQtBo9opssR5rBCD
        WnnibalysQqDPxdXRI4ZdWhowtWrYD30BKWUh/DWmpQT4EWDz0REvP+D2r++18cb+Z1FSV
        zgYeUw7LDvfXj26YgPR2MInSlXa+2Ac=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-Mlcp5x2wPqa4VISOC-SGlw-1; Tue, 17 May 2022 03:36:44 -0400
X-MC-Unique: Mlcp5x2wPqa4VISOC-SGlw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 404C9101AA47;
        Tue, 17 May 2022 07:36:43 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 771137774;
        Tue, 17 May 2022 07:36:39 +0000 (UTC)
Date:   Tue, 17 May 2022 09:36:36 +0200
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
Subject: [PATCH bpf-next v3 3/4] bpf_trace: handle compat in copy_user_syms
Message-ID: <2a56d66cf4b9430982e81233f49d6c54988df056.1652772731.git.esyr@redhat.com>
References: <cover.1652772731.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652772731.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For compat processes, userspace size for syms pointers is different.
Provide compat handling for copying array elements from the user space.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index a93a54f..9d3028a 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2253,6 +2253,24 @@ struct user_syms {
 	char *buf;
 };
 
+static inline int get_arr_ptr(unsigned long *p,
+			      unsigned long __user *uaddr, u32 idx)
+{
+	if (unlikely(in_compat_syscall())) {
+		compat_uptr_t __user *compat_uaddr = (compat_uptr_t __user *)uaddr;
+		compat_uptr_t val;
+		int err;
+
+		err = __get_user(val, compat_uaddr + idx);
+		if (!err)
+			*p = val;
+
+		return err;
+	} else {
+		return __get_user(*p, uaddr + idx);
+	}
+}
+
 static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32 cnt)
 {
 	unsigned long __user usymbol;
@@ -2270,7 +2288,7 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
 		goto error;
 
 	for (p = buf, i = 0; i < cnt; i++) {
-		if (__get_user(usymbol, usyms + i)) {
+		if (get_arr_ptr(&usymbol, usyms, i)) {
 			err = -EFAULT;
 			goto error;
 		}
-- 
2.1.4

