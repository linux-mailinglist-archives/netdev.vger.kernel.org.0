Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5327484D
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 20:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIVSjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 14:39:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23378 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726710AbgIVSi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 14:38:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600799934;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+g4gavvzkE9a6aqv0X291vvrq93unWSXrCpz4oNLKB8=;
        b=PqOZRZs4h2NAiQkvBi3C4sqv+woiq5UvMfRcQ0xmgCaWDqsUs0Gvzh4z9zu7Om0yIuIz2G
        IDfbt0nvBMiTPdGgS7PqR/z9HeteiiflBoEKbJMNZ+OsDnYtvdKHh+SNx8p/ziq9YHPTzi
        l5e1XtSpoN9TaMQryY51EwtRL420ODo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-u0iuTXLLMfqbpQin4aTtSQ-1; Tue, 22 Sep 2020 14:38:51 -0400
X-MC-Unique: u0iuTXLLMfqbpQin4aTtSQ-1
Received: by mail-pf1-f198.google.com with SMTP id e12so12053019pfm.0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 11:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+g4gavvzkE9a6aqv0X291vvrq93unWSXrCpz4oNLKB8=;
        b=gLPmfZl/2NIhdlhuu4KGCpOl/OTTy4zZFRr+eZ4M/PZ9coy+y6wKCxSQNTNwj8XnxX
         u7uFXa6JOTnihjAs3Oef/3ucOsyct2CpoWlThfFZTBFGG9VBUrnbqPK0/yrqI96TQrId
         0iXKbAOQPhH7hUwn0yckuykTFiwrwN+hT6sZoEQ4HC1qIjHt5EazGmtojZNB6FoFNTSW
         Ld/BfBaPrU1rMZFmCfRllih2g4q4Xc9NtSrnweY5LrDpcZtUTvuY9mOyefzKHvQys6Ut
         oLaKYf9QoBjDbKgD0UWdQMPexhlkY1/phCaRISd+JlW3RKmItSYSPOu36FppB58QkNIf
         6IJg==
X-Gm-Message-State: AOAM533j/g3D/jydG1amwvgMSsSWj3fdc+Vy6nJC1vZgepl5OgsZJE84
        B2375/Vy4jP/OHO5Kb4mUA8sdrLkS18piHRFlESmZcXIWSsr+lcOFnNmIt+adgkIZhQXxZ3Gbqx
        dYcz3jJ9IuZ1n+4RT
X-Received: by 2002:a17:902:ba98:b029:d1:e598:3ff2 with SMTP id k24-20020a170902ba98b02900d1e5983ff2mr5988967pls.44.1600799930186;
        Tue, 22 Sep 2020 11:38:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdThfifYLr3oWGFHCDqhkUa1fSe1NepN/sVZsxuzUZZdZ3WdvXlwH2dTyETfgMI15fpwWDfw==
X-Received: by 2002:a17:902:ba98:b029:d1:e598:3ff2 with SMTP id k24-20020a170902ba98b02900d1e5983ff2mr5988938pls.44.1600799929828;
        Tue, 22 Sep 2020 11:38:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y195sm15987276pfc.137.2020.09.22.11.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 11:38:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 91F46183A92; Tue, 22 Sep 2020 20:38:44 +0200 (CEST)
Subject: [PATCH bpf-next v8 10/11] selftests: Add selftest for disallowing
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
Date:   Tue, 22 Sep 2020 20:38:44 +0200
Message-ID: <160079992454.8301.10960942800501262586.stgit@toke.dk>
In-Reply-To: <160079991372.8301.10648588027560707258.stgit@toke.dk>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   56 ++++++++++++++++++++
 .../selftests/bpf/progs/fmod_ret_freplace.c        |   14 +++++
 .../selftests/bpf/progs/freplace_get_constant.c    |    2 -
 3 files changed, 71 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 2b94e827b2c5..5c0448910426 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -232,6 +232,60 @@ static void test_func_replace_multi(void)
 				  prog_name, true, test_second_attach);
 }
 
+static void test_fmod_ret_freplace(void)
+{
+	struct bpf_object *freplace_obj = NULL, *pkt_obj, *fmod_obj = NULL;
+	const char *freplace_name = "./freplace_get_constant.o";
+	const char *fmod_ret_name = "./fmod_ret_freplace.o";
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
+	const char *tgt_name = "./test_pkt_access.o";
+	struct bpf_link *freplace_link = NULL;
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
+	opts.attach_prog_fd = pkt_fd;
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
+	if (CHECK(!err, "fmod_obj_load", "loading fmod_ret should fail\n"))
+		goto out;
+
+out:
+	bpf_link__destroy(freplace_link);
+	bpf_object__close(freplace_obj);
+	bpf_object__close(fmod_obj);
+	bpf_object__close(pkt_obj);
+}
+
+
 static void test_func_sockmap_update(void)
 {
 	const char *prog_name[] = {
@@ -314,4 +368,6 @@ void test_fexit_bpf2bpf(void)
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

