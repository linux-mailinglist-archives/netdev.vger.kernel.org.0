Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0FD46339E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbhK3L7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 06:59:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43834 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbhK3L66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:58:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9856CB8186B;
        Tue, 30 Nov 2021 11:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78814C53FC7;
        Tue, 30 Nov 2021 11:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273336;
        bh=OTSXZslYL/62rjA+HJvdEc/hBnVqYdc6fAAwGoWqerE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D03e+7ooGWOtnVIzF+NnMrSSPmH+pWLcSz+lwHObJJ3yYX5K98wsG/ndERXADir+v
         Vnebic1NWVtEWg6EEWdo6eWpbyCfjP9qDOW5Ib//YnoBBn9jO0Af836Nmek8muTH0t
         hTZiqLHHMEjxS3D5GKQb2/9vM/8DccmsW4PbMBUua4XYN8JAMaQs0QhVqEHYrrMdrk
         gFYBChfj2uvza+Dh6wJ9yY7mQOvcOCLbhxN8PXghqah6AvNCy29PvW0vh2Oec1MppV
         RXvO8UOfytqZlfc8j/o0mlhOHXoB0Hx7djMGrNL1a0GuKHmY7XomTLOjPKVw0QB47P
         yydLvLf5EgweA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 22/23] bpf: selftests: add CPUMAP/DEVMAP selftests for xdp multi-buff
Date:   Tue, 30 Nov 2021 12:53:06 +0100
Message-Id: <5e264699b3dd12ca6c0fa8898e3347670cb245f3.1638272239.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify compatibility checks attaching a XDP multi-buff program to a
CPUMAP/DEVMAP

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_cpumap_attach.c        | 65 ++++++++++++++++++-
 .../bpf/prog_tests/xdp_devmap_attach.c        | 56 ++++++++++++++++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c  |  6 ++
 .../progs/test_xdp_with_cpumap_mb_helpers.c   | 27 ++++++++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |  7 ++
 .../progs/test_xdp_with_devmap_mb_helpers.c   | 27 ++++++++
 6 files changed, 187 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_mb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_mb_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index fd812bd43600..ee580b50a945 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -3,11 +3,12 @@
 #include <linux/if_link.h>
 #include <test_progs.h>
 
+#include "test_xdp_with_cpumap_mb_helpers.skel.h"
 #include "test_xdp_with_cpumap_helpers.skel.h"
 
 #define IFINDEX_LO	1
 
-void serial_test_xdp_cpumap_attach(void)
+void test_xdp_with_cpumap_helpers(void)
 {
 	struct test_xdp_with_cpumap_helpers *skel;
 	struct bpf_prog_info info = {};
@@ -54,6 +55,68 @@ void serial_test_xdp_cpumap_attach(void)
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	ASSERT_NEQ(err, 0, "Add non-BPF_XDP_CPUMAP program to cpumap entry");
 
+	/* try to attach BPF_XDP_CPUMAP multi-buff program when we have already
+	 * loaded a legacy XDP program on the map
+	 */
+	idx = 1;
+	val.qsize = 192;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_cm_mb);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0,
+		   "Add BPF_XDP_CPUMAP multi-buff program to cpumap entry");
+
 out_close:
 	test_xdp_with_cpumap_helpers__destroy(skel);
 }
+
+void test_xdp_with_cpumap_mb_helpers(void)
+{
+	struct test_xdp_with_cpumap_mb_helpers *skel;
+	struct bpf_prog_info info = {};
+	__u32 len = sizeof(info);
+	struct bpf_cpumap_val val = {
+		.qsize = 192,
+	};
+	int err, mb_prog_fd, map_fd;
+	__u32 idx = 0;
+
+	skel = test_xdp_with_cpumap_mb_helpers__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_xdp_with_cpumap_helpers__open_and_load"))
+		return;
+
+	mb_prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm_mb);
+	map_fd = bpf_map__fd(skel->maps.cpu_map);
+	err = bpf_obj_get_info_by_fd(mb_prog_fd, &info, &len);
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
+		goto out_close;
+
+	val.bpf_prog.fd = mb_prog_fd;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_OK(err, "Add program to cpumap entry");
+
+	err = bpf_map_lookup_elem(map_fd, &idx, &val);
+	ASSERT_OK(err, "Read cpumap entry");
+	ASSERT_EQ(info.id, val.bpf_prog.id,
+		  "Match program id to cpumap entry prog_id");
+
+	/* try to attach BPF_XDP_CPUMAP program when we have already
+	 * loaded a multi-buff XDP program on the map
+	 */
+	idx = 1;
+	val.qsize = 192;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0, "Add BPF_XDP_CPUMAP program to cpumap entry");
+
+out_close:
+	test_xdp_with_cpumap_mb_helpers__destroy(skel);
+}
+
+void serial_test_xdp_cpumap_attach(void)
+{
+	if (test__start_subtest("CPUMAP with programs in entries"))
+		test_xdp_with_cpumap_helpers();
+
+	if (test__start_subtest("CPUMAP with multi-buff programs in entries"))
+		test_xdp_with_cpumap_mb_helpers();
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index 3079d5568f8f..5c0dc3c20fc9 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -4,6 +4,7 @@
 #include <test_progs.h>
 
 #include "test_xdp_devmap_helpers.skel.h"
+#include "test_xdp_with_devmap_mb_helpers.skel.h"
 #include "test_xdp_with_devmap_helpers.skel.h"
 
 #define IFINDEX_LO 1
@@ -56,6 +57,16 @@ static void test_xdp_with_devmap_helpers(void)
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	ASSERT_NEQ(err, 0, "Add non-BPF_XDP_DEVMAP program to devmap entry");
 
+	/* try to attach BPF_XDP_DEVMAP multi-buff program when we have already
+	 * loaded a legacy XDP program on the map
+	 */
+	idx = 1;
+	val.ifindex = 1;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_dm_mb);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0,
+		   "Add BPF_XDP_DEVMAP multi-buff program to devmap entry");
+
 out_close:
 	test_xdp_with_devmap_helpers__destroy(skel);
 }
