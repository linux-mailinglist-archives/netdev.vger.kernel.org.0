Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2082948EE81
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243524AbiANQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiANQlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:41:02 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63023C06161C;
        Fri, 14 Jan 2022 08:41:02 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id n185so3191020pfd.2;
        Fri, 14 Jan 2022 08:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A3JaLE84K67zRLJfMf/KLOLAhK0TAQ3Mmgvt7CxX1JQ=;
        b=DjAvVeFNDGk2VwVFndxrYuCQ291R8un0VijDEjaCTuA5Z2yPOWRldt5+WAdvsQjCq9
         /dy3Z7D6eRGkw4bwxEB8WMxO5IgkavP7nORumNqtajGqg5VjXPl5q/oLFv55griLXSbp
         raN0UowfSq9i8SwCAhND37pXORYjYDH3sE3zuVDnSHOJmVnfhy1Z955NrUwd8BiEAWEj
         QYIKRtVew0K23jXms0V95SUpiHogTvglf1apicovxnrnmISDnIh69y6cwGmFJ0WGaFW6
         +4EJSUCM+yGkpajSKzFbgb4CjEMpuWWp76Nv9LnD9lXhmxDFLsiWw0pCGfsMQP+/Ki5W
         gILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A3JaLE84K67zRLJfMf/KLOLAhK0TAQ3Mmgvt7CxX1JQ=;
        b=ziV7Aht2ppbgKrlMwYg1SshEa8mjDF6JSkbLuxmt9HXdUcRvi6F2BE2wqkKZ7dkPCD
         8Y8g0nSGoN4WVMXbSBQka2+7FhdB9id+uYzxE6EoEYQiuZEdCBm4Cypf16IeLUY8nNIz
         XIO6qA0DhDn/RHS6mqV6+vN6oMFSBXU+Gj/81dTu/fZX+uIla7w3GO5O/HbHdzwUeXo8
         C3kBtKl501K+4WMKVP5VaBk5zgLjPs+TpiYoJ29lNBjg2NBLvKbm4kzYrNe9Jjir7B89
         8P85dTozDG2u27GnOZ+PlfZZwlgBeyuxvH0foNvfUFq9rgjVuii1FHuscTWWJCi9wKSJ
         4C6g==
X-Gm-Message-State: AOAM531LnxzmxvygOGq1mUo9H8+q+As60DLtTgY+goVFuOAu/t0TXGsy
        JitgoS4g1MP5mD+R2zb6L89QrwFTciGaiw==
X-Google-Smtp-Source: ABdhPJwgk7tSkZH8kOgl4GsqtMok6aNzBTcyfQOhjoom/JFLFUa/ctwQNdHcNQmn+OgsiPjT927Feg==
X-Received: by 2002:a63:171a:: with SMTP id x26mr1949124pgl.447.1642178461647;
        Fri, 14 Jan 2022 08:41:01 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id p18sm6161251pfq.174.2022.01.14.08.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:41:01 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v8 07/10] selftests/bpf: Add test for unstable CT lookup API
Date:   Fri, 14 Jan 2022 22:09:50 +0530
Message-Id: <20220114163953.1455836-8-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
References: <20220114163953.1455836-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6262; h=from:subject; bh=/8Ad9SyjgovBrK+6yQ9veygYGzalPT2UjOu1akeAQx0=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acVX7kA7VuYQoxExooJvfPjXBHgYl3YUQ1A0bPF XVFSNgqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFQAKCRBM4MiGSL8Ryl11EA C4s6Vhpbd2kdshjW6iCJ0ygs3esWXXBbIldCR7jQI90S3l9/smlmzZNbT0UZHhm6oOPKOZ7T1AQ6YY l0yUjlPeKVUK8J6JNQACDyROsua9qe6nnh3Ay963wVMEmPD7bJd+SVcpdX5hPkajcAMKBAYAs3QPge WtZVgvHAGDRHP/MykiM/AOkMa55Q87GEKBAFT7i4y+CP4FTX5Sym07O5SJ+LvdnO3XA0RwdzNJbw0E Telp4s3bUq04q8AtqYtxOX4RfakMrGa3bsdv86nQL/L8zYadeVh4OvqyOOxlvVP1tR7E77CLOri/zn jzE1fpR22cTcFt4YP9iU9/gLR+go04oZpwaaPY/BALLuMw5ykbAHWU0dBkbPy9npIBPuaDOdnLoXBT V6vKOO80Skd4WXO3wtPf+AVq6MfwhfP8Rn3vtWC+o8lhmb0Vf1CEjHdJbphhAvBiURqVdBzBgvq2Y3 U6iHjX/OtvVywUWP9ZWWHNMG66spCo84+8jVndp8O6NAK8ffPjCPz+zgaDeNuej0YrNAEYH9IyDRm8 phO+Bpenp9zmuMNP9ii2heHwnLN0yRaMY0Qt5FVVbwNzjovlt7fD08L2zDFcmgQrqubXMz6oYPQI9F RDvH8cp3eqKQ/j2kWYv7z7lmzFRf/4PA4HLx48/NtbCJ/T40hg4n4S2WFlqQ==
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
 .../testing/selftests/bpf/progs/test_bpf_nf.c | 109 ++++++++++++++++++
 3 files changed, 161 insertions(+)
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
index 000000000000..6f131c993c0b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -0,0 +1,109 @@
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
+static __always_inline void
+nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
+				   struct bpf_ct_opts *, u32),
+	   void *ctx)
+{
+	struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
+	struct bpf_sock_tuple bpf_tuple;
+	struct nf_conn *ct;
+
+	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
+
+	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_einval_bpf_tuple = opts_def.error;
+
+	opts_def.reserved[0] = 1;
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	opts_def.reserved[0] = 0;
+	opts_def.l4proto = IPPROTO_TCP;
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_einval_reserved = opts_def.error;
+
+	opts_def.netns_id = -2;
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	opts_def.netns_id = -1;
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_einval_netns_id = opts_def.error;
+
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_einval_len_opts = opts_def.error;
+
+	opts_def.l4proto = IPPROTO_ICMP;
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	opts_def.l4proto = IPPROTO_TCP;
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_eproto_l4proto = opts_def.error;
+
+	opts_def.netns_id = 0xf00f;
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	opts_def.netns_id = -1;
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_enonet_netns_id = opts_def.error;
+
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_enoent_lookup = opts_def.error;
+
+	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
+	if (ct)
+		bpf_ct_release(ct);
+	else
+		test_eafnosupport = opts_def.error;
+}
+
+SEC("xdp")
+int nf_xdp_ct_test(struct xdp_md *ctx)
+{
+	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
+	return 0;
+}
+
+SEC("tc")
+int nf_skb_ct_test(struct __sk_buff *ctx)
+{
+	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

