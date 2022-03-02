Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E554CA34E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241405AbiCBLTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:19:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241739AbiCBLSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:18:35 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FDFC4B7B;
        Wed,  2 Mar 2022 03:16:05 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s2l3lsFz67xDf;
        Wed,  2 Mar 2022 19:14:39 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:15:51 +0100
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
Subject: [PATCH v3 8/9] selftests/bpf: Add test for bpf_lsm_kernel_read_file()
Date:   Wed, 2 Mar 2022 12:14:03 +0100
Message-ID: <20220302111404.193900-9-roberto.sassu@huawei.com>
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

Test the ability of bpf_lsm_kernel_read_file() to call the sleepable
functions bpf_ima_inode_hash() or bpf_ima_file_hash() to obtain a
measurement of a loaded IMA policy.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/ima_setup.sh      | 13 ++++++++++++-
 .../selftests/bpf/prog_tests/test_ima.c       | 19 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/ima.c       | 18 ++++++++++++++++++
 3 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/ima_setup.sh b/tools/testing/selftests/bpf/ima_setup.sh
index a3de1cd43ba0..8ecead4ccad0 100755
--- a/tools/testing/selftests/bpf/ima_setup.sh
+++ b/tools/testing/selftests/bpf/ima_setup.sh
@@ -12,7 +12,7 @@ LOG_FILE="$(mktemp /tmp/ima_setup.XXXX.log)"
 
 usage()
 {
-	echo "Usage: $0 <setup|cleanup|run|modify-bin|restore-bin> <existing_tmp_dir>"
+	echo "Usage: $0 <setup|cleanup|run|modify-bin|restore-bin|load-policy> <existing_tmp_dir>"
 	exit 1
 }
 
@@ -51,6 +51,7 @@ setup()
 
 	ensure_mount_securityfs
 	echo "measure func=BPRM_CHECK fsuuid=${mount_uuid}" > ${IMA_POLICY_FILE}
+	echo "measure func=BPRM_CHECK fsuuid=${mount_uuid}" > ${mount_dir}/policy_test
 }
 
 cleanup() {
@@ -95,6 +96,14 @@ restore_bin()
 	truncate -s -4 "${copied_bin_path}"
 }
 
+load_policy()
+{
+	local tmp_dir="$1"
+	local mount_dir="${tmp_dir}/mnt"
+
+	echo ${mount_dir}/policy_test > ${IMA_POLICY_FILE} 2> /dev/null
+}
+
 catch()
 {
 	local exit_code="$1"
@@ -127,6 +136,8 @@ main()
 		modify_bin "${tmp_dir}"
 	elif [[ "${action}" == "restore-bin" ]]; then
 		restore_bin "${tmp_dir}"
+	elif [[ "${action}" == "load-policy" ]]; then
+		load_policy "${tmp_dir}"
 	else
 		echo "Unknown action: ${action}"
 		exit 1
diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index a0cfba0b4273..b13a141c4220 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -58,6 +58,7 @@ static void test_init(struct ima__bss *bss)
 
 	bss->use_ima_file_hash = false;
 	bss->enable_bprm_creds_for_exec = false;
+	bss->enable_kernel_read_file = false;
 }
 
 void test_test_ima(void)
@@ -181,6 +182,24 @@ void test_test_ima(void)
 	if (CHECK(err, "restore-bin #3", "err = %d\n", err))
 		goto close_clean;
 
+	/*
+	 * Test #5
+	 * - Goal: obtain a sample from the kernel_read_file hook
+	 * - Expected result: 2 samples (./ima_setup.sh, policy_test)
+	 */
+	test_init(skel->bss);
+	skel->bss->use_ima_file_hash = true;
+	skel->bss->enable_kernel_read_file = true;
+	err = _run_measured_process(measured_dir, &skel->bss->monitored_pid,
+				    "load-policy");
+	if (CHECK(err, "run_measured_process #5", "err = %d\n", err))
+		goto close_clean;
+
+	err = ring_buffer__consume(ringbuf);
+	ASSERT_EQ(err, 2, "num_samples_or_err");
+	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
+	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
+
 close_clean:
 	snprintf(cmd, sizeof(cmd), "./ima_setup.sh cleanup %s", measured_dir);
 	err = system(cmd);
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index 9633e5f2453d..e3ce943c5c3d 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -20,6 +20,7 @@ char _license[] SEC("license") = "GPL";
 
 bool use_ima_file_hash;
 bool enable_bprm_creds_for_exec;
+bool enable_kernel_read_file;
 
 static void ima_test_common(struct file *file)
 {
@@ -65,3 +66,20 @@ int BPF_PROG(bprm_creds_for_exec, struct linux_binprm *bprm)
 	ima_test_common(bprm->file);
 	return 0;
 }
+
+SEC("lsm.s/kernel_read_file")
+int BPF_PROG(kernel_read_file, struct file *file, enum kernel_read_file_id id,
+	     bool contents)
+{
+	if (!enable_kernel_read_file)
+		return 0;
+
+	if (!contents)
+		return 0;
+
+	if (id != READING_POLICY)
+		return 0;
+
+	ima_test_common(file);
+	return 0;
+}
-- 
2.32.0