@@ -71,12 +82,57 @@ static void test_neg_xdp_devmap_helpers(void)
 	}
 }
 
+void test_xdp_with_devmap_mb_helpers(void)
+{
+	struct test_xdp_with_devmap_mb_helpers *skel;
+	struct bpf_prog_info info = {};
+	struct bpf_devmap_val val = {
+		.ifindex = IFINDEX_LO,
+	};
+	__u32 len = sizeof(info);
+	int err, dm_fd_mb, map_fd;
+	__u32 idx = 0;
+
+	skel = test_xdp_with_devmap_mb_helpers__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_xdp_with_devmap_helpers__open_and_load"))
+		return;
+
+	dm_fd_mb = bpf_program__fd(skel->progs.xdp_dummy_dm_mb);
+	map_fd = bpf_map__fd(skel->maps.dm_ports);
+	err = bpf_obj_get_info_by_fd(dm_fd_mb, &info, &len);
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
+		goto out_close;
+
+	val.bpf_prog.fd = dm_fd_mb;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_OK(err, "Add multi-buff program to devmap entry");
+
+	err = bpf_map_lookup_elem(map_fd, &idx, &val);
+	ASSERT_OK(err, "Read devmap entry");
+	ASSERT_EQ(info.id, val.bpf_prog.id,
+		  "Match program id to devmap entry prog_id");
+
+	/* try to attach BPF_XDP_DEVMAP program when we have already loaded a
+	 * multi-buff XDP program on the map
+	 */
+	idx = 1;
+	val.ifindex = 1;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_dm);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0, "Add BPF_XDP_DEVMAP program to devmap entry");
+
+out_close:
+	test_xdp_with_devmap_mb_helpers__destroy(skel);
+}
 
 void serial_test_xdp_devmap_attach(void)
 {
 	if (test__start_subtest("DEVMAP with programs in entries"))
 		test_xdp_with_devmap_helpers();
 
+	if (test__start_subtest("DEVMAP with multi-buff programs in entries"))
+		test_xdp_with_devmap_mb_helpers();
+
 	if (test__start_subtest("Verifier check of DEVMAP programs"))
 		test_neg_xdp_devmap_helpers();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
index 532025057711..f32e4dab1751 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
@@ -33,4 +33,10 @@ int xdp_dummy_cm(struct xdp_md *ctx)
 	return XDP_PASS;
 }
 
+SEC("xdp_cpumap_mb/mb_dummy_cm")
+int xdp_dummy_cm_mb(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_mb_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_mb_helpers.c
new file mode 100644
index 000000000000..96eedbaef71b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_mb_helpers.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define IFINDEX_LO	1
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
+	__uint(max_entries, 4);
+} cpu_map SEC(".maps");
+
+SEC("xdp_cpumap/dummy_cm")
+int xdp_dummy_cm(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+SEC("xdp_cpumap_mb/mb_dummy_cm")
+int xdp_dummy_cm_mb(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
index 1e6b9c38ea6d..691f2d70dedc 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -40,4 +40,11 @@ int xdp_dummy_dm(struct xdp_md *ctx)
 
 	return XDP_PASS;
 }
+
+SEC("xdp_devmap_mb/mp_map_prog")
+int xdp_dummy_dm_mb(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_mb_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_mb_helpers.c
new file mode 100644
index 000000000000..05221b1fd9f2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_mb_helpers.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 4);
+} dm_ports SEC(".maps");
+
+/* valid program on DEVMAP entry via SEC name;
+ * has access to egress and ingress ifindex
+ */
+SEC("xdp_devmap/map_prog")
+int xdp_dummy_dm(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+SEC("xdp_devmap_mb/mp_map_prog")
+int xdp_dummy_dm_mb(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.31.1

