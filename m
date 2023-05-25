Return-Path: <netdev+bounces-5301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7D7710A76
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:02:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6DB2281555
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E244FC07;
	Thu, 25 May 2023 11:01:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2230EFBE3;
	Thu, 25 May 2023 11:01:27 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C77790;
	Thu, 25 May 2023 04:01:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1q28ih-0004iv-OS; Thu, 25 May 2023 13:01:23 +0200
From: Florian Westphal <fw@strlen.de>
To: <bpf@vger.kernel.org>
Cc: andrii.nakryiko@gmail.com,
	ast@kernel.org,
	<netdev@vger.kernel.org>,
	dxu@dxuuu.xyz,
	qde@naccy.de,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Add bpf_program__attach_netfilter_opts helper test
Date: Thu, 25 May 2023 13:01:00 +0200
Message-Id: <20230525110100.8212-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230525110100.8212-1-fw@strlen.de>
References: <20230525110100.8212-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=ANY_BOUNCE_MESSAGE,BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,VBOUNCE_MESSAGE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Call bpf_program__attach_netfilter_opts() with different
protocol/hook/priority combinations.

Test fails if supposedly-illegal attachments work
(e.g., bogus protocol family, illegal priority and so on)
or if a should-work attachment fails.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../bpf/prog_tests/netfilter_basic.c          | 87 +++++++++++++++++++
 .../bpf/progs/test_netfilter_link_attach.c    | 14 +++
 2 files changed, 101 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netfilter_basic.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_netfilter_link_attach.c

diff --git a/tools/testing/selftests/bpf/prog_tests/netfilter_basic.c b/tools/testing/selftests/bpf/prog_tests/netfilter_basic.c
new file mode 100644
index 000000000000..a64b5feaaca4
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/netfilter_basic.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <netinet/in.h>
+#include <linux/netfilter.h>
+
+#include "test_progs.h"
+#include "test_netfilter_link_attach.skel.h"
+
+struct nf_hook_options {
+	__u32 pf;
+	__u32 hooknum;
+	__s32 priority;
+	__u32 flags;
+
+	bool expect_success;
+};
+
+struct nf_hook_options nf_hook_attach_tests[] = {
+	{  },
+	{ .pf = NFPROTO_NUMPROTO, },
+	{ .pf = NFPROTO_IPV4, .hooknum = 42, },
+	{ .pf = NFPROTO_IPV4, .priority = INT_MIN },
+	{ .pf = NFPROTO_IPV4, .priority = INT_MAX },
+	{ .pf = NFPROTO_IPV4, .flags = UINT_MAX },
+
+	{ .pf = NFPROTO_INET, .priority = 1, },
+
+	{ .pf = NFPROTO_IPV4, .priority = -10000, .expect_success = true },
+	{ .pf = NFPROTO_IPV6, .priority = 10001, .expect_success = true },
+};
+
+static void __test_netfilter_link_attach(struct bpf_program *prog)
+{
+	LIBBPF_OPTS(bpf_netfilter_opts, opts);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(nf_hook_attach_tests); i++) {
+		struct bpf_link *link;
+
+#define X(opts, m, i)	opts.m = nf_hook_attach_tests[(i)].m
+		X(opts, pf, i);
+		X(opts, hooknum, i);
+		X(opts, priority, i);
+		X(opts, flags, i);
+#undef X
+		link = bpf_program__attach_netfilter_opts(prog, &opts);
+		if (nf_hook_attach_tests[i].expect_success) {
+			struct bpf_link *link2;
+
+			if (!ASSERT_OK_PTR(link, "program attach successful"))
+				continue;
+
+			link2 = bpf_program__attach_netfilter_opts(prog, &opts);
+			ASSERT_NULL(link2, "attach program with same pf/hook/priority");
+
+			if (!ASSERT_EQ(bpf_link__destroy(link), 0, "link destroy"))
+				break;
+
+			link2 = bpf_program__attach_netfilter_opts(prog, &opts);
+			if (!ASSERT_OK_PTR(link2, "program reattach successful"))
+				continue;
+			if (!ASSERT_EQ(bpf_link__destroy(link2), 0, "link destroy"))
+				break;
+		} else {
+			ASSERT_NULL(link, "program load failure");
+		}
+	}
+}
+
+static void test_netfilter_link_attach(void)
+{
+	struct test_netfilter_link_attach *skel;
+
+	skel = test_netfilter_link_attach__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_netfilter_link_attach__open_and_load"))
+		goto out;
+
+	__test_netfilter_link_attach(skel->progs.nf_link_attach_test);
+out:
+	test_netfilter_link_attach__destroy(skel);
+}
+
+void test_netfilter_basic(void)
+{
+	if (test__start_subtest("netfilter link attach"))
+		test_netfilter_link_attach();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_netfilter_link_attach.c b/tools/testing/selftests/bpf/progs/test_netfilter_link_attach.c
new file mode 100644
index 000000000000..03a475160abe
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_netfilter_link_attach.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+#define NF_ACCEPT 1
+
+SEC("netfilter")
+int nf_link_attach_test(struct bpf_nf_ctx *ctx)
+{
+	return NF_ACCEPT;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.39.3


