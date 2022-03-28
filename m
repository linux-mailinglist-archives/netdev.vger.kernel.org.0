Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180234E9E7B
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245097AbiC1R5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245011AbiC1R4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:56:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0441224594;
        Mon, 28 Mar 2022 10:55:07 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0dt6lWgz67sj9;
        Tue, 29 Mar 2022 01:52:34 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:55:04 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <corbet@lwn.net>, <viro@zeniv.linux.org.uk>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <shuah@kernel.org>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <zohar@linux.ibm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 18/18] bpf-preload/selftests: Preload a test eBPF program and check pinned objects
Date:   Mon, 28 Mar 2022 19:50:33 +0200
Message-ID: <20220328175033.2437312-19-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220328175033.2437312-1-roberto.sassu@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce the 'preload_methods' test, which loads the new kernel module
bpf_testmod_preload.ko (with the light skeleton from
gen_preload_methods.c), mounts a new instance of the bpf filesystem, and
checks if the pinned objects exist.

The test requires to include 'gen_preload_methods_lskel' among the list of
eBPF programs to preload.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/Makefile          | 17 ++++-
 .../bpf/bpf_testmod_preload/.gitignore        |  7 ++
 .../bpf/bpf_testmod_preload/Makefile          | 20 ++++++
 .../bpf/prog_tests/test_preload_methods.c     | 69 +++++++++++++++++++
 4 files changed, 110 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod_preload/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod_preload/Makefile
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_preload_methods.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index de81779e90e3..ca419b0a083c 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -82,7 +82,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver xdp_redirect_multi
+	xdpxceiver xdp_redirect_multi bpf_testmod_preload.ko
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
@@ -110,6 +110,7 @@ override define CLEAN
 	$(Q)$(RM) -r $(TEST_GEN_FILES)
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 	$(Q)$(MAKE) -C bpf_testmod clean
+	$(Q)$(MAKE) -C bpf_testmod_preload clean
 	$(Q)$(MAKE) docs-clean
 endef
 
@@ -502,7 +503,7 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 btf_helpers.c flow_dissector_load.h		\
 			 cap_helpers.c
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
-		       ima_setup.sh					\
+		       ima_setup.sh $(OUTPUT)/bpf_testmod_preload.ko	\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS) -DENABLE_ATOMICS_TESTS
@@ -575,9 +576,19 @@ $(OUTPUT)/bench: $(OUTPUT)/bench.o \
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) $(filter %.a %.o,$^) $(LDLIBS) -o $@
 
+bpf_testmod_preload/bpf_testmod_preload.c: $(OUTPUT)/gen_preload_methods.preload.lskel.h $(BPFTOOL) $(TRUNNER_BPF_LSKELSP)
+	$(call msg,GEN-MOD,,$@)
+	$(BPFTOOL) gen module $< > $@
+
+$(OUTPUT)/bpf_testmod_preload.ko: bpf_testmod_preload/bpf_testmod_preload.c
+	$(call msg,MOD,,$@)
+	$(Q)$(RM) bpf_testmod_preload/bpf_testmod_preload.ko # force re-compilation
+	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod_preload
+	$(Q)cp bpf_testmod_preload/bpf_testmod_preload.ko $@
+
 EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)	\
 	prog_tests/tests.h map_tests/tests.h verifier/tests.h		\
 	feature bpftool							\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h *.lskel.h *.subskel.h no_alu32 bpf_gcc bpf_testmod.ko)
+	$(addprefix $(OUTPUT)/,*.o *.skel.h *.lskel.h *.subskel.h no_alu32 bpf_gcc bpf_testmod.ko bpf_testmod_preload.ko)
 
 .PHONY: docs docs-clean
