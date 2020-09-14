Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64920269181
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgINQ3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:29:00 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58548 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726531AbgINQNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600100015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKxu0gI3NP8CcGDo/E56sTrTiNg8cMjHfGpHFMTcnpo=;
        b=Hic2chkywxhrTLvNUABhaJZlp7tturRLnMj+vCwaQQ/KXT+7xBn0hBVGKUFyGAyYvorE1J
        bLyUy6KzU2OmNP/psWuMTdmNYNdMHOf8FyEuGvkWteAZPaCGiYbgLpYJJGehGMp7rosYw+
        eF9ce4y2ujZWEap3bcbjkHrlJFUTYrM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-TeWN-PYsPsCjwuM4YOOQNQ-1; Mon, 14 Sep 2020 12:13:34 -0400
X-MC-Unique: TeWN-PYsPsCjwuM4YOOQNQ-1
Received: by mail-wr1-f71.google.com with SMTP id g6so67494wrv.3
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=bKxu0gI3NP8CcGDo/E56sTrTiNg8cMjHfGpHFMTcnpo=;
        b=COWnj84lIdMzAPtLy2PU7fPYNjXu6TA3o9ZNoeJeKE+hmb/FQHlkh1c6i58a19QSoh
         qeY+Wa87iGOMlGhLq3WUcEsDy53p9/LOfPtrQiavO9Y1DCe5DwdblQgTuthrTlF07IHB
         wnPgTXv9X1aaVmCs362/K4KLc9qIL09A/6H/wIjCsFLvs9wB9uBOLlYrR0FWjNe+BZCV
         iI6ngqdQJqxd7yF19DG7eWqXfOakMd4+W86UgKRgFsi/goMvhOpjI7DTb/5bb0No3k1v
         LAqWcflBavZWgHJUchD6nm/1XHcfFWDLL0a+UnDwQgllZUD6qXDwMp5iq7g8S+X7SXvr
         Ry/A==
X-Gm-Message-State: AOAM531xdJ326LWvfpy89AyilLMB6MZX/PPfbYc/Lyq6baDhXZr2iG+9
        Bw6S86dd6odZG1uUIBnfx+YccPQXK0VVZq3NROcAfOyuHAH6aR6N04yz6ucnH+vWxTPjcS/yXPo
        IsfyptRuXj9SbIJWf
X-Received: by 2002:a1c:2b43:: with SMTP id r64mr133923wmr.164.1600100012840;
        Mon, 14 Sep 2020 09:13:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzymn38Sc1H6g+2Td4p8iEhWnIPoL9wyn8Ds+kBBjuvjCm7o257Rq+nbxsI5IULwchqn8b4NQ==
X-Received: by 2002:a1c:2b43:: with SMTP id r64mr133896wmr.164.1600100012545;
        Mon, 14 Sep 2020 09:13:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x2sm21488767wrl.13.2020.09.14.09.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:13:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A2C651829CC; Mon, 14 Sep 2020 18:13:31 +0200 (CEST)
Subject: [PATCH bpf-next v4 8/8] selftests/bpf: Adding test for arg
 dereference in extension trace
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
Date:   Mon, 14 Sep 2020 18:13:31 +0200
Message-ID: <160010001156.80898.2494172135831865551.stgit@toke.dk>
In-Reply-To: <160010000272.80898.13117015273092905112.stgit@toke.dk>
References: <160010000272.80898.13117015273092905112.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

Adding test that setup following program:

  SEC("classifier/test_pkt_md_access")
  int test_pkt_md_access(struct __sk_buff *skb)

with its extension:

  SEC("freplace/test_pkt_md_access")
  int test_pkt_md_access_new(struct __sk_buff *skb)

and tracing that extension with:

  SEC("fentry/test_pkt_md_access_new")
  int BPF_PROG(fentry, struct sk_buff *skb)

The test verifies that the tracing program can
dereference skb argument properly.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |  113 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_trace_ext.c |   18 +++
 .../selftests/bpf/progs/test_trace_ext_tracing.c   |   25 ++++
 3 files changed, 156 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_ext.c b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
