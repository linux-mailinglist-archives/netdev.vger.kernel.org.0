Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0319EA87A
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfJaBBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:01:01 -0400
Received: from www62.your-server.de ([213.133.104.62]:42506 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbfJaBA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:00:59 -0400
Received: from 38.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.38] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iPypX-0000F6-E7; Thu, 31 Oct 2019 02:00:52 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, andrii.nakryiko@gmail.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH bpf-next v2 8/8] bpf, testing: Add selftest to read/write sockaddr from user space
Date:   Thu, 31 Oct 2019 02:00:26 +0100
Message-Id: <b0c2dec7982cf45ea009cb8d4a5043c667c87791.1572483054.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572483054.git.daniel@iogearbox.net>
References: <cover.1572483054.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on x86-64 and Ilya was also kind enough to give it a spin on
s390x, both passing with probe_user:OK there. The test is using the
newly added bpf_probe_read_user() to dump sockaddr from connect call
into .bss BPF map and overrides the user buffer via bpf_probe_write_user():

  # ./test_progs
  [...]
  #17 pkt_md_access:OK
  #18 probe_user:OK
  #19 prog_run_xattr:OK
  [...]

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 .../selftests/bpf/prog_tests/probe_user.c     | 78 +++++++++++++++++++
 .../selftests/bpf/progs/test_probe_user.c     | 26 +++++++
 2 files changed, 104 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c

diff --git a/tools/testing/selftests/bpf/prog_tests/probe_user.c b/tools/testing/selftests/bpf/prog_tests/probe_user.c
new file mode 100644
index 000000000000..6cc36c87bdbc
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/probe_user.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+void test_probe_user(void)
+{
+#define kprobe_name "__sys_connect"
+	const char *prog_name = "kprobe/" kprobe_name;
+	const char *obj_file = "./test_probe_user.o";
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, );
+	int err, results_map_fd, sock_fd, duration;
+	struct sockaddr curr, orig, tmp;
+	struct sockaddr_in *in = (struct sockaddr_in *)&curr;
+	struct bpf_link *kprobe_link = NULL;
+	struct bpf_program *kprobe_prog;
+	struct bpf_object *obj;
+	static const int zero = 0;
+
+	obj = bpf_object__open_file(obj_file, &opts);
+	if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	kprobe_prog = bpf_object__find_program_by_title(obj, prog_name);
+	if (CHECK(!kprobe_prog, "find_probe",
+		  "prog '%s' not found\n", prog_name))
+		goto cleanup;
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d\n", err))
+		goto cleanup;
+
+	results_map_fd = bpf_find_map(__func__, obj, "test_pro.bss");
+	if (CHECK(results_map_fd < 0, "find_bss_map",
+		  "err %d\n", results_map_fd))
+		goto cleanup;
+
+	kprobe_link = bpf_program__attach_kprobe(kprobe_prog, false,
+						 kprobe_name);
+	if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
+		  "err %ld\n", PTR_ERR(kprobe_link))) {
+		kprobe_link = NULL;
+		goto cleanup;
+	}
+
+	memset(&curr, 0, sizeof(curr));
+	in->sin_family = AF_INET;
+	in->sin_port = htons(5555);
+	in->sin_addr.s_addr = inet_addr("255.255.255.255");
+	memcpy(&orig, &curr, sizeof(curr));
+
+	sock_fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK(sock_fd < 0, "create_sock_fd", "err %d\n", sock_fd))
+		goto cleanup;
+
+	connect(sock_fd, &curr, sizeof(curr));
+	close(sock_fd);
+
+	err = bpf_map_lookup_elem(results_map_fd, &zero, &tmp);
+	if (CHECK(err, "get_kprobe_res",
+		  "failed to get kprobe res: %d\n", err))
+		goto cleanup;
+
+	in = (struct sockaddr_in *)&tmp;
+	if (CHECK(memcmp(&tmp, &orig, sizeof(orig)), "check_kprobe_res",
+		  "wrong kprobe res from probe read: %s:%u\n",
+		  inet_ntoa(in->sin_addr), ntohs(in->sin_port)))
+		goto cleanup;
+
+	memset(&tmp, 0xab, sizeof(tmp));
+
+	in = (struct sockaddr_in *)&curr;
+	if (CHECK(memcmp(&curr, &tmp, sizeof(tmp)), "check_kprobe_res",
+		  "wrong kprobe res from probe write: %s:%u\n",
+		  inet_ntoa(in->sin_addr), ntohs(in->sin_port)))
+		goto cleanup;
+cleanup:
+	bpf_link__destroy(kprobe_link);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_probe_user.c b/tools/testing/selftests/bpf/progs/test_probe_user.c
new file mode 100644
index 000000000000..1871e2ece0c4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_probe_user.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+
+#include <netinet/in.h>
+
+#include "bpf_helpers.h"
+#include "bpf_tracing.h"
+
+static struct sockaddr_in old;
+
+SEC("kprobe/__sys_connect")
+int handle_sys_connect(struct pt_regs *ctx)
+{
+	void *ptr = (void *)PT_REGS_PARM2(ctx);
+	struct sockaddr_in new;
+
+	bpf_probe_read_user(&old, sizeof(old), ptr);
+	__builtin_memset(&new, 0xab, sizeof(new));
+	bpf_probe_write_user(ptr, &new, sizeof(new));
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.21.0

