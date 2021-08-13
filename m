Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB93EB4D9
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240472AbhHMLuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:50:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240426AbhHMLuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 07:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D84B6109E;
        Fri, 13 Aug 2021 11:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628855424;
        bh=sb2BeUs+EdYXtkzmBkfivuB9XqFS6eMIn4b9huUVAyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smqCOf+yiR2GcdPqV5sEOIc7NRd+SP9YrPttS6L0xQGXGvqoagqziK3YWVtJrFL0s
         PYAam0o91L6i691RIACbSa9Pqqc0Cez7IZlx2NbQ1r62uQql4k5U962Po/dKlACosL
         GC9uvn/S29eo0iLLM4E5Opi+ITZg1Fe0xi/4jHSf4GmB7HQcwnyQWJ+4JEI+AzoXSL
         YekXXZijMSTQV0CqjfhztBA9eY5PMatcK0805ToBQoRRhAjpgp4xQo1qk1fNlNoZH+
         VLM7kDjuLM8r7kZoIxgZsT7Y7/PnIvCweUYhk9ZIIE1Z/QbZXQxwTjP08UwFgSwdf5
         /LWxG1xTJ8c1g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v11 bpf-next 18/18] bpf: add bpf_xdp_adjust_data selftest
Date:   Fri, 13 Aug 2021 13:47:59 +0200
Message-Id: <5026e9756e7a065581f31eae240e99552417f7fb.1628854454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_adjust_data helper.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_data.c          | 55 +++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         | 41 ++++++++++++++
 2 files changed, 96 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c
new file mode 100644
index 000000000000..a3e098b72fc9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+
+void test_xdp_update_frag(void)
+{
+	const char *file = "./test_xdp_update_frags.o";
+	__u32 duration, retval, size;
+	struct bpf_object *obj;
+	int err, prog_fd;
+	__u8 *buf;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	buf = malloc(128);
+	if (CHECK(!buf, "malloc()", "error:%s\n", strerror(errno)))
+		return;
+
+	memset(buf, 0, 128);
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 128,
+				buf, &size, &retval, &duration);
+	free(buf);
+
+	CHECK(err || retval != XDP_DROP,
+	      "128b", "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	buf = malloc(9000);
+	if (CHECK(!buf, "malloc()", "error:%s\n", strerror(errno)))
+		return;
+
+	memset(buf, 0, 9000);
+	buf[5000] = 0xaa; /* marker at offset 5000 (frag0) */
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	/* test_xdp_update_frags: buf[5000]: 0xaa -> 0xbb */
+	CHECK(err || retval != XDP_PASS || buf[5000] != 0xbb,
+	      "9000b", "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	free(buf);
+
+	bpf_object__close(obj);
+}
+
+void test_xdp_adjust_data(void)
+{
+	if (test__start_subtest("xdp_adjust_data"))
+		test_xdp_update_frag();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
new file mode 100644
index 000000000000..c2d5772007f3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ */
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <bpf/bpf_helpers.h>
+
+int _version SEC("version") = 1;
+
+SEC("xdp_adjust_frags")
+int _xdp_adjust_frags(struct xdp_md *xdp)
+{
+	__u8 *data_end = (void *)(long)xdp->data_end;
+	__u8 *data = (void *)(long)xdp->data;
+	__u32 offset = 5000; /* marker offset */
+	int base_offset, ret = XDP_DROP;
+
+	base_offset = bpf_xdp_adjust_data(xdp, offset);
+	if (base_offset < 0 || base_offset > offset)
+		return XDP_DROP;
+
+	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(long)xdp->data;
+
+	if (data + 1 > data_end)
+		goto out;
+
+	if (*data != 0xaa) /* marker */
+		goto out;
+
+	*data = 0xbb; /* update the marker */
+	ret = XDP_PASS;
+out:
+	bpf_xdp_adjust_data(xdp, 0);
+	return ret;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.31.1

