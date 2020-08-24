Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6CB250600
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHXRZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgHXQfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97BC922CBB;
        Mon, 24 Aug 2020 16:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286941;
        bh=4YAmf4dSSuVzZiazHPkKQCjkpbtJsu85PXPDdQOTguM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q75rnpUBNTBW4jlA+DA7AJ68KZfchfqlWzcbkUboDBYbSjbAjd/bJmygr5xcr2ik9
         ZopX1+bAO1EhZ3HSVwTeelaxM9NvzX8wcyrQjKzAnaaOne8xeFj3EWdpwKMtgIZlJm
         dYUYOb9gRoy18NnV2uDwowzA7Uv9vVuuNA5LqjDs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 27/63] selftests/bpf: Fix btf_dump test cases on 32-bit arches
Date:   Mon, 24 Aug 2020 12:34:27 -0400
Message-Id: <20200824163504.605538-27-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit eed7818adf03e874994b966aa33bc00204dd275a ]

Fix btf_dump test cases by hard-coding BPF's pointer size of 8 bytes for cases
where it's impossible to deterimne the pointer size (no long type in BTF). In
cases where it's known, validate libbpf correctly determines it as 8.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200813204945.1020225-6-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/btf_dump.c       | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index cb33a7ee4e04f..39fb81d9daeb5 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -12,15 +12,16 @@ void btf_dump_printf(void *ctx, const char *fmt, va_list args)
 static struct btf_dump_test_case {
 	const char *name;
 	const char *file;
+	bool known_ptr_sz;
 	struct btf_dump_opts opts;
 } btf_dump_test_cases[] = {
-	{"btf_dump: syntax", "btf_dump_test_case_syntax", {}},
-	{"btf_dump: ordering", "btf_dump_test_case_ordering", {}},
-	{"btf_dump: padding", "btf_dump_test_case_padding", {}},
-	{"btf_dump: packing", "btf_dump_test_case_packing", {}},
-	{"btf_dump: bitfields", "btf_dump_test_case_bitfields", {}},
-	{"btf_dump: multidim", "btf_dump_test_case_multidim", {}},
-	{"btf_dump: namespacing", "btf_dump_test_case_namespacing", {}},
+	{"btf_dump: syntax", "btf_dump_test_case_syntax", true, {}},
+	{"btf_dump: ordering", "btf_dump_test_case_ordering", false, {}},
+	{"btf_dump: padding", "btf_dump_test_case_padding", true, {}},
+	{"btf_dump: packing", "btf_dump_test_case_packing", true, {}},
+	{"btf_dump: bitfields", "btf_dump_test_case_bitfields", true, {}},
+	{"btf_dump: multidim", "btf_dump_test_case_multidim", false, {}},
+	{"btf_dump: namespacing", "btf_dump_test_case_namespacing", false, {}},
 };
 
 static int btf_dump_all_types(const struct btf *btf,
@@ -62,6 +63,18 @@ static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
 		goto done;
 	}
 
+	/* tests with t->known_ptr_sz have no "long" or "unsigned long" type,
+	 * so it's impossible to determine correct pointer size; but if they
+	 * do, it should be 8 regardless of host architecture, becaues BPF
+	 * target is always 64-bit
+	 */
+	if (!t->known_ptr_sz) {
+		btf__set_pointer_size(btf, 8);
+	} else {
+		CHECK(btf__pointer_size(btf) != 8, "ptr_sz", "exp %d, got %zu\n",
+		      8, btf__pointer_size(btf));
+	}
+
 	snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX", t->file);
 	fd = mkstemp(out_file);
 	if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n", fd)) {
-- 
2.25.1

