Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78A23F1D8
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgHGRUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:20:33 -0400
Received: from foss.arm.com ([217.140.110.172]:60146 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725900AbgHGRUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 13:20:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C8641FB;
        Fri,  7 Aug 2020 10:20:31 -0700 (PDT)
Received: from net-arm-thunderx2-02.shanghai.arm.com (net-arm-thunderx2-02.shanghai.arm.com [10.169.210.119])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A05A13F7D7;
        Fri,  7 Aug 2020 10:20:28 -0700 (PDT)
From:   Jianlin Lv <Jianlin.Lv@arm.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, Jianlin.Lv@arm.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next] bpf: fix segmentation fault of test_progs
Date:   Sat,  8 Aug 2020 01:20:16 +0800
Message-Id: <20200807172016.150952-1-Jianlin.Lv@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200731061600.18344-1-Jianlin.Lv@arm.com>
References: <20200731061600.18344-1-Jianlin.Lv@arm.com>
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

Another issue is that when unmap the second page fails, the length
parameter to delete tmp1 mappings should be 3*page_size.

Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
---
 tools/testing/selftests/bpf/prog_tests/mmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 43d0b5578f46..2070cfe19cac 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -192,7 +192,7 @@ void test_mmap(void)
 	/* unmap second page: pages 1, 3 mapped */
 	err = munmap(tmp1 + page_size, page_size);
 	if (CHECK(err, "adv_mmap2", "errno %d\n", errno)) {
-		munmap(tmp1, map_sz);
+		munmap(tmp1, 3 * page_size);
 		goto cleanup;
 	}
 
@@ -207,8 +207,8 @@ void test_mmap(void)
 	CHECK(tmp1 + page_size != tmp2, "adv_mmap4",
 	      "tmp1: %p, tmp2: %p\n", tmp1, tmp2);
 
-	/* re-map all 4 pages */
-	tmp2 = mmap(tmp1, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
+	/* re-map all 3 pages */
+	tmp2 = mmap(tmp1, 3 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
 		    data_map_fd, 0);
 	if (CHECK(tmp2 == MAP_FAILED, "adv_mmap5", "errno %d\n", errno)) {
 		munmap(tmp1, 3 * page_size); /* unmap page 1 */
@@ -226,7 +226,7 @@ void test_mmap(void)
 	CHECK_FAIL(map_data->val[2] != 321);
 	CHECK_FAIL(map_data->val[far] != 3 * 321);
 
-	munmap(tmp2, 4 * page_size);
+	munmap(tmp2, 3 * page_size);
 
 	/* map all 4 pages, but with pg_off=1 page, should fail */
 	tmp1 = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
-- 
2.17.1

