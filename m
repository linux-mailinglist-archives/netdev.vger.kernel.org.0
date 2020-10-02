Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D619281588
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388236AbgJBOnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:43:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:32850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOnL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:43:11 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E6A020708;
        Fri,  2 Oct 2020 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649790;
        bh=KqdOIEBWHwpdkF+8jfdovWiCtyDc6YI5ZYHE4ztCj5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIds9OuUrNBgUDU3FEVZXGANfCKgS+sV8u4HNGhg7wykOtvZXjS2LjV4SCKYI0W0H
         hMj4nS08yznLWsajDy98UlJurHftfa32x8J+RjAuRohG0L9A11cn9JkPaXZZozz3Vj
         CeeyQfGfg6C5fJz1KsT21oJvvc5x8LbnEgY6XXL4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 11/13] bpf: add xdp multi-buffer selftest
Date:   Fri,  2 Oct 2020 16:42:09 +0200
Message-Id: <c7a48fba3a80ac9362c27272cd869cc251539290.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp multi-buffer selftest for the following ebpf helpers:
- bpf_xdp_get_frags_total_size
- bpf_xdp_get_frags_count

Co-developed-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/xdp_mb.c | 79 +++++++++++++++++++
 .../selftests/bpf/progs/test_xdp_multi_buff.c | 24 ++++++
 2 files changed, 103 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_mb.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_mb.c b/tools/testing/selftests/bpf/prog_tests/xdp_mb.c
new file mode 100644
index 000000000000..4b1aca2d31e5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_mb.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <unistd.h>
+#include <linux/kernel.h>
+#include <test_progs.h>
+#include <network_helpers.h>
+
+#include "test_xdp_multi_buff.skel.h"
+
+static void test_xdp_mb_check_len(void)
+{
+	int test_sizes[] = { 128, 4096, 9000 };
+	struct test_xdp_multi_buff *pkt_skel;
+	__u8 *pkt_in = NULL, *pkt_out = NULL;
+	__u32 duration = 0, retval, size;
+	int err, pkt_fd, i;
+
+	/* Load XDP program */
+	pkt_skel = test_xdp_multi_buff__open_and_load();
+	if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp_mb skeleton failed\n"))
+		goto out;
+
+	/* Allocate resources */
+	pkt_out = malloc(test_sizes[ARRAY_SIZE(test_sizes) - 1]);
+	if (CHECK(!pkt_out, "malloc", "Failed pkt_out malloc\n"))
+		goto out;
+
+	pkt_in = malloc(test_sizes[ARRAY_SIZE(test_sizes) - 1]);
+	if (CHECK(!pkt_in, "malloc", "Failed pkt_in malloc\n"))
+		goto out;
+
+	pkt_fd = bpf_program__fd(pkt_skel->progs._xdp_check_mb_len);
+	if (pkt_fd < 0)
+		goto out;
+
+	/* Run test for specific set of packets */
+	for (i = 0; i < ARRAY_SIZE(test_sizes); i++) {
+		int frags_count;
+
+		/* Run test program */
+		err = bpf_prog_test_run(pkt_fd, 1, pkt_in, test_sizes[i],
+					pkt_out, &size, &retval, &duration);
+
+		if (CHECK(err || retval != XDP_PASS || size != test_sizes[i],
+			  "test_run", "err %d errno %d retval %d size %d[%d]\n",
+			  err, errno, retval, size, test_sizes[i]))
+			goto out;
+
+		/* Verify test results */
+		frags_count = DIV_ROUND_UP(
+			test_sizes[i] - pkt_skel->data->test_result_xdp_len,
+			getpagesize());
+
+		if (CHECK(pkt_skel->data->test_result_frags_count != frags_count,
+			  "result", "frags_count = %llu != %u\n",
+			  pkt_skel->data->test_result_frags_count, frags_count))
+			goto out;
+
+		if (CHECK(pkt_skel->data->test_result_frags_len != test_sizes[i] -
+			  pkt_skel->data->test_result_xdp_len,
+			  "result", "frags_len = %llu != %llu\n",
+			  pkt_skel->data->test_result_frags_len,
+			  test_sizes[i] - pkt_skel->data->test_result_xdp_len))
+			goto out;
+	}
+out:
+	if (pkt_out)
+		free(pkt_out);
+	if (pkt_in)
+		free(pkt_in);
+
+	test_xdp_multi_buff__destroy(pkt_skel);
+}
+
+void test_xdp_mb(void)
+{
+	if (test__start_subtest("xdp_mb_check_len_frags"))
+		test_xdp_mb_check_len();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c b/tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c
new file mode 100644
index 000000000000..b7527829a3ed
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_multi_buff.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <bpf/bpf_helpers.h>
+#include <stdint.h>
+
+__u64 test_result_frags_count = UINT64_MAX;
+__u64 test_result_frags_len = UINT64_MAX;
+__u64 test_result_xdp_len = UINT64_MAX;
+
+SEC("xdp_check_mb_len")
+int _xdp_check_mb_len(struct xdp_md *xdp)
+{
+	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(long)xdp->data;
+
+	test_result_xdp_len = (__u64)(data_end - data);
+	test_result_frags_len = bpf_xdp_get_frags_total_size(xdp);
+	test_result_frags_count = bpf_xdp_get_frags_count(xdp);
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.26.2