new file mode 100644
index 000000000000..49b554f560a4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <test_progs.h>
+#include <network_helpers.h>
+#include <sys/stat.h>
+#include <linux/sched.h>
+#include <sys/syscall.h>
+
+#include "test_pkt_md_access.skel.h"
+#include "test_trace_ext.skel.h"
+#include "test_trace_ext_tracing.skel.h"
+
+static __u32 duration;
+
+void test_trace_ext(void)
+{
+	struct test_pkt_md_access *skel_pkt = NULL;
+	struct test_trace_ext_tracing *skel_trace = NULL;
+	struct test_trace_ext_tracing__bss *bss_trace;
+	struct test_trace_ext *skel_ext = NULL;
+	struct test_trace_ext__bss *bss_ext;
+	int err, pkt_fd, ext_fd;
+	struct bpf_program *prog;
+	char buf[100];
+	__u32 retval;
+	__u64 len;
+
+	/* open/load/attach test_pkt_md_access */
+	skel_pkt = test_pkt_md_access__open_and_load();
+	if (CHECK(!skel_pkt, "setup", "classifier/test_pkt_md_access open failed\n"))
+		goto cleanup;
+
+	err = test_pkt_md_access__attach(skel_pkt);
+	if (CHECK(err, "setup", "classifier/test_pkt_md_access attach failed: %d\n", err))
+		goto cleanup;
+
+	prog = skel_pkt->progs.test_pkt_md_access;
+	pkt_fd = bpf_program__fd(prog);
+
+	/* open extension */
+	skel_ext = test_trace_ext__open();
+	if (CHECK(!skel_ext, "setup", "freplace/test_pkt_md_access open failed\n"))
+		goto cleanup;
+
+	/* set extension's attach target - test_pkt_md_access  */
+	prog = skel_ext->progs.test_pkt_md_access_new;
+	bpf_program__set_attach_target(prog, pkt_fd, "test_pkt_md_access");
+
+	/* load/attach extension */
+	err = test_trace_ext__load(skel_ext);
+	if (CHECK(err, "setup", "freplace/test_pkt_md_access load failed\n")) {
+		libbpf_strerror(err, buf, sizeof(buf));
+		fprintf(stderr, "%s\n", buf);
+		goto cleanup;
+	}
+
+	err = test_trace_ext__attach(skel_ext);
+	if (CHECK(err, "setup", "freplace/test_pkt_md_access attach failed: %d\n", err))
+		goto cleanup;
+
+	prog = skel_ext->progs.test_pkt_md_access_new;
+	ext_fd = bpf_program__fd(prog);
+
+	/* open tracing  */
+	skel_trace = test_trace_ext_tracing__open();
+	if (CHECK(!skel_trace, "setup", "tracing/test_pkt_md_access_new open failed\n"))
+		goto cleanup;
+
+	/* set tracing's attach target - fentry */
+	prog = skel_trace->progs.fentry;
+	bpf_program__set_attach_target(prog, ext_fd, "test_pkt_md_access_new");
+
+	/* set tracing's attach target - fexit */
+	prog = skel_trace->progs.fexit;
+	bpf_program__set_attach_target(prog, ext_fd, "test_pkt_md_access_new");
+
+	/* load/attach tracing */
+	err = test_trace_ext_tracing__load(skel_trace);
+	if (CHECK(err, "setup", "tracing/test_pkt_md_access_new load failed\n")) {
+		libbpf_strerror(err, buf, sizeof(buf));
+		fprintf(stderr, "%s\n", buf);
+		goto cleanup;
+	}
+
+	err = test_trace_ext_tracing__attach(skel_trace);
+	if (CHECK(err, "setup", "tracing/test_pkt_md_access_new attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger the test */
+	err = bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, &retval, &duration);
+	CHECK(err || retval, "",
+	      "err %d errno %d retval %d duration %d\n",
+	      err, errno, retval, duration);
+
+	bss_ext = skel_ext->bss;
+	bss_trace = skel_trace->bss;
+
+	len = bss_ext->ext_called;
+
+	CHECK(bss_ext->ext_called == 0,
+		"check", "failed to trigger freplace/test_pkt_md_access\n");
+	CHECK(bss_trace->fentry_called != len,
+		"check", "failed to trigger fentry/test_pkt_md_access_new\n");
+	CHECK(bss_trace->fexit_called != len,
+		"check", "failed to trigger fexit/test_pkt_md_access_new\n");
+
+cleanup:
+	test_trace_ext_tracing__destroy(skel_trace);
+	test_trace_ext__destroy(skel_ext);
+	test_pkt_md_access__destroy(skel_pkt);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext.c b/tools/testing/selftests/bpf/progs/test_trace_ext.c
new file mode 100644
index 000000000000..d19a634d0e78
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_trace_ext.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+#include <linux/bpf.h>
+#include <stdbool.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+
+__u64 ext_called = 0;
+
+SEC("freplace/test_pkt_md_access")
+int test_pkt_md_access_new(struct __sk_buff *skb)
+{
+	ext_called = skb->len;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c b/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
new file mode 100644
index 000000000000..52f3baf98f20
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+__u64 fentry_called = 0;
+
+SEC("fentry/test_pkt_md_access_new")
+int BPF_PROG(fentry, struct sk_buff *skb)
+{
+	fentry_called = skb->len;
+	return 0;
+}
+
+__u64 fexit_called = 0;
+
+SEC("fexit/test_pkt_md_access_new")
+int BPF_PROG(fexit, struct sk_buff *skb)
+{
+	fexit_called = skb->len;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";

