Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184F51E3477
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 03:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbgE0BJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 21:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728161AbgE0BJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 21:09:13 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1986F20EDD;
        Wed, 27 May 2020 01:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590541752;
        bh=Y64wnXf6v+JFnVJpTXFW/UlNHHh3u5MuLlQYvsRlkF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0Fpj7jwSYzQ3H7UlEUoB5VKFwDh4zxpY/5lwobPbCkur6Cx7wk2ujtLlS1ZzO+h2
         yKTejYFFM7kvKUMDvJv5ZJcK03bUcBhrbtUna+T33zazTlMG5t+bIPYUgdYm6Gis7j
         qqn9lrCOEftDCS5e+bnm/k4FsVAXTOCjW4tzqpBU=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        toke@redhat.com, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, dsahern@gmail.com, David Ahern <dsahern@kernel.org>
Subject: [PATCH bpf-next 5/5] selftest: Add tests for XDP programs in devmap entries
Date:   Tue, 26 May 2020 19:09:05 -0600
Message-Id: <20200527010905.48135-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200527010905.48135-1-dsahern@kernel.org>
References: <20200527010905.48135-1-dsahern@kernel.org>
MIME-Version: 1.0
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
---
 .../bpf/prog_tests/xdp_devmap_attach.c        | 101 ++++++++++++++++++
 .../selftests/bpf/progs/test_xdp_devmap.c     |  19 ++++
 .../bpf/progs/test_xdp_with_devmap.c          |  17 +++
 3 files changed, 137 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_devmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
new file mode 100644
index 000000000000..4f608bde9cbe
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/if_link.h>
+#include <test_progs.h>
+
+#define IFINDEX_LO 1
+
+struct devmap_ext_val {
+	u32 ifindex;    /* must be first for compat with 4-byte values */
+	union {
+		int prog_fd;  /* prog fd on write */
+		u32 prog_id;  /* prog id on read */
+	};
+};
+
+void test_xdp_devmap_attach(void)
+{
+	struct bpf_prog_load_attr attr = {
+		.prog_type = BPF_PROG_TYPE_XDP,
+	};
+	struct bpf_object *obj, *dm_obj = NULL;
+	int err, dm_fd = -1, fd = -1, map_fd;
+	struct bpf_prog_info info = {};
+	struct devmap_ext_val val = {
+		.ifindex = IFINDEX_LO,
+	};
+	__u32 id, len = sizeof(info);
+	__u32 duration = 0, idx = 0;
+
+	attr.file = "./test_xdp_with_devmap.o",
+	err = bpf_prog_load_xattr(&attr, &obj, &fd);
+	if (CHECK(err, "load of xdp program with 8-byte devmap",
+		  "err %d errno %d\n", err, errno))
+		return;
+
+	/* can not attach program with DEVMAPs that allow programs */
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
+	CHECK(err == 0, "Generic attach of program with 8-byte devmap",
+	      "should have failed\n");
+
+	map_fd = bpf_object__find_map_fd_by_name(obj, "dm_ports");
+	if (CHECK(map_fd < 0, "Lookup dm_ports map",
+		  "err %d errno %d\n", err, errno))
+		goto out_close;
+
+	/*
+	 * basic test - load program to be installed in devmap;
+	 * also verifies access to ingress and egress ifindices.
+	 */
+	attr.expected_attach_type = BPF_XDP_DEVMAP;
+	attr.file = "./test_xdp_devmap.o";
+	err = bpf_prog_load_xattr(&attr, &dm_obj, &dm_fd);
+	if (CHECK(err, "Load of BPF_XDP_DEVMAP program",
+		  "err %d errno %d\n", err, errno))
+		goto out_close;
+
+	err = bpf_obj_get_info_by_fd(dm_fd, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_close;
+
+	val.prog_fd = dm_fd;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	CHECK(err, "Add program to devmap entry",
+	      "err %d errno %d\n", err, errno);
+
+	err = bpf_map_lookup_elem(map_fd, &id, &val);
+	CHECK(err, "Read devmap entry",
+	      "err %d errno %d\n", err, errno);
+	CHECK(info.id != val.prog_id, "Expected program id in devmap entry",
+	      "expected %u read %u\n", info.id, val.prog_id);
+
+	/* can not attach BPF_XDP_DEVMAP program to a device */
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
+	CHECK(err == 0, "Attach of BPF_XDP_DEVMAP program",
+	      "should have failed\n");
+
+	bpf_object__close(dm_obj);
+
+	/* Load of BPF_XDP_DEVMAP as XDP should fail because of egress index */
+	attr.expected_attach_type = 0;
+	err = bpf_prog_load_xattr(&attr, &dm_obj, &dm_fd);
+	if (CHECK(err == 0,
+		  "Load of XDP program accessing egress ifindex without attach type",
+		  "should have failed\n"))
+		bpf_object__close(dm_obj);
+
+	attr.file = "./xdp_dummy.o";
+	err = bpf_prog_load_xattr(&attr, &dm_obj, &dm_fd);
+	if (CHECK_FAIL(err))
+		goto out_close;
+
+	val.ifindex = 1;
+	val.prog_fd = dm_fd;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	CHECK(err == 0, "Add non-BPF_XDP_DEVMAP program to devmap entry",
+	      "should have failed\n");
+
+	bpf_object__close(dm_obj);
+
+out_close:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_devmap.c b/tools/testing/selftests/bpf/progs/test_xdp_devmap.c
new file mode 100644
index 000000000000..64fc2c3cae01
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_devmap.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+/* program inserted into devmap entry */
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("xdp_devmap_log")
+int xdpdm_devlog(struct xdp_md *ctx)
+{
+	char fmt[] = "devmap redirect: dev %u -> dev %u len %u\n";
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	unsigned int len = data_end - data;
+
+	bpf_trace_printk(fmt, sizeof(fmt), ctx->ingress_ifindex, ctx->egress_ifindex, len);
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
new file mode 100644
index 000000000000..cb76c9859e80
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") dm_ports = {
+	.type = BPF_MAP_TYPE_DEVMAP,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u32) * 2,
+	.max_entries = 4,
+};
+
+SEC("xdp_devmap")
+int xdp_with_devmap(struct xdp_md *ctx)
+{
+	return bpf_redirect_map(&dm_ports, 1, 0);
+}
-- 
2.21.1 (Apple Git-122.3)

