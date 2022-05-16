Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F88528CE7
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 20:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344796AbiEPS1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 14:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344781AbiEPS1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 14:27:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B7143DDCC
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 11:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652725658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=i9tbH4DATFTVHTVKDZDsmCN1LCos1kVSdRdRXbhuGME=;
        b=dKqZXW0UTK9vn059vjLbQdZ3ieXnOVO+qdEb9fQFjcp8JI4xOd2GEwSShQQqk2o2PsF3PL
        ahUgkbdhpr7dmlHb34zHfUBx6xG5Xi0plhflFzXH4unOM2RdNnkhz+Q9LTV13Cb5pnbYLc
        UygGCEePaXL3jnt/HuEWKbNGeOreKug=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-gLZIfmtbMiOoh8UQfzAPbw-1; Mon, 16 May 2022 14:27:35 -0400
X-MC-Unique: gLZIfmtbMiOoh8UQfzAPbw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BB953C6053D;
        Mon, 16 May 2022 18:27:34 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DD3F153B8B8;
        Mon, 16 May 2022 18:27:29 +0000 (UTC)
Date:   Mon, 16 May 2022 20:27:27 +0200
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
Subject: [PATCH bpf 2/4] bpf_trace: support 32-bit kernels in
 bpf_kprobe_multi_link_attach
Message-ID: <20220516182727.GA29647@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that there is no reason not to support 32-bit architectures;
doing so requires a bit of rework with respect to cookies handling,
however, as the current code implicitly assumes
that sizeof(long) == sizeof(u64).

Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 kernel/trace/bpf_trace.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e90c4ce7..d228440 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2405,16 +2405,12 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	struct bpf_link_primer link_primer;
 	void __user *ucookies;
 	unsigned long *addrs;
-	u32 flags, cnt, size;
+	u32 flags, cnt, size, cookies_size;
 	void __user *uaddrs;
 	u64 *cookies = NULL;
 	void __user *usyms;
 	int err;
 
-	/* no support for 32bit archs yet */
-	if (sizeof(u64) != sizeof(void *))
-		return -EOPNOTSUPP;
-
 	if (prog->expected_attach_type != BPF_TRACE_KPROBE_MULTI)
 		return -EINVAL;
 
@@ -2424,6 +2420,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 
 	uaddrs = u64_to_user_ptr(attr->link_create.kprobe_multi.addrs);
 	usyms = u64_to_user_ptr(attr->link_create.kprobe_multi.syms);
+	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
 	if (!!uaddrs == !!usyms)
 		return -EINVAL;
 
@@ -2431,8 +2428,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	if (!cnt)
 		return -EINVAL;
 
-	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size))
+	if (check_mul_overflow(cnt, (u32)sizeof(*addrs), &size) ||
+	    (ucookies &&
+	     check_mul_overflow(cnt, (u32)sizeof(*cookies), &cookies_size))) {
 		return -EOVERFLOW;
+	}
 	size = cnt * sizeof(*addrs);
 	addrs = kvmalloc(size, GFP_KERNEL);
 	if (!addrs)
@@ -2449,14 +2449,14 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 			goto error;
 	}
 
-	ucookies = u64_to_user_ptr(attr->link_create.kprobe_multi.cookies);
 	if (ucookies) {
-		cookies = kvmalloc(size, GFP_KERNEL);
+		cookies_size = cnt * sizeof(*cookies);
+		cookies = kvmalloc(cookies_size, GFP_KERNEL);
 		if (!cookies) {
 			err = -ENOMEM;
 			goto error;
 		}
-		if (copy_from_user(cookies, ucookies, size)) {
+		if (copy_from_user(cookies, ucookies, cookies_size)) {
 			err = -EFAULT;
 			goto error;
 		}
-- 
2.1.4

