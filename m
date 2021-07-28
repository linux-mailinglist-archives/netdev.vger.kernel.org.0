Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E543D8AEE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhG1JkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231524AbhG1JkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C5A560FE7;
        Wed, 28 Jul 2021 09:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465211;
        bh=L6HltSPqAJA403xBR4Z2bmI0frjkR0Z1YCQaSySnqII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/6laCG/xgemgCoPf05csZBNNoiaLhgcdLO3uYHVZvTQ8JTiDyBpAOFksjcxxKWt4
         lQ2WnZoxWCEN4zrJHIAUQIF83j96USyFlx4DNC/KYAl28TIRTYjLlC9YJjpH/tQdlv
         BOv8TvilhTPpqXkUyYE9MYqeqDT/VCL/UdednIJBEirrBMokgV7chBvZ4D7VdrTBb1
         xT3xVaMTRO3PNXn2XnBcMmvMtoYprl4Oc+H1INApVQW4n0h2DTwHp6+UaEgKPXxZKr
         m9aOVIO0zEKRjRWQjm/FVBA5lN8x6cMFtiYXogsGdhwiLPbkYInbep1tZBa9t/SAUn
         jTsRO84iem+AA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 18/18] bpf: add bpf_xdp_adjust_data selftest
Date:   Wed, 28 Jul 2021 11:38:23 +0200
Message-Id: <8761f8ba2fd7f2940017c5b4c2aac1c6beeed066.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_adjust_data helper.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_data.c          | 55 +++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         | 49 +++++++++++++++++
 2 files changed, 104 insertions(+)
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
index 000000000000..2392cc3b6ba5
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
@@ -0,0 +1,49 @@
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
+	int ret = XDP_DROP;
+	int data_len;
+
+	if (data + sizeof(__u32) > data_end)
+		return XDP_DROP;
+
+	data_len = bpf_xdp_adjust_data(xdp, offset);
+	if (data_len < 0)
+		return XDP_DROP;
+
+	if (data_len > 5000)
+		goto out;
+
+	data_end = (void *)(long)xdp->data_end;
+	data = (void *)(long)xdp->data;
+	offset -= data_len; /* offset in frag0 */
+
+	if (data + offset + 1 > data_end)
+		goto out;
+
+	if (data[offset] != 0xaa) /* marker */
+		goto out;
+
+	data[offset] = 0xbb; /* update the marker */
+	ret = XDP_PASS;
+out:
+	bpf_xdp_adjust_data(xdp, 0);
+	return ret;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.31.1

