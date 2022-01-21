Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304AF495D73
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379920AbiAUKMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349875AbiAUKL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:11:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A5FC061574;
        Fri, 21 Jan 2022 02:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30230B81F6D;
        Fri, 21 Jan 2022 10:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0374C340E3;
        Fri, 21 Jan 2022 10:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759916;
        bh=C4C9xzBfVHgYxbXZLcq114v/+pgTNzZ226e0416Uk5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtN+PZOxAabOqQnLIW1iqWsjRXqoTcdoKpp05jtlMa9WC/NPn0vxFPRV2yHkRgrLj
         NNTY/OI8ID0SQoG2lT/3ebjo3l34be0wZ6wsoO00XYGNUHNPzBCP2r+x42+lR4JfFi
         HEi1vqLos03mGBDgNVvm6ElbmdpoaEVzvsP6qLXu9CId46D2K3O0Ii9h0R5JIKFla4
         EdYUJhy9VB+xDVL11SvRTJ2XAgeMzkgYRIx7u5KKKpbhFzLcS82EQeX33tubfyDsYl
         ntIIGdo1Kx64AXY4i7YtTf5277cfEk/K+pUYjJhsA/0jVEaBRt6hL5Pm5AFKg9zPCh
         6iu+GkGH8n3hw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 17/23] bpf: selftests: update xdp_adjust_tail selftest to include xdp frags
Date:   Fri, 21 Jan 2022 11:10:00 +0100
Message-Id: <d2e6a0ebc52db6f89e62b9befe045032e5e0a5fe.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds test cases for the xdp frags scenarios when shrinking
and growing.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 .../bpf/prog_tests/xdp_adjust_tail.c          | 125 ++++++++++++++++++
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++++-
 3 files changed, 160 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index d5ebe92b0ebb..ccc9e63254a8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -118,6 +118,127 @@ static void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
