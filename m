Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D229627C143
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 11:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgI2Jbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 05:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbgI2JbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 05:31:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BB63C0613D1
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 02:31:14 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id k18so4040346wmj.5
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 02:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YMC53wjAecyfQSgyYtJfzRQQFrJ1VKu1cXscoS4ApIg=;
        b=tWoRTVisUgP1ckiKLUkup+xCM00Ez0PcUOmdR1SJhxtrKfdWyc0haa6xSaNE8DCQtU
         A6mSXNR4kZaS0ZXnEVyJWd8ovvIQTd8fXwrSh3iBfLLi39Pi/ME8Y0n0SDkupWTdw5cW
         OCBm4bCkjWt3Mwgv6kmmrye0E1+wdwgB0LNbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YMC53wjAecyfQSgyYtJfzRQQFrJ1VKu1cXscoS4ApIg=;
        b=Jx1R+7/ALRTxunQsx3YkCIPPl6CO9SZhS9sdCy4VVc4M5oQG01IEWuMCF57FmVx7op
         O+MBIZarwDIy7Mhh8AUK9Biqp0GJYcUrTZFFJTygGaK1HremDtNQ2aZN1DqtjVmF2LNe
         KobtlZASAF29XietHwWrYYYH4TBUiEES1mf0X++oJkui//sg9uBtUA3zEe8FMtlFYzfD
         S3kT1/sr0FgUEqxDiqigDaHK/Pq3SnfQQvIGgNRreqPsnyg1Nmmr12TOj2iDVYUrpMbB
         Jc1i75yddtQkSZyTqwblyQVDsIMgui2N2tsloZNSc7kvlZwXwOHs2fyfwOeKzPpTmT+R
         ICsA==
X-Gm-Message-State: AOAM530ThM+A3rleS9XS6GzAD4/FvxeOVK0G+nl2Y73vhLC/zeZWjARq
        G/Ia4ADQRP+cXuCbY7eHHScWBg==
X-Google-Smtp-Source: ABdhPJwuUNLZWqnkIYJEydinSUNuZES0TsyLsuyBrJHY2m6+lymw1UCXmR/xrvpaKiuBllPdsQEMSA==
X-Received: by 2002:a7b:c848:: with SMTP id c8mr3336277wml.184.1601371872926;
        Tue, 29 Sep 2020 02:31:12 -0700 (PDT)
Received: from antares.lan (1.f.1.6.a.e.6.5.a.0.3.2.4.7.4.0.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:474:230a:56ea:61f1])
        by smtp.gmail.com with ESMTPSA id i16sm5246798wrq.73.2020.09.29.02.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 02:31:12 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     kafai@fb.com, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 4/4] selftest: bpf: Test copying a sockmap and sockhash
Date:   Tue, 29 Sep 2020 10:30:39 +0100
Message-Id: <20200929093039.73872-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929093039.73872-1-lmb@cloudflare.com>
References: <20200929093039.73872-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we can now call map_update_elem(sockmap) from bpf_iter context
it's possible to copy a sockmap or sockhash in the kernel. Add a
selftest which exercises this.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 14 +++++-----
 .../selftests/bpf/progs/bpf_iter_sockmap.c    | 27 +++++++++++++++----
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 316c4e271b36..4c4224e3e10a 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -194,7 +194,7 @@ static void test_sockmap_invalid_update(void)
 		test_sockmap_invalid_update__destroy(skel);
 }
 
-static void test_sockmap_iter(enum bpf_map_type map_type)
+static void test_sockmap_copy(enum bpf_map_type map_type)
 {
 	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
 	int err, len, src_fd, iter_fd, duration = 0;
@@ -242,7 +242,7 @@ static void test_sockmap_iter(enum bpf_map_type map_type)
 	linfo.map.map_fd = src_fd;
 	opts.link_info = &linfo;
 	opts.link_info_len = sizeof(linfo);
-	link = bpf_program__attach_iter(skel->progs.count_elems, &opts);
+	link = bpf_program__attach_iter(skel->progs.copy, &opts);
 	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
 		goto out;
 
@@ -265,6 +265,8 @@ static void test_sockmap_iter(enum bpf_map_type map_type)
 		  skel->bss->socks, num_sockets))
 		goto close_iter;
 
+	compare_cookies(src, skel->maps.dst);
+
 close_iter:
 	close(iter_fd);
 free_link:
@@ -294,8 +296,8 @@ void test_sockmap_basic(void)
 		test_sockmap_update(BPF_MAP_TYPE_SOCKHASH);
 	if (test__start_subtest("sockmap update in unsafe context"))
 		test_sockmap_invalid_update();
-	if (test__start_subtest("sockmap iter"))
-		test_sockmap_iter(BPF_MAP_TYPE_SOCKMAP);
-	if (test__start_subtest("sockhash iter"))
-		test_sockmap_iter(BPF_MAP_TYPE_SOCKHASH);
+	if (test__start_subtest("sockmap copy"))
+		test_sockmap_copy(BPF_MAP_TYPE_SOCKMAP);
+	if (test__start_subtest("sockhash copy"))
+		test_sockmap_copy(BPF_MAP_TYPE_SOCKHASH);
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c b/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
index 1af7555f6057..f3af0e30cead 100644
--- a/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
@@ -22,21 +22,38 @@ struct {
 	__type(value, __u64);
 } sockhash SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKHASH);
+	__uint(max_entries, 64);
+	__type(key, __u32);
+	__type(value, __u64);
+} dst SEC(".maps");
+
 __u32 elems = 0;
 __u32 socks = 0;
 
 SEC("iter/sockmap")
-int count_elems(struct bpf_iter__sockmap *ctx)
+int copy(struct bpf_iter__sockmap *ctx)
 {
 	struct sock *sk = ctx->sk;
 	__u32 tmp, *key = ctx->key;
 	int ret;
 
-	if (key)
-		elems++;
+	if (!key)
+		return 0;
 
-	if (sk)
+	elems++;
+
+	/* We need a temporary buffer on the stack, since the verifier doesn't
+	 * let us use the pointer from the context as an argument to the helper.
+	 */
+	tmp = *key;
+
+	if (sk) {
 		socks++;
+		return bpf_map_update_elem(&dst, &tmp, sk, 0) != 0;
+	}
 
-	return 0;
+	ret = bpf_map_delete_elem(&dst, &tmp);
+	return ret && ret != -ENOENT;
 }
-- 
2.25.1

