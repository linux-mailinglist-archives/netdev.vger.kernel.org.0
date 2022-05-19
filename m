Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20052DC8D
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243771AbiESSOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243761AbiESSOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:14:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24FE1EAD18
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652984068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APqUIin6Y27hz4aeXKXWWeszK1zKqlCv5JpzZj++478=;
        b=fg8m+PaUj2REkFF9csnYwUJmAg0mCYQ5/0F42sVUv93xNhNrZY973BQPtgMsyiUVn9JyVL
        vrVeH6QdLBXglpVfTNPUsfjar/pBKO7J87oeymm9osk/lArPdhedXXb6G+tNB6jHY5lcIB
        PnmRmRKnTB2mV7t/CI0Ki8xk+gZ4HoU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-He52BFksPoe7G484-ZCqbA-1; Thu, 19 May 2022 14:14:24 -0400
X-MC-Unique: He52BFksPoe7G484-ZCqbA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A227294EDE6;
        Thu, 19 May 2022 18:14:23 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CCB822166B25;
        Thu, 19 May 2022 18:14:19 +0000 (UTC)
Date:   Thu, 19 May 2022 20:14:17 +0200
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
Subject: [PATCH bpf v4 2/3] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Message-ID: <f617d4d10690af09968af6f829e923a1a61c8545.1652982525.git.esyr@redhat.com>
References: <cover.1652982525.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652982525.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since bpf_kprobe_multi_link_attach doesn't support 32-bit kernels
for whatever reason, having it enabled for compat processes on 64-bit
kernels makes even less sense due to discrepances in the type sizes
that it does not handle.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 26cf99c..d6db124 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2412,7 +2412,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	int err;
 
 	/* no support for 32bit archs yet */
-	if (sizeof(u64) != sizeof(void *))
+	if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
 		return -EOPNOTSUPP;
 
 	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
-- 
2.1.4

