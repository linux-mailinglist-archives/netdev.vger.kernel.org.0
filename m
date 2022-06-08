Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC36A542EEF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 13:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237896AbiFHLPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 07:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237679AbiFHLPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 07:15:15 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9FC27B9AE;
        Wed,  8 Jun 2022 04:15:11 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJ4Jb7195z6GD8L;
        Wed,  8 Jun 2022 19:10:23 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 8 Jun 2022 13:15:08 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 3/3] selftests/bpf: Add test for bpf_verify_pkcs7_signature() helper
Date:   Wed, 8 Jun 2022 13:12:21 +0200
Message-ID: <20220608111221.373833-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220608111221.373833-1-roberto.sassu@huawei.com>
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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

The test requires access to the kernel modules signing key and the
execution of the sign-file tool with the signing key path passed as
argument.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/verify_pkcs7_sig.c         | 149 ++++++++++++++++++
 .../bpf/progs/test_verify_pkcs7_sig.c         | 127 +++++++++++++++
 3 files changed, 278 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 3b3edc0fc8a6..43f92ce5f3f3 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -57,3 +57,5 @@ CONFIG_FPROBE=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
 CONFIG_MPTCP=y
+CONFIG_MODULE_SIG_FORMAT=y
+CONFIG_SECONDARY_TRUSTED_KEYRING=y
diff --git a/tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c b/tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
new file mode 100644
index 000000000000..3c85b8cd13d4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
@@ -0,0 +1,149 @@
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
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <test_progs.h>
+
+#include "test_verify_pkcs7_sig.skel.h"
+
+#define MAX_DATA_SIZE 4096
+
+struct data {
+	u8 payload[MAX_DATA_SIZE];
+};
+
+static int populate_data_item(struct data *data_item)
+{
+	struct stat st;
+	char signed_file_template[] = "/tmp/signed_fileXXXXXX";
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
+	if (child_pid == 0)
+		return execlp(env.sign_file_path, env.sign_file_path, "sha256",
+			      env.kernel_priv_cert_path,
+			      env.kernel_priv_cert_path,
+			      signed_file_template, NULL);
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
+	struct test_verify_pkcs7_sig *skel = NULL;
+	struct bpf_map *map;
+	struct data data;
+	u32 saved_len;
+	int ret, zero = 0;
+
+	if (!env.sign_file_path || !env.kernel_priv_cert_path) {
+		printf(
+		  "%s:SKIP:sign-file and kernel priv key cert paths missing\n",
+		  __func__);
+		test__skip();
+		return;
+	}
+
+	skel = test_verify_pkcs7_sig__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_verify_pkcs7_sig__open_and_load"))
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
+	ret = populate_data_item(&data);
+	if (!ASSERT_OK(ret, "populate_data_item\n"))
+		goto close_prog;
+
+	skel->bss->monitored_pid = getpid();
+
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data, BPF_ANY);
+	if (!ASSERT_OK(ret, "bpf_map_update_elem\n"))
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
+	skel->bss->monitored_pid = 0;
+	test_verify_pkcs7_sig__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c b/tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
new file mode 100644
index 000000000000..e72bcb7fb7a9
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
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
+u32 monitored_pid;
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
+	struct module_signature ms;
+	struct data *data_ptr;
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
+	data_ptr = bpf_map_lookup_elem(&data_input, &zero);
+	if (!data_ptr)
+		return 0;
+
+	bpf_probe_read(&value, sizeof(value), &attr->value);
+
+	bpf_copy_from_user(data_ptr, sizeof(struct data),
+			   (void *)(unsigned long)value);
+
+	modlen = be32_to_cpu(*(u32 *)data_ptr->payload);
+	mod = data_ptr->payload + sizeof(u32);
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
+	return bpf_verify_pkcs7_signature(mod, modlen, mod + modlen, sig_len,
+					  VERIFY_USE_SECONDARY_KEYRING);
+}
-- 
2.25.1

