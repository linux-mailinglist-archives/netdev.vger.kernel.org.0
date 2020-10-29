Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9182429EA5C
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgJ2LSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbgJ2LS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 07:18:28 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF802C0613D2
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id t11so2576346edj.13
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCve2fqdX3eNfDkHydNsG1ArXsFgKs44/Cen4YHQRhc=;
        b=Rt2fU4VojLB9xvErHudVB8jLuZ1H4pDYHINrUlGVIFh956A+ak6vfplVj/PyGF/wR6
         kUYNhsaVQ+eRZdczfzvBBKSHbc291jSGfaVF5EHgqdKEU9CisHWI7UT7yqZsxQQSYktV
         OCFf+s/MB/su7dw/PZ/r9fl/Ex5dGIgshId0bAnwzl4FrV1V2lj0vOphUjN0e8XXJQ0a
         LrzM1IobgNfOjMsF4z31YUQSguZWUmHuvrdQmc1aS3McmGlxlrDMbygteLaUaw5C7gch
         7dNecrLLNvcX2HRw+EpoXXGgDzfAcdeYV/aMwJitKrgQn+VjmMaEw4Og1V8AWLrBtz9r
         3XtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCve2fqdX3eNfDkHydNsG1ArXsFgKs44/Cen4YHQRhc=;
        b=DYcQImviBOeygOj/sqa9EZbRM78chkeTMZ/4Wx3n7IZUDRXPRLjMcC/fNWwLnQo0Pw
         wLrRL0Nv73ApS0fPdsdUQQG/uWbjVl9lyrptjpwe/ZM5VJTpxWI62/RTC11ahmtuDMRS
         T1K3ZAKNzQ5NQMnM/dG68pg+Ym1UgwSmxIr176/B9DENf4Y28nl5hvTZMev47KHc8WTX
         AD/VTrhH82fn/0GjiwdwCvoRwMI8jEldfRdNzck5N9/2cKtp/JuGsFFd5XpcUKEqq37P
         V8FV36K8X4hyYZYyvVw8zx878GDHZUSPJQ/dl/akYKOM99/D+fSbp4cWrm5lMNTm7YOP
         TIlQ==
X-Gm-Message-State: AOAM532ouzFEhBIkdfRlOYy/suDA8aBrCw/9/N1j/+uT/+k5juE3TRcG
        KIfDApnLivj09j/LnOjzPdBv1iI/o9meUmAd
X-Google-Smtp-Source: ABdhPJzHM6Kh55jDDItpDcML3PR0jZUQ8wUM62ziJUdSVnAvdQ8026HGkyF8lmg3tdbch4S3XiNy1w==
X-Received: by 2002:a05:6402:b87:: with SMTP id cf7mr3517570edb.137.1603970306426;
        Thu, 29 Oct 2020 04:18:26 -0700 (PDT)
Received: from localhost.localdomain ([2a02:a03f:689e:3400:b894:bc77:ad21:b2db])
        by smtp.gmail.com with ESMTPSA id c19sm1302160edt.48.2020.10.29.04.18.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 29 Oct 2020 04:18:25 -0700 (PDT)
From:   David Verbeiren <david.verbeiren@tessares.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        David Verbeiren <david.verbeiren@tessares.net>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf] selftest/bpf: Validate initial values of per-cpu hash elems
Date:   Thu, 29 Oct 2020 12:17:30 +0100
Message-Id: <20201029111730.6881-1-david.verbeiren@tessares.net>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tests that when per-cpu hash map or LRU hash map elements are
re-used as a result of a bpf program inserting elements, the
element values for the other CPUs than the one executing the
BPF code are reset to 0.

This validates the fix proposed in:
https://lkml.kernel.org/bpf/20201027221324.27894-1-david.verbeiren@tessares.net/

Change-Id: I38bc7b3744ed40704a7b2cc6efa179fb344c4bee
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: David Verbeiren <david.verbeiren@tessares.net>
---
 .../selftests/bpf/prog_tests/map_init.c       | 204 ++++++++++++++++++
 1 file changed, 204 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_init.c

