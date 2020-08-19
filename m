Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45F24A991
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 00:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgHSWlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 18:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgHSWkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 18:40:51 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6839AC061386
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:45 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id k1so215368plk.17
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 15:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=eoycBj0dmzWV6TvaHW20mHC8PQPI+NKXhCcr88+dCvE=;
        b=RwVnai6KEHm0pCu5e/M8tbhY+lVSbUDwH/ocIBZ47Ye96EW4Wqdot6YPifg1lURWEk
         h0ooSs6RVb3Fdh6C2KKsnuIWUj6v5JVx3sEtvT+6G7HErImJtqMxdK1GYy8ZyJzcGkGk
         DQ17w7Vdd20SU3IjDzReDIdQC71ResXtsvX8t0YjoZvvkY0irLg56zkdR4U/tXEA2gNq
         iiuMBafkZNOSd2FcbEX/l37c9yxwCRYtrPM8UwAY7Ww5BofwK4lr4zQIAK9/XEiAV//G
         nxz7cxHbFQF6hQQkQpLFwzAkPplIfGaVBLQLxMElFOT17HySzeGXovPSexH0bPArPAMO
         Xrkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=eoycBj0dmzWV6TvaHW20mHC8PQPI+NKXhCcr88+dCvE=;
        b=uNYUZHx8lbT8tIF+VAMHxk/6tXWoTAMTWINciMgBP/X1yait9aqYAj+mIgVR2K1ngT
         DQDzI9CK+S/1aWfNHX06e30lAMD/8HR0f5oEZBTEnHkDJqaFAnvCdltfJdZbp8DIODLm
         OTn0ZgzLvsxpXx7bDDCyaglU0i+nGMTYfvWpDyvuu2EjVbX1gvP3xtkvLsaK45yPL08g
         MsBWFQRx7fzoW8LqLKmpDYOBTbPV+lA9ulcJJuqHPi9jGATn4MqpG/RdJdVzCPElRgkX
         PbcJFZpZG0Chm95eJeQknFqp/LIr0QJEwcuO0wB8h5MJjty47nL/JzpGpG3jACrG1cNZ
         5oxg==
X-Gm-Message-State: AOAM532TwOSihwQ4xCcker34YLyZwDQNa+7p6bNEKS+Ac9TpSFRfbLzo
        GLgJE9pExTrNUruknl4t49u4kPCZiGg9dj+DRW8AM5auZZEBpUe8DoA+BnXv0UYu+gy0XBEf2mb
        FsBDmFPswJEaLkhmfjdo78EyrxniWCBCmNU3vmMiwIPVA3dO2FbEIJEvr9AaEfA==
X-Google-Smtp-Source: ABdhPJzEZsN56SetJK1yr8c+VYky6alODaG8BWZVW+ZyriIS6DogfyX6fd2aZWq/cYIwQyLAOoqZYC08r1o=
X-Received: from haoluo.svl.corp.google.com ([2620:15c:2cd:202:f693:9fff:fef4:e444])
 (user=haoluo job=sendgmr) by 2002:a17:90b:4c46:: with SMTP id
 np6mr62568pjb.201.1597876844231; Wed, 19 Aug 2020 15:40:44 -0700 (PDT)
Date:   Wed, 19 Aug 2020 15:40:27 -0700
In-Reply-To: <20200819224030.1615203-1-haoluo@google.com>
Message-Id: <20200819224030.1615203-6-haoluo@google.com>
Mime-Version: 1.0
References: <20200819224030.1615203-1-haoluo@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH bpf-next v1 5/8] bpf/selftests: ksyms_btf to test typed ksyms
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
the other is a plain int. This tests two paths in the kernel. Struct
ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
typed ksyms will be converted into PTR_TO_MEM.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 .../selftests/bpf/prog_tests/ksyms_btf.c      | 77 +++++++++++++++++++
 .../selftests/bpf/progs/test_ksyms_btf.c      | 23 ++++++
 2 files changed, 100 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
new file mode 100644
index 000000000000..1dad61ba7e99
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Google */
+
+#include <test_progs.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+#include "test_ksyms_btf.skel.h"
+
+static int duration;
+
+static __u64 kallsyms_find(const char *sym)
+{
+	char type, name[500];
+	__u64 addr, res = 0;
+	FILE *f;
+
+	f = fopen("/proc/kallsyms", "r");
+	if (CHECK(!f, "kallsyms_fopen", "failed to open: %d\n", errno))
+		return 0;
+
+	while (fscanf(f, "%llx %c %499s%*[^\n]\n", &addr, &type, name) > 0) {
+		if (strcmp(name, sym) == 0) {
+			res = addr;
+			goto out;
+		}
+	}
+
+	CHECK(false, "not_found", "symbol %s not found\n", sym);
+out:
+	fclose(f);
+	return res;
+}
+
+void test_ksyms_btf(void)
+{
+	__u64 runqueues_addr = kallsyms_find("runqueues");
+	__u64 bpf_prog_active_addr = kallsyms_find("bpf_prog_active");
+	struct test_ksyms_btf *skel;
+	struct test_ksyms_btf__data *data;
+	struct btf *btf;
+	int percpu_datasec;
+	int err;
+
+	btf = libbpf_find_kernel_btf();
+	if (CHECK(IS_ERR(btf), "btf_exists", "failed to load kernel BTF: %ld\n",
+		  PTR_ERR(btf)))
+		return;
+
+	percpu_datasec = btf__find_by_name_kind(btf, ".data..percpu",
+						BTF_KIND_DATASEC);
+	if (percpu_datasec < 0) {
+		printf("%s:SKIP:no PERCPU DATASEC in kernel btf\n",
+		       __func__);
+		test__skip();
+		return;
+	}
+
+	skel = test_ksyms_btf__open_and_load();
+	if (CHECK(!skel, "skel_open", "failed to open and load skeleton\n"))
+		return;
+
+	err = test_ksyms_btf__attach(skel);
+	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
+		goto cleanup;
+
+	/* trigger tracepoint */
+	usleep(1);
+
+	data = skel->data;
+	CHECK(data->out__runqueues != runqueues_addr, "runqueues",
+	      "got %llu, exp %llu\n", data->out__runqueues, runqueues_addr);
+	CHECK(data->out__bpf_prog_active != bpf_prog_active_addr, "bpf_prog_active",
+	      "got %llu, exp %llu\n", data->out__bpf_prog_active, bpf_prog_active_addr);
+
+cleanup:
+	test_ksyms_btf__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_ksyms_btf.c b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
new file mode 100644
index 000000000000..e04e31117f84
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_ksyms_btf.c
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Google */
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+__u64 out__runqueues = -1;
+__u64 out__bpf_prog_active = -1;
+
+extern const struct rq runqueues __ksym; /* struct type global var. */
+extern const int bpf_prog_active __ksym; /* int type global var. */
+
+SEC("raw_tp/sys_enter")
+int handler(const void *ctx)
+{
+	out__runqueues = (__u64)&runqueues;
+	out__bpf_prog_active = (__u64)&bpf_prog_active;
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.28.0.220.ged08abb693-goog

