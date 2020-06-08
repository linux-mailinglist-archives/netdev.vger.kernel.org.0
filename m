Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDD61F1AA3
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 16:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgFHOLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 10:11:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34720 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729954AbgFHOLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 10:11:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591625498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MxkTRZRsQP1J8a71Um9hIg/iKa88JmYu+3UuvOpsZf0=;
        b=UNZB1sS3sG2KlU8i7uWAAoAWWC9Kgqqd2cbrZBX6HJPq06PvdPa8eZqAQZj8qsbKUwVi61
        lGC4efu/gQkX0e2h0vzMjjwFHEg3c6A1c4S1qb3F01FCSJmc3pp7JX9FtFUfBe8oNN4f+9
        mMo6fpJe8T+btROnwpRJb1DV7tGfJfc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-97iuZ7K6NMGv7q_fCkjo5w-1; Mon, 08 Jun 2020 10:11:34 -0400
X-MC-Unique: 97iuZ7K6NMGv7q_fCkjo5w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D396A83DE6B;
        Mon,  8 Jun 2020 14:11:32 +0000 (UTC)
Received: from ebuild.redhat.com (ovpn-115-69.ams2.redhat.com [10.36.115.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DACC768B4;
        Mon,  8 Jun 2020 14:11:27 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        toke@redhat.com
Subject: fentry/fexit attach to EXT type XDP program does not work
Date:   Mon,  8 Jun 2020 16:11:22 +0200
Message-Id: <159162546868.10791.12432342618156330247.stgit@ebuild>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm trying for a while to do a fentry/fexit trace an EXT program
attached to an XDP program. To make it easier to explain I've
created a test case (see patch below) to show the issue.

Without the changes to test_xdp_bpf2bpf.c I'll get the following error:

  libbpf: -- BEGIN DUMP LOG ---
  libbpf:
  arg#0 type is not a struct
  Unrecognized arg#0 type PTR
  ; int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
  0: (79) r6 = *(u64 *)(r1 +0)
  invalid bpf_context access off=0 size=8
  processed 1 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0

  libbpf: -- END LOG --
  libbpf: failed to load program 'fentry/FUNC'
  libbpf: failed to load object 'test_xdp_bpf2bpf'
  libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
  test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
  #91 xdp_fentry_ext:FAIL
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

With the change I get the following (but I do feel this change
should not be needed):

  libbpf: -- BEGIN DUMP LOG ---
  libbpf:
  Unrecognized arg#0 type PTR
  ; int trace_on_entry(struct xdp_buff *xdp)
  0: (bf) r6 = r1
  ; void *data = (void *)(long)xdp->data;
  1: (79) r1 = *(u64 *)(r6 +0)
  invalid bpf_context access off=0 size=8
  processed 2 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0

  libbpf: -- END LOG --
  libbpf: failed to load program 'fentry/FUNC'
  libbpf: failed to load object 'test_xdp_bpf2bpf'
  libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
  test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
  #91 xdp_fentry_ext:FAIL
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

Any idea what could be the case here? The same fentry/fexit attach
code works fine in the xdp_bpf2bpf.c tests case.


Cheers,


Eelco
---
 .../selftests/bpf/prog_tests/xdp_fentry_ext.c      |   95 ++++++++++++++++++++
 1 file changed, 95 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c b/tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c
new file mode 100644
index 000000000000..68cd83fad632
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_fentry_ext.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <network_helpers.h>
+
+#include "test_xdp_ext.skel.h"
+#include "test_xdp_bpf2bpf.skel.h"
+#include "xdp_dummy.skel.h"
+
+void test_xdp_fentry_ext(void)
+{
+        /* Using the skeleton framework does not work, as it does not like
+         * like the prog_replace() function to be noinline
+         */
+
+	__u32 duration = 0, retval, size;
+        const char *file = "./test_xdp_ext.o";
+        const char *ext_file = "./xdp_dummy.o";
+        struct bpf_program *prog;
+        struct bpf_program *ext_prog;
+	struct bpf_object *xdp_obj, *ext_obj = NULL;
+        struct test_xdp_bpf2bpf *ftrace_skel = NULL;
+        int err, xdp_fd, ext_fd;
+	char buf[128];
+
+        err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &xdp_obj, &xdp_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+        /* Load the EXT program to attach to replace existing function */
+        ext_obj = bpf_object__open_file(ext_file, NULL);
+        if (CHECK(IS_ERR_OR_NULL(ext_obj), "obj_open",
+                  "failed to open %s: %ld\n",
+                  ext_file, PTR_ERR(ext_obj)))
+                goto out;
+
+        ext_prog = bpf_object__find_program_by_title(ext_obj, "xdp_dummy");
+        if (CHECK(!ext_prog, "find_prog", "xdp_dummy_prog not found\n"))
+                goto out;
+
+        err = bpf_program__set_attach_target(ext_prog, xdp_fd, "prog_replace");
+	if (CHECK(err, "set_attach", "err %d, errno %d\n", err, errno))
+                goto out;
+
+        bpf_program__set_type(ext_prog, BPF_PROG_TYPE_EXT);
+
+        err = bpf_object__load(ext_obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto out;
+
+        bpf_program__attach_trace(ext_prog);
+
+        ext_fd = bpf_program__fd(ext_prog);
+
+        /* Now try to attach an fentry trace to the EXT program above */
+
+	ftrace_skel = test_xdp_bpf2bpf__open();
+	if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
+		goto out;
+
+        prog = ftrace_skel->progs.trace_on_entry;
+	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
+	bpf_program__set_attach_target(prog, ext_fd, "xdp_dummy_prog");
+
+	prog = ftrace_skel->progs.trace_on_exit;
+	bpf_program__set_expected_attach_type(prog, BPF_TRACE_FEXIT);
+	bpf_program__set_attach_target(prog, ext_fd, "xdp_dummy_prog");
+
+	err = test_xdp_bpf2bpf__load(ftrace_skel);
+	if (CHECK(err, "__load", "ftrace skeleton failed\n"))
+		goto out;
+
+	err = test_xdp_bpf2bpf__attach(ftrace_skel);
+	if (CHECK(err, "ftrace_attach", "ftrace attach failed: %d\n", err))
+		goto out;
+
+
+	/* Execute the xdp program by sending a dummy packet */
+	err = bpf_prog_test_run(xdp_fd, 1, &pkt_v4, sizeof(pkt_v4),
+				buf, &size, &retval, &duration);
+
+	if (CHECK(err || retval != XDP_PASS , "packet",
+		  "err %d, errno %d, retval %d %c= %d\n",
+                  err, errno, retval, retval != XDP_PASS ? '!' : '=', XDP_PASS))
+		goto out;
+
+out:
+	bpf_object__close(xdp_obj);
+        if (ext_obj)
+                bpf_object__close(ext_obj);
+        if (ftrace_skel)
+                test_xdp_bpf2bpf__destroy(ftrace_skel);
+
+}
+
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
index a038e827f850..41b2a103c7ca 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
@@ -42,7 +42,8 @@ struct {
 
 __u64 test_result_fentry = 0;
 SEC("fentry/FUNC")
-int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
+//int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
+int trace_on_entry(struct xdp_buff *xdp)
 {
 	struct meta meta;
 	void *data_end = (void *)(long)xdp->data_end;
@@ -61,7 +62,8 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
 
 __u64 test_result_fexit = 0;
 SEC("fexit/FUNC")
-int BPF_PROG(trace_on_exit, struct xdp_buff *xdp, int ret)
+//int BPF_PROG(trace_on_exit, struct xdp_buff *xdp, int ret)
+int trace_on_exit(struct xdp_buff *xdp, int ret)
 {
 	test_result_fexit = ret;
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_ext.c b/tools/testing/selftests/bpf/progs/test_xdp_ext.c
new file mode 100644
index 000000000000..37bd16c95b36
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_ext.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+__u64 xdp_ext_called = 0;
+
+__attribute__ ((noinline))
+int prog_replace(struct xdp_md *ctx) {
+        volatile int ret = XDP_ABORTED;
+
+        return ret;
+}
+
+SEC("xdp_ext_call")
+int xdp_ext_call_func(struct xdp_md *ctx)
+{
+
+        return prog_replace(ctx);
+}
+
+char _license[] SEC("license") = "GPL";

