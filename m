Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4144B23B4
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349192AbiBKKsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:48:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238232AbiBKKsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:48:45 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822E5D64;
        Fri, 11 Feb 2022 02:48:43 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jw9MM6swQz687Jc;
        Fri, 11 Feb 2022 18:48:31 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 11:48:40 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH] ima: Calculate digest in ima_inode_hash() if not available
Date:   Fri, 11 Feb 2022 11:48:28 +0100
Message-ID: <20220211104828.4061334-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
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

__ima_inode_hash() checks if a digest has been already calculated by
looking for the integrity_iint_cache structure associated to the passed
inode.

Users of ima_file_hash() and ima_inode_hash() (e.g. eBPF) might be
interested in obtaining the information without having to setup an IMA
policy so that the digest is always available at the time they call one of
those functions.

Open a new file descriptor in __ima_inode_hash(), so that this function
could invoke ima_collect_measurement() to calculate the digest if it is not
available. Still return -EOPNOTSUPP if the calculation failed.

Instead of opening a new file descriptor, the one from ima_file_hash()
could have been used. However, since ima_inode_hash() was created to obtain
the digest when the file descriptor is not available, it could benefit from
this change too. Also, the opened file descriptor might be not suitable for
use (file descriptor opened not for reading).

This change does not cause memory usage increase, due to using a temporary
integrity_iint_cache structure for the digest calculation, and due to
freeing the ima_digest_data structure inside integrity_iint_cache before
exiting from __ima_inode_hash().

Finally, update the test by removing ima_setup.sh (it is not necessary
anymore to set an IMA policy) and by directly executing /bin/true.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_main.c             |  46 ++++++-
 tools/testing/selftests/bpf/Makefile          |   1 -
 tools/testing/selftests/bpf/ima_setup.sh      | 123 ------------------
 .../selftests/bpf/prog_tests/test_ima.c       |  25 +---
 4 files changed, 43 insertions(+), 152 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/ima_setup.sh

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 8c6e4514d494..44df3f990950 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -26,6 +26,7 @@
 #include <linux/ima.h>
 #include <linux/iversion.h>
 #include <linux/fs.h>
+#include <linux/fs_struct.h>
 
 #include "ima.h"
 
