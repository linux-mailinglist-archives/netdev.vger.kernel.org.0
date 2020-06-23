Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0080C206658
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393821AbgFWVk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 17:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394046AbgFWVkV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 17:40:21 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E526B2078E;
        Tue, 23 Jun 2020 21:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592948420;
        bh=nnhLuWjhAmtqdh/h9McwI2+rIxXUasdP/Hjaz6p8JLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13PGfucgHJy7tvjWCF9VC7aGxsTrTg58wQks/nfHjexf0EyAI9Xa22bYW8JNQmpiJ
         DZFfIl8xi+I/woe4IHhmi8pkKd6qMiLrNnInbED5XcAPaSW4hSEhnrgZei7XR02xdO
         qJFjgquzmBsuFT7s1xLPxHSfzZi69kDwMvq1t1Ig=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org, andrii.nakryiko@gmail.com
Subject: [PATCH v3 bpf-next 9/9] selftest: add tests for XDP programs in CPUMAP entries
Date:   Tue, 23 Jun 2020 23:39:34 +0200
Message-Id: <81ff56ab7ba1f0e48cba821563d311fa8f7e2e28.1592947694.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to what have been done for DEVMAP, introduce tests to verify
ability to add a XDP program to an entry in a CPUMAP.
Verify CPUMAP programs can not be attached to devices as a normal
XDP program, and only programs with BPF_XDP_CPUMAP attach type can
be loaded in a CPUMAP.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_cpumap_attach.c        | 70 +++++++++++++++++++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c  | 40 +++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
new file mode 100644
index 000000000000..0176573fe4e7
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <uapi/linux/bpf.h>
+#include <linux/if_link.h>
+#include <test_progs.h>
+
+#include "test_xdp_with_cpumap_helpers.skel.h"
+
+#define IFINDEX_LO	1
+
+void test_xdp_with_cpumap_helpers(void)
+{
+	struct test_xdp_with_cpumap_helpers *skel;
+	struct bpf_prog_info info = {};
+	struct bpf_cpumap_val val = {
+		.qsize = 192,
+	};
+	__u32 duration = 0, idx = 0;
+	__u32 len = sizeof(info);
+	int err, prog_fd, map_fd;
+
+	skel = test_xdp_with_cpumap_helpers__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		perror("test_xdp_with_cpumap_helpers__open_and_load");
+		return;
+	}
+
+	/* can not attach program with cpumaps that allow programs
+	 * as xdp generic
+	 */
+	prog_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
+	CHECK(err == 0, "Generic attach of program with 8-byte CPUMAP",
+	      "should have failed\n");
+
+	prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
+	map_fd = bpf_map__fd(skel->maps.cpu_map);
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_close;
+
+	val.bpf_prog.fd = prog_fd;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	CHECK(err, "Add program to cpumap entry", "err %d errno %d\n",
+	      err, errno);
+
+	err = bpf_map_lookup_elem(map_fd, &idx, &val);
+	CHECK(err, "Read cpumap entry", "err %d errno %d\n", err, errno);
+	CHECK(info.id != val.bpf_prog.id, "Expected program id in cpumap entry",
+	      "expected %u read %u\n", info.id, val.bpf_prog.id);
+
+	/* can not attach BPF_XDP_CPUMAP program to a device */
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
+	CHECK(err == 0, "Attach of BPF_XDP_CPUMAP program",
+	      "should have failed\n");
+
+	val.qsize = 192;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	CHECK(err == 0, "Add non-BPF_XDP_CPUMAP program to cpumap entry",
+	      "should have failed\n");
+
+out_close:
+	test_xdp_with_cpumap_helpers__destroy(skel);
+}
+
+void test_xdp_cpumap_attach(void)
+{
+	if (test__start_subtest("cpumap_with_progs"))
+		test_xdp_with_cpumap_helpers();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
new file mode 100644
index 000000000000..861848d0c353
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+static __u32 ingress_ifindex;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
+	__uint(max_entries, 4);
+} cpu_map SEC(".maps");
+
+SEC("xdp_redir")
+int xdp_redir_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&cpu_map, 1, 0);
+}
+
+SEC("xdp_dummy")
+int xdp_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+SEC("xdp_cpumap/dummy_cm")
+int xdp_dummy_cm(struct xdp_md *ctx)
+{
+	char fmt[] = "devmap redirect: dev %u len %u\n";
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	unsigned int len = data_end - data;
+
+	ingress_ifindex = ctx->ingress_ifindex;
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.26.2

