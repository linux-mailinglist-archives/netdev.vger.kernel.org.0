Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4699629F5F1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgJ2UPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:15:40 -0400
Received: from mx.der-flo.net ([193.160.39.236]:47174 "EHLO mx.der-flo.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgJ2UPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 16:15:39 -0400
Received: by mx.der-flo.net (Postfix, from userid 110)
        id 7956F4431A; Thu, 29 Oct 2020 21:15:37 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1203:ecb0:3930:146b:10e2:afb5:be30])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 971B744315;
        Thu, 29 Oct 2020 21:15:30 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, Florian Lehner <dev@der-flo.net>
Subject: [PATCH bpf-next v5] bpf: Lift hashtab key_size limit
Date:   Thu, 29 Oct 2020 21:14:42 +0100
Message-Id: <20201029201442.596690-1-dev@der-flo.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently key_size of hashtab is limited to MAX_BPF_STACK.
As the key of hashtab can also be a value from a per cpu map it can be
larger than MAX_BPF_STACK.

The use-case for this patch originates to implement allow/disallow
lists for files and file paths. The maximum length of file paths is
defined by PATH_MAX with 4096 chars including nul.
This limit exceeds MAX_BPF_STACK.

Changelog:

v5:
 - Fix cast overflow

v4:
 - Utilize BPF skeleton in tests
 - Rebase

v3:
 - Rebase

v2:
 - Add a test for bpf side

Signed-off-by: Florian Lehner <dev@der-flo.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/hashtab.c                          | 16 +++----
 .../selftests/bpf/prog_tests/hash_large_key.c | 43 ++++++++++++++++++
 .../selftests/bpf/progs/test_hash_large_key.c | 44 +++++++++++++++++++
 tools/testing/selftests/bpf/test_maps.c       |  3 +-
 4 files changed, 94 insertions(+), 12 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1815e97d4c9c..893a60ccb2df 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -390,17 +390,11 @@ static int htab_map_alloc_check(union bpf_attr *attr)
 	    attr->value_size == 0)
 		return -EINVAL;
 
-	if (attr->key_size > MAX_BPF_STACK)
-		/* eBPF programs initialize keys on stack, so they cannot be
-		 * larger than max stack size
-		 */
-		return -E2BIG;
-
-	if (attr->value_size >= KMALLOC_MAX_SIZE -
-	    MAX_BPF_STACK - sizeof(struct htab_elem))
-		/* if value_size is bigger, the user space won't be able to
-		 * access the elements via bpf syscall. This check also makes
-		 * sure that the elem_size doesn't overflow and it's
+	if ((u64)attr->key_size + attr->value_size >= KMALLOC_MAX_SIZE -
+	   sizeof(struct htab_elem))
+		/* if key_size + value_size is bigger, the user space won't be
+		 * able to access the elements via bpf syscall. This check
+		 * also makes sure that the elem_size doesn't overflow and it's
 		 * kmalloc-able later in htab_map_update_elem()
 		 */
 		return -E2BIG;
diff --git a/tools/testing/selftests/bpf/prog_tests/hash_large_key.c b/tools/testing/selftests/bpf/prog_tests/hash_large_key.c
new file mode 100644
index 000000000000..34684c0fc76d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/hash_large_key.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "test_hash_large_key.skel.h"
+
+void test_hash_large_key(void)
+{
+	int err, value = 21, duration = 0, hash_map_fd;
+	struct test_hash_large_key *skel;
+
+	struct bigelement {
+		int a;
+		char b[4096];
+		long long c;
+	} key;
+	bzero(&key, sizeof(key));
+
+	skel = test_hash_large_key__open_and_load();
+	if (CHECK(!skel, "skel_open_and_load", "skeleton open/load failed\n"))
+		return;
+
+	hash_map_fd = bpf_map__fd(skel->maps.hash_map);
+	if (CHECK(hash_map_fd < 0, "bpf_map__fd", "failed\n"))
+		goto cleanup;
+
+	err = test_hash_large_key__attach(skel);
+	if (CHECK(err, "attach_raw_tp", "err %d\n", err))
+		goto cleanup;
+
+	err = bpf_map_update_elem(hash_map_fd, &key, &value, BPF_ANY);
+	if (CHECK(err, "bpf_map_update_elem", "errno=%d\n", errno))
+		goto cleanup;
+
+	key.c = 1;
+	err = bpf_map_lookup_elem(hash_map_fd, &key, &value);
+	if (CHECK(err, "bpf_map_lookup_elem", "errno=%d\n", errno))
+		goto cleanup;
+
+	CHECK_FAIL(value != 42);
+
+cleanup:
+	test_hash_large_key__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_hash_large_key.c b/tools/testing/selftests/bpf/progs/test_hash_large_key.c
new file mode 100644
index 000000000000..473a22794a62
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_hash_large_key.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 2);
+	__type(key, struct bigelement);
+	__type(value, __u32);
+} hash_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct bigelement);
+} key_map SEC(".maps");
+
+struct bigelement {
+	int a;
+	char b[4096];
+	long long c;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int bpf_hash_large_key_test(void *ctx)
+{
+	int zero = 0, err = 1, value = 42;
+	struct bigelement *key;
+
+	key = bpf_map_lookup_elem(&key_map, &zero);
+	if (!key)
+		return 0;
+
+	key->c = 1;
+	if (bpf_map_update_elem(&hash_map, key, &value, BPF_ANY))
+		return 0;
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 0d92ebcb335d..0ad3e6305ff0 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1223,9 +1223,10 @@ static void test_map_in_map(void)
 
 static void test_map_large(void)
 {
+
 	struct bigkey {
 		int a;
-		char b[116];
+		char b[4096];
 		long long c;
 	} key;
 	int fd, i, value;
-- 
2.26.2

