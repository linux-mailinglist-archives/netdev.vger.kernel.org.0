Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97FE71D047E
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbgEMBqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732114AbgEMBqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 21:46:20 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D7820714;
        Wed, 13 May 2020 01:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589334379;
        bh=Vw2FCOouxN7bROtFES0en98jMRaoYmLfRNQ/ko0YO0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kur1NyVN0m1RWD1Fonn8EkO3f6QZba9Ui9IqMJcZ0g7iJqjMBSmopVzXILjyzpkiJ
         s72ofWi+sKdB00o9LYIaQBqRHK6JmbM7h6dD0AAaBgTbs2Nh2JsL84nj6gcmXU1eYP
         6Zfz+jKsDiuPsRiBHIlN49ePdEsz/ah4Yd9/CAFQ=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v5 bpf-next 10/11] selftest: Add xdp_egress attach tests
Date:   Tue, 12 May 2020 19:46:06 -0600
Message-Id: <20200513014607.40418-11-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200513014607.40418-1-dsahern@kernel.org>
References: <20200513014607.40418-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add xdp_egress attach tests:
1. verify egress programs cannot access ingress entries in xdp context
2. verify ability to load, attach, and detach xdp egress to a device.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 .../bpf/prog_tests/xdp_egress_attach.c        | 56 +++++++++++++++++++
 .../selftests/bpf/progs/test_xdp_egress.c     | 12 ++++
 .../bpf/progs/test_xdp_egress_fail.c          | 16 ++++++
 3 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
new file mode 100644
index 000000000000..5253754b27de
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/if_link.h>
+#include <test_progs.h>
+
+#define IFINDEX_LO 1
+
+void test_xdp_egress_attach(void)
+{
+	struct bpf_prog_load_attr attr = {
+		.prog_type = BPF_PROG_TYPE_XDP,
+		.expected_attach_type = BPF_XDP_EGRESS,
+	};
+	struct bpf_prog_info info = {};
+	__u32 id, len = sizeof(info);
+	struct bpf_object *obj;
+	__u32 duration = 0;
+	int err, fd = -1;
+
+	/* should fail - accesses rx queue info */
+	attr.file = "./test_xdp_egress_fail.o",
+	err = bpf_prog_load_xattr(&attr, &obj, &fd);
+	if (CHECK(err == 0 && fd >= 0, "xdp_egress with rx failed to load",
+		 "load of xdp_egress with rx succeeded instead of failed"))
+		return;
+
+	attr.file = "./test_xdp_egress.o",
+	err = bpf_prog_load_xattr(&attr, &obj, &fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	err = bpf_obj_get_info_by_fd(fd, &info, &len);
+	if (CHECK_FAIL(err))
+		goto out_close;
+
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_EGRESS_MODE);
+	if (CHECK(err, "xdp attach", "xdp attach failed"))
+		goto out_close;
+
+	err = bpf_get_link_xdp_id(IFINDEX_LO, &id, XDP_FLAGS_EGRESS_MODE);
+	if (CHECK(err || id != info.id, "id_check",
+		  "loaded prog id %u != id %u, err %d", info.id, id, err))
+		goto out;
+
+out:
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, -1, XDP_FLAGS_EGRESS_MODE);
+	if (CHECK(err, "xdp detach", "xdp detach failed"))
+		goto out_close;
+
+	err = bpf_get_link_xdp_id(IFINDEX_LO, &id, XDP_FLAGS_EGRESS_MODE);
+	if (CHECK(err || id, "id_check",
+		  "failed to detach program %u", id))
+		goto out;
+
+out_close:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_egress.c b/tools/testing/selftests/bpf/progs/test_xdp_egress.c
new file mode 100644
index 000000000000..0477e8537b7f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_egress.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("xdp_egress")
+int xdp_egress_good(struct xdp_md *ctx)
+{
+	__u32 idx = ctx->egress_ifindex;
+
+	return idx == 1 ? XDP_DROP : XDP_PASS;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c b/tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c
new file mode 100644
index 000000000000..76b47b1d3bc3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c
@@ -0,0 +1,16 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("xdp_egress")
+int xdp_egress_fail(struct xdp_md *ctx)
+{
+	__u32 rxq = ctx->rx_queue_index;
+	__u32 idx = ctx->ingress_ifindex;
+
+	if (idx == 1)
+		return XDP_DROP;
+
+	return rxq ? XDP_DROP : XDP_PASS;
+}
-- 
2.21.1 (Apple Git-122.3)