diff --git a/tools/testing/selftests/bpf/bpf_testmod_preload/.gitignore b/tools/testing/selftests/bpf/bpf_testmod_preload/.gitignore
new file mode 100644
index 000000000000..989530ffc79f
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod_preload/.gitignore
@@ -0,0 +1,7 @@
+*.mod
+*.mod.c
+*.o
+.ko
+/Module.symvers
+/modules.order
+bpf_testmod_preload.c
diff --git a/tools/testing/selftests/bpf/bpf_testmod_preload/Makefile b/tools/testing/selftests/bpf/bpf_testmod_preload/Makefile
new file mode 100644
index 000000000000..d17ac6670974
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpf_testmod_preload/Makefile
@@ -0,0 +1,20 @@
+BPF_TESTMOD_PRELOAD_DIR := $(realpath $(dir $(abspath $(lastword $(MAKEFILE_LIST)))))
+KDIR ?= $(abspath $(BPF_TESTMOD_PRELOAD_DIR)/../../../../..)
+
+ifeq ($(V),1)
+Q =
+else
+Q = @
+endif
+
+MODULES = bpf_testmod_preload.ko
+
+obj-m += bpf_testmod_preload.o
+CFLAGS_bpf_testmod_preload.o = -I$(BPF_TESTMOD_PRELOAD_DIR)/../tools/include
+
+all:
+	+$(Q)make -C $(KDIR) M=$(BPF_TESTMOD_PRELOAD_DIR) modules
+
+clean:
+	+$(Q)make -C $(KDIR) M=$(BPF_TESTMOD_PRELOAD_DIR) clean
+
diff --git a/tools/testing/selftests/bpf/prog_tests/test_preload_methods.c b/tools/testing/selftests/bpf/prog_tests/test_preload_methods.c
new file mode 100644
index 000000000000..bad3b187794b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_preload_methods.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ */
+
+#include <errno.h>
+#include <limits.h>
+#include <test_progs.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+
+#define MOUNT_FLAGS (MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_RELATIME)
+
+static int duration;
+
+void test_test_preload_methods(void)
+{
+	char bpf_mntpoint[] = "/tmp/bpf_mntpointXXXXXX", *dir;
+	char path[PATH_MAX];
+	struct stat st;
+	int err;
+
+	system("rmmod bpf_testmod_preload 2> /dev/null");
+
+	err = system("insmod bpf_testmod_preload.ko");
+	if (CHECK(err, "insmod",
+		  "cannot load bpf_testmod_preload.ko, err=%d\n", err))
+		return;
+
+	dir = mkdtemp(bpf_mntpoint);
+	if (CHECK(!dir, "mkstemp", "cannot create temp file, err=%d\n",
+		  -errno))
+		goto out_rmmod;
+
+	err = mount(bpf_mntpoint, bpf_mntpoint, "bpf", MOUNT_FLAGS, NULL);
+	if (CHECK(err, "mount",
+		  "cannot mount bpf filesystem to %s, err=%d\n", bpf_mntpoint,
+		  err))
+		goto out_unlink;
+
+	snprintf(path, sizeof(path), "%s/gen_preload_methods_lskel",
+		 bpf_mntpoint);
+
+	err = stat(path, &st);
+	if (CHECK(err, "stat", "cannot find %s\n", path))
+		goto out_unmount;
+
+	snprintf(path, sizeof(path),
+		 "%s/gen_preload_methods_lskel/dump_bpf_map", bpf_mntpoint);
+
+	err = stat(path, &st);
+	if (CHECK(err, "stat", "cannot find %s\n", path))
+		goto out_unmount;
+
+	snprintf(path, sizeof(path), "%s/gen_preload_methods_lskel/ringbuf",
+		 bpf_mntpoint);
+
+	err = stat(path, &st);
+	if (CHECK(err, "stat", "cannot find %s\n", path))
+		goto out_unmount;
+
+out_unmount:
+	umount(bpf_mntpoint);
+out_unlink:
+	rmdir(bpf_mntpoint);
+out_rmmod:
+	system("rmmod bpf_testmod_preload");
+}
-- 
2.32.0

