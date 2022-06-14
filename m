Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258DC54AFA1
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354130AbiFNLyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 07:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352195AbiFNLyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 07:54:46 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D64396B9;
        Tue, 14 Jun 2022 04:54:44 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LMn0v349Mz68BVP;
        Tue, 14 Jun 2022 19:54:39 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 13:54:41 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v4 4/4] selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper
Date:   Tue, 14 Jun 2022 13:54:20 +0200
Message-ID: <20220614115420.1964686-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220614115420.1964686-1-roberto.sassu@huawei.com>
References: <20220614115420.1964686-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that signature verification is performed successfully from an eBPF
program, with the new bpf_verify_pkcs7_signature() helper.

Generate a testing signature key and compile sign-file from scripts/, so
that the test is selfcontained.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/Makefile          |  14 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 217 ++++++++++++++++++
 .../bpf/progs/test_verify_pkcs7_sig.c         | 168 ++++++++++++++
 .../testing/selftests/bpf/verify_sig_setup.sh | 100 ++++++++
 5 files changed, 498 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 8ad7a733a505..c689b63ecac2 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -14,6 +14,7 @@ BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
 APIDIR := $(TOOLSINCDIR)/uapi
 GENDIR := $(abspath ../../../../include/generated)
 GENHDR := $(GENDIR)/autoconf.h
+HOSTPKG_CONFIG := pkg-config
 
 ifneq ($(wildcard $(GENHDR)),)
   GENFLAGS := -DHAVE_GENHDR
@@ -75,7 +76,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xsk.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
-	with_tunnels.sh ima_setup.sh \
+	with_tunnels.sh ima_setup.sh verify_sig_setup.sh \
 	test_xdp_vlan.sh test_bpftool.py
 
 # Compile but not part of 'make run_tests'
@@ -84,7 +85,7 @@ TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
 	xdpxceiver xdp_redirect_multi
 
-TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
+TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
 
 # Emit succinct information message describing current building step
 # $1 - generic step name (e.g., CC, LINK, etc);
@@ -180,6 +181,12 @@ $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_r
 		  liburandom_read.so $(LDLIBS)	       			       \
 		  -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
 
+$(OUTPUT)/sign-file: ../../../../scripts/sign-file.c
+	$(call msg,SIGN-FILE,,$@)
+	$(Q)$(CC) $(shell $(HOSTPKG_CONFIG)--cflags libcrypto 2> /dev/null) \
+		  $< -o $@ \
+		  $(shell $(HOSTPKG_CONFIG) --libs libcrypto 2> /dev/null || echo -lcrypto)
+
 $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
 	$(call msg,MOD,,$@)
 	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
@@ -502,7 +509,8 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c	\
 			 cap_helpers.c
 TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read $(OUTPUT)/bpf_testmod.ko	\
 		       $(OUTPUT)/liburandom_read.so			\
