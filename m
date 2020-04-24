Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C331B6B2B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgDXCMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgDXCMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:12:14 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B12021655;
        Fri, 24 Apr 2020 02:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694334;
        bh=YEKnfhpruNzG9WjFUG1Pl8waCRTar5/8EQmUHJsdR6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DaOun2d/MDYkDnuvBli2aW6FavgHM/0/IZOZjidv7QjJYNDTArl+Hd++3RNp/sAcN
         VngKKPEqHEZXUZfshVSvul8VrMu5BSUk8GPWIbtKwZbTOvyNG60QDW4eSHSlYwguEw
         GeJnKHoiSwhqul3Uc6KoakEGT0fFYRgZN4GbNXAo=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 16/17] selftest: Add xdp_egress attach tests
Date:   Thu, 23 Apr 2020 20:11:47 -0600
Message-Id: <20200424021148.83015-17-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
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
 .../bpf/prog_tests/xdp_egress_attach.c        | 62 +++++++++++++++++++
 .../selftests/bpf/progs/test_xdp_egress.c     | 12 ++++
 .../bpf/progs/test_xdp_egress_fail.c          | 16 +++++
 3 files changed, 90 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_egress_fail.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
new file mode 100644
index 000000000000..a8727f82a29d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_egress_attach.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
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
+	struct bpf_xdp_set_link_opts opts;
+	struct bpf_prog_info info = {};
+	__u32 id, len = sizeof(info);
+	struct bpf_object *obj;
+	__u32 duration = 0;
+	int err, fd = -1;
+
+	memset(&opts, 0, sizeof(opts));
+	opts.sz = sizeof(opts);
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
+	opts.old_fd = -1;
+	opts.egress = 1;
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, fd, 0, &opts);
+	if (CHECK(err, "xdp attach", "xdp attach failed"))
+		goto out_close;
+
+	err = bpf_get_link_xdp_egress_id(IFINDEX_LO, &id, 0);
+	if (CHECK(err || id != info.id, "id_check",
+		  "loaded prog id %u != id %u, err %d", info.id, id, err))
+		goto out;
+
+out:
+	opts.old_fd = bpf_prog_get_fd_by_id(id);
+	err = bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, 0, &opts);
+	if (CHECK(err, "xdp detach", "xdp detach failed"))
+		goto out_close;
+
+	err = bpf_get_link_xdp_egress_id(IFINDEX_LO, &id, 0);
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

