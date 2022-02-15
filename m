Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDAE44B6C5C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiBOMmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:42:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237807AbiBOMmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:42:08 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E300140D1;
        Tue, 15 Feb 2022 04:41:43 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jygg61fqbz67y8P;
        Tue, 15 Feb 2022 20:40:50 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 13:41:41 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 4/6] selftests/bpf: Add test for bpf_ima_file_hash()
Date:   Tue, 15 Feb 2022 13:40:40 +0100
Message-ID: <20220215124042.186506-5-roberto.sassu@huawei.com>
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

Modify the existing IMA test to call bpf_ima_file_hash() and update the
expected result accordingly.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../selftests/bpf/prog_tests/test_ima.c       | 29 ++++++++++++++++---
 tools/testing/selftests/bpf/progs/ima.c       | 10 +++++--
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 97d8a6f84f4a..62bf0e830453 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -13,9 +13,10 @@
 
 #include "ima.skel.h"
 
-static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
+static int run_measured_process(const char *measured_dir, u32 *monitored_pid,
+				bool *use_ima_file_hash)
 {
-	int child_pid, child_status;
+	int err, child_pid, child_status;
 
 	child_pid = fork();
 	if (child_pid == 0) {
@@ -24,6 +25,21 @@ static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
 		       NULL);
 		exit(errno);
 
+	} else if (child_pid > 0) {
+		waitpid(child_pid, &child_status, 0);
+		err = WEXITSTATUS(child_status);
+		if (err)
+			return err;
+	}
+
+	child_pid = fork();
+	if (child_pid == 0) {
+		*monitored_pid = getpid();
+		*use_ima_file_hash = true;
+		execlp("./ima_setup.sh", "./ima_setup.sh", "run", measured_dir,
+		       NULL);
+		exit(errno);
+
 	} else if (child_pid > 0) {
 		waitpid(child_pid, &child_status, 0);
 		return WEXITSTATUS(child_status);
@@ -72,12 +88,17 @@ void test_test_ima(void)
 	if (CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno))
 		goto close_clean;
 
-	err = run_measured_process(measured_dir, &skel->bss->monitored_pid);
+	err = run_measured_process(measured_dir, &skel->bss->monitored_pid,
+				   &skel->bss->use_ima_file_hash);
 	if (CHECK(err, "run_measured_process", "err = %d\n", err))
 		goto close_clean;
 
 	err = ring_buffer__consume(ringbuf);
-	ASSERT_EQ(err, 1, "num_samples_or_err");
+	/*
+	 * 1 sample with use_ima_file_hash = false
+	 * 2 samples with use_ima_file_hash = true (./ima_setup.sh, /bin/true)
+	 */
+	ASSERT_EQ(err, 3, "num_samples_or_err");
 	ASSERT_NEQ(ima_hash_from_bpf, 0, "ima_hash");
 
 close_clean:
diff --git a/tools/testing/selftests/bpf/progs/ima.c b/tools/testing/selftests/bpf/progs/ima.c
index 96060ff4ffc6..9bb63f96cfc0 100644
--- a/tools/testing/selftests/bpf/progs/ima.c
+++ b/tools/testing/selftests/bpf/progs/ima.c
@@ -18,6 +18,8 @@ struct {
 
 char _license[] SEC("license") = "GPL";
 
+bool use_ima_file_hash;
+
 SEC("lsm.s/bprm_committed_creds")
 void BPF_PROG(ima, struct linux_binprm *bprm)
 {
@@ -28,8 +30,12 @@ void BPF_PROG(ima, struct linux_binprm *bprm)
 
 	pid = bpf_get_current_pid_tgid() >> 32;
 	if (pid == monitored_pid) {
-		ret = bpf_ima_inode_hash(bprm->file->f_inode, &ima_hash,
-					 sizeof(ima_hash));
+		if (!use_ima_file_hash)
+			ret = bpf_ima_inode_hash(bprm->file->f_inode, &ima_hash,
+						 sizeof(ima_hash));
+		else
+			ret = bpf_ima_file_hash(bprm->file, &ima_hash,
+						sizeof(ima_hash));
 		if (ret < 0 || ima_hash == 0)
 			return;
 
-- 
2.32.0

