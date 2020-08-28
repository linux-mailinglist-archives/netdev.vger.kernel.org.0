Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EB025616D
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 21:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgH1Tgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 15:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgH1Tgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 15:36:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7662AC06123E
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p138so291498yba.12
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 12:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WaTo6ZJcGLHZksayG/dsTkSRXBIBZTSwi40c3afpT9s=;
        b=XqtFeGtHuu0gx/158ocomVxIYVECyAvi9+H75KLQftxOdEFwbu0W7GEHg6Qv2z11N7
         ZuavD9SOP+WDH5DTjzLRIzlpeMT56zH+NVAeD8t3uipSvKdzQifXfl3guW19o6maqdhw
         zW3WLNb6Zuy/sUSXZUsn8/7m6Li4C44m4rim+k0kfDHjtjkDtj+9ZrvZV8OkAQDUvvoM
         C0ZbGaw0kbKeHF8NKOdLO2e3FwpuADnVxvp5jzHGZqiVbnCfDoAVsglRSR3XcTQXfZxK
         WmaZaLLU4yO3eDLXoBqmSDAwsXTAP9VW4oumdYmlYbeB/yVfW3s4rPF+EEJ5xgzKQDt9
         vbIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WaTo6ZJcGLHZksayG/dsTkSRXBIBZTSwi40c3afpT9s=;
        b=A6ig9erZQzmpvrdySUX3ziNa48N5lH3DHr4FB3/IS2y1jGhlaLlwtqdEtYUWPaRk0G
         JXdYF55qN3YR1e3zW0DhF0uDVHzSFfkDg8frzjJPVYIppA0jRNB+Ss2Xo0+/o4PoLYwD
         woEw/FB6OuUcH81L76Eg1EOQ3VnVlgnaO60bZRfWk19fId/bEMnH4m8MzoFCuyxPvGaB
         zKOSY1Ecu9Ka+BRxWku+K9C6OvTNuWvr3I5ZJBQZyEYY3k3PJygRHWhMHkcU96lZPndB
         rydaTjsTYiyX8ZWnBZJGdXH5olW8okLaGFnYqmiQEYDTGTVfqnVrjq92dEiAn4vblowB
         /9Vw==
X-Gm-Message-State: AOAM5314L2T2b09+eVAoiU24eLf2hfERYRwt08La4HzwafWg27BoHq0u
        3a/uVvYFoTVkIDspyLUV6j6OwcvzTmJ8Xxdvbs1KW5igxm/RiOASlSwOi+GcHYUnUCokoFGEy/R
        IgVLR2bCav2Y9x91pDEgGbu393oOabe2iiqYOLQVHyKgLsMCcv49lyA==
X-Google-Smtp-Source: ABdhPJxP/DYvvsPeuQ4BlDskYz65IqwhgmzcHtsDjMXmG7aRmZ9JUcD5A8yWlH7pMn0+e8qGDmB27pM=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:8b89:: with SMTP id j9mr4834608ybl.31.1598643380602;
 Fri, 28 Aug 2020 12:36:20 -0700 (PDT)
Date:   Fri, 28 Aug 2020 12:36:03 -0700
In-Reply-To: <20200828193603.335512-1-sdf@google.com>
Message-Id: <20200828193603.335512-9-sdf@google.com>
Mime-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH bpf-next v3 8/8] selftests/bpf: Test load and dump metadata
 with btftool and skel
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YiFei Zhu <zhuyifei@google.com>

This is a simple test to check that loading and dumping metadata
in btftool works, whether or not metadata contents are used by the
program.

A C test is also added to make sure the skeleton code can read the
metadata values, and we also check that trying to re-bind the map
causes EEXIST, so we are sure the map is already bound by libbpf
when loading skeleton.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/metadata.c       | 83 +++++++++++++++++++
 .../selftests/bpf/progs/metadata_unused.c     | 15 ++++
 .../selftests/bpf/progs/metadata_used.c       | 15 ++++
 .../selftests/bpf/test_bpftool_metadata.sh    | 82 ++++++++++++++++++
 5 files changed, 197 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 09657d0afb5c..f7fd1503d210 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -68,7 +68,8 @@ TEST_PROGS := test_kmod.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
 	test_bpftool_build.sh \
