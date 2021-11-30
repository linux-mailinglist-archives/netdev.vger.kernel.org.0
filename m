Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE87C46339C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbhK3L70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:59:26 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43766 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbhK3L6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD51CB8185F;
        Tue, 30 Nov 2021 11:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0A6C53FD1;
        Tue, 30 Nov 2021 11:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273331;
        bh=Tox+0Tc1GENUap+msZpt4mQwiYud52e6H9DjZ1aAhaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=In2HoY2Q4anM+eR90UOFd67D3YvfnXr7p2YPm+IcYvtWXX94A9txZL+DwzUqKLkGj
         BWf9gblz/JjktKSkRGhlee0UEaO8rzzWeINV3LBknssR/B+TfcaoAwkXI2AkhOv6b+
         MyYUXk0xrd4tFk/NDIeq+sw9kilsjwYiryeMAa54i8gZQY7W8LHQWv2dEUn3VLN6GA
         CEkk6tL5Ftb6QSP/08bpO+dBfGiYmTjJNIYuDJZXIWeSLLnVHTY2DNJzMYynvgkPDE
         1CFpZr0gkHdrn7wKRD5JlBt3QSCP8vCCgUXIta1ZL9n9fD0wDrOZNjx6BuL2FcPUlT
         jwccrOzJdff1g==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 21/23] bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
Date:   Tue, 30 Nov 2021 12:53:05 +0100
Message-Id: <f46713e2ff5deb31de5abfa2b2267cb7e45056de.1638272239.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_{load,store}_bytes helpers.
and bpf_xdp_pointer/bpf_xdp_copy_buf utility routines.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_frags.c         | 96 +++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         | 42 ++++++++
 2 files changed, 138 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
new file mode 100644
index 000000000000..dd15ecaed050
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+
+void test_xdp_update_frags(void)
+{
+	const char *file = "./test_xdp_update_frags.o";
+	__u32 duration, retval, size;
+	struct bpf_object *obj;
+	int err, prog_fd;
+	__u32 *offset;
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
+	offset = (__u32 *)buf;
+	*offset = 16;
+	buf[*offset] = 0xaa;		/* marker at offset 16 (head) */
+	buf[*offset + 15] = 0xaa;	/* marker at offset 31 (head) */
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 128,
+				buf, &size, &retval, &duration);
+
+	/* test_xdp_update_frags: buf[16,31]: 0xaa -> 0xbb */
+	CHECK(err || retval != XDP_PASS || buf[16] != 0xbb || buf[31] != 0xbb,
+	      "128b", "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	free(buf);
+
+	buf = malloc(9000);
+	if (CHECK(!buf, "malloc()", "error:%s\n", strerror(errno)))
+		return;
+
+	memset(buf, 0, 9000);
+	offset = (__u32 *)buf;
+	*offset = 5000;
+	buf[*offset] = 0xaa;		/* marker at offset 5000 (frag0) */
+	buf[*offset + 15] = 0xaa;	/* marker at offset 5015 (frag0) */
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	/* test_xdp_update_frags: buf[5000,5015]: 0xaa -> 0xbb */
+	CHECK(err || retval != XDP_PASS ||
+	      buf[5000] != 0xbb || buf[5015] != 0xbb,
+	      "9000b", "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	memset(buf, 0, 9000);
+	offset = (__u32 *)buf;
+	*offset = 3510;
+	buf[*offset] = 0xaa;		/* marker at offset 3510 (head) */
+	buf[*offset + 15] = 0xaa;	/* marker at offset 3525 (frag0) */
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	/* test_xdp_update_frags: buf[3510,3525]: 0xaa -> 0xbb */
+	CHECK(err || retval != XDP_PASS ||
+	      buf[3510] != 0xbb || buf[3525] != 0xbb,
+	      "9000b", "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	memset(buf, 0, 9000);
+	offset = (__u32 *)buf;
+	*offset = 7606;
+	buf[*offset] = 0xaa;		/* marker at offset 7606 (frag0) */
+	buf[*offset + 15] = 0xaa;	/* marker at offset 7621 (frag1) */
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	/* test_xdp_update_frags: buf[7606,7621]: 0xaa -> 0xbb */
+	CHECK(err || retval != XDP_PASS ||
+	      buf[7606] != 0xbb || buf[7621] != 0xbb,
+	      "9000b", "err %d errno %d retval %d size %d\n",
+	      err, errno, retval, size);
+
+	free(buf);
+
+	bpf_object__close(obj);
+}
+
+void test_xdp_adjust_frags(void)
+{
+	if (test__start_subtest("xdp_adjust_frags"))
+		test_xdp_update_frags();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
new file mode 100644
index 000000000000..5801f05219db
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
@@ -0,0 +1,42 @@
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
+SEC("xdp_mb/xdp_adjust_frags")
+int _xdp_adjust_frags(struct xdp_md *xdp)
+{
+	__u8 *data_end = (void *)(long)xdp->data_end;
+	__u8 *data = (void *)(long)xdp->data;
+	__u8 val[16] = {};
+	__u32 offset;
+	int err;
+
+	if (data + sizeof(__u32) > data_end)
+		return XDP_DROP;
+
+	offset = *(__u32 *)data;
+	err = bpf_xdp_load_bytes(xdp, offset, val, sizeof(val));
+	if (err < 0)
+		return XDP_DROP;
+
+	if (val[0] != 0xaa || val[15] != 0xaa) /* marker */
+		return XDP_DROP;
+
+	val[0] = 0xbb; /* update the marker */
+	val[15] = 0xbb;
+	err = bpf_xdp_store_bytes(xdp, offset, val, sizeof(val));
+	if (err < 0)
+		return XDP_DROP;
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.31.1

