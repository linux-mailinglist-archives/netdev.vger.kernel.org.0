Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B75852DC95
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243801AbiESSOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243797AbiESSOk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:14:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85BEFEBA80
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652984078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t16CR3RST/Ttm5em4stGqyXfCEBYjLXIn09fz9ExDas=;
        b=NAHZyTkd/MzSympXHYNUNqhlnBJgreqxgxbNjz982Jisn81R1037hNq676hlado9YcWBFy
        TmSHQxd6SAtnZD9XEAzH9P4G1WAcRs4sF3feigh6b4lqO1mZsec5SCUnVcGcovbtoFtO6m
        xpd8uh0tH9SH4I0+2DpTI2tS7wdSxf4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-d5Us7xPXOTCTvyu__BfIZg-1; Thu, 19 May 2022 14:14:34 -0400
X-MC-Unique: d5Us7xPXOTCTvyu__BfIZg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 862481C05193;
        Thu, 19 May 2022 18:14:33 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C570AC15E71;
        Thu, 19 May 2022 18:14:29 +0000 (UTC)
Date:   Thu, 19 May 2022 20:14:27 +0200
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
Subject: [PATCH bpf v4 3/3] libbpf, selftests/bpf: pass array of u64 values
 in kprobe_multi.addrs
Message-ID: <0f500d9a17dcc1270c581f0b722be8f9d7ce781d.1652982525.git.esyr@redhat.com>
References: <cover.1652982525.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1652982525.git.esyr@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the interface as defined, it is impossible to pass 64-bit kernel
addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
which severly limits the useability of the interface, change the API
to accept an array of u64 values instead of (kernel? user?) longs.
This patch implements the user space part of the change (without
the relevant kernel changes, since, as of now, an attempt to add
kprobe_multi link will fail with -EOPNOTSUPP), to avoid changing
the interface after a release.

Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
---
 tools/lib/bpf/bpf.h                                        | 2 +-
 tools/lib/bpf/libbpf.c                                     | 8 ++++----
 tools/lib/bpf/libbpf.h                                     | 2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c        | 2 +-
 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 8 ++++----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index f4b4afb..f677602 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -417,7 +417,7 @@ struct bpf_link_create_opts {
 			__u32 flags;
 			__u32 cnt;
 			const char **syms;
-			const unsigned long *addrs;
+			const __u64 *addrs;
 			const __u64 *cookies;
 		} kprobe_multi;
 	};
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 809fe20..03a14a6 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10279,7 +10279,7 @@ static bool glob_match(const char *str, const char *pat)
 
 struct kprobe_multi_resolve {
 	const char *pattern;
-	unsigned long *addrs;
+	__u64 *addrs;
 	size_t cap;
 	size_t cnt;
 };
@@ -10294,12 +10294,12 @@ resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
 	if (!glob_match(sym_name, res->pattern))
 		return 0;
 
-	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
+	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(__u64),
 				res->cnt + 1);
 	if (err)
 		return err;
 
-	res->addrs[res->cnt++] = (unsigned long) sym_addr;
+	res->addrs[res->cnt++] = sym_addr;
 	return 0;
 }
 
@@ -10314,7 +10314,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
 	};
 	struct bpf_link *link = NULL;
 	char errmsg[STRERR_BUFSIZE];
-	const unsigned long *addrs;
+	const __u64 *addrs;
 	int err, link_fd, prog_fd;
 	const __u64 *cookies;
 	const char **syms;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 05dde85..ec1cb61 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -431,7 +431,7 @@ struct bpf_kprobe_multi_opts {
 	/* array of function symbols to attach */
 	const char **syms;
 	/* array of function addresses to attach */
-	const unsigned long *addrs;
+	const __u64 *addrs;
 	/* array of user-provided values fetchable through bpf_get_attach_cookie */
 	const __u64 *cookies;
 	/* number of elements in syms/addrs/cookies arrays */
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index 923a613..5aa482a 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -137,7 +137,7 @@ static void kprobe_multi_link_api_subtest(void)
 	cookies[6] = 7;
 	cookies[7] = 8;
 
-	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
+	opts.kprobe_multi.addrs = (const __u64 *) &addrs;
 	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
 	opts.kprobe_multi.cookies = (const __u64 *) &cookies;
 	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index b9876b5..fbf4cf2 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -105,7 +105,7 @@ static void test_link_api_addrs(void)
 	GET_ADDR("bpf_fentry_test7", addrs[6]);
 	GET_ADDR("bpf_fentry_test8", addrs[7]);
 
-	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
+	opts.kprobe_multi.addrs = (const __u64 *) addrs;
 	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
 	test_link_api(&opts);
 }
@@ -183,7 +183,7 @@ static void test_attach_api_addrs(void)
 	GET_ADDR("bpf_fentry_test7", addrs[6]);
 	GET_ADDR("bpf_fentry_test8", addrs[7]);
 
-	opts.addrs = (const unsigned long *) addrs;
+	opts.addrs = (const __u64 *) addrs;
 	opts.cnt = ARRAY_SIZE(addrs);
 	test_attach_api(NULL, &opts);
 }
@@ -241,7 +241,7 @@ static void test_attach_api_fails(void)
 		goto cleanup;
 
 	/* fail_2 - both addrs and syms set */
-	opts.addrs = (const unsigned long *) addrs;
+	opts.addrs = (const __u64 *) addrs;
 	opts.syms = syms;
 	opts.cnt = ARRAY_SIZE(syms);
 	opts.cookies = NULL;
@@ -255,7 +255,7 @@ static void test_attach_api_fails(void)
 		goto cleanup;
 
 	/* fail_3 - pattern and addrs set */
-	opts.addrs = (const unsigned long *) addrs;
+	opts.addrs = (const __u64 *) addrs;
 	opts.syms = NULL;
 	opts.cnt = ARRAY_SIZE(syms);
 	opts.cookies = NULL;
-- 
2.1.4

