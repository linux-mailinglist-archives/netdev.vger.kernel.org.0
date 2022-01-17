Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18C2490F97
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbiAQRap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbiAQRai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:30:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09755C061751;
        Mon, 17 Jan 2022 09:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DF14B81136;
        Mon, 17 Jan 2022 17:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772F6C36AE3;
        Mon, 17 Jan 2022 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440625;
        bh=VbRrcJzsRvwtgGIMh/nwA0SnypdDYitIgiXFzoqAHfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjcsR2KqkPZw2NAuvyQDK67f6yQ4XnRLd/yZZ6HLz9jXp9Ld6ZKdwi3XHO39TH8MK
         waRIv5N2fKtfb/UF40ZTjs5nxx/cNyNZcEgnM72WfbfU1qudZj345BeXugZ7yzV+Bw
         nkScxccbrqvqbuETpxZGIDRFnnmYFQOMew+Yc6zADeeqhxZPm5JmwVvXroEY5VDbBj
         JhQedUeDVTxAi50T1WlhdqIxYUrCsdvEjJvVa7g/qQPooGGc1woTmrExiOOQd0lMox
         LfGzf9ExQ+u32aioaUUv+9KU+cN0D48NIszqGFzqSlbzBRDQTgijjKP+MBQLxsW0C+
         N6DRvIGkb7EQA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 17/23] bpf: selftests: update xdp_adjust_tail selftest to include multi-frags
Date:   Mon, 17 Jan 2022 18:28:29 +0100
Message-Id: <f7d7d5ba9c132be0dbbebe3a2e4c2377ffa05834.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>

This change adds test cases for the multi-frags scenarios when shrinking
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
index 3f5a17c38be5..c38be5155afa 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -130,6 +130,133 @@ static void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
+void test_xdp_adjust_multi_frags_tail_shrink(void)
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
+	/* Test case removing two pages resulting in a linear xdp_buff */
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
+void test_xdp_adjust_multi_frags_tail_grow(void)
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
+	if (test__start_subtest("xdp_adjust_multi_frags_tail_shrink"))
+		test_xdp_adjust_multi_frags_tail_shrink();
+	if (test__start_subtest("xdp_adjust_multi_frags_tail_grow"))
+		test_xdp_adjust_multi_frags_tail_grow();
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
index b7448253d135..46bd74aa647f 100644
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
+		/* Multi-frags test cases */
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

