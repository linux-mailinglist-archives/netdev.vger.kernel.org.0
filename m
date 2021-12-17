Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1352478284
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 02:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhLQBvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 20:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhLQBu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 20:50:58 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70694C061574;
        Thu, 16 Dec 2021 17:50:58 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id r5so680985pgi.6;
        Thu, 16 Dec 2021 17:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c6T8TScjh8deQN/B7UcgkU1g/9zF6+T8erziF7V7e64=;
        b=JuW5oXkybAiCB7scGJolylxz58BZeH3gvbvP61PmI3P4lYOrhRH1CsbdnAun1qogNk
         gmo4+RXVsbLPne/+kK9vB5CJmghHVIz/CWaejL8n8BWdMt2RqPkuQcMKz3TEhB5q8Ho/
         /GkSMUyAQ/Xu6HSJ3cBiogwKscN9CCo3iRic4gUTizn64k+uehRLs4sNYGVPpB4+Arpr
         yk10ZkLs7vrlahZ4j16sOsyj4ESTPb4q+JNa2bxNkFq1TKl7A9+YtDcRpPnZPQFOpjO3
         dUbYQawwNdM8eeBNRsTbFp16Sdg83EZ5Lgqh3Awb01nvmheFtlh563qw/8lx43XlB9nH
         MGUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c6T8TScjh8deQN/B7UcgkU1g/9zF6+T8erziF7V7e64=;
        b=GlmvJrKl2lmgnB/+4aHFADoJDdwpsd2E7P8PbawZPB9BjooiPxkt1U9w+gBmHMNPKa
         tXsyWWzSmwz7B43hqjTy4u3KqQXv1oOEj106LTQdWc/iDJ2Oz9vPJnD7LUFDzFy9Odeo
         akxJGeo1sWGHEN91DD9oBjM5edjL2F7D7OIKfmCaAWt1mN/9QdkKN5l88GO6WYlieKI9
         9uZRRgaL3QKvnlcWxX8yO7NPDqIh17X9cHiqQruenAYOrfpnH6S2EDyEf3d3q7tzfhWv
         zQ7kbsNF4jbNoYQa74EsHRpuhOyI0xNkekW7iNWZn5Fu4jLlKluhyE4sgQbajGv0lAnk
         LFLA==
X-Gm-Message-State: AOAM533T8dG3jEoeHOU6WYP9bK+mCZvWc4ProbI7loJZ4qHfKZ5iXOVa
        5jKx/94kwle8qGiaq6hJ/0RV1jMbLkU=
X-Google-Smtp-Source: ABdhPJxqWvWJv1G8kY9qJk0sfNMZWuZtvD7zbVLxynz3+faeX7EzNqG8y7xVOw7MSOJ6HarsVB6oeQ==
X-Received: by 2002:a63:9857:: with SMTP id l23mr843308pgo.482.1639705857853;
        Thu, 16 Dec 2021 17:50:57 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id oc8sm6727193pjb.45.2021.12.16.17.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:50:57 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v4 08/10] selftests/bpf: Add test for unstable CT lookup API
Date:   Fri, 17 Dec 2021 07:20:29 +0530
Message-Id: <20211217015031.1278167-9-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8450; h=from:subject; bh=OV3XsPUmIqF09MqHmIKAK6e33SZ9RG74MGiTdRhgU/Y=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhu+vFVjaDC4V61Mglf27wPFWbvHU2Tkjwgj/PS5lj ZfLkDs2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbvrxQAKCRBM4MiGSL8RypYCEA CWv8uf2jMSFB1EeCBLuiT+lLGHNSzmbahnT52geyPkSm8KJTUsbDt875PyrIywJLdWY6PuaN/pHSAx RR4rr7Nzz0ZpwL7k/ayuVLFYS1InkeoB/PJ6CDumAXO85651gnnzaWdpCylew2RFcPnj180PTQkdTu R9+2H9KGMju5Hl+wlyQCLL8YgZpatmTL1uCoHnTqT33J8LuZEIJ1D8WkNAQlfo+CKILxyNsWVD9zmH q6eFue2sGG6U95lyr2tImmmnFVO4HehZAK+8/HoxdOSTXQ95sTq2ahww7c7E8Mk/59Kw1fpo0o6VuI Fp/XvysVVVrXz7eUT/ROVfeJvjlr0g0jrkra/1iDUOcwvoKhYTGDeW4rFyHF2OrhecV0d2Vrmu+eJ4 gWlca3swp/p+1dG922FigoN++Qz2szu/9A4k2+eyfaHuqOrkTSg+y86BG03TaWS8edL6YR50ozsIPA a+yF4Nm9vkFycSKH+z9SFneAIvKfgvPQ9P86TNzm/rF7vCOTG4tAc/iBjMkpbhGrP/yBRUB0uU70Hq XZo8QWHaib2COIquzidu5lQPxwPLm/pW1lFmf4tFvUTwUmSFT/wOcj044rH8z7d6RgYfrwBY5TTQZd IbgGkIaKgLmCzAWjBdgsgtbVRllf+qVdbWBTNscHMZeTwjbiFjSbGJUQlEKg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests that we return errors as documented, and also that the kfunc
calls work from both XDP and TC hooks.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/config            |   4 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  48 ++++++++
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 105 ++++++++++++++++++
 3 files changed, 157 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 5192305159ec..4a2a47fcd6ef 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -46,3 +46,7 @@ CONFIG_IMA_READ_POLICY=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y
