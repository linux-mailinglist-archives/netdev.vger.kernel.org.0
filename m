Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812084818B2
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhL3Chd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbhL3Cha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:30 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2179C061574;
        Wed, 29 Dec 2021 18:37:30 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id z3so17242126plg.8;
        Wed, 29 Dec 2021 18:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yPVZrGJSFLRS6MIPiaFyGFav5aw9HfAuGJBQzAxNJDU=;
        b=Ddwcj4Hh2OmLtrFRMkchWicCrg5LflC4xSZ/omcZgCEmtCNzcA2XvQfXwxsNzozNB0
         7uNsi5Q4fc0Dg09tursUeCGNqAUOT5GjA+5h/n5EmYbLBnbIrcZaqVkaBToCAbgAem8b
         YfS9O7TdtqLX2Ypt6KOQ+s4SLunLanzKPt4U5fDPoAwmS4hVJ6hmVof/gVAtdsUY7kVb
         hfJLKf+Tm6nmcgCDQYarsa2X3KLkHQtlP7ucSOCcZIBst2GCLSlCh3dGbDk89Ldw6DSv
         bFxK/T1sqUgA2pchSsPHTI19OHGQvMZ9dOdJS9a5lpmM1TEB6rhF0wsR1E04I7P8/hAC
         /eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yPVZrGJSFLRS6MIPiaFyGFav5aw9HfAuGJBQzAxNJDU=;
        b=Z87ykezrCWmfC9mGaL3d5WMV2cnqDENOPGmSmHUChskO8ioVSS6TKZ2VvcEypcfkkJ
         CpiSXuHYEDyIfmv3VVZ4epYgwQfJUrJSbAq0I1HTKQW+0dMKFcG+St5lpDNRW89ZC38N
         tRRmkx4rRtHPS1Pn3hu30XqqdaxnlBnt2yGZMD+mvdAONi3kd7TZvyWACsVTovGNqQH+
         CtGvxx8O1aCOvqT8GTNKTUcwVqUAd0tED3tIH0OZDxEEUwqLZCOfj1zV/otDp7NTr4I2
         temQD4ps22pCrltZazXRUWMOVVoIkXFkwnIVF8jatPbnNS1GGLdigqLlX6ANIhcO+w8n
         +NkQ==
X-Gm-Message-State: AOAM533Bcy2jQFO5Glcha5osWzlfDxXtmA4AzofnzMdjVyMdyMt15DCE
        YwZ7P8kR1FoT1VAXdcAg/P4SqRPN3Ys=
X-Google-Smtp-Source: ABdhPJzGMriap6i3OUsqIZh4ucnjgrD0MhRXTgOf3eH37kDNmGbhPSrFC63FVOpkXJr58OIGeZqloQ==
X-Received: by 2002:a17:902:dacf:b0:148:a2e8:2c1a with SMTP id q15-20020a170902dacf00b00148a2e82c1amr29438148plx.105.1640831849982;
        Wed, 29 Dec 2021 18:37:29 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id i1sm2099357pgk.89.2021.12.29.18.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:29 -0800 (PST)
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
Subject: [PATCH bpf-next v5 7/9] selftests/bpf: Add test for unstable CT lookup API
Date:   Thu, 30 Dec 2021 08:07:03 +0530
Message-Id: <20211230023705.3860970-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8429; h=from:subject; bh=MBQICqrG+a3pqkvnxVBoDyjAg1t3txFFGYd3KBFCLtU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr+9BbKUvHCnIWf7yQ60wl78R6gMFoTU7Qav50x ByYaS2uJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/gAKCRBM4MiGSL8RyiwVD/ 9ZsU1u7GvDkdVb4d7Q+R5v8u/YKZbn9dYZUugl/TXoOV966YYs8eB7Ecy/2J7iVB8QvxLqxVu1D+mK DDxeFPffykWtIadLWt7x+fYJHQs+K6yK2+CU0rnEJ0pamScPV0ko6wkh2b9ni1DO2sgM1jT+ztXd+7 wJfyvSP1gwALvl/cgz/rgMsbKg0ovlCOr89QrEY1BZ/rQ6beGZ+JD0nQJRub8DAYReMv/DIzJzL1lf JDoCbWVk8TT7it9tzXPX2TAs+ETnXEDAguPqjJxEgDYz0841NEOl9EZJlLEAf6PpyP2Nqu4OrAibwX yRMY0TOdO9YSdqTT5EWqZ1igEc1Lh1po61j6qxaBJI8ST1E2zbDLvjXyS7SpYi8I3qjvqjso/81D+v h43yxvJaA7555PvZNZp3HIBWXfDnKo1ncPNMYZWeHl2FJJIU+ozD8bgSY5qWFrnJ73s757TtaQRWRD dUNLEPFXSARK56Fm9E7axvZR50GUvUtMx1PCL4wj+1jLcPtE3qHsUEIoZdeXgk/tHzNglIKRnzNnrT fopdvfhrqT0sMvnl8ZT19lE3IuZrHmPWWl0UnCioWpOOnhi/CPNXmWuP4nS+YowgPW/6U+Z+zjOIBV 2HhE1J9tDrHelilNGXd2nKTfJevegDvsmqx41ZtWxYJh0xD76j0rCy3+7p0g==
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
index f6287132fa89..32d80e77e910 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -48,3 +48,7 @@ CONFIG_IMA_READ_POLICY=y
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
index 000000000000..d6d4002ad69c
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
+				  struct bpf_ct_opts *, u32) __ksym;
+struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
+				  struct bpf_ct_opts *, u32) __ksym;
+void bpf_ct_release(struct nf_conn *) __ksym;
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

