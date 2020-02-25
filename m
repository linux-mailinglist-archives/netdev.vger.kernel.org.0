Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACFF016EF46
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731515AbgBYTpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:45:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:55680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731330AbgBYTpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 14:45:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E7829AB7F;
        Tue, 25 Feb 2020 19:45:01 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v3 5/5] selftests/bpf: Add test for "bpftool feature" command
Date:   Tue, 25 Feb 2020 20:44:43 +0100
Message-Id: <20200225194446.20651-6-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225194446.20651-1-mrostecki@opensuse.org>
References: <20200225194446.20651-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Python module with tests for "bpftool feature" command, which mainly
wheck whether the "full" option is working properly.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/testing/selftests/.gitignore          |   5 +-
 tools/testing/selftests/bpf/Makefile        |   3 +-
 tools/testing/selftests/bpf/test_bpftool.py | 179 ++++++++++++++++++++
 tools/testing/selftests/bpf/test_bpftool.sh |   5 +
 4 files changed, 190 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
 create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh

diff --git a/tools/testing/selftests/.gitignore b/tools/testing/selftests/.gitignore
index 61df01cdf0b2..304fdf1a21dc 100644
--- a/tools/testing/selftests/.gitignore
+++ b/tools/testing/selftests/.gitignore
@@ -3,4 +3,7 @@ gpiogpio-hammer
 gpioinclude/
 gpiolsgpio
 tpm2/SpaceTest.log
