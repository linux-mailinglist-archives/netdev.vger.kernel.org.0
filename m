Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC07495D7B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349911AbiAUKMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:12:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36330 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379912AbiAUKMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:12:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B33561A0C;
        Fri, 21 Jan 2022 10:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4764C340E3;
        Fri, 21 Jan 2022 10:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759935;
        bh=jhGct+Fto3ArkR8TfmaljJhn4Z6giszo8mbJD9CbnfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nhl0t7r4avQNuuGTlFK1O11ID+oElI6fKy4Kv7KoknalwPzejZErViNua++dPBEQc
         oTMX7RoV60sQQzAR6nexxqhZlKzg15BRE3G8LqUAdrif4rvSk8ArBS1dN9p43iZpgH
         4zB4QWexhn0id42VS8UY5bQ59gkZCgIjMD+s8wZLr785snqm9e8bB/6CfSAWEFHqhr
         cidFRijg5cTTSQ4JxmtLsyIQrWLNYm7ldDboHzRTMIo4L14An7wjcbV2bFiazLHcqL
         /LIJl/LHl1s5Jcn0cYN1n8E/+2iuP5dea5+B5c9YHT7jsEVNzNMIBZJj77fLYgtjpc
         qJNw1gJrVajzQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 21/23] bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
Date:   Fri, 21 Jan 2022 11:10:04 +0100
Message-Id: <2c99ae663a5dcfbd9240b1d0489ad55dea4f4601.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
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
 .../bpf/prog_tests/xdp_adjust_frags.c         | 104 ++++++++++++++++++
 .../bpf/progs/test_xdp_update_frags.c         |  42 +++++++
 2 files changed, 146 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
new file mode 100644
index 000000000000..31c188666e81
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -0,0 +1,104 @@
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
+	if (!ASSERT_OK_PTR(buf, "alloc buf 128b"))
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
+	ASSERT_OK(err, "xdp_update_frag");
+	ASSERT_EQ(retval, XDP_PASS, "xdp_update_frag retval");
+	ASSERT_EQ(buf[16], 0xbb, "xdp_update_frag buf[16]");
+	ASSERT_EQ(buf[31], 0xbb, "xdp_update_frag buf[31]");
+
+	free(buf);
+
+	buf = malloc(9000);
+	if (!ASSERT_OK_PTR(buf, "alloc buf 9Kb"))
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
+	ASSERT_OK(err, "xdp_update_frag");
+	ASSERT_EQ(retval, XDP_PASS, "xdp_update_frag retval");
+	ASSERT_EQ(buf[5000], 0xbb, "xdp_update_frag buf[5000]");
+	ASSERT_EQ(buf[5015], 0xbb, "xdp_update_frag buf[5015]");
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
+	ASSERT_OK(err, "xdp_update_frag");
+	ASSERT_EQ(retval, XDP_PASS, "xdp_update_frag retval");
+	ASSERT_EQ(buf[3510], 0xbb, "xdp_update_frag buf[3510]");
+	ASSERT_EQ(buf[3525], 0xbb, "xdp_update_frag buf[3525]");
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
+	ASSERT_OK(err, "xdp_update_frag");
+	ASSERT_EQ(retval, XDP_PASS, "xdp_update_frag retval");
+	ASSERT_EQ(buf[7606], 0xbb, "xdp_update_frag buf[7606]");
+	ASSERT_EQ(buf[7621], 0xbb, "xdp_update_frag buf[7621]");
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
index 000000000000..2a3496d8e327
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
+SEC("xdp.frags")
+int xdp_adjust_frags(struct xdp_md *xdp)
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
2.34.1

