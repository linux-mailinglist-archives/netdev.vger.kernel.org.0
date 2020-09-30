Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8FD27F51F
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731440AbgI3W3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:29:15 -0400
Received: from mga17.intel.com ([192.55.52.151]:23089 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgI3W3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 18:29:15 -0400
IronPort-SDR: bzNfuRTFMVh3iPW2a7VEyJyR1n9uNUcPbSWvVxzMk0MyVCdrWGWNt91wh7rPncjdag10CHbs9j
 nwKapXI8Ry/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="142570731"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="142570731"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 15:29:12 -0700
IronPort-SDR: Ms8uk+SalYWX/prYfZUjetUdfT/jWltAdrKf9xJ61Pe43ZADP/rLFSQwWhDZP996jWiSbyUiuq
 /Zzn8tfDDd6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="339269049"
Received: from bpujari-bxdsw.sc.intel.com ([10.232.14.242])
  by fmsmga004.fm.intel.com with ESMTP; 30 Sep 2020 15:29:10 -0700
From:   bimmy.pujari@intel.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, maze@google.com,
        bimmy.pujari@intel.com, ashkan.nikravesh@intel.com,
        Daniel.A.Alvarez@intel.com
Subject: [PATCH bpf-next v6 2/2] selftests/bpf: Selftest for real time helper
Date:   Wed, 30 Sep 2020 15:29:30 -0700
Message-Id: <20200930222930.14316-1-bimmy.pujari@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bimmy Pujari <bimmy.pujari@intel.com>

Add test validating that bpf_ktime_get_real_ns works fine.

Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
---
 .../selftests/bpf/prog_tests/ktime_real.c     | 42 +++++++++++++++++++
 .../bpf/progs/test_ktime_get_real_ns.c        | 36 ++++++++++++++++
 2 files changed, 78 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ktime_real.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ktime_get_real_ns.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ktime_real.c b/tools/testing/selftests/bpf/prog_tests/ktime_real.c
new file mode 100644
index 000000000000..85235f2786b2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ktime_real.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+
+static void *time_thread(void *arg)
+{
+	__u32 duration, retval;
+	int err, prog_fd = *(u32 *) arg;
+
+	err = bpf_prog_test_run(prog_fd, 10000, &pkt_v4, sizeof(pkt_v4),
+				NULL, NULL, &retval, &duration);
+	CHECK(err || retval, "",
+	      "err %d errno %d retval %d duration %d\n",
+	      err, errno, retval, duration);
+	pthread_exit(arg);
+}
+
+void test_ktime_real(void)
+{
+	const char *file = "./test_ktime_get_real_ns.o";
+	struct bpf_object *obj = NULL;
+	pthread_t thread_id;
+	int prog_fd;
+	int err = 0;
+	void *ret;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_CGROUP_SKB, &obj, &prog_fd);
+	if (CHECK_FAIL(err)) {
+		printf("test_ktime_get_real_ns:bpf_prog_load errno %d\n", errno);
+		goto close_prog;
+	}
+
+	if (CHECK_FAIL(pthread_create(&thread_id, NULL,
+				      &time_thread, &prog_fd)))
+		goto close_prog;
+
+	if (CHECK_FAIL(pthread_join(thread_id, &ret) ||
+				    ret != (void *)&prog_fd))
+		goto close_prog;
+close_prog:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ktime_get_real_ns.c b/tools/testing/selftests/bpf/progs/test_ktime_get_real_ns.c
new file mode 100644
index 000000000000..37132c59de61
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ktime_get_real_ns.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/version.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, int);
+	__type(value, unsigned long long);
+} time_map SEC(".maps");
+
+SEC("realtime_helper")
+int realtime_helper_test(struct __sk_buff *skb)
+{
+	unsigned long long *lasttime;
+	unsigned long long curtime;
+	int key = 0;
+	int err = 0;
+
+	lasttime = bpf_map_lookup_elem(&time_map, &key);
+	if (!lasttime)
+		goto err;
+
+	curtime = bpf_ktime_get_real_ns();
+	if (curtime <= *lasttime) {
+		err = 1;
+		goto err;
+	}
+	*lasttime = curtime;
+
+err:
+	return err;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

