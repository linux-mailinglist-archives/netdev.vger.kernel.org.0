Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B5D529AFB
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbiEQHgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242301AbiEQHgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:36:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B64A103F
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652772988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0xxKQ63UkLF4342r+f5JL5hPNHBH+mdnNusP1wdNqn8=;
        b=JWd1b9JhVLeF+EN/M/Gj86cj8FgH9Sb800ktsSHV2tFOHdgfcDZel8eOG/0lNcyvfOAPqm
        8hrf4mWxJWWieDZ7v1HzWaP/xuapF4Cuk6T+JzihwZaNcS52iYbRsvKCKMSzkJ6ihkIaiG
        fXjlq0e3AHaZz6A8ikloUMe49bF1MDQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-rN0cl44rNQqwRZrePtyRQg-1; Tue, 17 May 2022 03:36:22 -0400
X-MC-Unique: rN0cl44rNQqwRZrePtyRQg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9A19299E75D;
        Tue, 17 May 2022 07:36:21 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0443E5739A1;
        Tue, 17 May 2022 07:36:17 +0000 (UTC)
Date:   Tue, 17 May 2022 09:36:15 +0200
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
Subject: [PATCH bpf-next v3 1/4] bpf_trace: check size for overflow in
 bpf_kprobe_multi_link_attach
Message-ID: <9e4171972a3d75e656073e0c25cd4071a6f652e4.1652772731.git.esyr@redhat.com>
References: <cover.1652772731.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652772731.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
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
with the following copy_from_user.  Use kvmalloc_array
in copy_user_syms to prevent out-of-bounds write into syms
(and especially buf) as well.

Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
Cc: <stable@vger.kernel.org> # 5.18
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 7141ca8..9c041be 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2261,11 +2261,11 @@ static int copy_user_syms(struct user_syms *us, unsigned long __user *usyms, u32
 	int err = -ENOMEM;
 	unsigned int i;
 
-	syms = kvmalloc(cnt * sizeof(*syms), GFP_KERNEL);
+	syms = kvmalloc_array(cnt, sizeof(*syms), GFP_KERNEL);
 	if (!syms)
 		goto error;
 
-	buf = kvmalloc(cnt * KSYM_NAME_LEN, GFP_KERNEL);
+	buf = kvmalloc_array(cnt, KSYM_NAME_LEN, GFP_KERNEL);
 	if (!buf)
 		goto error;
 
@@ -2461,7 +2461,8 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
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

