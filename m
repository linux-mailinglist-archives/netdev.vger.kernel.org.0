Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEA9B270DC1
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 13:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgISLuF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 07:50:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726400AbgISLuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 07:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600516198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=utfMK0fpz+Di6YKgONWOEtGJeoQeNvRbM0wd8gaCZ8U=;
        b=hPgDz2pyoVrfz2ows2uk9+c7x0NIrespsxXz5YR46cGecbzU0ZmSYPWxW942VVNoD7/OGB
        b6B7f7OyFyxOdV3Q2A0AJ2IqcTUfdhQT0AZuFI1FYfX0x8IK3evnutBfxEbaWnCnNjrhFv
        ddXuAXZ+IVFDbTL6CMo4YbEplYQwpHM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-1S3kOP7RM-GBM1t67bnsYg-1; Sat, 19 Sep 2020 07:49:57 -0400
X-MC-Unique: 1S3kOP7RM-GBM1t67bnsYg-1
Received: by mail-ej1-f70.google.com with SMTP id dc22so3121249ejb.21
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 04:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=utfMK0fpz+Di6YKgONWOEtGJeoQeNvRbM0wd8gaCZ8U=;
        b=Gc/P7DLhw2NfVt6q3bLubBwXvZiTacfg/6L9LwB0P7ynXRa8jnTFZerloGHuRglzET
         ftgPvug7pIoqVj5T/Z2Koj0oNZxXxpe+74wQukg/maTbYs+Aa3RDxFYSY8/hzH5KUGI8
         OjMyWwD5yVTbRdQOVBt1eGI6SM6yyVL4l6AyRtaFiuJQVwnOOsmmRj/Y6PgRQ9C6XGYf
         gozS0hEswmURpKEfDDg09l8SWlYuJ590InCxjrqzvSMLZF/y9ObcK+X/HtSCvGzk0CsC
         K6MGdbOVA8YlCTZAYZKNr+gBzo04TXBmDF7GEExSmZ4xOb/9VLAG7UmyEkGoQ1BiWdvo
         ICqw==
X-Gm-Message-State: AOAM531TmZPE5lMlzmikeYXhZ57FEI81IFDTGcha1Pop3WaSNha3S58k
        w642dpNCEuApD0KLoNlYHslXPAnLgLPS/lhlEfBg2rfQ0KdNKyu1i2dga0AVLpzfAU6bK+jMOub
        dI0FA7KfTJf3KTvt8
X-Received: by 2002:a17:906:7248:: with SMTP id n8mr40167571ejk.160.1600516195311;
        Sat, 19 Sep 2020 04:49:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwET4wLasS4GyN4HhrrhJC65BBFerQhuAVWgNzLqhJ7YH2ZyMXgBmViYW56KvvkEBeUQAEFFQ==
X-Received: by 2002:a17:906:7248:: with SMTP id n8mr40167551ejk.160.1600516194925;
        Sat, 19 Sep 2020 04:49:54 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z23sm4271334eja.29.2020.09.19.04.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 04:49:54 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0E336183A98; Sat, 19 Sep 2020 13:49:54 +0200 (CEST)
Subject: [PATCH bpf-next v7 10/10] selftests: Add selftest for disallowing
 modify_return attachment to freplace
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 19 Sep 2020 13:49:54 +0200
Message-ID: <160051619397.58048.16822043567956571063.stgit@toke.dk>
In-Reply-To: <160051618267.58048.2336966160671014012.stgit@toke.dk>
References: <160051618267.58048.2336966160671014012.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds a selftest that ensures that modify_return tracing programs
cannot be attached to freplace programs. The security_ prefix is added to
the freplace program because that would otherwise let it pass the check for
modify_return.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   68 ++++++++++++++++++++
 .../selftests/bpf/progs/fmod_ret_freplace.c        |   14 ++++
 .../selftests/bpf/progs/freplace_get_constant.c    |    2 -
 3 files changed, 83 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 27677e015730..6339d125ef9a 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -233,6 +233,72 @@ static void test_func_replace_multi(void)
 				  prog_name, true, test_second_attach);
 }
 
