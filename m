Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD1852BA9A
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbiERMWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiERMWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:22:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58FB695A17
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652876550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K/ITSQPv+FLUqNfqJZ10C1qnyJTCcwgFhb/0q95NHko=;
        b=gwCu77hQLbJ+sljVxa6nxIo7C2bCH8FKUEKrzmhUeIqQAXzziWvvbLTabFh+elowIhJBEe
        XDzJwwUQIUgxoe7aUW2B1rU6bBg84GwdKac/eXenPqIO+Mr7Gmv14+6tqiGe0a4ivGp227
        TI6v2uSnjIlKFDxQK079vgzyj2FRgGM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-xp3zU66eO3iCnVuiEJu30A-1; Wed, 18 May 2022 08:22:26 -0400
X-MC-Unique: xp3zU66eO3iCnVuiEJu30A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 794C38015BA;
        Wed, 18 May 2022 12:22:25 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 280CF40C1438;
        Wed, 18 May 2022 12:22:21 +0000 (UTC)
Date:   Wed, 18 May 2022 14:22:19 +0200
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
Subject: [PATCH bpf v3 1/2] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <39c4a91f2867684dc51c5395d26cb56ffe9d995d.1652876188.git.esyr@redhat.com>
References: <cover.1652876187.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652876187.git.esyr@redhat.com>
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

Check that size would not overflow before calculation (and return
-EOVERFLOW if it will), to prevent potential out-of-bounds write
with the following copy_from_user.  Add the same check
to kprobe_multi_resolve_syms in case it will be called from elsewhere
in the future.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d8553f4..212faa4 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2352,13 +2352,15 @@ static int
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
 
-	size = cnt * sizeof(*syms);
+	if (check_mul_overflow(cnt, (u32)sizeof(*syms), &size))
+		return -EOVERFLOW;
 	syms = kvzalloc(size, GFP_KERNEL);
 	if (!syms)
 		return -ENOMEM;
@@ -2382,9 +2384,9 @@ kprobe_multi_resolve_syms(const void __user *usyms, u32 cnt,
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
@@ -2429,7 +2431,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!cnt)
 		return -EINVAL;
 
-	size = cnt * sizeof(*addrs);
+	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
+		return -EOVERFLOW;
 	addrs = kvmalloc(size, GFP_KERNEL);
 	if (!addrs)
 		return -ENOMEM;
-- 
2.1.4

