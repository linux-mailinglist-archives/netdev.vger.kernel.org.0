Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8429A4CA35B
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbiCBLTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:19:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241726AbiCBLSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:18:30 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FCAC4B62;
        Wed,  2 Mar 2022 03:16:04 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s2n1t9Zz67Z6v;
        Wed,  2 Mar 2022 19:14:41 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:15:48 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <revest@chromium.org>,
        <gregkh@linuxfoundation.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v3 5/9] selftests/bpf: Add test for bpf_ima_file_hash()
Date:   Wed, 2 Mar 2022 12:14:00 +0100
Message-ID: <20220302111404.193900-6-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302111404.193900-1-roberto.sassu@huawei.com>
References: <20220302111404.193900-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new test to ensure that bpf_ima_file_hash() returns the digest of the
executed files.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../selftests/bpf/prog_tests/test_ima.c       | 43 +++++++++++++++++--
 tools/testing/selftests/bpf/progs/ima.c       | 10 ++++-
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 97d8a6f84f4a..acc911ba63fd 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -13,6 +13,8 @@
 
 #include "ima.skel.h"
 
+#define MAX_SAMPLES 2
+
 static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
 {
 	int child_pid, child_status;
@@ -32,14 +34,25 @@ static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
 	return -EINVAL;
 }
 
-static u64 ima_hash_from_bpf;
+static u64 ima_hash_from_bpf[MAX_SAMPLES];
+static int ima_hash_from_bpf_idx;
 
 static int process_sample(void *ctx, void *data, size_t len)
 {
-	ima_hash_from_bpf = *((u64 *)data);
+	if (ima_hash_from_bpf_idx >= MAX_SAMPLES)
+		return -ENOSPC;
+
+	ima_hash_from_bpf[ima_hash_from_bpf_idx++] = *((u64 *)data);
 	return 0;
 }
 
+static void test_init(struct ima__bss *bss)
+{
+	ima_hash_from_bpf_idx = 0;
+
+	bss->use_ima_file_hash = false;
+}
+
 void test_test_ima(void)
 {
 	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
@@ -72,13 +85,35 @@ void test_test_ima(void)
 	if (CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno))
 		goto close_clean;
 
+	/*
+	 * Test #1
+	 * - Goal: obtain a sample with the bpf_ima_inode_hash() helper
+	 * - Expected result:  1 sample (/bin/true)
+	 */
+	test_init(skel->bss);
 	err = run_measured_process(measured_dir, &skel->bss->monitored_pid);
-	if (CHECK(err, "run_measured_process", "err = %d\n", err))
+	if (CHECK(err, "run_measured_process #1", "err = %d\n", err))
 		goto close_clean;
 
 	err = ring_buffer__consume(ringbuf);
 	ASSERT_EQ(err, 1, "num_samples_or_err");
-	ASSERT_NEQ(ima_hash_from_bpf, 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
+
+	/*
+	 * Test #2
+	 * - Goal: obtain samples with the bpf_ima_file_hash() helper
+	 * - Expected result: 2 samples (./ima_setup.sh, /bin/true)
+	 */
+	test_init(skel->bss);
+	skel->bss->use_ima_file_hash = true;
+	err = run_measured_process(measured_dir, &skel->bss->monitored_pid);
+	if (CHECK(err, "run_measured_process #2", "err = %d\n", err))
+		goto close_clean;
+
+	err = ring_buffer__consume(ringbuf);
+	ASSERT_EQ(err, 2, "num_samples_or_err");
+	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
 
 close_clean:
 	snprintf(cmd, sizeof(cmd), "./ima_setup.sh cleanup %s", measured_dir);
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index b5a0de50d1b4..e0b073dcfb5d 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -18,6 +18,8 @@ struct {
 
 char _license[] SEC("license") = "GPL";
 
+bool use_ima_file_hash;
+
 static void ima_test_common(struct file *file)
 {
 	u64 ima_hash = 0;
@@ -27,8 +29,12 @@ static void ima_test_common(struct file *file)
 
 	pid = bpf_get_current_pid_tgid() >> 32;
 	if (pid == monitored_pid) {
-		ret = bpf_ima_inode_hash(file->f_inode, &ima_hash,
-					 sizeof(ima_hash));
+		if (!use_ima_file_hash)
+			ret = bpf_ima_inode_hash(file->f_inode, &ima_hash,
+						 sizeof(ima_hash));
+		else
+			ret = bpf_ima_file_hash(file, &ima_hash,
+						sizeof(ima_hash));
 		if (ret < 0 || ima_hash == 0)
 			return;
 
-- 
2.32.0

