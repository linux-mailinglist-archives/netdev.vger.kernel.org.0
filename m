Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFEC64CA352
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbiCBLTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241738AbiCBLSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:18:35 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B037AC4B69;
        Wed,  2 Mar 2022 03:16:04 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s2j4DqTz67r9d;
        Wed,  2 Mar 2022 19:14:37 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:15:49 +0100
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
Subject: [PATCH v3 6/9] selftests/bpf: Check if the digest is refreshed after a file write
Date:   Wed, 2 Mar 2022 12:14:01 +0100
Message-ID: <20220302111404.193900-7-roberto.sassu@huawei.com>
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

Verify that bpf_ima_inode_hash() returns a non-fresh digest after a file
write, and that bpf_ima_file_hash() returns a fresh digest. Verification is
done by requesting the digest from the bprm_creds_for_exec hook, called
before ima_bprm_check().

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/ima_setup.sh      | 24 ++++++-
 .../selftests/bpf/prog_tests/test_ima.c       | 72 ++++++++++++++++++-
 tools/testing/selftests/bpf/progs/ima.c       | 11 +++
 3 files changed, 103 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/ima_setup.sh b/tools/testing/selftests/bpf/ima_setup.sh
index 8e62581113a3..a3de1cd43ba0 100755
--- a/tools/testing/selftests/bpf/ima_setup.sh
+++ b/tools/testing/selftests/bpf/ima_setup.sh
@@ -12,7 +12,7 @@ LOG_FILE="$(mktemp /tmp/ima_setup.XXXX.log)"
 
 usage()
 {
-	echo "Usage: $0 <setup|cleanup|run> <existing_tmp_dir>"
+	echo "Usage: $0 <setup|cleanup|run|modify-bin|restore-bin> <existing_tmp_dir>"
 	exit 1
 }
 
@@ -77,6 +77,24 @@ run()
 	exec "${copied_bin_path}"
 }
 
