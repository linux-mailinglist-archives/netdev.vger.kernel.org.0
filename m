Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1064527CDAF
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387578AbgI2MqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54498 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387564AbgI2MqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 08:46:10 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601383567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clygwoJ1f9sZLqUhcfeUO7K+/N8tqwPrjcsYeSe/dUM=;
        b=U5UdhqHI4pG0a0gHi+xBtc6zN/OLvPniVkpxa0uLSp5vtQ/lv6Gj9L5ZoB4A6nHV+YmZED
        H5xKmU33P9mvXJi+GWa96fR+4gV7uIrjWhQ5fWf04kS5GH7LPqtJSvYpRQRwQycuuj3/KK
        xx8v4svReU656sk34055u6J0NqhJVEs=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-p9RjQeu8N-mSib8przufTA-1; Tue, 29 Sep 2020 08:46:05 -0400
X-MC-Unique: p9RjQeu8N-mSib8przufTA-1
Received: by mail-oo1-f71.google.com with SMTP id j12so2005360ooi.15
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 05:46:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=clygwoJ1f9sZLqUhcfeUO7K+/N8tqwPrjcsYeSe/dUM=;
        b=stIpFYt0SHZbuTyEaIsUvFcptLE/9uAc+SbwUHgfjTn2Tg7cmevHjeu1WtHbGZBDZA
         Wv2YCN09bicgXkyvEkf8taeyGEi1vCdWuQUGkNeHxB/0jAcAh8obHcPnj+Zu7z7uDlvJ
         2sEk6MauiDODvuFcQ+99phYAzolBrvIOAwwAXfLLh4aQjAEYQo53U54ZKOHDceLkvLqK
         2s+xLAUz7INdo99dnqWF17k+oImlFWOn3NgRflxs3OsERpda3crEdR4YwxI2hmTnuEkY
         EWgxT5uI/zeaTIKJvDxvjnniFTC3lqvr3YintiSPTv3NQ3P46chji6Iy0tbjuP9euKDV
         lLqw==
X-Gm-Message-State: AOAM531DpAHf2SZtKtMbSRPgWtK0ecRlzm5mwuwdY2gg3Jq/0Js/HBQK
        JdVheATbiJevRkIZ56nZxJIZ/8E2v5y5C2Hp13KZU+UyIMdyXeyoJr+YweIodoNHBrnRXvAQwAD
        HX6ttPW7YsgiAtDWA
X-Received: by 2002:aca:3c44:: with SMTP id j65mr2365576oia.43.1601383564538;
        Tue, 29 Sep 2020 05:46:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwWbt0h/1aJXZekPyieLew9z7mSDit5og/0NfKZto3o/L2gU4Vs5Ay1qSJxY+JmQ2JA3sX8FA==
X-Received: by 2002:aca:3c44:: with SMTP id j65mr2365547oia.43.1601383564206;
        Tue, 29 Sep 2020 05:46:04 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b1sm2863537oof.8.2020.09.29.05.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 05:46:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 210E4183C62; Tue, 29 Sep 2020 14:45:56 +0200 (CEST)
Subject: [PATCH bpf-next v10 6/7] selftests/bpf: Adding test for arg
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
Date:   Tue, 29 Sep 2020 14:45:56 +0200
Message-ID: <160138355603.48470.9072073357530773228.stgit@toke.dk>
In-Reply-To: <160138354947.48470.11523413403103182788.stgit@toke.dk>
References: <160138354947.48470.11523413403103182788.stgit@toke.dk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

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

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |  111 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_trace_ext.c |   18 +++
 .../selftests/bpf/progs/test_trace_ext_tracing.c   |   25 +++++
 3 files changed, 154 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracing.c

diff --git a/tools/testing/selftests/bpf/prog_tests/trace_ext.c b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
new file mode 100644
index 000000000000..924441d4362d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/trace_ext.c
@@ -0,0 +1,111 @@
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
+	CHECK(err || retval, "run", "err %d errno %d retval %d\n", err, errno, retval);
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

