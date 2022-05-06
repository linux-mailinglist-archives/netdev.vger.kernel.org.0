Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175A451DA6F
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 16:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442172AbiEFOZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 10:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442038AbiEFOZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 10:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FA2E5A2C5
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 07:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651846919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=UoCumu7o9BabMe8Pn9KhSl2Wbtdkabdo24tDb7pIRwo=;
        b=YIKW/loTikmL4cVSq1wMYfZcEmnVjVHHy3JOXu7LELW/hiyauDI71Z1TG/jMCm+zfxPe/U
        4rRlngi+2H2WtCGSEjTJhM9YDyJXKGr6OJqPFTcNWzMZT6cgg3U4Che2IOmbwUGQkgx2DQ
        FrGl2AUJob4AlQhB3Vx556HlKMWcrmM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-418-S3f8mc3qO0CPQdTezQ4b5A-1; Fri, 06 May 2022 10:21:55 -0400
X-MC-Unique: S3f8mc3qO0CPQdTezQ4b5A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B46C4185A794;
        Fri,  6 May 2022 14:21:54 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E1A940314B;
        Fri,  6 May 2022 14:21:51 +0000 (UTC)
Date:   Fri, 6 May 2022 16:21:48 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf] bpf_trace: bail out from bpf_kprobe_multi_link_attach
 when in compat
Message-ID: <20220506142148.GA24802@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d8553f4..9560af6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2410,7 +2410,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	int err;
 
 	/* no support for 32bit archs yet */
-	if (sizeof(u64) != sizeof(void *))
+	if (sizeof(u64) != sizeof(void *) || in_compat_syscall())
 		return -EOPNOTSUPP;
 
 	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
-- 
2.1.4

