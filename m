Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B8752BA96
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236502AbiERMWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbiERMWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4799013F1E1
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652876561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MlM2AUQc/4YaS8YQ+3153zXGMb60UOH0oHzcHsTkB/k=;
        b=QqJStpI4kMr2yObFurxqvdUw/hBas3uCRxtAc9cwoXqPxyKoB/A5YhzE/C3SlecVptR0Pu
        g3O4cE7lUK+r39t1Y9dXbb5gHjywGHMapBgiyIp+9XVrwjbhWyso56jnSbgAAKKrUQ8rKS
        N1oG3jRJtQiJd5QKXJAr/maYUb+C0Kk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-rBBidYBlPCKRs_9PNwSsAw-1; Wed, 18 May 2022 08:22:38 -0400
X-MC-Unique: rBBidYBlPCKRs_9PNwSsAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C6271C01B24;
        Wed, 18 May 2022 12:22:37 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AC8F2166B40;
        Wed, 18 May 2022 12:22:34 +0000 (UTC)
Date:   Wed, 18 May 2022 14:22:31 +0200
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
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf v3 2/2] bpf_trace: bail out from
 bpf_kprobe_multi_link_attach when in compat
Message-ID: <47cbdb76178a112763a3766a03d8cc51842fcab0.1652876188.git.esyr@redhat.com>
References: <cover.1652876187.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652876187.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 212faa4..2f83489 100644
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

