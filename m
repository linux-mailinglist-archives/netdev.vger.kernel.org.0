Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FABA488373
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiAHLzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:55:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53200 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiAHLzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:55:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C79960F23;
        Sat,  8 Jan 2022 11:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10A7C36AE9;
        Sat,  8 Jan 2022 11:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642904;
        bh=lq1i34qzLr7jq43IPhbeiHfyfJTofyNBkjwvuFqX2HI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KL3QMLiCez4KQUEuCmWjScc+JK6JDtp7y6T8lf/Ua4FGPKzeqRgiVyBEfMs0n2Pqb
         h8l4KNzN6Eoeh9ytveDhWCI5273i6AJ1W836/PMVn+zIlKOclXPbsHfX5MvFysuwXd
         msHfgciLhLiDIwOXQynqxif72EoZc1865yjkY+bgjPZ4/Jn6k5ErUhn9hF58zbZB6j
         s/oJGSU3SJzg9kpdgUPGFiPCmbyUI1UMx7Pse41sCHJ4OLImqqXeQv2/LKUfKjsvaw
         wLG5gEdnUDe+nwTaJnf23pSCEPnKvxEw9a0dBCQMRIEKcXJf4pUYV75ZVx6cLWTg40
         LMhvfr0JWCJpg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 17/23] bpf: selftests: update xdp_adjust_tail selftest to include multi-buffer
Date:   Sat,  8 Jan 2022 12:53:20 +0100
Message-Id: <de8408a520cb1f1881d71cf96d2725868cbf2f5d.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds test cases for the multi-buffer scenarios when shrinking
and growing.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 .../bpf/prog_tests/xdp_adjust_tail.c          | 131 ++++++++++++++++++
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++++-
 3 files changed, 166 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 3f5a17c38be5..d21e0a597b3c 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -130,6 +130,133 @@ static void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
+void test_xdp_adjust_mb_tail_shrink(void)
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
+	if (CHECK(!buf, "malloc()", "error:%s\n", strerror(errno)))
+		goto out;
+
+	memset(buf, 0, 9000);
+
+	/* Test case removing 10 bytes from last frag, NOT freeing it */
+	exp_size = 8990; /* 9000 - 10 */
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k-10b", "err %d errno %d retval %d[%d] size %d[%u]\n",
+	      err, errno, retval, XDP_TX, size, exp_size);
+
+	/* Test case removing one of two pages, assuming 4K pages */
+	buf[0] = 1;
+	exp_size = 4900; /* 9000 - 4100 */
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k-1p", "err %d errno %d retval %d[%d] size %d[%u]\n",
+	      err, errno, retval, XDP_TX, size, exp_size);
+
+	/* Test case removing two pages resulting in a non mb xdp_buff */
+	buf[0] = 2;
+	exp_size = 800; /* 9000 - 8200 */
+	err = bpf_prog_test_run(prog_fd, 1, buf, 9000,
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k-2p", "err %d errno %d retval %d[%d] size %d[%u]\n",
+	      err, errno, retval, XDP_TX, size, exp_size);
+
+	free(buf);
+out:
+	bpf_object__close(obj);
+}
+
+void test_xdp_adjust_mb_tail_grow(void)
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
+	if (CHECK(!buf, "malloc()", "error:%s\n", strerror(errno)))
+		goto out;
+
+	/* Test case add 10 bytes to last frag */
+	memset(buf, 1, 16384);
+	size = 9000;
+	exp_size = size + 10;
+	err = bpf_prog_test_run(prog_fd, 1, buf, size,
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k+10b", "err %d retval %d[%d] size %d[%u]\n",
+	      err, retval, XDP_TX, size, exp_size);
+
+	for (i = 0; i < 9000; i++)
+		CHECK(buf[i] != 1, "9k+10b-old",
+		      "Old data not all ok, offset %i is failing [%u]!\n",
+		      i, buf[i]);
+
+	for (i = 9000; i < 9010; i++)
+		CHECK(buf[i] != 0, "9k+10b-new",
+		      "New data not all ok, offset %i is failing [%u]!\n",
+		      i, buf[i]);
+
+	for (i = 9010; i < 16384; i++)
+		CHECK(buf[i] != 1, "9k+10b-untouched",
+		      "Unused data not all ok, offset %i is failing [%u]!\n",
+		      i, buf[i]);
+
+	/* Test a too large grow */
+	memset(buf, 1, 16384);
+	size = 9001;
+	exp_size = size;
+	err = bpf_prog_test_run(prog_fd, 1, buf, size,
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_DROP || size != exp_size,
+	      "9k+10b", "err %d retval %d[%d] size %d[%u]\n",
+	      err, retval, XDP_TX, size, exp_size);
+
+	free(buf);
+out:
+	bpf_object__close(obj);
+}
+
 void test_xdp_adjust_tail(void)
 {
 	if (test__start_subtest("xdp_adjust_tail_shrink"))
@@ -138,4 +265,8 @@ void test_xdp_adjust_tail(void)
 		test_xdp_adjust_tail_grow();
 	if (test__start_subtest("xdp_adjust_tail_grow2"))
 		test_xdp_adjust_tail_grow2();
+	if (test__start_subtest("xdp_adjust_mb_tail_shrink"))
+		test_xdp_adjust_mb_tail_shrink();
+	if (test__start_subtest("xdp_adjust_mb_tail_grow"))
+		test_xdp_adjust_mb_tail_grow();
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
index b7448253d135..eeff48997b6e 100644
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
+		/* Multi-buffer test cases */
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
2.33.1

