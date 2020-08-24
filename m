Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0739250539
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgHXRMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728382AbgHXQhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:37:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D3B22D3E;
        Mon, 24 Aug 2020 16:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287021;
        bh=TYTTdCegp15oLYrWq/F7PP5Ab8BnxcWk62tjoSVlprc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMsL5rRmqDybtENNNmFKjsGU7HxASjVgAG0+owzOqM96SJmLfkUTAzCTOWiigS+be
         iZI5x0IN91FTDRxqpzog3Z8gl0fhwE58JXO0ev52TWAeOa0fTj8WRY03ZtV3zP10E1
         fvX+PDkQvMen7aE1Oiu+7g8Osk7FJ2+Ux7MgeVko=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianlin Lv <Jianlin.Lv@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 20/54] selftests/bpf: Fix segmentation fault in test_progs
Date:   Mon, 24 Aug 2020 12:35:59 -0400
Message-Id: <20200824163634.606093-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianlin Lv <Jianlin.Lv@arm.com>

[ Upstream commit 0390c429dbed4068bd2cd8dded937d9a5ec24cd2 ]

test_progs reports the segmentation fault as below:

  $ sudo ./test_progs -t mmap --verbose
  test_mmap:PASS:skel_open_and_load 0 nsec
  [...]
  test_mmap:PASS:adv_mmap1 0 nsec
  test_mmap:PASS:adv_mmap2 0 nsec
  test_mmap:PASS:adv_mmap3 0 nsec
  test_mmap:PASS:adv_mmap4 0 nsec
  Segmentation fault

This issue was triggered because mmap() and munmap() used inconsistent
length parameters; mmap() creates a new mapping of 3 * page_size, but the
length parameter set in the subsequent re-map and munmap() functions is
4 * page_size; this leads to the destruction of the process space.

To fix this issue, first create 4 pages of anonymous mapping, then do all
the mmap() with MAP_FIXED.

Another issue is that when unmap the second page fails, the length
parameter to delete tmp1 mappings should be 4 * page_size.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200810153940.125508-1-Jianlin.Lv@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 43d0b5578f461..9c3c5c0f068fb 100644
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
2.25.1

