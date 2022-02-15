Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA154B6C76
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237989AbiBOMoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:44:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237969AbiBOMnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:43:42 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F97F20F46;
        Tue, 15 Feb 2022 04:43:03 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JygcY3VYqz67Ybb;
        Tue, 15 Feb 2022 20:38:37 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 13:43:01 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 6/6] selftests/bpf: Add test for bpf_lsm_kernel_read_file()
Date:   Tue, 15 Feb 2022 13:40:42 +0100
Message-ID: <20220215124042.186506-7-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220215124042.186506-1-roberto.sassu@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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
 tools/testing/selftests/bpf/ima_setup.sh      |  2 ++
 .../selftests/bpf/prog_tests/test_ima.c       |  3 +-
 tools/testing/selftests/bpf/progs/ima.c       | 28 ++++++++++++++++---
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/ima_setup.sh b/tools/testing/selftests/bpf/ima_setup.sh
index 8e62581113a3..82530f19f85a 100755
--- a/tools/testing/selftests/bpf/ima_setup.sh
+++ b/tools/testing/selftests/bpf/ima_setup.sh
@@ -51,6 +51,7 @@ setup()
 
 	ensure_mount_securityfs
 	echo "measure func=BPRM_CHECK fsuuid=${mount_uuid}" > ${IMA_POLICY_FILE}
+	echo "measure func=BPRM_CHECK fsuuid=${mount_uuid}" > ${mount_dir}/policy_test
 }
 
 cleanup() {
@@ -74,6 +75,7 @@ run()
 	local mount_dir="${tmp_dir}/mnt"
 	local copied_bin_path="${mount_dir}/$(basename ${TEST_BINARY})"
 
+	echo ${mount_dir}/policy_test > ${IMA_POLICY_FILE}
 	exec "${copied_bin_path}"
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 62bf0e830453..c4a62d7b70df 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -97,8 +97,9 @@ void test_test_ima(void)
 	/*
 	 * 1 sample with use_ima_file_hash = false
 	 * 2 samples with use_ima_file_hash = true (./ima_setup.sh, /bin/true)
+	 * 1 sample with use_ima_file_hash = true (IMA policy)
 	 */
-	ASSERT_EQ(err, 3, "num_samples_or_err");
+	ASSERT_EQ(err, 4, "num_samples_or_err");
 	ASSERT_NEQ(ima_hash_from_bpf, 0, "ima_hash");
 
 close_clean:
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index 9bb63f96cfc0..9b4c03f30a1c 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -20,8 +20,7 @@ char _license[] SEC("license") = "GPL";
 
 bool use_ima_file_hash;
 
-SEC("lsm.s/bprm_committed_creds")
-void BPF_PROG(ima, struct linux_binprm *bprm)
+static void ima_test_common(struct file *file)
 {
 	u64 ima_hash = 0;
 	u64 *sample;
@@ -31,10 +30,10 @@ void BPF_PROG(ima, struct linux_binprm *bprm)
 	pid = bpf_get_current_pid_tgid() >> 32;
 	if (pid == monitored_pid) {
 		if (!use_ima_file_hash)
-			ret = bpf_ima_inode_hash(bprm->file->f_inode, &ima_hash,
+			ret = bpf_ima_inode_hash(file->f_inode, &ima_hash,
 						 sizeof(ima_hash));
 		else
-			ret = bpf_ima_file_hash(bprm->file, &ima_hash,
+			ret = bpf_ima_file_hash(file, &ima_hash,
 						sizeof(ima_hash));
 		if (ret < 0 || ima_hash == 0)
 			return;
@@ -49,3 +48,24 @@ void BPF_PROG(ima, struct linux_binprm *bprm)
 
 	return;
 }
+
+SEC("lsm.s/bprm_committed_creds")
+void BPF_PROG(ima, struct linux_binprm *bprm)
+{
+	ima_test_common(bprm->file);
+}
+
+SEC("lsm.s/kernel_read_file")
+int BPF_PROG(kernel_read_file, struct file *file, enum kernel_read_file_id id,
+	     bool contents)
+{
+	if (!contents)
+		return 0;
+
+	if (id != READING_POLICY)
+		return 0;
+
+	ima_test_common(file);
+
+	return 0;
+}
-- 
2.32.0

