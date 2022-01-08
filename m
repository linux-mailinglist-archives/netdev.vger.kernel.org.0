Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0689C48837C
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiAHLzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiAHLzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:55:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1E8C061574;
        Sat,  8 Jan 2022 03:55:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ACDC60F32;
        Sat,  8 Jan 2022 11:55:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E832BC36AF4;
        Sat,  8 Jan 2022 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642921;
        bh=MDUV4HcR8eb85GyzXZRE8OkK5zkoQTUU/ICf6NhxZbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7tAcvCyC23P3Dw1vR55aSEYO9VwL+pgu+jhtzDGJTdp20XuAeMnCxih3xaQRG6W2
         cPg+/bhYpO2tgwdpEiwMhPI1cfhhJwhvBLU5UQHuUxZhLb1h0CTcn7YSMDf19p54zM
         Yj6gGHDUkRv9Bc9J2YcGt3Vlnjsz++WUJgV57bsmFkOJUZCBX2X40HnQtffzozQOfP
         b2m3baOQpWF+0D/zaazf9daMh1HGM/szIY6Z5rrS4LByV1xYw9fOHPWrpUA+ctyuHs
         u0KZWCEq6saBTWd29VzbaDFf2EGPnvvsEP/e/krhBHcW9PV3Me9S6tnlGmkJ2uTz/w
         s3yWBXRrcWxwA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 21/23] bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
Date:   Sat,  8 Jan 2022 12:53:24 +0100
Message-Id: <a366bb418e0ef001cc7b27f40ff9621382791028.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce kernel selftest for new bpf_xdp_{load,store}_bytes helpers.
and bpf_xdp_pointer/bpf_xdp_copy_buf utility routines.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
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

