Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BDC52949E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 01:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349946AbiEPXFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 19:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350088AbiEPXFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 19:05:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B6BD45528
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 16:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652742304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=XWqMzw1NbrOQqMg0//tnmzedML/So/AECv/iAu4oGTQ=;
        b=L+wPXHwOFXgiEDa3aqcptV7+cw/maX8YgepA0+1/7zznJEAGZqZXXslqnvlt8aggGIR04N
        +4m13E3QWXPdxS5wpFvFmVqY9niqbdW+VGmi3nf9sXWxN6t6LnjMDBWuhlOIB96arPx8rY
        N71ujRSwwXsJiCRxnT3VnAglYWO6Fy8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-xoS2vbd9O0aNGqsh54rUhg-1; Mon, 16 May 2022 19:05:03 -0400
X-MC-Unique: xoS2vbd9O0aNGqsh54rUhg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0ED9185A7BA;
        Mon, 16 May 2022 23:05:02 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53B44568626;
        Mon, 16 May 2022 23:04:58 +0000 (UTC)
Date:   Tue, 17 May 2022 01:04:55 +0200
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
Subject: [PATCH bpf v2 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <20220516230455.GA25103@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that size would not overflow before calculation (and return
-EOVERFLOW if it will), to prevent potential out-of-bounds write
with the following copy_from_user.  Add the same check
to kprobe_multi_resolve_syms in case it will be called from elsewhere
in the future.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d8553f4..f1d4e68 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2352,12 +2352,15 @@ static int
 kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
 			  unsigned long *addrs)
 {
-	unsigned long addr, size;
+	unsigned long addr, sym_size;
+	u32 size;
 	const char __user **syms;
 	int err = -ENOMEM;
 	unsigned int i;
 	char *func;
 
+	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
+		return -EOVERFLOW;
 	size = cnt * sizeof(*syms);
 	syms = kvzalloc(size, GFP_KERNEL);
 	if (!syms)
@@ -2382,9 +2385,9 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
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
@@ -2429,6 +2432,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!cnt)
 		return -EINVAL;
 
+	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
+		return -EOVERFLOW;
 	size = cnt * sizeof(*addrs);
 	addrs = kvmalloc(size, GFP_KERNEL);
 	if (!addrs)
-- 
2.1.4

