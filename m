Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D02656D813
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiGKIcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiGKIc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78E6B1F2FA
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657528345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rOvdknNIUIgwtUuGLKnWKb2uga4ygZMa7e3xZ51+vSU=;
        b=DMKzNf0jQjQWU2IDdARZwCv3M0nHxNpVUp/DIKRhQITspvxeTO+/QGyTKbgwl7Oe90Rr/X
        pxH8Yk0JuN6gyjBWUaTDqTpYJequ7hsiNXIUaxfSYyEA4Nmu5Enb0byy+Z/ENJ3B4n86bc
        NFPJyRDxAoLF7cU1NV0BAa7S3pJ+F1s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-9CPImoJYPOyARge6nMgrWQ-1; Mon, 11 Jul 2022 04:32:23 -0400
X-MC-Unique: 9CPImoJYPOyARge6nMgrWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D1B18041B5;
        Mon, 11 Jul 2022 08:32:23 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09A5F2026D64;
        Mon, 11 Jul 2022 08:32:22 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 061281C03BC; Mon, 11 Jul 2022 10:32:22 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [RFC PATCH bpf-next 4/4] selftests/bpf: bpf_panic selftest
Date:   Mon, 11 Jul 2022 10:32:20 +0200
Message-Id: <20220711083220.2175036-5-asavkov@redhat.com>
In-Reply-To: <20220711083220.2175036-1-asavkov@redhat.com>
References: <20220711083220.2175036-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a selftest for bpf_panic() checking that the program will only load
if all the prerequisites are met.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 .../selftests/bpf/prog_tests/bpf_panic.c      | 144 ++++++++++++++++++
 1 file changed, 144 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_panic.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_panic.c b/tools/testing/selftests/bpf/prog_tests/bpf_panic.c
