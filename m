Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDCE4E9E7A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244863AbiC1R5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:57:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244967AbiC1R4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:56:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DDC23BC0;
        Mon, 28 Mar 2022 10:55:05 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0fd4t1mz67y8R;
        Tue, 29 Mar 2022 01:53:13 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:55:02 +0200
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
Subject: [PATCH 17/18] bpf-preload/selftests: Add test for automatic generation of preload methods
Date:   Mon, 28 Mar 2022 19:50:32 +0200
Message-ID: <20220328175033.2437312-18-roberto.sassu@huawei.com>
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

Add the test 'gen_preload_methods' to ensure that the preload methods are
correctly generated. Introduce a sample eBPF program in
progs/gen_preload_methods.c, generate the light skeleton without and with
the preload methods, and finally compare the diff with the expected diff
output in prog_tests/gen_preload_methods.expected.diff.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/Makefile          | 15 ++-
 .../gen_preload_methods.expected.diff         | 97 +++++++++++++++++++
 .../bpf/prog_tests/test_gen_preload_methods.c | 27 ++++++
 .../selftests/bpf/progs/gen_preload_methods.c | 23 +++++
 4 files changed, 160 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/gen_preload_methods.expected.diff
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_gen_preload_methods.c
 create mode 100644 tools/testing/selftests/bpf/progs/gen_preload_methods.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 3820608faf57..de81779e90e3 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -337,10 +337,11 @@ test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.o test_subskeleton_lib
 
 LSKELS := kfunc_call_test.c fentry_test.c fexit_test.c fexit_sleep.c \
 	test_ringbuf.c atomics.c trace_printk.c trace_vprintk.c \
-	map_ptr_kern.c core_kern.c core_kern_overflow.c
+	map_ptr_kern.c core_kern.c core_kern_overflow.c gen_preload_methods.c
+LSKELSP := gen_preload_methods.c
 # Generate both light skeleton and libbpf skeleton for these
 LSKELS_EXTRA := test_ksyms_module.c test_ksyms_weak.c kfunc_call_test_subprog.c
-SKEL_BLACKLIST += $$(LSKELS)
+SKEL_BLACKLIST += $$(LSKELS) $$(LSKELSP)
 
 test_static_linked.skel.h-deps := test_static_linked1.o test_static_linked2.o
 linked_funcs.skel.h-deps := linked_funcs1.o linked_funcs2.o
@@ -370,6 +371,7 @@ TRUNNER_BPF_SKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.skel.h,	\
 				 $$(filter-out $(SKEL_BLACKLIST) $(LINKED_BPF_SRCS),\
 					       $$(TRUNNER_BPF_SRCS)))
 TRUNNER_BPF_LSKELS := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.lskel.h, $$(LSKELS) $$(LSKELS_EXTRA))
+TRUNNER_BPF_LSKELSP := $$(patsubst %.c,$$(TRUNNER_OUTPUT)/%.preload.lskel.h, $$(LSKELSP))
 TRUNNER_BPF_SKELS_LINKED := $$(addprefix $$(TRUNNER_OUTPUT)/,$(LINKED_SKELS))
 TEST_GEN_FILES += $$(TRUNNER_BPF_OBJS)
 
@@ -421,6 +423,14 @@ $(TRUNNER_BPF_LSKELS): %.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
 	$(Q)$$(BPFTOOL) gen skeleton -L $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=_lskel)) > $$@
 
+$(TRUNNER_BPF_LSKELSP): %.preload.lskel.h: %.o $(BPFTOOL) | $(TRUNNER_OUTPUT)
+	$$(call msg,GEN-SKEL,$(TRUNNER_BINARY),$$@)
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked1.o) $$<
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked2.o) $$(<:.o=.linked1.o)
+	$(Q)$$(BPFTOOL) gen object $$(<:.o=.linked3.o) $$(<:.o=.linked2.o)
+	$(Q)diff $$(<:.o=.linked2.o) $$(<:.o=.linked3.o)
+	$(Q)$$(BPFTOOL) gen skeleton -L -P $$(<:.o=.linked3.o) name $$(notdir $$(<:.o=_lskel)) > $$@
+
 $(TRUNNER_BPF_SKELS_LINKED): $(TRUNNER_BPF_OBJS) $(BPFTOOL) | $(TRUNNER_OUTPUT)
 	$$(call msg,LINK-BPF,$(TRUNNER_BINARY),$$(@:.skel.h=.o))
 	$(Q)$$(BPFTOOL) gen object $$(@:.skel.h=.linked1.o) $$(addprefix $(TRUNNER_OUTPUT)/,$$($$(@F)-deps))
@@ -451,6 +461,7 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:			\
 		      $(TRUNNER_BPF_OBJS)				\
 		      $(TRUNNER_BPF_SKELS)				\
 		      $(TRUNNER_BPF_LSKELS)				\
+		      $(TRUNNER_BPF_LSKELSP)				\
 		      $(TRUNNER_BPF_SKELS_LINKED)			\
 		      $$(BPFOBJ) | $(TRUNNER_OUTPUT)
 	$$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
