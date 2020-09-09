Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C6C2635E8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729529AbgIISYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgIISYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:24:22 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C4CC061799
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 11:24:18 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l14so2381522pgm.6
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 11:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=uSHodFLWlUfGlLydQ5jSJNN2VPiTPUOh7WGERwhNze8=;
        b=iLN622kq/vPefBvo2kPG5W5adhvxLANF+wV1Nk6ycxoV/BbV2A6BoBw5VL5Z0b2azc
         AHL87109oHIfZ+F5GpZ4iy0gxZvHLuE3oqr6O8zAon6AY+bBvT9bYwVXRo/rYqtfMQg5
         77vnED+/SKD+zcP9Qx/WmQk9+loVQ0gVXTZr/pkourwKw4oAiDuRLdsh0Bgkbul3iT9p
         vgRthcuVZ41veOS4yc7CYekDU71HxGjfRr/KDpMAlw7pa4jAIXmc1ag0DhjfvmLyS3hM
         1uRynXIj/orGCKBMunYdvdbkmDi0MhhC7H0uxJMo14qXLN1dogw3PVRxYpZMoX+f9iBj
         jEQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uSHodFLWlUfGlLydQ5jSJNN2VPiTPUOh7WGERwhNze8=;
        b=ktqqmZN77WhIFgTyMcRsI1r59nxHtYtozpuFyFflGdYX3oZnUVQsv86/gfUj1C7Hw0
         ZlIWRFKKssCl9Z5oeZ8z0b5b4fSJ5wkOGYoY2iDbAio+Z8faZlCnuriTFcdWyG9U1AP8
         LVITIhXqc7TEpVJ5jqSQoCshWEANQNtASVXmtPeFU9Oe4JmYg3+sFBupNsDzUu9ukDqp
         mO2T498fhfRN9+MW3CY0alJ5/l7lriJ+dB+S93JLLqMRDO+cP4t34xI762v3wZ3CkKa6
         sUS333uBTtomFcxT/9/W7kJQTahb/gTiKnuCydtU2onQN31K3QyWzEwlJp7ZnY0ZZRGm
         9GZQ==
X-Gm-Message-State: AOAM531D0JwD9Uz+Uv/RftYcdjTMvp6v16h7LBhRXfuKKRe0fpJCov7r
        siVuBu1C3juw10CKEWpbsDkBkg/2sJw33hnUNavkZNnFR+MYdUA9HCFbGz9yO4RWgRDlL3ANPfX
        MEgiv/I4XLi1vtqqH4nyAlBb4iMAC14E1UrGyU9bisidjPIfNDcJGZQ==
X-Google-Smtp-Source: ABdhPJz+bGhWOfL72GGVzPXMqEYGoHT6OqqWTwt85QJ6f4FAo2TklVE2vVi6Uxr435KfPw3mne+Fp6M=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:aa7:9548:0:b029:13e:d13d:a08d with SMTP id
 w8-20020aa795480000b029013ed13da08dmr1952356pfq.36.1599675857829; Wed, 09 Sep
 2020 11:24:17 -0700 (PDT)
Date:   Wed,  9 Sep 2020 11:24:06 -0700
In-Reply-To: <20200909182406.3147878-1-sdf@google.com>
Message-Id: <20200909182406.3147878-6-sdf@google.com>
Mime-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH bpf-next v4 5/5] selftests/bpf: Test load and dump metadata
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
metadata values.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/metadata.c       | 81 ++++++++++++++++++
 .../selftests/bpf/progs/metadata_unused.c     | 15 ++++
 .../selftests/bpf/progs/metadata_used.c       | 15 ++++
 .../selftests/bpf/test_bpftool_metadata.sh    | 82 +++++++++++++++++++
 5 files changed, 195 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 65d3d9aaeb31..3c92db8a189a 100644
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
index 000000000000..dea8fa86b5fb
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/metadata.c
@@ -0,0 +1,81 @@
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
+	if (CHECK(strncmp(obj->rodata->bpf_metadata_a, "foo",
+			  sizeof(obj->rodata->bpf_metadata_a)),
+		  "bpf_metadata_a", "expected \"foo\", value differ"))
+		goto close_bpf_object;
+	if (CHECK(obj->rodata->bpf_metadata_b != 1, "bpf_metadata_b",
+		  "expected 1, got %d", obj->rodata->bpf_metadata_b))
+		goto close_bpf_object;
+
+	/* Assert that binding metadata map to prog again succeeds. */
+	err = bpf_prog_bind_map(bpf_program__fd(obj->progs.prog),
+				bpf_map__fd(obj->maps.rodata), NULL);
+	CHECK(err, "rebind_map", "errno %d, expected 0", errno);
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
+	if (CHECK(strncmp(obj->rodata->bpf_metadata_a, "bar",
+			  sizeof(obj->rodata->bpf_metadata_a)),
+		  "metadata_a", "expected \"bar\", value differ"))
+		goto close_bpf_object;
+	if (CHECK(obj->rodata->bpf_metadata_b != 2, "metadata_b",
+		  "expected 2, got %d", obj->rodata->bpf_metadata_b))
+		goto close_bpf_object;
+
+	/* Assert that binding metadata map to prog again succeeds. */
+	err = bpf_prog_bind_map(bpf_program__fd(obj->progs.prog),
+				bpf_map__fd(obj->maps.rodata), NULL);
+	CHECK(err, "rebind_map", "errno %d, expected 0", errno);
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
index 000000000000..db5b804f6f4c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/metadata_unused.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+const char bpf_metadata_a[] SEC(".rodata") = "foo";
+const int bpf_metadata_b SEC(".rodata") = 1;
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
index 000000000000..0dcb1ba2f0ae
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/metadata_used.c
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+const char bpf_metadata_a[] SEC(".rodata") = "bar";
+const int bpf_metadata_b SEC(".rodata") = 2;
+
+SEC("cgroup_skb/egress")
+int prog(struct xdp_md *ctx)
+{
+	return bpf_metadata_b ? 1 : 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_bpftool_metadata.sh b/tools/testing/selftests/bpf/test_bpftool_metadata.sh
new file mode 100755
index 000000000000..1bf81b49457a
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
+METADATA_PLAIN="$(bpftool prog)"
+echo "$METADATA_PLAIN" | grep 'a = "foo"' > /dev/null
+echo "$METADATA_PLAIN" | grep 'b = 1' > /dev/null
+
+bpftool prog --json | grep '"metadata":{"a":"foo","b":1}' > /dev/null
+
+bpftool map | grep 'metadata.rodata' > /dev/null
+
+rm $BPF_DIR/unused
+
+bpftool prog load metadata_used.o $BPF_DIR/used
+
+METADATA_PLAIN="$(bpftool prog)"
+echo "$METADATA_PLAIN" | grep 'a = "bar"' > /dev/null
+echo "$METADATA_PLAIN" | grep 'b = 2' > /dev/null
+
+bpftool prog --json | grep '"metadata":{"a":"bar","b":2}' > /dev/null
+
+bpftool map | grep 'metadata.rodata' > /dev/null
+
+rm $BPF_DIR/used
+
+exit 0
-- 
2.28.0.526.ge36021eeef-goog