new file mode 100644
index 000000000000..9d008c0a5140
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_panic.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Red Hat, Inc. */
+
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+#include "cap_helpers.h"
+
+static int sysctl_get(const char *sysctl_path, char *old_val)
+{
+	int ret = 0;
+	FILE *fp;
+
+	fp = fopen(sysctl_path, "r");
+	if (!fp)
+		return -errno;
+
+	if (fscanf(fp, "%s", old_val) <= 0)
+		ret = -ENOENT;
+
+	fclose(fp);
+
+	return ret;
+}
+
+static int sysctl_set(const char *sysctl_path, const char *new_val)
+{
+	int ret = 0;
+	FILE *fp;
+
+	fp = fopen(sysctl_path, "w");
+	if (!fp)
+		return -errno;
+
+	if (fprintf(fp, "%s", new_val) < 0)
+		ret = -errno;
+
+	fclose(fp);
+
+	return ret;
+}
+
+static char bpf_vlog[UINT_MAX >> 8];
+
+static void test_bpf_panic_conditions(void)
+{
+	int fd_prog;
+	int map_fd;
+	struct bpf_insn prog_insns[] = {
+		BPF_LD_MAP_VALUE(BPF_REG_1, 0, 0),
+		BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_panic),
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	const size_t prog_insn_cnt = sizeof(prog_insns) / sizeof(struct bpf_insn);
+	LIBBPF_OPTS(bpf_prog_load_opts, load_opts);
+	LIBBPF_OPTS(bpf_map_create_opts, map_create_opts);
+	int attach_btf_id;
+	__u64 save_caps = 0;
+
+	if (!ASSERT_OK(sysctl_set("/proc/sys/kernel/destructive_bpf_enabled",
+			 "1"), "set destructive_bpf_enabled"))
+		return;
+
+	load_opts.log_level = 1;
+	load_opts.log_buf = bpf_vlog;
+	load_opts.log_size = sizeof(bpf_vlog);
+	load_opts.expected_attach_type = BPF_TRACE_FENTRY;
+
+	attach_btf_id = libbpf_find_vmlinux_btf_id("dentry_open", load_opts.expected_attach_type);
+	if (!ASSERT_GE(attach_btf_id, 0, "attach_btf_id"))
+		return;
+
+	load_opts.attach_btf_id = attach_btf_id;
+
+	map_create_opts.map_flags = BPF_F_RDONLY_PROG;
+	map_fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, 4, 8, 1, &map_create_opts);
+	if (!ASSERT_GE(map_fd, 0, "bpf_map_create"))
+		return;
+	ASSERT_OK(bpf_map_freeze(map_fd), "bpf_map_freeze");
+
+	prog_insns[0].imm = map_fd;
+
+	fd_prog = bpf_prog_load(BPF_PROG_TYPE_TRACING, "bpf_panic", "GPL", prog_insns, prog_insn_cnt, &load_opts);
+
+	if (ASSERT_EQ(fd_prog, -EACCES, "BPF_F_DESTRUCTIVE required")) {
+		if (!ASSERT_OK_PTR(
+				strstr(bpf_vlog, "require BPF_F_DESTRUCTIVE"),
+				"BPF_F_DESTRUCTIVE verifier log")) {
+			printf("verifier log:\n%s\n", bpf_vlog);
+		}
+	}
+
+	load_opts.prog_flags = BPF_F_DESTRUCTIVE;
+	fd_prog = bpf_prog_load(BPF_PROG_TYPE_TRACING, "bpf_panic", "GPL", prog_insns, prog_insn_cnt, &load_opts);
+
+	if (ASSERT_GE(fd_prog, 0, "successful load")) {
+		close(fd_prog);
+	} else {
+		printf("verifier log:\n%s\n", bpf_vlog);
+	}
+
+
+	if (ASSERT_OK(cap_disable_effective(1ULL << CAP_SYS_BOOT, &save_caps), "disable caps")) {
+		fd_prog = bpf_prog_load(BPF_PROG_TYPE_TRACING, "bpf_panic", "GPL", prog_insns, prog_insn_cnt, &load_opts);
+		ASSERT_EQ(fd_prog, -EINVAL, "CAP_SYS_BOOT required");
+		if (!ASSERT_OK_PTR(
+				strstr(bpf_vlog, "unknown func bpf_panic"),
+				"CAP_SYS_BOOT verifier log")) {
+			printf("verifier log:\n%s\n", bpf_vlog);
+		}
+		cap_enable_effective(save_caps, NULL);
+	}
+
+	if (ASSERT_OK(sysctl_set("/proc/sys/kernel/destructive_bpf_enabled",
+			 "0"), "unset destructive_bpf_enabled")) {
+		fd_prog = bpf_prog_load(BPF_PROG_TYPE_TRACING, "bpf_panic", "GPL", prog_insns, prog_insn_cnt, &load_opts);
+		ASSERT_EQ(fd_prog, -EINVAL, "!destructive_bpf_enabled");
+		if (!ASSERT_OK_PTR(
+				strstr(bpf_vlog, "unknown func bpf_panic"),
+				"!destructive_bpf_enabled verifier log")) {
+			printf("verifier log:\n%s\n", bpf_vlog);
+		}
+	}
+	close(map_fd);
+}
+
+void test_bpf_panic(void)
+{
+	char destructive_bpf_enabled_orig[32] = {};
+
+	if (!ASSERT_OK(sysctl_get("/proc/sys/kernel/destructive_bpf_enabled",
+			 destructive_bpf_enabled_orig), "read destructive_bpf_enabled"))
+		goto cleanup;
+
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+	if (test__start_subtest("bpf_panic_conditions"))
+		test_bpf_panic_conditions();
+
+cleanup:
+	if (strlen(destructive_bpf_enabled_orig) > 0)
+		sysctl_set("/proc/sys/kernel/destructive_bpf_enabled",
+				destructive_bpf_enabled_orig);
+}
-- 
2.35.3