diff --git a/tools/testing/selftests/bpf/prog_tests/map_init.c b/tools/testing/selftests/bpf/prog_tests/map_init.c
new file mode 100644
index 000000000000..9640cf925908
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/map_init.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2020 Tessares SA <http://www.tessares.net>
+
+#include <test_progs.h>
+
+#define TEST_VALUE 0x1234
+
+static int nr_cpus;
+static int duration;
+static char bpf_log_buf[BPF_LOG_BUF_SIZE];
+
+typedef unsigned long long map_key_t;
+typedef unsigned long long map_value_t;
+typedef struct {
+	map_value_t v; /* padding */
+} __bpf_percpu_val_align pcpu_map_value_t;
+
+/* executes bpf program that updates map with key, value */
+static int bpf_prog_insert_elem(int fd, map_key_t key, map_value_t value)
+{
+	struct bpf_load_program_attr prog;
+	struct bpf_insn insns[] = {
+		BPF_LD_IMM64(BPF_REG_8, key),
+		BPF_LD_IMM64(BPF_REG_9, value),
+
+		/* update: R1=fd, R2=&key, R3=&value, R4=flags */
+		BPF_LD_MAP_FD(BPF_REG_1, fd),
+		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
+		BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_8, 0),
+		BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
+		BPF_ALU64_IMM(BPF_ADD, BPF_REG_3, -8),
+		BPF_STX_MEM(BPF_DW, BPF_REG_3, BPF_REG_9, 0),
+		BPF_MOV64_IMM(BPF_REG_4, 0),
+		BPF_EMIT_CALL(BPF_FUNC_map_update_elem),
+
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	char buf[64] = {};
+	int pfd, err;
+	__u32 retval = 0;
+
+	memset(&prog, 0, sizeof(prog));
+	prog.prog_type = BPF_PROG_TYPE_SCHED_CLS;
+	prog.insns = insns;
+	prog.insns_cnt = ARRAY_SIZE(insns);
+	prog.license = "GPL";
+
+	pfd = bpf_load_program_xattr(&prog, bpf_log_buf, BPF_LOG_BUF_SIZE);
+	if (CHECK(pfd < 0, "bpf_load_program_xattr", "failed: %s\n%s\n",
+		  strerror(errno), bpf_log_buf))
+		return -1;
+
+	err = bpf_prog_test_run(pfd, 1, buf, sizeof(buf), NULL, NULL,
+				&retval, NULL);
+	if (CHECK(err || retval, "bpf_prog_test_run",
+		  "err=%d retval=%d errno=%d\n", err, retval, errno))
+		err = -1;
+
+	close(pfd);
+
+	return err;
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
+			if (val != expected) {
+				PRINT_FAIL("Unexpected value (cpu %d): 0x%llx\n",
+					   i, val);
+				return -1;
+			}
+			nzCnt++;
+		}
+	}
+
+	if (CHECK(nzCnt != 1, "non-zero-count",
+		   "Map value set for %d CPUs instead of 1!\n", nzCnt))
+		return -1;
+
+	return 0;
+}
+
+static int map_setup(int map_type, int max, int num)
+{
+	pcpu_map_value_t value[nr_cpus];
+	int map_fd, i, err;
+	map_key_t key;
+
+	map_fd = bpf_create_map(map_type, sizeof(key),
+				sizeof(pcpu_map_value_t), 2, 0);
+	if (CHECK(map_fd < 0, "bpf_create_map", "failed: %s\n",
+		  strerror(errno)))
+		return -1;
+
+	for (i = 0; i < nr_cpus; i++)
+		bpf_percpu(value, i) = 0xdeadbeef;
+
+	for (key = 1; key <= num; key++) {
+		err = bpf_map_update_elem(map_fd, &key, value, BPF_NOEXIST);
+		if (CHECK(err, "bpf_map_update_elem", "(key=%llu) failed: %s\n",
+			  key, strerror(errno))) {
+			close(map_fd);
+			return -1;
+		}
+	}
+
+	return map_fd;
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
+	int map_fd, err;
+	map_key_t key;
+
+	/* set up map with 1 element, value filled for all CPUs */
+	map_fd = map_setup(BPF_MAP_TYPE_PERCPU_HASH, 2, 1);
+	if (CHECK(map_fd < 0, "map_setup", "failed\n"))
+		return;
+
+	/* delete key=1 element so it will later be re-used*/
+	key = 1;
+	err = bpf_map_delete_elem(map_fd, &key);
+	if (CHECK(err, "bpf_map_delete_elem", "failed: %s\n", strerror(errno)))
+		goto error_map;
+
+	/* run bpf prog that inserts new elem, re-using the slot just freed */
+	err = bpf_prog_insert_elem(map_fd, key, TEST_VALUE);
+	if (!ASSERT_OK(err, "bpf_prog_insert_elem"))
+		goto error_map;
+
+	/* check that key=1 was re-created by bpf prog */
+	err = bpf_map_lookup_elem(map_fd, &key, value);
+	if (CHECK(err, "bpf_map_lookup_elem", "failed: %s\n", strerror(errno)))
+		goto error_map;
+
+	/* and has expected value for just a single CPU, 0 for all others */
+	check_values_one_cpu(value, TEST_VALUE);
+
+error_map:
+	close(map_fd);
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
+	int map_fd, err;
+	map_key_t key;
+
+	/* Set up LRU map with 2 elements, values filled for all CPUs.
+	 * With these 2 elements, the LRU map is full
+	 */
+	map_fd = map_setup(BPF_MAP_TYPE_LRU_PERCPU_HASH, 2, 2);
+	if (CHECK(map_fd < 0, "map_setup", "failed\n"))
+		return;
+
+	/* run bpf prog that inserts new key=3 element, re-using LRU slot */
+	key = 3;
+	err = bpf_prog_insert_elem(map_fd, key, TEST_VALUE);
+	if (!ASSERT_OK(err, "bpf_prog_insert_elem"))
+		goto error_map;
+
+	/* check that key=3 present */
+	err = bpf_map_lookup_elem(map_fd, &key, value);
+	if (CHECK(err, "bpf_map_lookup_elem", "failed: %s\n", strerror(errno)))
+		goto error_map;
+
+	/* and has expected value for just a single CPU, 0 for all others */
+	check_values_one_cpu(value, TEST_VALUE);
+
+error_map:
+	close(map_fd);
+}
+
+void test_map_init(void)
+{
+	nr_cpus = bpf_num_possible_cpus();
+	if (CHECK(nr_cpus <= 1, "nr_cpus", "> 1 needed for this test"))
+		return;
+
+	if (test__start_subtest("pcpu_map_init"))
+		test_pcpu_map_init();
+	if (test__start_subtest("pcpu_lru_map_init"))
+		test_pcpu_lru_map_init();
+}
-- 
2.29.0