+modify_bin()
+{
+	local tmp_dir="$1"
+	local mount_dir="${tmp_dir}/mnt"
+	local copied_bin_path="${mount_dir}/$(basename ${TEST_BINARY})"
+
+	echo "mod" >> "${copied_bin_path}"
+}
+
+restore_bin()
+{
+	local tmp_dir="$1"
+	local mount_dir="${tmp_dir}/mnt"
+	local copied_bin_path="${mount_dir}/$(basename ${TEST_BINARY})"
+
+	truncate -s -4 "${copied_bin_path}"
+}
+
 catch()
 {
 	local exit_code="$1"
@@ -105,6 +123,10 @@ main()
 		cleanup "${tmp_dir}"
 	elif [[ "${action}" == "run" ]]; then
 		run "${tmp_dir}"
+	elif [[ "${action}" == "modify-bin" ]]; then
+		modify_bin "${tmp_dir}"
+	elif [[ "${action}" == "restore-bin" ]]; then
+		restore_bin "${tmp_dir}"
 	else
 		echo "Unknown action: ${action}"
 		exit 1
diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index acc911ba63fd..a0cfba0b4273 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -13,16 +13,17 @@
 
 #include "ima.skel.h"
 
-#define MAX_SAMPLES 2
+#define MAX_SAMPLES 4
 
-static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
+static int _run_measured_process(const char *measured_dir, u32 *monitored_pid,
+				 const char *cmd)
 {
 	int child_pid, child_status;
 
 	child_pid = fork();
 	if (child_pid == 0) {
 		*monitored_pid = getpid();
-		execlp("./ima_setup.sh", "./ima_setup.sh", "run", measured_dir,
+		execlp("./ima_setup.sh", "./ima_setup.sh", cmd, measured_dir,
 		       NULL);
 		exit(errno);
 
@@ -34,6 +35,11 @@ static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
 	return -EINVAL;
 }
 
+static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
+{
+	return _run_measured_process(measured_dir, monitored_pid, "run");
+}
+
 static u64 ima_hash_from_bpf[MAX_SAMPLES];
 static int ima_hash_from_bpf_idx;
 
@@ -51,6 +57,7 @@ static void test_init(struct ima__bss *bss)
 	ima_hash_from_bpf_idx = 0;
 
 	bss->use_ima_file_hash = false;
+	bss->enable_bprm_creds_for_exec = false;
 }
 
 void test_test_ima(void)
@@ -58,6 +65,7 @@ void test_test_ima(void)
 	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
 	struct ring_buffer *ringbuf = NULL;
 	const char *measured_dir;
+	u64 bin_true_sample;
 	char cmd[256];
 
 	int err, duration = 0;
@@ -114,6 +122,64 @@ void test_test_ima(void)
 	ASSERT_EQ(err, 2, "num_samples_or_err");
 	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
 	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
+	bin_true_sample = ima_hash_from_bpf[1];
+
+	/*
+	 * Test #3
+	 * - Goal: confirm that bpf_ima_inode_hash() returns a non-fresh digest
+	 * - Expected result: 2 samples (/bin/true: non-fresh, fresh)
+	 */
+	test_init(skel->bss);
+
+	err = _run_measured_process(measured_dir, &skel->bss->monitored_pid,
+				    "modify-bin");
+	if (CHECK(err, "modify-bin #3", "err = %d\n", err))
+		goto close_clean;
+
+	skel->bss->enable_bprm_creds_for_exec = true;
+	err = run_measured_process(measured_dir, &skel->bss->monitored_pid);
+	if (CHECK(err, "run_measured_process #3", "err = %d\n", err))
+		goto close_clean;
+
+	err = ring_buffer__consume(ringbuf);
+	ASSERT_EQ(err, 2, "num_samples_or_err");
+	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
+	ASSERT_EQ(ima_hash_from_bpf[0], bin_true_sample, "sample_equal_or_err");
+	/* IMA refreshed the digest. */
+	ASSERT_NEQ(ima_hash_from_bpf[1], bin_true_sample,
+		   "sample_different_or_err");
+
+	/*
+	 * Test #4
+	 * - Goal: verify that bpf_ima_file_hash() returns a fresh digest
+	 * - Expected result: 4 samples (./ima_setup.sh: fresh, fresh;
+	 *                               /bin/true: fresh, fresh)
+	 */
+	test_init(skel->bss);
+	skel->bss->use_ima_file_hash = true;
+	skel->bss->enable_bprm_creds_for_exec = true;
+	err = run_measured_process(measured_dir, &skel->bss->monitored_pid);
+	if (CHECK(err, "run_measured_process #4", "err = %d\n", err))
+		goto close_clean;
+
+	err = ring_buffer__consume(ringbuf);
+	ASSERT_EQ(err, 4, "num_samples_or_err");
+	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[2], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[3], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[2], bin_true_sample,
+		   "sample_different_or_err");
+	ASSERT_EQ(ima_hash_from_bpf[3], ima_hash_from_bpf[2],
+		  "sample_equal_or_err");
+
+	skel->bss->use_ima_file_hash = false;
+	skel->bss->enable_bprm_creds_for_exec = false;
+	err = _run_measured_process(measured_dir, &skel->bss->monitored_pid,
+				    "restore-bin");
+	if (CHECK(err, "restore-bin #3", "err = %d\n", err))
+		goto close_clean;
 
 close_clean:
 	snprintf(cmd, sizeof(cmd), "./ima_setup.sh cleanup %s", measured_dir);
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index e0b073dcfb5d..9633e5f2453d 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -19,6 +19,7 @@ struct {
 char _license[] SEC("license") = "GPL";
 
 bool use_ima_file_hash;
+bool enable_bprm_creds_for_exec;
 
 static void ima_test_common(struct file *file)
 {
@@ -54,3 +55,13 @@ void BPF_PROG(bprm_committed_creds, struct linux_binprm *bprm)
 {
 	ima_test_common(bprm->file);
 }
+
+SEC("lsm.s/bprm_creds_for_exec")
+int BPF_PROG(bprm_creds_for_exec, struct linux_binprm *bprm)
+{
+	if (!enable_bprm_creds_for_exec)
+		return 0;
+
+	ima_test_common(bprm->file);
+	return 0;
+}
-- 
2.32.0