diff --git a/tools/testing/selftests/bpf/prog_tests/gen_preload_methods.expected.diff b/tools/testing/selftests/bpf/prog_tests/gen_preload_methods.expected.diff
new file mode 100644
index 000000000000..5e010d380e50
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/gen_preload_methods.expected.diff
@@ -0,0 +1,97 @@
+--- gen_preload_methods.lskel.h	2022-03-28 13:40:22.042715754 +0200
++++ gen_preload_methods.preload.lskel.h	2022-03-28 13:40:22.530715750 +0200
+@@ -221,4 +221,94 @@ gen_preload_methods_lskel__assert(struct
+ #endif
+ }
+ 
++static struct bpf_link *dump_bpf_map_link;
++static struct bpf_map *ringbuf_map;
++static struct gen_preload_methods_lskel *skel;
++
++static void free_objs_and_skel(void)
++{
++	bpf_preload_set_ops("gen_preload_methods_lskel", THIS_MODULE, NULL);
++
++	if (!IS_ERR_OR_NULL(dump_bpf_map_link))
++		bpf_link_put(dump_bpf_map_link);
++	if (!IS_ERR_OR_NULL(ringbuf_map))
++		bpf_map_put(ringbuf_map);
++
++	gen_preload_methods_lskel__destroy(skel);
++}
++
++static int preload(struct dentry *parent)
++{
++	int err;
++
++	bpf_link_inc(dump_bpf_map_link);
++	bpf_map_inc(ringbuf_map);
++
++	err = bpf_obj_do_pin_kernel(parent, "dump_bpf_map",
++				    dump_bpf_map_link,
++				    BPF_TYPE_LINK);
++	if (err)
++		goto undo;
++
++	err = bpf_obj_do_pin_kernel(parent, "ringbuf",
++				    ringbuf_map,
++				    BPF_TYPE_MAP);
++	if (err)
++		goto undo;
++
++	return 0;
++undo:
++	bpf_link_put(dump_bpf_map_link);
++	bpf_map_put(ringbuf_map);
++	return err;
++}
++
++static struct bpf_preload_ops ops = {
++	.preload = preload,
++	.owner = THIS_MODULE,
++};
++
++static int load_skel(void)
++{
++	int err = -ENOMEM;
++
++	if (!bpf_preload_set_ops("gen_preload_methods_lskel", THIS_MODULE, &ops))
++		return 0;
++
++	skel = gen_preload_methods_lskel__open();
++	if (!skel)
++		goto out;
++
++	err = gen_preload_methods_lskel__load(skel);
++	if (err)
++		goto out;
++
++	err = gen_preload_methods_lskel__attach(skel);
++	if (err)
++		goto out;
++
++	dump_bpf_map_link = bpf_link_get_from_fd(skel->links.dump_bpf_map_fd);
++	if (IS_ERR(dump_bpf_map_link)) {
++		err = PTR_ERR(dump_bpf_map_link);
++		goto out;
++	}
++
++	ringbuf_map = bpf_map_get(skel->maps.ringbuf.map_fd);
++	if (IS_ERR(ringbuf_map)) {
++		err = PTR_ERR(ringbuf_map);
++		goto out;
++	}
++
++	/* Avoid taking over stdin/stdout/stderr of init process. Zeroing out
++	 * makes skel_closenz() a no-op later in iterators_bpf__destroy().
++	 */
++	close_fd(skel->links.dump_bpf_map_fd);
++	skel->links.dump_bpf_map_fd = 0;
++
++	return 0;
++out:
++	free_objs_and_skel();
++	return err;
++}
++
+ #endif /* __GEN_PRELOAD_METHODS_LSKEL_SKEL_H__ */
diff --git a/tools/testing/selftests/bpf/prog_tests/test_gen_preload_methods.c b/tools/testing/selftests/bpf/prog_tests/test_gen_preload_methods.c
new file mode 100644
index 000000000000..937b3e606f53
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_gen_preload_methods.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ */
+
+#include <test_progs.h>
+
+static int duration;
+
+void test_test_gen_preload_methods(void)
+{
+	char diff_cmd[1024];
+	int err;
+
+	snprintf(diff_cmd, sizeof(diff_cmd),
+		 "diff -up gen_preload_methods.lskel.h "
+		 "gen_preload_methods.preload.lskel.h "
+		 "| tail -n +4 | "
+		 "diff -u - "
+		 "<(tail -n +4 prog_tests/gen_preload_methods.expected.diff)");
+	err = system(diff_cmd);
+	if (CHECK(err, "diff",
+		  "differing test output, err=%d, diff cmd:\n%s\n",
+		  err, diff_cmd))
+		return;
+}
diff --git a/tools/testing/selftests/bpf/progs/gen_preload_methods.c b/tools/testing/selftests/bpf/progs/gen_preload_methods.c
new file mode 100644
index 000000000000..5b3ab27f945d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/gen_preload_methods.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_RINGBUF);
+	__uint(max_entries, 1 << 12);
+} ringbuf SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("iter/bpf_map")
+int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
+{
+	return 0;
+}
-- 
2.32.0

