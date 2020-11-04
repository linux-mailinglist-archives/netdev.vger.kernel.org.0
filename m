Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05602A633F
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 12:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgKDL0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 06:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729427AbgKDL0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 06:26:15 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D8AC0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 03:26:13 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id a71so16690400edf.9
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 03:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XCJVvVC37q/FBSmwNc5ZxOB0A7aigYwdjEhLEv3R8Xg=;
        b=EHLGx+Ww685I4ungPQqZnCIINO8THUogzMVyMs7+SZYi8V9BmswLIEJta1UkriORlO
         Q2AEg93jXCd9FBsZ//QLqCGz+Y6z3OGUzikR/rFGsnxcnqIulg6qCF1VwCO3D+viTaKm
         /bkXTqETCSM/z7eWkzjfHUuZPsjTjjDGuXXkZ5IPLX26BoAlgVM39mf4KFYafUtoE+D5
         TKHjlrGLv3ecsvEuQoBuT3j2DGXzc6smebryFdOSaPbR2QGyrHkmIdGnDs1b3kfs755E
         osVbmCkf+s4ly5F/lgRXxFgIAP5JMViwJo+8AkvWvcu0nYVB//75raGpkyW8MB4pD1Fh
         EIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XCJVvVC37q/FBSmwNc5ZxOB0A7aigYwdjEhLEv3R8Xg=;
        b=A4JqK8L7rJXxwT4DK+ScxGoLjZRwAlwLtDnYVP0UJ2zqtaYkY/OUUMKNXq88aGS1sc
         07x421y/VPxGQPjI4Lfavv/rKKI7lVTNFPZuFfdJYhX4N5XbjeAIBLMfQc+i8u1dsg51
         CmoC0dZAQSx4QCDb0WcTsNXEgaXaEh9c40Mbh6+JfbBUcNBgozhhY61zJGnEd4DUxoz/
         5um4O2ez0QKquOpS+tSWi7fDOrOBoZuf5rECyEitUwbNXZIbMMdQKEFJY089cd4btnb2
         4Z8kZHF1SbKwkDb+WYP2tKePHhwtWN7yj5mjC8MJRdF3d2ggWZFHjnX5W5qYVVa4pXLy
         q02w==
X-Gm-Message-State: AOAM533+ajxi0+2dLyIByuTQjcX92wHbwlVkbJqA+FKHY4c4+PEwRL1M
        TcwZG3vr35lsDbLYKyurV0mk4g==
X-Google-Smtp-Source: ABdhPJzNE8ssFpCvJKh6CU7JpMesV+B+CO/XNtt+VJfiasHNeGK+C9NcNHIFXVBohss9u/35qwHqOw==
X-Received: by 2002:a05:6402:1bdb:: with SMTP id ch27mr24103555edb.63.1604489171826;
        Wed, 04 Nov 2020 03:26:11 -0800 (PST)
Received: from dverbeir-mobl.lan ([2a02:a03f:689e:3400:b894:bc77:ad21:b2db])
        by smtp.gmail.com with ESMTPSA id d20sm892456edz.14.2020.11.04.03.26.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 03:26:11 -0800 (PST)
From:   David Verbeiren <david.verbeiren@tessares.net>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH bpf v4] bpf: zero-fill re-used per-cpu map element
Date:   Wed,  4 Nov 2020 12:23:32 +0100
Message-Id: <20201104112332.15191-1-david.verbeiren@tessares.net>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201103154738.29809-1-david.verbeiren@tessares.net>
References: <20201103154738.29809-1-david.verbeiren@tessares.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zero-fill element values for all other cpus than current, just as
when not using prealloc. This is the only way the bpf program can
ensure known initial values for all cpus ('onallcpus' cannot be
set when coming from the bpf program).