+CONFIG_NETFILTER=y
+CONFIG_NF_DEFRAG_IPV4=y
+CONFIG_NF_DEFRAG_IPV6=y
+CONFIG_NF_CONNTRACK=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
new file mode 100644
index 000000000000..e3166a81e989
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "test_bpf_nf.skel.h"
+
+enum {
+	TEST_XDP,
+	TEST_TC_BPF,
+};
+
+void test_bpf_nf_ct(int mode)
+{
+	struct test_bpf_nf *skel;
+	int prog_fd, err, retval;
+
+	skel = test_bpf_nf__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
+		return;
+
+	if (mode == TEST_XDP)
+		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
+	else
+		prog_fd = bpf_program__fd(skel->progs.nf_skb_ct_test);
+
+	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4), NULL, NULL,
+				(__u32 *)&retval, NULL);
+	if (!ASSERT_OK(err, "bpf_prog_test_run"))
+		goto end;
+
+	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
+	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
+	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
+	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
+	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
+	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
+	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
+	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
+end:
+	test_bpf_nf__destroy(skel);
+}
+
+void test_bpf_nf(void)
+{
+	if (test__start_subtest("xdp-ct"))
+		test_bpf_nf_ct(TEST_XDP);
+	if (test__start_subtest("tc-bpf-ct"))
+		test_bpf_nf_ct(TEST_TC_BPF);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
new file mode 100644
index 000000000000..1c7d3b83b3e6
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -0,0 +1,105 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+#define EAFNOSUPPORT 97
+#define EPROTO 71
+#define ENONET 64
+#define EINVAL 22
+#define ENOENT 2
+
+int test_einval_bpf_tuple = 0;
+int test_einval_reserved = 0;
+int test_einval_netns_id = 0;
+int test_einval_len_opts = 0;
+int test_eproto_l4proto = 0;
+int test_enonet_netns_id = 0;
+int test_enoent_lookup = 0;
+int test_eafnosupport = 0;
+
+struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __weak __ksym;
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __weak __ksym;
+void bpf_ct_release(struct nf_conn *) __weak __ksym;
+
+#define nf_ct_test(func, ctx)                                                  \
+	({                                                                     \
+		struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP,        \
+						.netns_id = -1 };              \
+		struct bpf_sock_tuple bpf_tuple;                               \
+		struct nf_conn *ct;                                            \
+		__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));       \
+		ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));          \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_bpf_tuple = opts_def.error;                \
+		opts_def.reserved[0] = 1;                                      \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.reserved[0] = 0;                                      \
+		opts_def.l4proto = IPPROTO_TCP;                                \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_reserved = opts_def.error;                 \
+		opts_def.netns_id = -2;                                        \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.netns_id = -1;                                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_netns_id = opts_def.error;                 \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def) - 1);                               \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_einval_len_opts = opts_def.error;                 \
+		opts_def.l4proto = IPPROTO_ICMP;                               \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.l4proto = IPPROTO_TCP;                                \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_eproto_l4proto = opts_def.error;                  \
+		opts_def.netns_id = 0xf00f;                                    \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		opts_def.netns_id = -1;                                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_enonet_netns_id = opts_def.error;                 \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,  \
+			  sizeof(opts_def));                                   \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_enoent_lookup = opts_def.error;                   \
+		ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1,         \
+			  &opts_def, sizeof(opts_def));                        \
+		if (ct)                                                        \
+			bpf_ct_release(ct);                                    \
+		else                                                           \
+			test_eafnosupport = opts_def.error;                    \
+	})
+
+SEC("xdp")
+int nf_xdp_ct_test(struct xdp_md *ctx)
+{
+	nf_ct_test(bpf_xdp_ct_lookup, ctx);
+	return 0;
+}
+
+SEC("tc")
+int nf_skb_ct_test(struct __sk_buff *ctx)
+{
+	nf_ct_test(bpf_skb_ct_lookup, ctx);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