@@ -521,15 +522,43 @@ EXPORT_SYMBOL_GPL(ima_file_check);
 
 static int __ima_inode_hash(struct inode *inode, char *buf, size_t buf_size)
 {
-	struct integrity_iint_cache *iint;
-	int hash_algo;
+	struct integrity_iint_cache *iint = NULL, tmp_iint;
+	struct file *file;
+	struct path root, path;
+	int rc, hash_algo;
+
+	if (ima_policy_flag)
+		iint = integrity_iint_find(inode);
+
+	if (!iint) {
+		memset(&tmp_iint, 0, sizeof(tmp_iint));
+		tmp_iint.inode = inode;
+		iint = &tmp_iint;
+
+		path.dentry = d_find_alias(inode);
+		if (!path.dentry)
+			return -EOPNOTSUPP;
+
+		get_fs_root(current->fs, &root);
+		path.mnt = root.mnt;
+
+		file = dentry_open(&path, O_RDONLY, current_cred());
+		if (IS_ERR(file)) {
+			dput(path.dentry);
+			path_put(&root);
+			return -EOPNOTSUPP;
+		}
 
-	if (!ima_policy_flag)
-		return -EOPNOTSUPP;
+		rc = ima_collect_measurement(iint, file, NULL, 0, ima_hash_algo,
+					     NULL);
 
-	iint = integrity_iint_find(inode);
-	if (!iint)
-		return -EOPNOTSUPP;
+		fput(file);
+		dput(path.dentry);
+		path_put(&root);
+
+		if (rc != 0)
+			return -EOPNOTSUPP;
+	}
 
 	mutex_lock(&iint->mutex);
 
@@ -551,6 +580,9 @@ static int __ima_inode_hash(struct inode *inode, char *buf, size_t buf_size)
 	hash_algo = iint->ima_hash->algo;
 	mutex_unlock(&iint->mutex);
 
+	if (iint == &tmp_iint)
+		kfree(iint->ima_hash);
+
 	return hash_algo;
 }
 
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 42ffc24e9e71..f7f850b2cf26 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -480,7 +480,6 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 network_helpers.c testing_helpers.c		\
 			 btf_helpers.c flow_dissector_load.h
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
-		       ima_setup.sh					\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS) -DENABLE_ATOMICS_TESTS
diff --git a/tools/testing/selftests/bpf/ima_setup.sh b/tools/testing/selftests/bpf/ima_setup.sh
deleted file mode 100755
index 8e62581113a3..000000000000
--- a/tools/testing/selftests/bpf/ima_setup.sh
+++ /dev/null
@@ -1,123 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-
-set -e
-set -u
-set -o pipefail
-
-IMA_POLICY_FILE="/sys/kernel/security/ima/policy"
-TEST_BINARY="/bin/true"
-VERBOSE="${SELFTESTS_VERBOSE:=0}"
-LOG_FILE="$(mktemp /tmp/ima_setup.XXXX.log)"
-
-usage()
-{
-	echo "Usage: $0 <setup|cleanup|run> <existing_tmp_dir>"
-	exit 1
-}
-
-ensure_mount_securityfs()
-{
-	local securityfs_dir=$(grep "securityfs" /proc/mounts | awk '{print $2}')
-
-	if [ -z "${securityfs_dir}" ]; then
-		securityfs_dir=/sys/kernel/security
-		mount -t securityfs security "${securityfs_dir}"
-	fi
-
-	if [ ! -d "${securityfs_dir}" ]; then
-		echo "${securityfs_dir}: securityfs is not mounted" && exit 1
-	fi
-}
-
-setup()
-{
-	local tmp_dir="$1"
-	local mount_img="${tmp_dir}/test.img"
-	local mount_dir="${tmp_dir}/mnt"
-	local copied_bin_path="${mount_dir}/$(basename ${TEST_BINARY})"
-	mkdir -p ${mount_dir}
-
-	dd if=/dev/zero of="${mount_img}" bs=1M count=10
-
-	losetup -f "${mount_img}"
-	local loop_device=$(losetup -a | grep ${mount_img:?} | cut -d ":" -f1)
-
-	mkfs.ext2 "${loop_device:?}"
-	mount "${loop_device}" "${mount_dir}"
-
-	cp "${TEST_BINARY}" "${mount_dir}"
-	local mount_uuid="$(blkid ${loop_device} | sed 's/.*UUID="\([^"]*\)".*/\1/')"
-
-	ensure_mount_securityfs
-	echo "measure func=BPRM_CHECK fsuuid=${mount_uuid}" > ${IMA_POLICY_FILE}
-}
-
-cleanup() {
-	local tmp_dir="$1"
-	local mount_img="${tmp_dir}/test.img"
-	local mount_dir="${tmp_dir}/mnt"
-
-	local loop_devices=$(losetup -a | grep ${mount_img:?} | cut -d ":" -f1)
-
-	for loop_dev in "${loop_devices}"; do
-		losetup -d $loop_dev
-	done
-
-	umount ${mount_dir}
-	rm -rf ${tmp_dir}
-}
-
-run()
-{
-	local tmp_dir="$1"
-	local mount_dir="${tmp_dir}/mnt"
-	local copied_bin_path="${mount_dir}/$(basename ${TEST_BINARY})"
-
-	exec "${copied_bin_path}"
-}
-
-catch()
-{
-	local exit_code="$1"
-	local log_file="$2"
-
-	if [[ "${exit_code}" -ne 0 ]]; then
-		cat "${log_file}" >&3
-	fi
-
-	rm -f "${log_file}"
-	exit ${exit_code}
-}
-
-main()
-{
-	[[ $# -ne 2 ]] && usage
-
-	local action="$1"
-	local tmp_dir="$2"
-
-	[[ ! -d "${tmp_dir}" ]] && echo "Directory ${tmp_dir} doesn't exist" && exit 1
-
-	if [[ "${action}" == "setup" ]]; then
-		setup "${tmp_dir}"
-	elif [[ "${action}" == "cleanup" ]]; then
-		cleanup "${tmp_dir}"
-	elif [[ "${action}" == "run" ]]; then
-		run "${tmp_dir}"
-	else
-		echo "Unknown action: ${action}"
-		exit 1
-	fi
-}
-
-trap 'catch "$?" "${LOG_FILE}"' EXIT
-
-if [[ "${VERBOSE}" -eq 0 ]]; then
-	# Save the stderr to 3 so that we can output back to
-	# it incase of an error.
-	exec 3>&2 1>"${LOG_FILE}" 2>&1
-fi
-
-main "$@"
-rm -f "${LOG_FILE}"
diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 97d8a6f84f4a..82427549f45a 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -13,15 +13,14 @@
 
 #include "ima.skel.h"
 
-static int run_measured_process(const char *measured_dir, u32 *monitored_pid)
+static int run_measured_process(u32 *monitored_pid)
 {
 	int child_pid, child_status;
 
 	child_pid = fork();
 	if (child_pid == 0) {
 		*monitored_pid = getpid();
-		execlp("./ima_setup.sh", "./ima_setup.sh", "run", measured_dir,
-		       NULL);
+		execlp("/bin/true", "/bin/true", NULL);
 		exit(errno);
 
 	} else if (child_pid > 0) {
@@ -42,10 +41,7 @@ static int process_sample(void *ctx, void *data, size_t len)
 
 void test_test_ima(void)
 {
-	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
 	struct ring_buffer *ringbuf = NULL;
-	const char *measured_dir;
-	char cmd[256];
 
 	int err, duration = 0;
 	struct ima *skel = NULL;
@@ -63,27 +59,14 @@ void test_test_ima(void)
 	if (CHECK(err, "attach", "attach failed: %d\n", err))
 		goto close_prog;
 
-	measured_dir = mkdtemp(measured_dir_template);
-	if (CHECK(measured_dir == NULL, "mkdtemp", "err %d\n", errno))
-		goto close_prog;
-
-	snprintf(cmd, sizeof(cmd), "./ima_setup.sh setup %s", measured_dir);
-	err = system(cmd);
-	if (CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno))
-		goto close_clean;
-
-	err = run_measured_process(measured_dir, &skel->bss->monitored_pid);
+	err = run_measured_process(&skel->bss->monitored_pid);
 	if (CHECK(err, "run_measured_process", "err = %d\n", err))
-		goto close_clean;
+		goto close_prog;
 
 	err = ring_buffer__consume(ringbuf);
 	ASSERT_EQ(err, 1, "num_samples_or_err");
 	ASSERT_NEQ(ima_hash_from_bpf, 0, "ima_hash");
 
-close_clean:
-	snprintf(cmd, sizeof(cmd), "./ima_setup.sh cleanup %s", measured_dir);
-	err = system(cmd);
-	CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
 close_prog:
 	ring_buffer__free(ringbuf);
 	ima__destroy(skel);
-- 
2.32.0

