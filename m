Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B4326E697
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgIQUU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:20:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38870 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726687AbgIQUUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600374019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=utfMK0fpz+Di6YKgONWOEtGJeoQeNvRbM0wd8gaCZ8U=;
        b=a/W6MhccT92kYY+U6AxswV334O8AA0sD4pjJyQoWvSPwq7WAsYuiF2qcpdfNaeROrjLEd2
        +nZhz9cr6TAvndQ52F5mhmDoClm0+k/XAeA5Qd8vDMuFvD/5luyX6pZNgVhWdo+o+dZDIO
        Tr0AfvT30/x/XQlfEJ81pOyI5sAszeE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-zzDWq2BDPJevqnaNFU3Bng-1; Thu, 17 Sep 2020 16:20:16 -0400
X-MC-Unique: zzDWq2BDPJevqnaNFU3Bng-1
Received: by mail-ej1-f71.google.com with SMTP id dc22so1317110ejb.21
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:20:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=utfMK0fpz+Di6YKgONWOEtGJeoQeNvRbM0wd8gaCZ8U=;
        b=bgoOJMsrLqY5MKsYoWCZMo/I3DwYgCcqq6c7vpAR2S5Vylq/RKRT5dvdV/9p1IwmtL
         BwaI+9le1SVEiDYzYOBg2sZsvO0eyzjxbo+uLrNGr/Z2L3KLUU39za7TrDXw/BNjUePb
         TAvy40FIT3HaPDUGhrAorbCIZ3H070JpiCMrn61LeELNlp1m2bq3N2tB/QI368AtwUkz
         01MmGAPt1qR+SGXRvoCpPV7xyBMlLkEQC4vyUF8Etud7U8ZYBEIxQo9j9nGG5czERfjO
         y/aYx2W6FqDofgUfwq+8nvPP+zMq5TfQfOdOZc0cNM0Gu2lZ2j75j1HL5WPorKIfPzih
         Ynqg==
X-Gm-Message-State: AOAM532LEtZMuU/DcmSAlJBgqSWawKhhDCxvtENKI/KmlE2zE2ZK8fj1
        N521qiqwpFYMqNEVqJ69dH3/9SN3Xiog80bjhykEHcGNVq0N0XkRqlgbYFBjh8q2nmoFv/FKySG
        b0OHh4pwqj5hR8YcD
X-Received: by 2002:a50:9b44:: with SMTP id a4mr33993175edj.12.1600374014666;
        Thu, 17 Sep 2020 13:20:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxaciW8tG440uTdlNwDKJDmptZbQNSa+lRZbVQSmel/IQ38y98L4ha57CCv6RRiz52sXM2oLw==
X-Received: by 2002:a50:9b44:: with SMTP id a4mr33993141edj.12.1600374014305;
        Thu, 17 Sep 2020 13:20:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q12sm546410edj.19.2020.09.17.13.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 13:20:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 848E1183A91; Thu, 17 Sep 2020 22:20:11 +0200 (CEST)
Subject: [PATCH bpf-next v6 10/10] selftests: Add selftest for disallowing
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
Date:   Thu, 17 Sep 2020 22:20:11 +0200
Message-ID: <160037401148.28970.15646899510538322830.stgit@toke.dk>
In-Reply-To: <160037400056.28970.7647821897296177963.stgit@toke.dk>
References: <160037400056.28970.7647821897296177963.stgit@toke.dk>
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

