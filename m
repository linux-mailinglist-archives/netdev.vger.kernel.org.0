Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA274A9A7E
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 14:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbiBDN7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 08:59:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47246 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233765AbiBDN7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 08:59:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9999561CB7;
        Fri,  4 Feb 2022 13:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B122C004E1;
        Fri,  4 Feb 2022 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643983148;
        bh=X2dZPVwvDUfAvsvNReE1qUqwAF6LGrrmDLNy0JI/Dlc=;
        h=From:To:Cc:Subject:Date:From;
        b=ay6KlxDzbyGb1zegUcSknDc/ax+VYjqsHMbzUzAUjCHus45A8Fvzned8VXNAPf2Sb
         1X4NtdoOCPGr5fTJccsJigbOehzJzY/RdSVrLTrRx8iIZ6kzad6k89+8+ERC8A/7lQ
         JbiVqJlM0rsDAhK5OFcYrVyn9up+pV0GB2fGVZgQ4qFiCC1ERgnXVLTjh7TKTR0Y2H
         5mVmuDs+07v5P3hZbaBEtZGWPc1UTJYF/hFe+vH0ABRubNEX7hH4d0CYW8MaI5p5XZ
         sSPsMk3LA1CTpzTKzE9BsqF3Yp5/67GvU8D2ACzMNgHEFNMdrVMDKkZOPVzYXeuxAa
         PJmrflclJVFzg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, lorenzo.bianconi@redhat.com, andrii@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next] selftest/bpf: check invalid length in test_xdp_update_frags
Date:   Fri,  4 Feb 2022 14:58:44 +0100
Message-Id: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update test_xdp_update_frags adding a test for a buffer size
set to (MAX_SKB_FRAGS + 2) * PAGE_SIZE. The kernel is supposed
to return -ENOMEM.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../bpf/prog_tests/xdp_adjust_frags.c         | 37 ++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
index 134d0ac32f59..61d5b585eb15 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -5,11 +5,12 @@
 void test_xdp_update_frags(void)
 {
 	const char *file = "./test_xdp_update_frags.o";
+	int err, prog_fd, max_skb_frags, buf_size, num;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
-	int err, prog_fd;
 	__u32 *offset;
 	__u8 *buf;
+	FILE *f;
 	LIBBPF_OPTS(bpf_test_run_opts, topts);
 
 	obj = bpf_object__open(file);
@@ -99,6 +100,40 @@ void test_xdp_update_frags(void)
 	ASSERT_EQ(buf[7621], 0xbb, "xdp_update_frag buf[7621]");
 
 	free(buf);
+
+	/* test_xdp_update_frags: unsupported buffer size */
+	f = fopen("/proc/sys/net/core/max_skb_frags", "r");
+	if (!ASSERT_OK_PTR(f, "max_skb_frag file pointer"))
+		goto out;
+
+	num = fscanf(f, "%d", &max_skb_frags);
+	fclose(f);
+
+	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
+		goto out;
+
+	/* xdp_buff linear area size is always set to 4096 in the
+	 * bpf_prog_test_run_xdp routine.
+	 */
+	buf_size = 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_SIZE);
+	buf = malloc(buf_size);
+	if (!ASSERT_OK_PTR(buf, "alloc buf"))
+		goto out;
+
+	memset(buf, 0, buf_size);
+	offset = (__u32 *)buf;
+	*offset = 16;
+	buf[*offset] = 0xaa;
+	buf[*offset + 15] = 0xaa;
+
+	topts.data_in = buf;
+	topts.data_out = buf;
+	topts.data_size_in = buf_size;
+	topts.data_size_out = buf_size;
+
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
+	free(buf);
 out:
 	bpf_object__close(obj);
 }
-- 
2.34.1

