Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D1F27CDB9
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbgI2MqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:46:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733294AbgI2MqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:46:06 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601383564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+g4gavvzkE9a6aqv0X291vvrq93unWSXrCpz4oNLKB8=;
        b=iOwHuFquA4001/R0rEDuogHArlpaoIRx9bsS5KaLUvo6Hg1iKcAd+hKDCg+jysjos1gmyL
        vrXlAf5C3uHaJ8Fllcx0iD0ZzAy1ajIL4AG7Cg62LvFb4DndV+GenmCimgYCJppQ3upjzu
        NqJOkzjDcuzRE98KaBvc6mm2ymN8Uiw=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-dX9cQLbNPy-JBnAM3Npwjw-1; Tue, 29 Sep 2020 08:46:02 -0400
X-MC-Unique: dX9cQLbNPy-JBnAM3Npwjw-1
Received: by mail-oi1-f197.google.com with SMTP id j189so1561287oih.16
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:46:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+g4gavvzkE9a6aqv0X291vvrq93unWSXrCpz4oNLKB8=;
        b=VNShuCT8+gxuBnKaqldrCPj49IzcDVaRRWas6XErNMcgQODwzw9I4xWPbi80X2SFyg
         sg4GvYQDcHgY7cEnQw7KnAfS7BByy67qa7HnfuJZ218a3b7+E7rocaEKIIVCPJkU2syY
         rXiKVQs3SuGtpTCzQzf7qjF56tsTkeMti4oc26kFp/eYsadd1ZUoof3YtN/q17W5vw55
         ojLm2MLV5j/A8tvhUSTFmc9slsiqvTV2Ehelyd/LXLBpl38lzLFWms1h6Lfr+hQ6P0yq
         pFGp1rah7G5B7hG70P4tyil63X04NSboPiIKf/8eXEkCbsplkVPrMPHoKMyDPpMehLiF
         kLaQ==
X-Gm-Message-State: AOAM533R4mv7oUcBMqdbXJBRSHsdQUWErufIjvgMUWknwNkeAuzxp4nf
        K0x0dpOHpSNhSHK8dHgpB/287XXOjuirWzVrkL7yM3IouKjh5AjKrnXbtI+BzLkL8RCnD2XcHQp
        +u4O4CJo78rWDq4ch
X-Received: by 2002:a05:6830:150a:: with SMTP id k10mr2490489otp.167.1601383560678;
        Tue, 29 Sep 2020 05:46:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhZ6bbqG0rcTTHpIecObb0KcP+Dmz9DesXltkItA3D2L762yo+YRChxD3SAPCXz7ANYjPgKg==
X-Received: by 2002:a05:6830:150a:: with SMTP id k10mr2490476otp.167.1601383560453;
        Tue, 29 Sep 2020 05:46:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a2sm2871165ooo.26.2020.09.29.05.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:45:58 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 37FF2183C5F; Tue, 29 Sep 2020 14:45:57 +0200 (CEST)
Subject: [PATCH bpf-next v10 7/7] selftests: Add selftest for disallowing
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
Date:   Tue, 29 Sep 2020 14:45:57 +0200
Message-ID: <160138355713.48470.3811074984255709369.stgit@toke.dk>
In-Reply-To: <160138354947.48470.11523413403103182788.stgit@toke.dk>
References: <160138354947.48470.11523413403103182788.stgit@toke.dk>
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