+void test_xdp_adjust_frags_tail_shrink(void)
+{
+	const char *file = "./test_xdp_adjust_tail_shrink.o";
+	__u32 duration, retval, size, exp_size;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int err, prog_fd;
+	__u8 *buf;
+
+	/* For the individual test cases, the first byte in the packet
+	 * indicates which test will be run.
+	 */
+	obj = bpf_object__open(file);
+	if (libbpf_get_error(obj))
+		return;
+
+	prog = bpf_object__next_program(obj, NULL);
+	if (bpf_object__load(obj))
+		return;
+
+	prog_fd = bpf_program__fd(prog);
+
+	buf = malloc(9000);
+	if (!ASSERT_OK_PTR(buf, "alloc buf 9Kb"))
+		goto out;
+
+	memset(buf, 0, 9000);
+
+	/* Test case removing 10 bytes from last frag, NOT freeing it */
+	exp_size = 8990; /* 9000 - 10 */
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	ASSERT_OK(err, "9Kb-10b");
+	ASSERT_EQ(retval, XDP_TX, "9Kb-10b retval");
+	ASSERT_EQ(size, exp_size, "9Kb-10b size");
+
+	/* Test case removing one of two pages, assuming 4K pages */
+	buf[0] = 1;
+	exp_size = 4900; /* 9000 - 4100 */
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	ASSERT_OK(err, "9Kb-4Kb");
+	ASSERT_EQ(retval, XDP_TX, "9Kb-4Kb retval");
+	ASSERT_EQ(size, exp_size, "9Kb-4Kb size");
+
+	/* Test case removing two pages resulting in a linear xdp_buff */
+	buf[0] = 2;
+	exp_size = 800; /* 9000 - 8200 */
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	ASSERT_OK(err, "9Kb-9Kb");
+	ASSERT_EQ(retval, XDP_TX, "9Kb-9Kb retval");
+	ASSERT_EQ(size, exp_size, "9Kb-9Kb size");
+
+	free(buf);
+out:
+	bpf_object__close(obj);
+}
+
+void test_xdp_adjust_frags_tail_grow(void)
+{
+	const char *file = "./test_xdp_adjust_tail_grow.o";
+	__u32 duration, retval, size, exp_size;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int err, i, prog_fd;
+	__u8 *buf;
+
+	obj = bpf_object__open(file);
+	if (libbpf_get_error(obj))
+		return;
+
+	prog = bpf_object__next_program(obj, NULL);
+	if (bpf_object__load(obj))
+		return;
+
+	prog_fd = bpf_program__fd(prog);
+
+	buf = malloc(16384);
+	if (!ASSERT_OK_PTR(buf, "alloc buf 16Kb"))
+		goto out;
+
+	/* Test case add 10 bytes to last frag */
+	memset(buf, 1, 16384);
+	size = 9000;
+	exp_size = size + 10;
+	err = bpf_prog_test_run(prog_fd, 1, buf, size,
+				buf, &size, &retval, &duration);
+
+	ASSERT_OK(err, "9Kb+10b");
+	ASSERT_EQ(retval, XDP_TX, "9Kb+10b retval");
+	ASSERT_EQ(size, exp_size, "9Kb+10b size");
+
+	for (i = 0; i < 9000; i++)
+		ASSERT_EQ(buf[i], 1, "9Kb+10b-old");
+
+	for (i = 9000; i < 9010; i++)
+		ASSERT_EQ(buf[i], 0, "9Kb+10b-new");
+
+	for (i = 9010; i < 16384; i++)
+		ASSERT_EQ(buf[i], 1, "9Kb+10b-untouched");
+
+	/* Test a too large grow */
+	memset(buf, 1, 16384);
+	size = 9001;
+	exp_size = size;
+	err = bpf_prog_test_run(prog_fd, 1, buf, size,
+				buf, &size, &retval, &duration);
+
+	ASSERT_OK(err, "9Kb+10b");
+	ASSERT_EQ(retval, XDP_DROP, "9Kb+10b retval");
+	ASSERT_EQ(size, exp_size, "9Kb+10b size");
+
+	free(buf);
+out:
+	bpf_object__close(obj);
+}
+
 void test_xdp_adjust_tail(void)
 {
 	if (test__start_subtest("xdp_adjust_tail_shrink"))
@@ -126,4 +247,8 @@ void test_xdp_adjust_tail(void)
 		test_xdp_adjust_tail_grow();
 	if (test__start_subtest("xdp_adjust_tail_grow2"))
 		test_xdp_adjust_tail_grow2();
+	if (test__start_subtest("xdp_adjust_frags_tail_shrink"))
+		test_xdp_adjust_frags_tail_shrink();
+	if (test__start_subtest("xdp_adjust_frags_tail_grow"))
+		test_xdp_adjust_frags_tail_grow();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
index 199c61b7d062..53b64c999450 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
@@ -7,11 +7,10 @@ int _xdp_adjust_tail_grow(struct xdp_md *xdp)
 {
 	void *data_end = (void *)(long)xdp->data_end;
 	void *data = (void *)(long)xdp->data;
-	unsigned int data_len;
+	int data_len = bpf_xdp_get_buff_len(xdp);
 	int offset = 0;
 
 	/* Data length determine test case */
-	data_len = data_end - data;
 
 	if (data_len == 54) { /* sizeof(pkt_v4) */
 		offset = 4096; /* test too large offset */
@@ -20,7 +19,12 @@ int _xdp_adjust_tail_grow(struct xdp_md *xdp)
 	} else if (data_len == 64) {
 		offset = 128;
 	} else if (data_len == 128) {
-		offset = 4096 - 256 - 320 - data_len; /* Max tail grow 3520 */
+		/* Max tail grow 3520 */
+		offset = 4096 - 256 - 320 - data_len;
+	} else if (data_len == 9000) {
+		offset = 10;
+	} else if (data_len == 9001) {
+		offset = 4096;
 	} else {
 		return XDP_ABORTED; /* No matching test */
 	}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
index b7448253d135..ca68c038357c 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
@@ -12,14 +12,38 @@
 SEC("xdp")
 int _xdp_adjust_tail_shrink(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	__u8 *data_end = (void *)(long)xdp->data_end;
+	__u8 *data = (void *)(long)xdp->data;
 	int offset = 0;
 
-	if (data_end - data == 54) /* sizeof(pkt_v4) */
+	switch (bpf_xdp_get_buff_len(xdp)) {
+	case 54:
+		/* sizeof(pkt_v4) */
 		offset = 256; /* shrink too much */
-	else
+		break;
+	case 9000:
+		/* non-linear buff test cases */
+		if (data + 1 > data_end)
+			return XDP_DROP;
+
+		switch (data[0]) {
+		case 0:
+			offset = 10;
+			break;
+		case 1:
+			offset = 4100;
+			break;
+		case 2:
+			offset = 8200;
+			break;
+		default:
+			return XDP_DROP;
+		}
+		break;
+	default:
 		offset = 20;
+		break;
+	}
 	if (bpf_xdp_adjust_tail(xdp, 0 - offset))
 		return XDP_DROP;
 	return XDP_TX;
-- 
2.34.1

