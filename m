Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C6C402908
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344497AbhIGMik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:45890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344411AbhIGMiV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 08:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 483646108D;
        Tue,  7 Sep 2021 12:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631018235;
        bh=jDVS9YsWEmyKRrELFSoOnde96d+BRIEJy33TX2T4QC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i18fPaFRZt6vEuzDNBKrlshOhp3KvhTxjVZDhYk/HuYS/mjecI9mDYjKeJX5UBM20
         pvz9vwBs4N30plzhH+goLadNCO5h60upLEi2AMBuOoo1ZRusleWsuhtgjEpsmhrhdE
         8RDcW36XdH1GSJ/cBmPuEZM/7jIdgBiqzB4GCRKHdG4XZNC4NOdESKme1ZDBYonx8d
         tcrtrTiYqdRApNKzkmFNCMnY1vegtPD0bi+TeuBd8IBhycFbp1+/rsNGUx9g3sTHUN
         x+swQCYauHImaQsnwcjTamHJzk/f/Y0LDFBrVTQV+auyWYSonDcPLl14MUS7cYvIfn
         DOPn2xSSRSbZw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v13 bpf-next 18/18] bpf: add bpf_xdp_adjust_data selftest
Date:   Tue,  7 Sep 2021 14:35:22 +0200
Message-Id: <2a6c8fb38a8f9dcc41bc51dbdae69ed76a26e158.1631007211.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631007211.git.lorenzo@kernel.org>
References: <cover.1631007211.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_adjust_data helper.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_data.c          | 63 +++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         | 45 +++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c
new file mode 100644
index 000000000000..dfb8bce8ff55
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_data.c
@@ -0,0 +1,63 @@
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
+	buf[*offset] = 0xaa; /* marker at offset 16 */
+
+	err = bpf_prog_test_run(prog_fd, 1, buf, 128,
+				buf, &size, &retval, &duration);
+
+	/* test_xdp_update_frags: buf[16]: 0xaa -> 0xbb */
+	CHECK(err || retval != XDP_PASS || buf[16] != 0xbb,
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
+	buf[*offset] = 0xaa; /* marker at offset 5000 (frag0) */
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
index 000000000000..d06504228265
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
@@ -0,0 +1,45 @@
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
+	int base_offset, ret = XDP_DROP;
+	__u32 offset;
+
+	if (data + sizeof(__u32) > data_end)
+		return XDP_DROP;
+
+	offset = *(__u32 *)data;
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

