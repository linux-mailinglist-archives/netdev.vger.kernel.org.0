Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6271534281D
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhCSVtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230435AbhCSVsv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:48:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E0F61981;
        Fri, 19 Mar 2021 21:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190530;
        bh=7rAvZGMahdh7X616sOsJRHk3+fsB8FFlsd9SKvcSRbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFrTtv61jkS9EutAZHXLdZFiY3uvdUQTjklN4zz9cfJjA3qLzzo9lq0d5GeynwLhI
         Ood3YO2JwactDw1oeE/OMDp2+S16m29B9ZKGLmcGPPxjh8WmVov/EGvRMVZ0Cmii7c
         Q0PJDKsPdpHKjW6HW2iLZJ8P8MZAokLErJLptNklLGYhjuXGkR1xnptiJfiRLyGniE
         DMiVry0RudTiFfmROz2Thibg1Icru5qzSTuaVWhemFI/k4gLAFyMscDpT1q7MJdg15
         jjhNHj3BrI3a3+IC0Ffuiw3K0tqsARYkuNkxXsiIuHQmxPvugz36XszBI1CIM48Tmc
         D/NVIOmVOAGvg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v7 bpf-next 14/14] bpf: update xdp_adjust_tail selftest to include multi-buffer
Date:   Fri, 19 Mar 2021 22:47:28 +0100
Message-Id: <f23fddd58b667a016a329e84b6227ddb231d06f7.1616179034.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616179034.git.lorenzo@kernel.org>
References: <cover.1616179034.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds test cases for the multi-buffer scenarios when shrinking
and growing.

Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++++++++++
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  16 +--
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 +++++-
 3 files changed, 142 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index d5c98f2cb12f..b936beaba797 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -130,6 +130,107 @@ void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
+void test_xdp_adjust_mb_tail_shrink(void)
+{
+	const char *file = "./test_xdp_adjust_tail_shrink.o";
+	__u32 duration, retval, size, exp_size;
+	struct bpf_object *obj;
+	static char buf[9000];
+	int err, prog_fd;
+
+	/* For the individual test cases, the first byte in the packet
+	 * indicates which test will be run.
+	 */
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	/* Test case removing 10 bytes from last frag, NOT freeing it */
+	buf[0] = 0;
+	exp_size = sizeof(buf) - 10;
+	err = bpf_prog_test_run(prog_fd, 1, buf, sizeof(buf),
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k-10b", "err %d errno %d retval %d[%d] size %d[%u]\n",
+	      err, errno, retval, XDP_TX, size, exp_size);
+
+	/* Test case removing one of two pages, assuming 4K pages */
+	buf[0] = 1;
+	exp_size = sizeof(buf) - 4100;
+	err = bpf_prog_test_run(prog_fd, 1, buf, sizeof(buf),
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k-1p", "err %d errno %d retval %d[%d] size %d[%u]\n",
+	      err, errno, retval, XDP_TX, size, exp_size);
+
+	/* Test case removing two pages resulting in a non mb xdp_buff */
+	buf[0] = 2;
+	exp_size = sizeof(buf) - 8200;
+	err = bpf_prog_test_run(prog_fd, 1, buf, sizeof(buf),
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_TX || size != exp_size,
+	      "9k-2p", "err %d errno %d retval %d[%d] size %d[%u]\n",
+	      err, errno, retval, XDP_TX, size, exp_size);
+
+	bpf_object__close(obj);
+}
+
+void test_xdp_adjust_mb_tail_grow(void)
+{
+	const char *file = "./test_xdp_adjust_tail_grow.o";
+	__u32 duration, retval, size, exp_size;
+	static char buf[16384];
+	struct bpf_object *obj;
+	int err, i, prog_fd;
+
+	err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
+	if (CHECK_FAIL(err))
+		return;
+
+	/* Test case add 10 bytes to last frag */
+	memset(buf, 1, sizeof(buf));
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
+	for (i = 9010; i < sizeof(buf); i++)
+		CHECK(buf[i] != 1, "9k+10b-untouched",
+		      "Unused data not all ok, offset %i is failing [%u]!\n",
+		      i, buf[i]);
+
+	/* Test a too large grow */
+	memset(buf, 1, sizeof(buf));
+	size = 9001;
+	exp_size = size;
+	err = bpf_prog_test_run(prog_fd, 1, buf, size,
+				buf, &size, &retval, &duration);
+
+	CHECK(err || retval != XDP_DROP || size != exp_size,
+	      "9k+10b", "err %d retval %d[%d] size %d[%u]\n",
+	      err, retval, XDP_TX, size, exp_size);
+
+	bpf_object__close(obj);
+}
+
 void test_xdp_adjust_tail(void)
 {
 	if (test__start_subtest("xdp_adjust_tail_shrink"))
@@ -138,4 +239,8 @@ void test_xdp_adjust_tail(void)
 		test_xdp_adjust_tail_grow();
 	if (test__start_subtest("xdp_adjust_tail_grow2"))
 		test_xdp_adjust_tail_grow2();
+	if (test__start_subtest("xdp_adjust_mb_tail_shrink"))
+		test_xdp_adjust_mb_tail_shrink();
+	if (test__start_subtest("xdp_adjust_mb_tail_grow"))
+		test_xdp_adjust_mb_tail_grow();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
index 3d66599eee2e..25ac7108a53f 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
@@ -7,20 +7,22 @@ int _xdp_adjust_tail_grow(struct xdp_md *xdp)
 {
 	void *data_end = (void *)(long)xdp->data_end;
 	void *data = (void *)(long)xdp->data;
-	unsigned int data_len;
 	int offset = 0;
 
 	/* Data length determine test case */
-	data_len = data_end - data;
 
-	if (data_len == 54) { /* sizeof(pkt_v4) */
+	if (xdp->frame_length == 54) { /* sizeof(pkt_v4) */
 		offset = 4096; /* test too large offset */
-	} else if (data_len == 74) { /* sizeof(pkt_v6) */
+	} else if (xdp->frame_length == 74) { /* sizeof(pkt_v6) */
 		offset = 40;
-	} else if (data_len == 64) {
+	} else if (xdp->frame_length == 64) {
 		offset = 128;
-	} else if (data_len == 128) {
-		offset = 4096 - 256 - 320 - data_len; /* Max tail grow 3520 */
+	} else if (xdp->frame_length == 128) {
+		offset = 4096 - 256 - 320 - xdp->frame_length; /* Max tail grow 3520 */
+	} else if (xdp->frame_length == 9000) {
+		offset = 10;
+	} else if (xdp->frame_length == 9001) {
+		offset = 4096;
 	} else {
 		return XDP_ABORTED; /* No matching test */
 	}
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
index 22065a9cfb25..689450414d29 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_shrink.c
@@ -14,14 +14,38 @@ int _version SEC("version") = 1;
 SEC("xdp_adjust_tail_shrink")
 int _xdp_adjust_tail_shrink(struct xdp_md *xdp)
 {
-	void *data_end = (void *)(long)xdp->data_end;
-	void *data = (void *)(long)xdp->data;
+	__u8 *data_end = (void *)(long)xdp->data_end;
+	__u8 *data = (void *)(long)xdp->data;
 	int offset = 0;
 
-	if (data_end - data == 54) /* sizeof(pkt_v4) */
+	switch (xdp->frame_length) {
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
2.30.2