-		       ima_setup.sh					\
+		       $(OUTPUT)/sign-file				\
+		       ima_setup.sh verify_sig_setup.sh			\
 		       $(wildcard progs/btf_dump_test_case_*.c)
 TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
 TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS) -DENABLE_ATOMICS_TESTS
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 3b3edc0fc8a6..e4013c459f15 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -57,3 +57,5 @@ CONFIG_FPROBE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_MPTCP=y
+CONFIG_MODULE_SIG=y
+CONFIG_KEYS=y
diff --git a/tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c b/tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
new file mode 100644
index 000000000000..c88bc563a71b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <endian.h>
+#include <limits.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <linux/keyctl.h>
+#include <test_progs.h>
+
+#include "test_verify_pkcs7_sig.skel.h"
+
+#define MAX_DATA_SIZE 4096
+#define LOG_BUF_SIZE 16384
+
+struct data {
+	u8 payload[MAX_DATA_SIZE];
+};
+
+static int _run_setup_process(const char *setup_dir, const char *cmd)
+{
+	int child_pid, child_status;
+
+	child_pid = fork();
+	if (child_pid == 0) {
+		execlp("./verify_sig_setup.sh", "./verify_sig_setup.sh", cmd,
+		       setup_dir, NULL);
+		exit(errno);
+
+	} else if (child_pid > 0) {
+		waitpid(child_pid, &child_status, 0);
+		return WEXITSTATUS(child_status);
+	}
+
+	return -EINVAL;
+}
+
+static int populate_data_item(const char *tmp_dir, struct data *data_item)
+{
+	struct stat st;
+	char signed_file_template[] = "/tmp/signed_fileXXXXXX";
+	char path[PATH_MAX];
+	int ret, fd, child_status, child_pid;
+
+	fd = mkstemp(signed_file_template);
+	if (fd == -1)
+		return -errno;
+
+	ret = write(fd, "test", 4);
+
+	close(fd);
+
+	if (ret != 4) {
+		ret = -EIO;
+		goto out;
+	}
+
+	child_pid = fork();
+
+	if (child_pid == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	if (child_pid == 0) {
+		snprintf(path, sizeof(path), "%s/signing_key.pem", tmp_dir);
+
+		return execlp("./sign-file", "./sign-file", "sha256",
+			      path, path, signed_file_template, NULL);
+	}
+
+	waitpid(child_pid, &child_status, 0);
+
+	ret = WEXITSTATUS(child_status);
+	if (ret)
+		goto out;
+
+	ret = stat(signed_file_template, &st);
+	if (ret == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	if (st.st_size > sizeof(data_item->payload) - sizeof(u32)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	*(u32 *)data_item->payload = __cpu_to_be32(st.st_size);
+
+	fd = open(signed_file_template, O_RDONLY);
+	if (fd == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	ret = read(fd, data_item->payload + sizeof(u32), st.st_size);
+
+	close(fd);
+
+	if (ret != st.st_size) {
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = 0;
+out:
+	unlink(signed_file_template);
+	return ret;
+}
+
+void test_verify_pkcs7_sig(void)
+{
+	char tmp_dir_template[] = "/tmp/verify_sigXXXXXX";
+	char *tmp_dir;
+	char *buf = NULL;
+	struct test_verify_pkcs7_sig *skel = NULL;
+	struct bpf_map *map;
+	struct data data;
+	u32 saved_len;
+	int ret, zero = 0;
+
+	LIBBPF_OPTS(bpf_object_open_opts, opts);
+
+	/* Trigger creation of session keyring. */
+	syscall(__NR_request_key, "keyring", "_uid.0", NULL,
+		KEY_SPEC_SESSION_KEYRING);
+
+	tmp_dir = mkdtemp(tmp_dir_template);
+	if (!ASSERT_OK_PTR(tmp_dir, "mkdtemp"))
+		return;
+
+	ret = _run_setup_process(tmp_dir, "setup");
+	if (!ASSERT_OK(ret, "_run_setup_process"))
+		goto close_prog;
+
+	buf = malloc(LOG_BUF_SIZE);
+	if (!ASSERT_OK_PTR(buf, "malloc"))
+		goto close_prog;
+
+	opts.kernel_log_buf = buf;
+	opts.kernel_log_size = LOG_BUF_SIZE;
+	opts.kernel_log_level = 1;
+
+	skel = test_verify_pkcs7_sig__open_opts(&opts);
+	if (!ASSERT_OK_PTR(skel, "test_verify_pkcs7_sig__open_opts"))
+		goto close_prog;
+
+	ret = test_verify_pkcs7_sig__load(skel);
+
+	if (ret < 0 && strstr(buf, "unknown func bpf_verify_pkcs7_signature")) {
+		printf(
+		  "%s:SKIP:bpf_verify_pkcs7_signature() helper not supported\n",
+		  __func__);
+		test__skip();
+		goto close_prog;
+	}
+
+	if (!ASSERT_OK(ret, "test_verify_pkcs7_sig__load\n"))
+		goto close_prog;
+
+	ret = test_verify_pkcs7_sig__attach(skel);
+	if (!ASSERT_OK(ret, "test_verify_pkcs7_sig__attach\n"))
+		goto close_prog;
+
+	map = bpf_object__find_map_by_name(skel->obj, "data_input");
+	if (!ASSERT_OK_PTR(map, "data_input not found"))
+		goto close_prog;
+
+	ret = populate_data_item(tmp_dir, &data);
+	if (!ASSERT_OK(ret, "populate_data_item\n"))
+		goto close_prog;
+
+	skel->bss->monitored_pid = getpid();
+	skel->bss->keyring_id = ULONG_MAX;
+
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data, BPF_ANY);
+	if (!ASSERT_OK(ret, "bpf_map_update_elem\n"))
+		goto close_prog;
+
+	skel->bss->monitored_pid = getpid();
+	/* Search the verification key in the primary keyring (should fail). */
+	skel->bss->keyring_id = 0;
+
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data, BPF_ANY);
+	if (!ASSERT_LT(ret, 0, "bpf_map_update_elem data_input\n"))
+		goto close_prog;
+
+	saved_len = *(__u32 *)data.payload;
+	*(__u32 *)data.payload = sizeof(data.payload);
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data, BPF_ANY);
+	if (!ASSERT_LT(ret, 0, "bpf_map_update_elem data_input\n"))
+		goto close_prog;
+
+	*(__u32 *)data.payload = saved_len;
+	data.payload[sizeof(__u32)] = 'a';
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data, BPF_ANY);
+	ASSERT_LT(ret, 0, "bpf_map_update_elem data_input\n");
+close_prog:
+	_run_setup_process(tmp_dir, "cleanup");
+	free(buf);
+
+	if (!skel)
+		return;
+
+	skel->bss->monitored_pid = 0;
+	test_verify_pkcs7_sig__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c b/tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
new file mode 100644
index 000000000000..824379fa4a2c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <errno.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_endian.h>
+
+#define MAX_DATA_SIZE 4096
+
+#ifdef __BIG_ENDIAN__
+#define be32_to_cpu(x) (x)
+#else
+#define be32_to_cpu(x) ___bpf_swab32(x)
+#endif
+
+#define VERIFY_USE_SECONDARY_KEYRING (1UL)
+
+/* In stripped ARM and x86-64 modules, ~ is surprisingly rare. */
+#define MODULE_SIG_STRING "~Module signature appended~\n"
+
+typedef __u8 u8;
+typedef __u16 u16;
+typedef __u32 u32;
+typedef __u64 u64;
+
+enum pkey_id_type {
+	PKEY_ID_PGP,		/* OpenPGP generated key ID */
+	PKEY_ID_X509,		/* X.509 arbitrary subjectKeyIdentifier */
+	PKEY_ID_PKCS7,		/* Signature in PKCS#7 message */
+};
+
+/*
+ * Module signature information block.
+ *
+ * The constituents of the signature section are, in order:
+ *
+ *	- Signer's name
+ *	- Key identifier
+ *	- Signature data
+ *	- Information block
+ */
+struct module_signature {
+	u8	algo;		/* Public-key crypto algorithm [0] */
+	u8	hash;		/* Digest algorithm [0] */
+	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
+	u8	signer_len;	/* Length of signer's name [0] */
+	u8	key_id_len;	/* Length of key identifier [0] */
+	u8	__pad[3];
+	__be32	sig_len;	/* Length of signature data */
+};
+
+struct key;
+
+u32 monitored_pid;
+unsigned long keyring_id;
+
+struct data {
+	u8 payload[MAX_DATA_SIZE];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct data);
+} data_input SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+static int mod_check_sig(const struct module_signature *ms, size_t file_len)
+{
+	if (!ms)
+		return -ENOENT;
+
+	if (be32_to_cpu(ms->sig_len) >= file_len - sizeof(*ms))
+		return -EBADMSG;
+
+	if (ms->id_type != PKEY_ID_PKCS7)
+		return -ENOPKG;
+
+	if (ms->algo != 0 ||
+	    ms->hash != 0 ||
+	    ms->signer_len != 0 ||
+	    ms->key_id_len != 0 ||
+	    ms->__pad[0] != 0 ||
+	    ms->__pad[1] != 0 ||
+	    ms->__pad[2] != 0)
+		return -EBADMSG;
+
+	return 0;
+}
+
+SEC("lsm.s/bpf")
+int BPF_PROG(bpf, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	const size_t marker_len = sizeof(MODULE_SIG_STRING) - 1;
+	char marker[sizeof(MODULE_SIG_STRING) - 1];
+	struct bpf_dynptr data_ptr, sig_ptr;
+	struct module_signature ms;
+	struct data *data_val;
+	struct key *trusted_keys;
+	u32 modlen;
+	u32 sig_len;
+	u64 value;
+	u8 *mod;
+	u32 pid;
+	int ret, zero = 0;
+
+	pid = bpf_get_current_pid_tgid() >> 32;
+	if (pid != monitored_pid)
+		return 0;
+
+	data_val = bpf_map_lookup_elem(&data_input, &zero);
+	if (!data_val)
+		return 0;
+
+	bpf_probe_read(&value, sizeof(value), &attr->value);
+
+	bpf_copy_from_user(data_val, sizeof(struct data),
+			   (void *)(unsigned long)value);
+
+	modlen = be32_to_cpu(*(u32 *)data_val->payload);
+	mod = data_val->payload + sizeof(u32);
+
+	if (modlen > sizeof(struct data) - sizeof(u32))
+		return -EINVAL;
+
+	if (modlen <= marker_len)
+		return -ENOENT;
+
+	modlen &= sizeof(struct data) - 1;
+	bpf_probe_read(marker, marker_len, (char *)mod + modlen - marker_len);
+
+	if (bpf_strncmp(marker, marker_len, MODULE_SIG_STRING))
+		return -ENOENT;
+
+	modlen -= marker_len;
+
+	if (modlen <= sizeof(ms))
+		return -EBADMSG;
+
+	bpf_probe_read(&ms, sizeof(ms), (char *)mod + (modlen - sizeof(ms)));
+
+	ret = mod_check_sig(&ms, modlen);
+	if (ret)
+		return ret;
+
+	sig_len = be32_to_cpu(ms.sig_len);
+	modlen -= sig_len + sizeof(ms);
+
+	modlen &= 0x3ff;
+	sig_len &= 0x3ff;
+
+	bpf_dynptr_from_mem(mod, modlen, 0, &data_ptr);
+	bpf_dynptr_from_mem(mod + modlen, sig_len, 0, &sig_ptr);
+	trusted_keys = bpf_request_key_by_id(keyring_id);
+
+	return bpf_verify_pkcs7_signature(&data_ptr, &sig_ptr, trusted_keys);
+}
diff --git a/tools/testing/selftests/bpf/verify_sig_setup.sh b/tools/testing/selftests/bpf/verify_sig_setup.sh
new file mode 100755
index 000000000000..48cb55abc4a4
--- /dev/null
+++ b/tools/testing/selftests/bpf/verify_sig_setup.sh
@@ -0,0 +1,100 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+set -e
+set -u
+set -o pipefail
+
+VERBOSE="${SELFTESTS_VERBOSE:=0}"
+LOG_FILE="$(mktemp /tmp/verify_sig_setup.XXXX.log)"
+
+x509_genkey_content="\
+[ req ]
+default_bits = 2048
+distinguished_name = req_distinguished_name
+prompt = no
+string_mask = utf8only
+x509_extensions = myexts
+
+[ req_distinguished_name ]
+CN = eBPF Signature Verification Testing Key
+
+[ myexts ]
+basicConstraints=critical,CA:FALSE
+keyUsage=digitalSignature
+subjectKeyIdentifier=hash
+authorityKeyIdentifier=keyid
+"
+
+usage()
+{
+	echo "Usage: $0 <setup|cleanup <existing_tmp_dir>"
+	exit 1
+}
+
+setup()
+{
+	local tmp_dir="$1"
+
+	echo "${x509_genkey_content}" > ${tmp_dir}/x509.genkey
+
+	openssl req -new -nodes -utf8 -sha256 -days 36500 \
+			-batch -x509 -config ${tmp_dir}/x509.genkey \
+			-outform PEM -out ${tmp_dir}/signing_key.pem \
+			-keyout ${tmp_dir}/signing_key.pem 2>&1
+
+	openssl x509 -in ${tmp_dir}/signing_key.pem -out \
+		${tmp_dir}/signing_key.der -outform der
+
+	cat ${tmp_dir}/signing_key.der | keyctl padd asymmetric ebpf_testing_key @s
+}
+
+cleanup() {
+	local tmp_dir="$1"
+
+	keyctl unlink $(keyctl search @s asymmetric ebpf_testing_key) @s
+	rm -rf ${tmp_dir}
+}
+
+catch()
+{
+	local exit_code="$1"
+	local log_file="$2"
+
+	if [[ "${exit_code}" -ne 0 ]]; then
+		cat "${log_file}" >&3
+	fi
+
+	rm -f "${log_file}"
+	exit ${exit_code}
+}
+
+main()
+{
+	[[ $# -ne 2 ]] && usage
+
+	local action="$1"
+	local tmp_dir="$2"
+
+	[[ ! -d "${tmp_dir}" ]] && echo "Directory ${tmp_dir} doesn't exist" && exit 1
+
+	if [[ "${action}" == "setup" ]]; then
+		setup "${tmp_dir}"
+	elif [[ "${action}" == "cleanup" ]]; then
+		cleanup "${tmp_dir}"
+	else
+		echo "Unknown action: ${action}"
+		exit 1
+	fi
+}
+
+trap 'catch "$?" "${LOG_FILE}"' EXIT
+
+if [[ "${VERBOSE}" -eq 0 ]]; then
+	# Save the stderr to 3 so that we can output back to
+	# it incase of an error.
+	exec 3>&2 1>"${LOG_FILE}" 2>&1
+fi
+
+main "$@"
+rm -f "${LOG_FILE}"
-- 
2.25.1

