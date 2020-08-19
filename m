Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B77B24997F
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgHSJib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgHSJh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 05:37:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B133C061344
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r15so10897013wrp.13
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 02:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FDpi2QIDOUNs+oTRdf9VTGQOJTmQUxGd6EEehSUSOqc=;
        b=rBXwlDqmQW2mi1eDwy4yCmDy+M/G0KgX4nrRLieMNgsDNPMtj48MeMupJpAkXcSfmW
         UE6FXBfkK6LLbyyWSoydJcxOERfic38uXyWnijiDTbbfTCAqZ48Hex2oF7ewCoviuE08
         57gSGtLv9G0fKd7/xffCssHOyLaPVJTw9/o00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FDpi2QIDOUNs+oTRdf9VTGQOJTmQUxGd6EEehSUSOqc=;
        b=h+Ir4YVs3vRMQtdZyd4WCpfWQjF/OCPSpeerT5sXcBLoqcHinJe9g7EV4jIa9s18Tv
         R5FT3PuZ/JCe1pI5wLMStLyNtClYPs0sE046WEnHB4KBQeJMZ8xTM8/ISJZEsvtduMwu
         zEBKS7f0n8yOas0F1SOAXN006qM/Or0oJ91O2hFs6cgQbi51wd+VbLDIIfwrgq9yB4kG
         Bh8RjCK/SvPYWYGk9VgsRzNlfJ37aF6KOJCBbTwpXeirbIo8C2+mGyAPuLQNQlxUBIie
         NudxpCluyBTzxIw27c9B3V1GpEnJPfCQXVMzHEuSce0xlq5hYOGnOgrQnVrK+ojaVWf/
         1HmA==
X-Gm-Message-State: AOAM530N6ueilX7Op4lbzUHuOC5vN6HBHE/ztiJI1nc4OoZ1na4pgB5E
        HeRrz00i7VOW8B1nVLC5PknauQ==
X-Google-Smtp-Source: ABdhPJzJ5o5wV5OdLa3eRVHCRMu61AKEaX+ywMO2j7xpboPjL0u2x/kdvZgCLds8X1cMmb4o0Mr4Sg==
X-Received: by 2002:adf:9526:: with SMTP id 35mr25432425wrs.326.1597829874068;
        Wed, 19 Aug 2020 02:37:54 -0700 (PDT)
Received: from antares.lan (c.d.0.4.4.2.3.3.e.9.1.6.6.d.0.6.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:60d6:619e:3324:40dc])
        by smtp.gmail.com with ESMTPSA id 3sm4204565wms.36.2020.08.19.02.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 02:37:53 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     jakub@cloudflare.com, john.fastabend@gmail.com,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 6/6] selftests: bpf: test sockmap update from BPF
Date:   Wed, 19 Aug 2020 10:24:36 +0100
Message-Id: <20200819092436.58232-7-lmb@cloudflare.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819092436.58232-1-lmb@cloudflare.com>
References: <20200819092436.58232-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test which copies a socket from a sockmap into another sockmap
or sockhash. This excercises bpf_map_update_elem support from BPF
context. Compare the socket cookies from source and destination to
ensure that the copy succeeded.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 76 +++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_copy.c   | 48 ++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_copy.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 96e7b7f84c65..d30cabc00e9e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -4,6 +4,7 @@
 
 #include "test_progs.h"
 #include "test_skmsg_load_helpers.skel.h"
+#include "test_sockmap_copy.skel.h"
 
 #define TCP_REPAIR		19	/* TCP sock is under repair right now */
 
@@ -101,6 +102,77 @@ static void test_skmsg_helpers(enum bpf_map_type map_type)
 	test_skmsg_load_helpers__destroy(skel);
 }
 
+static void test_sockmap_copy(enum bpf_map_type map_type)
+{
+	struct bpf_prog_test_run_attr attr;
+	struct test_sockmap_copy *skel;
+	__u64 src_cookie, dst_cookie;
+	int err, prog, s, src, dst;
+	const __u32 zero = 0;
+	char dummy[14] = {0};
+
+	s = connected_socket_v4();
+	if (CHECK_FAIL(s == -1))
+		return;
+
+	skel = test_sockmap_copy__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		close(s);
+		perror("test_sockmap_copy__open_and_load");
+		return;
+	}
+
+	prog = bpf_program__fd(skel->progs.copy_sock_map);
+	src = bpf_map__fd(skel->maps.src);
+	if (map_type == BPF_MAP_TYPE_SOCKMAP)
+		dst = bpf_map__fd(skel->maps.dst_sock_map);
+	else
+		dst = bpf_map__fd(skel->maps.dst_sock_hash);
+
+	err = bpf_map_update_elem(src, &zero, &s, BPF_NOEXIST);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_update");
+		goto out;
+	}
+
+	err = bpf_map_lookup_elem(src, &zero, &src_cookie);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_lookup_elem(src)");
+		goto out;
+	}
+
+	attr = (struct bpf_prog_test_run_attr){
+		.prog_fd = prog,
+		.repeat = 1,
+		.data_in = dummy,
+		.data_size_in = sizeof(dummy),
+	};
+
+	err = bpf_prog_test_run_xattr(&attr);
+	if (err) {
+		test__fail();
+		perror("bpf_prog_test_run");
+		goto out;
+	} else if (!attr.retval) {
+		PRINT_FAIL("bpf_prog_test_run: program returned %u\n",
+			   attr.retval);
+		goto out;
+	}
+
+	err = bpf_map_lookup_elem(dst, &zero, &dst_cookie);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_lookup_elem(dst)");
+		goto out;
+	}
+
+	if (dst_cookie != src_cookie)
+		PRINT_FAIL("cookie %llu != %llu\n", dst_cookie, src_cookie);
+
+out:
+	close(s);
+	test_sockmap_copy__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -111,4 +183,8 @@ void test_sockmap_basic(void)
 		test_skmsg_helpers(BPF_MAP_TYPE_SOCKMAP);
 	if (test__start_subtest("sockhash sk_msg load helpers"))
 		test_skmsg_helpers(BPF_MAP_TYPE_SOCKHASH);
+	if (test__start_subtest("sockmap copy"))
+		test_sockmap_copy(BPF_MAP_TYPE_SOCKMAP);
+	if (test__start_subtest("sockhash copy"))
+		test_sockmap_copy(BPF_MAP_TYPE_SOCKHASH);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_copy.c b/tools/testing/selftests/bpf/progs/test_sockmap_copy.c
new file mode 100644
index 000000000000..9d0c9f28cab2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_copy.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Cloudflare
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} src SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} dst_sock_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKHASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u64);
+} dst_sock_hash SEC(".maps");
+
+SEC("classifier/copy_sock_map")
+int copy_sock_map(void *ctx)
+{
+	struct bpf_sock *sk;
+	bool failed = false;
+	__u32 key = 0;
+
+	sk = bpf_map_lookup_elem(&src, &key);
+	if (!sk)
+		return SK_DROP;
+
+	if (bpf_map_update_elem(&dst_sock_map, &key, sk, 0))
+		failed = true;
+
+	if (bpf_map_update_elem(&dst_sock_hash, &key, sk, 0))
+		failed = true;
+
+	bpf_sk_release(sk);
+	return failed ? SK_DROP : SK_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.25.1

