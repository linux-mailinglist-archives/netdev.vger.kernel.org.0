Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF1B42F1ED
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 15:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbhJONMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 09:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239273AbhJONMu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 09:12:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCEBC611C8;
        Fri, 15 Oct 2021 13:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634303444;
        bh=v/xKKm7pK45erNzDtEBmB1EkqYKDVshX9hXRWweMUtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2A6EVHs3ZYc8gM31JawXS25skMDHKFsyzxT2vHP0QVj/51nKEG4wqQTxRMpYDP8k
         wJu9Gy8sVs3koTkJcBYeuDreGGTmMgAv5Ez/7sjrEKlsbwllCle1lM337eb2O4gPIx
         7ChRkLJbCQTwu5IpLs3xLErnPPYAvVr0GWhzyQLovGTMew3SbFtNOu0Xsyj/p0nvhd
         +W5uM10OdbtO8XJqzqrN3EPMHtkSU9iCTM5iggwvgfT3aDVeioP5qiiy6ae7EVcJOI
         Vs8snKih9nrBnrXMZT3LzWWytErE4dCRheRcVrKA28DGxbQ07U/r90BbYABohO7TAN
         RkQTccT6C5N1w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v16 bpf-next 20/20] bpf: introduce bpf_xdp_{load,store}_bytes selftest
Date:   Fri, 15 Oct 2021 15:08:57 +0200
Message-Id: <829038ab1f3c84e5f0508675f9dfaf5617984049.1634301224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1634301224.git.lorenzo@kernel.org>
References: <cover.1634301224.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_{load,store}_bytes helpers.
and bpf_xdp_pointer/bpf_xdp_copy_buf utility routines.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c                        |  2 +-
 .../bpf/prog_tests/xdp_adjust_frags.c         | 81 +++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         | 42 ++++++++++
 3 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d5ae2716d08b..dd64721988fd 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8098,8 +8098,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("syscall",		SYSCALL, 0, SEC_SLEEPABLE),
 	SEC_DEF("xdp_devmap/",		XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
 	SEC_DEF("xdp_cpumap/",		XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
-	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("xdp_mb/",		XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX | SEC_XDP_MB),
+	SEC_DEF("xdp",			XDP, BPF_XDP, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),
 	SEC_DEF("perf_event",		PERF_EVENT, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_in",		LWT_IN, 0, SEC_NONE | SEC_SLOPPY_PFX),
 	SEC_DEF("lwt_out",		LWT_OUT, 0, SEC_NONE | SEC_SLOPPY_PFX),
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
new file mode 100644
index 000000000000..53febbcb8fd4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -0,0 +1,81 @@
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
+	buf[*offset] = 0xaa;		/* marker at offset 16 */
+	buf[*offset + 15] = 0xaa;	/* marker at offset 31 */
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

