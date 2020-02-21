Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7274166D4E
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 04:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgBUDQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 22:16:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:59654 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgBUDQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 22:16:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 28A52ADA3;
        Fri, 21 Feb 2020 03:16:37 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
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
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH bpf-next v2 5/5] selftests/bpf: Add test for "bpftool feature" command
Date:   Fri, 21 Feb 2020 04:17:00 +0100
Message-Id: <20200221031702.25292-6-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221031702.25292-1-mrostecki@opensuse.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
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
 tools/testing/selftests/bpf/test_bpftool.py | 228 ++++++++++++++++++++
 tools/testing/selftests/bpf/test_bpftool.sh |   5 +
 4 files changed, 239 insertions(+), 2 deletions(-)
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
index 257a1aaaa37d..e7d822259c50 100644
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
index 000000000000..7f545feaec98
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_bpftool.py
@@ -0,0 +1,228 @@
+# Copyright (c) 2020 SUSE LLC.
+#
+# This software is licensed under the GNU General License Version 2,
+# June 1991 as shown in the file COPYING in the top-level directory of this
+# source tree.
+#
+# THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS"
+# WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING,
+# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+# FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
+# OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME
+# THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
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
+# Probe sections
+SECTION_SYSTEM_CONFIG_PATTERN = b"Scanning system configuration..."
+SECTION_SYSCALL_CONFIG_PATTERN = b"Scanning system call availability..."
+SECTION_PROGRAM_TYPES_PATTERN = b"Scanning eBPF program types..."
+SECTION_MAP_TYPES_PATTERN = b"Scanning eBPF map types..."
+SECTION_HELPERS_PATTERN = b"Scanning eBPF helper functions..."
+SECTION_MISC_PATTERN = b"Scanning miscellaneous eBPF features..."
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
+    return _bpftool(args, json=False)
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
+            raise UnprivilegedUserError("This test suite eeeds root privileges")
+
+    def _assert_pattern_not_in_dict(self, dct, pattern, check_keys=False):
+        """Check if all string values inside dictionary do not containe the
+        given pattern.
+        """
+        for key, value in dct.items():
+            if check_keys:
+                self.assertNotIn(pattern, key)
+            if isinstance(value, dict):
+                self._assert_pattern_not_in_dict(value, pattern,
+                                                 check_keys=True)
+            elif isinstance(value, str):
+                self.assertNotIn(pattern, value)
+
+    @default_iface
+    def test_feature_dev(self, iface):
+        expected_patterns = [
+            SECTION_SYSCALL_CONFIG_PATTERN,
+            SECTION_PROGRAM_TYPES_PATTERN,
+            SECTION_MAP_TYPES_PATTERN,
+            SECTION_HELPERS_PATTERN,
+            SECTION_MISC_PATTERN,
+        ]
+        unexpected_patterns = [
+            b"bpf_trace_printk",
+            b"bpf_probe_write_user",
+        ]
+
+        res = bpftool(["feature", "probe", "dev", iface])
+        for pattern in expected_patterns:
+            self.assertIn(pattern, res)
+        for pattern in unexpected_patterns:
+            self.assertNotIn(pattern, res)
+
+    @default_iface
+    def test_feature_dev_json(self, iface):
+        expected_keys = [
+            "syscall_config",
+            "program_types",
+            "map_types",
+            "helpers",
+            "misc",
+        ]
+        unexpected_values = [
+            "bpf_trace_printk",
+            "bpf_probe_write_user",
+        ]
+
+        res = bpftool_json(["feature", "probe", "dev", iface])
+        self.assertCountEqual(res.keys(), expected_keys)
+        for value in unexpected_values:
+            self._assert_pattern_not_in_dict(res, value)
+
+    def test_feature_kernel(self):
+        expected_patterns = [
+            SECTION_SYSTEM_CONFIG_PATTERN,
+            SECTION_SYSCALL_CONFIG_PATTERN,
+            SECTION_PROGRAM_TYPES_PATTERN,
+            SECTION_MAP_TYPES_PATTERN,
+            SECTION_HELPERS_PATTERN,
+            SECTION_MISC_PATTERN,
+        ]
+        unexpected_patterns = [
+            b"bpf_trace_printk",
+            b"bpf_probe_write_user",
+        ]
+
+        res_default1 = bpftool(["feature"])
+        res_default2 = bpftool(["feature", "probe"])
+        res = bpftool(["feature", "probe", "kernel"])
+
+        for pattern in expected_patterns:
+            self.assertIn(pattern, res_default1)
+            self.assertIn(pattern, res_default2)
+            self.assertIn(pattern, res)
+        for pattern in unexpected_patterns:
+            self.assertNotIn(pattern, res_default1)
+            self.assertNotIn(pattern, res_default2)
+            self.assertNotIn(pattern, res)
+
+    def test_feature_kernel_full(self):
+        expected_patterns = [
+            SECTION_SYSTEM_CONFIG_PATTERN,
+            SECTION_SYSCALL_CONFIG_PATTERN,
+            SECTION_PROGRAM_TYPES_PATTERN,
+            SECTION_MAP_TYPES_PATTERN,
+            SECTION_HELPERS_PATTERN,
+            SECTION_MISC_PATTERN,
+            b"bpf_trace_printk",
+            b"bpf_probe_write_user",
+        ]
+
+        res_default = bpftool(["feature", "probe", "full"])
+        res = bpftool(["feature", "probe", "kernel", "full"])
+
+        for pattern in expected_patterns:
+            self.assertIn(pattern, res_default)
+            self.assertIn(pattern, res)
+
+    def test_feature_kernel_json(self):
+        expected_keys = [
+            "system_config",
+            "syscall_config",
+            "program_types",
+            "map_types",
+            "helpers",
+            "misc",
+        ]
+        unexpected_values = [
+            "bpf_trace_printk",
+            "bpf_probe_write_user",
+        ]
+
+        res_default1 = bpftool_json(["feature"])
+        self.assertCountEqual(res_default1.keys(), expected_keys)
+        for value in unexpected_values:
+            self._assert_pattern_not_in_dict(res_default1, value)
+
+        res_default2 = bpftool_json(["feature", "probe"])
+        self.assertCountEqual(res_default2.keys(), expected_keys)
+        for value in unexpected_values:
+            self._assert_pattern_not_in_dict(res_default2, value)
+
+        res = bpftool_json(["feature", "probe", "kernel"])
+        self.assertCountEqual(res.keys(), expected_keys)
+        for value in unexpected_values:
+            self._assert_pattern_not_in_dict(res, value)
+
+    def test_feature_macros(self):
+        expected_patterns = [
+            b"/\*\*\* System call availability \*\*\*/",
+            b"#define HAVE_BPF_SYSCALL",
+            b"/\*\*\* eBPF program types \*\*\*/",
+            b"#define HAVE.*PROG_TYPE",
+            b"/\*\*\* eBPF map types \*\*\*/",
+            b"#define HAVE.*MAP_TYPE",
+            b"/\*\*\* eBPF helper functions \*\*\*/",
+            b"#define HAVE.*HELPER",
+            b"/\*\*\* eBPF misc features \*\*\*/",
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
2.25.0