The scenario is: bpf program inserts some elements in a per-cpu
map, then deletes some (or userspace does). When later adding
new elements using bpf_map_update_elem(), the bpf program can
only set the value of the new elements for the current cpu.
When prealloc is enabled, previously deleted elements are re-used.
Without the fix, values for other cpus remain whatever they were
when the re-used entry was previously freed.

A selftest is added to validate correct operation in above
scenario as well as in case of LRU per-cpu map element re-use.

Fixes: 6c9059817432 ("bpf: pre-allocate hash map elements")
Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
---

Notes:
    v4:
      - Replaced racy "once" test by getpgid syscall with
        check on pid. (Andrii)
      - Copyright lines use /* */ (Andrii)
    
    v3:
      - Added selftest that was initially provided as separate
        patch, and reworked to
        * use skeleton (Andrii, Song Liu)
        * skip test if <=1 CPU (Song Liu)
    
    v2:
      - Moved memset() to separate pcpu_init_value() function,
        which replaces pcpu_copy_value() but delegates to it
        for the cases where no memset() is needed (Andrii).
      - This function now also avoids doing the memset() for
        the current cpu for which the value must be set
        anyhow (Andrii).
      - Same pcpu_init_value() used for per-cpu LRU map
        (Andrii).

 kernel/bpf/hashtab.c                          |  30 ++-
 .../selftests/bpf/prog_tests/map_init.c       | 214 ++++++++++++++++++
 .../selftests/bpf/progs/test_map_init.c       |  33 +++
 3 files changed, 275 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_init.c

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1815e97d4c9c..1fccba6e88c4 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -821,6 +821,32 @@ static void pcpu_copy_value(struct bpf_htab *htab, void __percpu *pptr,
 	}
 }
 
+static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr,
+			    void *value, bool onallcpus)
+{
+	/* When using prealloc and not setting the initial value on all cpus,
+	 * zero-fill element values for other cpus (just as what happens when
+	 * not using prealloc). Otherwise, bpf program has no way to ensure
+	 * known initial values for cpus other than current one
+	 * (onallcpus=false always when coming from bpf prog).
+	 */
+	if (htab_is_prealloc(htab) && !onallcpus) {
+		u32 size = round_up(htab->map.value_size, 8);
+		int current_cpu = raw_smp_processor_id();
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			if (cpu == current_cpu)
+				bpf_long_memcpy(per_cpu_ptr(pptr, cpu), value,
+						size);
+			else
+				memset(per_cpu_ptr(pptr, cpu), 0, size);
+		}
+	} else {
+		pcpu_copy_value(htab, pptr, value, onallcpus);
+	}
+}
+
 static bool fd_htab_map_needs_adjust(const struct bpf_htab *htab)
 {
 	return htab->map.map_type == BPF_MAP_TYPE_HASH_OF_MAPS &&
@@ -891,7 +917,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 			}
 		}
 
-		pcpu_copy_value(htab, pptr, value, onallcpus);
+		pcpu_init_value(htab, pptr, value, onallcpus);
 
 		if (!prealloc)
 			htab_elem_set_ptr(l_new, key_size, pptr);