+static void test_fmod_ret_freplace(void)
+{
+	const char *tgt_name = "./test_pkt_access.o";
+	const char *freplace_name = "./freplace_get_constant.o";
+	const char *fmod_ret_name = "./fmod_ret_freplace.o";
+	struct bpf_link *freplace_link = NULL, *fmod_link = NULL;
+	struct bpf_object *freplace_obj = NULL, *pkt_obj, *fmod_obj = NULL;
+	struct bpf_program *prog;
+	__u32 duration = 0;
+	int err, pkt_fd;
+
+	err = bpf_prog_load(tgt_name, BPF_PROG_TYPE_UNSPEC,
+			    &pkt_obj, &pkt_fd);
+	/* the target prog should load fine */
+	if (CHECK(err, "tgt_prog_load", "file %s err %d errno %d\n",
+		  tgt_name, err, errno))
+		return;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			    .attach_prog_fd = pkt_fd,
+			   );
+
+	freplace_obj = bpf_object__open_file(freplace_name, &opts);
+	if (CHECK(IS_ERR_OR_NULL(freplace_obj), "freplace_obj_open",
+		  "failed to open %s: %ld\n", freplace_name,
+		  PTR_ERR(freplace_obj)))
+		goto out;
+
+	err = bpf_object__load(freplace_obj);
+	if (CHECK(err, "freplace_obj_load", "err %d\n", err))
+		goto out;
+
+	prog = bpf_program__next(NULL, freplace_obj);
+	freplace_link = bpf_program__attach_trace(prog);
+	if (CHECK(IS_ERR(freplace_link), "freplace_attach_trace", "failed to link\n"))
+		goto out;
+
+	opts.attach_prog_fd = bpf_program__fd(prog);
+	fmod_obj = bpf_object__open_file(fmod_ret_name, &opts);
+	if (CHECK(IS_ERR_OR_NULL(fmod_obj), "fmod_obj_open",
+		  "failed to open %s: %ld\n", fmod_ret_name,
+		  PTR_ERR(fmod_obj)))
+		goto out;
+
+	err = bpf_object__load(fmod_obj);
+	if (CHECK(err, "fmod_obj_load", "err %d\n", err))
+		goto out;
+
+	prog = bpf_program__next(NULL, fmod_obj);
+	fmod_link = bpf_program__attach_trace(prog);
+	if (CHECK(!IS_ERR(fmod_link), "fmod_attach_trace",
+		  "linking fmod_ret to freplace should fail\n"))
+		goto out;
+
+out:
+	if (!IS_ERR_OR_NULL(freplace_link))
+		bpf_link__destroy(freplace_link);
+	if (!IS_ERR_OR_NULL(fmod_link))
+		bpf_link__destroy(fmod_link);
+	if (!IS_ERR_OR_NULL(freplace_obj))
+		bpf_object__close(freplace_obj);
+	if (!IS_ERR_OR_NULL(fmod_obj))
+		bpf_object__close(fmod_obj);
+	bpf_object__close(pkt_obj);
+}
+
+
 static void test_func_sockmap_update(void)
 {
 	const char *prog_name[] = {
@@ -315,4 +381,6 @@ void test_fexit_bpf2bpf(void)
 		test_func_map_prog_compatibility();
 	if (test__start_subtest("func_replace_multi"))
 		test_func_replace_multi();
+	if (test__start_subtest("fmod_ret_freplace"))
+		test_fmod_ret_freplace();
 }
diff --git a/tools/testing/selftests/bpf/progs/fmod_ret_freplace.c b/tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
new file mode 100644
index 000000000000..c8943ccee6c0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+volatile __u64 test_fmod_ret = 0;
+SEC("fmod_ret/security_new_get_constant")
+int BPF_PROG(fmod_ret_test, long val, int ret)
+{
+	test_fmod_ret = 1;
+	return 120;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/freplace_get_constant.c b/tools/testing/selftests/bpf/progs/freplace_get_constant.c
index 8f0ecf94e533..705e4b64dfc2 100644
--- a/tools/testing/selftests/bpf/progs/freplace_get_constant.c
+++ b/tools/testing/selftests/bpf/progs/freplace_get_constant.c
@@ -5,7 +5,7 @@
 
 volatile __u64 test_get_constant = 0;
 SEC("freplace/get_constant")
-int new_get_constant(long val)
+int security_new_get_constant(long val)
 {
 	if (val != 123)
 		return 0;

