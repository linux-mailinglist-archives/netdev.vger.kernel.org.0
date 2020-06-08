Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB841F2E89
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729086AbgFHXMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728384AbgFHXMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C7C1212CC;
        Mon,  8 Jun 2020 23:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657940;
        bh=52liZxWS/YVroA/0/89/gMuhBgSh5CrWsVrWvpMtxo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDwlKid4kRMpQBoMqO5E0dhfpM2WucrsJdCMZSl2gmfXwr4Qck+ua9JJor+CEFOWG
         kX/FZp20iu9P2XerocXebmYl3jWbHVWPGLvxZ3GW+K+2gf1EhkxP/CWbDNsI7S/Gyd
         FbXoh99o0Mjt2LgjSMFSOXdI7HKu1neJNUvOLtXQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 006/606] bpf: Fix bug in mmap() implementation for BPF array map
Date:   Mon,  8 Jun 2020 19:02:11 -0400
Message-Id: <20200608231211.3363633-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Upstream commit 333291ce5055f2039afc907badaf5b66bc1adfdc ]

mmap() subsystem allows user-space application to memory-map region with
initial page offset. This wasn't taken into account in initial implementation
of BPF array memory-mapping. This would result in wrong pages, not taking into
account requested page shift, being memory-mmaped into user-space. This patch
fixes this gap and adds a test for such scenario.

Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20200512235925.3817805-1-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/arraymap.c                         | 7 ++++++-
 tools/testing/selftests/bpf/prog_tests/mmap.c | 9 +++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 95d77770353c..1d6120fd5ba6 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -486,7 +486,12 @@ static int array_map_mmap(struct bpf_map *map, struct vm_area_struct *vma)
 	if (!(map->map_flags & BPF_F_MMAPABLE))
 		return -EINVAL;
 
-	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array), pgoff);
+	if (vma->vm_pgoff * PAGE_SIZE + (vma->vm_end - vma->vm_start) >
+	    PAGE_ALIGN((u64)array->map.max_entries * array->elem_size))
+		return -EINVAL;
+
+	return remap_vmalloc_range(vma, array_map_vmalloc_addr(array),
+				   vma->vm_pgoff + pgoff);
 }
 
 const struct bpf_map_ops array_map_ops = {
diff --git a/tools/testing/selftests/bpf/prog_tests/mmap.c b/tools/testing/selftests/bpf/prog_tests/mmap.c
index 16a814eb4d64..b0e789678aa4 100644
--- a/tools/testing/selftests/bpf/prog_tests/mmap.c
+++ b/tools/testing/selftests/bpf/prog_tests/mmap.c
@@ -197,6 +197,15 @@ void test_mmap(void)
 	CHECK_FAIL(map_data->val[far] != 3 * 321);
 
 	munmap(tmp2, 4 * page_size);
+
+	/* map all 4 pages, but with pg_off=1 page, should fail */
+	tmp1 = mmap(NULL, 4 * page_size, PROT_READ, MAP_SHARED | MAP_FIXED,
+		    data_map_fd, page_size /* initial page shift */);
+	if (CHECK(tmp1 != MAP_FAILED, "adv_mmap7", "unexpected success")) {
+		munmap(tmp1, 4 * page_size);
+		goto cleanup;
+	}
+
 cleanup:
 	if (bss_mmaped)
 		CHECK_FAIL(munmap(bss_mmaped, bss_sz));
-- 
2.25.1

