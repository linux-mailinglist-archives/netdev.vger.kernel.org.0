Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB91C1E8AFE
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgE2WHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:07:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgE2WH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 18:07:27 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBE312145D;
        Fri, 29 May 2020 22:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590790046;
        bh=wkiI9f8oimnx01hAfmXraa6dLlJ6mIXy8rBl03y0oEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAyr6b6qg/NiNJbpOpcD6+OsAChxcpEGCAsrc0kmL7m0i5XjAvf9cMRitTseqUupo
         F1YbLKmp6rFVWuouyniW2SLgJRjHqsFeC9M2Jb/ZRZ2enHfnVMztz9EONidgFjLzRD
         wZbJ5bj2RUg+y77GNFaD2dmmM2C1gvC5BAoaWnkg=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, toke@redhat.com, lorenzo@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH v4 bpf-next 5/5] selftest: Add tests for XDP programs in devmap entries
Date:   Fri, 29 May 2020 16:07:16 -0600
Message-Id: <20200529220716.75383-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200529220716.75383-1-dsahern@kernel.org>
References: <20200529220716.75383-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to verify ability to add an XDP program to a
entry in a DEVMAP.

Add negative tests to show DEVMAP programs can not be
attached to devices as a normal XDP program, and accesses
to egress_ifindex require BPF_XDP_DEVMAP attach type.

Signed-off-by: David Ahern <dsahern@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 .../bpf/prog_tests/xdp_devmap_attach.c        | 97 +++++++++++++++++++
 .../bpf/progs/test_xdp_devmap_helpers.c       | 22 +++++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  | 44 +++++++++
 3 files changed, 163 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
new file mode 100644
index 000000000000..8454d5b96058
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <uapi/linux/bpf.h>
+#include <linux/if_link.h>
+#include <test_progs.h>
+
+#include "test_xdp_devmap_helpers.skel.h"
+#include "test_xdp_with_devmap_helpers.skel.h"
+
+#define IFINDEX_LO 1
+
+struct bpf_devmap_val {
+	u32 ifindex;   /* device index */
+	union {
+		int fd;  /* prog fd on map write */
+		u32 id;  /* prog id on map read */
+	} bpf_prog;
+};
+
+void test_xdp_with_devmap_helpers(void)
+{
+	struct test_xdp_with_devmap_helpers *skel;
+	struct bpf_prog_info info = {};
+	struct bpf_devmap_val val = {
+		.ifindex = IFINDEX_LO,
+	};
+	__u32 len = sizeof(info);
+	__u32 duration, idx = 0;
+	int err, dm_fd, map_fd;
+
+
+	skel = test_xdp_with_devmap_helpers__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		perror("test_xdp_with_devmap_helpers__open_and_load");
+		return;
+	}
+
+	/* can not attach program with DEVMAPs that allow programs
+	 * as xdp generic
+	 */
+	dm_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
+	CHECK(err == 0, "Generic attach of program with 8-byte devmap",
+	      "should have failed\n");
+
+	dm_fd = bpf_program__fd(skel->progs.xdp_dummy_dm);
+	map_fd = bpf_map__fd(skel->maps.dm_ports);
+	err = bpf_obj_get_info_by_fd(dm_fd, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_close;
+
+	val.bpf_prog.fd = dm_fd;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	CHECK(err, "Add program to devmap entry",
+	      "err %d errno %d\n", err, errno);
+
+	err = bpf_map_lookup_elem(map_fd, &idx, &val);
+	CHECK(err, "Read devmap entry", "err %d errno %d\n", err, errno);
+	CHECK(info.id != val.bpf_prog.id, "Expected program id in devmap entry",
+	      "expected %u read %u\n", info.id, val.bpf_prog.id);
+
+	/* can not attach BPF_XDP_DEVMAP program to a device */
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
+	CHECK(err == 0, "Attach of BPF_XDP_DEVMAP program",
+	      "should have failed\n");
+
+	val.ifindex = 1;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_prog);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	CHECK(err == 0, "Add non-BPF_XDP_DEVMAP program to devmap entry",
+	      "should have failed\n");
+
+out_close:
+	test_xdp_with_devmap_helpers__destroy(skel);
+}
+
+void test_neg_xdp_devmap_helpers(void)
+{
+	struct test_xdp_devmap_helpers *skel;
+	__u32 duration;
+
+	skel = test_xdp_devmap_helpers__open_and_load();
+	if (CHECK(skel,
+		  "Load of XDP program accessing egress ifindex without attach type",
+		  "should have failed\n")) {
+		test_xdp_devmap_helpers__destroy(skel);
+	}
+}
+
+
+void test_xdp_devmap_attach(void)
+{
+	if (test__start_subtest("DEVMAP with programs in entries"))
+		test_xdp_with_devmap_helpers();
+
+	if (test__start_subtest("Verifier check of DEVMAP programs"))
+		test_neg_xdp_devmap_helpers();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
new file mode 100644
index 000000000000..e5c0f131c8a7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap_helpers.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/* fails to load without expected_attach_type = BPF_XDP_DEVMAP
+ * because of access to egress_ifindex
+ */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+SEC("xdp_dm_log")
+int xdpdm_devlog(struct xdp_md *ctx)
+{
+	char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	unsigned int len = data_end - data;
+
+	bpf_trace_printk(fmt, sizeof(fmt),
+			 ctx->ingress_ifindex, ctx->egress_ifindex, len);
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
new file mode 100644
index 000000000000..deef0e050863
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 4);
+} dm_ports SEC(".maps");
+
+SEC("xdp_redir")
+int xdp_redir_prog(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&dm_ports, 1, 0);
+}
+
+/* invalid program on DEVMAP entry;
+ * SEC name means expected attach type not set
+ */
+SEC("xdp_dummy")
+int xdp_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+/* valid program on DEVMAP entry via SEC name;
+ * has access to egress and ingress ifindex
+ */
+SEC("xdp_devmap")
+int xdp_dummy_dm(struct xdp_md *ctx)
+{
+	char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	unsigned int len = data_end - data;
+
+	bpf_trace_printk(fmt, sizeof(fmt),
+			 ctx->ingress_ifindex, ctx->egress_ifindex, len);
+
+	return XDP_PASS;
+}
+char _license[] SEC("license") = "GPL";
-- 
2.21.1 (Apple Git-122.3)

