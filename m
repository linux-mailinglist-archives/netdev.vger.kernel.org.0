Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91811BB1A1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgD0Wq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726420AbgD0Wqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:46:52 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55DBE21835;
        Mon, 27 Apr 2020 22:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588027611;
        bh=Vw2FCOouxN7bROtFES0en98jMRaoYmLfRNQ/ko0YO0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P9hEgAB/Zxh7OkWD/9Pcim0Sj+Rw4r68x9JHcDId5H+y40GMCFcuawCZPQPFn4/8w
         apx6hHhIkt3iKg2EbDW0xc7WfQ2yIyVkPRJu6cVPOV2XgPWmKMwy3PZowQF5/DxJ5n
         UIIf3dHeQJwPDb3D0GnC2A+HjNr/zD5t5cXjQI1c=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v4 bpf-next 14/15] selftest: Add xdp_egress attach tests
Date:   Mon, 27 Apr 2020 16:46:32 -0600
Message-Id: <20200427224633.15627-15-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200427224633.15627-1-dsahern@kernel.org>
References: <20200427224633.15627-1-dsahern@kernel.org>
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