@@ -1183,7 +1209,7 @@ static int __htab_lru_percpu_map_update_elem(struct bpf_map *map, void *key,
 		pcpu_copy_value(htab, htab_elem_get_ptr(l_old, key_size),
 				value, onallcpus);
 	} else {
-		pcpu_copy_value(htab, htab_elem_get_ptr(l_new, key_size),
+		pcpu_init_value(htab, htab_elem_get_ptr(l_new, key_size),
 				value, onallcpus);
 		hlist_nulls_add_head_rcu(&l_new->hash_node, head);
 		l_new = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
new file mode 100644
index 000000000000..14a31109dd0e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (c) 2020 Tessares SA <http://www.tessares.net> */
+
+#include <test_progs.h>
+#include "test_map_init.skel.h"
+
+#define TEST_VALUE 0x1234
+#define FILL_VALUE 0xdeadbeef
+
+static int nr_cpus;
+static int duration;
+
+typedef unsigned long long map_key_t;
+typedef unsigned long long map_value_t;
+typedef struct {
+	map_value_t v; /* padding */
+} __bpf_percpu_val_align pcpu_map_value_t;
+
+
+static int map_populate(int map_fd, int num)
+{
+	pcpu_map_value_t value[nr_cpus];
+	int i, err;
+	map_key_t key;
+
+	for (i = 0; i < nr_cpus; i++)
+		bpf_percpu(value, i) = FILL_VALUE;
+
+	for (key = 1; key <= num; key++) {
+		err = bpf_map_update_elem(map_fd, &key, value, BPF_NOEXIST);
+		if (!ASSERT_OK(err, "bpf_map_update_elem"))
+			return -1;
+	}
+
+	return 0;
+}
+
+static struct test_map_init *setup(enum bpf_map_type map_type, int map_sz,
+			    int *map_fd, int populate)
+{
+	struct test_map_init *skel;
+	int err;
+
+	skel = test_map_init__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return NULL;
+
+	err = bpf_map__set_type(skel->maps.hashmap1, map_type);
+	if (!ASSERT_OK(err, "bpf_map__set_type"))
+		goto error;
+
+	err = bpf_map__set_max_entries(skel->maps.hashmap1, map_sz);
+	if (!ASSERT_OK(err, "bpf_map__set_max_entries"))
+		goto error;
+
+	err = test_map_init__load(skel);
+	if (!ASSERT_OK(err, "skel_load"))
+		goto error;
+
+	*map_fd = bpf_map__fd(skel->maps.hashmap1);
+	if (CHECK(*map_fd < 0, "bpf_map__fd", "failed\n"))
+		goto error;
+
+	err = map_populate(*map_fd, populate);
+	if (!ASSERT_OK(err, "map_populate"))
+		goto error_map;
+
+	return skel;
+
+error_map:
+	close(*map_fd);
+error:
+	test_map_init__destroy(skel);
+	return NULL;
+}
+
+/* executes bpf program that updates map with key, value */
+static int prog_run_insert_elem(struct test_map_init *skel, map_key_t key,
+				map_value_t value)
+{
+	struct test_map_init__bss *bss;
+
+	bss = skel->bss;
+
+	bss->inKey = key;
+	bss->inValue = value;
+	bss->inPid = getpid();
+
+	if (!ASSERT_OK(test_map_init__attach(skel), "skel_attach"))
+		return -1;
+
+	/* Let tracepoint trigger */
+	syscall(__NR_getpgid);
+
+	test_map_init__detach(skel);
+
+	return 0;
+}
+
+static int check_values_one_cpu(pcpu_map_value_t *value, map_value_t expected)
+{
+	int i, nzCnt = 0;
+	map_value_t val;
+
+	for (i = 0; i < nr_cpus; i++) {
+		val = bpf_percpu(value, i);
+		if (val) {
+			if (CHECK(val != expected, "map value",
+				  "unexpected for cpu %d: 0x%llx\n", i, val))
+				return -1;
+			nzCnt++;
+		}
+	}
+
+	if (CHECK(nzCnt != 1, "map value", "set for %d CPUs instead of 1!\n",
+		  nzCnt))
+		return -1;
+
+	return 0;
+}
+
+/* Add key=1 elem with values set for all CPUs
+ * Delete elem key=1
+ * Run bpf prog that inserts new key=1 elem with value=0x1234
+ *   (bpf prog can only set value for current CPU)
+ * Lookup Key=1 and check value is as expected for all CPUs:
+ *   value set by bpf prog for one CPU, 0 for all others
+ */
+static void test_pcpu_map_init(void)
+{
+	pcpu_map_value_t value[nr_cpus];
+	struct test_map_init *skel;
+	int map_fd, err;
+	map_key_t key;
+
+	/* max 1 elem in map so insertion is forced to reuse freed entry */
+	skel = setup(BPF_MAP_TYPE_PERCPU_HASH, 1, &map_fd, 1);
+	if (!ASSERT_OK_PTR(skel, "prog_setup"))
+		return;
+
+	/* delete element so the entry can be re-used*/
+	key = 1;
+	err = bpf_map_delete_elem(map_fd, &key);
+	if (!ASSERT_OK(err, "bpf_map_delete_elem"))
+		goto cleanup;
+
+	/* run bpf prog that inserts new elem, re-using the slot just freed */
+	err = prog_run_insert_elem(skel, key, TEST_VALUE);
+	if (!ASSERT_OK(err, "prog_run_insert_elem"))
+		goto cleanup;
+
+	/* check that key=1 was re-created by bpf prog */
+	err = bpf_map_lookup_elem(map_fd, &key, value);
+	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
+		goto cleanup;
+
+	/* and has expected values */
+	check_values_one_cpu(value, TEST_VALUE);
+
+cleanup:
+	test_map_init__destroy(skel);
+}
+
+/* Add key=1 and key=2 elems with values set for all CPUs
+ * Run bpf prog that inserts new key=3 elem
+ *   (only for current cpu; other cpus should have initial value = 0)
+ * Lookup Key=1 and check value is as expected for all CPUs
+ */
+static void test_pcpu_lru_map_init(void)
+{
+	pcpu_map_value_t value[nr_cpus];
+	struct test_map_init *skel;
+	int map_fd, err;
+	map_key_t key;
+
+	/* Set up LRU map with 2 elements, values filled for all CPUs.
+	 * With these 2 elements, the LRU map is full
+	 */
+	skel = setup(BPF_MAP_TYPE_LRU_PERCPU_HASH, 2, &map_fd, 2);
+	if (!ASSERT_OK_PTR(skel, "prog_setup"))
+		return;
+
+	/* run bpf prog that inserts new key=3 element, re-using LRU slot */
+	key = 3;
+	err = prog_run_insert_elem(skel, key, TEST_VALUE);
+	if (!ASSERT_OK(err, "prog_run_insert_elem"))
+		goto cleanup;
+
+	/* check that key=3 replaced one of earlier elements */
+	err = bpf_map_lookup_elem(map_fd, &key, value);
+	if (!ASSERT_OK(err, "bpf_map_lookup_elem"))
+		goto cleanup;
+
+	/* and has expected values */
+	check_values_one_cpu(value, TEST_VALUE);
+
+cleanup:
+	test_map_init__destroy(skel);
+}
+
+void test_map_init(void)
+{
+	nr_cpus = bpf_num_possible_cpus();
+	if (nr_cpus <= 1) {
+		printf("%s:SKIP: >1 cpu needed for this test\n", __func__);
+		test__skip();
+		return;
+	}
+
+	if (test__start_subtest("pcpu_map_init"))
+		test_pcpu_map_init();
+	if (test__start_subtest("pcpu_lru_map_init"))
+		test_pcpu_lru_map_init();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_map_init.c b/tools/testing/selftests/bpf/progs/test_map_init.c
new file mode 100644
index 000000000000..c89d28ead673
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_map_init.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Tessares SA <http://www.tessares.net> */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+__u64 inKey = 0;
+__u64 inValue = 0;
+__u32 inPid = 0;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 2);
+	__type(key, __u64);
+	__type(value, __u64);
+} hashmap1 SEC(".maps");
+
+
+SEC("tp/syscalls/sys_enter_getpgid")
+int sysenter_getpgid(const void *ctx)
+{
+	/* Just do it for once, when called from our own test prog. This
+	 * ensures the map value is only updated for a single CPU.
+	 */
+	int cur_pid = bpf_get_current_pid_tgid() >> 32;
+
+	if (cur_pid == inPid)
+		bpf_map_update_elem(&hashmap1, &inKey, &inValue, BPF_NOEXIST);
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.29.0

