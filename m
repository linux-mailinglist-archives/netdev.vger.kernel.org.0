Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EFB490F9D
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiAQRa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239334AbiAQRau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:30:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7055C061749;
        Mon, 17 Jan 2022 09:30:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CFC8B8115E;
        Mon, 17 Jan 2022 17:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B09BC36AE3;
        Mon, 17 Jan 2022 17:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440647;
        bh=chFTglYxwUObJwaUBm4ZVC8tsTeMzv7CS1sPjR4SBYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FshxE+RML/atRY4pVSiH5nA0Wc4ig8FZCvlckGgRtDKMFUJEmDSLLcnY0XZ+OvEPj
         eaCLRgcizuBiInM2qm3wcxxO75ukpFyw7xW49LfdEhd7rUxOEi/n+oPpeqqo6YYQWo
         s74c0/jSRsA1fah66zqUoourL+RlbBA0ZyFNqts9vIbXL5O02SBI8+wRNK07WkeIND
         qLsH6a3wKc4+STNb+TTd5VOmMQkEJk7eCrA+B7NzwVeJS/4BbMEJELLLaiYpUqXRKE
         sr+lVdcLVcmwMPQ7+8tgayiFYcDMwY6TcOjUeWTWlwGRF0Nq9qXyqRymrb2yqm0mwW
         K4IHC5QFkTTcg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 22/23] bpf: selftests: add CPUMAP/DEVMAP selftests for xdp multi-frags
Date:   Mon, 17 Jan 2022 18:28:34 +0100
Message-Id: <ca18e84014935e69833cd85ab5bbc62858d2fa73.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify compatibility checks attaching a XDP multi-frags program to a
CPUMAP/DEVMAP

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_cpumap_attach.c        | 64 ++++++++++++++++++-
 .../bpf/prog_tests/xdp_devmap_attach.c        | 55 ++++++++++++++++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c  |  6 ++
 ...test_xdp_with_cpumap_multi_frags_helpers.c | 27 ++++++++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |  7 ++
 ...test_xdp_with_devmap_multi_frags_helpers.c | 27 ++++++++
 6 files changed, 185 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_multi_frags_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_multi_frags_helpers.c

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index fd812bd43600..acef8534ec65 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -3,11 +3,12 @@
 #include <linux/if_link.h>
 #include <test_progs.h>
 
+#include "test_xdp_with_cpumap_multi_frags_helpers.skel.h"
 #include "test_xdp_with_cpumap_helpers.skel.h"
 
 #define IFINDEX_LO	1
 
-void serial_test_xdp_cpumap_attach(void)
+void test_xdp_with_cpumap_helpers(void)
 {
 	struct test_xdp_with_cpumap_helpers *skel;
 	struct bpf_prog_info info = {};
@@ -54,6 +55,67 @@ void serial_test_xdp_cpumap_attach(void)
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	ASSERT_NEQ(err, 0, "Add non-BPF_XDP_CPUMAP program to cpumap entry");
 
+	/* Try to attach BPF_XDP program with frags to cpumap when we have
+	 * already loaded a BPF_XDP program on the map
+	 */
+	idx = 1;
+	val.qsize = 192;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_cm_multi_frags);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0, "Add BPF_XDP program with frags to cpumap entry");
+
 out_close:
 	test_xdp_with_cpumap_helpers__destroy(skel);
 }
+
+void test_xdp_with_cpumap_multi_frags_helpers(void)
+{
+	struct test_xdp_with_cpumap_multi_frags_helpers *skel;
+	struct bpf_prog_info info = {};
+	__u32 len = sizeof(info);
+	struct bpf_cpumap_val val = {
+		.qsize = 192,
+	};
+	int err, multi_frags_prog_fd, map_fd;
+	__u32 idx = 0;
+
+	skel = test_xdp_with_cpumap_multi_frags_helpers__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_xdp_with_cpumap_helpers__open_and_load"))
+		return;
+
+	multi_frags_prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm_multi_frags);
+	map_fd = bpf_map__fd(skel->maps.cpu_map);
+	err = bpf_obj_get_info_by_fd(multi_frags_prog_fd, &info, &len);
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
+		goto out_close;
+
+	val.bpf_prog.fd = multi_frags_prog_fd;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_OK(err, "Add program to cpumap entry");
+
+	err = bpf_map_lookup_elem(map_fd, &idx, &val);
+	ASSERT_OK(err, "Read cpumap entry");
+	ASSERT_EQ(info.id, val.bpf_prog.id,
+		  "Match program id to cpumap entry prog_id");
+
+	/* Try to attach BPF_XDP program to cpumap when we have
+	 * already loaded a BPF_XDP program with frags on the map
+	 */
+	idx = 1;
+	val.qsize = 192;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0, "Add BPF_XDP program to cpumap entry");
+
+out_close:
+	test_xdp_with_cpumap_multi_frags_helpers__destroy(skel);
+}
+
+void serial_test_xdp_cpumap_attach(void)
+{
+	if (test__start_subtest("CPUMAP with programs in entries"))
+		test_xdp_with_cpumap_helpers();
+
+	if (test__start_subtest("CPUMAP with multi-frags programs in entries"))
+		test_xdp_with_cpumap_multi_frags_helpers();
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index 3079d5568f8f..fe080861208b 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -4,6 +4,7 @@
 #include <test_progs.h>
 
 #include "test_xdp_devmap_helpers.skel.h"
+#include "test_xdp_with_devmap_multi_frags_helpers.skel.h"
 #include "test_xdp_with_devmap_helpers.skel.h"
 
 #define IFINDEX_LO 1
@@ -56,6 +57,15 @@ static void test_xdp_with_devmap_helpers(void)
 	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
 	ASSERT_NEQ(err, 0, "Add non-BPF_XDP_DEVMAP program to devmap entry");
 
+	/* Try to attach BPF_XDP program with frags to devmap when we have
+	 * already loaded a BPF_XDP program on the map
+	 */
+	idx = 1;
+	val.ifindex = 1;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_dm_multi_frags);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0, "Add BPF_XDP program with frags to devmap entry");
+
 out_close:
 	test_xdp_with_devmap_helpers__destroy(skel);
 }