-	test_bpftool.sh
+	test_bpftool.sh \
+	test_bpftool_metadata.sh \
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/prog_tests/metadata.c b/tools/testing/selftests/bpf/prog_tests/metadata.c
new file mode 100644
index 000000000000..086a601a3f74
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/metadata.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright 2020 Google LLC.
+ */
+
+#include <test_progs.h>
+#include <cgroup_helpers.h>
+#include <network_helpers.h>
+
+#include "metadata_unused.skel.h"
+#include "metadata_used.skel.h"
+
+static int duration;
+
+static void test_metadata_unused(void)
+{
+	struct metadata_unused *obj;
+	int err;
+
+	obj = metadata_unused__open_and_load();
+	if (CHECK(!obj, "skel-load", "errno %d", errno))
+		return;
+
+	/* Assert that we can access the metadata in skel and the values are
+	 * what we expect.
+	 */
+	if (CHECK(strncmp(obj->metadata->metadata_a, "foo",
+			  sizeof(obj->metadata->metadata_a)),
+		  "metadata_a", "expected \"foo\", value differ"))
+		goto close_bpf_object;
+	if (CHECK(obj->metadata->metadata_b != 1, "metadata_b",
+		  "expected 1, got %d", obj->metadata->metadata_b))
+		goto close_bpf_object;
+
+	/* Assert that binding metadata map to prog again results in EEXIST. */
+	err = bpf_prog_bind_map(bpf_program__fd(obj->progs.prog),
+				bpf_map__fd(obj->maps.metadata), NULL);
+	CHECK(!err || errno != EEXIST, "rebind_map",
+	      "errno %d, expected EEXIST", errno);
+
+close_bpf_object:
+	metadata_unused__destroy(obj);
+}
+
+static void test_metadata_used(void)
+{
+	struct metadata_used *obj;
+	int err;
+
+	obj = metadata_used__open_and_load();
+	if (CHECK(!obj, "skel-load", "errno %d", errno))
+		return;
+
+	/* Assert that we can access the metadata in skel and the values are
+	 * what we expect.
+	 */
+	if (CHECK(strncmp(obj->metadata->metadata_a, "bar",
+			  sizeof(obj->metadata->metadata_a)),
+		  "metadata_a", "expected \"bar\", value differ"))
+		goto close_bpf_object;
+	if (CHECK(obj->metadata->metadata_b != 2, "metadata_b",
+		  "expected 2, got %d", obj->metadata->metadata_b))
+		goto close_bpf_object;
+
+	/* Assert that binding metadata map to prog again results in EEXIST. */
+	err = bpf_prog_bind_map(bpf_program__fd(obj->progs.prog),
+				bpf_map__fd(obj->maps.metadata), NULL);
+	CHECK(!err || errno != EEXIST, "rebind_map",
+	      "errno %d, expected EEXIST", errno);
+
+close_bpf_object:
+	metadata_used__destroy(obj);
+}
+
+void test_metadata(void)
+{
+	if (test__start_subtest("unused"))
+		test_metadata_unused();
+
+	if (test__start_subtest("used"))
+		test_metadata_used();
+}
diff --git a/tools/testing/selftests/bpf/progs/metadata_unused.c b/tools/testing/selftests/bpf/progs/metadata_unused.c
new file mode 100644
index 000000000000..523b3c332426
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/metadata_unused.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char metadata_a[] SEC(".metadata") = "foo";
+int metadata_b SEC(".metadata") = 1;
+
+SEC("cgroup_skb/egress")
+int prog(struct xdp_md *ctx)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/metadata_used.c b/tools/testing/selftests/bpf/progs/metadata_used.c
new file mode 100644
index 000000000000..59785404f7bb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/metadata_used.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char metadata_a[] SEC(".metadata") = "bar";
+int metadata_b SEC(".metadata") = 2;
+
+SEC("cgroup_skb/egress")
+int prog(struct xdp_md *ctx)
+{
+	return metadata_b ? 1 : 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_bpftool_metadata.sh b/tools/testing/selftests/bpf/test_bpftool_metadata.sh
new file mode 100755
index 000000000000..a7515c09dc2d
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool_metadata.sh
@@ -0,0 +1,82 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TESTNAME=bpftool_metadata
+BPF_FS=$(awk '$3 == "bpf" {print $2; exit}' /proc/mounts)
+BPF_DIR=$BPF_FS/test_$TESTNAME
+
+_cleanup()
+{
+	set +e
+	rm -rf $BPF_DIR 2> /dev/null
+}
+
+cleanup_skip()
+{
+	echo "selftests: $TESTNAME [SKIP]"
+	_cleanup
+
+	exit $ksft_skip
+}
+
+cleanup()
+{
+	if [ "$?" = 0 ]; then
+		echo "selftests: $TESTNAME [PASS]"
+	else
+		echo "selftests: $TESTNAME [FAILED]"
+	fi
+	_cleanup
+}
+
+if [ $(id -u) -ne 0 ]; then
+	echo "selftests: $TESTNAME [SKIP] Need root privileges"
+	exit $ksft_skip
+fi
+
+if [ -z "$BPF_FS" ]; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without bpffs mounted"
+	exit $ksft_skip
+fi
+
+if ! bpftool version > /dev/null 2>&1; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without bpftool"
+	exit $ksft_skip
+fi
+
+set -e
+
+trap cleanup_skip EXIT
+
+mkdir $BPF_DIR
+
+trap cleanup EXIT
+
+bpftool prog load metadata_unused.o $BPF_DIR/unused
+
+METADATA_PLAIN="$(bpftool prog --metadata)"
+echo "$METADATA_PLAIN" | grep 'metadata_a = "foo"' > /dev/null
+echo "$METADATA_PLAIN" | grep 'metadata_b = 1' > /dev/null
+
+bpftool prog --metadata --json | grep '"metadata":{"metadata_a":"foo","metadata_b":1}' > /dev/null
+
+bpftool map | grep 'metada.metadata' > /dev/null
+
+rm $BPF_DIR/unused
+
+bpftool prog load metadata_used.o $BPF_DIR/used
+
+METADATA_PLAIN="$(bpftool prog --metadata)"
+echo "$METADATA_PLAIN" | grep 'metadata_a = "bar"' > /dev/null
+echo "$METADATA_PLAIN" | grep 'metadata_b = 2' > /dev/null
+
+bpftool prog --metadata --json | grep '"metadata":{"metadata_a":"bar","metadata_b":2}' > /dev/null
+
+bpftool map | grep 'metada.metadata' > /dev/null
+
+rm $BPF_DIR/used
+
+exit 0
-- 
2.28.0.402.g5ffc5be6b7-goog

