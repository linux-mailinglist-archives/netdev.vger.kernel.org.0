Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118D92C6B54
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 19:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbgK0SHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 13:07:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731981AbgK0SHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 13:07:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606500426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=syTvU0jrp0ayBwL6zMDhSOwpXyqcnTrTsriNHwa1rMo=;
        b=M97G+7wDIZH4cFEhDPTWhoPLPYJ8ouOMI9VUlABYfiWO0CQNGjhfjwJhFpNKvxxIEYa3dw
        iNg5dFgaTaZ4bxCUOfbIfjSSsIGWAHUewXZ/s0D2hja7zq0gCwVoCNvoaYLC5i+fy+K5RQ
        vQTgu2DnmUwYTg2+8LylN8R9sg9k6H4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-4VpYtueVPfqkuOnbG6uDCg-1; Fri, 27 Nov 2020 13:07:01 -0500
X-MC-Unique: 4VpYtueVPfqkuOnbG6uDCg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8D3580ED8B;
        Fri, 27 Nov 2020 18:06:59 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35B1F10021B3;
        Fri, 27 Nov 2020 18:06:59 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 32E8B32138453;
        Fri, 27 Nov 2020 19:06:58 +0100 (CET)
Subject: [PATCH bpf-next V8 8/8] bpf/selftests: tests using bpf_check_mtu
 BPF-helper
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Fri, 27 Nov 2020 19:06:58 +0100
Message-ID: <160650041814.2890576.15669951840217403529.stgit@firesoul>
In-Reply-To: <160650034591.2890576.1092952641487480652.stgit@firesoul>
References: <160650034591.2890576.1092952641487480652.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding selftest for BPF-helper bpf_check_mtu(). Making sure
it can be used from both XDP and TC.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |  204 ++++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_check_mtu.c |  196 +++++++++++++++++++
 2 files changed, 400 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c

diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
new file mode 100644
index 000000000000..b5d0c3a9abe8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
@@ -0,0 +1,204 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Jesper Dangaard Brouer */
+
+#include <linux/if_link.h> /* before test_progs.h, avoid bpf_util.h redefines */
+
+#include <test_progs.h>
+#include "test_check_mtu.skel.h"
+#include <network_helpers.h>
+
+#include <stdlib.h>
+#include <inttypes.h>
+
+#define IFINDEX_LO 1
+
+static __u32 duration; /* Hint: needed for CHECK macro */
+
+static int read_mtu_device_lo(void)
+{
+	const char *filename = "/sys/devices/virtual/net/lo/mtu";
+	char buf[11] = {};
+	int value;
+	int fd;
+
+	fd = open(filename, 0, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	if (read(fd, buf, sizeof(buf)) == -1)
+		return -2;
+	close(fd);
+
+	value = strtoimax(buf, NULL, 10);
+	if (errno == ERANGE)
+		return -3;
+
+	return value;
+}
+
+static void test_check_mtu_xdp_attach(struct bpf_program *prog)
+{
+	int err = 0;
+	int fd;
+
+	fd = bpf_program__fd(prog);
+	err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
+	if (CHECK(err, "XDP-attach", "failed"))
+		return;
+
+	bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
+}
+
+static void test_check_mtu_run_xdp(struct test_check_mtu *skel,
+				   struct bpf_program *prog,
+				   __u32 mtu_expect)
+{
+	const char *prog_name = bpf_program__name(prog);
+	int retval_expect = XDP_PASS;
+	__u32 mtu_result = 0;
+	char buf[256];
+	int err;
+
+	struct bpf_prog_test_run_attr tattr = {
+		.repeat = 1,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.data_out = buf,
+		.data_size_out = sizeof(buf),
+		.prog_fd = bpf_program__fd(prog),
+	};
+
+	memset(buf, 0, sizeof(buf));
+
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
+		   "prog_name:%s (err %d errno %d retval %d)\n",
+		   prog_name, err, errno, tattr.retval);
+
+        CHECK(tattr.retval != retval_expect, "retval",
+	      "progname:%s unexpected retval=%d expected=%d\n",
+	      prog_name, tattr.retval, retval_expect);
+
+	/* Extract MTU that BPF-prog got */
+	mtu_result = skel->bss->global_bpf_mtu_xdp;
+	CHECK(mtu_result != mtu_expect, "MTU-compare-user",
+	      "failed (MTU user:%d bpf:%d)", mtu_expect, mtu_result);
+}
+
+static void test_check_mtu_xdp(__u32 mtu, __u32 ifindex)
+{
+	struct test_check_mtu *skel;
+	int err;
+
+	skel = test_check_mtu__open();
+	if (CHECK(!skel, "skel_open", "failed"))
+		return;
+
+	/* Update "constants" in BPF-prog *BEFORE* libbpf load */
+	skel->rodata->GLOBAL_USER_MTU = mtu;
+	skel->rodata->GLOBAL_USER_IFINDEX = ifindex;
+
+	err = test_check_mtu__load(skel);
+	if (CHECK(err, "skel_load", "failed: %d\n", err))
+		goto cleanup;
+
+	test_check_mtu_run_xdp(skel, skel->progs.xdp_use_helper, mtu);
+	test_check_mtu_run_xdp(skel, skel->progs.xdp_exceed_mtu, mtu);
+	test_check_mtu_run_xdp(skel, skel->progs.xdp_minus_delta, mtu);
+
+cleanup:
+	test_check_mtu__destroy(skel);
+}
+
+static void test_check_mtu_run_tc(struct test_check_mtu *skel,
+				  struct bpf_program *prog,
+				  __u32 mtu_expect)
+{
+	const char *prog_name = bpf_program__name(prog);
+	int retval_expect = BPF_OK;
+	__u32 mtu_result = 0;
+	char buf[256];
+	int err;
+
+	struct bpf_prog_test_run_attr tattr = {
+		.repeat = 1,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.data_out = buf,
+		.data_size_out = sizeof(buf),
+		.prog_fd = bpf_program__fd(prog),
+	};
+
+	memset(buf, 0, sizeof(buf));
+
+	err = bpf_prog_test_run_xattr(&tattr);
+	CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
+		   "prog_name:%s (err %d errno %d retval %d)\n",
+		   prog_name, err, errno, tattr.retval);
+
+        CHECK(tattr.retval != retval_expect, "retval",
+	      "progname:%s unexpected retval=%d expected=%d\n",
+	      prog_name, tattr.retval, retval_expect);
+
+	/* Extract MTU that BPF-prog got */
+	mtu_result = skel->bss->global_bpf_mtu_tc;
+	CHECK(mtu_result != mtu_expect, "MTU-compare-user",
+	      "failed (MTU user:%d bpf:%d)", mtu_expect, mtu_result);
+}
+
+
+static void test_check_mtu_tc(__u32 mtu, __u32 ifindex)
+{
+	struct test_check_mtu *skel;
+	int err;
+
+	skel = test_check_mtu__open();
+	if (CHECK(!skel, "skel_open", "failed"))
+		return;
+
+	/* Update "constants" in BPF-prog *BEFORE* libbpf load */
+	skel->rodata->GLOBAL_USER_MTU = mtu;
+	skel->rodata->GLOBAL_USER_IFINDEX = ifindex;
+
+	err = test_check_mtu__load(skel);
+	if (CHECK(err, "skel_load", "failed: %d\n", err))
+		goto cleanup;
+
+	test_check_mtu_run_tc(skel, skel->progs.tc_use_helper, mtu);
+	test_check_mtu_run_tc(skel, skel->progs.tc_exceed_mtu, mtu);
+	test_check_mtu_run_tc(skel, skel->progs.tc_exceed_mtu_da, mtu);
+	test_check_mtu_run_tc(skel, skel->progs.tc_minus_delta, mtu);
+cleanup:
+	test_check_mtu__destroy(skel);
+}
+
+void test_check_mtu(void)
+{
+	struct test_check_mtu *skel;
+	__u32 mtu_lo;
+
+	skel = test_check_mtu__open_and_load();
+	if (CHECK(!skel, "open and load skel", "failed"))
+		return; /* Exit if e.g. helper unknown to kernel */
+
+	if (test__start_subtest("bpf_check_mtu XDP-attach"))
+		test_check_mtu_xdp_attach(skel->progs.xdp_use_helper_basic);
+
+	test_check_mtu__destroy(skel);
+
+	mtu_lo = read_mtu_device_lo();
+	if (CHECK(mtu_lo < 0, "reading MTU value", "failed (err:%d)", mtu_lo))
+		return;
+
+	if (test__start_subtest("bpf_check_mtu XDP-run"))
+		test_check_mtu_xdp(mtu_lo, 0);
+
+	if (test__start_subtest("bpf_check_mtu XDP-run ifindex-lookup"))
+		test_check_mtu_xdp(mtu_lo, IFINDEX_LO);
+
+	if (test__start_subtest("bpf_check_mtu TC-run"))
+		test_check_mtu_tc(mtu_lo, 0);
+
+	if (test__start_subtest("bpf_check_mtu TC-run ifindex-lookup"))
+		test_check_mtu_tc(mtu_lo, IFINDEX_LO);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_check_mtu.c b/tools/testing/selftests/bpf/progs/test_check_mtu.c
new file mode 100644
index 000000000000..91a026b8d458
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_check_mtu.c
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Jesper Dangaard Brouer */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <linux/if_ether.h>
+
+#include <stddef.h>
+#include <stdint.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* Userspace will update with MTU it can see on device */
+static volatile const int GLOBAL_USER_MTU;
+static volatile const __u32 GLOBAL_USER_IFINDEX;
+
+/* BPF-prog will update these with MTU values it can see */
+__u32 global_bpf_mtu_xdp = 0;
+__u32 global_bpf_mtu_tc  = 0;
+
+SEC("xdp")
+int xdp_use_helper_basic(struct xdp_md *ctx)
+{
+	__u32 mtu_len = 0;
+
+	if (bpf_check_mtu(ctx, 0, &mtu_len, 0, 0))
+		return XDP_ABORTED;
+
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int xdp_use_helper(struct xdp_md *ctx)
+{
+	int retval = XDP_PASS; /* Expected retval on successful test */
+	__u32 mtu_len = 0;
+	__u32 ifindex = 0;
+	int delta = 0;
+
+	/* When ifindex is zero, save net_device lookup and use ctx netdev */
+	if (GLOBAL_USER_IFINDEX > 0)
+		ifindex = GLOBAL_USER_IFINDEX;
+
+	if (bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0)) {
+		/* mtu_len is also valid when check fail */
+		retval = XDP_ABORTED;
+		goto out;
+	}
+
+	if (GLOBAL_USER_MTU != mtu_len)
+		retval = XDP_DROP;
+
+out:
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}
+
+SEC("xdp")
+int xdp_exceed_mtu(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	__u32 data_len = data_end - data;
+	int retval = XDP_ABORTED; /* Fail */
+	__u32 mtu_len = 0;
+
+	int delta;
+	int err;
+
+	/* Exceed MTU with 1 via delta adjust */
+	delta = GLOBAL_USER_MTU - (data_len - ETH_HLEN) + 1;
+
+	if ((err = bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))) {
+		retval = XDP_PASS; /* Success in exceeding MTU check */
+		if (err != BPF_MTU_CHK_RET_FRAG_NEEDED)
+			retval = XDP_DROP;
+	}
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}
+
+SEC("xdp")
+int xdp_minus_delta(struct xdp_md *ctx)
+{
+	int retval = XDP_PASS; /* Expected retval on successful test */
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	__u32 data_len = data_end - data;
+	__u32 mtu_len = 0;
+	int delta;
+
+	/* Boarderline test case: Minus delta exceeding packet length allowed */
+	delta = -((data_len - ETH_HLEN) + 1);
+
+	/* Minus length (adjusted via delta) still pass MTU check, other helpers
+	 * are responsible for catching this, when doing actual size adjust
+	 */
+	if (bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))
+		retval = XDP_ABORTED;
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}
+
+SEC("classifier")
+int tc_use_helper(struct __sk_buff *ctx)
+{
+	int retval = BPF_OK; /* Expected retval on successful test */
+	__u32 mtu_len = 0;
+	int delta = 0;
+
+	if (bpf_check_mtu(ctx, 0, &mtu_len, delta, 0)) {
+		retval = BPF_DROP;
+		goto out;
+	}
+
+	if (GLOBAL_USER_MTU != mtu_len)
+		retval = BPF_REDIRECT;
+out:
+	global_bpf_mtu_tc = mtu_len;
+	return retval;
+}
+
+SEC("classifier")
+int tc_exceed_mtu(struct __sk_buff *ctx)
+{
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	int retval = BPF_DROP; /* Fail */
+	__u32 skb_len = ctx->len;
+	__u32 mtu_len = 0;
+	int delta;
+	int err;
+
+	/* Exceed MTU with 1 via delta adjust */
+	delta = GLOBAL_USER_MTU - (skb_len - ETH_HLEN) + 1;
+
+	if ((err = bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))) {
+		retval = BPF_OK; /* Success in exceeding MTU check */
+		if (err != BPF_MTU_CHK_RET_FRAG_NEEDED)
+			retval = BPF_DROP;
+	}
+
+	global_bpf_mtu_tc = mtu_len;
+	return retval;
+}
+
+SEC("classifier")
+int tc_exceed_mtu_da(struct __sk_buff *ctx)
+{
+	/* SKB Direct-Access variant */
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	__u32 data_len = data_end - data;
+	int retval = BPF_DROP; /* Fail */
+	__u32 mtu_len = 0;
+	int delta;
+	int err;
+
+	/* Exceed MTU with 1 via delta adjust */
+	delta = GLOBAL_USER_MTU - (data_len - ETH_HLEN) + 1;
+
+	if ((err = bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))) {
+		retval = BPF_OK; /* Success in exceeding MTU check */
+		if (err != BPF_MTU_CHK_RET_FRAG_NEEDED)
+			retval = BPF_DROP;
+	}
+
+	global_bpf_mtu_tc = mtu_len;
+	return retval;
+}
+
+SEC("classifier")
+int tc_minus_delta(struct __sk_buff *ctx)
+{
+	int retval = BPF_OK; /* Expected retval on successful test */
+	__u32 ifindex = GLOBAL_USER_IFINDEX;
+	__u32 skb_len = ctx->len;
+	__u32 mtu_len = 0;
+	int delta;
+
+	/* Boarderline test case: Minus delta exceeding packet length allowed */
+	delta = -((skb_len - ETH_HLEN) + 1);
+
+	/* Minus length (adjusted via delta) still pass MTU check, other helpers
+	 * are responsible for catching this, when doing actual size adjust
+	 */
+	if (bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))
+		retval = BPF_DROP;
+
+	global_bpf_mtu_xdp = mtu_len;
+	return retval;
+}


