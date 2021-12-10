Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6CA470A30
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343595AbhLJTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242642AbhLJTUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:20:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B46C061746;
        Fri, 10 Dec 2021 11:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93AA8B829CF;
        Fri, 10 Dec 2021 19:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C31C341CE;
        Fri, 10 Dec 2021 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163807;
        bh=LAv9uTaYn1b9AgkVDwqlGxXXoUkWf+VWqkpZ8Py2C4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkapLJAGRM9EXg4OftXbK8YKVbh+OjwbOwvbydTE5TxI+Zbd4fWwepcEDWUbV2OUR
         zAjVPXYlnRhp0qQGy0dprZk6lZ9BaeGmownF0cxFqAAydIZzKtEeZsitnJsR7l4zm1
         /yd7UklvLwt2106XyMPtRwG2C9/NWmz0EcDPT11KAa5TC4J7QUgTjvS+OVEwXJp+E9
         8XHHF3DutclHzmwCzCBQuyXyEYW1KvP3UCXFOTmqaTIsuZxmQkjx6cIzXkeTQ3if5V
         McY6/2OBX7cvVOHy8GYd6q0RfhDmMfPX5SBIBU7QCJ/ZabUaddfqdlTzqSzLApfOUq
         KH69iZpkEi45Q==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 21/23] bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
Date:   Fri, 10 Dec 2021 20:14:28 +0100
Message-Id: <02ec4b2d3d47dd104676583b8eea2a874d87bc9a.1639162846.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_{load,store}_bytes helpers.
and bpf_xdp_pointer/bpf_xdp_copy_buf utility routines.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_frags.c         | 103 ++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         |  42 +++++++
 2 files changed, 145 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
new file mode 100644
index 000000000000..4b0d04fb1041
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+
+void test_xdp_update_frags(void)
+{
+	const char *file = "./test_xdp_update_frags.o";
+	__u32 duration, retval, size;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int err, prog_fd;
+	__u32 *offset;
+	__u8 *buf;
+
+	obj = bpf_object__open(file);
+	if (libbpf_get_error(obj))
+		return;
+
+	prog = bpf_object__next_program(obj, NULL);
+	if (bpf_object__load(obj))
+		return;
+
+	prog_fd = bpf_program__fd(prog);
+
+	buf = malloc(128);
+	if (CHECK(!buf, "malloc()", "error:%s\n", strerror(errno)))
+		goto out;
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
+		goto out;
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
+out:
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
2.33.1