@@ -71,12 +81,57 @@ static void test_neg_xdp_devmap_helpers(void)
 	}
 }
 
+void test_xdp_with_devmap_multi_frags_helpers(void)
+{
+	struct test_xdp_with_devmap_multi_frags_helpers *skel;
+	struct bpf_prog_info info = {};
+	struct bpf_devmap_val val = {
+		.ifindex = IFINDEX_LO,
+	};
+	__u32 len = sizeof(info);
+	int err, dm_fd_multi_frags, map_fd;
+	__u32 idx = 0;
+
+	skel = test_xdp_with_devmap_multi_frags_helpers__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_xdp_with_devmap_helpers__open_and_load"))
+		return;
+
+	dm_fd_multi_frags = bpf_program__fd(skel->progs.xdp_dummy_dm_multi_frags);
+	map_fd = bpf_map__fd(skel->maps.dm_ports);
+	err = bpf_obj_get_info_by_fd(dm_fd_multi_frags, &info, &len);
+	if (!ASSERT_OK(err, "bpf_obj_get_info_by_fd"))
+		goto out_close;
+
+	val.bpf_prog.fd = dm_fd_multi_frags;
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_OK(err, "Add multi-frags program to devmap entry");
+
+	err = bpf_map_lookup_elem(map_fd, &idx, &val);
+	ASSERT_OK(err, "Read devmap entry");
+	ASSERT_EQ(info.id, val.bpf_prog.id,
+		  "Match program id to devmap entry prog_id");
+
+	/* Try to attach BPF_XDP program to devmap when we have
+	 * already loaded a BPF_XDP program with frags on the map
+	 */
+	idx = 1;
+	val.ifindex = 1;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_dummy_dm);
+	err = bpf_map_update_elem(map_fd, &idx, &val, 0);
+	ASSERT_NEQ(err, 0, "Add BPF_XDP program to devmap entry");
+
+out_close:
+	test_xdp_with_devmap_multi_frags_helpers__destroy(skel);
+}
 
 void serial_test_xdp_devmap_attach(void)
 {
 	if (test__start_subtest("DEVMAP with programs in entries"))
 		test_xdp_with_devmap_helpers();
 
+	if (test__start_subtest("DEVMAP with multi-frags programs in entries"))
+		test_xdp_with_devmap_multi_frags_helpers();
+
 	if (test__start_subtest("Verifier check of DEVMAP programs"))
 		test_neg_xdp_devmap_helpers();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
index 532025057711..5b7c8371508f 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_helpers.c
@@ -33,4 +33,10 @@ int xdp_dummy_cm(struct xdp_md *ctx)
 	return XDP_PASS;
 }
 
+SEC("xdp.frags/cpumap")
+int xdp_dummy_cm_multi_frags(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_multi_frags_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_multi_frags_helpers.c
new file mode 100644
index 000000000000..e474408ff5c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_multi_frags_helpers.c
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
+SEC("xdp.frags/cpumap")
+int xdp_dummy_cm_multi_frags(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
index 1e6b9c38ea6d..05c90e7ccd6c 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_helpers.c
@@ -40,4 +40,11 @@ int xdp_dummy_dm(struct xdp_md *ctx)
 
 	return XDP_PASS;
 }
+
+SEC("xdp.frags/devmap")
+int xdp_dummy_dm_multi_frags(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_multi_frags_helpers.c b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_multi_frags_helpers.c
new file mode 100644
index 000000000000..cf2ae077003f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_xdp_with_devmap_multi_frags_helpers.c
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
+SEC("xdp.frags/devmap")
+int xdp_dummy_dm_multi_frags(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