-tpm2/*.pyc
+
+# Python bytecode and cache
+__pycache__/
+*.py[cod]
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 2a583196fa51..2dffce6cc429 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -62,7 +62,8 @@ TEST_PROGS := test_kmod.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
 	test_xdping.sh \
-	test_bpftool_build.sh
+	test_bpftool_build.sh \
+	test_bpftool.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/test_bpftool.py b/tools/testing/selftests/bpf/test_bpftool.py
new file mode 100644
index 000000000000..c8e54843a487
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool.py
@@ -0,0 +1,179 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 SUSE LLC.
+
+import collections
+import functools
+import json
+import os
+import socket
+import subprocess
+import unittest
+
+
+# Add the source tree of bpftool and /usr/local/sbin to PATH
+cur_dir = os.path.dirname(os.path.realpath(__file__))
+bpftool_dir = os.path.abspath(os.path.join(cur_dir, "..", "..", "..", "..",
+                                           "tools", "bpf", "bpftool"))
+os.environ["PATH"] = bpftool_dir + ":/usr/local/sbin:" + os.environ["PATH"]
+
+
+class IfaceNotFoundError(Exception):
+    pass
+
+
+class UnprivilegedUserError(Exception):
+    pass
+
+
+def _bpftool(args, json=True):
+    _args = ["bpftool"]
+    if json:
+        _args.append("-j")
+    _args.extend(args)
+
+    res = subprocess.run(_args, capture_output=True)
+    return res.stdout
+
+
+def bpftool(args):
+    return _bpftool(args, json=False).decode("utf-8")
+
+
+def bpftool_json(args):
+    res = _bpftool(args)
+    return json.loads(res)
+
+
+def get_default_iface():
+    for iface in socket.if_nameindex():
+        if iface[1] != "lo":
+            return iface[1]
+    raise IfaceNotFoundError("Could not find any network interface to probe")
+
+
+def default_iface(f):
+    @functools.wraps(f)
+    def wrapper(*args, **kwargs):
+        iface = get_default_iface()
+        return f(*args, iface, **kwargs)
+    return wrapper
+
+
+class TestBpftool(unittest.TestCase):
+    @classmethod
+    def setUpClass(cls):
+        if os.getuid() != 0:
+            raise UnprivilegedUserError(
+                "This test suite needs root privileges")
+
+    @default_iface
+    def test_feature_dev_json(self, iface):
+        unexpected_helpers = [
+            "bpf_probe_write_user",
+            "bpf_trace_printk",
+        ]
+        expected_keys = [
+            "syscall_config",
+            "program_types",
+            "map_types",
+            "helpers",
+            "misc",
+        ]
+
+        res = bpftool_json(["feature", "probe", "dev", iface])
+        # Check if the result has all expected keys.
+        self.assertCountEqual(res.keys(), expected_keys)
+        # Check if unexpected helpers are not included in helpers probes
+        # result.
+        for helpers in res["helpers"].values():
+            for unexpected_helper in unexpected_helpers:
+                self.assertNotIn(unexpected_helper, helpers)
+
+    def test_feature_kernel(self):
+        test_cases = [
+            bpftool_json(["feature", "probe", "kernel"]),
+            bpftool_json(["feature", "probe"]),
+            bpftool_json(["feature"]),
+        ]
+        unexpected_helpers = [
+            "bpf_probe_write_user",
+            "bpf_trace_printk",
+        ]
+        expected_keys = [
+            "syscall_config",
+            "system_config",
+            "program_types",
+            "map_types",
+            "helpers",
+            "misc",
+        ]
+
+        for tc in test_cases:
+            # Check if the result has all expected keys.
+            self.assertCountEqual(tc.keys(), expected_keys)
+            # Check if unexpected helpers are not included in helpers probes
+            # result.
+            for helpers in tc["helpers"].values():
+                for unexpected_helper in unexpected_helpers:
+                    self.assertNotIn(unexpected_helper, helpers)
+
+    def test_feature_kernel_full(self):
+        test_cases = [
+            bpftool_json(["feature", "probe", "kernel", "full"]),
+            bpftool_json(["feature", "probe", "full"]),
+        ]
+        expected_helpers = [
+            "bpf_probe_write_user",
+            "bpf_trace_printk",
+        ]
+
+        for tc in test_cases:
+            # Check if expected helpers are included at least once in any
+            # helpers list for any program type. Unfortunately we cannot assume
+            # that they will be included in all program types or a specific
+            # subset of programs. It depends on the kernel version and
+            # configuration.
+            found_helpers = False
+
+            for helpers in tc["helpers"].values():
+                if all(expected_helper in helpers
+                       for expected_helper in expected_helpers):
+                    found_helpers = True
+                    break
+
+            self.assertTrue(found_helpers)
+
+    def test_feature_kernel_full_vs_not_full(self):
+        full_res = bpftool_json(["feature", "probe", "full"])
+        not_full_res = bpftool_json(["feature", "probe"])
+        not_full_set = set()
+        full_set = set()
+
+        for helpers in full_res["helpers"].values():
+            for helper in helpers:
+                full_set.add(helper)
+
+        for helpers in not_full_res["helpers"].values():
+            for helper in helpers:
+                not_full_set.add(helper)
+
+        self.assertCountEqual(full_set - not_full_set,
+                                {"bpf_probe_write_user", "bpf_trace_printk"})
+        self.assertCountEqual(not_full_set - full_set, set())
+
+    def test_feature_macros(self):
+        expected_patterns = [
+            r"/\*\*\* System call availability \*\*\*/",
+            r"#define HAVE_BPF_SYSCALL",
+            r"/\*\*\* eBPF program types \*\*\*/",
+            r"#define HAVE.*PROG_TYPE",
+            r"/\*\*\* eBPF map types \*\*\*/",
+            r"#define HAVE.*MAP_TYPE",
+            r"/\*\*\* eBPF helper functions \*\*\*/",
+            r"#define HAVE.*HELPER",
+            r"/\*\*\* eBPF misc features \*\*\*/",
+        ]
+
+        res = bpftool(["feature", "probe", "macros"])
+        for pattern in expected_patterns:
+            self.assertRegex(res, pattern)
diff --git a/tools/testing/selftests/bpf/test_bpftool.sh b/tools/testing/selftests/bpf/test_bpftool.sh
new file mode 100755
index 000000000000..66690778e36d
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2020 SUSE LLC.
+
+python3 -m unittest -v test_bpftool.TestBpftool
-- 
2.25.1

