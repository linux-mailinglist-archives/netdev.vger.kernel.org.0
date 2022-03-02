Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FF54CA350
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiCBLTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241746AbiCBLSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:18:35 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5EDC4B7C;
        Wed,  2 Mar 2022 03:16:05 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K7s4158THz67vZB;
        Wed,  2 Mar 2022 19:15:45 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 12:15:52 +0100
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
Subject: [PATCH v3 9/9] selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA policy
Date:   Wed, 2 Mar 2022 12:14:04 +0100
Message-ID: <20220302111404.193900-10-roberto.sassu@huawei.com>
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

Check that bpf_kernel_read_file() denies the reading of an IMA policy, by
ensuring that ima_setup.sh exits with an error.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../selftests/bpf/prog_tests/test_ima.c        | 17 +++++++++++++++++
 tools/testing/selftests/bpf/progs/ima.c        | 18 ++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index b13a141c4220..b13feceb38f1 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -59,6 +59,7 @@ static void test_init(struct ima__bss *bss)
 	bss->use_ima_file_hash = false;
 	bss->enable_bprm_creds_for_exec = false;
 	bss->enable_kernel_read_file = false;
+	bss->test_deny = false;
 }
 
 void test_test_ima(void)
@@ -200,6 +201,22 @@ void test_test_ima(void)
 	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
 	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
 
+	/*
+	 * Test #6
+	 * - Goal: ensure that the kernel_read_file hook denies an operation
+	 * - Expected result: 0 samples
+	 */
+	test_init(skel->bss);
+	skel->bss->enable_kernel_read_file = true;
+	skel->bss->test_deny = true;
+	err = _run_measured_process(measured_dir, &skel->bss->monitored_pid,
+				    "load-policy");
+	if (CHECK(!err, "run_measured_process #6", "err = %d\n", err))
+		goto close_clean;
+
+	err = ring_buffer__consume(ringbuf);
+	ASSERT_EQ(err, 0, "num_samples_or_err");
+
 close_clean:
 	snprintf(cmd, sizeof(cmd), "./ima_setup.sh cleanup %s", measured_dir);
 	err = system(cmd);
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index e3ce943c5c3d..e16a2c208481 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -21,6 +21,7 @@ char _license[] SEC("license") = "GPL";
 bool use_ima_file_hash;
 bool enable_bprm_creds_for_exec;
 bool enable_kernel_read_file;
+bool test_deny;
 
 static void ima_test_common(struct file *file)
 {
@@ -51,6 +52,17 @@ static void ima_test_common(struct file *file)
 	return;
 }
 
+static int ima_test_deny(void)
+{
+	u32 pid;
+
+	pid = bpf_get_current_pid_tgid() >> 32;
+	if (pid == monitored_pid && test_deny)
+		return -EPERM;
+
+	return 0;
+}
+
 SEC("lsm.s/bprm_committed_creds")
 void BPF_PROG(bprm_committed_creds, struct linux_binprm *bprm)
 {
@@ -71,6 +83,8 @@ SEC("lsm.s/kernel_read_file")
 int BPF_PROG(kernel_read_file, struct file *file, enum kernel_read_file_id id,
 	     bool contents)
 {
+	int ret;
+
 	if (!enable_kernel_read_file)
 		return 0;
 
@@ -80,6 +94,10 @@ int BPF_PROG(kernel_read_file, struct file *file, enum kernel_read_file_id id,
 	if (id != READING_POLICY)
 		return 0;
 
+	ret = ima_test_deny();
+	if (ret < 0)
+		return ret;
+
 	ima_test_common(file);
 	return 0;
 }
-- 
2.32.0

