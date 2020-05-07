Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5041C9992
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgEGSqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEGSqc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 14:46:32 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 159D8216FD;
        Thu,  7 May 2020 18:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588877192;
        bh=8VacPoTbGjqVXDTwPuYe3Mg/26pmSYjPzGz8cwswqJk=;
        h=Date:From:To:Cc:Subject:From;
        b=DedEP2mq6qrgUzakngn8r7xcVr2pM0OAetbvOrCdCURunFj9j6oKw6liEDu3jaFMc
         7Xi0YhSgFEwnnm2wNZpibhKLlRtWfnsmN9RgFbAaOfIB7lBjmh46w4XTWJGbyCuAMb
         OS8MV6bw4czSSQxV0exZm1/fIuoApmNvHSn2tSlY=
Date:   Thu, 7 May 2020 13:50:57 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libbpf: Replace zero-length array with flexible-array
Message-ID: <20200507185057.GA13981@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 kernel/bpf/queue_stack_maps.c                        |    2 +-
 tools/lib/bpf/libbpf.c                               |    2 +-
 tools/lib/bpf/libbpf_internal.h                      |    2 +-
 tools/testing/selftests/bpf/progs/core_reloc_types.h |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.c
index f697647ceb54..30e1373fd437 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -19,7 +19,7 @@ struct bpf_queue_stack {
 	u32 head, tail;
 	u32 size; /* max_entries + 1 */
 
-	char elements[0] __aligned(8);
+	char elements[] __aligned(8);
 };
 
 static struct bpf_queue_stack *bpf_queue_stack(struct bpf_map *map)
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 8f480e29a6b0..b9335c686353 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8035,7 +8035,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 struct perf_sample_raw {
 	struct perf_event_header header;
 	uint32_t size;
-	char data[0];
+	char data[];
 };
 
 struct perf_sample_lost {
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 8c3afbd97747..50d70e90d5f1 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -153,7 +153,7 @@ struct btf_ext_info_sec {
 	__u32	sec_name_off;
 	__u32	num_info;
 	/* Followed by num_info * record_size number of bytes */
-	__u8	data[0];
+	__u8	data[];
 };
 
 /* The minimum bpf_func_info checked by the loader */
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index 6d598cfbdb3e..34d84717c946 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -379,7 +379,7 @@ struct core_reloc_arrays___equiv_zero_sz_arr {
 	struct core_reloc_arrays_substruct c[3];
 	struct core_reloc_arrays_substruct d[1][2];
 	/* equivalent to flexible array */
-	struct core_reloc_arrays_substruct f[0][2];
+	struct core_reloc_arrays_substruct f[][2];
 };
 
 struct core_reloc_arrays___fixed_arr {

