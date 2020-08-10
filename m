Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F246A240A4E
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 17:40:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgHJPkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 11:40:33 -0400
Received: from foss.arm.com ([217.140.110.172]:57722 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728755AbgHJPk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 11:40:29 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97B201063;
        Mon, 10 Aug 2020 08:40:28 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BC74B3F575;
        Mon, 10 Aug 2020 08:40:25 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, Jianlin.Lv@arm.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v2] bpf: fix segmentation fault of test_progs
Date:   Mon, 10 Aug 2020 23:39:40 +0800
Message-Id: <20200810153940.125508-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807172016.150952-1-Jianlin.Lv@arm.com>
References: <20200807172016.150952-1-Jianlin.Lv@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_progs reports the segmentation fault as below

$ sudo ./test_progs -t mmap --verbose
test_mmap:PASS:skel_open_and_load 0 nsec
......
test_mmap:PASS:adv_mmap1 0 nsec
test_mmap:PASS:adv_mmap2 0 nsec
test_mmap:PASS:adv_mmap3 0 nsec
test_mmap:PASS:adv_mmap4 0 nsec
Segmentation fault

This issue was triggered because mmap() and munmap() used inconsistent
length parameters; mmap() creates a new mapping of 3*page_size, but the
length parameter set in the subsequent re-map and munmap() functions is
4*page_size; this leads to the destruction of the process space.

To fix this issue, first create 4 pages of anonymous mapping,then do all
the mmap() with MAP_FIXED.

Another issue is that when unmap the second page fails, the length
parameter to delete tmp1 mappings should be 4*page_size.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
v2:
- Update commit messages
- Create 4 pages of anonymous mapping that serve the subsequent mmap()
---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 43d0b5578f46..9c3c5c0f068f 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -21,7 +21,7 @@ void test_mmap(void)
 	const long page_size = sysconf(_SC_PAGE_SIZE);
 	int err, duration = 0, i, data_map_fd, data_map_id, tmp_fd, rdmap_fd;
 	struct bpf_map *data_map, *bss_map;
-	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp1, *tmp2;
+	void *bss_mmaped = NULL, *map_mmaped = NULL, *tmp0, *tmp1, *tmp2;
 	struct test_mmap__bss *bss_data;
 	struct bpf_map_info map_info;
 	__u32 map_info_sz = sizeof(map_info);
@@ -183,16 +183,23 @@ void test_mmap(void)
 
 	/* check some more advanced mmap() manipulations */
 
+	tmp0 = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_ANONYMOUS,
+			  -1, 0);
+	if (CHECK(tmp0 == MAP_FAILED, "adv_mmap0", "errno %d\n", errno))
+		goto cleanup;
+
 	/* map all but last page: pages 1-3 mapped */
-	tmp1 = mmap(NULL, 3 * page_size, PROT_READ, MAP_SHARED,
+	tmp1 = mmap(tmp0, 3 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
 			  data_map_fd, 0);
-	if (CHECK(tmp1 == MAP_FAILED, "adv_mmap1", "errno %d\n", errno))
+	if (CHECK(tmp0 != tmp1, "adv_mmap1", "tmp0: %p, tmp1: %p\n", tmp0, tmp1)) {
+		munmap(tmp0, 4 * page_size);
 		goto cleanup;
+	}
 
 	/* unmap second page: pages 1, 3 mapped */
 	err = munmap(tmp1 + page_size, page_size);
 	if (CHECK(err, "adv_mmap2", "errno %d\n", errno)) {
-		munmap(tmp1, map_sz);
+		munmap(tmp1, 4 * page_size);
 		goto cleanup;
 	}
 
@@ -201,7 +208,7 @@ void test_mmap(void)
 		    MAP_SHARED | MAP_FIXED, data_map_fd, 0);
 	if (CHECK(tmp2 == MAP_FAILED, "adv_mmap3", "errno %d\n", errno)) {
 		munmap(tmp1, page_size);
-		munmap(tmp1 + 2*page_size, page_size);
+		munmap(tmp1 + 2*page_size, 2 * page_size);
 		goto cleanup;
 	}
 	CHECK(tmp1 + page_size != tmp2, "adv_mmap4",
@@ -211,7 +218,7 @@ void test_mmap(void)
 	tmp2 = mmap(tmp1, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
 		    data_map_fd, 0);
 	if (CHECK(tmp2 == MAP_FAILED, "adv_mmap5", "errno %d\n", errno)) {
-		munmap(tmp1, 3 * page_size); /* unmap page 1 */
+		munmap(tmp1, 4 * page_size); /* unmap page 1 */
 		goto cleanup;
 	}
 	CHECK(tmp1 != tmp2, "adv_mmap6", "tmp1: %p, tmp2: %p\n", tmp1, tmp2);
-- 
2.17.1

